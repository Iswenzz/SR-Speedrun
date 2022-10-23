#include sr\sys\_file;
#include sr\sys\_events;
#include sr\utils\_common;

main()
{
	event("death", ::stopDemoPlayer);
}

setup(id)
{
	if (!isDefined(level.demos[id]))
	{
		self sr\sys\_admins::pm("^1Demo not found.");
		return false;
	}
	self stopDemoPlayer();
	self.demo = level.demos[id];
	self endon("demo_stop");

	// Interpolation
	if (!isDefined(self.demoEnt))
	{
		self suicide();
		wait 0.05;
		self.demoEnt = self playDemo(id);
		if (!isDefined(self.demoEnt))
			return false;

		self linkTo(self.demoEnt);
	}

	self.sr_cheat = true;
	self.godmode = true;
	self.antiLag = false;
	self.antiElevator = false;
	return true;
}

play(id)
{
	if(!self setup(id))
		return;

	self endon("death");
	self endon("disconnect");
	self endon("joined_spectators");

	self thread speedrun\player\huds\_demo::hud();

	while (self isDemoPlaying())
	{
		if (self meleeButtonPressed())
			break;

		if (self isOnLadder())
			self disableWeapons();
		else
			self enableWeapons();

		wait 0.05;
	}
	self thread stopDemoPlayer();
}

stopDemoPlayer()
{
	if (!isDefined(self.demoEnt))
		return;

	self notify("demo_stop");
	self.demoEnt delete();
	self.demo = undefined;
	self stopDemo();
	self suicide();

	self.godmode = undefined;
	self.antiLag = true;
	self.antiElevator = true;
}
