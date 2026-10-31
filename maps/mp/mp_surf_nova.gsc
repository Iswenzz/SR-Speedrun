#include common_scripts\utility;

main() {
	sr\api\_map::swapTargetname("trigger_endmap", "endmap_trig");
	sr\api\_speedrun::createNormalWays("Normal Way;");
	maps\mp\_load::main();

	thread goToSpawn();

	// thread devSavePos();
}

goToSpawn () {
	trig = getEnt("trigger_goto_spawn", "targetname");
	for (;;) {
		trig waittill("trigger", player);
		if (!isDefined(player.goingToSpawn) || !player.goingToSpawn) {
			player thread goToSpawnElevate();
		}
	}
}

goToSpawnElevate () {
	self.goingToSpawn = true;
	platform = getEnt("trigger_goto_spawn_platform", "targetname");
	spawn = getEnt("origin_spawn", "targetname");

	self freezeControls(true);
	org = spawn("script_origin", self.origin);
	self linkTo(org);

	self thread goToSpawnCleanup(org);

	self endon("spawned");
	self endon("disconnect");
	self endon("death");

	org moveTo(platform.origin, 1.5, .5, .5);
	org waittill("movedone");
	wait .25;
	org moveZ(368, 3, .5, .5);
	org waittill("movedone");

	self setOrigin(spawn.origin);
	self setPlayerAngles(spawn.angles);

	self notify("goto_spawn_done");
}

goToSpawnCleanup (org) {
	self waittill_any("spawned", "disconnect", "death", "goto_spawn_done");
	if (isDefined(self)) {
		self unlink();
		self freezeControls(false);
		self.goingToSpawn = false;
	}
	org delete();
}

/*
devSavePos () {
	for (;;) {
		players = getEntArray("player", "classname");
		if (players.size > 0) {
			player = players[0];

			if (player fragButtonPressed()) {
				iPrintLnBold("Saving position");
				player writePlayerData();
			} else if (player useButtonPressed()) {
				iPrintLnBold("Loading position");
				player loadPlayerData();
			}
		}

		wait .1;
	}
}

writePlayerData () {
	origin = self getOrigin();
	angles = self getPlayerAngles();
	vel = self getVelocity();

	data = origin[0] + "," + origin[1] + "," + origin[2]
		+ ";" + angles[0] + "," + angles[1] + "," + angles[2]
		+ ";" + vel[0] + "," + vel[1] + "," + vel[2];

	file = FS_fOpen("playerpos.txt", "write");
	iPrintLnBold(data);
	FS_writeLine(file, data);
	FS_fClose(file);

	wait 1;
}

loadPlayerData () {
	file = FS_fOpen("playerpos.txt", "read");
	data = FS_readLine(file);
	iPrintLnBold(data);
	FS_fClose(file);

	splitData = strTok(data, ";");
	origin = strTok(splitData[0], ",");
	angles = strTok(splitData[1], ",");
	vel = strTok(splitData[2], ",");

	self setOrigin((int(origin[0]), int(origin[1]), int(origin[2])));
	self setPlayerAngles((int(angles[0]), int(angles[1]), int(angles[2])));
	self setVelocity((int(vel[0]), int(vel[1]), int(vel[2])));

	wait 1;
}
*/
