#!/bin/bash
source env

# Cleanup
cd $MOD
rm _images.iwd
rm _sounds.iwd
rm _weapons.iwd
rm _maps_weapons.iwd
rm _z.iwd
rm _zz.iwd

# SR
cd $SR/assets
7z a -r -tzip $MOD/_images.iwd images
7z a -r -tzip $MOD/_sounds.iwd sound
7z a -r -tzip $MOD/_weapons.iwd weapons_mod
7z rn $MOD/_weapons.iwd weapons_mod weapons
7z a -r -tzip $MOD/_maps_weapons.iwd weapons_maps
7z rn $MOD/_maps_weapons.iwd weapons_maps weapons
7z a -r -tzip $MOD/_z.iwd misc/iwds/_z
7z rn $MOD/_z.iwd misc/iwds/_z sound

# IWDs
cd $MOD/assets
7z a -r -tzip $MOD/_images.iwd images
7z a -r -tzip $MOD/_sounds.iwd sound
7z a -r -tzip $MOD/_weapons.iwd weapons_mod
7z rn $MOD/_weapons.iwd weapons_mod weapons
7z a -r -tzip $MOD/_maps_weapons.iwd weapons_maps
7z rn $MOD/_maps_weapons.iwd weapons_maps weapons
cd $MOD/scripts
