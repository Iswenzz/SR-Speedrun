#include sr\sys\_events;
#include sr\utils\_common;
#include speedrun\game\_leaderboards;

main()
{
	addMode("190", speedrun\player\run\_190::start);
	addMode("210", speedrun\player\run\_210::start);
	addMode("Portal", speedrun\player\run\_portal::start);
	addMode("Defrag", speedrun\player\run\_defrag::start);
	addMode("Bhop", speedrun\player\run\_bhop::start);

    event("map", ::endmapTrigger);
}

start()
{
	self.finishedMap = false;

	self.sr_mode = self speedrun\player\run\_main::getLastMode();
	if (sr\game\_event::isEventStarted())
		self.sr_mode = "210";
	if (self sr\game\minigames\_main::isInAnyQueue())
		self.sr_mode = "210";
	self.sr_way = "normal_0";

    self [[level.leaderboard_modes[self.sr_mode].callback]]();
	self thread playerTimer();
}

getLastMode()
{
	switch (self getStat(1700))
	{
		case 1: return "190";
		case 2: return "210";
		case 3: return "Portal";
		case 4: return "Defrag";
		case 5: return "Bhop";
	}
	return "190";
}

getLastModeStat()
{
	switch (self.sr_mode)
	{
		case "190": return 1;
		case "210": return 2;
		case "Portal": return 3;
		case "Defrag": return 4;
		case "Bhop": return 5;
	}
	return 1;
}

endmapTrigger()
{
	waitMapLoad(3);

	array = getEntArray("endmap_trig", "targetname");
	if (!array.size)
		return;

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
	self endon("spawned");
	self endon("disconnect");
	self endon("death");

	if (self.finishedMap)
		return;
	self.time = undefined;

	// Spastic delay caused by bad modding, too bad...
	self sr\game\_demo::record();
	wait 0.1;

	self speedrun\player\huds\_speedrun::updateTime();
	self.time = originToTime(getTime());
}

endTimer()
{
	if (!self isPlaying() || self isDemo() || !isDefined(self.time) || self.finishedMap)
		return;
	self.finishedMap = true;

	self.time = originToTime(getTime() - self.time.origin);
	self speedrun\player\huds\_speedrun::updateTime();

	if (!self sr\sys\_admins::isAuth())
	{
		self sr\sys\_admins::printLinkRequired();
		return;
	}
	if (self isCheat())
	{
		self iPrintLnBold("^1Your time was not saved!");
		return;
	}
	way = getLeaderboardName(self.sr_mode, self.sr_way);
	message = fmt("%s finished the map in %d:%d.%d - %s / %s",
		self.name, self.time.min, self.time.sec, self.time.ms,
		self.sr_mode, way);

	if (self sr\sys\_admins::isTAS())
		message = fmt("^5[TAS] ^7%s", message);

	iPrintLn(message);

	entry = self makeEntry();
    self thread speedrun\game\_leaderboards::saveEntry(entry);
    self thread speedrun\game\_pbs::saveEntry(entry);

	self speedrun\player\huds\_speedrun::updateRecords();
}
