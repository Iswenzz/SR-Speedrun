#include sr\sys\_events;
#include sr\utils\_common;

initPBs()
{
    event("connect", ::onConnect);
}

onConnect()
{
    self.pbs = [];

    if (self.isBot) return;

    mutex_acquire("mysql");

	SQL_Prepare("SELECT mode, way, time FROM pbs WHERE map = ? AND player = ?");
    SQL_BindParam(level.map, level.MYSQL_TYPE_STRING);
    SQL_BindParam(self.id, level.MYSQL_TYPE_STRING);
    SQL_BindResult(level.MYSQL_TYPE_STRING, 20);
    SQL_BindResult(level.MYSQL_TYPE_STRING, 20);
    SQL_BindResult(level.MYSQL_TYPE_LONG);
    SQL_Execute();

    if (SQL_NumRows())
	{
		rows = SQL_FetchRowsDict();
		for (i = 0; i < rows.size; i++)
		{
			row = rows[i];
			mode = row["mode"];
			way = row["way"];

			if (!isDefined(self.pbs[mode]))
				self.pbs[mode] = [];
			self.pbs[mode][way] = originToTime(row["time"]);
		}
    }

    mutex_release("mysql");
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

    mutex_acquire("mysql");

    SQL_Prepare("UPDATE pbs SET time = ? WHERE map = ? AND player = ? AND mode = ? AND way = ?");
    SQL_BindParam(entry["time"].origin, level.MYSQL_TYPE_LONG);
	SQL_BindParam(level.map, level.MYSQL_TYPE_STRING);
    SQL_BindParam(entry["player"], level.MYSQL_TYPE_STRING);
    SQL_BindParam(entry["mode"], level.MYSQL_TYPE_STRING);
    SQL_BindParam(entry["way"], level.MYSQL_TYPE_STRING);
    SQL_Execute();

    if (!SQL_AffectedRows())
    {
		SQL_Prepare("INSERT INTO pbs (map, time, name, mode, way, player, run) VALUES (?, ?, ?, ?, ?, ?, ?)");
        SQL_BindParam(level.map, level.MYSQL_TYPE_STRING);
		SQL_BindParam(entry["time"].origin, level.MYSQL_TYPE_LONG);
		SQL_BindParam(entry["name"], level.MYSQL_TYPE_STRING);
		SQL_BindParam(entry["mode"], level.MYSQL_TYPE_STRING);
		SQL_BindParam(entry["way"], level.MYSQL_TYPE_STRING);
		SQL_BindParam(entry["player"], level.MYSQL_TYPE_STRING);
		SQL_BindParam(entry["run"], level.MYSQL_TYPE_STRING);
		SQL_Execute();
    }
    mutex_release("mysql");
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
