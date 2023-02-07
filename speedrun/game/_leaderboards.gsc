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

	event("map", ::load);
	event("connected", ::onConnect);
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
	level loading("leaderboards");

	wait 0.5;

	if (self isBot())
	{
		self setLoading("wr", false);
		self botLeaderboardEntries();
		self speedrun\player\huds\_speedrun::updateRecords();
		return;
	}

	// Default
	for (i = 0; isDefined(self) && i < level.leaderboard_max_page; i++)
	{
		self setClientDvars(fmt("normal_%d", i), "", fmt("secret_%d", i), "");
		wait 0.05;
	}
	if (!isDefined(self) || !mapHasLeaderboards())
		return;

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

	if (!isDefined(self))
		return;

	self setLoading("wr", false);
	self speedrun\player\huds\_speedrun::updateRecords();
	self updateMenuInfo();
}

botLeaderboardEntries()
{
	self.lbEntries = 0;
	self.pers["wrCount"] = 0;
	self.pers["wrBaseCount"] = 0;
}

updateMenuInfo()
{
	wr = speedrun\game\_leaderboards::getWorldRecord(self.sr_mode, self.sr_way);
	pb = self speedrun\game\_pbs::getPersonalBest(self.sr_mode, self.sr_way);

	self setClientDvars(
		"sr_leaderboard_pb", fmt("^3%s", pb),
		"sr_leaderboard_wr", fmt("^2%s", wr)
	);
}

getPlayerWorldRecordCount()
{
	critical_enter("mysql");

	filter = "SELECT id, map, name, mode, way, player, time, min(time) OVER (PARTITION BY map, mode, way) AS minTime FROM leaderboards";
	query = fmt("SELECT count(id) FROM (%s) b WHERE time = minTime AND player = ?", filter);

	request = SQL_Prepare(query);
	SQL_BindParam(request, self.id, level.MYSQL_TYPE_STRING);
	SQL_BindResult(request, level.MYSQL_TYPE_LONG);
	SQL_Execute(request);
	AsyncWait(request);
	wrCount = IfUndef(SQL_FetchRow(request), []);
	SQL_Free(request);

	filter = "SELECT id, map, name, mode, way, player, time, min(time) OVER (PARTITION BY map, mode, way) AS minTime FROM leaderboards";
	query = fmt("SELECT count(id) FROM (%s) b WHERE time = minTime AND player = ? AND (mode = %s OR mode = %s)",
		filter, "190", "210");

	request = SQL_Prepare(query);
	SQL_BindParam(request, self.id, level.MYSQL_TYPE_STRING);
	SQL_BindResult(request, level.MYSQL_TYPE_LONG);
	SQL_Execute(request);
	AsyncWait(request);
	wrBaseCount = IfUndef(SQL_FetchRow(request), []);
	SQL_Free(request);
	critical_release("mysql");

	if (!isDefined(self))
		return;

	self.pers["wrCount"] = IfUndef(wrCount[0], 0);
	self.pers["wrBaseCount"] = IfUndef(wrBaseCount[0], 0);
	self setStat(2001, self.pers["wrBaseCount"]);
	self setClientDvar("sr_leaderboard_wr_count", fmt("%d ^5(%d)", self.pers["wrBaseCount"], self.pers["wrCount"]));
}

getPlayerEntriesCount()
{
	critical_enter("mysql");

	request = SQL_Prepare("SELECT COUNT(id) FROM leaderboards WHERE player = ?");
	SQL_BindParam(request, self.id, level.MYSQL_TYPE_STRING);
	SQL_BindResult(request, level.MYSQL_TYPE_LONG);
	SQL_Execute(request);
	AsyncWait(request);
	count = IfUndef(SQL_FetchRow(request), []);
	SQL_Free(request);

	critical_release("mysql");

	if (!isDefined(self))
		return;

	self.lbEntries = IfUndef(count[0], 0);
	self setStat(2002, self.lbEntries);
}

load()
{
	waitMapLoad(3);

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

	critical_enter("mysql");

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
	critical_release("mysql");

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

	// Sort leaderboards
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
		}
	}
	level setLoading("leaderboards", false);
	level thread demos();

	players = getAllPlayers();
	for (i = 0; i < players.size; i++)
		players[i] thread speedrun\player\huds\_speedrun::updateRecords();
}

demos()
{
	modes = getArrayKeys(level.leaderboard_modes);
	ways = getArrayKeys(level.leaderboard_ways);

	for (i = 0; i < modes.size; i++)
	{
		for (j = 0; j < ways.size; j++)
		{
			mode = level.leaderboard_modes[modes[i]];
			way = level.leaderboard_ways[ways[j]];
			index = getLeaderboardIndex(mode.id, way.id);

			if (!isDefined(level.leaderboards[index]))
				continue;
			if (!level.leaderboards[index].entries.size)
				continue;

			entryIndex = 0;
			entries = level.leaderboards[index].entries;
			entry = entries[entryIndex];
			registred = speedrun\game\_demo::addSpeedrunDemo(entry);

			while (!registred)
			{
				entryIndex++;
				if (entryIndex > 10 || entryIndex >= entries.size)
					break;

				entry = level.leaderboards[index].entries[entryIndex];
				registred = speedrun\game\_demo::addSpeedrunDemo(entry);
			}
			if (registred)
				level.demos[index] = entry;

			wait 0.05;
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

isTie(entry, entries)
{
	if (!isDefined(entries[0]))
		return false;
	return entry["time"].origin == entries[0]["time"].origin;
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
		self thread sr\game\_demo::recordSave();
	if (placement == 1 && !self isTie(entry, entries))
		self thread worldRecord(entry);

	critical_enter("mysql");

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
	critical_release("mysql");
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
	if (!isDefined(leaderboard))
		return;

	entries = leaderboard.entries;

	self setClientDvar("leaderboard_name", fmt("%s ^7%s", self.leaderboard_mode, leaderboard.name));

	if (!isDefined(entries))
		return;

	for (i = 0; i < int(level.leaderboard_max_entries / 10); i++)
	{
		self setClientDvars(
			"leaderboard_numbers_" + i, "",
			"leaderboard_names_" + i, "",
			"leaderboard_values_" + i, ""
		);
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
			self setClientDvars(
				"leaderboard_numbers_" + stringIndex, numbers,
				"leaderboard_names_" + stringIndex, names,
				"leaderboard_values_" + stringIndex, times
			);

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
	return "Normal Way";
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

	self thread sr\game\_rank::giveRankXP("", xp);
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
		players[i] thread updateMenuInfo();
	}

	wait 1;
	if (speedrun\game\_demo::addSpeedrunDemo(entry))
		level.demos[index] = entry;
}

effects()
{
	self endon("disconnect");
	self endon("death");

	self playLocalSound("wr_sound");

	for (i = 0; i < 25; i++)
	{
		playFX(level.gfx["wr_event"], self.origin);
		wait 0.5;
	}
}
