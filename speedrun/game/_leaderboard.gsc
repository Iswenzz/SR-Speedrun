#include sr\sys\_menu;
#include sr\utils\_common;

main()
{
	level.leaderboards = [];
	level.leaderboard_max_entries = 30;
	level.leaderboard_xps = xpTable();

	menu("sr_leaderboard", "open", ::menu_Open);
	menu_multiple("sr_leaderboard", "way", ::menu_Leaderboard);
	menu_multiple("sr_leaderboard", "filter", ::menu_Filter);
}

menu_Open(arg)
{
	self.leaderboard_way = IfUndef(self.leaderboard_way, "ns0");
	self.leaderboard_filter = IfUndef(self.leaderboard_filter, "190");

	self display();
}

menu_Leaderboard(arg)
{
	args = strTok(arg, ":");
	way = args[1];

	self.leaderboard_way = way;
	self display();
}

menu_Filter(arg)
{
	args = strTok(arg, ":");
	filter = args[1];

	self.leaderboard_filter = filter;
	self display();
}

load()
{
	sr\sys\_mysql::prepare("SELECT speed, way, time, name FROM speedrun_leaderboards WHERE map = ?");
	SQL_BindParam(getDvar("mapname"), level.MYSQL_TYPE_STRING);
	SQL_BindResult(level.MYSQL_TYPE_STRING, 3);
	SQL_BindResult(level.MYSQL_TYPE_LONG);
	SQL_BindResult(level.MYSQL_TYPE_LONG);
	SQL_BindResult(level.MYSQL_TYPE_LONG);
	SQL_BindResult(level.MYSQL_TYPE_STRING, 32);
	sr\sys\_mysql::execute();

	rows = SQL_FetchRowsDict();
	for (i = 0; i < rows.size; i++)
	{
		speed = rows[i]["speed"];
		way = rows[i]["way"];
		name = fmt("times_%d_%s", speed, way);

		if (!isDefined(level.leaderboards[name]))
			level.leaderboards[name] = [];

		level.leaderboards[name][i]["speed"] = speed;
		level.leaderboards[name][i]["way"] = way;
		level.leaderboards[name][i]["time"] = originToTime(rows[i]["time"]);
		level.leaderboards[name][i]["name"] = rows[i]["name"];
	}
}

makeEntry()
{
	entry = [];
	entry["name"] = self.shortName;
	entry["id"] = self.id;
	entry["runId"] = self.runId;
	entry["way"] = self.sr_way;
	entry["speed"] = self.sr_speed;
	entry["time"] = originToTime(self.time);
	return entry;
}

isValidEntry(entry)
{
	entries = getLeaderboardEntries(entry["speed"], entry["way"]);
	return getEntryPlacement(entry, entries) <= level.leaderboard_max_entries;
}

saveEntry(entry)
{
	self endon("disconnect");

	entries = getLeaderboardEntries(entry["speed"], entry["way"]);
	entries[entries.size] = entry;
	entries = sortEntries(entries);

	placement = getEntryPlacement(entry, entries);
	self givePlacementXP(placement);
	if (placement == 1)
		self thread worldRecord();

	// // Update
	// sr\sys\_mysql::prepare("UPDATE speedrun_leaderboards SET time = ?, name = ?, runId = ? WHERE map = ?, id = ?, speed = ?, way = ?");
	// SQL_BindParam(entry["time"], level.MYSQL_TYPE_LONG);
	// SQL_BindParam(entry["name"], level.MYSQL_TYPE_STRING);
	// SQL_BindParam(entry["runId"], level.MYSQL_TYPE_LONG);
	// SQL_BindParam(getDvar("mapname"), level.MYSQL_TYPE_STRING);
	// SQL_BindParam(entry["id"], level.MYSQL_TYPE_LONG);
	// SQL_BindParam(entry["speed"], level.MYSQL_TYPE_LONG);
	// SQL_BindParam(entry["way"], level.MYSQL_TYPE_STRING);
	// sr\sys\_mysql::execute();

	// // Insert
	// if (!SQL_AffectedRows())
	// {
	// 	sr\sys\_mysql::prepare("INSERT INTO speedrun_leaderboards (map, time, name, speed, way, id, runId) VALUES (?, ?, ?, ?, ?, ?, ?)");
	// 	SQL_BindParam(getDvar("mapname"), level.MYSQL_TYPE_STRING);
	// 	SQL_BindParam(entry["time"], level.MYSQL_TYPE_LONG);
	// 	SQL_BindParam(entry["name"], level.MYSQL_TYPE_STRING);
	// 	SQL_BindParam(entry["speed"], level.MYSQL_TYPE_LONG);
	// 	SQL_BindParam(entry["way"], level.MYSQL_TYPE_STRING);
	// 	SQL_BindParam(entry["id"], level.MYSQL_TYPE_LONG);
	// 	SQL_BindParam(entry["runId"], level.MYSQL_TYPE_LONG);
	// 	sr\sys\_mysql::execute();
	// }
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

	entries = getLeaderboardEntries(self.leaderboard_way, self.leaderboard_filter);
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

getLeaderboardEntries(speed, way)
{
	name = fmt("times_%d_%s", speed, way);
	return level.leaderboards[name];
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

	self sr\sys\_rank::giveRankXP("", level.leaderboard_xps[placement - 1]);
}

worldRecord(entry)
{
	players = getAllPlayers();

	iPrintLnBold(fmt("^5New ^2WR ^7on ^6%d ^2%s ^7By ^5%s", entry["speed"], entry["way"], self.shortName));

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
