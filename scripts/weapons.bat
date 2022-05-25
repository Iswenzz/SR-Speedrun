@ECHO OFF

set NAME=sr_speedrun
set GAME="D:\Program Files (x86)\Activision\Cod4Mod"
set MOD="D:\Program Files (x86)\Activision\Cod4Mod\mods\sr_speedrun"

cd %MOD%
del mod.ff

cd assets
copy /Y mod.csv %GAME%\zone_source
xcopy /SY mp %GAME%\raw\mp
xcopy /SY weapons_maps weapons
xcopy /SY weapons_mod weapons
xcopy /SY weapons %GAME%\raw\weapons

cd %GAME%\bin
linker_pc.exe -language english -compress -cleanup mod
copy %GAME%\zone\english\mod.ff %MOD%\mod.ff
cd %MOD%\scripts
