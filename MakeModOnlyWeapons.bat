@ECHO OFF

del mod.ff

xcopy mp ..\..\raw\mp /SY
xcopy weapons ..\..\raw\weapons /SY

copy /Y DeathRun_ReadMe.txt ..\..\raw
copy /Y cleanup.cfg ..\..\raw
copy /Y mod.csv ..\..\zone_source

cd ..\..\bin
linker_pc.exe -language english -compress -cleanup mod
cd ..\mods\aspeed_run
copy ..\..\zone\english\mod.ff
