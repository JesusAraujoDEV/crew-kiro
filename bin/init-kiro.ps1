# Install or update crew-kiro for Kiro IDE.
# Workspace (recommended): .\init-kiro.ps1 [-Solo] [-Target C:\project]
# Global user profile:     .\init-kiro.ps1 -Global

[CmdletBinding()]
param(
  [switch]$Solo,
  [switch]$Global,
  [string]$Target = (Get-Location).Path
)

$ErrorActionPreference = "Stop"
$Mode = if ($Solo) { "solo" } else { "team" }
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$CrewRoot = Split-Path -Parent $ScriptDir

function Sync-File {
  param([string]$Source, [string]$Destination)
  $parent = Split-Path -Parent $Destination
  New-Item -ItemType Directory -Path $parent -Force | Out-Null
  Copy-Item -LiteralPath $Source -Destination $Destination -Force
  Write-Host "  synced: $Destination"
}

function Sync-Tree {
  param([string]$Source, [string]$Destination)
  Get-ChildItem -LiteralPath $Source -Recurse -File | ForEach-Object {
    $relative = $_.FullName.Substring($Source.Length).TrimStart("\", "/")
    Sync-File $_.FullName (Join-Path $Destination $relative)
  }
}

function Copy-IfMissing {
  param([string]$Source, [string]$Destination)
  if (Test-Path -LiteralPath $Destination) {
    Write-Host "  preserved: $Destination"
    return
  }
  Sync-File $Source $Destination
}

function Install-GlobalCrew {
  $KiroHome = if ($env:KIRO_HOME) { $env:KIRO_HOME } else { Join-Path $HOME ".kiro" }
  Write-Host "Installing crew-kiro globally into $KiroHome" -ForegroundColor Cyan

  Sync-File "$CrewRoot\.kiro\steering\crew-baseline.md" "$KiroHome\steering\crew-baseline.md"
  Sync-File "$CrewRoot\.kiro\steering\crew-roles.md" "$KiroHome\steering\crew-roles.md"
  Sync-Tree "$CrewRoot\.kiro\agents" "$KiroHome\agents"
  Sync-Tree "$CrewRoot\.kiro\skills" "$KiroHome\skills"
  Sync-Tree "$CrewRoot\agents" "$KiroHome\crew\agents"
  Sync-File "$CrewRoot\bin\metrics.js" "$KiroHome\crew\bin\metrics.js"

  Write-Host ""
  Write-Host "Global crew installed. Start a new Kiro session so agents and steering reload." -ForegroundColor Green
  Write-Host "Kiro will route ordinary requests automatically; selecting an agent explicitly is optional."
}

function Install-WorkspaceCrew {
  $resolvedTarget = (Resolve-Path -LiteralPath $Target).Path
  if ($resolvedTarget -eq $CrewRoot) {
    throw "Refusing to install the distributable into its own source repository. Use -Global or choose another -Target."
  }
  if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    throw "Node.js is required by crew's workspace hooks but was not found on PATH."
  }

  Write-Host "Installing crew-kiro into $resolvedTarget (mode: $Mode)" -ForegroundColor Cyan

  # Crew-managed Kiro assets converge on every run.
  Sync-File "$CrewRoot\.kiro\steering\crew-baseline.md" "$resolvedTarget\.kiro\steering\crew-baseline.md"
  Sync-File "$CrewRoot\.kiro\steering\crew-roles.md" "$resolvedTarget\.kiro\steering\crew-roles.md"
  Sync-Tree "$CrewRoot\.kiro\agents" "$resolvedTarget\.kiro\agents"
  Sync-Tree "$CrewRoot\.kiro\skills" "$resolvedTarget\.kiro\skills"
  Sync-Tree "$CrewRoot\.kiro\hooks" "$resolvedTarget\.kiro\hooks"
  Sync-Tree "$CrewRoot\agents" "$resolvedTarget\.kiro\crew\agents"
  Sync-File "$CrewRoot\bin\metrics.js" "$resolvedTarget\.kiro\crew\bin\metrics.js"

  Get-ChildItem "$CrewRoot\hooks\kiro-*.js" -File | ForEach-Object {
    Sync-File $_.FullName "$resolvedTarget\hooks\$($_.Name)"
  }
  foreach ($library in @("config.js", "ceilings.js", "kiro-input.js")) {
    Sync-File "$CrewRoot\hooks\lib\$library" "$resolvedTarget\hooks\lib\$library"
  }

  # Project-owned scaffold is never overwritten.
  $Templates = "$CrewRoot\templates"
  Copy-IfMissing "$Templates\standards\code-quality.md" "$resolvedTarget\standards\code-quality.md"
  Copy-IfMissing "$Templates\docs\decisions\README.md" "$resolvedTarget\docs\decisions\README.md"
  Copy-IfMissing "$Templates\docs\decisions\0000-template.md" "$resolvedTarget\docs\decisions\0000-template.md"
  Copy-IfMissing "$Templates\docs\work\README.md" "$resolvedTarget\docs\work\README.md"

  if ($Mode -eq "team") {
    foreach ($relative in @(
      "docs\INDEX.md",
      "docs\MAINTAINING.md",
      "docs\DEVIATIONS.md",
      "docs\briefs\README.md",
      "docs\stories\README.md",
      "docs\requirements\README.md",
      "docs\proposals\README.md",
      "docs\guides\delivery-circuit.md",
      "docs\guides\delivery-circuit.es.md"
    )) {
      $source = Join-Path $Templates $relative
      if (Test-Path -LiteralPath $source) {
        Copy-IfMissing $source (Join-Path $resolvedTarget $relative)
      }
    }
  }

  $crewConfig = Join-Path $resolvedTarget "crew.json"
  if (-not (Test-Path -LiteralPath $crewConfig)) {
    @"
{
  "mode": "$Mode",
  "metrics": true,
  "quality": "advise",
  "ceilings": {}
}
"@ | Set-Content -LiteralPath $crewConfig -Encoding utf8
    Write-Host "  created: $crewConfig"
  } else {
    Write-Host "  preserved: $crewConfig"
  }

  Write-Host ""
  Write-Host "Workspace crew installed. Open a new Kiro session to reload agents, steering, and hooks." -ForegroundColor Green
  Write-Host "Kiro now chooses the relevant crew roles automatically. Aliases remain optional overrides."
}

if ($Global) {
  if ($Solo) { Write-Warning "-Solo affects workspace process only and is ignored with -Global." }
  Install-GlobalCrew
} else {
  Install-WorkspaceCrew
}
