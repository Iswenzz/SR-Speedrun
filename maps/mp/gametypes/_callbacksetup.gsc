CodeCallback_StartGameType()
{
	println("^5===================================");
	println("^5SR Mod (c) Iswenzz 2016-2022");
	println("^5Visit: iswenzz.com" );
	println("^5===================================");

	setdvar("g_gametype", "deathrun");

	if(!isDefined(level.gametypestarted) || !level.gametypestarted)
	{
		[[level.callbackStartGameType]]();
		level.gametypestarted = true;
	}
}

CodeCallback_PlayerConnect()
{
	self endon("disconnect");
	[[level.callbackPlayerConnect]]();
}

CodeCallback_PlayerDisconnect()
{
	self notify("disconnect");
	[[level.callbackPlayerDisconnect]]();
}

CodeCallback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset)
{
	self endon("disconnect");
	[[level.callbackPlayerDamage]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset);
}

CodeCallback_PlayerKilled(eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, timeOffset, deathAnimDuration)
{
	self endon("disconnect");
	[[level.callbackPlayerKilled]](eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, timeOffset, deathAnimDuration);
}

CodeCallback_PlayerLastStand(eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, timeOffset, deathAnimDuration)
{
	self endon("disconnect");
	[[level.callbackPlayerLastStand]](eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, timeOffset, deathAnimDuration);
}

CodeCallback_ScriptCommand(cmd, arg)
{
	self thread sr\sys\_admins::command(cmd, arg);
}

SetupCallbacks()
{
	SetDefaultCallbacks();

	level.iDFLAGS_RADIUS				= 1;
	level.iDFLAGS_NO_ARMOR				= 2;
	level.iDFLAGS_NO_KNOCKBACK			= 4;
	level.iDFLAGS_PENETRATION			= 8;
	level.iDFLAGS_NO_TEAM_PROTECTION 	= 16;
	level.iDFLAGS_NO_PROTECTION			= 32;
	level.iDFLAGS_PASSTHRU				= 64;
}

SetDefaultCallbacks()
{
	level.callbackStartGameType = ::callbackVoid;
	level.callbackPlayerConnect = ::callbackVoid;
	level.callbackPlayerDisconnect = ::callbackVoid;
	level.callbackPlayerDamage = ::callbackVoid;
	level.callbackPlayerKilled = ::callbackVoid;
	level.callbackPlayerLastStand = ::callbackVoid;
}

AbortLevel()
{
	println("Aborting level - gametype is not supported");

	level.callbackStartGameType = ::callbackVoid;
	level.callbackPlayerConnect = ::callbackVoid;
	level.callbackPlayerDisconnect = ::callbackVoid;
	level.callbackPlayerDamage = ::callbackVoid;
	level.callbackPlayerKilled = ::callbackVoid;
	level.callbackPlayerLastStand = ::callbackVoid;

	setdvar("g_gametype", "deathrun");

	exitLevel(false);
}

callbackVoid() { }
