@echo off

:: reset errorlevel
cd > nul

set genLibName=%1 
shift
set srcDir=%1
shift
set dstDir=%1
shift

echo generating lib: %genLibName% to "%dstDir%"
robocopy "%srcDir%" "%dstDir%" /xf *.cmake
pushd "%dstDir%"
:: make sure that the files have the timestamp of the generation
for /r %%i in (*) do copy /b "%%i"+,,
popd
exit /b %errorlevel%
