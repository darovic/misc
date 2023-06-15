function Stop-Explorer {
	Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoRestartShell -Value 0
	Get-Process -Name explorer | Stop-Process -Force
	Start-Sleep -Seconds 1
	Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoRestartShell -Value 1
}

# elevation check from https://superuser.com/a/756696
if (([Security.Principal.WindowsPrincipal] `
		[Security.Principal.WindowsIdentity]::GetCurrent() `
		).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	Stop-Explorer
} else {
	Start-Process pwsh -ArgumentList $PSCommandPath -Verb RunAs -WindowStyle hidden
}
