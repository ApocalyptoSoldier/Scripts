Write-Host "Getting Windows 7 Hyper-V image..." -BackgroundColor Black -ForegroundColor Cyan

$tempPath = "$env:TEMP\HyperV-Images"
New-Item -ItemType Directory -Force -Path $tempPath

function Get-Windows7ForHyperVFileList {
	$web = New-Object System.Net.WebClient
	$fileList = $web.DownloadString("https://az412801.vo.msecnd.net/vhd/VMBuild_20131127/2012/IE10_Win7/IE10.Win7.For.WindowsHyperV.WMIv2.txt")
	return $fileList -split '[\r\n]' | foreach { $_.Trim() } | where { ![string]::IsNullOrWhiteSpace($_) }
}

function Download-Part {
	param ([string]$url)
	$fileName = Split-Path -Leaf $url
	$file = "$tempPath\$fileName"
	Write-Host "Downloading:"
	Write-Host "  from: $url"
	Write-Host "    to: $file"
	if (Test-Path $file) {
		Write-Warning "Skipping existing file: $fileName"
	}
	else {
		Start-Process curl.exe -NoNewWindow -Wait -ArgumentList "-o",$file,$url
	}
}

function Download-Windows7Parts {
	Get-Windows7ForHyperVFileList | foreach { Download-Part($_) }
}

$destPath = "${env:ProgramData}\Hyper-V-Images"
$destFile = "$destPath\Virtual Hard Disks\IE10 - Win7.vhd"
if (Test-Path $destFile) {
	Write-Host "VHD already exists:`n -> $destFile"
}
else {
	Download-Windows7Parts
	Push-Location
	New-Item -ItemType Directory -Force -Path $destPath | Set-Location
	$file = Resolve-Path $tempPath\*.exe | Select-Object -First 1 -ExpandProperty ProviderPath
	Write-Host "Extracting $file ..."
	Start-Process $file -NoNewWindow -Wait -ArgumentList "/S"
	Pop-Location
}
