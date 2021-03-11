del _weapons.iwd
del _maps_weapons.iwd

rem mod weapons
7za a -r -tzip _weapons.iwd weapons_mod
7z rn _weapons.iwd weapons_mod weapons

rem map weapons
7za a -r -tzip _maps_weapons.iwd weapons_maps
7z rn _maps_weapons.iwd weapons_maps weapons
