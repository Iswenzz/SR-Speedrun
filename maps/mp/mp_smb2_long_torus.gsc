main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_smb2_long_torus", 0);

	thread iz_sounds();

	thread iz_bananas();
	thread sr\api\_speedrun::createNormalWays("Normal Way;^3Banana Way");

	thread iz_anims();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
}

iz_sounds()
{
	ambientPlay("iz_0_sf", 2);
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

iz_move(origin, angles, frames)
{
	if (!isDefined(self.iz_step))
	{
		self.iz_step = (0, 0, 0);
		self.iz_turn = (0, 0, 0);
	}
	time = frames * 0.05 + 0.0005;
	if (isDefined(origin))
	{
		to = origin - self.iz_step;
		self.iz_step = (to - self.origin) * (1.0 / frames);
		self moveTo(to, time);
	}
	if (isDefined(angles))
	{
		turn = angles - self.iz_turn - self.angles;
		turn = (iz_wrap(turn[0]), iz_wrap(turn[1]), iz_wrap(turn[2]));
		self.iz_turn = turn * (1.0 / frames);
		self rotateTo(self.angles + turn, time);
	}
}

iz_wrap(angle)
{
	return angle - 360 * floor(angle / 360 + 0.5);
}

iz_place(origin, angles)
{
	self.origin = origin;
	if (isDefined(angles))
		self.angles = angles;
	self.iz_step = (0, 0, 0);
	self.iz_turn = (0, 0, 0);
}

iz_stop(origin, angles)
{
	self iz_move(origin, angles, 1);
	wait 0.05;
	self iz_move(origin, angles, 1);
}

iz_anims()
{
	thread iz_mover0();
	thread iz_mover1();
}

iz_mover0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, -15260, -350);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, -15260, -350);
	angles[1] = (90, 0, 0);
	at[1] = 7.5000;
	points[2] = (0, -15260, -350);
	angles[2] = (135, 0, 0);
	at[2] = 11.2500;
	points[3] = (0, -15260, -350);
	angles[3] = (180, 0, 0);
	at[3] = 15;
	points[4] = (0, -15260, -350);
	angles[4] = (225, 0, 0);
	at[4] = 18.7500;
	points[5] = (0, -15260, -350);
	angles[5] = (270, 0, 0);
	at[5] = 22.5000;
	points[6] = (0, -15260, -350);
	angles[6] = (360, 0, 0);
	at[6] = 30;
	mover = getEnt("iz_mover0", "targetname");
	if (!isDefined(mover))
		return;
	rider = getEnt("endmap_trig", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover1()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, -15260, -350);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, -15260, -350);
	angles[1] = (90, 0, 0);
	at[1] = 7.5000;
	points[2] = (0, -15260, -350);
	angles[2] = (135, 0, 0);
	at[2] = 11.2500;
	points[3] = (0, -15260, -350);
	angles[3] = (180, 0, 0);
	at[3] = 15;
	points[4] = (0, -15260, -350);
	angles[4] = (225, 0, 0);
	at[4] = 18.7500;
	points[5] = (0, -15260, -350);
	angles[5] = (270, 0, 0);
	at[5] = 22.5000;
	points[6] = (0, -15260, -350);
	angles[6] = (360, 0, 0);
	at[6] = 30;
	mover = getEnt("iz_mover1", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover_loop(points, angles, at, once, closed)
{
	wait 0.05;
	self iz_place(points[0], iz_pose(angles, 0));
	period = at[at.size - 1];
	if (period < 0.05)
		return;
	done = 0;
	for (pass = 0; !once || pass < 1; pass++)
	{
		if (pass && !closed)
			self iz_place(points[0], iz_pose(angles, 0));
		for (i = 1; i < points.size; i++)
		{
			if (at[i] == at[i - 1])
			{
				self iz_place(points[i], iz_pose(angles, i));
				continue;
			}
			due = int((pass * period + at[i]) * 20 + 0.5);
			if (due <= done)
				continue;
			self iz_move(points[i], iz_pose(angles, i), due - done);
			wait 0.05 * (due - done);
			done = due;
		}
	}
	last = points.size - 1;
	self iz_stop(points[last], iz_pose(angles, last));
}

iz_pose(angles, i)
{
	if (isDefined(angles))
		return angles[i];
}
