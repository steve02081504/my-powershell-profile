﻿Register-EngineEvent PowerShell.OnIdle -Action {
	#先注销这个事件
	Unregister-Event PowerShell.OnIdle

	#多打印两行以免光标偏移
	$MyX = $host.UI.RawUI.CursorPosition.X
	Write-Host ""
	Write-Host ""
	#移动到两行前
	$host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $MyX,($host.UI.RawUI.CursorPosition.Y - 2)

	#保存光标位置便于后面清除输出
	$CursorPos = $host.UI.RawUI.CursorPosition

	#set thefuck as alias "fk"
	if (Test-Command "thefuck") {
		$env:PYTHONIOENCODING = "utf-8"
		Invoke-Expression "$(thefuck --alias global:fk)"
	}

	if ($Host.UI.SupportsVirtualTerminal) {
		# https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
		if (-not (Get-Module -ListAvailable -Name Terminal-Icons)) {
			Install-Module -Name Terminal-Icons -Repository PSGallery -Force
		}
		Import-Module -Name Terminal-Icons
	}

	. $PSScriptRoot/CHT2CHS.ps1
	if (Test-Path "C:\ProgramData\BlueStacks_nxt") {
		. $PSScriptRoot/BlueStacks.ps1
	}

	#import appx with -UseWindowsPowerShell to avoid [Operation is not supported on this platform. (0x80131539)]
	if (Test-Command "powershell.exe") {
		Import-Module Appx -UseWindowsPowerShell 3> $null
	}

	#回复光标位置
	$host.UI.RawUI.CursorPosition = $CursorPos
	Write-Host -NoNewline ${VirtualTerminal.ClearScreenDown}
	Remove-Variable CursorPos
} | Out-Null
