param([int]$MaxPid,[string]$SessionDir,[string]$MaxLog)
$ErrorActionPreference='Stop'
$logPath=Join-Path $SessionDir 'windows-input.jsonl'
$encoding=[System.Text.UTF8Encoding]::new($false)
function Write-Event([string]$Kind,$Data){
 $item=[ordered]@{utc=[DateTime]::UtcNow.ToString('o');kind=$Kind;data=$Data}
 [IO.File]::AppendAllText($logPath,(ConvertTo-Json -InputObject $item -Compress -Depth 8)+[Environment]::NewLine,$encoding)
}
function Get-LocalFileHash([string]$Path){
 $stream=[IO.File]::OpenRead($Path);$sha=[Security.Cryptography.SHA256]::Create()
 try{return ([BitConverter]::ToString($sha.ComputeHash($stream))).Replace('-','')}finally{$stream.Dispose();$sha.Dispose()}
}
function Copy-MaxLog([string]$Label){
 if($MaxLog -and (Test-Path -LiteralPath $MaxLog)){
  try{[IO.File]::Copy($MaxLog,(Join-Path $SessionDir ("Max-$Label.log")),$true)}catch{Write-Event 'maxlog_copy_failed' $_.Exception.Message}
 }
}
try{
 [IO.Directory]::CreateDirectory($SessionDir)|Out-Null
 Add-Type -TypeDefinition @"
using System;
using System.Text;
using System.Runtime.InteropServices;
public static class ZYMaxInput {
 [StructLayout(LayoutKind.Sequential)] public struct POINT { public int X; public int Y; }
 [DllImport("user32.dll")] public static extern short GetAsyncKeyState(int key);
 [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
 [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr hwnd,out uint pid);
 [DllImport("user32.dll")] public static extern bool GetCursorPos(out POINT p);
 [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr hwnd);
 [DllImport("user32.dll",CharSet=CharSet.Unicode)] public static extern int GetWindowText(IntPtr hwnd,StringBuilder text,int size);
 [DllImport("user32.dll",CharSet=CharSet.Unicode)] public static extern int GetClassName(IntPtr hwnd,StringBuilder text,int size);
 public delegate bool EnumProc(IntPtr hwnd,IntPtr data);
 [DllImport("user32.dll")] public static extern bool EnumWindows(EnumProc callback,IntPtr data);
 [DllImport("user32.dll")] public static extern bool EnumChildWindows(IntPtr hwnd,EnumProc callback,IntPtr data);
 public static string Text(IntPtr h){var b=new StringBuilder(4096);GetWindowText(h,b,b.Capacity);return b.ToString();}
 public static string Class(IntPtr h){var b=new StringBuilder(256);GetClassName(h,b,b.Capacity);return b.ToString();}
}
"@
 $maxProcess=[Diagnostics.Process]::GetProcessById($MaxPid)
 if($maxProcess.ProcessName -ne '3dsmax'){throw 'Only the selected 3dsmax process may be monitored.'}
 $began=Get-Date
 Write-Event 'watcher_start' @{pid=$MaxPid;process=$maxProcess.ProcessName;scope='Max foreground mouse and modifiers only; no typed text; no animation evaluation'}
 try{$maxProcess.Modules|ForEach-Object{[pscustomobject]@{name=$_.ModuleName;path=$_.FileName;version=$_.FileVersionInfo.FileVersion}}|ConvertTo-Json -Depth 4|Set-Content -LiteralPath (Join-Path $SessionDir 'loaded-modules.json') -Encoding UTF8}catch{Write-Event 'modules_unavailable' $_.Exception.Message}
 $metadata=[ordered]@{pid=$MaxPid;startedLocal=(Get-Date).ToString('o');os=[Environment]::OSVersion.VersionString;maxExecutable=$maxProcess.MainModule.FileName;maxFileVersion=$maxProcess.MainModule.FileVersionInfo.FileVersion;files=@()}
 $scriptCandidates=@((Join-Path $PSScriptRoot 'ZYTrail.ms'),(Join-Path $PSScriptRoot 'ZYLB\ZYLB_Core_zh.ms'),(Join-Path $PSScriptRoot 'ZYDiagnostics.ms'),(Join-Path ([IO.Path]::GetDirectoryName($maxProcess.MainModule.FileName)) 'scripts\BulletScripts\Quote\DTrajEdit.ms'),(Join-Path ([IO.Path]::GetDirectoryName($maxProcess.MainModule.FileName)) 'scripts\BulletScripts\Quote\DTrajEdit_New.ms'))
 foreach($candidate in $scriptCandidates){if(Test-Path -LiteralPath $candidate){$metadata.files+=@{path=$candidate;sha256=(Get-LocalFileHash $candidate)}}}
 try{$first=(Get-Content -LiteralPath (Join-Path $SessionDir 'maxscript.jsonl') -TotalCount 1 -Encoding UTF8)|ConvertFrom-Json;if(Test-Path -LiteralPath $first.scene){$metadata.scene=@{path=$first.scene;sha256=(Get-LocalFileHash $first.scene)}}}catch{}
 $metadata|ConvertTo-Json -Depth 6|Set-Content -LiteralPath (Join-Path $SessionDir 'environment.json') -Encoding UTF8
 Copy-MaxLog 'start' 
 [IO.File]::WriteAllText((Join-Path $SessionDir 'watcher.ready'),[DateTime]::UtcNow.ToString('o'),$encoding)
 $prevLeft=$false;$prevRight=$false;$prevMods='';$lastMove=Get-Date;$lastDialogs=Get-Date;$seenDialogs=@{}
 while(-not $maxProcess.HasExited -and -not (Test-Path -LiteralPath (Join-Path $SessionDir 'stop.signal'))){
  [uint32]$foregroundPid=0
  $foreground=[ZYMaxInput]::GetForegroundWindow();[void][ZYMaxInput]::GetWindowThreadProcessId($foreground,[ref]$foregroundPid)
  $left=([ZYMaxInput]::GetAsyncKeyState(1) -band 0x8000)-ne 0
  $right=([ZYMaxInput]::GetAsyncKeyState(2) -band 0x8000)-ne 0
  if($foregroundPid -eq $MaxPid){
   $point=New-Object ZYMaxInput+POINT;[void][ZYMaxInput]::GetCursorPos([ref]$point)
   $mods=@{shift=([ZYMaxInput]::GetAsyncKeyState(16)-band 0x8000)-ne 0;ctrl=([ZYMaxInput]::GetAsyncKeyState(17)-band 0x8000)-ne 0;alt=([ZYMaxInput]::GetAsyncKeyState(18)-band 0x8000)-ne 0}
   $state=@{x=$point.X;y=$point.Y;left=$left;right=$right;shift=$mods.shift;ctrl=$mods.ctrl;alt=$mods.alt;window=[ZYMaxInput]::Text($foreground)}
   if($left -ne $prevLeft -or $right -ne $prevRight){Write-Event 'mouse_button' $state}
   $modText="$($mods.shift),$($mods.ctrl),$($mods.alt)"
   if($modText -ne $prevMods){Write-Event 'modifiers' $state;$prevMods=$modText}
   if($left -and ((Get-Date)-$lastMove).TotalMilliseconds -ge 120){Write-Event 'drag_sample' $state;$lastMove=Get-Date}
  }
  $prevLeft=$left;$prevRight=$right
  if(((Get-Date)-$lastDialogs).TotalMilliseconds -ge 500){
   $script:dialogRecords=[Collections.Generic.List[object]]::new()
   $callback=[ZYMaxInput+EnumProc]{param($window,$data)
    [uint32]$ownerPid=0;[void][ZYMaxInput]::GetWindowThreadProcessId($window,[ref]$ownerPid)
    if($ownerPid -eq $MaxPid -and [ZYMaxInput]::IsWindowVisible($window)){
     $title=[ZYMaxInput]::Text($window)
     if($title -match 'MAXScript|Exception|Error|错误' -and $title -notmatch 'Editor|编辑器'){
      $script:dialogTexts=[Collections.Generic.List[string]]::new()
      [void][ZYMaxInput]::EnumChildWindows($window,[ZYMaxInput+EnumProc]{param($child,$p)
       if([ZYMaxInput]::Class($child) -match 'Static|Edit'){$t=[ZYMaxInput]::Text($child);if($t){$script:dialogTexts.Add($t)}}
       return $true
      },[IntPtr]::Zero)
      $script:dialogRecords.Add(@{title=$title;text=@($script:dialogTexts.ToArray())})
     }
    }
    return $true
   }
   [void][ZYMaxInput]::EnumWindows($callback,[IntPtr]::Zero)
   foreach($record in $script:dialogRecords){$signature=ConvertTo-Json $record -Compress -Depth 5;if(-not $seenDialogs.ContainsKey($signature)){Write-Event 'error_dialog_observed' $record;$seenDialogs[$signature]=$true}}
   $lastDialogs=Get-Date
  }
  Start-Sleep -Milliseconds 40
  $maxProcess.Refresh()
 }
 if($maxProcess.HasExited){
  Write-Event 'process_exit_observed' @{pid=$MaxPid;exitCode=$maxProcess.ExitCode;note='Exit alone does not prove a crash. Correlate Application Error event and dump.'}
  Start-Sleep -Milliseconds 800
  try{
   Import-Module (Join-Path $PSHOME "Modules\Microsoft.PowerShell.Diagnostics") -ErrorAction Stop
   $records=Get-WinEvent -FilterHashtable @{LogName='Application';Id=1000;StartTime=$began.AddSeconds(-2)} -ErrorAction Stop
   foreach($record in $records){
    [xml]$xml=$record.ToXml();$fields=@{};foreach($entry in $xml.Event.EventData.Data){$fields[$entry.Name]=$entry.'#text'}
    $eventPid=0;if($fields['ProcessId']){$raw=$fields['ProcessId'];$eventPid=if($raw -match '^0x'){[Convert]::ToInt32($raw.Substring(2),16)}else{[int]$raw}}
    if($eventPid -eq $MaxPid){Write-Event 'application_error_1000' $fields;[IO.File]::WriteAllText((Join-Path $SessionDir 'ApplicationError.xml'),$record.ToXml(),$encoding)}
   }
  }catch{Write-Event 'application_event_unavailable' $_.Exception.Message}
 }else{Write-Event 'watcher_stopped_by_user' @{pid=$MaxPid}}
 Copy-MaxLog 'end'
}catch{try{Write-Event 'watcher_error' $_.Exception.ToString()}catch{}}
