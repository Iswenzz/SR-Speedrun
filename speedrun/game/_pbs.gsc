#include sr\sys\_events;
#include sr\utils\_common;

initPBs()
{
    event("connect", ::onConnect);
}

onConnect()
{
    self.pbs = [];

    if (self isBot())
	{
		self setLoading("pbs", false);
		return;
	}
	critical_enter("mysql");

	request = SQL_Prepare("SELECT mode, way, time FROM pbs WHERE map = ? AND player = ?");
    SQL_BindParam(request, level.map, level.MYSQL_TYPE_STRING);
    SQL_BindParam(request, self.id, level.MYSQL_TYPE_STRING);
    SQL_BindResult(request, level.MYSQL_TYPE_STRING, 20);
    SQL_BindResult(request, level.MYSQL_TYPE_STRING, 20);
    SQL_BindResult(request, level.MYSQL_TYPE_LONG);
    SQL_Execute(request);
	AsyncWait(request);
	rows = SQL_FetchRowsDict(request);
	SQL_Free(request);

	critical_release("mysql");

    if (!isDefined(self))
		return;

	for (i = 0; i < rows.size; i++)
	{
		row = rows[i];
		mode = row["mode"];
		way = row["way"];

		if (!isDefined(self.pbs[mode]))
			self.pbs[mode] = [];
		self.pbs[mode][way] = originToTime(row["time"]);
	}
	self setLoading("pbs", false);
	self speedrun\player\huds\_speedrun::updateRecords();
}

isValidEntry(entry)
{
    mode = entry["mode"];
    way = entry["way"];

    if (!isDefined(self.pbs[mode]))
        return true;
    if (!isDefined(self.pbs[mode][way]))
        return true;
    return entry["time"].origin < self.pbs[mode][way].origin;
}

saveEntry(entry)
{
    if (!isValidEntry(entry))
		return;

    mode = entry["mode"];
    way = entry["way"];
    self.pbs[mode][way] = entry["time"];

	self thread speedrun\game\_leaderboards::updateMenuInfo();

	critical_enter("mysql");

    request = SQL_Prepare("UPDATE pbs SET time = ? WHERE map = ? AND player = ? AND mode = ? AND way = ?");
    SQL_BindParam(request, entry["time"].origin, level.MYSQL_TYPE_LONG);
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
		request = SQL_Prepare("INSERT INTO pbs (map, time, name, mode, way, player, run) VALUES (?, ?, ?, ?, ?, ?, ?)");
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

getPersonalBest(mode, way)
{
    if (!isDefined(self.pbs[mode]))
        return "";
    if (!isDefined(self.pbs[mode][way]))
        return "";
    pb = self.pbs[mode][way];
	return fmt("%d:%d.%d", pb.min, pb.sec, pb.ms);
}
