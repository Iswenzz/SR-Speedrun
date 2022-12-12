CodeCallback_StartGameType()
{
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

	level.iDFLAGS_RADIUS				= 1;
	level.iDFLAGS_NO_ARMOR				= 2;
	level.iDFLAGS_NO_KNOCKBACK			= 4;
	level.iDFLAGS_PENETRATION			= 8;
	level.iDFLAGS_NO_TEAM_PROTECTION 	= 16;
	level.iDFLAGS_NO_PROTECTION			= 32;
	level.iDFLAGS_PASSTHRU				= 64;

	printLn("^5===================================");
	printLn("^5SR Mod (c) Iswenzz 2016-2022");
	printLn("^5Visit: iswenzz.com" );
	printLn("^5===================================");

	setDvar("g_gametype", "deathrun");

	speedrun\_tests::runTests();

	if (level.gscunit.enabled)
		return;

	if (!isDefined(level.gametypestarted) || !level.gametypestarted)
	{
		if (isDefined(level.callbackStartGameType))
			[[level.callbackStartGameType]]();
		level.gametypestarted = true;
	}
}

CodeCallback_PlayerSpawned()
{
	self endon("disconnect");

	while (true)
	{
		self waittill("spawned_player");

		self.team = self.pers["team"];
		self.sessionteam = self.team;
		self.sessionstate = "playing";
		self.spectatorclient = -1;
		self.killcamentity = -1;
		self.archivetime = 0;
		self.psoffsettime = 0;

		for (i = 0; isDefined(level.events["spawn"]) && i < level.events["spawn"].size; i++)
			self thread [[level.events["spawn"][i]]]();

		self notify("end_spawned_player");
	}
}

CodeCallback_PlayerSpectator()
{
	self endon("disconnect");

	while (true)
	{
		self waittill("joined_spectators");

		self.sessionstate = "spectator";
		self.spectatorclient = -1;

		for (i = 0; isDefined(level.events["spectator"]) && i < level.events["spectator"].size; i++)
			self thread [[level.events["spectator"][i]]]();

		self notify("end_joined_spectators");
	}
}

CodeCallback_PlayerTeam()
{
	self endon("disconnect");

	while (true)
	{
		self waittill("joined_team");

		for (i = 0; isDefined(level.events["team"]) && i < level.events["team"].size; i++)
			self thread [[level.events["team"][i]]]();
	}
}

CodeCallback_PlayerConnect()
{
	if (level.gscunit.enabled)
		return;

	self endon("disconnect");
	self waittill("begin");
	level notify("connecting", self);

	self.team = "spectator";
	self.pers["team"] = "spectator";
	self.sessionstate = Ternary(game["state"] == "endmap", "intermission", "spectator");
	self.run = 0;

	self thread CodeCallback_PlayerSpawned();
	self thread CodeCallback_PlayerSpectator();
	self thread CodeCallback_PlayerTeam();

	for (i = 0; isDefined(level.events["connect"]) && i < level.events["connect"].size; i++)
		self thread [[level.events["connect"][i]]]();
}

CodeCallback_PlayerDisconnect()
{
	if (level.gscunit.enabled)
		return;

	self notify("disconnect");

	for (i = 0; isDefined(level.events["disconnect"]) && i < level.events["disconnect"].size; i++)
		self thread [[level.events["disconnect"][i]]]();
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

	self.sessionstate = "dead";

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
	println("Aborting level - gametype is not supported");
	setDvar("g_gametype", "deathrun");
	exitLevel(false);
}
