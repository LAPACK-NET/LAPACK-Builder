mkdir "./build"
cd "./build"

$tools_folder=(Resolve-Path -Path "../tools").Path | % {$_ -replace '\\','/'}
$lapack_path="../lapack"

$ninja_path=$tools_folder+"/ninja/ninja.exe"
$cmake_path=$tools_folder+"/cmake/cmake-3.20.0-rc1-windows-x86_64/bin/cmake.exe"

$mingw_folder=$tools_folder+"/mingw64/bin"
$gcc_path=$mingw_folder+"/gcc.exe"
$gcpp_path=$mingw_folder+"/g++.exe"
$gfortran_path=$mingw_folder+"/gfortran.exe"

&"$($cmake_path)" $lapack_path -GNinja -DCMAKE_MAKE_PROGRAM="$($ninja_path)" -DCMAKE_CXX_COMPILER="$($gcpp_path)" -DCMAKE_C_COMPILER="$($gcc_path)" -DCMAKE_Fortran_COMPILER="$($gfortran_path)" -DBUILD_SHARED_LIBS=ON -DCMAKE_GNUtoMS=ON -DCMAKE_SHARED_LINKER_FLAGS="-Wl,--allow-multiple-definition"
&"$($cmake_path)" --build .

cd ".."
Remove-Item -LiteralPath "./bin" -Force -Recurse
mkdir "./bin/"
copy "./build/bin/*.dll" "./bin"
copy "$($mingw_folder)/*.dll" "./bin"