#!/bin/bash
source env

# Cleanup
cd $MOD
rm mod.ff

# SR
cd $SR/assets
cp -R weapons_maps weapons
cp -R weapons_mod weapons
cp -R weapons $GAME/raw/weapons

# Assets
cd $MOD/assets
cp mod.csv $GAME/zone_source
cp -R weapons_maps weapons
cp -R weapons_mod weapons
cp -R weapons $GAME/raw/weapons

# Compile
cd $GAME/bin
linker_pc.exe -language english -compress -cleanup mod
copy $GAME/zone/english/mod.ff $MOD/mod.ff
cd $MOD/scripts
