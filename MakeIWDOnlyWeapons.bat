@ECHO OFF

SET sz="%~dp0\bin\7z.exe"

del _weapons.iwd
del _maps_weapons.iwd

echo. & echo [=====] Mod Weapons [=====]
%sz% a -r -tzip _weapons.iwd weapons_mod
%sz% rn _weapons.iwd weapons_mod weapons

echo. & echo [=====] Map Weapons [=====]
%sz% a -r -tzip _maps_weapons.iwd weapons_maps
%sz% rn _maps_weapons.iwd weapons_maps weapons
