#include sr\sys\_admins;
#include sr\sys\_events;
#include sr\utils\_common;

main()
{
	cmd("leaderboard_delete_entry", "owner", ::cmd_LeaderboardDeleteEntry, 	"Delete an entry in a leaderboard");
	cmd("leaderboard_delete", 		"owner", ::cmd_LeaderboardDelete, 		"Delete a whole leaderboard");
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
