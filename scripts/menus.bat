@ECHO OFF

set NAME=sr_speedrun
set GAME="D:\Program Files (x86)\Activision\Cod4Mod"
set MOD="D:\Program Files (x86)\Activision\Cod4Mod\mods\sr_speedrun"

cd %MOD%
del mod.ff

cd assets
copy /Y mod.csv %GAME%\zone_source
xcopy /SY english %GAME%\raw\english
xcopy /SY info %GAME%\raw\info
xcopy /SY mp %GAME%\raw\mp
xcopy /SY ui %GAME%\raw\ui
xcopy /SY ui_mp %GAME%\raw\ui_mp

cd %GAME%\bin
linker_pc.exe -language english -compress -cleanup mod
copy %GAME%\zone\english\mod.ff %MOD%\mod.ff
cd %MOD%\scripts
