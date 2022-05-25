@ECHO OFF

set NAME=sr_speedrun
set GAME="D:\Program Files (x86)\Activision\Cod4Mod"
set MOD="D:\Program Files (x86)\Activision\Cod4Mod\mods\sr_speedrun"
set SR="D:\Program Files (x86)\Activision\Cod4Mod\mods\sr_speedrun\sr"

@REM Cleanup
cd %MOD%
del _images.iwd
del _sounds.iwd
del _weapons.iwd
del _maps_weapons.iwd
del _z.iwd
del _zz.iwd

@REM SR
cd %SR%\assets
7z a -r -tzip %MOD%\_images.iwd images
7z a -r -tzip %MOD%\_sounds.iwd sound
7z a -r -tzip %MOD%\_weapons.iwd weapons_mod
7z rn %MOD%\_weapons.iwd weapons_mod weapons
7z a -r -tzip %MOD%\_maps_weapons.iwd weapons_maps
7z rn %MOD%\_maps_weapons.iwd weapons_maps weapons
7z a -r -tzip %MOD%\_z.iwd misc/iwds/_z
7z rn %MOD%\_z.iwd misc/iwds/_z sound

@REM IWDs
cd %MOD%\assets
7z a -r -tzip %MOD%\_images.iwd images
7z a -r -tzip %MOD%\_sounds.iwd sound
7z a -r -tzip %MOD%\_weapons.iwd weapons_mod
7z rn %MOD%\_weapons.iwd weapons_mod weapons
7z a -r -tzip %MOD%\_maps_weapons.iwd weapons_maps
7z rn %MOD%\_maps_weapons.iwd weapons_maps weapons
cd %MOD%\scripts
