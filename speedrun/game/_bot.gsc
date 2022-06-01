init()
{
	start();
}

start()
{
	level endon("intermission");
	level endon("game over");

	while (true)
	{
		bot = AddTestClient();
		bot.isBot = true;
		bot.sr_cheatmode = true;
		bot.runNumber = "^5Speedrun Bot";
		bot notify("menuresponse", game["menu_team"], "axis");

		wait 0.1;
		bot hide();

		wait 2;

		self notify("menuresponse", game["menu_team"], "spectator");
	}
}

step()
{
	self endon("death");
	self endon("disconnect");

	wait 0.20;
	self playSoundToPlayer("gear_rattle_plr_sprint", self);
}
