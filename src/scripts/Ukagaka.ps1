function global:Get-Ukagaka-Description-File-HashTable {
	param(
		[Parameter(Mandatory = $true)]
		$Content
	)
	#首先以换行符分割
	$Content = $Content -split "`n"
	#去除末尾可能的`r
	$Content = $Content -replace "`r$"
	#去除空行
	$Content = $Content -ne ""
	$Description = @{}
	foreach ($Line in $Content) {
		$LineArray = $Line -split ','
		$Key = $LineArray[0].Trim()
		$Value = $Line.Substring($LineArray[0].Length + 1).Trim()
		$Description.Add($Key,$Value)
	}
	$Description
}
function global:Read-Ukagaka-Description-File {
	param(
		[Parameter(Mandatory = $true)]
		[string]$Path
	)
	$Content = Get-Content $Path -Encoding UTF8
	$Description = Get-Ukagaka-Description-File-HashTable -Content $Content
	#若charset不是UTF-8或其大小写变体，则重新读取
	if (($Description['charset']) -and ($Description['charset'] -notmatch 'UTF-?8')) {
		$Content = Get-Content $Path -Encoding $Description['charset']
		$Description = Get-Ukagaka-Description-File-HashTable -Content $Content
	}
	$Description
}
function global:Test-Ukagaka-Directory-Base {
	param(
		[Parameter(Mandatory = $true)]
		[string]$Path,
		[string]$CheckPath = 'descript.txt'
	)
	$DescriptionPath = Join-Path $Path $CheckPath
	if (Test-Path $DescriptionPath) {
		Read-Ukagaka-Description-File $DescriptionPath
	}
	else {
		#测试父目录直至根目录
		$ParentPath = Split-Path $Path
		if ($ParentPath) {
			Test-Ukagaka-Directory-Base $ParentPath $CheckPath
		}
		else {
			$null
		}
	}
}
function global:Test-Ukagaka-Ghost-Directory {
	param(
		[Parameter(Mandatory = $true)]
		[string]$Path
	)
	Test-Ukagaka-Directory-Base $Path 'ghost/master/descript.txt'
}
function global:Test-Ukagaka-Directory {
	param(
		[Parameter(Mandatory = $true)]
		[string]$Path
	)
	$result = Test-Ukagaka-Directory-Base $Path
	if (-not $result) {
		Test-Ukagaka-Ghost-Directory $Path
	}
	else {
		$result
	}
}
