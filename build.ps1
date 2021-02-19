$out_folder="./src/Lapack.Net/native"

Write-Host "Remove 'build' folder if exists"
Remove-Item -LiteralPath "./build" -Force -Recurse -ErrorAction SilentlyContinue
Write-Host "Create 'build' folder"
mkdir "./build" | Out-Null
cd "./build"

$tools_folder=(Resolve-Path -Path "../tools").Path | % {$_ -replace '\\','/'}
$lapack_path="../lapack"

$Env:Path = $tools_folder+"/mingw64/bin;" + $Env:Path

Write-Host "Detecting ninja..."
if (!(Get-Command "ninja.exe" -ErrorAction SilentlyContinue))
{
    $Env:Path = $tools_folder+"/ninja;" + $Env:Path
}

Write-Host "Detecting cmake..."
if (!(Get-Command "cmake.exe" -ErrorAction SilentlyContinue))
{
    $Env:Path = $tools_folder+"/cmake/bin;" + $Env:Path
}

Write-Host "Generating ninja.build..."
cmake $lapack_path -GNinja `
    -D CMAKE_CXX_COMPILER="g++" `
    -D CMAKE_C_COMPILER="gcc" `
    -D CMAKE_Fortran_COMPILER="gfortran" `
    -D BUILD_SHARED_LIBS=ON `
    -D CMAKE_GNUtoMS=ON `
    -D BUILD_DEPRECATED=OFF `
    -D BLAS++=OFF `
    -D LAPACK++=OFF `
    -D CBLAS=OFF `
    -D LAPACKE=OFF `
    -D LAPACKE_WITH_TMG=OFF `
    -D BUILD_COMPLEX=ON `
    -D BUILD_COMPLEX16=ON `
    -D BUILD_DOUBLE=ON `
    -D BUILD_SINGLE=ON `
    -D BUILD_TESTING=OFF `
    -D BUILD_INDEX64=OFF `
    -D USE_XBLAS=OFF `
    -D USE_OPTIMIZED_BLAS=OFF `
    -D USE_OPTIMIZED_LAPACK=OFF `
    -D CMAKE_SHARED_LINKER_FLAGS="-Wl,--allow-multiple-definition" `
    -D CMAKE_BUILD_TYPE=Release

Write-Host "Building project..."
cmake --build . --clean-first --config Release

Write-Host "Removing previous builded binaries..."
cd ".."
Remove-Item -LiteralPath $out_folder -Force -Recurse

Write-Host "Copying new binaries to bin folder..."
mkdir $out_folder | Out-Null
copy "./build/bin/*.dll" $out_folder
copy "$($tools_folder)/mingw64/bin/*.dll" $out_folder

Write-Host "Done"
