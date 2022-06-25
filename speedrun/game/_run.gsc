#include sr\sys\_events;
#include sr\utils\_common;
#include speedrun\game\_leaderboards;

main()
{
    event("spawn", ::onSpawn);

	addMode("190", ::mode_190);
	addMode("210", ::mode_210);

    thread endmapTrig();
}

mode_190()
{
	if (sr\api\_speedrun::isSlide())
	{
		self setMoveSpeedScale(1.0);
		self setGravity(1000);
		self setJumpHeight(70);
		self setMoveSpeed(190 * level.map_slide_multiplier);
		return;
	}
	self setMoveSpeed(190);
	self setMoveSpeedScale(1.05);
	self setgravity(800);
}

mode_210()
{
	if (sr\api\_speedrun::isSlide())
	{
		self setMoveSpeedScale(1.8);
		self setGravity(1000);
		self setJumpHeight(70);
		self setMoveSpeed(190 * level.map_slide_multiplier);
		return;
	}
	self setMoveSpeed(210);
	self setMoveSpeedScale(1.12);
	self setgravity(800);
}

onSpawn()
{
	self endon("disconnect");

	self.sr_mode = IfUndef(self.sr_mode, "190");
	self.sr_way = "normal_0";
	
	self startMode();
	self playerTimer();
}

startMode()
{
    self [[level.leaderboard_modes[self.sr_mode].callback]]();
}

endmapTrig()
{
	wait 5;
	
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
		player endTimer();
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

	wait 0.1; // Spastic delay caused by bad modding, too bad...

	self.time = originToTime(getTime());
}

endTimer()
{
	if (self.finishedMap || self.sr_cheat)
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
