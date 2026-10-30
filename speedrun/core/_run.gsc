#include sr\sys\_events;
#include sr\utils\_common;

main()
{
    event("map", ::endmapTrigger);
    event("practise_save", ::practiseSave);
    event("practise_load", ::practiseLoad);
    event("practise_rewind", ::practiseRewind);
}

// A practise load resumes the timer from the time of the save, so a section is timed as part of a full run.
practiseSave(save)
{
	if (isDefined(self.time) && !self.finishedMap)
		save.time = getTime() - self.time.origin;
}

practiseLoad(save)
{
	if (!isDefined(save.time))
		return;

	self.finishedMap = false;
	self.time = originToTime(getTime() - save.time);
	self timerHistory(self.time.origin);
	self speedrun\huds\_speedrun::resumeTime(save.time);
}

// A rewind puts the timer back to what it read at the frame it lands on.
practiseRewind(rewind)
{
	entry = self timerAt(rewind.time);

	// Landing after the finish keeps the finished time.
	if (isDefined(entry) && !isDefined(entry.start))
		return;

	// A frame from before the timer started puts it back at zero.
	elapsed = 0;
	if (isDefined(entry))
		elapsed = rewind.time - entry.start;

	self.finishedMap = false;
	self.time = originToTime(getTime() - elapsed);
	self timerHistory(self.time.origin);
	self speedrun\huds\_speedrun::resumeTime(elapsed);
}

// Every start the timer takes since the spawn, undefined once finished, so a rewind can find the one in
// effect at its frame. Past the 12.8 s SR-Server records, only the entry in effect at that edge matters.
timerHistory(start)
{
	now = getTime();
	previous = IfUndef(self.timerHistory, []);
	history = [];

	for (i = 0; i < previous.size; i++)
	{
		if (i + 1 < previous.size && previous[i + 1].at <= now - 13000)
			continue;
		history[history.size] = previous[i];
	}

	entry = spawnStruct();
	entry.at = now;
	entry.start = start;
	history[history.size] = entry;
	self.timerHistory = history;
}

timerAt(time)
{
	if (!isDefined(self.timerHistory))
		return undefined;

	for (i = self.timerHistory.size - 1; i >= 0; i--)
	{
		if (self.timerHistory[i].at <= time)
			return self.timerHistory[i];
	}
	return undefined;
}

start()
{
	self.finishedMap = false;

	self.sr_mode = self getMode();
	self.sr_way = "normal_0";

	if (self getStat(1700) != self getModeStat())
		self setStat(1700, self getModeStat());

	self setQ3Weapons(self.teamKill, false);

	switch (self.sr_mode)
	{
		case "190":
			self.speed = sr\api\_map::getSpeed(190);
			self.jumpHeight = sr\api\_map::getJumpHeight(39);
			self.gravity = sr\api\_map::getGravity(800);
			self.moveSpeedScale = sr\api\_map::getMoveSpeedScale(1.05);
			if (isSlide())
			{
				self.moveSpeedScale = sr\api\_map::getMoveSpeedScale(1.0);
				self.gravity = sr\api\_map::getGravity(1000);
				self.jumpHeight = sr\api\_map::getJumpHeight(70);
				self.speed = sr\api\_map::getSpeed(190 * level.map_slide_multiplier);
			}
			break;

		case "210":
			self.speed = sr\api\_map::getSpeed(210);
			self.jumpHeight = sr\api\_map::getJumpHeight(39);
			self.gravity = sr\api\_map::getGravity(800);
			self.moveSpeedScale = sr\api\_map::getMoveSpeedScale(1.12);
			if (isSlide())
			{
				self.moveSpeedScale = sr\api\_map::getMoveSpeedScale(1.8);
				self.gravity = sr\api\_map::getGravity(1000);
				self.jumpHeight = sr\api\_map::getJumpHeight(70);
				self.speed = sr\api\_map::getSpeed(190 * level.map_slide_multiplier);
			}
			break;

		case "Q3":
		case "Q3CPM":
		case "Q3CPMW":
			self.speed = sr\api\_map::getSpeed(320);
			self.jumpHeight = sr\api\_map::getJumpHeight(39);
			self.gravity = sr\api\_map::getGravity(800);
			self.moveSpeedScale = sr\api\_map::getMoveSpeedScale(1.0);

			if (self isQ3W())
			{
				self takeAllWeapons();
				self giveWeapon(level.q3Weapons["rl"]);
				self giveWeapon(level.q3Weapons["pg"]);
				self setSpawnWeapon(level.q3Weapons["rl"]);
			}
			else
			{
				for (i = 0; i < level.q3StartWeapons.size; i++)
				{
					weapon = level.q3Weapons[level.q3StartWeapons[i]];
					if (!isDefined(weapon))
						continue;
					self giveWeapon(weapon);
					self setWeaponAmmoStock(weapon, 0);
					self setWeaponAmmoClip(weapon, IfUndef(level.q3StartAmmo, 0));
					if (i == 0)
						self setSpawnWeapon(weapon);
				}
			}
			break;

		case "CS":
			self.speed = sr\api\_map::getSpeed(250);
			self.jumpHeight = sr\api\_map::getJumpHeight(39);
			self.gravity = sr\api\_map::getGravity(800);
			self.moveSpeedScale = sr\api\_map::getMoveSpeedScale(1.0);
			break;

		case "Portal":
			self.speed = sr\api\_map::getSpeed(250);
			self.jumpHeight = sr\api\_map::getJumpHeight(39);
			self.gravity = sr\api\_map::getGravity(800);
			self.moveSpeedScale = sr\api\_map::getMoveSpeedScale(1.0);
			self allowAds(true);
			self takeAllWeapons();
			self giveWeapon(level.portalgun);
			self setSpawnWeapon(level.portalgun);
			self giveMaxAmmo(level.portalgun);
			break;
	}
	self.spawnMoveSpeedScale = self.moveSpeedScale;
	self.spawnGravity = self.gravity;
	self.spawnJumpHeight = self.jumpHeight;
	self.spawnSpeed = self.speed;

	self setMoveSpeedScale(self.moveSpeedScale);
	self setGravity(self.gravity);
	self setJumpHeight(self.jumpHeight);
	self setMoveSpeed(self.speed);

	self thread playerTimer();
}

getMode()
{
	if (isDefined(self.demo))
		return self.sr_mode;
	if (isDefined(self.sr_mode_force))
		return self.sr_mode_force;
	if (isSurf())
		return "CS";
	if (sr\core\_event::isEventStarted())
		return "210";
	if (self sr\core\_minigames::isInAnyQueue())
		return "210";

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

getModeStat()
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
	self.timerHistory = [];

	// Spastic delay caused by bad modding, too bad...
	self sr\core\_demo::record();
	wait 0.1;

	self speedrun\huds\_speedrun::updateTime();
	self.time = originToTime(getTime());
	self timerHistory(self.time.origin);
}

endTimer()
{
	if (!self isPlaying() || self isDemo() || !isDefined(self.time) || self.finishedMap)
		return;
	self.finishedMap = true;

	self.time = originToTime(getTime() - self.time.origin);
	self timerHistory(undefined);
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
	message = fmt("%s finished the map in %s - %s / %s",
		self.name, formatTime(self.time), self.sr_mode, way);

	if (self sr\sys\_admins::isTAS())
		message = fmt("^5[TAS] ^7%s", message);

	iPrintLn(message);

	entry = self speedrun\core\_leaderboards::makeEntry();
    self thread speedrun\core\_leaderboards::saveEntry(entry);
    self thread speedrun\core\_pbs::saveEntry(entry);

	self speedrun\huds\_speedrun::updateRecords();
}

// fmt has no zero-padding, so 1:03.005 would otherwise read as 1:3.5.
formatTime(time, tenths)
{
	sec = time.sec + "";
	if (time.sec < 10)
		sec = "0" + sec;

	if (isDefined(tenths) && tenths)
		return fmt("%d:%s.%d", time.min, sec, int(time.ms / 100));

	ms = time.ms + "";
	while (ms.size < 3)
		ms = "0" + ms;
	return fmt("%d:%s.%s", time.min, sec, ms);
}
