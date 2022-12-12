#include sr\sys\_events;
#include sr\utils\_common;

initLeaderboards()
{
	level.leaderboards = [];
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

	// Stats
	self getPlayerEntriesCount();
	self getPlayerWorldRecordCount();
}

updateMenuInfo()
{
	wr = speedrun\game\_leaderboards::getWorldRecord(self.sr_mode, self.sr_way);
	pb = self speedrun\game\_pbs::getPersonalBest(self.sr_mode, self.sr_way);

	self setClientDvar("sr_leaderboard_pb", fmt("^3%s", pb));
	self setClientDvar("sr_leaderboard_wr", fmt("^2%s", wr));
}

getPlayerWorldRecordCount()
{
	if (self.isBot)
		return;

	// All
	filter = "SELECT id, map, name, mode, way, player, time, min(time) OVER (PARTITION BY map, mode, way) AS minTime FROM leaderboards";
	query = fmt("SELECT count(id) FROM (%s) b WHERE time = minTime AND player = ?", filter);

	mutex_acquire("mysql");

	request = SQL_Prepare(query);
	SQL_BindParam(request, self.id, level.MYSQL_TYPE_STRING);
	SQL_BindResult(request, level.MYSQL_TYPE_LONG);
	SQL_Execute(request);
	AsyncWait(request);

	count = SQL_FetchRow(request);
	SQL_Free(request);

	self.wrCount = 0;
	if (isDefined(count) && isDefined(count.size))
		self.wrCount = count[0];

	// 190 / 210
	filter = "SELECT id, map, name, mode, way, player, time, min(time) OVER (PARTITION BY map, mode, way) AS minTime FROM leaderboards";
	query = fmt("SELECT count(id) FROM (%s) b WHERE time = minTime AND player = ? AND (mode = %s OR mode = %s)",
		filter, "190", "210");

	request = SQL_Prepare(query);
	SQL_BindParam(request, self.id, level.MYSQL_TYPE_STRING);
	SQL_BindResult(request, level.MYSQL_TYPE_LONG);
	SQL_Execute(request);
	AsyncWait(request);

	count = SQL_FetchRow(request);
	SQL_Free(request);
	mutex_release("mysql");

	self.wrBaseCount = 0;
	if (isDefined(count) && isDefined(count.size))
		self.wrBaseCount = count[0];

	self setStat(2001, self.wrBaseCount);
	self setClientDvar("sr_leaderboard_wr_count", fmt("%d ^5(%d)", self.wrBaseCount, self.wrCount));
}

getPlayerEntriesCount()
{
	if (self.isBot)
		return;

	mutex_acquire("mysql");

	request = SQL_Prepare("SELECT COUNT(id) FROM leaderboards WHERE player = ?");
	SQL_BindParam(request, self.id, level.MYSQL_TYPE_STRING);
	SQL_BindResult(request, level.MYSQL_TYPE_LONG);
	SQL_Execute(request);
	AsyncWait(request);

	count = SQL_FetchRow(request);
	SQL_Free(request);
	mutex_release("mysql");

	self.lbEntries = 0;
	if (isDefined(count) && isDefined(count.size))
		self.lbEntries = count[0];

	self setStat(2002, self.lbEntries);
}

load()
{
	waitMapLoad();

	if (!mapHasLeaderboards())
		addWay("normal_0", "Normal Way");

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

	request = SQL_Prepare("SELECT mode, way, time, name, player, run FROM leaderboards WHERE map = ?");
	SQL_BindParam(request, level.map, level.MYSQL_TYPE_STRING);
	SQL_BindResult(request, level.MYSQL_TYPE_STRING, 20);
	SQL_BindResult(request, level.MYSQL_TYPE_STRING, 20);
	SQL_BindResult(request, level.MYSQL_TYPE_LONG);
	SQL_BindResult(request, level.MYSQL_TYPE_STRING, 36);
	SQL_BindResult(request, level.MYSQL_TYPE_STRING, 36);
	SQL_BindResult(request, level.MYSQL_TYPE_STRING, 36);
	SQL_Execute(request);
	AsyncWait(request);

	rows = SQL_FetchRowsDict(request);
	SQL_Free(request);
	mutex_release("mysql");

	// Fetch
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

	// Sort and register demos
	for (i = 0; i < modes.size; i++)
	{
		resetTimeout();

		for (j = 0; j < ways.size; j++)
		{
			resetTimeout();

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
			registred = RegisterSpeedrunDemo(level.map, entry["player"], entry["run"], entry["mode"], entry["way"]);

			while (!registred)
			{
				entryIndex++;
				if (entryIndex > 10 || !isDefined(level.leaderboards[index].entries[entryIndex]))
					break;

				entry = level.leaderboards[index].entries[entryIndex];
				registred = RegisterSpeedrunDemo(level.map, entry["player"], entry["run"], entry["mode"], entry["way"]);
			}
			if (registred)
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

	return entry["time"].origin < previousEntry["time"].origin;
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

	if (placement <= 3)
		self sr\game\_demo::recordSave();
	if (placement == 1)
		self thread worldRecord(entry);

	mutex_acquire("mysql");

	// Update
	request = SQL_Prepare("UPDATE leaderboards SET time = ?, name = ?, run = ? WHERE map = ? AND player = ? AND mode = ? AND way = ?");
	SQL_BindParam(request, entry["time"].origin, level.MYSQL_TYPE_LONG);
	SQL_BindParam(request, entry["name"], level.MYSQL_TYPE_STRING);
	SQL_BindParam(request, entry["run"], level.MYSQL_TYPE_STRING);
	SQL_BindParam(request, level.map, level.MYSQL_TYPE_STRING);
	SQL_BindParam(request, entry["player"], level.MYSQL_TYPE_STRING);
	SQL_BindParam(request, entry["mode"], level.MYSQL_TYPE_STRING);
	SQL_BindParam(request, entry["way"], level.MYSQL_TYPE_STRING);
	SQL_Execute(request);
	AsyncWait(request);

	affected = SQL_AffectedRows(request);
	SQL_Free(request);

	// Insert
	if (!affected)
	{
		request = SQL_Prepare("INSERT INTO leaderboards (map, time, name, mode, way, player, run) VALUES (?, ?, ?, ?, ?, ?, ?)");
		SQL_BindParam(request, level.map, level.MYSQL_TYPE_STRING);
		SQL_BindParam(request, entry["time"].origin, level.MYSQL_TYPE_LONG);
		SQL_BindParam(request, entry["name"], level.MYSQL_TYPE_STRING);
		SQL_BindParam(request, entry["mode"], level.MYSQL_TYPE_STRING);
		SQL_BindParam(request, entry["way"], level.MYSQL_TYPE_STRING);
		SQL_BindParam(request, entry["player"], level.MYSQL_TYPE_STRING);
		SQL_BindParam(request, entry["run"], level.MYSQL_TYPE_STRING);
		SQL_Execute(request);
		AsyncWait(request);
		SQL_Free(request);
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
	threshold = 100;

	for (i = 1; i <= level.leaderboard_max_entries; i++)
	{
		if (!(i % 10))
			multiplier += threshold / (level.leaderboard_max_entries / 10);
		xp[xp.size] = float(i * multiplier);
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

	multiplier = Ternary(self sr\sys\_admins::isVIP(), 3, 1);
	filled = entries.size / level.leaderboard_max_entries;
	xp = level.leaderboard_xps[placement - 1] * filled * multiplier;

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
	index = getLeaderboardIndex(entry["mode"], entry["way"]);

	iPrintLnBold(fmt("^5New ^2WR ^7on ^6%s ^2%s ^7By ^5%s", entry["mode"], way, self.shortName));

	for (i = 0; i < players.size; i++)
	{
		players[i] thread effects();
		players[i] thread speedrun\game\_leaderboards::updateMenuInfo();
	}

	wait 1;
	if (RegisterSpeedrunDemo(level.map, entry["player"], entry["run"], entry["mode"], entry["way"]))
		level.demos[index] = entry;
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
