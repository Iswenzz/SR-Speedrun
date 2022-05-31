#include sr\sys\_common;
#include sr\game\_leaderboard;

init()
{
	level waittill("round_started");
	level endon("intermission");
	level endon("game over");

	mapname = getDvar("mapname");

	bot = AddTestClient();
	bot.isBot = true;
	bot.sr_cheatmode = true;

	while (1)
	{
		thread bot_run(bot);
		level waittill("bot_done");
	}
}

bot_search_path()
{
	mapname = getDvar("mapname");
	file_exists = checkfile("./sr/data/speedrun/txt_demos/" + mapname + "/WR.txt");

	if (!file_exists)
	{
		WriteToFile("./sr/data/speedrun/txt_demos/" + mapname + "/WR.txt", "");
		WriteToFile("./sr/data/speedrun/txt_demos/" + mapname + "/WR_190_ns.txt", "");
		WriteToFile("./sr/data/speedrun/txt_demos/" + mapname + "/WR_190_s.txt", "");
		WriteToFile("./sr/data/speedrun/txt_demos/" + mapname + "/WR_210_ns.txt", "");
		WriteToFile("./sr/data/speedrun/txt_demos/" + mapname + "/WR_210_s.txt", "");
	}

	path_190_ns = "./sr/data/speedrun/txt_demos/" + mapname + "/WR_190_ns.txt";
	path_190_ns_read = readAll(path_190_ns);
	path_190_s = "./sr/data/speedrun/txt_demos/" + mapname + "/WR_190_s.txt";
	path_190_s_read = readAll(path_190_s);
	path_210_ns = "./sr/data/speedrun/txt_demos/" + mapname + "/WR_210_ns.txt";
	path_210_ns_read = readAll(path_210_ns);
	path_210_s = "./sr/data/speedrun/txt_demos/" + mapname + "/WR_210_s.txt";
	path_210_s_read = readAll(path_210_s);

	if (isStringInt(path_190_ns_read[0]) && path_190_ns_read[0] != "")
		level.bot_190_ns_path = int(path_190_ns_read[0]);
	if (isStringInt(path_190_s_read[0]) && path_190_s_read[0] != "")
		level.bot_190_s_path = int(path_190_s_read[0]);
	if (isStringInt(path_210_ns_read[0]) && path_210_ns_read[0] != "")
		level.bot_210_ns_path = int(path_210_ns_read[0]);
	if (isStringInt(path_210_s_read[0]) && path_210_s_read[0] != "")
		level.bot_210_s_path = int(path_210_s_read[0]);
}

bot_run(bot)
{
	// if(!isDefined(level.bot_curr_path))
	// {
	// 	wait 0.1;
	// 	level notify("bot_done");
	// 	return;
	// }

	level endon("intermission");
	level endon("game over");
	level endon("bot_done");

	path = level.bot_curr_path;
	sync = 0;

	wait 1;

	bot notify("menuresponse", game["menu_team"], "axis");
	wait 0.1;

	bot hide();
	bot.runNumber = "^5Speedrun Bot";
	bot.sr_cheatmode = true;

	// bot speedrunBOT(path);
	mapname = getDvar("mapname");
	// bot speedrunBOT("./sr/data/speedrun/txt_demos/"+mapname+"/test.txt");
	// bot bot_gsc_test("./sr/data/speedrun/txt_demos/"+mapname+"/test.txt");

	wait 2;

	self notify("menuresponse", game["menu_team"], "spectator");
	level notify("bot_done");
}

bot_gsc_test(path)
{
	if (!checkfile(path))
	{
		IPrintLn("^1SPEEDRUN BOT PATH FAIL");
		return;
	}

	lines = readAll(path);
	iPrintLnBold(lines.size);
}

bot_step_sfx(bot)
{
	bot endon("death");
	bot endon("disconnect");

	wait 0.20;
	bot PlaySoundToPlayer("gear_rattle_plr_sprint", bot);
}

record_txt()
{
	if (self.isBot || !isDefined(self.bot_record))
		return;

	self notify("demos_txt");
	wait 0.05;
	self endon("demos_txt");
	self endon("disconnect");
	self endon("death");

	mapname = getDvar("mapname");
	if (mapname.size > 17)
		mapname = GetSubStr(mapname, mapname.size - 17, mapname.size);
	path = "./sr/data/speedrun/txt_demos/" + mapname + "/" + self.runNumber + ".txt";
}
