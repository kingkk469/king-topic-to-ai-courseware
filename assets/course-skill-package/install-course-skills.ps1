param(
    [switch]$Force,
    [string]$InstallRoot = (Join-Path $HOME ".codex\skills")
)

$ErrorActionPreference = "Stop"
$packageRoot = $PSScriptRoot
$installRootFull = [IO.Path]::GetFullPath($InstallRoot)
New-Item -ItemType Directory -Force -Path $installRootFull | Out-Null

$skillDirs = @(Get-ChildItem -LiteralPath $packageRoot -Directory | Where-Object {
    Test-Path -LiteralPath (Join-Path $_.FullName "SKILL.md")
})

if ($skillDirs.Count -eq 0) {
    throw "No skill folders containing SKILL.md were found."
}

$backupRoot = Join-Path (Join-Path $HOME ".codex\skill-backups") ("course-install-" + (Get-Date -Format "yyyyMMdd-HHmmss"))

foreach ($skillDir in $skillDirs) {
    $target = [IO.Path]::GetFullPath((Join-Path $installRootFull $skillDir.Name))
    $rootPrefix = $installRootFull.TrimEnd([IO.Path]::DirectorySeparatorChar) + [IO.Path]::DirectorySeparatorChar
    if (-not $target.StartsWith($rootPrefix, [StringComparison]::OrdinalIgnoreCase)) {
        throw "Unsafe install target: $target"
    }

    if (Test-Path -LiteralPath $target) {
        if (-not $Force) {
            Write-Output ("SKIP {0}: already exists" -f $skillDir.Name)
            continue
        }

        New-Item -ItemType Directory -Force -Path $backupRoot | Out-Null
        Move-Item -LiteralPath $target -Destination (Join-Path $backupRoot $skillDir.Name)
        Write-Output ("BACKUP {0}" -f $skillDir.Name)
    }

    Copy-Item -LiteralPath $skillDir.FullName -Destination $target -Recurse
    if (-not (Test-Path -LiteralPath (Join-Path $target "SKILL.md"))) {
        throw "Install validation failed: $target"
    }
    Write-Output ("INSTALLED {0}" -f $skillDir.Name)
}

Write-Output "Done. Reopen Codex before using the installed skills."
