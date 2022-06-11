#include sr\sys\_events;
#include sr\utils\_common;

initLeaderboards()
{
	level.leaderboards = [];
	level.leaderboard_modes = [];
	level.leaderboard_max_page = 7;
	level.leaderboard_max_entries = 30;
	level.leaderboard_loaded = true;
	level.leaderboard_xps = xpTable();

	addMode("190", ::mode_190);
	addMode("210", ::mode_210);

	menu("sr_leaderboard", "open", ::menu_Open);
	menu_multiple("sr_leaderboard", "way", ::menu_Leaderboard);
	menu_multiple("sr_leaderboard", "mode", ::menu_Mode);

	event("connect", ::onConnect);
	event("spawn", ::onSpawn);

	load();
	thread endmapTrig();
}

menu_Open(arg)
{
	self.leaderboard_way = self.sr_way;
	self.leaderboard_mode = self.sr_mode;

	self display();
}

menu_Leaderboard(args)
{
	way = args[1];

	self.leaderboard_way = way;
	self display();
}

menu_Mode(args)
{
	mode = args[1];

	self.leaderboard_mode = mode;
	self display();
}

mode_190()
{
	if (sr\api\_speedrun::isSlide())
	{
		self setMoveSpeedScale(1.0);
		self setGravity(1000);
		self setJumpHeight(70);
		self setMoveSpeed(190 * level.map_slide_multiplier);
		return;
	}
	self setMoveSpeed(190);
	self setMoveSpeedScale(1.05);
	self setgravity(800);

	self setMoveSpeed(500); // @TODO remove
}

mode_210()
{
	if (sr\api\_speedrun::isSlide())
	{
		self setMoveSpeedScale(1.8);
		self setGravity(1000);
		self setJumpHeight(70);
		self setMoveSpeed(190 * level.map_slide_multiplier);
		return;
	}
	self setMoveSpeed(210);
	self setMoveSpeedScale(1.12);
	self setgravity(800);

	self setMoveSpeed(500); // @TODO remove
}

onConnect()
{
	self.sr_mode = "190";
	self.sr_way = "normal_0";

	names = getArrayKeys(level.leaderboards);

	// Default
	for (i = 0; i < level.leaderboard_max_page; i++)
	{
		self setClientDvar(fmt("normal_%d", i), "0");
		self setClientDvar(fmt("normal_%d_name", i), "-");
		self setClientDvar(fmt("secret_%d", i), "0");
		self setClientDvar(fmt("secret_%d_name", i), "-");
	}

	// Registred
	for (i = 0; i < names.size; i++)
	{
		leaderboard = level.leaderboards[names[i]];
		self setClientDvar(leaderboard.id, "1");
		self setClientDvar(fmt("%s_name", leaderboard.id), leaderboard.name);
	}
}

load()
{
	mutex_acquire("mysql");

	SQL_Prepare("SELECT mode, way, time, name, player, run FROM leaderboards WHERE map = ?");
	SQL_BindParam(getDvar("mapname"), level.MYSQL_TYPE_STRING);
	SQL_BindResult(level.MYSQL_TYPE_STRING, 20);
	SQL_BindResult(level.MYSQL_TYPE_STRING, 20);
	SQL_BindResult(level.MYSQL_TYPE_LONG);
	SQL_BindResult(level.MYSQL_TYPE_STRING, 36);
	SQL_BindResult(level.MYSQL_TYPE_STRING, 36);
	SQL_BindResult(level.MYSQL_TYPE_LONG);
	SQL_Execute();

	rows = SQL_FetchRowsDict();
	for (i = 0; i < rows.size; i++)
	{
		entry = [];
		entry["mode"] = rows[i]["mode"];
		entry["way"] = rows[i]["way"];
		entry["time"] = originToTime(rows[i]["time"]);
		entry["name"] = rows[i]["name"];
		entry["player"] = rows[i]["player"];
		entry["run"] = rows[i]["run"];

		index = getLeaderboardIndex(entry["mode"], entry["way"]);

		if (!isDefined(level.leaderboards[index]))
		{
			level.leaderboards[index] = spawnStruct();
			level.leaderboards[index].entries = [];
			level.leaderboards[index].id = entry["way"];
		}
		entryIndex = level.leaderboards[index].entries.size;
		level.leaderboards[index].entries[entryIndex] = entry;
	}
	mutex_release("mysql");
}

makeEntry()
{
	entry = [];
	entry["name"] = self.shortName;
	entry["player"] = self.id;
	entry["run"] = self.runId;
	entry["way"] = self.sr_way;
	entry["mode"] = self.sr_mode;
	entry["time"] = self.time;
	return entry;
}

isValidEntry(entry)
{
	leaderboard = getLeaderboard(entry["mode"], entry["way"]);
	placement = getEntryPlacement(entry, leaderboard.entries);

	if (placement > level.leaderboard_max_entries)
		return false;

	previousEntry = self getPlayerEntry(leaderboard.entries);
	if (!isDefined(previousEntry))
		return true;

	return entry["time"].origin <= previousEntry["time"].origin;
}

saveEntry(entry)
{
	self endon("disconnect");

	index = getLeaderboardIndex(entry["mode"], entry["way"]);
	entries = level.leaderboards[index].entries;
	level.leaderboards[index].entries = addEntry(entry, entries);

	placement = getEntryPlacement(entry, entries);
	self givePlacementXP(placement);
	if (placement == 1)
		self thread worldRecord(entry);

	mutex_acquire("mysql");

	// Update
	SQL_Prepare("UPDATE leaderboards SET time = ?, name = ?, run = ? WHERE map = ? AND player = ? AND mode = ? AND way = ?");
	SQL_BindParam(entry["time"].origin, level.MYSQL_TYPE_LONG);
	SQL_BindParam(entry["name"], level.MYSQL_TYPE_STRING);
	SQL_BindParam(entry["run"], level.MYSQL_TYPE_LONG);
	SQL_BindParam(getDvar("mapname"), level.MYSQL_TYPE_STRING);
	SQL_BindParam(entry["player"], level.MYSQL_TYPE_STRING);
	SQL_BindParam(entry["mode"], level.MYSQL_TYPE_STRING);
	SQL_BindParam(entry["way"], level.MYSQL_TYPE_STRING);
	SQL_Execute();

	// Insert
	if (!SQL_AffectedRows())
	{
		SQL_Prepare("INSERT INTO leaderboards (map, time, name, mode, way, player, run) VALUES (?, ?, ?, ?, ?, ?, ?)");
		SQL_BindParam(getDvar("mapname"), level.MYSQL_TYPE_STRING);
		SQL_BindParam(entry["time"].origin, level.MYSQL_TYPE_LONG);
		SQL_BindParam(entry["name"], level.MYSQL_TYPE_STRING);
		SQL_BindParam(entry["mode"], level.MYSQL_TYPE_STRING);
		SQL_BindParam(entry["way"], level.MYSQL_TYPE_STRING);
		SQL_BindParam(entry["player"], level.MYSQL_TYPE_STRING);
		SQL_BindParam(entry["run"], level.MYSQL_TYPE_LONG);
		SQL_Execute();
	}
	mutex_release("mysql");
}

addMode(mode, callback)
{
	level.leaderboard_modes[mode] = spawnStruct();
	level.leaderboard_modes[mode].id = mode;
	level.leaderboard_modes[mode].callback = callback;
}

addWay(way, name)
{
	modes = getArrayKeys(level.leaderboard_modes);
	for (i = 0; i < modes.size; i++)
	{
		index = getLeaderboardIndex(modes[i], way);

		if (!isDefined(level.leaderboards[index]))
		{
			level.leaderboards[index] = spawnStruct();
			level.leaderboards[index].entries = [];
		}

		level.leaderboards[index].id = way;
		level.leaderboards[index].name = name;
	}
}

display()
{
	numbers = "";
	names = "";
	times = "";

	leaderboard = getLeaderboard(self.leaderboard_mode, self.leaderboard_way);
	entries = leaderboard.entries;

	for (i = 0; i < level.leaderboard_max_entries / 10; i++)
	{
		self setClientDvar("leaderboard_numbers_" + i, "");
		self setClientDvar("leaderboard_names_" + i, "");
		self setClientDvar("leaderboard_values_" + i, "");
	}
	self setClientDvar("leaderboard_name", fmt("%s ^7%s", self.leaderboard_mode, leaderboard.name));

	stringIndex = 0;
	for (i = 0; i < entries.size; i++)
    {
		placement = i + 1;
		numbers += fmt("#%d\n", placement);
        color = "^7";

		switch (placement)
		{
			case 1: color = "^3"; break;
			case 2: color = "^8"; break;
			case 3: color = "^9"; break;
		}

		names += fmt("%s%s^7\n", color, entries[i]["name"]);
		times += fmt("^7%d:%d.%d\n", entries[i]["time"].min, entries[i]["time"].sec, entries[i]["time"].ms);

		if (!(placement % 10) || entries.size < 10)
		{
			self setClientDvar("leaderboard_numbers_" + stringIndex, numbers);
			self setClientDvar("leaderboard_names_" + stringIndex, names);
			self setClientDvar("leaderboard_values_" + stringIndex, times);

			numbers = "";
			names = "";
			times = "";
			stringIndex++;
		}
    }
}

addEntry(entry, entries)
{
	temp = [];

	// Remove duplicates
	for (i = 0; i < entries.size; i++)
	{
		if (entries[i]["player"] == entry["player"])
			continue;
		temp[temp.size] = entries[i];
	}
	temp[temp.size] = entry;

	// Sort
	for (i = 0; i < temp.size; i++)
	{
		for (z = 0; z < temp.size - 1; z++)
		{
			if (temp[z]["time"].origin > temp[z + 1]["time"].origin)
			{
				swap = temp[z + 1];
				temp[z + 1] = temp[z];
				temp[z] = swap;
			}
		}
	}
	return temp;
}

xpTable()
{
	xp = [];
	multiplier = 1;

	for (i = 1; i <= level.leaderboard_max_entries; i++)
	{
		if (!(i % 10))
			multiplier += 7;
		xp[xp.size] = i * multiplier;
	}
	return Reverse(xp);
}

getLeaderboard(mode, way)
{
	return level.leaderboards[getLeaderboardIndex(mode, way)];
}

getLeaderboardIndex(mode, way)
{
	return fmt("times_%s_%s", mode, way);
}

getLeaderboardName(mode, way)
{
	return getLeaderboard(mode, way).name;
}

getEntryPlacement(entry, entries)
{
	i = 1;
	for (; i <= entries.size; i++)
	{
		if (entry["time"].origin <= entries[i - 1]["time"].origin)
			return i;
	}
	return i;
}

getPlayerEntry(entries)
{
	for (i = 0; i < entries.size; i++)
	{
		if (entries[i]["player"] == self.id)
			return entries[i];
	}
	return undefined;
}

givePlacementXP(placement)
{
	if (placement == 0 || !isDefined(level.leaderboard_xps[placement - 1]))
		return;

	self sr\game\_rank::giveRankXP("", level.leaderboard_xps[placement - 1]);
}

worldRecord(entry)
{
	players = getAllPlayers();

	way = getLeaderboardName(entry["mode"], entry["way"]);
	iPrintLnBold(fmt("^5New ^2WR ^7on ^6%s ^2%s ^7By ^5%s", entry["mode"], way, self.shortName));

	for (i = 0; i < players.size; i++)
		players[i] thread effects();
}

effects()
{
	self endon("disconnect");
	self endon("death");

	self playLocalSound("wr_sound");

	for (i = 0; i < 25; i++)
	{
		PlayFX(level.fx["wr_event"], self.origin);
		wait 0.5;
	}
}

endmapTrig()
{
	array = getEntArray("endmap_trig", "targetname");
	if (!array.size)
	{
		iPrintLnBold("^1Error: No endmap_trig found.");
		return;
	}

	trigger = array[0];
	thread sr\game\fx\_trigger::createTrigFx(trigger, "red");
	while (true)
	{
		trigger waittill("trigger", player);
		player speedrun\game\_leaderboards::endTimer();
	}
}

onSpawn()
{
	self endon("disconnect");

	self [[level.leaderboard_modes[self.sr_mode].callback]]();
	self playerTimer();
}

playerTimer()
{
	self endon("disconnect");
	self endon("spawned_player");
	self endon("joined_spectators");
	self endon("death");

	if (self.finishedMap)
		return;

	while (game["state"] != "playing")
		wait 0.05;

	wait 0.1; // Spastic delay caused by bad modding, too bad...

	self.time = sr\utils\_common::originToTime(getTime());
}

endTimer()
{
	if (self.finishedMap || self.sr_cheat)
		return;

	self.finishedMap = true;

	if (self.isBot)
	{
		self notify("menuresponse", "team_select", "spectator");
		return;
	}

	self.time = originToTime(getTime() - self.time.origin);
	self speedrun\player\huds\_speedrun::updateTime();

	way = getLeaderboardName(self.sr_mode, self.sr_way);
	iPrintLn(fmt("%s finished the map in %d:%d.%d - %s / %s",
		self.name, self.time.min, self.time.sec, self.time.ms,
		self.sr_mode, way));

	entry = self makeEntry();
	if (isValidEntry(entry))
		saveEntry(entry);
}
