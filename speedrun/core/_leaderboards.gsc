#include sr\sys\_events;
#include sr\utils\_common;

main()
{
	level.leaderboards = [];
	level.leaderboard_max_page = 7;
	level.leaderboard_max_entries = 40;
	level.leaderboard_xps = xpTable();

	event("map", ::load);
	event("connected", ::onConnect);
}

onConnect()
{
	level loading("leaderboards");

	wait 0.5;

	if (self isBot())
	{
		self setLoading("wr", false);
		self botLeaderboardEntries();
		self speedrun\huds\_speedrun::updateRecords();
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
	self speedrun\huds\_speedrun::updateRecords();
	self updateMenuInfo();
}

botLeaderboardEntries()
{
	self.lbEntries = 0;
	self.pers["wrs"] = 0;
	self.pers["wrms"] = 0;
}

updateMenuInfo()
{
	wr = getWorldRecord(self.sr_mode, self.sr_way);
	pb = self speedrun\core\_pbs::getPersonalBest(self.sr_mode, self.sr_way);

	self setClientDvars(
		"sr_leaderboard_pb", fmt("^3%s", Ternary(IsNullOrEmpty(pb), "-", pb)),
		"sr_leaderboard_wr", fmt("^2%s", Ternary(IsNullOrEmpty(wr), "-", wr))
	);
}

getPlayerWorldRecordCount()
{
	critical_enter("mysql");

	filter = "SELECT id, map, name, mode, way, player, time, tas, min(time) OVER (PARTITION BY map, mode, way, tas) AS minTime FROM leaderboards";
	query = fmt("SELECT COUNT(*) FROM (%s) b WHERE time = minTime AND player = ? AND tas = 0 AND (mode = %s OR mode = %s)",
		filter, "190", "210");

	request = SQL_Prepare(query);
	SQL_BindParam(request, self.id, level.MYSQL_TYPE_STRING);
	SQL_Execute(request);
	AsyncWait(request);
	wrs = IfUndef(SQL_FetchRow(request), []);
	SQL_Free(request);

	filter = "SELECT id, map, name, mode, way, player, time, tas, min(time) OVER (PARTITION BY map, mode, way, tas) AS minTime FROM leaderboards";
	query = fmt("SELECT COUNT(*) FROM (%s) b WHERE time = minTime AND player = ? AND tas = 0 AND mode IN (%s, %s, %s, %s, %s)",
        filter, "Q3", "Q3CPM", "Q3CPMW", "CS", "Portal");

	request = SQL_Prepare(query);
	SQL_BindParam(request, self.id, level.MYSQL_TYPE_STRING);
	SQL_Execute(request);
	AsyncWait(request);
	wrms = IfUndef(SQL_FetchRow(request), []);
	SQL_Free(request);

	critical_release("mysql");

	if (!isDefined(self))
		return;

	self.pers["wrs"] = IfUndef(wrs[0], 0);
	self.pers["wrms"] = IfUndef(wrms[0], 0);
	self setStat(2001, self.pers["wrs"]);
	self setClientDvar("sr_leaderboard_wr_count", fmt("%d ^5(%d)", self.pers["wrs"], self.pers["wrms"]));
}

getPlayerEntriesCount()
{
	critical_enter("mysql");

	request = SQL_Prepare("SELECT COUNT(*) FROM leaderboards WHERE player = ?");
	SQL_BindParam(request, self.id, level.MYSQL_TYPE_STRING);
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
			for (tas = 0; tas < 2; tas++)
			{
				mode = level.leaderboard_modes[modes[i]];
				way = level.leaderboard_ways[ways[j]];
				index = getLeaderboardIndex(mode.id, way.id, tas);

				level.leaderboards[index] = spawnStruct();
				level.leaderboards[index].entries = [];
				level.leaderboards[index].id = way.id;
				level.leaderboards[index].name = way.name;
			}
		}
	}

	critical_enter("mysql");

	request = SQL_Prepare("SELECT mode, way, time, name, player, run, tas FROM leaderboards WHERE map = ?");
	SQL_BindParam(request, level.map, level.MYSQL_TYPE_STRING);
	SQL_Execute(request);
	AsyncWait(request);

	rows = SQL_FetchRowsDict(request);
	SQL_Free(request);
	critical_release("mysql");

	for (i = 0; i < rows.size; i++)
	{
		entry = [];
		entry["map"] = level.map;
		entry["mode"] = rows[i]["mode"];
		entry["way"] = rows[i]["way"];
		entry["time"] = originToTime(rows[i]["time"]);
		entry["name"] = getSubStr(rows[i]["name"], 0, 15);
		entry["player"] = rows[i]["player"];
		entry["run"] = rows[i]["run"];
		entry["tas"] = rows[i]["tas"];

		index = getLeaderboardIndex(entry["mode"], entry["way"], entry["tas"]);

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
			for (tas = 0; tas < 2; tas++)
			{
				mode = level.leaderboard_modes[modes[i]];
				way = level.leaderboard_ways[ways[j]];
				index = getLeaderboardIndex(mode.id, way.id, tas);

				if (!isDefined(level.leaderboards[index]))
					continue;

				level.leaderboards[index].entries = sortEntries(level.leaderboards[index].entries);
			}
		}
	}
	level setLoading("leaderboards", false);
	level thread demos();

	players = getAllPlayers();
	for (i = 0; i < players.size; i++)
		players[i] thread speedrun\huds\_speedrun::updateRecords();
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
			registred = speedrun\core\_demo::addSpeedrunDemo(entry);

			while (!registred)
			{
				entryIndex++;
				if (entryIndex > 10 || entryIndex >= entries.size)
					break;

				entry = level.leaderboards[index].entries[entryIndex];
				registred = speedrun\core\_demo::addSpeedrunDemo(entry);
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
	entry["map"] = level.map;
	entry["name"] = self.shortName;
	entry["player"] = self.id;
	entry["run"] = self.run;
	entry["way"] = self.sr_way;
	entry["mode"] = self.sr_mode;
	entry["time"] = self.time;
	entry["tas"] = self.admin_tas;
	return entry;
}

isValidEntry(entry)
{
	leaderboard = getLeaderboard(entry["mode"], entry["way"], entry["tas"]);
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

	index = getLeaderboardIndex(entry["mode"], entry["way"], entry["tas"]);
	entries = level.leaderboards[index].entries;
	self addEntry(entry, index);

	placement = getEntryPlacement(entry, entries);
	self givePlacementXP(entry, entries, placement);

	if (placement <= 3)
		self thread sr\core\_demo::recordSave();
	if (placement == 1 && !self isTie(entry, entries))
		self thread worldRecord(entry);

	critical_enter("mysql");

	request = SQL_Prepare("UPDATE leaderboards SET time = ?, name = ?, run = ?, tas = ?, date = NOW() WHERE map = ? AND player = ? AND mode = ? AND way = ?");
	SQL_BindParam(request, entry["time"].origin, level.MYSQL_TYPE_LONG);
	SQL_BindParam(request, entry["name"], level.MYSQL_TYPE_STRING);
	SQL_BindParam(request, entry["run"], level.MYSQL_TYPE_STRING);
	SQL_BindParam(request, entry["tas"], level.MYSQL_TYPE_LONG);
	SQL_BindParam(request, entry["map"], level.MYSQL_TYPE_STRING);
	SQL_BindParam(request, entry["player"], level.MYSQL_TYPE_STRING);
	SQL_BindParam(request, entry["mode"], level.MYSQL_TYPE_STRING);
	SQL_BindParam(request, entry["way"], level.MYSQL_TYPE_STRING);
	SQL_Execute(request);
	AsyncWait(request);

	affected = SQL_AffectedRows(request);
	SQL_Free(request);

	if (!affected)
	{
		request = SQL_Prepare("INSERT INTO leaderboards (map, time, name, mode, way, player, run, tas, date) VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())");
		SQL_BindParam(request, entry["map"], level.MYSQL_TYPE_STRING);
		SQL_BindParam(request, entry["time"].origin, level.MYSQL_TYPE_LONG);
		SQL_BindParam(request, entry["name"], level.MYSQL_TYPE_STRING);
		SQL_BindParam(request, entry["mode"], level.MYSQL_TYPE_STRING);
		SQL_BindParam(request, entry["way"], level.MYSQL_TYPE_STRING);
		SQL_BindParam(request, entry["player"], level.MYSQL_TYPE_STRING);
		SQL_BindParam(request, entry["run"], level.MYSQL_TYPE_STRING);
		SQL_BindParam(request, entry["tas"], level.MYSQL_TYPE_LONG);
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

addEntry(entry, index)
{
	array = [];
	entries = level.leaderboards[index].entries;

	// Remove duplicates
	for (i = 0; i < entries.size; i++)
	{
		if (entries[i]["player"] == entry["player"])
			continue;
		array[array.size] = entries[i];
	}
	array[array.size] = entry;
	level.leaderboards[index].entries = sortEntries(array);
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

getLeaderboard(mode, way, tas)
{
	tas = IfUndef(tas, 0);
	if (!isDefined(level.leaderboards) || !level.leaderboards.size)
		return undefined;
	return level.leaderboards[getLeaderboardIndex(mode, way, tas)];
}

getLeaderboardIndex(mode, way, tas)
{
	tas = IfUndef(tas, 0);
	tas = Ternary(tas, "_TAS", "");
	return fmt("times%s_%s_%s", tas, mode, way);
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

	self thread sr\core\_rank::giveRankXP("", xp);
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
	if (self sr\sys\_admins::isTAS())
		return;

	way = getLeaderboardName(entry["mode"], entry["way"]);
	index = getLeaderboardIndex(entry["mode"], entry["way"], entry["tas"]);

	message = fmt("^5New ^2WR ^7on ^6%s ^2%s ^7By ^5%s", entry["mode"], way, self.shortName);
	iPrintLnBold(message);
	comPrintLn(message);

	players = getAllPlayers();
	for (i = 0; i < players.size; i++)
	{
		players[i] thread effects();
		players[i] thread updateMenuInfo();
	}

	wait 1;
	if (speedrun\core\_demo::addSpeedrunDemo(entry))
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
