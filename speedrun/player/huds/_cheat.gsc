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

	self.runId = randomInt(999999);

	self setClientDvar("sr_anticheat_player_id", self.id);
	self setClientDvar("sr_anticheat_player_name", self.shortName);
	self setClientDvar("sr_anticheat_player_run", self.runId);
	self setClientDvar("sr_anticheat_player_guid", self.guid);
}

spec()
{
	self endon("disconnect");
	self endon("spawned_player");

	while (self.sessionstate != "playing")
	{
		wait 0.1;
		player = self getSpectatorClient();

		if (!isDefined(player))
			continue;

		if (player.isBot)
		{
			player.guid = "^84201337";
			player.id = "0000000";
		}

		self setClientDvar("sr_anticheat_player_id", player.id);
		self setClientDvar("sr_anticheat_player_name", player.shortName);
		self setClientDvar("sr_anticheat_player_run", player.runId);
		self setClientDvar("sr_anticheat_player_guid", player.guid);
	}
}
