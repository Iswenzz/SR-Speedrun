main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_smb1_quake", 0);

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
	ambientPlay("iz_0_st7", 2);
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
	points[0] = (0, 0, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 0, -0.4088);
	angles[1] = (0, 0, 0);
	at[1] = 0.1000;
	points[2] = (0, 0, -2.4500);
	angles[2] = (0, 0, 0);
	at[2] = 0.2500;
	points[3] = (0, 0, -6.0032);
	angles[3] = (0, 0, 0);
	at[3] = 0.4000;
	points[4] = (0, 0, -10.8416);
	angles[4] = (0, 0, 0);
	at[4] = 0.5500;
	points[5] = (0, 0, -23.4668);
	angles[5] = (0, 0, 0);
	at[5] = 0.8500;
	points[6] = (0, 0, -61.6449);
	angles[6] = (0, 0, 0);
	at[6] = 1.6000;
	points[7] = (0, 0, -74.7992);
	angles[7] = (0, 0, 0);
	at[7] = 1.9000;
	points[8] = (0, 0, -80.0157);
	angles[8] = (0, 0, 0);
	at[8] = 2.0500;
	points[9] = (0, 0, -84.0224);
	angles[9] = (0, 0, 0);
	at[9] = 2.2000;
	points[10] = (0, 0, -86.5929);
	angles[10] = (0, 0, 0);
	at[10] = 2.3500;
	points[11] = (0, 0, -87.5000);
	angles[11] = (0, 0, 0);
	at[11] = 2.5000;
	points[12] = (0, 0, -69.3000);
	angles[12] = (0, 0, 0);
	at[12] = 2.5500;
	points[13] = (0, 0, -25.9001);
	angles[13] = (0, 0, 0);
	at[13] = 2.6000;
	points[14] = (0, 0, 25.9001);
	angles[14] = (0, 0, 0);
	at[14] = 2.6500;
	points[15] = (0, 0, 69.3000);
	angles[15] = (0, 0, 0);
	at[15] = 2.7000;
	points[16] = (0, 0, 87.5000);
	angles[16] = (0, 0, 0);
	at[16] = 2.7500;
	points[17] = (0, 0, 71.1201);
	angles[17] = (0, 0, 0);
	at[17] = 2.8000;
	points[18] = (0, 0, 32.0601);
	angles[18] = (0, 0, 0);
	at[18] = 2.8500;
	points[19] = (0, 0, -14.5601);
	angles[19] = (0, 0, 0);
	at[19] = 2.9000;
	points[20] = (0, 0, -53.6201);
	angles[20] = (0, 0, 0);
	at[20] = 2.9500;
	points[21] = (0, 0, -70);
	angles[21] = (0, 0, 0);
	at[21] = 3;
	points[22] = (0, 0, -56.8961);
	angles[22] = (0, 0, 0);
	at[22] = 3.0500;
	points[23] = (0, 0, -25.6481);
	angles[23] = (0, 0, 0);
	at[23] = 3.1000;
	points[24] = (0, 0, 11.6481);
	angles[24] = (0, 0, 0);
	at[24] = 3.1500;
	points[25] = (0, 0, 42.8961);
	angles[25] = (0, 0, 0);
	at[25] = 3.2000;
	points[26] = (0, 0, 56);
	angles[26] = (0, 0, 0);
	at[26] = 3.2500;
	points[27] = (0, 0, 45.5169);
	angles[27] = (0, 0, 0);
	at[27] = 3.3000;
	points[28] = (0, 0, 20.5185);
	angles[28] = (0, 0, 0);
	at[28] = 3.3500;
	points[29] = (0, 0, -9.3185);
	angles[29] = (0, 0, 0);
	at[29] = 3.4000;
	points[30] = (0, 0, -34.3168);
	angles[30] = (0, 0, 0);
	at[30] = 3.4500;
	points[31] = (0, 0, -44.8000);
	angles[31] = (0, 0, 0);
	at[31] = 3.5000;
	points[32] = (0, 0, -36.4134);
	angles[32] = (0, 0, 0);
	at[32] = 3.5500;
	points[33] = (0, 0, -16.4148);
	angles[33] = (0, 0, 0);
	at[33] = 3.6000;
	points[34] = (0, 0, 7.4548);
	angles[34] = (0, 0, 0);
	at[34] = 3.6500;
	points[35] = (0, 0, 27.4534);
	angles[35] = (0, 0, 0);
	at[35] = 3.7000;
	points[36] = (0, 0, 35.8400);
	angles[36] = (0, 0, 0);
	at[36] = 3.7500;
	points[37] = (0, 0, 29.1308);
	angles[37] = (0, 0, 0);
	at[37] = 3.8000;
	points[38] = (0, 0, 13.1318);
	angles[38] = (0, 0, 0);
	at[38] = 3.8500;
	points[39] = (0, 0, -5.9638);
	angles[39] = (0, 0, 0);
	at[39] = 3.9000;
	points[40] = (0, 0, -21.9628);
	angles[40] = (0, 0, 0);
	at[40] = 3.9500;
	points[41] = (0, 0, -28.6720);
	angles[41] = (0, 0, 0);
	at[41] = 4;
	points[42] = (0, 0, -23.3045);
	angles[42] = (0, 0, 0);
	at[42] = 4.0500;
	points[43] = (0, 0, -10.5055);
	angles[43] = (0, 0, 0);
	at[43] = 4.1000;
	points[44] = (0, 0, 4.7711);
	angles[44] = (0, 0, 0);
	at[44] = 4.1500;
	points[45] = (0, 0, 17.5702);
	angles[45] = (0, 0, 0);
	at[45] = 4.2000;
	points[46] = (0, 0, 22.9376);
	angles[46] = (0, 0, 0);
	at[46] = 4.2500;
	points[47] = (0, 0, 18.6437);
	angles[47] = (0, 0, 0);
	at[47] = 4.3000;
	points[48] = (0, 0, 8.4043);
	angles[48] = (0, 0, 0);
	at[48] = 4.3500;
	points[49] = (0, 0, -3.8168);
	angles[49] = (0, 0, 0);
	at[49] = 4.4000;
	points[50] = (0, 0, -14.0561);
	angles[50] = (0, 0, 0);
	at[50] = 4.4500;
	points[51] = (0, 0, -18.3501);
	angles[51] = (0, 0, 0);
	at[51] = 4.5000;
	points[52] = (0, 0, -14.9149);
	angles[52] = (0, 0, 0);
	at[52] = 4.5500;
	points[53] = (0, 0, -6.7235);
	angles[53] = (0, 0, 0);
	at[53] = 4.6000;
	points[54] = (0, 0, 3.0535);
	angles[54] = (0, 0, 0);
	at[54] = 4.6500;
	points[55] = (0, 0, 11.2449);
	angles[55] = (0, 0, 0);
	at[55] = 4.7000;
	points[56] = (0, 0, 14.6800);
	angles[56] = (0, 0, 0);
	at[56] = 4.7500;
	points[57] = (0, 0, 11.9319);
	angles[57] = (0, 0, 0);
	at[57] = 4.8000;
	points[58] = (0, 0, -8.9959);
	angles[58] = (0, 0, 0);
	at[58] = 4.9500;
	points[59] = (0, 0, -11.7441);
	angles[59] = (0, 0, 0);
	at[59] = 5;
	points[60] = (0, 0, -8.4410);
	angles[60] = (0, 0, 0);
	at[60] = 5.0500;
	points[61] = (0, 0, 6.0923);
	angles[61] = (0, 0, 0);
	at[61] = 5.1500;
	points[62] = (0, 0, 9.3953);
	angles[62] = (0, 0, 0);
	at[62] = 5.2000;
	points[63] = (0, 0, 7.6365);
	angles[63] = (0, 0, 0);
	at[63] = 5.2500;
	points[64] = (0, 0, -5.7574);
	angles[64] = (0, 0, 0);
	at[64] = 5.4000;
	points[65] = (0, 0, -7.5162);
	angles[65] = (0, 0, 0);
	at[65] = 5.4500;
	points[66] = (0, 0, -5.4022);
	angles[66] = (0, 0, 0);
	at[66] = 5.5000;
	points[67] = (0, 0, 3.8990);
	angles[67] = (0, 0, 0);
	at[67] = 5.6000;
	points[68] = (0, 0, 6.0129);
	angles[68] = (0, 0, 0);
	at[68] = 5.6500;
	points[69] = (0, 0, 4.8873);
	angles[69] = (0, 0, 0);
	at[69] = 5.7000;
	points[70] = (0, 0, -3.6847);
	angles[70] = (0, 0, 0);
	at[70] = 5.8500;
	points[71] = (0, 0, -4.8103);
	angles[71] = (0, 0, 0);
	at[71] = 5.9000;
	points[72] = (0, 0, -3.9098);
	angles[72] = (0, 0, 0);
	at[72] = 5.9500;
	points[73] = (0, 0, 2.9478);
	angles[73] = (0, 0, 0);
	at[73] = 6.1000;
	points[74] = (0, 0, 3.8483);
	angles[74] = (0, 0, 0);
	at[74] = 6.1500;
	points[75] = (0, 0, 2.7660);
	angles[75] = (0, 0, 0);
	at[75] = 6.2000;
	points[76] = (0, 0, -1.9963);
	angles[76] = (0, 0, 0);
	at[76] = 6.3000;
	points[77] = (0, 0, -3.0786);
	angles[77] = (0, 0, 0);
	at[77] = 6.3500;
	points[78] = (0, 0, -2.5023);
	angles[78] = (0, 0, 0);
	at[78] = 6.4000;
	points[79] = (0, 0, 1.8866);
	angles[79] = (0, 0, 0);
	at[79] = 6.5500;
	points[80] = (0, 0, 2.4629);
	angles[80] = (0, 0, 0);
	at[80] = 6.6000;
	points[81] = (0, 0, -1.9704);
	angles[81] = (0, 0, 0);
	at[81] = 6.8000;
	points[82] = (0, 0, 1.5763);
	angles[82] = (0, 0, 0);
	at[82] = 7.0500;
	points[83] = (0, 0, 0);
	angles[83] = (0, 0, 0);
	at[83] = 7.2500;
	points[84] = (0, 0, 0);
	angles[84] = (0, 0, 0);
	at[84] = 8;
	mover = getEnt("iz_mover0", "targetname");
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
