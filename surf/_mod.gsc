#include sr\sys\_events;
#include sr\utils\_math;
#include surf\_util;

main()
{
	event("map", ::mapLogic);
}

mapLogic()
{
	teleporters = getEntArray("trigger_teleport", "targetname");
	for (i = 0; i < teleporters.size; i++)
		teleporters[i] thread teleporter();

	boosters = getEntArray("trigger_boost", "targetname");
	for (i = 0; i < boosters.size; i++)
		boosters[i] thread booster();

	speedBoosts = getEntArray("trigger_speed", "targetname");
	for (i = 0; i < speedBoosts.size; i++)
		speedBoosts[i] thread speedBoost();
}

teleporter()
{
	if (!isDefined(self.target))
	{
		print("WARNING: teleporter without target!\n");
		return;
	}
	targets = getEntArray(self.target, "targetname");
	if (!targets.size)
	{
		print("WARNING: trigger without target.\n");
		return;
	}
	while (true)
	{
		self waittill("trigger", player);

		target = targets[randomInt(targets.size)];

		player setOrigin(target.origin);
		player setPlayerAngles(target.angles);

		if (isDefined(self.script_noteworthy) && self.script_noteworthy == "slowdown")
			player setVelocity((0, 0, 0));
		else
			player setVelocityBase(vectorScale(anglesToForward(target.angles), length(player getVelocityBase())));
		wait 0.05;
	}
}

booster()
{
	speed = strTok(self.target, " ");
	speed = (int(speed[0]), int(speed[1]), int(speed[2]));

	while (true)
	{
		self waittill("trigger", player);
		player setVelocity(player getVelocity() + speed);
	}
}

speedBoost()
{
	speedScale = strTok(self.target, " ");
	speedScale = (float(speedScale[0]), float(speedScale[1]), float(speedScale[2]));

	while (true)
	{
		self waittill("trigger", player);
		player setVelocity(player getVelocity() * speedScale);
	}
}

setVelocityBase(velocity)
{
	if (!isDefined(self.baseVelocity))
		self.baseVelocity = ( 0, 0, 0 );
	if (!isDefined(self.baseVelocityLast))
		self.baseVelocityLast = 0;
	if (getTime() - self.baseVelocityLast > 100)
		self.baseVelocity = (0, 0, 0);

	velocity += self.baseVelocity;
	self setVelocity(velocity);
}

getVelocityBase()
{
	if (!isDefined( self.baseVelocity))
		self.baseVelocity = (0, 0, 0);
	if (!isDefined( self.baseVelocityLast))
		self.baseVelocityLast = 0;
	if (getTime() - self.baseVelocityLast > 100)
		self.baseVelocity = (0, 0, 0);

	ret = self getVelocity();
	ret -= self.baseVelocity;
	return ret;
}
