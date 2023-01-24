main()
{
	sr\sys\_dvar::reset();

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

	level.iDFLAGS_RADIUS				= 1;
	level.iDFLAGS_NO_ARMOR				= 2;
	level.iDFLAGS_NO_KNOCKBACK			= 4;
	level.iDFLAGS_PENETRATION			= 8;
	level.iDFLAGS_NO_TEAM_PROTECTION 	= 16;
	level.iDFLAGS_NO_PROTECTION			= 32;
	level.iDFLAGS_PASSTHRU				= 64;

	game["state"] = "start";
	if (!isDefined(game["allies"]))
		game["allies"] = "marines";
	if (!isDefined(game["axis"]))
		game["axis"] = "opfor";

	speedrun\_tests::runTests();

	if (level.gscunit.enabled)
		return;

	speedrun\_mod::main();

	allowed = [];
	maps\mp\gametypes\_gameobjects::main(allowed);
}
