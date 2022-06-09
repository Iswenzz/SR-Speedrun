#include sr\sys\_events;

main()
{
	event("spawn", ::setSpeed);
	event("spawn", ::watchWay);

	thread endmapTrig();
}

endmapTrig()
{
	array = getEntArray("endmap_trig", "targetname");
	if (!array.size)
	{
		iPrintLnBold("^1Error: No endmap_trig found.");
		return;
	}

	trigger = array[0];
	thread sr\game\fx\_trigger::createTrigFx(trigger, "red");
	while (true)
	{
		trigger waittill("trigger", player);
		player speedrun\game\_leaderboards::endTimer();
	}
}

setSpeed()
{
	if (sr\api\_speedrun::isSlide())
	{
		speed = Ternary(self.sr_mode == "210", 1.8, 1.0);
		self setMoveSpeedScale(speed);
		self setGravity(1000);
		self setJumpHeight(70);
		self setMoveSpeed(190 * level.map_slide_multiplier);
		return;
	}

	speedScale = Ternary(self.sr_mode == "210", 1.12, 1.05);
	speed = Ternary(self.sr_mode == "210", 210, 190);
	self setMoveSpeed(speed);
	self setMoveSpeedScale(speedScale);
	self setgravity(800);
}

watchWay()
{
	self endon("disconnect");
	self endon("death");
	self endon("joined_spectators");

	way = self.sr_way;
	while (true)
	{
		if (way != self.sr_way)
		{
			way = self.sr_way;
			self thread speedrun\player\huds\_speedrun::updateWay();
		}
		wait 0.1;
	}
}
