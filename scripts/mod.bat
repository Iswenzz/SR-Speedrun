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
xcopy /SY animtrees %GAME%\raw\animtrees
xcopy /SY english %GAME%\raw\english
xcopy /SY fx %GAME%\raw\fx
xcopy /SY images %GAME%\raw\images
xcopy /SY maps %GAME%\raw\maps
xcopy /SY material_properties %GAME%\raw\material_properties
xcopy /SY materials %GAME%\raw\materials
xcopy /SY info %GAME%\raw\info
xcopy /SY mp %GAME%\raw\mp
xcopy /SY soundaliases %GAME%\raw\soundaliases
xcopy /SY sound %GAME%\raw\sound
xcopy /SY ui %GAME%\raw\ui
xcopy /SY ui_mp %GAME%\raw\ui_mp
xcopy /SY weapons_maps weapons
xcopy /SY weapons_mod weapons
xcopy /SY weapons %GAME%\raw\weapons
xcopy /SY vision %GAME%\raw\vision
xcopy /SY xanim %GAME%\raw\xanim
xcopy /SY xmodel %GAME%\raw\xmodel
xcopy /SY xmodelparts %GAME%\raw\xmodelparts
xcopy /SY xmodelsurfs %GAME%\raw\xmodelsurfs

@REM Assets
cd %MOD%\assets
copy /Y mod.csv %GAME%\zone_source
xcopy /SY animtrees %GAME%\raw\animtrees
xcopy /SY english %GAME%\raw\english
xcopy /SY fx %GAME%\raw\fx
xcopy /SY images %GAME%\raw\images
xcopy /SY maps %GAME%\raw\maps
xcopy /SY material_properties %GAME%\raw\material_properties
xcopy /SY materials %GAME%\raw\materials
xcopy /SY info %GAME%\raw\info
xcopy /SY mp %GAME%\raw\mp
xcopy /SY soundaliases %GAME%\raw\soundaliases
xcopy /SY sound %GAME%\raw\sound
xcopy /SY ui %GAME%\raw\ui
xcopy /SY ui_mp %GAME%\raw\ui_mp
xcopy /SY weapons_maps weapons
xcopy /SY weapons_mod weapons
xcopy /SY weapons %GAME%\raw\weapons
xcopy /SY vision %GAME%\raw\vision
xcopy /SY xanim %GAME%\raw\xanim
xcopy /SY xmodel %GAME%\raw\xmodel
xcopy /SY xmodelparts %GAME%\raw\xmodelparts
xcopy /SY xmodelsurfs %GAME%\raw\xmodelsurfs

@REM Compile
cd %GAME%\bin
linker_pc.exe -language english -compress -cleanup mod
copy %GAME%\zone\english\mod.ff %MOD%\mod.ff
cd %MOD%\scripts
