if((Get-ExecutionPolicy) -eq 'Restricted'){ Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force }
# 遍历环境变量
$env:Path.Split(";") | ForEach-Object {
	if ($_ -and (-not (Test-Path $_ -PathType Container))) {
		Write-Warning "检测到无效的环境变量于$_，请考虑删除"
	}
	elseif ($_ -like "*[\\/]esh[\\/]path*") {
		$Script:eshDir = $_ -replace "[\\/]path[\\/]*$", ''
		$Script:eshDirFromEnv = $true
	}
}
# 使用if判断+赋值：我们不能使用??=因为用户可能以winpwsh运行该脚本
if (-not $eshDir) {
	$Script:eshDir =
	if ($EshellUI.Sources.Path -and (Test-Path "${EshellUI.Sources.Path}/path/esh")) { $EshellUI.Sources.Path }
	elseif (Test-Path $PSScriptRoot/../path/esh) { "$PSScriptRoot/.." }
	elseif (Test-Path $env:LOCALAPPDATA/esh) { "$env:LOCALAPPDATA/esh" }
}