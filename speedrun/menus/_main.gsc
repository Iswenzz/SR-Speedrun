#include sr\sys\_events;
#include sr\utils\_common;

main()
{
	precache();

	menu("-1", 			"dog", 			::menu_Dog);
	menu("-1", 			"back", 		::menu_Back);
	menu("-1", 			"tu", 			::menu_TAS);
	menu("quickstuff", 	"3rdperson", 	::menu_3rdPerson);
	menu("quickstuff", 	"suicide", 		::menu_Suicide);
	menu("quickstuff", 	"laser", 		::menu_Laser);
	menu("main_mp", 	"allies", 		::menu_Team);
	menu("main_mp", 	"axis", 		::menu_Team);
	menu("main_mp", 	"autoassign", 	::menu_Team);
	menu("main_mp", 	"spectator", 	::menu_Spectator);

	menu_multiple("sr_modes",  "mode",	::menu_Modes);

	menu_callback("quickcommands",	 	maps\mp\gametypes\_quickmessages::quickcommands);
	menu_callback("quickstatements", 	maps\mp\gametypes\_quickmessages::quickstatements);
	menu_callback("quickresponses",  	maps\mp\gametypes\_quickmessages::quickresponses);

	game["menu_main"] = "main_mp";
}

precache()
{
	precacheMenu("main/main_mp");
	precacheMenu("main/sr_about");
	precacheMenu("main/sr_customize");
	precacheMenu("main/sr_leaderboard");
	precacheMenu("main/sr_modes");
	precacheMenu("main/sr_votemap");
	precacheMenu("commands/wm_quickmessage");
	precacheMenu("commands/quickcommands");
	precacheMenu("commands/quickresponses");
	precacheMenu("commands/quickstatements");
	precacheMenu("commands/quickstuff");
	precacheMenu("options/sr_settings");
	precacheMenu("controls/controls_multi");
	precacheMenu("popups/exit");
	precacheMenu("misc/clientcmd");
	precacheMenu("misc/endofgame");
	precacheMenu("misc/scoreboard");
	precacheMenu("misc/muteplayer");

	precacheMenu("about_page_1");
}

menu_Modes(arg)
{
	self closeMenu();
	self closeInGameMenu();

	mode = arg[1];
	self setStat(1700, int(mode));
	self suicide();

	if (self canSpawn())
		self eventSpawn();
}

menu_Dog(arg)
{
	self.pers["isDog"] = !self.pers["isDog"];
}

menu_Back(arg)
{
	self closeMenu();
	self closeInGameMenu();
}

menu_TAS(arg)
{
	if (sr\sys\_admins::isTAS())
		return;

	self cheat();
	self.cheating = true;
	sr\sys\_admins::tas(self.id, true);

	self reconnect();
}

menu_3rdPerson(arg)
{
	state = !self getStat(988);
	self iPrintln("Third Person Camera " + Ternary(state, "^2Enabled", "^1Disabled"));
	self setClientDvar("cg_thirdperson", state);
	self setStat(988, state);
}

menu_Suicide(arg)
{
	if (self isAxis())
	{
		self iPrintLn("^1Suicide disabled");
		return;
	}
	self suicide();
}

menu_Laser(arg)
{
	state = !self getStat(977);
	self iPrintln("Laser " + Ternary(state, "^2Enabled", "^1Disabled"));
	self setClientDvar("cg_laserForceOn", state);
	self setStat(977, state);
}

menu_Team(arg)
{
	self closeMenu();
	self closeInGameMenu();

	if (game["state"] == "end")
		return;

	if (self.pers["team"] == "axis")
	{
		self iPrintLn("^1Suicide disabled");
		return;
	}
	self sr\core\_teams::setTeam("allies");

	if (self.settings["player_help_menus"])
		self openMenu("sr_modes");
	else if (self canSpawn())
		self eventSpawn();
}

menu_Spectator(arg)
{
	self closeMenu();
	self closeInGameMenu();

	if (game["state"] == "end")
		return;

	if(self isAxis())
	{
		self iPrintln("^1Nice try.");
		return;
	}
	self sr\core\_teams::setSpectator();
}
