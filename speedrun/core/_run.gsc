#include sr\sys\_events;
#include sr\utils\_common;

main()
{
	speedrun\core\_leaderboards::addMode("190", ::start_190);
	speedrun\core\_leaderboards::addMode("210", ::start_210);
	speedrun\core\_leaderboards::addMode("Q3", ::start_Q3);
	speedrun\core\_leaderboards::addMode("Q3CPM", ::start_Q3);
	speedrun\core\_leaderboards::addMode("Q3CPMW", ::start_Q3W);
	speedrun\core\_leaderboards::addMode("CS", ::start_CS);
	speedrun\core\_leaderboards::addMode("Portal", ::start_Portal);

    event("map", ::endmapTrigger);
}

start()
{
	self.finishedMap = false;

	self.sr_mode = self getLastMode();
	if (sr\core\_event::isEventStarted())
		self.sr_mode = "210";
	if (self sr\core\_minigames::isInAnyQueue())
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
		case 3: return "Q3";
		case 4: return "Q3CPM";
		case 5: return "Q3CPMW";
		case 6: return "CS";
		case 7: return "Portal";
	}
	return "190";
}

getLastModeStat()
{
	switch (self.sr_mode)
	{
		case "190": return 1;
		case "210": return 2;
		case "Q3": return 3;
		case "Q3CPM": return 4;
		case "Q3CPMW": return 5;
		case "CS": return 6;
		case "Portal": return 7;
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
	thread sr\fx\_trigger::effect(trigger, "red");
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
	self sr\core\_demo::record();
	wait 0.1;

	self speedrun\huds\_speedrun::updateTime();
	self.time = originToTime(getTime());
}

endTimer()
{
	if (!self isPlaying() || self isDemo() || !isDefined(self.time) || self.finishedMap)
		return;
	self.finishedMap = true;

	self.time = originToTime(getTime() - self.time.origin);
	self speedrun\huds\_speedrun::updateTime();

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
	way = speedrun\core\_leaderboards::getLeaderboardName(self.sr_mode, self.sr_way);
	message = fmt("%s finished the map in %d:%d.%d - %s / %s",
		self.name, self.time.min, self.time.sec, self.time.ms,
		self.sr_mode, way);

	if (self sr\sys\_admins::isTAS())
		message = fmt("^5[TAS] ^7%s", message);

	iPrintLn(message);

	entry = self speedrun\core\_leaderboards::makeEntry();
    self thread speedrun\core\_leaderboards::saveEntry(entry);
    self thread speedrun\core\_pbs::saveEntry(entry);

	self speedrun\huds\_speedrun::updateRecords();
}

start_190()
{
	self.moveSpeedScale = sr\api\_map::getMoveSpeedScale(1.05);
	self.gravity = sr\api\_map::getGravity(800);
	self.jumpHeight = sr\api\_map::getJumpHeight(39);
	self.speed = sr\api\_map::getSpeed(190);

	if (isSlide())
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

start_210()
{
	self.moveSpeedScale = sr\api\_map::getMoveSpeedScale(1.12);
	self.gravity = sr\api\_map::getGravity(800);
	self.jumpHeight = sr\api\_map::getJumpHeight(39);
	self.speed = sr\api\_map::getSpeed(210);

	if (isSlide())
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

start_Q3()
{
	self.moveSpeedScale = sr\api\_map::getMoveSpeedScale(1.0);
	self.gravity = sr\api\_map::getGravity(800);
	self.jumpHeight = sr\api\_map::getJumpHeight(39);
	self.speed = sr\api\_map::getSpeed(320);

	self.spawnMoveSpeedScale = self.moveSpeedScale;
	self.spawnGravity = self.gravity;
	self.spawnJumpHeight = self.jumpHeight;
	self.spawnSpeed = self.speed;

	self setMoveSpeedScale(self.moveSpeedScale);
	self setGravity(self.gravity);
	self setJumpHeight(self.jumpHeight);
	self setMoveSpeed(self.speed);
}

start_Q3W()
{
	self.moveSpeedScale = sr\api\_map::getMoveSpeedScale(1.0);
	self.gravity = sr\api\_map::getGravity(800);
	self.jumpHeight = sr\api\_map::getJumpHeight(39);
	self.speed = sr\api\_map::getSpeed(320);

	self.spawnMoveSpeedScale = self.moveSpeedScale;
	self.spawnGravity = self.gravity;
	self.spawnJumpHeight = self.jumpHeight;
	self.spawnSpeed = self.speed;

	self setMoveSpeedScale(self.moveSpeedScale);
	self setGravity(self.gravity);
	self setJumpHeight(self.jumpHeight);
	self setMoveSpeed(self.speed);

	if (!level.q3StartWeapons.size)
	{
		for (i = 0; i < level.weapons.size; i++)
		{
			weapon = level.weapons[i]["item"];
			self setWeaponAmmoClip(weapon, 0);
			self setWeaponAmmoStock(weapon, 0);
		}
		return;
	}
	self takeAllWeapons();
	for (i = 0; i < level.q3StartWeapons.size; i++)
	{
		weapon = level.q3Weapons[level.q3StartWeapons[i]];
		self giveWeapon(weapon);
		if (i == 0)
			self setSpawnWeapon(weapon);
	}
}

start_CS()
{
	self.moveSpeedScale = sr\api\_map::getMoveSpeedScale(1.0);
	self.gravity = sr\api\_map::getGravity(800);
	self.jumpHeight = sr\api\_map::getJumpHeight(39);
	self.speed = sr\api\_map::getSpeed(250);

	self.spawnMoveSpeedScale = self.moveSpeedScale;
	self.spawnGravity = self.gravity;
	self.spawnJumpHeight = self.jumpHeight;
	self.spawnSpeed = self.speed;

	self setMoveSpeedScale(self.moveSpeedScale);
	self setGravity(self.gravity);
	self setJumpHeight(self.jumpHeight);
	self setMoveSpeed(self.speed);
}

start_Portal()
{
	self.moveSpeedScale = sr\api\_map::getMoveSpeedScale(1.0);
	self.gravity = sr\api\_map::getGravity(800);
	self.jumpHeight = sr\api\_map::getJumpHeight(39);
	self.speed = sr\api\_map::getSpeed(250);

	self.spawnMoveSpeedScale = self.moveSpeedScale;
	self.spawnGravity = self.gravity;
	self.spawnJumpHeight = self.jumpHeight;
	self.spawnSpeed = self.speed;

	self setMoveSpeedScale(self.moveSpeedScale);
	self setGravity(self.gravity);
	self setJumpHeight(self.jumpHeight);
	self setMoveSpeed(self.speed);

	weapon = level.portalgun;
	self allowAds(true);
	self takeAllWeapons();
	self giveWeapon(weapon);
	self setSpawnWeapon(weapon);
	self giveMaxAmmo(weapon);
}
