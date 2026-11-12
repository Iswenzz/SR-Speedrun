main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_smb2_chipped_pipes", 0);

	thread iz_sounds();

	thread iz_bananas();
	thread sr\api\_speedrun::createNormalWays("Normal Way;^3Banana Way");

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
}

iz_sounds()
{
	ambientPlay("iz_0_colony", 2);
}

iz_bananas()
{
	level.iz_bananas = getEntArray("iz_banana", "targetname");
	for (i = 0; i < level.iz_bananas.size; i++)
	{
		level.iz_bananas[i].iz_id = i;
		level.iz_bananas[i] thread iz_banana();
	}
	// Each player has their own, and a spawn brings all of theirs back.
	for (;;)
	{
		level waittill("player_spawn", player);
		player.iz_bananas = [];
		for (i = 0; i < level.iz_bananas.size; i++)
			level.iz_bananas[i] iz_banana_show();
	}
}

iz_banana()
{
	self notSolid();
	// One on a moving group rides what its target names, and a linked
	// entity takes no turn of its own.
	ride = undefined;
	if (isDefined(self.target))
		ride = getEnt(self.target, "targetname");
	if (isDefined(ride))
		self linkTo(ride);
	else
		self thread iz_banana_spin();
	reach = 48;
	if (isDefined(self.radius))
		reach = self.radius;
	tick = 0;
	for (;;)
	{
		wait 0.1;
		players = getEntArray("player", "classname");
		for (i = 0; i < players.size; i++)
		{
			player = players[i];
			if (!isAlive(player) || distance(player.origin + (0, 0, 35), self.origin) > reach)
				continue;
			if (!isDefined(player.iz_bananas))
				player.iz_bananas = [];
			if (isDefined(player.iz_bananas[self.iz_id]))
				continue;
			player.iz_bananas[self.iz_id] = true;
			if (isDefined(level.iz_cue) && isDefined(level.iz_cue["iz_cue_banana"]))
				player playLocalSound("iz_cue_banana");
			self iz_banana_show();
			player iz_banana_taken();
		}
		// Whoever joined or changed who they watch since.
		tick++;
		if (tick >= 10)
		{
			tick = 0;
			self iz_banana_show();
		}
	}
}

// Gone for whoever took it and for those watching them, there for the rest.
iz_banana_show()
{
	self hide();
	players = getEntArray("player", "classname");
	for (i = 0; i < players.size; i++)
	{
		owner = players[i] getSpectatorClient();
		if (!isDefined(owner))
			owner = players[i];
		if (!isDefined(owner.iz_bananas) || !isDefined(owner.iz_bananas[self.iz_id]))
			self showToPlayer(players[i]);
	}
}

// The SR mod's Banana Way: the last banana, taken in any order, ends the run
// where the player stands.
iz_banana_taken()
{
	self iPrintLn("^3Bananas ^7" + self.iz_bananas.size + "/" + level.iz_bananas.size);
	if (self.iz_bananas.size < level.iz_bananas.size || (isDefined(self.finishedMap) && self.finishedMap))
		return;
	self sr\api\_speedrun::changeWay("normal_1");
	self sr\api\_speedrun::finishWay("normal_1");
}

iz_banana_spin()
{
	for (;;)
	{
		self rotateYaw(360, 2);
		wait 2;
	}
}
