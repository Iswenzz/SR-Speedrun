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
	self sr\game\_teams::setTeam("allies");
	self eventSpawn();
	self stopDemoPlayer();
	self.demo = level.demos[id];
	self endon("demo_stop");

	if (!isDefined(self.demo))
	{
		self sr\sys\_admins::pm("^1Demo not found.");
		return false;
	}

	self.sr_mode = self.demo["mode"];
	self setStat(1700, self speedrun\player\run\_main::getLastModeStat());

	// Interpolation
	if (!isDefined(self.demoEnt))
	{
		self suicide();
		wait 0.05;

		if (!IsDemoLoaded(id))
		{
			self sr\sys\_admins::pm("^3Demo loading...");
			return false;
		}

		self.demoEnt = self PlayDemo(id);
		if (!isDefined(self.demoEnt))
		{
			self sr\sys\_admins::pm("^1Demo corrupted.");
			return false;
		}
	}

	self.sr_cheat = true;
	self.godmode = true;
	self.antiLag = false;
	self.antiElevator = false;
	return true;
}

play(id)
{
	if (!self setup(id))
	{
		self stopDemoPlayer();
		return;
	}

	self endon("death");
	self endon("disconnect");
	self endon("joined_spectators");

	self thread speedrun\player\huds\_demo::hud();

	self.prevDemoWeapon = "";

	while (self isDemoPlaying())
	{
		if (self meleeButtonPressed())
			break;

		self linkTo(self.demoEnt);
		self.demoWeapon = self getDemoWeapon();

		if (self.demoWeapon.size && self.demoWeapon != self.prevDemoWeapon
			&& self getCurrentWeapon() != self.demoWeapon)
		{
			if (!isPrecached(self.demoWeapon, "item"))
				self.demoWeapon = "beretta_mp";

			self takeAllWeapons();
			self giveWeapon(self.demoWeapon);
			self switchToWeapon(self.demoWeapon);
		}
		if (self isOnLadder())
			self disableWeapons();
		else
			self enableWeapons();

		wait 0.05;

		self.prevDemoWeapon = self.demoWeapon;
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

	if (game["state"] == "endmap")
	{
		players = getAllPlayers();
		for (i = 0; i < players.size; i++)
		{
			if (players[i].spectatorclient == self getEntityNumber() || players[i] == self)
			{
				players[i] sr\game\_teams::setTeam("spectator");
				players[i] eventSpectator();
				players[i] allowSpectateTeam("freelook", false);
				players[i] allowSpectateTeam("none", true);
			}
		}
	}
}
