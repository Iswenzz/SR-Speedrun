#!/bin/bash
source env

# Cleanup
cd $MOD
rm mod.ff

# SR
cd $SR/assets
cp -R english $GAME/raw/english
cp -R info $GAME/raw/info
cp -R mp $GAME/raw/mp
cp -R ui $GAME/raw/ui
cp -R ui_mp $GAME/raw/ui_mp

# Assets
cd $MOD/assets
cp mod.csv $GAME/zone_source
cp -R english $GAME/raw/english
cp -R info $GAME/raw/info
cp -R mp $GAME/raw/mp
cp -R ui $GAME/raw/ui
cp -R ui_mp $GAME/raw/ui_mp

# Compile
cd $GAME/bin
linker_pc$BIN_PREFIX -language english -compress -cleanup mod
copy $GAME/zone/english/mod.ff $MOD/mod.ff
cd $MOD/scripts
