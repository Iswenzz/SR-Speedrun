#include sr\sys\_events;
#include sr\utils\_common;

main()
{
	menu("-1", 			"dog", 			::menu_Dog);
	menu("-1", 			"back", 		::menu_Back);
	menu("quickstuff", 	"3rdperson", 	::menu_3rdPerson);
	menu("quickstuff", 	"suicide", 		::menu_Suicide);
	menu("team_select", "allies", 		::menu_Team);
	menu("team_select", "axis", 		::menu_Team);
	menu("team_select", "autoassign", 	::menu_Team);

	menu_callback("quickcommands",	 	maps\mp\gametypes\_quickmessages::quickcommands);
	menu_callback("quickstatements", 	maps\mp\gametypes\_quickmessages::quickstatements);
	menu_callback("quickresponses",  	maps\mp\gametypes\_quickmessages::quickresponses);
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

menu_3rdPerson(arg)
{
	state = !self getStat(988);
	self iPrintln("Third Person Camera " + Ternary(state, "^2Enabled", "^1Disabled"));
	self setClientDvar("cg_thirdperson", state);
	self setStat(988, state);
}

menu_Suicide(arg)
{
	if (self sr\game\minigames\_main::isInAnyQueue() || !game["roundStarted"] || self.pers["team"] == "axis")
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

	if (self sr\game\minigames\_main::isInAnyQueue() || !game["roundStarted"] || self.pers["team"] == "axis")
	{
		self iPrintLn("^1Suicide disabled");
		return;
	}

	self sr\game\_teams::setTeam("allies");

	if (self canSpawn())
		self eventSpawn();
}
