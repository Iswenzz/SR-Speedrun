#!/bin/bash
source cod4env

# Cleanup
cd "$MOD"
rm -v mod.ff

# SR
cd "$SR/assets"
cp -rv deffiles "$GAME"
cp -rv shader_bin "$GAME/raw"
cp -rv techniques "$GAME/raw"
cp -rv techsets "$GAME/raw"
cp -v techsets/* "$GAME/raw/techsets/sm2"

# Assets
cd "$MOD/assets"
cp -v mod.csv "$GAME/zone_source"
cp -rv deffiles "$GAME"
cp -rv shader_bin "$GAME/raw"
cp -rv techniques "$GAME/raw"
cp -rv techsets "$GAME/raw"
cp -v techsets/* "$GAME/raw/techsets/sm2"

# Shaders
cd "$GAME/raw/shader_bin"
./shader_tool sr_edge sr_blur sr_vhs sr_shake sr_zoom sr_translate sr_mirror sr_psy_glass sr_glitch

# Compile
cd "$GAME/bin"
./linker_pc -language english -compress -cleanup mod
cp -v "$GAME/zone/english/mod.ff" "$MOD/mod.ff"
