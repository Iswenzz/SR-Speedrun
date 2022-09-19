#include sr\sys\_events;
#include sr\utils\_common;

main()
{
	event("spawn",		::playerSpawn);
	event("connect", 	::playerConnect);
	event("disconnect", ::playerDisconnect);
	event("laststand", 	::playerLastStand);
	event("damage", 	::playerDamage);
	event("killed", 	::playerKilled);
	event("spectator",	::playerSpectator);

	level.allies 	= ::allies;
	level.axis 		= ::axis;
	level.spectator = ::spectator;
}

playerConnect()
{
	self endon("disconnect");
	level notify("connected", self);

	self clientCmd("setu sr_xp_bar 0");
	self clientCmd("setu com_maxfps 125");

	self.enable3DWaypoints = true;
	self.enableDeathIcons = true;
	self.classType = undefined;
	self.selectedClass = false;
	self.teamKill = false;
	self.timePlayed = getTime();
	self.shortName = getSubStr(self.name, 0, 15);
	self.number = self getEntityNumber();
	self.statusicon = "hud_status_connecting";
	self.died = false;
	self.pers["score"] = 0;
	self.pers["kills"] = 0;
	self.pers["deaths"] = 0;
	self.pers["assists"] = 0;
	self.pers["lifes"] = 0;
	self.pers["headshots"] = 0;
	self.pers["knifes"] = 0;
	self.pers["activator"] = 0;
	self.pers["isDog"] = false;
	self.score = self.pers["score"];
	self.kills = self.pers["kills"];
	self.assists = self.pers["assists"];
	self.deaths = self.pers["deaths"];
	self.viewKick = true;

	logPrint(fmt("J;%s;%d;%s\n", self.guid, self.number, self.name));

	if (game["state"] == "endmap")
		return;

	self eventSpectator();
	self welcomeMenu();

	wait 3;

	wait 0.05;
	self setClientDvar("ui_3dwaypointtext", "1");
	self setClientDvar("ui_deathicontext", "1");
	self setClientDvar("cl_maxpackets", 125);
	self setClientDvar("rate", 25000);
	self setClientDvar("show_hud", "true");
	self setClientDvar("ip", getDvar("net_ip"));
	wait 0.05;
	self setClientDvar("port", getDvar("net_port"));
	self setClientDvar("cg_drawSpectatorMessages", 1);
	self setClientDvar("ui_hud_hardcore", 1);
	self setClientDvar("player_sprintTime", 4);
	self setClientDvar("ui_uav_client", 0);
	self setClientDvar("g_scriptMainMenu", "team_select");
}

playerDisconnect()
{
	level notify("disconnected", self);
	self cleanUp();

	if (isDefined(self.clone))
		self.clone delete();

	if (isDefined(self.timePlayed))
	{
		time = originToTime(getTime() - self.timePlayed);
		self setStat(2631, self getStat(2631) + time.min);
	}

	iPrintln(self.name + " ^7left the game");
	logPrint(fmt("Q;%s;%d;%s\n", self.guid, self.number, self.name));
}

playerLastStand(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	self suicide();
}

playerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime)
{
	if (self.sessionteam == "spectator" || game["state"] == "endmap")
		return;

	level notify("player_damage", self, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);

	if (isPlayer(self) && isPlayer(eAttacker) && self.pers["team"] != eAttacker.pers["team"])
		return;
	if (isPlayer(self) && isPlayer(eAttacker) && self.pers["team"] == eAttacker.pers["team"] && !eAttacker.teamKill)
		return;
	if (isPlayer(self) && isDefined(self.godmode))
		return;
	if (isPlayer(eAttacker) && sMeansOfDeath == "MOD_MELEE" && isWallKnifing(eAttacker, self))
		return;
	if (self.sr_mode == "Defrag" && sMeansOfDeath == "MOD_FALLING")
		return;

	if (!isDefined(vDir))
		iDFlags |= level.iDFLAGS_NO_KNOCKBACK;

	if (!(iDFlags & level.iDFLAGS_NO_PROTECTION))
	{
		if (iDamage < 1)
			iDamage = 1;

		self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
	}
}

playerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	self endon("spawned");
	self notify("killed_player");
	self notify("death");

	if (self.sessionteam == "spectator" || game["state"] == "endmap")
		return;

	level notify("player_killed", self, eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration);

	if (level.dvar["giveXpForKill"] && !level.trapsDisabled)
	{
		if (isDefined(level.activ) && level.activ != self && level.activ isReallyAlive())
		{
			if (sMeansOfDeath == "MOD_UNKNOWN" || sMeansOfDeath == "MOD_FALLING" || sMeansOfDeath == "MOD_SUICIDE")
				level.activ sr\game\_rank::giveRankXP("jumper_died");
		}
	}
	if (sHitLoc == "head" && sMeansOfDeath != "MOD_MELEE")
		sMeansOfDeath = "MOD_HEAD_SHOT";

	self.statusicon = "hud_status_dead";
	self.sessionstate = "spectator";
	self.died = true;

	self thread ragdoll(sHitLoc, vDir, sWeapon, eInflictor, sMeansOfDeath, deathAnimDuration);

	if (self.pers["team"] == "allies" && self canSpawn())
		self eventSpawn();
}

playerSpawn()
{
	if (game["state"] == "endmap")
		return;

	level notify("jumper", self);
	self cleanUp();

	self.statusicon = Ternary(self sr\sys\_admins::isVIP(), "vip_status", "");
	self.finishedMap = false;

	self sr\game\_teams::setPlayerModel();
	self sr\game\_teams::setHealth();
	spawn = IfUndef(self.spawnPoint, level.masterSpawn);
	self spawn(spawn.origin, spawn.angles);
	self.spawnPoint = undefined;

	self.pers["weapon"] = level.assets["weapon"][self getStat(981)]["item"];
	self.pers["knife"] = level.assets["knife"][self getStat(982)]["item"];
	self.pers["knife_skin"] = int(level.assets["knife_skin"][self getStat(983)]["item"]);

	if (self.model == "german_sheperd_dog")
		self.pers["weapon"] = "dog_mp";

	weapon = Ternary(!self.settings["player_knife"], self.pers["weapon"], self.pers["knife"]);
	if (!self.settings["player_knife"])
		self giveWeapon(self.pers["knife"], self.pers["knife_skin"]);
	self giveWeapon(weapon);
	self setSpawnWeapon(weapon);
	self giveMaxAmmo(weapon);

	if (sr\api\_speedrun::isCJ())
	{
		self setActionSlot(4, "weapon", "rpg_mp");
		self giveWeapon("rpg_mp");
		self giveMaxAmmo("rpg_mp");
	}
	if (game["state"] == "readyup")
	{
		self freezeControls(true);
		self disableWeapons();
	}
	if (self getStat(988) == 1)
		self setClientDvar("cg_thirdperson", 1);

	level notify("player_spawn", self);
}

playerSpectator()
{
	self endon("disconnect");
	self sr\game\_map::spawnSpectator();
	level notify("player_spectator", self);
}

isWallKnifing(attacker, victim)
{
	start = attacker getEye();
	end = victim getEye();

	if (bulletTracePassed(start, end, false, attacker) == 1)
		return false;
	return true;
}

welcomeMenu()
{
	self endon("disconnect");
	wait 0.05;

	if (!isDefined(self.canplay))
	{
		self.canplay = true;
		self openMenu("sr_welcome");
	}
	else
		self openMenu("team_select");
}

allies()
{
	self sr\game\_teams::setTeam("allies");
}

axis()
{
	self sr\game\_teams::setTeam("axis");
}

spectator()
{
	self sr\game\_teams::setTeam("spectator");
}
