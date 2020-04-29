﻿Clear-Host

Start-Process $PSScriptRoot\..\AlterID.exe -ArgumentList "-silent"
Start-Sleep 5
do
{
	$Process = Get-Process | Where-Object -FilterScript {$_.Name -eq "TeamViewer"}
	if ($Process)
	{
		# "Still running: TeamViewer"
		Start-Sleep -Seconds 1
	}
}
until (-not ($Process))

powershell.exe -NoProfile -NoLogo -Command Start-Process powershell -WindowStyle Hidden -ArgumentList "{
	Start-Sleep -Seconds 3
	TAKEOWN /F $PSScriptRoot\..\rolloutfile.tv13
	ICACLS $PSScriptRoot\..\rolloutfile.tv13 --% /grant:r %USERNAME%:F
	Remove-Item -Path $PSScriptRoot\..\rolloutfile.tv13 -Force
	Remove-Item -Path HKCU:\Software\TeamViewer -Recurse -Force -ErrorAction Ignore
	Remove-Item $env:LOCALAPPDATA\TeamViewer -Recurse -Force
	Remove-Item $env:APPDATA\TeamViewer -Recurse -Force
	exit
}" -Verb runAs