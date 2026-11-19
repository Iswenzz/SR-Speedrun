#include sr\sys\_admins;
#include sr\sys\_events;
#include sr\utils\_common;

main()
{
	cmd("leaderboard_delete_entry", "owner", ::cmd_LeaderboardDeleteEntry, 	"Delete an entry in a leaderboard");
	cmd("leaderboard_delete", 		"owner", ::cmd_LeaderboardDelete, 		"Delete a whole leaderboard");
	cmd("epic", 					"owner", ::cmd_Epic, 					"Make a mode and way of this map an epic world record");
	cmd("remove_epic", 				"owner", ::cmd_RemoveEpic, 				"Remove an epic world record from this map");
}

cmd_Epic(args)
{
	if (args.size < 2)
	{
		self pm("Usage: epic <mode> <way>");
		self pm(fmt("^5Epic: ^7%s", epicList()));
		return;
	}
	mode = epicMode(args[0]);
	way = args[1];

	if (!isDefined(mode) || !isDefined(level.leaderboard_ways) || !isDefined(level.leaderboard_ways[way]))
		return self pm(fmt("^3Leaderboard not found ^7%s %s", args[0], way));
	if (speedrun\core\_leaderboards::isEpic(mode, way))
		return self pm(fmt("^3Already epic ^7%s %s", mode, way));

	critical_enter("mysql");

	request = SQL_Prepare("INSERT IGNORE INTO epics (map, mode, way) VALUES (?, ?, ?)");
	SQL_BindParam(request, level.map, level.MYSQL_TYPE_STRING);
	SQL_BindParam(request, mode, level.MYSQL_TYPE_STRING);
	SQL_BindParam(request, way, level.MYSQL_TYPE_STRING);
	SQL_Execute(request);
	AsyncWait(request);
	SQL_Free(request);

	critical_release("mysql");

	speedrun\core\_leaderboards::setEpic(mode, way, true);
	self pm(fmt("^5Epic ^7%s %s", mode, speedrun\core\_leaderboards::getLeaderboardName(mode, way)));
	refreshWorldRecordCounts();
}

cmd_RemoveEpic(args)
{
	if (args.size < 2)
		return self pm("Usage: remove_epic <mode> <way>");

	mode = epicMode(args[0]);
	way = args[1];

	if (!isDefined(mode) || !speedrun\core\_leaderboards::isEpic(mode, way))
		return self pm(fmt("^3Not epic ^7%s %s", args[0], way));

	critical_enter("mysql");

	request = SQL_Prepare("DELETE FROM epics WHERE map = ? AND mode = ? AND way = ?");
	SQL_BindParam(request, level.map, level.MYSQL_TYPE_STRING);
	SQL_BindParam(request, mode, level.MYSQL_TYPE_STRING);
	SQL_BindParam(request, way, level.MYSQL_TYPE_STRING);
	SQL_Execute(request);
	AsyncWait(request);
	SQL_Free(request);

	critical_release("mysql");

	speedrun\core\_leaderboards::setEpic(mode, way, false);
	self pm(fmt("^1Removed epic ^7%s %s", mode, way));
	refreshWorldRecordCounts();
}

epicMode(name)
{
	if (!isDefined(level.leaderboard_modes))
		return undefined;

	modes = getArrayKeys(level.leaderboard_modes);
	for (i = 0; i < modes.size; i++)
	{
		if (toLower(modes[i]) == toLower(name))
			return modes[i];
	}
	return undefined;
}

epicList()
{
	list = "";
	epics = getArrayKeys(level.leaderboard_epics);
	for (i = 0; i < epics.size; i++)
		list += Ternary(i, ", ", "") + level.leaderboard_epics[epics[i]];
	return Ternary(list == "", "-", list);
}

refreshWorldRecordCounts()
{
	players = getAllPlayers();
	for (i = 0; i < players.size; i++)
		players[i] thread speedrun\core\_leaderboards::refreshWorldRecordCount();
}

cmd_LeaderboardDelete(args)
{
	if (args.size < 2)
		return self pm("Usage: leaderboard_delete <mode> <way> [tas]");

	mode = args[0];
	way = args[1];
	tas = 0;
	if (args.size > 2)
		tas = ToInt(args[2]) != 0;

	id = speedrun\core\_leaderboards::getLeaderboardIndex(mode, way, tas);
	leaderboard = level.leaderboards[id];
	if (!isDefined(leaderboard) || !leaderboard.entries.size)
	{
		self pm(fmt("^3Leaderboard not found ^7%s %s", mode, way));
		return;
	}
	self pm(fmt("^1Remove ^3%d entries ^7from %s %s type ^2!confirm ^7to remove this entry.",
		leaderboard.entries.size, mode, way));

	response = self confirmation();
	if (!hasConfirmed(response))
		return;

	level.leaderboards[id].entries = [];

	critical_enter("mysql");

	request = SQL_Prepare("DELETE FROM leaderboards WHERE map = ? AND mode = ? AND way = ? AND tas = ?");
	SQL_BindParam(request, level.map, level.MYSQL_TYPE_STRING);
	SQL_BindParam(request, mode, level.MYSQL_TYPE_STRING);
	SQL_BindParam(request, way, level.MYSQL_TYPE_STRING);
	SQL_BindParam(request, tas, level.MYSQL_TYPE_LONG);
	SQL_Execute(request);
	AsyncWait(request);
	SQL_Free(request);

	critical_release("mysql");
}

cmd_LeaderboardDeleteEntry(args)
{
	if (args.size < 3)
		return self pm("Usage: leaderboard_delete_entry <mode> <way> <placement> [tas]");

	mode = args[0];
	way = args[1];
	index = ToInt(args[2]) - 1;
	tas = 0;
	if (args.size > 3)
		tas = ToInt(args[3]) != 0;

	id = speedrun\core\_leaderboards::getLeaderboardIndex(mode, way, tas);
	leaderboard = level.leaderboards[id];
	if (!isDefined(leaderboard) || !leaderboard.entries.size || !isDefined(leaderboard.entries[index]))
	{
		self pm(fmt("^3Entry not found for leaderboard ^7%s %s", mode, way));
		return;
	}
	entry = leaderboard.entries[index];
	self pm(fmt("^1Remove ^7%s %s %s type ^2!confirm ^7to remove this entry.",
		entry["name"], entry["mode"], entry["way"]));

	response = self confirmation();
	if (!hasConfirmed(response))
		return;

	level.leaderboards[id].entries = Remove(level.leaderboards[id].entries, entry);

	critical_enter("mysql");

	request = SQL_Prepare("DELETE FROM leaderboards WHERE map = ? AND player = ? AND mode = ? AND way = ? AND tas = ?");
	SQL_BindParam(request, entry["map"], level.MYSQL_TYPE_STRING);
	SQL_BindParam(request, entry["player"], level.MYSQL_TYPE_STRING);
	SQL_BindParam(request, entry["mode"], level.MYSQL_TYPE_STRING);
	SQL_BindParam(request, entry["way"], level.MYSQL_TYPE_STRING);
	SQL_BindParam(request, tas, level.MYSQL_TYPE_LONG);
	SQL_Execute(request);
	AsyncWait(request);
	SQL_Free(request);

	critical_release("mysql");
}
