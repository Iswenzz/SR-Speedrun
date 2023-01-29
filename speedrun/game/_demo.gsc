#include sr\sys\_file;
#include sr\sys\_events;
#include sr\utils\_common;

main()
{
	event("death", ::stopDemoPlayer);
}

setup(id)
{
	self stopDemoPlayer();

	if (!isDefined(level.demos[id]))
	{
		self pm("^1Demo not found.");
		return false;
	}

	self.demo = level.demos[id];
	self.sr_mode = self.demo["mode"];
	self sr\game\_teams::setTeam("allies");
	self setStat(1700, self speedrun\player\run\_main::getLastModeStat());
	self eventSpawn(true);

	if (isDefined(self.demoCamera))
		return false;

	if (!IsDemoLoaded(id))
	{
		self pm("^3Demo loading...");
		return false;
	}

	self.demoCamera = self PlayDemo(id);
	if (!isDefined(self.demoCamera))
	{
		self pm("^1Demo corrupted.");
		return false;
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

	self endon("spawned");
	self endon("death");
	self endon("disconnect");

	self thread speedrun\player\huds\_demo::hud();
	self.prevDemoWeapon = "";

	while (self isReallyAlive() && self isDemoPlaying())
	{
		if (self meleeButtonPressed())
			break;

		self linkTo(self.demoCamera);
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
	if (!isDefined(self.demoCamera))
		return;

	self.demoCamera delete();
	self.demo = undefined;
	self.godmode = undefined;
	self stopDemo();
	self suicide();

	if (game["state"] == "end")
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
