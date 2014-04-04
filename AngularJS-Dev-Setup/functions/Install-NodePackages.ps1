Write-Host "Installing Global NodeJS packages..."

function Install-NodePackagesGlobal {
	param ([string]$packages)
	$packages -split '[\n\r]' | % { $_.Trim() } | ? { $_ } | % {
		& "npm.cmd" "install" "-g" $_
	}
}

Install-NodePackagesGlobal("
	yo
	grunt-cli
	bower
	generator-angular")
