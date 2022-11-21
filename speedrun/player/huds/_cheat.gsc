#include sr\sys\_events;

main()
{
	event("spawn", ::hud);
	event("spectator", ::spec);
}

hud()
{
	self endon("disconnect");
	self endon("death");
}

spec()
{
	self endon("disconnect");
	self endon("spawned_player");

	while (self.sessionstate != "playing")
	{
		wait 0.1;
		self.player = self getSpectatorClient();

		if (!isDefined(self.player))
			continue;
	}
}
