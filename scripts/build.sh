#!/bin/bash
source env

# Cleanup
cd $MOD
rm mod.ff

# SR
cd $SR/assets
cp -R animtrees $GAME/raw/animtrees
cp -R english $GAME/raw/english
cp -R fx $GAME/raw/fx
cp -R images $GAME/raw/images
cp -R maps $GAME/raw/maps
cp -R material_properties $GAME/raw/material_properties
cp -R materials $GAME/raw/materials
cp -R info $GAME/raw/info
cp -R mp $GAME/raw/mp
cp -R soundaliases $GAME/raw/soundaliases
cp -R sound $GAME/raw/sound
cp -R ui $GAME/raw/ui
cp -R ui_mp $GAME/raw/ui_mp
cp -R weapons_maps weapons
cp -R weapons_mod weapons
cp -R weapons $GAME/raw/weapons
cp -R vision $GAME/raw/vision
cp -R xanim $GAME/raw/xanim
cp -R xmodel $GAME/raw/xmodel
cp -R xmodelparts $GAME/raw/xmodelparts
cp -R xmodelsurfs $GAME/raw/xmodelsurfs

# Assets
cd $MOD/assets
cp mod.csv $GAME/zone_source
cp -R animtrees $GAME/raw/animtrees
cp -R english $GAME/raw/english
cp -R fx $GAME/raw/fx
cp -R images $GAME/raw/images
cp -R maps $GAME/raw/maps
cp -R material_properties $GAME/raw/material_properties
cp -R materials $GAME/raw/materials
cp -R info $GAME/raw/info
cp -R mp $GAME/raw/mp
cp -R soundaliases $GAME/raw/soundaliases
cp -R sound $GAME/raw/sound
cp -R ui $GAME/raw/ui
cp -R ui_mp $GAME/raw/ui_mp
cp -R weapons_maps weapons
cp -R weapons_mod weapons
cp -R weapons $GAME/raw/weapons
cp -R vision $GAME/raw/vision
cp -R xanim $GAME/raw/xanim
cp -R xmodel $GAME/raw/xmodel
cp -R xmodelparts $GAME/raw/xmodelparts
cp -R xmodelsurfs $GAME/raw/xmodelsurfs

# Compile
cd $GAME/bin
linker_pc.exe -language english -compress -cleanup mod
copy $GAME/zone/english/mod.ff $MOD/mod.ff
cd $MOD/scripts
