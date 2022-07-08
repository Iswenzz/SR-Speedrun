#include sr\sys\_events;
#include sr\utils\_common;

initLeaderboards()
{
	level.leaderboard_max_page = 7;
	level.leaderboard_max_entries = 30;
	level.leaderboard_xps = xpTable();

	menu("sr_leaderboard", "open", ::menu_Open);
	menu_multiple("sr_leaderboard", "way", ::menu_Leaderboard);
	menu_multiple("sr_leaderboard", "mode", ::menu_Mode);

	event("connect", ::onConnect);

	thread load();
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

onConnect()
{
	self endon("disconnect");

	waitMapLoad(1);

	names = getArrayKeys(level.leaderboards);

	// Default
	for (i = 0; i < level.leaderboard_max_page; i++)
	{
		self setClientDvar(fmt("normal_%d", i), "0");
		self setClientDvar(fmt("normal_%d_name", i), "-");
		self setClientDvar(fmt("secret_%d", i), "0");
		self setClientDvar(fmt("secret_%d_name", i), "-");
		wait 0.05;
	}

	// Registred
	for (i = 0; i < names.size; i++)
	{
		leaderboard = level.leaderboards[names[i]];
		self setClientDvar(leaderboard.id, "1");
		self setClientDvar(fmt("%s_name", leaderboard.id), IfUndef(leaderboard.name, ""));
	}
}

load()
{
	waitMapLoad();

	level.leaderboards = [];
	modes = getArrayKeys(level.leaderboard_modes);
	ways = getArrayKeys(level.leaderboard_ways);

	for (i = 0; i < modes.size; i++)
	{
		for (j = 0; j < ways.size; j++)
		{
			mode = level.leaderboard_modes[modes[i]];
			way = level.leaderboard_ways[ways[j]];
			index = getLeaderboardIndex(mode.id, way.id);

			level.leaderboards[index] = spawnStruct();
			level.leaderboards[index].entries = [];
			level.leaderboards[index].id = way.id;
			level.leaderboards[index].name = way.name;
		}
	}

	mutex_acquire("mysql");

	SQL_Prepare("SELECT mode, way, time, name, player, run FROM leaderboards WHERE map = ?");
	SQL_BindParam(level.map, level.MYSQL_TYPE_STRING);
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
	entry["run"] = self.run;
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
	if (!isValidEntry(entry))
		return;

	index = getLeaderboardIndex(entry["mode"], entry["way"]);
	entries = level.leaderboards[index].entries;
	level.leaderboards[index].entries = addEntry(entry, entries);

	placement = getEntryPlacement(entry, entries);
	self givePlacementXP(placement);

	if (placement == 1)
		self thread worldRecord(entry);
	if (placement <= 5)
		self sr\game\_demo::recordSave();

	mutex_acquire("mysql");

	// Update
	SQL_Prepare("UPDATE leaderboards SET time = ?, name = ?, run = ? WHERE map = ? AND player = ? AND mode = ? AND way = ?");
	SQL_BindParam(entry["time"].origin, level.MYSQL_TYPE_LONG);
	SQL_BindParam(entry["name"], level.MYSQL_TYPE_STRING);
	SQL_BindParam(entry["run"], level.MYSQL_TYPE_LONG);
	SQL_BindParam(level.map, level.MYSQL_TYPE_STRING);
	SQL_BindParam(entry["player"], level.MYSQL_TYPE_STRING);
	SQL_BindParam(entry["mode"], level.MYSQL_TYPE_STRING);
	SQL_BindParam(entry["way"], level.MYSQL_TYPE_STRING);
	SQL_Execute();

	// Insert
	if (!SQL_AffectedRows())
	{
		SQL_Prepare("INSERT INTO leaderboards (map, time, name, mode, way, player, run) VALUES (?, ?, ?, ?, ?, ?, ?)");
		SQL_BindParam(level.map, level.MYSQL_TYPE_STRING);
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
	if (!isDefined(level.leaderboard_modes))
		level.leaderboard_modes = [];
	level.leaderboard_modes[mode] = spawnStruct();
	level.leaderboard_modes[mode].id = mode;
	level.leaderboard_modes[mode].callback = callback;
}

addWay(way, name)
{
	if (!isDefined(level.leaderboard_ways))
		level.leaderboard_ways = [];
	level.leaderboard_ways[way] = spawnStruct();
	level.leaderboard_ways[way].id = way;
	level.leaderboard_ways[way].name = name;
}

display()
{
	numbers = "";
	names = "";
	times = "";

	leaderboard = getLeaderboard(self.leaderboard_mode, self.leaderboard_way);
	entries = leaderboard.entries;

	self setClientDvar("leaderboard_name", fmt("%s ^7%s", self.leaderboard_mode, leaderboard.name));

	if (!isDefined(entries))
		return;

	for (i = 0; i < int(level.leaderboard_max_entries / 10); i++)
	{
		self setClientDvar("leaderboard_numbers_" + i, "");
		self setClientDvar("leaderboard_names_" + i, "");
		self setClientDvar("leaderboard_values_" + i, "");
	}

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

		if (!(placement % 10) || i == entries.size - 1)
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
	if (!isDefined(level.leaderboards) || !level.leaderboards.size)
		return undefined;
	return level.leaderboards[getLeaderboardIndex(mode, way)];
}

getLeaderboardIndex(mode, way)
{
	return fmt("times_%s_%s", mode, way);
}

getLeaderboardName(mode, way)
{
	leaderboard = getLeaderboard(mode, way);
	if (isDefined(leaderboard))
		return leaderboard.name;
	return "Loading...";
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

getWorldRecord(mode, way)
{
	leaderboard = getLeaderboard(self.sr_mode, self.sr_way);
	if (!isDefined(leaderboard))
		return "";

	entries = leaderboard.entries;
	if (!entries.size)
		return "";

	wr = entries[0]["time"];
	return fmt("%d:%d.%d", wr.min, wr.sec, wr.ms);
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
