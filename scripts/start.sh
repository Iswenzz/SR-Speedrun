#!/bin/sh
GAMEPATH="D:\Program Files (x86)\Activision\Cod4Mod"
GAME="mods/sr_speedrun"

cd "$GAMEPATH"
./cod4x18_dedrun.exe +set fs_game $GAME +set dedicated 2 +set net_port 28960 +set developer 0 +exec server.cfg +map mp_sr_pure_strafe +set fs_basepath "$GAMEPATH" +set fs_homepath "$GAMEPATH"