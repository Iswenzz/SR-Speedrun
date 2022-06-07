#include sr\sys\_events;

main()
{
	event("spawn", ::setSpeed);
	event("spawn", ::watchWay);
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
