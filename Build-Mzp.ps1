[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string] $UpstreamMZP
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression.FileSystem

$source = Join-Path $PSScriptRoot 'BipedTools\src'
$originalPath = (Resolve-Path -LiteralPath $UpstreamMZP).ProviderPath
$originalHash = '5bfdc9ae404dda50740405d1eb54b3b9d42b7fd18bdcef87cf6f43c1e7363f70'
if ((Get-FileHash -LiteralPath $originalPath -Algorithm SHA256).Hash -ne $originalHash) {
    throw 'The input must be the original Biped Helper + Picker 3.5 MZP. Check the upstream link and hash in README.md.'
}

$legacyDll = Join-Path $source 'ZYNativeGroups.netfx.dll'
$modernDll = Join-Path $source 'ZYNativeGroups.net8.dll'
if (!(Test-Path -LiteralPath $legacyDll) -or !(Test-Path -LiteralPath $modernDll)) {
    $compiler = Join-Path $env:WINDIR 'Microsoft.NET\Framework64\v4.0.30319\csc.exe'
    & $compiler /nologo /target:library /optimize+ "/out:$legacyDll" /reference:System.dll /reference:System.Drawing.dll (Join-Path $source 'ZYNativeGroups.cs')
    if ($LASTEXITCODE -ne 0) { throw '.NET Framework helper build failed.' }

    $project = Join-Path $PSScriptRoot 'dev\net8-BipedTools\ZYNativeGroups.net8.csproj'
    & dotnet build $project -c Release --nologo --ignore-failed-sources -p:NuGetAudit=false
    if ($LASTEXITCODE -ne 0) { throw '.NET 8 helper build failed.' }
    Copy-Item -LiteralPath (Join-Path (Split-Path $project) 'bin\Release\net8.0-windows\ZYNativeGroups.net8.dll') -Destination $modernDll -Force
}

$installer = [IO.File]::ReadAllText((Join-Path $source 'install.ms'))
$fileList = [regex]::Match($installer, '(?s)for relative in #\((.*?)\) do')
$payload = @([regex]::Matches($fileList.Groups[1].Value, '@"([^"]+)"') | ForEach-Object {
    $_.Groups[1].Value.Replace('\', '/')
})
if ($payload.Count -ne 51 -or ($payload | Sort-Object -Unique).Count -ne $payload.Count) {
    throw 'Unexpected install manifest. Check that install.ms belongs to this release.'
}

$outDir = Join-Path $PSScriptRoot 'dist'
[void][IO.Directory]::CreateDirectory($outDir)
$outFile = Join-Path $outDir 'Zhuoyu_BipedTools_1.9.8.mzp'
if (Test-Path -LiteralPath $outFile) { throw "Output already exists: $outFile" }

$tempFile = Join-Path $outDir ([Guid]::NewGuid().ToString() + '.tmp')
$original = [IO.Compression.ZipFile]::OpenRead($originalPath)
try {
    $reader = [IO.StreamReader]::new($original.GetEntry('LBTools_Biped_Helper.ms').Open())
    try { $upstreamCore = $reader.ReadToEnd() } finally { $reader.Dispose() }

    $surfaceFunction = [regex]::Match($upstreamCore, '(?ms)^fn f_addTrajToBipedSurface obj[ \t]*=[ \t]*\r?\n.*?(?=^fn f_addTrajectoryHelper &pt)')
    if (!$surfaceFunction.Success) { throw 'Original trajectory helper was not found.' }
    $helper = $surfaceFunction.Value.Replace('g_LBTools_BH', 'g_ZYLB_BH')

    $package = [IO.Compression.ZipFile]::Open($tempFile, [IO.Compression.ZipArchiveMode]::Create)
    try {
        foreach ($entryName in @('mzp.run', 'install.ms') + @($payload + 'ZhuoyuBipedTools_Startup.ms' | ForEach-Object { "payload/$_" })) {
            $relative = $entryName -replace '^payload/', ''
            $sourceFile = Join-Path $source $relative
            if ($relative -match '^ZYLB/LBTools_.+\.(bmp|png)$') {
                $asset = $original.GetEntry([IO.Path]::GetFileName($relative))
                if (!$asset) { throw "Missing original asset: $relative" }
                $inputStream = $asset.Open()
                $outputStream = $package.CreateEntry($entryName).Open()
                try { $inputStream.CopyTo($outputStream) } finally { $outputStream.Dispose(); $inputStream.Dispose() }
            } elseif ($relative -match '^ZYLB/ZYLB_Core_(en|zh)\.ms$') {
                $template = [IO.File]::ReadAllText($sourceFile)
                $marker = [regex]::Match($template, '(?m)^-- @UPSTREAM_SURFACE_HELPER@\r?\n')
                if (!$marker.Success) { throw "Missing original helper marker: $relative" }
                $core = $template.Replace($marker.Value, $helper)
                $writer = [IO.StreamWriter]::new($package.CreateEntry($entryName).Open(), [Text.UTF8Encoding]::new($true))
                try { $writer.Write($core) } finally { $writer.Dispose() }
            } else {
                [void][IO.Compression.ZipFileExtensions]::CreateEntryFromFile($package, $sourceFile, $entryName)
            }
        }
    } finally { $package.Dispose() }

    [IO.File]::Move($tempFile, $outFile)
} finally {
    $original.Dispose()
    if ([IO.File]::Exists($tempFile)) { [IO.File]::Delete($tempFile) }
}

Get-FileHash -LiteralPath $outFile -Algorithm SHA256

