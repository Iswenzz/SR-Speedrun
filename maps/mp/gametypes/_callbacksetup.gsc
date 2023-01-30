#include sr\utils\_common;

start()
{
	printLn("^5===================================");
	printLn("^5SR Mod (c) Iswenzz 2016-2023");
	printLn("^5iswenzz.com" );
	printLn("^5===================================");

	GSCLIB_Init();

	sr\sys\_dvar::reset();

	level.scriptusage = debug_scriptusage();
	level.script = toLower(getDvar("mapname"));
	level.gametype = toLower(getDvar("g_gametype"));
	level.splitscreen = isSplitScreen();
	level.xenon = false;
	level.ps3 = false;
	level.onlineGame = true;
	level.console = false;
	level.rankedMatch = getDvarInt("sv_pure");
	level.teamBased = true;
	level.oldschool = false;
	level.gameEnded = false;
	level.map = getDvar("mapname");

	level.iDFLAGS_RADIUS = 1;
	level.iDFLAGS_NO_ARMOR = 2;
	level.iDFLAGS_NO_KNOCKBACK = 4;
	level.iDFLAGS_PENETRATION = 8;
	level.iDFLAGS_NO_TEAM_PROTECTION = 16;
	level.iDFLAGS_NO_PROTECTION = 32;
	level.iDFLAGS_PASSTHRU = 64;

	game["state"] = "start";
	if (!isDefined(game["allies"]))
		game["allies"] = "marines";
	if (!isDefined(game["axis"]))
		game["axis"] = "opfor";

	speedrun\_tests::runTests();

	if (level.gscunit.enabled)
		return;

	speedrun\_mod::main();
}

CodeCallback_StartGameType()
{
	if (level.gscunit.enabled)
		return;

	for (i = 0; isDefined(level.events["map"]) && i < level.events["map"].size; i++)
		self thread [[level.events["map"][i]]]();
}

CodeCallback_PlayerDamaged()
{
	self endon("connect");
	self endon("disconnect");

	while (true)
	{
		self waittill("damage", eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);

		self CodeCallback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
	}
}

CodeCallback_PlayerSpawned()
{
	self endon("connect");
	self endon("disconnect");

	while (true)
	{
		self waittill("spawned");

		self.team = self.pers["team"];
		self.sessionteam = self.team;
		self.sessionstate = "playing";
		self.spectatorclient = -1;
		self.killcamentity = -1;
		self.archivetime = 0;
		self.psoffsettime = 0;
		self.sr_cheat = true;

		for (i = 0; isDefined(level.events["spawn"]) && i < level.events["spawn"].size; i++)
			self thread [[level.events["spawn"][i]]]();

		self notify("spawned_after");
	}
}

CodeCallback_PlayerSpectator()
{
	self endon("connect");
	self endon("disconnect");

	while (true)
	{
		self waittill("joined_spectators");

		self.sessionstate = "spectator";
		self.spectatorclient = -1;

		for (i = 0; isDefined(level.events["spectator"]) && i < level.events["spectator"].size; i++)
			self thread [[level.events["spectator"][i]]]();

		self notify("joined_spectators_after");
	}
}

CodeCallback_PlayerTeam()
{
	self endon("connect");
	self endon("disconnect");

	while (true)
	{
		self waittill("joined_team");

		for (i = 0; isDefined(level.events["team"]) && i < level.events["team"].size; i++)
			self thread [[level.events["team"][i]]]();

		self notify("joined_team_after");
	}
}

CodeCallback_PlayerConnect()
{
	if (level.gscunit.enabled)
		return;

	self endon("disconnect");
	self waittill("begin");
	self notify("connected");
	level notify("connecting", self);

	self.shortName = getSubStr(self.name, 0, 15);
	self.guid = getSubStr(self getGuid(), 24, 32);
	self.number = self getEntityNumber();
	self.team = IfUndef(self.pers["team"], "spectator");
	self.sessionteam = self.team;
	self.pers["team"] = self.team;
	self.sessionstate = Ternary(game["state"] == "endmap", "intermission", "spectator");
	self.statusicon = "hud_status_connecting";
	self.died = false;

	self setClientDvar("g_scriptMainMenu", "main_mp");

	self thread CodeCallback_PlayerSpawned();
	self thread CodeCallback_PlayerSpectator();
	self thread CodeCallback_PlayerTeam();
	self thread CodeCallback_PlayerDamaged();

	for (i = 0; isDefined(level.events["connect"]) && i < level.events["connect"].size; i++)
		self thread [[level.events["connect"][i]]]();

	if (self isFirstConnection())
	{
		for (i = 0; isDefined(level.events["connected"]) && i < level.events["connected"].size; i++)
			self thread [[level.events["connected"][i]]]();
	}
	comPrintLn(fmt("[Info] %s", removeColorFromString(self sr\sys\_admins::getPlayerInfo())));

	self.pers["connected"] = true;
	self notify("connecting_after");
}

CodeCallback_PlayerDisconnect()
{
	if (level.gscunit.enabled)
		return;

	self notify("disconnect");

	for (i = 0; isDefined(level.events["disconnect"]) && i < level.events["disconnect"].size; i++)
		self thread [[level.events["disconnect"][i]]]();

	iPrintln(self.name + " ^7left the game");
}

CodeCallback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset)
{
	self endon("disconnect");

	for (i = 0; isDefined(level.events["damage"]) && i < level.events["damage"].size; i++)
		self thread [[level.events["damage"][i]]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset);
}

CodeCallback_PlayerKilled(eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, timeOffset, deathAnimDuration)
{
	self endon("disconnect");

	self.statusicon = "hud_status_dead";
	self.sessionstate = "dead";
	self.died = true;

	for (i = 0; isDefined(level.events["killed"]) && i < level.events["killed"].size; i++)
		self thread [[level.events["killed"][i]]](eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, timeOffset, deathAnimDuration);
	for (i = 0; isDefined(level.events["death"]) && i < level.events["death"].size; i++)
		self thread [[level.events["death"][i]]]();
}

CodeCallback_PlayerLastStand(eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, timeOffset, deathAnimDuration)
{
	self endon("disconnect");

	for (i = 0; isDefined(level.events["laststand"]) && i < level.events["laststand"].size; i++)
		self thread [[level.events["laststand"][i]]](eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, timeOffset, deathAnimDuration);
}

CodeCallback_ScriptCommand(cmd, arg)
{
	if (level.gscunit.enabled)
		return;

	self endon("disconnect");

	for (i = 0; isDefined(level.events["command"]) && i < level.events["command"].size; i++)
		self thread [[level.events["command"][i]]](cmd, arg);
}

AbortLevel()
{
	println("Gametype is not supported");
	setDvar("g_gametype", "deathrun");
	exitLevel(false);
}
