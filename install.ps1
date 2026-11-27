param(
    [string]$RepoDir = $PSScriptRoot
)

$ErrorActionPreference = "Stop"

Write-Host "Gflow: instalando o agente e a pasta de saida."

$gflow = Get-Command gflow -ErrorAction SilentlyContinue
if (-not $gflow) {
    Write-Host "Erro: o CLI gflow nao esta instalado."
    Write-Host "Instale primeiro com: uv tool install gflow-cli"
    exit 1
}

# Pasta Downloads real do Windows, inclusive quando o OneDrive redireciona.
$downloads = $null
try {
    $shellFolders = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"
    $raw = $shellFolders.'{374DE290-123F-4565-9164-39C4925E467B}'
    if ($raw) {
        $downloads = [Environment]::ExpandEnvironmentVariables($raw)
    }
} catch {
    $downloads = $null
}
if (-not $downloads) {
    $downloads = Join-Path $HOME "Downloads"
}

$outDir = Join-Path $downloads "Flow"
foreach ($folder in @("images", "videos", "audio", "legendas", "montagens")) {
    New-Item -ItemType Directory -Force -Path (Join-Path $outDir $folder) | Out-Null
}

$gflowHome = Join-Path $env:LOCALAPPDATA "gflow-cli"
New-Item -ItemType Directory -Force -Path $gflowHome | Out-Null
$envFile = Join-Path $gflowHome ".env"
if (-not (Test-Path $envFile)) {
    New-Item -ItemType File -Force -Path $envFile | Out-Null
}

# Barra normal evita problema de escape no .env. O Windows aceita.
$envPath = $outDir -replace '\\', '/'
$lines = @(Get-Content -Path $envFile -ErrorAction SilentlyContinue)
$found = $false
$newLines = foreach ($line in $lines) {
    if ($line -match '^GFLOW_CLI_OUTPUT_DIR=') {
        $found = $true
        "GFLOW_CLI_OUTPUT_DIR=`"$envPath`""
    } else {
        $line
    }
}
if (-not $found) {
    $newLines = @($newLines) + "GFLOW_CLI_OUTPUT_DIR=`"$envPath`""
}
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllLines($envFile, [string[]]$newLines, $utf8NoBom)

$agentDir = Join-Path $HOME ".config\opencode\agents"
New-Item -ItemType Directory -Force -Path $agentDir | Out-Null
$agentFile = Join-Path $agentDir "gflow.md"
if (Test-Path $agentFile) {
    $stamp = Get-Date -Format "yyyyMMddHHmmss"
    $backup = "$agentFile.bak.$stamp"
    Copy-Item $agentFile $backup
    Write-Host "Agente antigo guardado em: $backup"
}
Copy-Item (Join-Path $RepoDir "opencode\agents\gflow.md") $agentFile -Force

Write-Host ""
Write-Host "Pronto."
Write-Host "Agente instalado em: $agentFile"
Write-Host "Saida configurada em: $outDir"
Write-Host ""
Write-Host "Agora faca o login uma vez, no terminal:"
Write-Host "  gflow auth login --browser chrome"
Write-Host ""
Write-Host "Depois abra o OpenCode e digite: gflow"
