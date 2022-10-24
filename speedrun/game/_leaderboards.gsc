#include sr\sys\_events;
#include sr\utils\_common;

initLeaderboards()
{
	level.leaderboard_max_page = 7;
	level.leaderboard_max_entries = 40;
	level.leaderboard_xps = xpTable();

	menu("sr_leaderboard", "open", ::menu_Open);
	menu("sr_leaderboard", "demo", ::menu_Demo);
	menu_multiple("sr_leaderboard", "way", ::menu_Leaderboard);
	menu_multiple("sr_leaderboard", "mode", ::menu_Mode);

	event("connect", ::onConnect);

	thread load();
}

menu_Open(arg)
{
	if (!isDefined(self.leaderboard_way))
		self.leaderboard_way = self.sr_way;
	if (!isDefined(self.leaderboard_mode))
		self.leaderboard_mode = self.sr_mode;

	self display();
}

menu_Demo(arg)
{
	if (!self isReallyAlive())
		return;

	index = getLeaderboardIndex(self.leaderboard_mode, self.leaderboard_way);
	self thread speedrun\game\_demo::play(index);

	self closeMenu();
	self closeInGameMenu();
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

	if (!isDefined(self.sr_way))
		self.sr_way = "normal_0";
	if (!isDefined(self.sr_mode))
		self.sr_mode = "190";

	wait 0.5;

	// Default
	for (i = 0; i < level.leaderboard_max_page; i++)
	{
		self setClientDvar(fmt("normal_%d", i), "");
		self setClientDvar(fmt("secret_%d", i), "");
		wait 0.05;
	}
	waitMapLoad(1);

	if (!mapHasLeaderboards())
		return;

	self thread updateMenuInfo();

	// Registred
	names = getArrayKeys(level.leaderboards);
	for (i = 0; i < names.size; i++)
	{
		leaderboard = level.leaderboards[names[i]];
		self setClientDvar(leaderboard.id, IfUndef(leaderboard.name, ""));
	}
}

updateMenuInfo()
{
	wr = speedrun\game\_leaderboards::getWorldRecord(self.sr_mode, self.sr_way);
	pb = self speedrun\game\_pbs::getPersonalBest(self.sr_mode, self.sr_way);

	self setClientDvar("sr_leaderboard_pb", fmt("^3%s", pb));
	self setClientDvar("sr_leaderboard_wr", fmt("^2%s", wr));

	self getPlayerEntriesCount();
	self getPlayerWorldRecordCount();
}

getPlayerWorldRecordCount()
{
	mutex_acquire("mysql");

	filter = "SELECT map, mode, way, MIN(time) as minTime FROM leaderboards GROUP BY map, mode, way";
	query = fmt("SELECT count(a.id) FROM leaderboards a JOIN (%s) b ON a.time = b.minTime where a.player = ?", filter);

	SQL_Prepare(query);
	SQL_BindParam(self.id, level.MYSQL_TYPE_STRING);
	SQL_BindResult(level.MYSQL_TYPE_LONG);
	SQL_Execute();

	count = SQL_FetchRow();

	self.wrCount = 0;
	if (isDefined(count) && isDefined(count.size))
		self.wrCount = count[0];

	self setStat(2001, self.wrCount);

	mutex_release("mysql");
}

getPlayerEntriesCount()
{
	mutex_acquire("mysql");

	SQL_Prepare("SELECT COUNT(id) FROM leaderboards WHERE player = ?");
	SQL_BindParam(self.id, level.MYSQL_TYPE_STRING);
	SQL_BindResult(level.MYSQL_TYPE_LONG);
	SQL_Execute();

	count = SQL_FetchRow();

	self.lbEntries = 0;
	if (isDefined(count) && isDefined(count.size))
		self.lbEntries = count[0];

	self setStat(2002, self.lbEntries);

	mutex_release("mysql");
}

load()
{
	waitMapLoad();

	if (!mapHasLeaderboards())
		addWay("normal_0", "Normal Way");

	level.leaderboards = [];
	modes = getArrayKeys(level.leaderboard_modes);
	ways = getArrayKeys(level.leaderboard_ways);

	// Initialize
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

	// Fetch
	rows = SQL_FetchRowsDict();
	for (i = 0; i < rows.size; i++)
	{
		entry = [];
		entry["mode"] = rows[i]["mode"];
		entry["way"] = rows[i]["way"];
		entry["time"] = originToTime(rows[i]["time"]);
		entry["name"] = getSubStr(rows[i]["name"], 0, 15);
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

	// Sort and register demos
	for (i = 0; i < modes.size; i++)
	{
		for (j = 0; j < ways.size; j++)
		{
			mode = level.leaderboard_modes[modes[i]];
			way = level.leaderboard_ways[ways[j]];
			index = getLeaderboardIndex(mode.id, way.id);

			if (!isDefined(level.leaderboards[index]))
				continue;

			level.leaderboards[index].entries = sortEntries(level.leaderboards[index].entries);

			if (!level.leaderboards[index].entries.size)
				continue;

			entryIndex = 0;
			entry = level.leaderboards[index].entries[entryIndex];

			while (!RegisterSpeedrunDemo(level.map, entry["player"], entry["run"], entry["mode"], entry["way"]))
			{
				entryIndex++;
				if (entryIndex > 10 || !isDefined(level.leaderboards[index].entries[entryIndex]))
					break;

				entry = level.leaderboards[index].entries[entryIndex];
				wait 0.05;
			}
			level.demos[index] = entry;
		}
	}
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

mapHasLeaderboards()
{
	return isDefined(level.leaderboard_ways) && isDefined(level.leaderboard_modes);
}

saveEntry(entry)
{
	if (!mapHasLeaderboards() || !isValidEntry(entry))
		return;

	index = getLeaderboardIndex(entry["mode"], entry["way"]);
	entries = level.leaderboards[index].entries;
	level.leaderboards[index].entries = addEntry(entry, entries);

	placement = getEntryPlacement(entry, entries);
	self givePlacementXP(entry, entries, placement);

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
	if (!mapHasLeaderboards())
		return;

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
	array = [];

	// Remove duplicates
	for (i = 0; i < entries.size; i++)
	{
		if (entries[i]["player"] == entry["player"])
			continue;
		array[array.size] = entries[i];
	}
	array[array.size] = entry;

	return sortEntries(array);
}

sortEntries(entries)
{
	array = entries;

	for (i = 0; i < array.size; i++)
	{
		for (z = 0; z < array.size - 1; z++)
		{
			if (array[z]["time"].origin > array[z + 1]["time"].origin)
			{
				swap = array[z + 1];
				array[z + 1] = array[z];
				array[z] = swap;
			}
		}
	}
	return array;
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

givePlacementXP(entry, entries, placement)
{
	if (isDefined(level.leaderboard_xp_disabled) || placement == 0)
		return;
	if (entries.size && entries[0]["time"].origin == entry["time"].origin)
		return;

	multiplier = (entries.size / 10) * Ternary(self sr\sys\_admins::isVIP(), 3, 1);
	xp = level.leaderboard_xps[placement - 1] * multiplier;

	self sr\game\_rank::giveRankXP("", xp);
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
	{
		players[i] thread effects();
		players[i] thread speedrun\game\_leaderboards::updateMenuInfo();
	}
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
