#include sr\sys\_events;
#include sr\utils\_common;
#include speedrun\game\_leaderboards;

main()
{
    event("spawn", ::onSpawn);

	addMode("190", speedrun\player\run\_190::start);
	addMode("210", speedrun\player\run\_210::start);
	addMode("Portal", speedrun\player\run\_portal::start);
	addMode("Defrag", speedrun\player\run\_defrag::start);

    thread endmapTrig();
}

onSpawn()
{
	self endon("disconnect");

	if (self sr\game\minigames\_main::isInAnyQueue())
		self.sr_mode = "210";
	else
		self.sr_mode = self getLastMode();
	self.sr_way = "normal_0";

	self startMode();
	self playerTimer();
}

getLastMode()
{
	switch (self getStat(1700))
	{
		case 1: return "190";
		case 2: return "210";
		case 3: return "Portal";
		case 4: return "Defrag";
	}
	return "190";
}

startMode()
{
    self [[level.leaderboard_modes[self.sr_mode].callback]]();
}

endmapTrig()
{
	waitMapLoad(2);

	array = getEntArray("endmap_trig", "targetname");
	if (!array.size)
	{
		iPrintLnBold("^1Error: No endmap_trig found.");
		return;
	}

	trigger = array[0];
	thread sr\game\fx\_trigger::effect(trigger, "red");
	while (true)
	{
		trigger waittill("trigger", player);
		player thread endTimer();
	}
}

playerTimer()
{
	self endon("disconnect");
	self endon("spawned_player");
	self endon("joined_spectators");
	self endon("death");

	if (self.finishedMap)
		return;

	if (game["state"] != "playing")
		level waittill("round_started");

	self.time = undefined;
	wait 0.1; // Spastic delay caused by bad modding, too bad...

	self.time = originToTime(getTime());
}

endTimer()
{
	if (self.finishedMap || self.sr_cheat || !self isPlaying() || !isDefined(self.time))
		return;

	self.finishedMap = true;
	self.time = originToTime(getTime() - self.time.origin);
	self speedrun\player\huds\_speedrun::updateTime();

	way = getLeaderboardName(self.sr_mode, self.sr_way);
	iPrintLn(fmt("%s finished the map in %d:%d.%d - %s / %s",
		self.name, self.time.min, self.time.sec, self.time.ms,
		self.sr_mode, way));

	entry = self makeEntry();
    speedrun\game\_leaderboards::saveEntry(entry);
    speedrun\game\_pbs::saveEntry(entry);

	self speedrun\player\huds\_speedrun::updateRecords();
}
