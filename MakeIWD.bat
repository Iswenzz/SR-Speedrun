@ECHO OFF

SET sza="%~dp0\bin\7za.exe"
SET sz="%~dp0\bin\7z.exe"

echo. & echo [=====] Deleting IWDs [=====] & echo.
del _images.iwd
del _sounds.iwd
del _weapons.iwd
del _maps_weapons.iwd
del _z.iwd

echo. & echo [=====] Images [=====] & echo.
%sza% a -r -tzip _images.iwd images

echo. & echo [=====] Sounds [=====] & echo.
%sza% a -r -tzip _sounds.iwd sound
%sza% a -r -tzip _sounds.iwd dr_songs.cfg

echo. & echo [=====] Mod Weapons [=====] & echo.
%sza% a -r -tzip _weapons.iwd weapons_mod
%sz% rn _weapons.iwd weapons_mod weapons

echo. & echo [=====] Map Weapons [=====] & echo.
%sza% a -r -tzip _maps_weapons.iwd weapons_maps
%sz% rn _maps_weapons.iwd weapons_maps weapons

echo. & echo [=====] Temps [=====] & echo.
%sza% a -r -tzip _z.iwd _z
%sz% rn _z.iwd _z sound
