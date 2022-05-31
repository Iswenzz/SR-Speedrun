#include braxi\_common;

init()
{
	game["menu_team"] = "team_select";
	game["menu_callvote"] = "callvote";
	game["menu_muteplayer"] = "muteplayer";
	game["menu_quickstuff"] = "quickstuff";
	game["menu_welcome"] = "sr_welcome";
	game["menu_votepopup"] = "sr_votepopup";
	game["menu_scoreboard"] = "scoreboard";

	precacheMenu(game["menu_callvote"]);
	precacheMenu(game["menu_muteplayer"]);
	precacheMenu(game["menu_scoreboard"]);
	precacheMenu(game["menu_team"]);
	precacheMenu(game["menu_quickstuff"]);
	precacheMenu(game["menu_welcome"]);
	precacheMenu(game["menu_votepopup"]);

	precacheMenu("sr_leaderboard");
	precacheMenu("sr_settings");
	precacheMenu("sr_votemap");
	precacheMenu("sr_customize");
	precacheMenu("sr_customize_area");
	precacheMenu("minesweeper");

	precacheString(&"MP_HOST_ENDED_GAME");
	precacheString(&"MP_HOST_ENDGAME_RESPONSE");

	level.playerBanned = [];

	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for (;;)
	{
		level waittill("connecting", player);

		player setClientDvar("ui_3dwaypointtext", "1");
		player.enable3DWaypoints = true;
		player setClientDvar("ui_deathicontext", "1");
		player.enableDeathIcons = true;
		player.classType = undefined;
		player.selectedClass = false;

		player thread onMenuResponse();
	}
}

onMenuResponse()
{
	self endon("disconnect");

	if (!isDefined(self.pers["failedLogins"]))
		self.pers["failedLogins"] = 0;

	for (;;)
	{
		self waittill("menuresponse", menu, response);

		if (response == "dog")
		{
			if (!self.pers["isDog"])
				self.pers["isDog"] = true;
			else
				self.pers["isDog"] = false;
		}

		if (response == "2doff")
			self setClientDvar("cg_draw2d", 0);

		if (response == "2don")
			self setClientDvar("cg_draw2d", 1);


		if (response == "back")
		{
			self closeMenu();
			self closeInGameMenu();
			continue;
		}

		if (response == "top10_leaderboard")
		{
			self CloseMenu();
			self closeInGameMenu();
			self openMenu("sr_leaderboard");
			self thread speedrun\game\_leaderboard::top10Menu();
		}

		if (response == "vote_menu")
			self thread sr\commands\_map_vote::main();

		if (menu == game["menu_welcome"])
		{
			switch (response)
			{
				case "connectmessage":
				self thread speedrun\_main::connectMessages();
				break;

			}
		}

		if (response == "checkguid")
			self sr\sys\_admins::isBanned();

		if (menu == "sr_customize" || menu == "sr_customize_area")
			self thread sr\player\_customize::executeResponse(menu, response);

		else if (response == "prestigemode")
		{
			self closeMenu();
			self closeInGameMenu();
			self thread braxi\_rank::prestigeSystem();
		}

		else if (menu == game["menu_quickstuff"])
		{
			switch (response)
			{
				case "3rdperson":
				if (self getStat(988) == 0)
				{
					self iPrintln("Third Person Camera Enabled");
					self setClientDvar("cg_thirdperson", 1);
					self setStat(988, 1);
				}
				else
				{
					self iPrintln("Third Person Camera Disabled");
					self setClientDvar("cg_thirdperson", 0);
					self setStat(988, 0);
				}
				break;


				case "suicide":
				if (self.inRace || self.inKz)
				{
					self iPrintln("^1Suicide disabled");
					continue;
				}

				if (!game["roundStarted"])
					continue;
				if (self.pers["team"] == "allies")
					self suicide();
				else
					self iPrintln("^1Suicide disabled");
				break;

				case "laser":
				if (self getStat(977) == 0)
				{
					self iPrintln("Laser ^2Enabled");
					self setClientDvar("cg_laserForceOn", 1);
					self setStat(977, 1);
				}
				else
				{
					self iPrintln("Laser ^1Disabled");
					self setClientDvar("cg_laserForceOn", 0);
					self setStat(977, 0);
				}
				break;

			}
		}

		else if (menu == game["menu_team"])
		{
			switch (response)
			{
				case "allies":
				case "axis":
				case "autoassign":
				self closeMenu();

				self closeInGameMenu();
				if (self.inRace || self.inKz)
				{
					self iPrintLn("^1Suicide disabled.");
					continue;
				}
				if (self.pers["team"] == "axis")
					continue;

				self braxi\_teams::setTeam("allies");
				if (self.pers["team"] == "allies" && self.sessionstate != "playing" && self.pers["lifes"])
					continue;
				if (self.sessionstate == "playing" || game["state"] == "round ended")
					continue;

				if (self canSpawn())
					self braxi\_mod::spawnPlayer();
				break;

				case "spectator":
				self closeMenu();

				self closeInGameMenu();
				if (self.pers["team"] == "axis" || self.inRace || self.inKz)
				{
					self iPrintln("^1Suicide disabled.");
					continue;
				}
				self braxi\_teams::setTeam("spectator");
				self braxi\_mod::spawnSpectator(level.spawn["spectator"].origin, level.spawn["spectator"].angles);
				if (self.pers["spec_hud"] == 1)
					self thread speedrun\player\_hud_spectator::hud();
				self thread speedrun\player\_hud_cheat::spec();
				break;

				case "sr_customize":
				self closeMenu();

				self closeInGameMenu();
				self openMenu("sr_customize");
				break;
			}
		}
		else if (!level.console)
		{
			if (menu == game["menu_quickcommands"])
				maps\mp\gametypes\_quickmessages::quickcommands(response);
			else if (menu == game["menu_quickstatements"])
				maps\mp\gametypes\_quickmessages::quickstatements(response);
			else if (menu == game["menu_quickresponses"])
				maps\mp\gametypes\_quickmessages::quickresponses(response);
		}
	}
}
