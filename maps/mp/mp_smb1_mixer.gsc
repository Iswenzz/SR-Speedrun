main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_smb1_mixer", 0);

	thread iz_sounds();

	thread iz_bananas();

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
	ambientPlay("iz_0_st8", 2);
}

iz_bananas()
{
	bananas = getEntArray("iz_banana", "targetname");
	for (i = 0; i < bananas.size; i++)
		bananas[i] thread iz_banana();
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
	for (;;)
	{
		wait 0.1;
		players = getEntArray("player", "classname");
		for (i = 0; i < players.size; i++)
		{
			if (!isAlive(players[i]) || distance(players[i].origin + (0, 0, 35), self.origin) > reach)
				continue;
			if (isDefined(level.iz_cue) && isDefined(level.iz_cue["iz_cue_banana"]))
				players[i] playLocalSound("iz_cue_banana");
			self hide();
			wait 15;
			self show();
			break;
		}
	}
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
	points[0] = (-52.5000, 0, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-52.5000, 0, 0);
	angles[1] = (-90, 0, 0);
	at[1] = 3.7500;
	points[2] = (-52.5000, 0, 0);
	angles[2] = (-134.3999, 0, 0);
	at[2] = 5.6000;
	points[3] = (-52.5000, 0, 0);
	angles[3] = (-180, 0, 0);
	at[3] = 7.5000;
	points[4] = (-52.5000, 0, 0);
	angles[4] = (-270, 0, 0);
	at[4] = 11.2500;
	points[5] = (-52.5000, 0, 0);
	angles[5] = (-360, 0, 0);
	at[5] = 15;
	points[6] = (-52.5000, 0, 0);
	angles[6] = (-450, 0, 0);
	at[6] = 18.7500;
	points[7] = (-52.5000, 0, 0);
	angles[7] = (-494.3999, 0, 0);
	at[7] = 20.6000;
	points[8] = (-52.5000, 0, 0);
	angles[8] = (-540, 0, 0);
	at[8] = 22.5000;
	points[9] = (-52.5000, 0, 0);
	angles[9] = (-630, 0, 0);
	at[9] = 26.2500;
	points[10] = (-52.5000, 0, 0);
	angles[10] = (-720, 0, 0);
	at[10] = 30;
	mover = getEnt("iz_mover0", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover1()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (52.5000, 0, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (52.5000, 0, 0);
	angles[1] = (90, 0, 0);
	at[1] = 3.7500;
	points[2] = (52.5000, 0, 0);
	angles[2] = (134.4000, 0, 0);
	at[2] = 5.6000;
	points[3] = (52.5000, 0, 0);
	angles[3] = (180, 0, 0);
	at[3] = 7.5000;
	points[4] = (52.5000, 0, 0);
	angles[4] = (224.4000, 0, 0);
	at[4] = 9.3500;
	points[5] = (52.5000, 0, 0);
	angles[5] = (270, 0, 0);
	at[5] = 11.2500;
	points[6] = (52.5000, 0, 0);
	angles[6] = (360, 0, 0);
	at[6] = 15;
	points[7] = (52.5000, 0, 0);
	angles[7] = (450, 0, 0);
	at[7] = 18.7500;
	points[8] = (52.5000, 0, 0);
	angles[8] = (540, 0, 0);
	at[8] = 22.5000;
	points[9] = (52.5000, 0, 0);
	angles[9] = (630, 0, 0);
	at[9] = 26.2500;
	points[10] = (52.5000, 0, 0);
	angles[10] = (720, 0, 0);
	at[10] = 30;
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
