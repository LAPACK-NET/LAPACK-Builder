$7zip_installer_exe = "7z1900-x64.exe"

$working_folder = "./tools"

Remove-Item -LiteralPath $working_folder -Force -Recurse -ErrorAction SilentlyContinue
mkdir $working_folder | Out-Null
cd $working_folder

if (Get-Command "ninja.exe" -ErrorAction SilentlyContinue)
{
    Write-Host "ninja is already available"
}
else
{
    Write-Host "Loading ninja..."
    $ninja_url=((Invoke-WebRequest -URI 'https://api.github.com/repos/ninja-build/ninja/releases/latest' | ConvertFrom-Json).assets | Where-Object { $_.name -eq "ninja-win.zip" }).browser_download_url
    Write-Host "Ninja url: $($ninja_url)"
    Invoke-WebRequest -Uri $ninja_url -OutFile "./ninja.zip"
    
    Write-Host "Expanding ninja..."
    Expand-Archive -LiteralPath "./ninja.zip" -DestinationPath "./ninja"
    
    Write-Host "Cleaning up..."
    Remove-Item -LiteralPath "./ninja.zip" -Force
}

if (Get-Command "cmake.exe" -ErrorAction SilentlyContinue)
{
    Write-Host "cmake is already available"
}
else
{
    Write-Host "Loading cmake..."
    $cmake_url=((Invoke-WebRequest -URI 'https://api.github.com/repos/Kitware/CMake/releases/latest' | ConvertFrom-Json).assets | Where-Object { $_.name -like "cmake-*-windows-x86_64.zip" }).browser_download_url
    Write-Host "Cmake url: $($cmake_url)"
    Invoke-WebRequest -Uri $cmake_url -OutFile "./cmake.zip"

    Write-Host "Expanding cmake..."
    Expand-Archive -LiteralPath "./cmake.zip" -DestinationPath "./cmake"

    Write-Host "Cleaning Up..."
    Remove-Item -LiteralPath "./cmake.zip" -Force
    cd "./cmake/cmake-*-windows-x86_64"
    xcopy /s * ".." | Out-Null
    cd "../../"
    Remove-Item "./cmake/cmake-*-windows-x86_64/" -Force -Recurse
}

Write-Host "Loading mingw..."
$mingw_url="https://deac-fra.dl.sourceforge.net/project/mingw-w64/Toolchains%20targetting%20Win64/Personal%20Builds/mingw-builds/8.1.0/threads-posix/sjlj/x86_64-8.1.0-release-posix-sjlj-rt_v6-rev0.7z"
Write-Host "MinGW url: $($mingw_url)"
Invoke-WebRequest -Uri $mingw_url -OutFile "./mingw.7z"

if (Get-Command "7z.exe" -ErrorAction SilentlyContinue)
{
    Write-Host "7z is already available"
    $7zip = "7z.exe"
}
else
{
    <# 
    the only found way of downloading mingw binaris without installation is downloading .7z archive
    powershell's Expand-Archive do not support 7z
    modern versions of 7z file archiver are spreaded only as executable archive...
    so the solution is to expand modern 7z with version spreaded in .zip file (which is supported by Expand-Archive)
    #>
    Write-Host "Loading 7z..."
    Invoke-WebRequest -Uri "http://www.7-zip.org/a/7za920.zip" -OutFile "./7za920.zip"
    Invoke-WebRequest -Uri "http://www.7-zip.org/a/$($7zip_installer_exe)" -OutFile "./$($7zip_installer_exe)"

    Write-Host "Preparing 7z..."
    Expand-Archive -LiteralPath "./7za920.zip" -DestinationPath "./7za920"
    &"./7za920/7za.exe" x -o"7zip" "./$($7zip_installer_exe)" > temp # redirecting output for quit instalation
    $7zip = "./7zip/7z.exe"
}

Write-Host "Extracting MinGW..."
&"$($7zip)" x mingw.7z > temp # redirecting output for quit instalation

Write-Host "Cleaning Up..."
Remove-Item -LiteralPath "./mingw.7z" -Force
Remove-Item -LiteralPath "./temp" -Force
if (!(Get-Command "7z.exe" -ErrorAction SilentlyContinue))
{
    Remove-Item -LiteralPath "./7za920.zip" -Force
    Remove-Item -LiteralPath "./$($7zip_installer_exe)" -Force
    Remove-Item -LiteralPath "./7za920" -Force -Recurse
    Remove-Item -LiteralPath "./7zip" -Force -Recurse
}

if(!(Get-Command "C:\Program Files (x86)\Microsoft Visual Studio\*\Community\VC\Auxiliary\Build\vcvarsall.bat" -ErrorAction SilentlyContinue))
{
    Write-Warning "Visual studio command prompt is not installed or not in default location"
}

Write-Host "Done"
