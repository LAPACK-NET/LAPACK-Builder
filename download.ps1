$7zip_exe = "7z1900-x64.exe"
$working_folder = "./tools"

mkdir $working_folder
cd $working_folder

Write-Host "Getting urls..."
$ninja_url=((Invoke-WebRequest -URI 'https://api.github.com/repos/ninja-build/ninja/releases/latest' | ConvertFrom-Json).assets | Where-Object { $_.name -eq "ninja-win.zip" }).browser_download_url
Write-Host "Ninja url: $($ninja_url)"
$cmake_url=((Invoke-WebRequest -URI 'https://api.github.com/repos/Kitware/CMake/releases/latest' | ConvertFrom-Json).assets | Where-Object { $_.name -like "cmake-*-windows-x86_64.zip" }).browser_download_url
Write-Host "Cmake url: $($cmake_url)"
$mingw_url="https://deac-fra.dl.sourceforge.net/project/mingw-w64/Toolchains%20targetting%20Win64/Personal%20Builds/mingw-builds/8.1.0/threads-posix/sjlj/x86_64-8.1.0-release-posix-sjlj-rt_v6-rev0.7z"
Write-Host "MinGW url: $($mingw_url)"

Write-Host "Loading archives..."
Invoke-WebRequest -Uri $ninja_url -OutFile "./ninja.zip"
Invoke-WebRequest -Uri $cmake_url -OutFile "./cmake.zip"
Invoke-WebRequest -Uri $mingw_url -OutFile "./mingw.7z"

Write-Host "Expanding ninja..."
Expand-Archive -LiteralPath "./ninja.zip" -DestinationPath "./ninja"
Write-Host "Expanding cmake..."
Expand-Archive -LiteralPath "./cmake.zip" -DestinationPath "./cmake"

<# 
the only flond way of downloading mingw binaris without instalation is downloading .7z archive
powershell's Expand-Archive do not support 7z
modern versions of 7z file archiver are spreaded only as executable archive...
so the solution is to expand modern 7z with version spreaded in .zip file (which is supported by Expand-Archive)
#>
Write-Host "Loading 7z..."
Invoke-WebRequest -Uri "http://www.7-zip.org/a/7za920.zip" -OutFile "./7za920.zip"
Invoke-WebRequest -Uri "http://www.7-zip.org/a/$($7zip_exe)" -OutFile "./$($7zip_exe)"

Write-Host "Preparing 7z..."
Expand-Archive -LiteralPath "./7za920.zip" -DestinationPath "./7za920"
&"./7za920/7za.exe" x -o"7zip" "./$($7zip_exe)" > temp # redirecting output for quit instalation

Write-Host "Extracting MinGW..."
&"./7zip/7z.exe" x mingw.7z > temp # redirecting output for quit instalation

Write-Host "Cleaning Up..."
Remove-Item -LiteralPath "./ninja.zip" -Force
Remove-Item -LiteralPath "./cmake.zip" -Force
Remove-Item -LiteralPath "./mingw.7z" -Force
Remove-Item -LiteralPath "./7za920.zip" -Force
Remove-Item -LiteralPath "./$($7zip_exe)" -Force
Remove-Item -LiteralPath "./7za920" -Force -Recurse
Remove-Item -LiteralPath "./7zip" -Force -Recurse
Remove-Item -LiteralPath "./temp" -Force

#cd "./cmake/cmake-*-windows-x86_64/bin"
#copy * "../../"
#cd "../../"
#Remove-Item "./cmake-*-windows-x86_64/" -Force -Recurse

Write-Host "Done"