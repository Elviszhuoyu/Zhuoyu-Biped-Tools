
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$source = Join-Path $PSScriptRoot 'BipedTools\src'
$manifest = [IO.File]::ReadAllText((Join-Path $source 'mzp.run'))
if ($manifest -notmatch '(?m)^run "install\.ms"\r?$' -or $manifest -notmatch '(?m)^drop "install\.ms"\r?$') {
    throw 'The MZP must declare both Run Script and drag-and-drop entry points.'
}

$installer = [IO.File]::ReadAllText((Join-Path $source 'install.ms'))
$fileList = [regex]::Match($installer, '(?s)for relative in #\((.*?)\) do')
$payload = @([regex]::Matches($fileList.Groups[1].Value, '@"([^"]+)"') | ForEach-Object {
    $_.Groups[1].Value.Replace('\', '/')
})
if ($payload.Count -eq 0 -or ($payload | Sort-Object -Unique).Count -ne $payload.Count) {
    throw 'The install manifest is empty or has duplicate paths.'
}

$outDir = Join-Path $PSScriptRoot 'dist'
[void][IO.Directory]::CreateDirectory($outDir)
$outFile = Join-Path $outDir 'Zhuoyu_BipedTools_1.9.9.mzp'
if (Test-Path -LiteralPath $outFile) { throw "Output already exists: $outFile" }

$legacyDll = Join-Path $source 'ZYNativeGroups.netfx.dll'
$modernDll = Join-Path $source 'ZYNativeGroups.net8.dll'
$compiler = Join-Path $env:WINDIR 'Microsoft.NET\Framework64\v4.0.30319\csc.exe'
& $compiler /nologo /target:library /optimize+ "/out:$legacyDll" /reference:System.dll /reference:System.Drawing.dll (Join-Path $source 'ZYNativeGroups.cs')
if ($LASTEXITCODE -ne 0) { throw '.NET Framework helper build failed.' }

$project = Join-Path $PSScriptRoot 'dev\net8-BipedTools\ZYNativeGroups.net8.csproj'
& dotnet build $project -c Release --nologo --ignore-failed-sources -p:NuGetAudit=false
if ($LASTEXITCODE -ne 0) { throw '.NET 8 helper build failed.' }
Copy-Item -LiteralPath (Join-Path (Split-Path $project) 'bin\Release\net8.0-windows\ZYNativeGroups.net8.dll') -Destination $modernDll -Force

$tempFile = Join-Path $outDir ([Guid]::NewGuid().ToString() + '.tmp')
try {
    $package = [IO.Compression.ZipFile]::Open($tempFile, [IO.Compression.ZipArchiveMode]::Create)
    try {
        foreach ($name in @('mzp.run', 'install.ms')) {
            [void][IO.Compression.ZipFileExtensions]::CreateEntryFromFile($package, (Join-Path $source $name), $name)
        }
        foreach ($name in ($payload + 'ZhuoyuBipedTools_Startup.ms')) {
            [void][IO.Compression.ZipFileExtensions]::CreateEntryFromFile($package, (Join-Path $source $name), "payload/$name")
        }
    } finally { $package.Dispose() }
    [IO.File]::Move($tempFile, $outFile)
} finally {
    if ([IO.File]::Exists($tempFile)) { [IO.File]::Delete($tempFile) }
}

Get-FileHash -LiteralPath $outFile -Algorithm SHA256
