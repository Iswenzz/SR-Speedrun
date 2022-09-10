#!/bin/bash
source cod4env

# Cleanup
cd "$MOD"
rm -v mod.ff

# SR
cd "$SR/assets"
cp -rv animtrees "$GAME/raw"
cp -rv english "$GAME/raw"
cp -rv fx "$GAME/raw"
cp -rv images "$GAME/raw"
cp -rv maps "$GAME/raw"
cp -rv material_properties "$GAME/raw"
cp -rv materials "$GAME/raw"
cp -rv info "$GAME/raw"
cp -rv mp "$GAME/raw"
cp -rv rumble "$GAME/raw"
cp -rv soundaliases "$GAME/raw"
cp -rv sound "$GAME/raw"
cp -rv deffiles "$GAME"
cp -rv shader_bin "$GAME/raw"
cp -rv techniques "$GAME/raw"
cp -rv techsets "$GAME/raw"
cp -v techsets/* "$GAME/raw/techsets/sm2"
cp -rv ui "$GAME/raw"
cp -rv ui_mp "$GAME/raw"
cp -v weapons_maps/* "$GAME/raw/weapons"
cp -v weapons_mod/* "$GAME/raw/weapons"
cp -rv vision "$GAME/raw"
cp -rv xanim "$GAME/raw"
cp -rv xmodel "$GAME/raw"
cp -rv xmodelparts "$GAME/raw"
cp -rv xmodelsurfs "$GAME/raw"

# Assets
cd "$MOD/assets"
cp -v mod.csv "$GAME/zone_source"
cp -rv animtrees "$GAME/raw"
cp -rv english "$GAME/raw"
cp -rv fx "$GAME/raw"
cp -rv images "$GAME/raw"
cp -rv maps "$GAME/raw"
cp -rv material_properties "$GAME/raw"
cp -rv materials "$GAME/raw"
cp -rv info "$GAME/raw"
cp -rv mp "$GAME/raw"
cp -rv rumble "$GAME/raw"
cp -rv soundaliases "$GAME/raw"
cp -rv sound "$GAME/raw"
cp -rv deffiles "$GAME"
cp -rv shader_bin "$GAME/raw"
cp -rv techniques "$GAME/raw"
cp -rv techsets "$GAME/raw"
cp -v techsets/* "$GAME/raw/techsets/sm2"
cp -rv ui "$GAME/raw"
cp -rv ui_mp "$GAME/raw"
cp -rv weapons_maps/* weapons
cp -rv weapons_mod/* weapons
cp -rv weapons "$GAME/raw"
cp -rv vision "$GAME/raw"
cp -rv xanim "$GAME/raw"
cp -rv xmodel "$GAME/raw"
cp -rv xmodelparts "$GAME/raw"
cp -rv xmodelsurfs "$GAME/raw"

# Shaders
cd "$GAME/raw/shader_bin"
./shader_tool sr_edge sr_blur sr_vhs sr_shake sr_zoom sr_translate sr_mirror sr_psy_glass sr_glitch

# Compile
cd "$GAME/bin"
./linker_pc -language english -compress -cleanup mod
cp -v "$GAME/zone/english/mod.ff" "$MOD/mod.ff"
