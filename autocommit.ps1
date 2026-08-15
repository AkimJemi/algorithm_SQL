# Root wrapper for PowerShell autocommit
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
& "$ScriptDir\tool\auto_git_commit.ps1" @args
