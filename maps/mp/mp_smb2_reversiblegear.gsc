main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_smb2_reversiblegear", 0);

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
	ambientPlay("iz_0_water", 2);
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
}

iz_mover0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, -4985.7876, -35);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, -4985.7876, -35);
	angles[1] = (0, 1.4288, 0);
	at[1] = 0.1500;
	points[2] = (0, -4985.7876, -35);
	angles[2] = (0, 5.5987, 0);
	at[2] = 0.3000;
	points[3] = (0, -4985.7876, -35);
	angles[3] = (0, 12.3347, 0);
	at[3] = 0.4500;
	points[4] = (0, -4985.7876, -35);
	angles[4] = (0, 21.4617, 0);
	at[4] = 0.6000;
	points[5] = (0, -4985.7876, -35);
	angles[5] = (0, 32.8050, 0);
	at[5] = 0.7500;
	points[6] = (0, -4985.7876, -35);
	angles[6] = (0, 46.1894, 0);
	at[6] = 0.9000;
	points[7] = (0, -4985.7876, -35);
	angles[7] = (0, 61.4401, 0);
	at[7] = 1.0500;
	points[8] = (0, -4985.7876, -35);
	angles[8] = (0, 84.3750, 0);
	at[8] = 1.2500;
	points[9] = (0, -4985.7876, -35);
	angles[9] = (0, 103.2998, 0);
	at[9] = 1.4000;
	points[10] = (0, -4985.7876, -35);
	angles[10] = (0, 123.5078, 0);
	at[10] = 1.5500;
	points[11] = (0, -4985.7876, -35);
	angles[11] = (0, 167.0727, 0);
	at[11] = 1.8500;
	points[12] = (0, -4985.7876, -35);
	angles[12] = (0, 213.6705, 0);
	at[12] = 2.1500;
	points[13] = (0, -4985.7876, -35);
	angles[13] = (0, 270, 0);
	at[13] = 2.5000;
	points[14] = (0, -4985.7876, -35);
	angles[14] = (0, 334.2472, 0);
	at[14] = 2.9000;
	points[15] = (0, -4985.7876, -35);
	angles[15] = (0, 365.3337, 0);
	at[15] = 3.1000;
	points[16] = (0, -4985.7876, -35);
	angles[16] = (0, 395.1763, 0);
	at[16] = 3.3000;
	points[17] = (0, -4985.7876, -35);
	angles[17] = (0, 423.3601, 0);
	at[17] = 3.5000;
	points[18] = (0, -4985.7876, -35);
	angles[18] = (0, 443.1597, 0);
	at[18] = 3.6500;
	points[19] = (0, -4985.7876, -35);
	angles[19] = (0, 461.6179, 0);
	at[19] = 3.8000;
	points[20] = (0, -4985.7876, -35);
	angles[20] = (0, 478.5600, 0);
	at[20] = 3.9500;
	points[21] = (0, -4985.7876, -35);
	angles[21] = (0, 493.8107, 0);
	at[21] = 4.1000;
	points[22] = (0, -4985.7876, -35);
	angles[22] = (0, 507.1951, 0);
	at[22] = 4.2500;
	points[23] = (0, -4985.7876, -35);
	angles[23] = (0, 518.5381, 0);
	at[23] = 4.4000;
	points[24] = (0, -4985.7876, -35);
	angles[24] = (0, 524.8801, 0);
	at[24] = 4.5000;
	points[25] = (0, -4985.7876, -35);
	angles[25] = (0, 532.4324, 0);
	at[25] = 4.6500;
	points[26] = (0, -4985.7876, -35);
	angles[26] = (0, 536.0850, 0);
	at[26] = 4.7500;
	points[27] = (0, -4985.7876, -35);
	angles[27] = (0, 539.3606, 0);
	at[27] = 4.9000;
	points[28] = (0, -4985.7876, -35);
	angles[28] = (0, 540, 0);
	at[28] = 5;
	points[29] = (0, -4985.7876, -35);
	angles[29] = (0, 538.5712, 0);
	at[29] = 5.1500;
	points[30] = (0, -4985.7876, -35);
	angles[30] = (0, 534.4012, 0);
	at[30] = 5.3000;
	points[31] = (0, -4985.7876, -35);
	angles[31] = (0, 527.6653, 0);
	at[31] = 5.4500;
	points[32] = (0, -4985.7876, -35);
	angles[32] = (0, 518.5383, 0);
	at[32] = 5.6000;
	points[33] = (0, -4985.7876, -35);
	angles[33] = (0, 507.1951, 0);
	at[33] = 5.7500;
	points[34] = (0, -4985.7876, -35);
	angles[34] = (0, 493.8107, 0);
	at[34] = 5.9000;
	points[35] = (0, -4985.7876, -35);
	angles[35] = (0, 478.5598, 0);
	at[35] = 6.0500;
	points[36] = (0, -4985.7876, -35);
	angles[36] = (0, 455.6250, 0);
	at[36] = 6.2500;
	points[37] = (0, -4985.7876, -35);
	angles[37] = (0, 436.7001, 0);
	at[37] = 6.4000;
	points[38] = (0, -4985.7876, -35);
	angles[38] = (0, 416.4922, 0);
	at[38] = 6.5500;
	points[39] = (0, -4985.7876, -35);
	angles[39] = (0, 372.9273, 0);
	at[39] = 6.8500;
	points[40] = (0, -4985.7876, -35);
	angles[40] = (0, 326.3295, 0);
	at[40] = 7.1500;
	points[41] = (0, -4985.7876, -35);
	angles[41] = (0, 270, 0);
	at[41] = 7.5000;
	points[42] = (0, -4985.7876, -35);
	angles[42] = (0, 205.7529, 0);
	at[42] = 7.9000;
	points[43] = (0, -4985.7876, -35);
	angles[43] = (0, 174.6662, 0);
	at[43] = 8.1000;
	points[44] = (0, -4985.7876, -35);
	angles[44] = (0, 144.8237, 0);
	at[44] = 8.3000;
	points[45] = (0, -4985.7876, -35);
	angles[45] = (0, 116.6401, 0);
	at[45] = 8.5000;
	points[46] = (0, -4985.7876, -35);
	angles[46] = (0, 96.8404, 0);
	at[46] = 8.6500;
	points[47] = (0, -4985.7876, -35);
	angles[47] = (0, 78.3821, 0);
	at[47] = 8.8000;
	points[48] = (0, -4985.7876, -35);
	angles[48] = (0, 61.4401, 0);
	at[48] = 8.9500;
	points[49] = (0, -4985.7876, -35);
	angles[49] = (0, 46.1894, 0);
	at[49] = 9.1000;
	points[50] = (0, -4985.7876, -35);
	angles[50] = (0, 32.8050, 0);
	at[50] = 9.2500;
	points[51] = (0, -4985.7876, -35);
	angles[51] = (0, 21.4617, 0);
	at[51] = 9.4000;
	points[52] = (0, -4985.7876, -35);
	angles[52] = (0, 15.1200, 0);
	at[52] = 9.5000;
	points[53] = (0, -4985.7876, -35);
	angles[53] = (0, 7.5676, 0);
	at[53] = 9.6500;
	points[54] = (0, -4985.7876, -35);
	angles[54] = (0, 3.9150, 0);
	at[54] = 9.7500;
	points[55] = (0, -4985.7876, -35);
	angles[55] = (0, 0.6394, 0);
	at[55] = 9.9000;
	points[56] = (0, -4985.7876, -35);
	angles[56] = (0, 0, 0);
	at[56] = 10;
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
