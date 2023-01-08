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

	self.enable3DWaypoints = true;
	self.enableDeathIcons = true;
	self.classType = undefined;
	self.selectedClass = false;
	self.teamKill = false;
	self.hidden = false;
	self.shortName = getSubStr(self.name, 0, 15);
	self.number = self getEntityNumber();
	self.statusicon = "hud_status_connecting";
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

	logPrint(fmt("J;%s;%d;%s\n", self.guid, self.number, self.name));

	if (game["state"] == "endmap")
		return;

	self setu("sr_xp_bar", "0");
	self setu("sr_vote_search", "_");

	self setClientDvar("g_scriptMainMenu", "main_mp");
	wait 0.05;

	if (isDefined(self.pers["joined"]))
	{
		self eventSpawn();
		return;
	}
	self.pers["joined"] = true;

	self openMenu("main_mp");
	self welcome();
	self eventSpectator();

	wait 3;
	self setClientDvars(
		"ui_3dwaypointtext", "1",
		"ui_deathicontext", "1",
		"cl_maxpackets", 125,
		"rate", 25000,
		"ip", getDvar("net_ip"),
		"port", getDvar("net_port")
	);
	wait 0.05;
	self setClientDvars(
		"show_hud", "true",
		"cg_drawSpectatorMessages", 1,
		"ui_hud_hardcore", 1,
		"player_sprintTime", 4,
		"ui_uav_client", 0
	);
}

playerDisconnect()
{
	level notify("disconnected", self);
	self cleanUp();

	if (isDefined(self.clone))
		self.clone delete();

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

	if (isDefined(self) && !(iDFlags & level.iDFLAGS_NO_PROTECTION))
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
	self spawnPlayer();

	self.pers["weapon"] = level.assets["weapon"][self getStat(981)]["item"];
	self.pers["knife"] = level.assets["knife"][self getStat(982)]["item"];
	self.pers["knife_skin"] = int(level.assets["knife_skin"][self getStat(983)]["item"]);

	if (self.model == "german_sheperd_dog")
		self.pers["weapon"] = "dog_mp";

	if (self.settings["player_knife"])
	{
		self giveWeapon(self.pers["knife"], self.pers["knife_skin"]);
		self setSpawnWeapon(self.pers["knife"]);
		self giveMaxAmmo(self.pers["knife"]);
	}
	else
	{
		self giveWeapon(self.pers["knife"], self.pers["knife_skin"]);
		self giveWeapon(self.pers["weapon"]);
		self setSpawnWeapon(self.pers["weapon"]);
		self giveMaxAmmo(self.pers["weapon"]);
	}

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
	if (self getStat(988))
		self setClientDvar("cg_thirdperson", 1);

	level notify("player_spawn", self);
}

playerSpectator()
{
	self endon("disconnect");

	self cleanUp();
	self spawnSpectator();
	self sr\game\_teams::setSpectatePermissions();

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

welcome()
{
	level loading("admins");

	role = self sr\sys\_admins::getRoleName();
	geo = self getGeoLocation(2);

	sr\sys\_admins::message(fmt("^2Welcome ^7%s ^7%s ^7from ^1%s", role, self.name, geo));
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
