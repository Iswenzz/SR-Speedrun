#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include braxi\_common;
#include braxi\_dvar;

main()
{
	braxi\_dvar::setupDvars();
	precache();
	init_spawns();
	braxi\_cod4stuff::main();

	game["DeathRunVersion"] = 12;
	level.mapName = toLower(getDvar("mapname"));
	level.jumpers = 0;
	level.activators = 0;
	level.activatorKilled = false;
	level.freeRun = false;
	level.allowSpawn = true;
	level.tempEntity = spawn("script_model", (0, 0, 0));
	level.colliders = [];
	level.trapsDisabled = false;
	level.canCallFreeRun = true;
	level.color_cool_green = (0.8, 2.0, 0.8);
	level.color_cool_green_glow = (0.3, 0.6, 0.3);
	level.hudYOffset = 10;
	level.firstBlood = false;
	level.lastJumper = false;
	level.mapHasTimeTrigger = false;

	if (!isDefined(game["roundsplayed"]))
		game["roundsplayed"] = 1;
	game["roundStarted"] = false;
	game["state"] = "readyup";

	if (game["roundsplayed"] == 1)
	{
		game["playedmaps"] = strTok(level.dvar["playedmaps"], ";");
		addMap = true;
		if (game["playedmaps"].size)
		{
			for (i = 0; i < game["playedmaps"].size; i++)
			{
				if (game["playedmaps"][i] == level.mapName)
				{
					addMap = false;
					break;
				}
			}
		}
		if (addMap)
		{
			appendToDvar("dr_playedmaps", level.mapName + ";");
			level.dvar["playedmaps"] = getDvar("dr_playedmaps");
			game["playedmaps"] = strTok(level.dvar["playedmaps"], ";");
		}
		if (level.dvar["freerun"])
			level.freeRun = true;
	}

	setDvar("jump_slowdownEnable", 0);
	setDvar("bullet_penetrationEnabled", 0);
	setDvar("mod_author", "BraXi");
	makeDvarServerInfo("mod_author", "BraXi");

	buildSprayInfo();
	buildCharacterInfo();
	buildItemInfo();
	buildKnifeInfo();
	buildKnifeSkinInfo();
	buildThemeInfo();
	buildFxInfo();
	buildGloveInfo();
	buildRankIcons();

	thread maps\mp\gametypes\_hud::init();
	thread maps\mp\gametypes\_hud_message::init();
	thread maps\mp\gametypes\_damagefeedback::init();
	thread maps\mp\gametypes\_clientids::init();
	thread maps\mp\gametypes\_gameobjects::init();
	thread maps\mp\gametypes\_spawnlogic::init();
	thread maps\mp\gametypes\_oldschool::deletePickups();
	thread maps\mp\gametypes\_hud::init();
	thread maps\mp\gametypes\_quickmessages::init();
	thread maps\mp\_weapons::init();

	thread braxi\_scoreboard::init();
	thread braxi\_menus::init();
	thread braxi\_rank::init();

	level thread gameLogic();
	level thread serverMessages();
	level thread doHudTime();
	level thread fastestTime();

	visionSetNaked(level.mapName, 0);
}

precache()
{
	level.text = [];
	level.fx = [];

	precacheModel("german_sheperd_dog");
	precacheModel("viewmodel_hands_zombie");
	precacheModel("tag_origin");
	precacheModel("body_mp_usmc_cqb");
	precacheModel("body_alice");
	precacheModel("collision_sphere");
	precacheModel("mil_frame_charge");

	precacheItem("fortnite_mp");
	precacheItem("colt45_mp");
	precacheItem("tomahawk_mp");
	precacheItem("claymore_mp");
	precacheItem("shop_mp");
	precacheItem("vip_mp");
	precacheItem("knife_mp");
	precacheItem("dog_mp");
	precacheItem("shovel_mp");
	precacheItem("rpg_mp");
	precacheItem("c4_mp");
	precacheItem("rtd_mp");
	precacheItem("frag_grenade_short_mp");

	precacheMenu("clientcmd");

	precacheShader("black");
	precacheShader("white");
	precacheShader("time_hud");
	precacheShader("killiconsuicide");
	precacheShader("killiconmelee");
	precacheShader("killiconheadshot");
	precacheShader("killiconfalling");
	precacheShader("stance_stand");
	precacheShader("hudstopwatch");
	precacheShader("score_icon");

	precacheShader("minesweeper_square");
	precacheShader("minesweeper_smile");
	precacheShader("minesweeper_minered");
	precacheShader("minesweeper_mine");
	precacheShader("minesweeper_glasses");
	precacheShader("minesweeper_flag");
	precacheShader("minesweeper_dead");
	precacheShader("minesweeper_board");

	PreCacheShader("key_w");
	PreCacheShader("key_a");
	PreCacheShader("key_s");
	PreCacheShader("key_d");

	precacheStatusIcon("vip_status");
	precacheShader("vip_status");
	precacheShader("vip_gold");

	precacheShader("sr_shop");
	precacheShader("sr_dice");
	precacheShader("sr_vip");
	precacheShader("sr_insert");

	precacheShader("speedrunner_logo");

	precacheshader("fps_20");
	precacheshader("fps_30");
	precacheshader("fps_125");
	precacheshader("fps_142");
	precacheshader("fps_166");
	precacheshader("fps_250");
	precacheshader("fps_333");
	precacheshader("fps_500");
	precacheshader("fps_1000");

	PreCacheShellShock("flashbang");

	precacheStatusIcon("hud_status_connecting");
	precacheStatusIcon("hud_status_dead");
	precacheHeadIcon("headicon_admin");

	level.text["round_begins_in"] = &"BRAXI_ROUND_BEGINS_IN";
	level.text["waiting_for_players"] = &"BRAXI_WAITING_FOR_PLAYERS";
	level.text["jumpers_count"] = &"BRAXI_ALIVE_JUMPERS";
	level.text["call_freeround"] = &"BRAXI_CALL_FREEROUND";

	precacheString(level.text["round_begins_in"]);
	precacheString(level.text["waiting_for_players"]);
	precacheString(level.text["jumpers_count"]);
	precacheString(level.text["call_freeround"]);
	precacheString(&"Your Time: ^2&&1");

	level.fx["endgame"] = loadFx("deathrun/endgame_fx");
	level.fx["gib_splat"] = loadFx("deathrun/gib_splat");
	level.fx["light_blink"] = loadFx("misc/light_c4_blink");
	level.fx["endtrig_fx"] = loadFx("deathrun/endtrig_fx");
	level.fx["endtrigcircle_fx"] = loadFx("deathrun/endtrigcircle_fx");
	level.fx["secrettrig_fx"] = loadFx("deathrun/secrettrig_fx");
	level.fx["yellow_fx"] = loadFx("deathrun/yellow_fx");
	level.fx["red_fx"] = loadFx("deathrun/red_fx");
	level.fx["purple_fx"] = loadFx("deathrun/purple_fx");
	level.fx["orange_fx"] = loadFx("deathrun/orange_fx");
	level.fx["green_fx"] = loadFx("deathrun/green_fx");
	level.fx["cyan_fx"] = loadFx("deathrun/cyan_fx");
	level.fx["secrettrigcircle_fx"] = loadFx("deathrun/secrettrigcircle_fx");
	level.fx["wr_event"] = loadFx("deathrun/wr_fx");
	level.fx["viptrail1"] = loadFx("deathrun/vip_trail1");
	level.fx["viptrail2"] = loadFx("deathrun/vip_trail2");
	level.fx["viptrail3"] = loadFx("deathrun/vip_trail3");
	level.fx["viptrail4"] = loadFx("deathrun/vip_trail4");
	level.fx["viptrail5"] = loadFx("deathrun/vip_trail5");
	level.fx["startnstop"] = loadFx("deathrun/flare_startnstop");
	level.jetpack = loadFx("smoke/jetpack");

	level.meteorfx = LoadFX("fire/tank_fire_engine");
	level.expbullt = loadfx("explosions/grenadeExp_concrete_1");
	level.flame = loadfx("fire/tank_fire_engine");
}

init_spawns()
{
	level.spawn = [];
	level.spawn["allies"] = getEntArray("mp_jumper_spawn", "classname");
	level.spawn["axis"] = getEntArray("mp_activator_spawn", "classname");

	if (getEntArray("mp_global_intermission", "classname").size == 0)
	{
		level.spawn["spectator"] = spawn("script_origin", (0, 0, 0));
		level.spawn["spectator"].angles = (0, 0, 0);
	}
	else
		level.spawn["spectator"] = getEntArray("mp_global_intermission", "classname")[0];

	if (!level.spawn["allies"].size)
		level.spawn["allies"] = getEntArray("mp_dm_spawn", "classname");
	if (!level.spawn["axis"].size)
		level.spawn["axis"] = getEntArray("mp_tdm_spawn", "classname");

	for (i = 0; i < level.spawn["allies"].size; i++)
		level.spawn["allies"][i] placeSpawnPoint();

	for (i = 0; i < level.spawn["axis"].size; i++)
		level.spawn["axis"][i] placeSpawnPoint();

	x = 0;
	y = 0;
	z = 0;

	for (i = 0; i < level.spawn["allies"].size; i++)
	{
		x += level.spawn["allies"][i].origin[0];
		y += level.spawn["allies"][i].origin[1];
		x += level.spawn["allies"][i].origin[2];
	}

	x = x / level.spawn["allies"].size;
	y = y / level.spawn["allies"].size;
	z = z / level.spawn["allies"].size;

	level.masterSpawn = spawn("script_origin", (x, y, z));
	level.masterSpawn.angles = level.spawn["allies"][0].angles;
	level.masterSpawn placeSpawnPoint();

}

buildRankIcons()
{
	level.rankIconInfo = [];

	tableName = "mp/rankIconTable.csv";

	for (idx = 1; isdefined(tableLookup(tableName, 0, idx, 0)) && tableLookup(tableName, 0, idx, 0) != ""; idx++)
	{
		level.rankIconInfo[idx - 1]["icon"] = tableLookup(tableName, 0, idx, 1);

		preCacheShader(level.rankIconInfo[idx - 1]["icon"]);
	}
	for (i = 1; i < 11; i++)
		preCacheShader("rank_prestige" + i);
}

buildSprayInfo()
{
	level.sprayInfo = [];
	level.numSprays = 0;

	tableName = "mp/sprayTable.csv";

	for (idx = 1; isdefined(tableLookup(tableName, 0, idx, 0)) && tableLookup(tableName, 0, idx, 0) != ""; idx++)
	{
		id = int(tableLookup(tableName, 0, idx, 1));
		level.sprayInfo[id]["rank"] = (int(tableLookup(tableName, 0, idx, 2)) - 1);
		level.sprayInfo[id]["prestige"] = int(tableLookup(tableName, 0, idx, 3));
		level.sprayInfo[id]["effect"] = loadFx(tableLookup(tableName, 0, idx, 4));
		level.sprayInfo[id]["name"] = tableLookup(tableName, 0, idx, 5);
		level.sprayInfo[id]["model"] = "";
		level.sprayInfo[id]["func"] = sr\player\_customize::sprayPredicate;

		level.numSprays++;
	}
}

buildCharacterInfo()
{
	level.characterInfo = [];
	level.numCharacters = 0;

	tableName = "mp/characterTable.csv";

	for (idx = 1; isdefined(tableLookup(tableName, 0, idx, 0)) && tableLookup(tableName, 0, idx, 0) != ""; idx++)
	{
		id = int(tableLookup(tableName, 0, idx, 1));
		level.characterInfo[id]["rank"] = (int(tableLookup(tableName, 0, idx, 2)) - 1);
		level.characterInfo[id]["prestige"] = int(tableLookup(tableName, 0, idx, 3));
		level.characterInfo[id]["model"] = tableLookup(tableName, 0, idx, 4);
		level.characterInfo[id]["handsModel"] = tableLookup(tableName, 0, idx, 5);
		level.characterInfo[id]["name"] = tableLookup(tableName, 0, idx, 6);
		level.characterInfo[id]["desc"] = tableLookup(tableName, 0, idx, 7);
		level.characterInfo[id]["func"] = sr\player\_customize::characterPredicate;

		precacheModel(level.characterInfo[id]["model"]);
		precacheModel(level.characterInfo[id]["handsModel"]);
		level.numCharacters++;
	}
}

buildItemInfo()
{
	level.itemInfo = [];
	level.numItems = 0;

	tableName = "mp/itemTable.csv";

	for (idx = 1; isdefined(tableLookup(tableName, 0, idx, 0)) && tableLookup(tableName, 0, idx, 0) != ""; idx++)
	{
		id = int(tableLookup(tableName, 0, idx, 1));
		level.itemInfo[id]["rank"] = (int(tableLookup(tableName, 0, idx, 2)) - 1);
		level.itemInfo[id]["prestige"] = int(tableLookup(tableName, 0, idx, 3));
		level.itemInfo[id]["item"] = (tableLookup(tableName, 0, idx, 4) + "_mp");
		level.itemInfo[id]["name"] = tableLookup(tableName, 0, idx, 5);
		level.itemInfo[id]["desc"] = tableLookup(tableName, 0, idx, 6);
		level.itemInfo[id]["model"] = GetWeaponModel(level.itemInfo[id]["item"]);
		level.itemInfo[id]["func"] = sr\player\_customize::weaponPredicate;

		precacheItem(level.itemInfo[id]["item"]);
		level.numItems++;
	}
}

buildKnifeInfo()
{
	level.knifeInfo = [];
	level.numKnifes = 0;

	tableName = "mp/knifeTable.csv";

	for (idx = 1; isdefined(tableLookup(tableName, 0, idx, 0)) && tableLookup(tableName, 0, idx, 0) != ""; idx++)
	{
		id = int(tableLookup(tableName, 0, idx, 1));
		level.knifeInfo[id]["rank"] = (int(tableLookup(tableName, 0, idx, 2)) - 1);
		level.knifeInfo[id]["prestige"] = int(tableLookup(tableName, 0, idx, 3));
		level.knifeInfo[id]["item"] = (tableLookup(tableName, 0, idx, 4) + "_mp");
		level.knifeInfo[id]["name"] = tableLookup(tableName, 0, idx, 5);
		level.knifeInfo[id]["model"] = tableLookup(tableName, 0, idx, 6);
		level.knifeInfo[id]["func"] = sr\player\_customize::knifePredicate;

		precacheModel(level.knifeInfo[id]["model"]);
		precacheItem(level.knifeInfo[id]["item"]);
		level.numKnifes++;
	}
}

buildKnifeSkinInfo()
{
	level.knifeSkinInfo = [];
	level.numKnifeSkins = 0;

	tableName = "mp/knifeSkinTable.csv";

	for (idx = 1; isdefined(tableLookup(tableName, 0, idx, 0)) && tableLookup(tableName, 0, idx, 0) != ""; idx++)
	{
		id = int(tableLookup(tableName, 0, idx, 1));
		level.knifeSkinInfo[id]["rank"] = (int(tableLookup(tableName, 0, idx, 2)) - 1);
		level.knifeSkinInfo[id]["shader"] = tableLookup(tableName, 0, idx, 3);
		level.knifeSkinInfo[id]["item"] = tableLookup(tableName, 0, idx, 4);
		level.knifeSkinInfo[id]["name"] = tableLookup(tableName, 0, idx, 5);
		level.knifeSkinInfo[id]["model"] = tableLookup(tableName, 0, idx, 6);
		level.knifeSkinInfo[id]["func"] = sr\player\_customize::knifeSkinPredicate;

		precacheModel(level.knifeSkinInfo[id]["model"]);
		level.numKnifeSkins++;
	}
}

buildThemeInfo()
{
	level.themeInfo = [];
	level.numTheme = 0;

	tableName = "mp/themeTable.csv";

	for (idx = 1; isdefined(tableLookup(tableName, 0, idx, 0)) && tableLookup(tableName, 0, idx, 0) != ""; idx++)
	{
		id = int(tableLookup(tableName, 0, idx, 1));
		level.themeInfo[id]["rank"] = (int(tableLookup(tableName, 0, idx, 2)) - 1);
		level.themeInfo[id]["shader"] = tableLookup(tableName, 0, idx, 3);
		level.themeInfo[id]["item"] = tableLookup(tableName, 0, idx, 4);
		level.themeInfo[id]["name"] = tableLookup(tableName, 0, idx, 5);
		level.themeInfo[id]["desc"] = tableLookup(tableName, 0, idx, 6);
		level.themeInfo[id]["func"] = sr\player\_customize::themePredicate;
		level.themeInfo[id]["model"] = "";

		level.numTheme++;
	}
}

buildFxInfo()
{
	level.fxInfo = [];
	level.numFx = 0;

	tableName = "mp/fxTable.csv";

	for (idx = 1; isdefined(tableLookup(tableName, 0, idx, 0)) && tableLookup(tableName, 0, idx, 0) != ""; idx++)
	{
		id = int(tableLookup(tableName, 0, idx, 1));
		level.fxInfo[id]["rank"] = (int(tableLookup(tableName, 0, idx, 2)) - 1);
		level.fxInfo[id]["prestige"] = int(tableLookup(tableName, 0, idx, 3));
		level.fxInfo[id]["name"] = tableLookup(tableName, 0, idx, 4);
		level.fxInfo[id]["model"] = "";
		level.fxInfo[id]["func"] = sr\player\_customize::fxPredicate;

		level.numFx++;
	}
}

buildGloveInfo()
{
	level.gloveInfo = [];
	level.numGlove = 0;

	tableName = "mp/gloveTable.csv";

	for (idx = 1; isdefined(tableLookup(tableName, 0, idx, 0)) && tableLookup(tableName, 0, idx, 0) != ""; idx++)
	{
		id = int(tableLookup(tableName, 0, idx, 1));
		level.gloveInfo[id]["rank"] = (int(tableLookup(tableName, 0, idx, 2)) - 1);
		level.gloveInfo[id]["prestige"] = int(tableLookup(tableName, 0, idx, 3));
		level.gloveInfo[id]["model"] = tableLookup(tableName, 0, idx, 4);
		level.gloveInfo[id]["name"] = tableLookup(tableName, 0, idx, 5);
		level.gloveInfo[id]["func"] = sr\player\_customize::glovePredicate;

		precacheModel(level.gloveInfo[id]["model"]);
		level.numGlove++;
	}
}

playerConnect() // Called when player is connecting to server

{
	level notify("connected", self);

	self thread cleanUp();
	self.canDamage = undefined;
	self.guid = self getGuid();
	self.number = self getEntityNumber();
	self.statusicon = "hud_status_connecting";
	self.died = false;
	self.doingNotify = false;
 //for hud logic
	self setClientDvar("cl_maxpackets", 125);
	self.pers["fullbright"] = 0;
	self.pers["fovscale"] = 0;
	self.pers["fxenabled"] = 1;
	self setStat(2360, 0);

	self thread speedrun\_main::onConnect();

	if (!isDefined(self.name))
		self.name = "undefined name";
	if (!isDefined(self.guid))
		self.guid = "undefined guid";

	// we want to show hud and we get an IP adress for "add to favourities" menu
	self setClientDvars("show_hud", "true", "ip", getDvar("net_ip"), "port", getDvar("net_port"));
	if (!isDefined(self.pers["team"]))
	{
		self.sessionstate = "spectator";
		self.team = "spectator";
		self.pers["team"] = "spectator";

		self.pers["score"] = 0;
		self.pers["kills"] = 0;
		self.pers["deaths"] = 0;
		self.pers["assists"] = 0;
		self.pers["lifes"] = 0;
		self.pers["headshots"] = 0;
		self.pers["knifes"] = 0;
		self.pers["activator"] = 0;
		self.pers["time"] = 99999999;
		self.pers["isDog"] = false;
	}
	else
	{
		self.score = self.pers["score"];
		self.kills = self.pers["kills"];
		self.assists = self.pers["assists"];
		self.deaths = self.pers["deaths"];
	}

	if (game["state"] == "endmap")
	{
		self spawnSpectator(level.spawn["spectator"].origin, level.spawn["spectator"].angles);
		self.sessionstate = "intermission";
		return;
	}

	if (isDefined(self.pers["weapon"]) && self.pers["team"] != "spectator")
	{
		self.pers["weapon"] = "colt_mp";
		self thread braxi\_teams::setTeam("allies");
		spawnPlayer();
		return;
	}
	else
	{
		self spawnSpectator(level.spawn["spectator"].origin, level.spawn["spectator"].angles);
		self thread delayedMenu();
		logPrint("J;" + self.guid + ";" + self.number + ";" + self.name + "\n");
	}
	self setClientDvars("cg_drawSpectatorMessages", 1, "ui_hud_hardcore", 1, "player_sprintTime", 4, "ui_uav_client", 0, "g_scriptMainMenu", game["menu_team"]);
}

playerDisconnect() // Called when player disconnect from server

{
	level notify("disconnected", self);
	self thread cleanUp();
	self thread speedrun\_main::stoprecord_disconnect();

	if (isDefined(self.clone))
		self.clone delete();

	if (!isDefined(self.name))
		self.name = "no name";

	if (level.dvar["show_guids"])
		iPrintln(self.name + " ^2[" + getSubStr(self getGuid(), 24, 32) + "^2] ^7left the game");
	else
		iPrintln(self.name + " ^7left the game");

	logPrint("Q;" + self getGuid() + ";" + self getEntityNumber() + ";" + self.name + "\n");
}

PlayerLastStand(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	self suicide();
}

PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime)
{
	if (self.sessionteam == "spectator" || game["state"] == "endmap")
		return;

	level notify("player_damage", self, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);

	if (isPlayer(eAttacker) && !isDefined(eAttacker.can_damage))
		return;

	if (isPlayer(eAttacker) && sMeansOfDeath == "MOD_MELEE" && isWallKnifing(eAttacker, self))
		return;

	// damage modifier
	if (sMeansOfDeath != "MOD_MELEE")
	{
		modifier = getDvarFloat("dr_damageMod_" + sWeapon);
		if (modifier <= 2.0 && modifier >= 0.1 && sMeansOfDeath != "MOD_MELEE")
			iDamage = int(iDamage * modifier);
	}

	if (!isDefined(vDir))
		iDFlags |= level.iDFLAGS_NO_KNOCKBACK;

	if (!(iDFlags & level.iDFLAGS_NO_PROTECTION))
	{
		if (iDamage < 1)
			iDamage = 1;

		self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
	}
}

PlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	self endon("spawned");
	self notify("killed_player");
	self notify("death");

	if (self.sessionteam == "spectator" || game["state"] == "endmap")
		return;

	if (level.raceStarted && self.inRace)
		return;

	level notify("player_killed", self, eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration);

	self thread speedrun\_main::stoprecord_death();

	if (level.dvar["giveXpForKill"] && !level.trapsDisabled)
	{
		if (isDefined(level.activ) && level.activ != self && level.activ isReallyAlive())
			if (sMeansOfDeath == "MOD_UNKNOWN" || sMeansOfDeath == "MOD_FALLING" || sMeansOfDeath == "MOD_SUICIDE")
			level.activ braxi\_rank::giveRankXP("jumper_died");
	}
	if (sHitLoc == "head" && sMeansOfDeath != "MOD_MELEE")
		sMeansOfDeath = "MOD_HEAD_SHOT";

	self.statusicon = "hud_status_dead";
	self.sessionstate = "spectator";

	if (isPlayer(attacker) && self.inKz && level.kzStarted)
	{
		if (attacker != self)
		{
			braxi\_rank::processXpReward(sMeansOfDeath, attacker, self);

			attacker.kills++;
			attacker.pers["kills"]++;
			if (sHitLoc == "head" && sMeansOfDeath != "MOD_MELEE")
				attacker thread braxi\_rank::giveRankXP(10);
			else if (sMeansOfDeath == "MOD_MELEE")
				attacker thread braxi\_rank::giveRankXP(7);
			else
				attacker thread braxi\_rank::giveRankXP(5);
		}
	}

	if (self.inKz && level.kzStarted)
	{
		if (isPlayer(attacker))
			attacker.wonKz = true;
		deaths = self maps\mp\gametypes\_persistence::statGet("deaths");
		self maps\mp\gametypes\_persistence::statSet("deaths", deaths + 1);
		self.deaths++;
		self.pers["deaths"]++;
	}
	self.died = true;
	self thread cleanUp();

	if (self.inKz)
		return;

	self thread respawn();
}

after_time_lower()
{
	self endon("disconnect");
	wait 3;
	self clearLowerMessage();
}

spawnPlayer(origin, angles)
{
	if (game["state"] == "endmap")
		return;

	level notify("jumper", self);
	self thread cleanUp();
	resettimeout();

	self.team = self.pers["team"];
	self.sessionteam = self.team;
	self.sessionstate = "playing";
	self.spectatorclient = -1;
	self.killcamentity = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	self.statusicon = "";
	self.finishedMap = undefined;

	self thread speedrun\_main::onPlayerSpawned();

	self braxi\_teams::setPlayerModel();

	if (isDefined(origin) && isDefined(angles))
		self spawn(origin, angles);
	else
	{
		spawnPoint = level.masterSpawn;
		self spawn(spawnPoint.origin, spawnPoint.angles);
	}

	if (self.model == "german_sheperd_dog")
		self.pers["weapon"] = "dog_mp";
	else
	{
		self.pers["weapon"] = level.itemInfo[self getStat(981)]["item"];
		self.pers["knife"] = level.knifeInfo[self getStat(982)]["item"];
		self.pers["knife_skin"] = int(level.knifeSkinInfo[self getStat(983)]["item"]);
	}

	if (self.pers["knifeonly"])
	{
		self giveWeapon(self.pers["knife"], self.pers["knife_skin"]);
		self setSpawnWeapon(self.pers["knife"]);
		self giveMaxAmmo(self.pers["knife"]);
	}
	else
	{
		self giveWeapon(self.pers["weapon"]);
		self giveWeapon(self.pers["knife"], self.pers["knife_skin"]);
		self setSpawnWeapon(self.pers["weapon"]);
		self giveMaxAmmo(self.pers["weapon"]);
	}
	if (self.isBot)
		self takeAllWeapons();

	self thread braxi\_teams::setHealth();
	self thread afterFirstFrame();

	self notify("spawned_player");
	level notify("player_spawn", self);
}

afterFirstFrame()
{
	self endon("disconnect");
	self endon("joined_spectators");
	self endon("death");
	waittillframeend;
	wait 0.1;

	if (!self isPlaying())
		return;

	if (game["state"] == "readyup")
	{
		self FreezeControls(1);
		self disableWeapons();
	}

	if (self getStat(988) == 1)
		self setClientDvar("cg_thirdperson", 1);

	self clearPerks();

	self thread watchItems();
	self thread playerTimer();
	self thread sprayLogo();

	if (isDefined(level.sr_CJ) && level.sr_CJ)
	{
		self SetActionSlot(4, "weapon", "rpg_mp");
		self giveWeapon("rpg_mp");
		self giveMaxAmmo("rpg_mp");
	}
}

makeMeNotSolid()
{
	self endon("disconnect");
	self endon("spawned_player");
	self endon("joined_spectators");
	self endon("death");

	self setClientDvar("g_playerCollisionEjectSpeed", 1);
	while (self isReallyAlive())
	{
		wait 0.05;
		self setContents(0);
	}
}

isAngleOk(angles, min, max)
{
	diff = distance(angles, self.angles);
	iprintln("diff:" + diff);
	if (diff >= min && diff <= max)
		return true;
	return false;
}

sprayLogo()
{
	self endon("disconnect");
	self endon("spawned_player");
	self endon("joined_spectators");
	self endon("death");

	if (!level.dvar["sprays"])
		return;

	while (game["state"] != "playing")
		wait 0.05;

	while (self isReallyAlive())
	{
		while (!self fragButtonPressed())
			wait .2;

		angles = self getPlayerAngles();
		eye = self getTagOrigin("j_head");
		forward = eye + vector_scale(anglesToForward(angles), 70);
		trace = bulletTrace(eye, forward, false, self);

		if (trace["fraction"] == 1)
		{
			wait 0.1;
			continue;
		}

		position = trace["position"] - vector_scale(anglesToForward(angles), -2);
		angles = vectorToAngles(eye - position);
		forward = anglesToForward(angles);
		up = anglesToUp(angles);

		sprayNum = self getStat(979);

		if (sprayNum < 0)
			sprayNum = 0;
		else if (sprayNum > level.numSprays)
			sprayNum = level.numSprays;

		playFx(level.sprayInfo[sprayNum]["effect"], position, forward, up);
		self playSound("sprayer");

		self notify("spray", sprayNum, position, forward, up);

		if (isDefined(self.admin_group) && self.admin_group == "owner")
			wait 0.1;
		else
			wait level.dvar["sprays_delay"];
	}
}

endRound(reasonText, team)
{
	level endon("endmap");

	if (game["state"] == "round ended" || !game["roundStarted"])
		return;

	level notify("round_ended", reasonText, team);
	level notify("endround");
	level notify("kill logic");

	game["state"] = "round ended";
	game["roundsplayed"]++;

	if (isDefined(level.hud_time))
		level.hud_time destroy();

	players = getAllPlayers();
	for (i = 0; i < players.size; i++)
		players[i] setClientDvars("r_blur", 2.0, "show_hud", "false");

	if (game["roundsplayed"] >= (level.dvar["round_limit"] + 1))
	{
		level endMap("Game has ended");
		return;
	}
	else
		level thread endRoundAnnoucement(reasonText, (0, 1, 0));

	wait 10;
	map_restart(true);
}

addTextHud(who, x, y, alpha, alignX, alignY, fontScale)
{
	if (isPlayer(who))
		hud = newClientHudElem(who);
	else
		hud = newHudElem();

	hud.x = x;
	hud.y = y;
	hud.alpha = alpha;
	hud.alignX = alignX;
	hud.alignY = alignY;
	hud.fontScale = fontScale;
	return hud;
}

endRoundAnnoucement(text, color)
{
	notifyData = spawnStruct();
	notifyData.titleText = text;
	notifyData.notifyText = ("Starting round ^3" + game["roundsplayed"] + "^7 out of ^3" + level.dvar["round_limit"]);
	notifyData.glowColor = color;
	notifyData.duration = 8.8;

	players = getAllPlayers();
	for (i = 0; i < players.size; i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage(notifyData);
}

spawnSpectator(origin, angles)
{
	if (!isDefined(origin))
		origin = (0, 0, 0);
	if (!isDefined(angles))
		angles = (0, 0, 0);

	self notify("joined_spectators");

	self thread cleanUp();
	resettimeout();
	self.sessionstate = "spectator";
	self.spectatorclient = -1;
	self.statusicon = "";
	self spawn(origin, angles);
	self braxi\_teams::setSpectatePermissions();

	level notify("player_spectator", self);
}

cleanUp()
{
	self clearLowerMessage();
	self notify("kill afk monitor");
	self setClientDvars("cg_thirdperson", 0, "cg_thirdpersonrange", 80, "r_blur", 0, "ui_healthbar", 1, "bg_viewKickMax", 90, "bg_viewKickMin", 5, "bg_viewKickRandom", 0.4, "bg_viewKickScale", 0.2);
	self unLink();

	self.bh = 0;
	self.doingBH = false;
	self enableWeapons();

	if (isDefined(self.hud_freeround))
		self.hud_freeround destroy();
	if (isDefined(self.hud_freeround_time))
		self.hud_freeround_time destroy();
}

gameLogic()
{
	level endon("endround");
	level endon("kill logic");
	waittillframeend;

	level.allowSpawn = true;
	warning = false;

	visionSetNaked("mpIntro", 0);
	if (isDefined(level.matchStartText))
		level.matchStartText destroyElem();

	wait 0.2;

	level.matchStartText = createServerFontString("objective", 1.5);
	level.matchStartText setPoint("CENTER", "CENTER", 0, -20);
	level.matchStartText.sort = 1001;
	level.matchStartText setText(level.text["waiting_for_players"]);
	level.matchStartText.foreground = false;
	level.matchStartText.hidewheninmenu = true;

	min = 1;

	roundStartTimer();

	if (!canStartRound(min))
	{
		thread restartLogic();
		return;
	}

	level notify("round_started", game["roundsplayed"]);
	level notify("game started");
	game["state"] = "playing";
	game["roundStarted"] = true;

	visionSetNaked(level.mapName, 2.0);

	players = getAllPlayers();
	for (i = 0; i < players.size; i++)
	{
		if (players[i] isPlaying())
		{
			players[i] FreezeControls(0);
			players[i] unLink();
			players[i] enableWeapons();
		}
	}

	if (level.freeRun)
	{
		level.hud_time setTimer(level.dvar["freerun_time"]);
		thread sr\game\_timer::hud(level.dvar["freerun_time"], ::endRound);
	}
}

checkTimeLimit()
{
	level endon("endround");
	level endon("game over");

	if (!level.dvar["time_limit"])
		return;

	time = 60 * level.dvar["time_limit"];
	level.hud_time setTimer(time);
	wait time;
	level thread endRound("Time limit reached", "activators");
}

endmap_rng_song()
{
	r = RandomIntRange(2, 11);
	return "end_map" + r;
}

endmap_song()
{
	wait 1;
	ambientPlay(endmap_rng_song(), 0);
}

endmap_earthquake()
{
	while (1)
	{
		Earthquake(0.05, 0.05, level.spawn["spectator"].origin, 20000);
		wait 0.05;
	}
}

endMap(winningteam, map)
{
	game["state"] = "endmap";
	level notify("intermission");
	level notify("game over");

	setDvar("g_deadChat", 1);

	if (isDefined(level.hud_jumpers))
		level.hud_jumpers destroy();

	AmbientStop(2);

	visionSetNaked("mp_dr_sm64", 4);

	thread endmap_song();

	players = getAllPlayers();
	for (i = 0; i < players.size; i++)
	{
		players[i] closeMenu();
		players[i] closeInGameMenu();
		players[i] freezeControls(true);
		players[i] cleanUp();
		players[i] suicide();
	}
	wait .05;

	players = getAllPlayers();
	for (i = 0; i < players.size; i++)
	{
		players[i] spawnSpectator(level.spawn["spectator"].origin, level.spawn["spectator"].angles);
		players[i] allowSpectateTeam("allies", false);
		players[i] allowSpectateTeam("axis", false);
		players[i] allowSpectateTeam("freelook", false);
		players[i] allowSpectateTeam("none", true);
	}

	thread endmap_earthquake();

	wait 5;

	playFx(level.fx["endgame"], level.spawn["spectator"].origin - (0, 0, 50));

	braxi\_credits::main();

	players = getAllPlayers();
	for (i = 0; i < players.size; i++)
	{
		players[i] spawnSpectator(level.spawn["spectator"].origin, level.spawn["spectator"].angles);
		players[i].sessionstate = "intermission";
	}
	wait 15;

	if (!isDefined(map))
	{
		setDvar("sv_maprotationcurrent", "gametype deathrun map " + sr\commands\_map_vote::load(false)[RandomInt(sr\commands\_map_vote::load(false).size)]);
		ExitLevel(false);
	}

	if (isDefined(map))
	{
		setDvar("sv_maprotationcurrent", "gametype deathrun map " + map);
		ExitLevel(false);
	}
}

respawn()
{
	self endon("disconnect");
	self endon("spawned_player");
	self endon("joined_spectators");

	wait 0.1;
	self spawnPlayer();
	return;
}

kickAfterTime(time)
{
	self endon("disconnect");
	wait time;

	if (isDefined(self))
		kick(self getEntityNumber());
}

roundStartTimer()
{
	if (isDefined(level.matchStartText))
		level.matchStartText destroyElem();

	level.matchStartText = createServerFontString("objective", 1.5);
	level.matchStartText setPoint("CENTER", "CENTER", 0, -20);
	level.matchStartText.sort = 1001;
	level.matchStartText setText(level.text["round_begins_in"]);
	level.matchStartText.foreground = false;
	level.matchStartText.hidewheninmenu = true;

	level.matchStartTimer = createServerTimer("objective", 1.4);
	level.matchStartTimer setPoint("CENTER", "CENTER", 0, 0);
	level.matchStartTimer setTimer(level.dvar["spawn_time"]);
	level.matchStartTimer.sort = 1001;
	level.matchStartTimer.foreground = false;
	level.matchStartTimer.hideWhenInMenu = true;

	wait level.dvar["spawn_time"];

	level.matchStartText destroyElem();
	level.matchStartTimer destroyElem();
}

freeRunChoice()
{
	self endon("disconnect");
	self endon("spawned_player");
	self endon("joined_spectators");
	self endon("death");

	if (!level.dvar["freeRunChoice"] || level.trapsDisabled)
		return;

	self.hud_freeround = newClientHudElem(self);
	self.hud_freeround.elemType = "font";
	self.hud_freeround.x = 320;
	self.hud_freeround.y = 370;
	self.hud_freeround.alignX = "center";
	self.hud_freeround.alignY = "middle";
	self.hud_freeround.alpha = 1;
	self.hud_freeround.font = "default";
	self.hud_freeround.fontScale = 1.8;
	self.hud_freeround.sort = 0;
	self.hud_freeround.foreground = true;
	self.hud_freeround.label = level.text["call_freeround"];

	self.hud_freeround_time = newClientHudElem(self);
	self.hud_freeround_time.elemType = "font";
	self.hud_freeround_time.x = 320;
	self.hud_freeround_time.y = 390;
	self.hud_freeround_time.alignX = "center";
	self.hud_freeround_time.alignY = "middle";
	self.hud_freeround_time.alpha = 1;
	self.hud_freeround_time.font = "default";
	self.hud_freeround_time.fontScale = 1.8;
	self.hud_freeround_time.sort = 0;
	self.hud_freeround_time.foreground = true;
	self.hud_freeround_time setTimer(level.dvar["freeRunChoiceTime"]);

	wait 1;
	freeRun = false;
	for (i = 0; i < 10 * level.dvar["freeRunChoiceTime"]; i++)
	{
		if (!level.canCallFreeRun)
		{
			self.hud_freeround destroy();
			self.hud_freeround_time destroy();
			return;
		}
		if (self attackButtonPressed())
		{
			freeRun = true;
			level endon("kill_free_run_choice");
			break;
		}
		wait 0.1;
	}
	level endon("kill_free_run_choice");

	if (isDefined(self.hud_freeround))
		self.hud_freeround destroy();
	if (isDefined(self.hud_freeround_time))
		self.hud_freeround_time destroy();

	if (freeRun)
	{
		thread drawInformation(800, 0.8, 1, "FREE RUN");
		thread drawInformation(800, 0.8, -1, "FREE RUN");

		level disableTraps();

		players = getAllPlayers();
		for (i = 0; i < players.size; i++)
		{
			if (players[i] isPlaying())
			{
				players[i] takeAllWeapons();
				weapon = "knife_mp";
				players[i] giveWeapon(weapon);
				players[i] giveMaxAmmo(weapon);
				players[i] switchToWeapon(weapon);
			}
		}
		level notify("round_freerun");
	}
}

disableTraps()
{
	level.trapsDisabled = true;
	for (i = 0; i < level.trapTriggers.size; i++)
		if (isDefined(level.trapTriggers[i]))
		level.trapTriggers[i].origin = level.trapTriggers[i].origin - (0, 0, 10000);
	level notify("traps_disabled");
}

serverMessages()
{
	if (!level.dvar["messages_enable"])
		return;

	messages = strTok(level.dvar["messages"], ";");
	lastMessage = messages.size - 1;
	if (!isDefined(game["msg_time"]))
		game["msg_time"] = 0;
	if (!isDefined(game["msg"]))
		game["msg"] = 0;

	while (1)
	{
		if (game["msg_time"] == level.dvar["messages_delay"])
		{
			game["msg_time"] = 0;
			iPrintln("^1>>^7 " + messages[game["msg"]]);
			game["msg"]++;
			if (game["msg"] > lastMessage)
				game["msg"] = 0;
		}
		wait 1;
		game["msg_time"]++;
	}
}

isWallKnifing(attacker, victim)
{
	start = attacker getEye();
	end = victim getEye();

	if (bulletTracePassed(start, end, false, attacker) == 1)
		return false;
	return true;
}

new_ending_hud(align, fade_in_time, x_off, y_off)
{
	hud = newHudElem();
	hud.foreground = true;
	hud.x = x_off;
	hud.y = y_off;
	hud.alignX = align;
	hud.alignY = "middle";
	hud.horzAlign = align;
	hud.vertAlign = "middle";

	hud.fontScale = 3;

	hud.color = (0.8, 1.0, 0.8);
	hud.font = "objective";
	hud.glowColor = (0.3, 0.6, 0.3);
	hud.glowAlpha = 1;

	hud.alpha = 0;
	hud fadeovertime(fade_in_time);
	hud.alpha = 1;
	hud.hidewheninmenu = true;
	hud.sort = 10;
	return hud;
}

drawInformation(start_offset, movetime, mult, text)
{
	start_offset *= mult;
	hud = new_ending_hud("center", 0.1, start_offset, 90);
	hud setText(text);
	hud moveOverTime(movetime);
	hud.x = 0;
	wait (movetime);
	wait (3);
	hud moveOverTime(movetime);
	hud.x = start_offset * -1;

	wait movetime;
	hud destroy();
}

gib_splat()
{
	self playSound("gib_splat");
	playFx(level.fx["gib_splat"], self.origin + (0, 0, 20));
	self delete();
}

initScoresStat(num, name)
{
	level.bestScores[num]["name"] = name;
	level.bestScores[num]["value"] = 0;
	level.bestScores[num]["player"] = " ";
	level.bestScores[num]["guid"] = "123";
}

appendToDvar(dvar, string)
{
	setDvar(dvar, getDvar(dvar) + string);
}

watchItems()
{
	if (!level.dvar["insertion"])
		return;

	self endon("spawned_player");
	self endon("disconnect");

	insertionItem = "claymore_mp";
	self giveWeapon(insertionItem);
	self giveMaxAmmo(insertionItem);

	while (self isReallyAlive())
	{
		self waittill("grenade_fire", entity, weapName);

		if (weapName != insertionItem)
			continue;

		self giveMaxAmmo(insertionItem);

		entity.flareloop = false;
		entity StopLoopSound();
		entity waitTillNotMoving();
		pos = entity.origin;
		angle = entity.angles;

		if (!self isOnGround() || distance(self.origin, pos) > 48)
		{
			self iPrintlnBold("^1You can't use insertion here");
			entity delete();
			continue;
		}

		entity.flareloop = true;
		entity thread flarefx();
		self cleanUpInsertion();
		self.insertion = entity;

		self iPrintlnBold("^2Insertion at " + pos);
	}
}

flarefx()
{
	self endon("disconnect");

	while (isDefined(self))
	{
		if (!self.flareloop)
			break;

		if (isDefined(self))
			playFxOnTag(level.fx["startnstop"], self, "tag_fx");

		wait 0.2;
	}
}

cleanUpInsertion()
{
	if (isDefined(self.insertion))
		self.insertion delete();
}

giveLife() { }

playerTimer()
{
	self endon("disconnect");
	self endon("spawned_player");
	self endon("joined_spectators");
	self endon("death");

	if (!level.mapHasTimeTrigger || isDefined(self.finishedMap))
		return;

	while (game["state"] != "playing")
		wait 0.05;

	//timer hud moves to its own gsc
	if (!self.isBot)
		self notify("start_time_hud");

	self.timerStartTime = getTime();
}

doHudTime()
{
	level.hud_time = newHudElem();
	level.hud_time.foreground = true;
	level.hud_time.alignX = "right";
	level.hud_time.alignY = "bottom";
	level.hud_time.horzAlign = "right";
	level.hud_time.vertAlign = "bottom";
	level.hud_time.x = -10;
	level.hud_time.y = -2;
	level.hud_time.sort = 0;
	level.hud_time.fontScale = 1.4;
	level.hud_time.color = (1, 1, 1);
	level.hud_time.font = "objective";
	level.hud_time.hidewheninmenu = true;
	level.hud_time.label = &"^7&&1";
	level.hud_time.alpha = 1;
	level.hud_time.archived = false;
}

endTimer()
{
	if (isDefined(self.finishedMap))
		return;

	self.finishedMap = true;
	runtest = int(self.runNumber);

	if (self.isBot)
	{
		self notify("menuresponse", game["menu_team"], "spectator");
		level notify("bot_done");
	}

	// don't save time if in cheat mode
	if (self.sr_cheatmode || runtest == 0)
	{
		if (!self.inRace && !self.inKz)
			self iprintlnbold("^1Your time was not saved!");
		return;
	}

	if (!isDefined(level.new_leaderboard))
	{
		if (!self.sr_secret)
			self.sr_way = "ns0";
		if (self.sr_secret)
			self.sr_way = "s0";
	}

	self.time = speedrun\game\_leaderboard::realtime(getTime() - self.timerStartTime);

	self thread speedrun\game\_leaderboard::saveTimes();
	self speedrun\game\_leaderboard::loadPersonBest();
	self thread speedrun\player\_hud_speedrun::updatepbHud();
	self thread speedrun\player\_hud_speedrun::updatewrHud();
	self thread speedrun\player\_hud_speedrun::updateHud();

	if (self.time.ori < self.pers["time"])
		self.pers["time"] = self.time.ori;

	wait 0.1;

	if (self.sr_speed == 190)
	{
		if (self.sr_way == "ns0" || self.sr_way == "ns1" || self.sr_way == "ns2" || self.sr_way == "ns3" || self.sr_way == "ns4" || self.sr_way == "ns5")
		{
			number = strTok(self.sr_way, "ns");

			if (level.normal_way_info_190[int(number[0])].size > 0)
			{
				if (self.time.ori == level.normal_way_info_190[int(number[0])][0]["time"].ori)
				{
					thread wr_event(level.normal_way[int(number[0])].name, 190, self.name);
				}
			}
		}

		else if (self.sr_way == "s0" || self.sr_way == "s1" || self.sr_way == "s2" || self.sr_way == "s3" || self.sr_way == "s4" || self.sr_way == "s5")
		{
			number = strTok(self.sr_way, "s");

			if (level.secret_way_info_190[int(number[0])].size > 0)
			{
				if (self.time.ori == level.secret_way_info_190[int(number[0])][0]["time"].ori)
				{
					thread wr_event(level.secret_way[int(number[0])].name, 190, self.name);
				}
			}
		}
	}

	if (self.sr_speed == 210)
	{
		if (self.sr_way == "ns0" || self.sr_way == "ns1" || self.sr_way == "ns2" || self.sr_way == "ns3" || self.sr_way == "ns4" || self.sr_way == "ns5")
		{
			number = strTok(self.sr_way, "ns");

			if (level.normal_way_info_210[int(number[0])].size > 0)
			{
				if (self.time.ori == level.normal_way_info_210[int(number[0])][0]["time"].ori)
				{
					thread wr_event(level.normal_way[int(number[0])].name, 210, self.name);
				}
			}
		}

		else if (self.sr_way == "s0" || self.sr_way == "s1" || self.sr_way == "s2" || self.sr_way == "s3" || self.sr_way == "s4" || self.sr_way == "s5")
		{
			number = strTok(self.sr_way, "s");

			if (level.secret_way_info_210[int(number[0])].size > 0)
			{
				if (self.time.ori == level.secret_way_info_210[int(number[0])][0]["time"].ori)
				{
					thread wr_event(level.secret_way[int(number[0])].name, 210, self.name);
				}
			}
		}
	}
}

wr_event(w, s, n)
{
	player = getEntArray("player", "classname");

	iprintlnbold("^5New ^2WR ^7on ^6" + s + " ^2" + w + " ^7By ^5" + n);

	for (i = 0; i < player.size; i++)
	{
		player[i] thread wr_event_int();
	}
}

wr_event_int()
{
	self endon("disconnect");
	self endon("death");

	self playLocalSound("wr_sound");

	x = 0;

	while (1)
	{
		fx = PlayFX(level.fx["wr_event"], self.origin);
		wait 0.5;

		x++;

		if (x == 25)
			break;
	}
}

fastestTime()
{
	trig = getEntArray("endmap_trig", "targetname");

	if (!trig.size || trig.size > 1)
	{
		iPrintln("^1NO END TRIG!! CREATE ONE!");
		return;
	}

	level.mapHasTimeTrigger = true;

	trig = trig[0];

	while (1)
	{
		trig waittill("trigger", user);

		if (!user isReallyAlive())
			continue;

		user thread endTimer();
	}
}
