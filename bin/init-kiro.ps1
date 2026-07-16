# Install crew-kiro into a target project's .kiro/ directory.
# Run from the root of your target project.
#
# Usage:
#   & "C:\path\to\crew-kiro\bin\init-kiro.ps1"          # team mode (full circuit)
#   & "C:\path\to\crew-kiro\bin\init-kiro.ps1" -Solo    # solo mode (minimal)

param(
  [switch]$Solo
)

$Mode = if ($Solo) { "solo" } else { "team" }
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$CrewRoot = Split-Path -Parent $ScriptDir
$Target = Get-Location

if ($Target.Path -eq $CrewRoot) {
  Write-Error "Refusing to install into the crew-kiro repo itself. cd to your project first."
  exit 1
}

Write-Host "Installing crew-kiro into: $Target (mode: $Mode)" -ForegroundColor Cyan
Write-Host ""

function Copy-IfAbsent {
  param($Src, $Dest)
  if (Test-Path $Dest) {
    $rel = $Dest.Replace($Target.Path + "\", "")
    Write-Host "  skip (exists): $rel"
  } else {
    $dir = Split-Path -Parent $Dest
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    Copy-Item $Src $Dest
    $rel = $Dest.Replace($Target.Path + "\", "")
    Write-Host "  wrote:         $rel"
  }
}

function Copy-DirIfAbsent {
  param($Src, $Dest)
  if (Test-Path $Dest) {
    $rel = $Dest.Replace($Target.Path + "\", "")
    Write-Host "  skip (exists): $rel\"
  } else {
    Copy-Item -Recurse $Src $Dest
    $rel = $Dest.Replace($Target.Path + "\", "")
    Write-Host "  wrote:         $rel\"
  }
}

# --- 1. .kiro/steering ---
Write-Host "=== Steering files ===" -ForegroundColor Yellow
New-Item -ItemType Directory -Path "$Target\.kiro\steering\agents" -Force | Out-Null

Copy-IfAbsent "$CrewRoot\.kiro\steering\crew-baseline.md" "$Target\.kiro\steering\crew-baseline.md"
Copy-IfAbsent "$CrewRoot\.kiro\steering\crew-roles.md"    "$Target\.kiro\steering\crew-roles.md"

Get-ChildItem "$CrewRoot\.kiro\steering\agents\*.md" | ForEach-Object {
  Copy-IfAbsent $_.FullName "$Target\.kiro\steering\agents\$($_.Name)"
}
Write-Host ""

# --- 2. .kiro/hooks ---
Write-Host "=== Hooks ===" -ForegroundColor Yellow
New-Item -ItemType Directory -Path "$Target\.kiro\hooks" -Force | Out-Null

Get-ChildItem "$CrewRoot\.kiro\hooks\*.json" | ForEach-Object {
  Copy-IfAbsent $_.FullName "$Target\.kiro\hooks\$($_.Name)"
}
Write-Host ""

# --- 3. Hook scripts ---
Write-Host "=== Hook scripts ===" -ForegroundColor Yellow
New-Item -ItemType Directory -Path "$Target\hooks\lib" -Force | Out-Null

Get-ChildItem "$CrewRoot\hooks\kiro-*.js" | ForEach-Object {
  Copy-IfAbsent $_.FullName "$Target\hooks\$($_.Name)"
}
Get-ChildItem "$CrewRoot\hooks\lib\*.js" | ForEach-Object {
  Copy-IfAbsent $_.FullName "$Target\hooks\lib\$($_.Name)"
}
Write-Host ""

# --- 4. Agent definitions ---
Write-Host "=== Agent definitions ===" -ForegroundColor Yellow
Copy-DirIfAbsent "$CrewRoot\agents" "$Target\agents"
Write-Host ""

# --- 5. Skills ---
Write-Host "=== Skills ===" -ForegroundColor Yellow
Copy-DirIfAbsent "$CrewRoot\skills" "$Target\skills"
Write-Host ""

# --- 6. Standards & docs ---
Write-Host "=== Standards & documentation skeleton ===" -ForegroundColor Yellow
New-Item -ItemType Directory -Path "$Target\standards" -Force | Out-Null
New-Item -ItemType Directory -Path "$Target\docs\decisions" -Force | Out-Null
New-Item -ItemType Directory -Path "$Target\docs\work" -Force | Out-Null

$Templates = "$CrewRoot\templates"

if (Test-Path "$Templates\standards\code-quality.md") {
  Copy-IfAbsent "$Templates\standards\code-quality.md" "$Target\standards\code-quality.md"
}
if (Test-Path "$Templates\docs\decisions\README.md") {
  Copy-IfAbsent "$Templates\docs\decisions\README.md" "$Target\docs\decisions\README.md"
}
if (Test-Path "$Templates\docs\decisions\0000-template.md") {
  Copy-IfAbsent "$Templates\docs\decisions\0000-template.md" "$Target\docs\decisions\0000-template.md"
}
if (Test-Path "$Templates\docs\work\README.md") {
  Copy-IfAbsent "$Templates\docs\work\README.md" "$Target\docs\work\README.md"
}

if ($Mode -eq "team") {
  New-Item -ItemType Directory -Path "$Target\docs\briefs" -Force | Out-Null
  New-Item -ItemType Directory -Path "$Target\docs\stories" -Force | Out-Null
  New-Item -ItemType Directory -Path "$Target\docs\requirements" -Force | Out-Null
  New-Item -ItemType Directory -Path "$Target\docs\proposals" -Force | Out-Null
  New-Item -ItemType Directory -Path "$Target\docs\guides" -Force | Out-Null

  $teamFiles = @(
    @("docs\INDEX.md", "docs\INDEX.md"),
    @("docs\DEVIATIONS.md", "docs\DEVIATIONS.md"),
    @("docs\briefs\README.md", "docs\briefs\README.md"),
    @("docs\stories\README.md", "docs\stories\README.md"),
    @("docs\requirements\README.md", "docs\requirements\README.md"),
    @("docs\proposals\README.md", "docs\proposals\README.md"),
    @("docs\guides\delivery-circuit.md", "docs\guides\delivery-circuit.md"),
    @("docs\guides\delivery-circuit.es.md", "docs\guides\delivery-circuit.es.md")
  )

  foreach ($pair in $teamFiles) {
    $src = "$Templates\$($pair[0])"
    $dest = "$Target\$($pair[1])"
    if (Test-Path $src) { Copy-IfAbsent $src $dest }
  }
}
Write-Host ""

# --- 7. crew.json ---
Write-Host "=== Configuration ===" -ForegroundColor Yellow
$crewJson = "$Target\crew.json"
if (Test-Path $crewJson) {
  Write-Host "  skip (exists): crew.json"
} else {
  @"
{
  "mode": "$Mode",
  "metrics": true,
  "quality": "advise",
  "ceilings": {}
}
"@ | Set-Content $crewJson -Encoding utf8
  Write-Host "  wrote:         crew.json"
}
Write-Host ""

Write-Host "Done! crew-kiro installed for Kiro IDE." -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Open the project in Kiro - steering files and hooks activate automatically."
Write-Host "  2. Use #system-architect, #ux-architect, etc. in chat to invoke roles."
Write-Host "  3. Or prefix messages with SYS:, UX:, DA:, etc. for role activation."
if ($Mode -eq "team") {
  Write-Host "  4. Review crew.json - flip quality to 'enforce' when the team is ready."
  Write-Host "  5. Write docs/spec.md with your project specification."
}
