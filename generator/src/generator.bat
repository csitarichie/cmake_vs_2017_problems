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
:: robocopy "%srcDir%" "%dstDir%" /xf *.cmake
pushd "%srcDir%"
for /r %%i in (*) do (
        :: echo processing %%i
        if "%%~xi" equ ".gensrc" (
          echo generating "%dstDir%\%%~ni"
          copy /Y "%%i" "%dstDir%\%%~ni"
        )
)
popd
pushd "%dstDir%"
:: make sure that the files have the timestamp of the generation time
:: stamp file is updated by cmake 
for /r %%i in (*) do (
    if "%%~xi" neq ".stamp" (
        copy /b "%%i"+,,
    )
)
popd
exit /b %errorlevel%
