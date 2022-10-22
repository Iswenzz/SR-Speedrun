#include sr\sys\_file;
#include sr\sys\_events;
#include sr\utils\_common;

main()
{
	event("death", ::stopDemoPlayer);
}

play(id)
{
	if (!isDefined(level.demos[id]))
	{
		self sr\sys\_admins::pm("^1Demo not found.");
		return;
	}
	self.demo = level.demos[id];

	self stopDemoPlayer();
	wait 0.05;
	self endon("demo_stop");

	self.sr_cheat = true;
	self.godmode = true;
	self.antiLag = false;
	self.antiElevator = false;

	self endon("death");
	self endon("disconnect");
	self endon("joined_spectators");

	// Interpolation
	if (!isDefined(self.demoEnt))
	{
		self.demoEnt = self playDemo(id);
		// Demo not found
		if (!isDefined(self.demoEnt))
		{
			self suicide();
			return;
		}
		self linkTo(self.demoEnt);
	}
	self thread speedrun\player\huds\_demo::hud();

	while (self isDemoPlaying())
	{
		if (self meleeButtonPressed())
			break;

		wait 0.05;
	}
	self thread stopDemoPlayer();
}

stopDemoPlayer()
{
	if (isDefined(self.demoEnt))
	{
		self notify("demo_stop");
		self.demoEnt delete();
		self stopDemo();
		self suicide();

		self.godmode = undefined;
		self.antiLag = true;
		self.antiElevator = true;
	}
}
