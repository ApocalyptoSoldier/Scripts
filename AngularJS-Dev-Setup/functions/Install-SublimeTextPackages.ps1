function Install-SublimeTextPackage {
    param ([string]$url, [string]$packageName)

    $web = New-Object System.Net.WebClient
    $destDir = "$env:Temp\SublimeText-Packages"
    
    New-Item -ItemType Directory -Force -Path $destDir
    $dest = "$destDir\$packageName.zip"
    $packagesDir = "$env:APPDATA\Sublime Text 3\Packages"
    $web.DownloadFile($url, $dest)
    Start-Process 7za.bat -NoNewWindow -Wait -ArgumentList "-o`"$packagesDir`"","-y","x",$dest
    Remove-Item "$packagesDir\packageName" -Force -Recurse -ErrorAction SilentlyContinue
    $path = (Resolve-Path -Path $packagesDir\$packageName*-master).ProviderPath
	Rename-Item -Force -Path $path -NewName "$packagesDir\$packageName"
}

function Install-SublimeTextPackages {
	Install-SublimeTextPackage "https://github.com/SublimeText/PowerShell/archive/master.zip" "PowerShell"
	Install-SublimeTextPackage "https://github.com/angular-ui/AngularJS-sublime-package/archive/master.zip" "AngularJS"

    # Package Control:
	$web = New-Object System.Net.WebClient
    $web.DownloadFile("https://sublime.wbond.net/Package%20Control.sublime-package", "$env:APPDATA\Sublime Text 3\Installed Packages\Package Control.sublime-package")
}
