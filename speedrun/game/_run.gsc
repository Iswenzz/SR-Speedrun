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
	self.moveSpeedScale = sr\api\_map::getMoveSpeedScale(1.05);
	self.gravity = sr\api\_map::getGravity(800);
	self.jumpHeight = sr\api\_map::getJumpHeight(39);
	self.speed = sr\api\_map::getSpeed(190);

	if (sr\api\_speedrun::isSlide())
	{
		self.moveSpeedScale = sr\api\_map::getMoveSpeedScale(1.0);
		self.gravity = sr\api\_map::getGravity(1000);
		self.jumpHeight = sr\api\_map::getJumpHeight(70);
		self.speed = sr\api\_map::getSpeed(190 * level.map_slide_multiplier);
	}

	self.spawnMoveSpeedScale = self.moveSpeedScale;
	self.spawnGravity = self.gravity;
	self.spawnJumpHeight = self.jumpHeight;
	self.spawnSpeed = self.speed;

	self setMoveSpeedScale(self.moveSpeedScale);
	self setGravity(self.gravity);
	self setJumpHeight(self.jumpHeight);
	self setMoveSpeed(self.speed);
}

mode_210()
{
	self.moveSpeedScale = sr\api\_map::getMoveSpeedScale(1.12);
	self.gravity = sr\api\_map::getGravity(800);
	self.jumpHeight = sr\api\_map::getJumpHeight(39);
	self.speed = sr\api\_map::getSpeed(210);

	if (sr\api\_speedrun::isSlide())
	{
		self.moveSpeedScale = sr\api\_map::getMoveSpeedScale(1.8);
		self.gravity = sr\api\_map::getGravity(1000);
		self.jumpHeight = sr\api\_map::getJumpHeight(70);
		self.speed = sr\api\_map::getSpeed(190 * level.map_slide_multiplier);
	}

	self.spawnMoveSpeedScale = self.moveSpeedScale;
	self.spawnGravity = self.gravity;
	self.spawnJumpHeight = self.jumpHeight;
	self.spawnSpeed = self.speed;

	self setMoveSpeedScale(self.moveSpeedScale);
	self setGravity(self.gravity);
	self setJumpHeight(self.jumpHeight);
	self setMoveSpeed(self.speed);
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
