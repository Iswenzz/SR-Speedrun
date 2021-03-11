del _images.iwd
del _sounds.iwd
del _weapons.iwd
del _maps_weapons.iwd
del _loadscreens.iwd
del _z.iwd

rem main images
7za a -r -tzip _images.iwd images

rem main sounds
7za a -r -tzip _sounds.iwd sound
7za a -r -tzip _sounds.iwd dr_songs.cfg

rem mod weapons
7za a -r -tzip _weapons.iwd weapons_mod
7z rn _weapons.iwd weapons_mod weapons

rem map weapons
7za a -r -tzip _maps_weapons.iwd weapons_maps
7z rn _maps_weapons.iwd weapons_maps weapons

rem loadscreens
7za a -r -tzip _loadscreens.iwd loadscreen
7z rn _loadscreens.iwd loadscreen images

rem misc 1
7za a -r -tzip _z.iwd _z
7z rn _z.iwd _z sound

rem misc 2
7za a -r -tzip _zz.iwd _zz
7z rn _zz.iwd _zz images