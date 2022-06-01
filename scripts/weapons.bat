@ECHO OFF

set NAME=sr_speedrun
set GAME="D:\Program Files (x86)\Activision\Cod4Mod"
set MOD="D:\Program Files (x86)\Activision\Cod4Mod\mods\sr_speedrun"
set SR="D:\Program Files (x86)\Activision\Cod4Mod\mods\sr_speedrun\sr"

@REM Cleanup
cd %MOD%
del mod.ff

@REM SR
cd %SR%\assets
xcopy /SY weapons_maps weapons
xcopy /SY weapons_mod weapons
xcopy /SY weapons %GAME%\raw\weapons

@REM Assets
cd %MOD%\assets
copy /Y mod.csv %GAME%\zone_source
xcopy /SY weapons_maps weapons
xcopy /SY weapons_mod weapons
xcopy /SY weapons %GAME%\raw\weapons

@REM Compile
cd %GAME%\bin
linker_pc.exe -language english -compress -cleanup mod
copy %GAME%\zone\english\mod.ff %MOD%\mod.ff
cd %MOD%\scripts
