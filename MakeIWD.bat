@ECHO OFF

SET sz="%~dp0\bin\7z.exe"

echo. & echo [=====] Deleting IWDs [=====]
del _images.iwd
del _sounds.iwd
del _weapons.iwd
del _maps_weapons.iwd
del _z.iwd

echo. & echo [=====] Images [=====]
%sz% a -r -tzip _images.iwd images

echo. & echo [=====] Sounds [=====]
%sz% a -r -tzip _sounds.iwd sound
%sz% a -r -tzip _sounds.iwd dr_songs.cfg

echo. & echo [=====] Mod Weapons [=====]
%sz% a -r -tzip _weapons.iwd weapons_mod
%sz% rn _weapons.iwd weapons_mod weapons

echo. & echo [=====] Map Weapons [=====]
%sz% a -r -tzip _maps_weapons.iwd weapons_maps
%sz% rn _maps_weapons.iwd weapons_maps weapons

echo. & echo [=====] Temps [=====]
%sz% a -r -tzip _z.iwd misc/temp_iwds/_z
%sz% rn _z.iwd misc/temp_iwds/_z sound
