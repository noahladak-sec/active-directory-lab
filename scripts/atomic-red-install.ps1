# atomic-red-install.ps1
# Installs Atomic Red Team and runs a test for local account creation (T1136.001)

Set-ExecutionPolicy Bypass -Scope Process -Force

Invoke-WebRequest -UseBasicParsing -Uri `
"https://raw.githubusercontent.com/redcanaryco/invoke-atomicredteam/main/install-atomicredteam.ps1" `
-OutFile install-atomicredteam.ps1

.\install-atomicredteam.ps1

Import-Module .\AtomicRedTeam\Invoke-AtomicRedTeam.psd1 -Force

Invoke-AtomicTest T1136.001
