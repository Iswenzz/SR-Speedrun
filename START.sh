#!/bin/sh
GAMEPATH="D:\Program Files (x86)\Activision\Cod4Mod"
TOKEN="485709CA6432CD38206B1EEF302549D8F54A494E"
GAME="mods/aspeed_run"
GAMETYPE="speedrun"
XASSET="weapons=200 xmodel=1200 xanim=3200 material=3200 image=3200 fx=600"

"$GAMEPATH/cod4x18_dedrun.exe" +set sv_authtoken $TOKEN +set fs_game $GAME +set sv_legacyguidmode 1 +loadplugin gsclib +set dedicated 2 +set net_port 28960 +set developer 0 +set g_gametype $GAMETYPE +exec server.cfg +map mp_dr_lolz +set fs_basepath "$GAMEPATH" +set fs_homepath "$GAMEPATH" +set r_xassetnum $XASSET