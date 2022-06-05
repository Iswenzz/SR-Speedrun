#include sr\sys\_events;
#include sr\utils\_common;

main()
{
	level.leaderboards = [];
	level.leaderboard_modes = [];
	level.leaderboard_max_page = 7;
	level.leaderboard_max_entries = 30;
	level.leaderboard_xps = xpTable();

	addMode("190");
	addMode("210");

	menu("sr_leaderboard", "open", ::menu_Open);
	menu_multiple("sr_leaderboard", "way", ::menu_Leaderboard);
	menu_multiple("sr_leaderboard", "mode", ::menu_Mode);

	event("connect", ::onConnect);

	load();
}

menu_Open(arg)
{
	self.leaderboard_way = IfUndef(self.leaderboard_way, "ns0");
	self.leaderboard_mode = IfUndef(self.leaderboard_mode, "190");

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
		self setClientDvar(fmt("%s_name", leaderboard.id), "-");
	}
}

load()
{
	mutex_acquire("mysql");

	SQL_Prepare("SELECT mode, way, time, name FROM speedrun_leaderboards WHERE map = ?");
	SQL_BindParam(getDvar("mapname"), level.MYSQL_TYPE_STRING);
	SQL_BindResult(level.MYSQL_TYPE_STRING, 3);
	SQL_BindResult(level.MYSQL_TYPE_LONG);
	SQL_BindResult(level.MYSQL_TYPE_LONG);
	SQL_BindResult(level.MYSQL_TYPE_LONG);
	SQL_BindResult(level.MYSQL_TYPE_STRING, 32);
	SQL_Execute();

	rows = SQL_FetchRowsDict();
	for (i = 0; i < rows.size; i++)
	{
		mode = rows[i]["mode"];
		way = rows[i]["way"];
		name = getLeaderboardName(mode, way);

		level.leaderboards[name].entries[i]["mode"] = mode;
		level.leaderboards[name].entries[i]["way"] = way;
		level.leaderboards[name].entries[i]["time"] = originToTime(rows[i]["time"]);
		level.leaderboards[name].entries[i]["name"] = rows[i]["name"];
	}
	mutex_release("mysql");
}

makeEntry()
{
	entry = [];
	entry["name"] = self.shortName;
	entry["id"] = self.id;
	entry["runId"] = self.runId;
	entry["way"] = self.sr_way;
	entry["mode"] = self.sr_mode;
	entry["time"] = originToTime(self.time);
	return entry;
}

isValidEntry(entry)
{
	entries = getLeaderboardEntries(entry["mode"], entry["way"]);
	return getEntryPlacement(entry, entries) <= level.leaderboard_max_entries;
}

saveEntry(entry)
{
	self endon("disconnect");

	entries = getLeaderboardEntries(entry["mode"], entry["way"]);
	entries[entries.size] = entry;
	entries = sortEntries(entries);

	placement = getEntryPlacement(entry, entries);
	self givePlacementXP(placement);
	if (placement == 1)
		self thread worldRecord();

	mutex_acquire("mysql");

	// Update
	SQL_Prepare("UPDATE speedrun_leaderboards SET time = ?, name = ?, runId = ? WHERE map = ?, id = ?, mode = ?, way = ?");
	SQL_BindParam(entry["time"], level.MYSQL_TYPE_LONG);
	SQL_BindParam(entry["name"], level.MYSQL_TYPE_STRING);
	SQL_BindParam(entry["runId"], level.MYSQL_TYPE_LONG);
	SQL_BindParam(getDvar("mapname"), level.MYSQL_TYPE_STRING);
	SQL_BindParam(entry["id"], level.MYSQL_TYPE_LONG);
	SQL_BindParam(entry["mode"], level.MYSQL_TYPE_LONG);
	SQL_BindParam(entry["way"], level.MYSQL_TYPE_STRING);
	SQL_Execute();

	// Insert
	if (!SQL_AffectedRows())
	{
		SQL_Prepare("INSERT INTO speedrun_leaderboards (map, time, name, mode, way, id, runId) VALUES (?, ?, ?, ?, ?, ?, ?)");
		SQL_BindParam(getDvar("mapname"), level.MYSQL_TYPE_STRING);
		SQL_BindParam(entry["time"], level.MYSQL_TYPE_LONG);
		SQL_BindParam(entry["name"], level.MYSQL_TYPE_STRING);
		SQL_BindParam(entry["mode"], level.MYSQL_TYPE_LONG);
		SQL_BindParam(entry["way"], level.MYSQL_TYPE_STRING);
		SQL_BindParam(entry["id"], level.MYSQL_TYPE_LONG);
		SQL_BindParam(entry["runId"], level.MYSQL_TYPE_LONG);
		SQL_Execute();
	}
	mutex_release("mysql");
}

addMode(name)
{
	level.leaderboard_modes[level.leaderboard_modes.size] = name;
}

addWay(id, name)
{
	modes = level.leaderboard_modes;
	for (i = 0; i < modes.size; i++)
	{
		name = getLeaderboardName(modes[i], id);
		level.leaderboards[name] = spawnStruct();
		level.leaderboards[name].entries = [];
		level.leaderboards[name].id = id;
		level.leaderboards[name].name = name;
	}
}

display()
{
	numbers = "";
	names = "";
	times = "";

	for (i = 0; i < level.leaderboard_max_entries / 10; i++)
	{
		self setClientDvar("leaderboard_numbers_" + i, "");
		self setClientDvar("leaderboard_names_" + i, "");
		self setClientDvar("leaderboard_values_" + i, "");
	}

	entries = getLeaderboardEntries(self.leaderboard_way, self.leaderboard_mode);
	for (i = 1; i <= entries.size; i++)
    {
        numbers += "#" + i + "\n";
        color = Ternary(self sr\sys\_admins::isVIP(), "^2", "^7");

		switch (i)
		{
			case 1: color = "^3"; break;
			case 2: color = "^8"; break;
			case 3: color = "^9"; break;
		}

		names += fmt("%s%s\n", color, getSubStr(entries[i]["name"], 0, 15));
		times += fmt("%d:%d.%d\n", entries[i]["time"].min, entries[i]["time"].sec, entries[i]["time"].milsec);
    }
}

sortEntries(entries)
{
	for (i = 0; i < entries.size; i++)
	{
		for (z = 0; z < entries.size - 1; z++)
		{
			if (entries[z]["time"].origin > entries[z + 1]["time"].origin)
			{
				temp = entries[z + 1];
				entries[z + 1] = entries[z];
				entries[z] = temp;
			}
		}
	}
	return entries;
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

getLeaderboardName(mode, way)
{
	return fmt("times_%s_%s", mode, way);
}

getLeaderboardEntries(mode, way)
{
	name = getLeaderboardName(mode, way);
	return level.leaderboards[name].entries;
}

getEntryPlacement(entry, entries)
{
	for (i = 1; i <= entries.size; i++)
	{
		if (entries[i]["id"] == entry["id"] && entries[i]["runId"] == entry["runId"])
			return i;
	}
	return 0;
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

	iPrintLnBold(fmt("^5New ^2WR ^7on ^6%s ^2%s ^7By ^5%s", entry["mode"], entry["way"], self.shortName));

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
