#include sr\sys\_admins;
#include sr\sys\_events;
#include sr\utils\_common;
#include speedrun\game\_leaderboards;

main()
{
    cmd("owner", 	"leaderboard_delete",			::cmd_LeaderboardDelete);
    cmd("owner", 	"leaderboard_delete_entry",		::cmd_LeaderboardDeleteEntry);
}

cmd_LeaderboardDelete(args)
{
	if (args.size < 2)
		return self pm("Usage: leaderboard_delete <mode> <way>");

	mode = args[0];
	way = args[1];
	tas = 0;

	id = getLeaderboardIndex(mode, way, tas);
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

	request = SQL_Prepare("DELETE FROM leaderboards WHERE map = ? AND mode = ? AND way = ?");
	SQL_BindParam(request, level.map, level.MYSQL_TYPE_STRING);
	SQL_BindParam(request, mode, level.MYSQL_TYPE_STRING);
	SQL_BindParam(request, way, level.MYSQL_TYPE_STRING);
	SQL_Execute(request);
	AsyncWait(request);
	SQL_Free(request);

	critical_release("mysql");
}

cmd_LeaderboardDeleteEntry(args)
{
	if (args.size < 3)
		return self pm("Usage: leaderboard_delete_entry <mode> <way> <index>");

	mode = args[0];
	way = args[1];
	index = ToInt(args[2]);
	tas = 0;

	id = getLeaderboardIndex(mode, way, tas);
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

	level.leaderboards[id].entries = sortEntries(Remove(level.leaderboards[id].entries, entry));

	critical_enter("mysql");

	request = SQL_Prepare("DELETE FROM leaderboards WHERE map = ? AND player = ? AND mode = ? AND way = ?");
	SQL_BindParam(request, entry["map"], level.MYSQL_TYPE_STRING);
	SQL_BindParam(request, entry["player"], level.MYSQL_TYPE_STRING);
	SQL_BindParam(request, entry["mode"], level.MYSQL_TYPE_STRING);
	SQL_BindParam(request, entry["way"], level.MYSQL_TYPE_STRING);
	SQL_Execute(request);
	AsyncWait(request);
	SQL_Free(request);

	critical_release("mysql");
}
