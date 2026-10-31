main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_smb2_ufo", 0);

	thread iz_sounds();

	thread iz_bananas();

	thread iz_stage_objects();

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
	ambientPlay("iz_0_colony", 2);
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

iz_stage_objects()
{
	level.iz_play = [];
	level.iz_press = [];
	level.iz_play[1] = -1;
	level.iz_press[1] = 0;
	thread iz_button("iz_button0", 1, 0);
}

iz_bumper(name, spin)
{
	model = getEnt(name, "targetname");
	touch = getEnt(name + "_touch", "targetname");
	if (!isDefined(model) || !isDefined(touch))
		return;
	if (isDefined(model.target))
	{
		mover = getEnt(model.target, "targetname");
		if (isDefined(mover))
		{
			model linkTo(mover);
			spin = false;
		}
	}
	if (spin)
		model thread iz_bumper_spin();
	for (;;)
	{
		touch waittill("trigger", player);
		away = player.origin - touch.origin;
		away = (away[0], away[1], 0);
		if (length(away) < 1)
			away = anglesToForward(player.angles) * -1;
		away = vectorNormalize(away);
		velocity = player getVelocity();
		into = vectorDot(velocity, away);
		if (into < 0)
			velocity = velocity - away * (1.5 * into);
		velocity = velocity + away * 210;
		if (velocity[2] < 150)
			velocity = (velocity[0], velocity[1], 150);
		player setVelocity(velocity);
	}
}

iz_bumper_spin()
{
	for (;;)
	{
		self rotateYaw(360, 4.27);
		wait 4.27;
	}
}

iz_tilt(at)
{
	players = getEntArray("player", "classname");
	nearest = undefined;
	reach = 3000;
	for (i = 0; i < players.size; i++)
	{
		if (!isAlive(players[i]))
			continue;
		d = distance(players[i].origin, at);
		if (d < reach)
		{
			reach = d;
			nearest = players[i];
		}
	}
	if (!isDefined(nearest))
		return (0, 0, 0);
	velocity = nearest getVelocity();
	velocity = (velocity[0], velocity[1], 0);
	speed = length(velocity);
	if (speed < 1)
		return (0, 0, 0);
	share = speed / 190;
	if (share > 1)
		share = 1;
	return vectorNormalize(velocity) * (sin(23) * share);
}

iz_jamabar(name, axis)
{
	bar = getEnt(name, "targetname");
	if (!isDefined(bar))
		return;
	rest = bar.origin;
	offset = 0;
	speed = 0;
	for (;;)
	{
		push = vectorDot(iz_tilt(rest), axis) * 0.016;
		for (i = 0; i < 3; i++)
		{
			speed = (speed + push) * 0.97;
			offset += speed;
			if (offset < -2.5)
			{
				offset = -2.5;
				if (speed < 0)
					speed = 0 - speed;
			}
			else if (offset > 0)
			{
				offset = 0;
				if (speed > 0)
					speed = 0 - speed;
			}
		}
		bar iz_move(rest + axis * (offset * 70), undefined, 1);
		wait 0.05;
	}
}

iz_cross(a, b)
{
	return (a[1] * b[2] - a[2] * b[1], a[2] * b[0] - a[0] * b[2], a[0] * b[1] - a[1] * b[0]);
}

iz_unturn(d, axis, degrees)
{
	c = cos(degrees);
	return d * c - iz_cross(axis, d) * sin(degrees) + axis * (vectorDot(axis, d) * (1 - c));
}

iz_seesaw(axis, turns, sensitivity, friction, spring, low, high)
{
	pivot = self.origin;
	turn = 0;
	speed = 0;
	for (;;)
	{
		push = 0;
		players = getEntArray("player", "classname");
		for (i = 0; i < players.size; i++)
		{
			player = players[i];
			if (!isAlive(player) || !player isOnGround())
				continue;
			at = iz_unturn(player.origin - pivot, axis, turn * 360 / 65536);
			if (at[0] < low[0] - 16 || at[0] > high[0] + 16 || at[1] < low[1] - 16 || at[1] > high[1] + 16
				|| at[2] < high[2] - 24 || at[2] > high[2] + 40)
				continue;
			arm = (player.origin + (0, 0, 35) - pivot) * 0.0142857;
			arm = arm - axis * vectorDot(arm, axis);
			reach = length(arm);
			if (reach < 0.01)
				continue;
			out = arm * (1 / reach);
			velocity = player getVelocity() * 0.000238095 + (0, 0, -0.0098);
			velocity = velocity - axis * vectorDot(velocity, axis);
			across = velocity - out * vectorDot(velocity, out);
			sideways = length(across);
			if (vectorDot(iz_cross(out, across), axis) < 0)
				sideways = 0 - sideways;
			push += 40 * sensitivity * reach * sideways;
		}
		for (i = 0; i < 3; i++)
		{
			speed += push - 2 * spring * sin(turn * 360 / 65536);
			speed *= 1 - 0.02 * friction;
			turn += speed;
		}
		degrees = turn * 360 / 65536;
		self iz_move(undefined, turns * degrees, 1);
		wait 0.05;
	}
}

iz_button(name, id, state)
{
	button = getEnt(name, "targetname");
	if (!isDefined(button))
		return;
	for (;;)
	{
		button waittill("trigger", player);
		if (level.iz_play[id] != state)
		{
			level.iz_play[id] = state;
			level.iz_press[id]++;
		}
	}
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
	points[0] = (0, -2100, -350);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, -2100, -350);
	angles[1] = (0, 0.4262, 0);
	at[1] = 0.2000;
	points[2] = (0, -2100, -350);
	angles[2] = (0, 2.1214, 0);
	at[2] = 0.4500;
	points[3] = (0, -2100, -350);
	angles[3] = (0, 8.2231, 0);
	at[3] = 0.9000;
	points[4] = (0, -2100, -350);
	angles[4] = (0, 13.1880, 0);
	at[4] = 1.1500;
	points[5] = (0, -2100, -350);
	angles[5] = (0, 19.1924, 0);
	at[5] = 1.4000;
	points[6] = (0, -2100, -350);
	angles[6] = (0, 34.0495, 0);
	at[6] = 1.9000;
	points[7] = (0, -2100, -350);
	angles[7] = (0, 50.2989, 0);
	at[7] = 2.3500;
	points[8] = (0, -2100, -350);
	angles[8] = (0.3474, 68.8692, 0.8987);
	at[8] = 2.8000;
	points[9] = (0, -2100, -350);
	angles[9] = (0.2635, 87.0107, 5.0331);
	at[9] = 3.2000;
	points[10] = (0, -2100, -350);
	angles[10] = (-1.9664, 101.2618, 9.7770);
	at[10] = 3.5000;
	points[11] = (0, -2100, -350);
	angles[11] = (-6.0872, 113.1624, 13.9209);
	at[11] = 3.7500;
	points[12] = (0, -2100, -350);
	angles[12] = (-12.5176, 124.8065, 17.3160);
	at[12] = 4;
	points[13] = (0, -2100, -350);
	angles[13] = (-23.0424, 138.5214, 19.0873);
	at[13] = 4.3000;
	points[14] = (0, -2100, -350);
	angles[14] = (-33.5194, 150.5050, 17.3471);
	at[14] = 4.5500;
	points[15] = (0, -2100, -350);
	angles[15] = (-42.3368, 161.6060, 12.6237);
	at[15] = 4.7500;
	points[16] = (0, -2100, -350);
	angles[16] = (-46.6250, 168.1644, 8.6609);
	at[16] = 4.8500;
	points[17] = (0, -2100, -350);
	angles[17] = (-50.6374, 175.7406, 3.2956);
	at[17] = 4.9500;
	points[18] = (0, -2100, -350);
	angles[18] = (-54.1687, 184.6153, -3.7446);
	at[18] = 5.0500;
	points[19] = (0, -2100, -350);
	angles[19] = (-56.9608, 194.9725, -12.6363);
	at[19] = 5.1500;
	points[20] = (0, -2100, -350);
	angles[20] = (-58.7256, 206.6995, -23.2607);
	at[20] = 5.2500;
	points[21] = (0, -2100, -350);
	angles[21] = (-59.2168, 219.1914, -35.0096);
	at[21] = 5.3500;
	points[22] = (0, -2100, -350);
	angles[22] = (-58.3294, 231.4254, -46.8594);
	at[22] = 5.4500;
	points[23] = (0, -2100, -350);
	angles[23] = (-56.1497, 242.4012, -57.8113);
	at[23] = 5.5500;
	points[24] = (0, -2100, -350);
	angles[24] = (-50.9644, 255.4105, -71.4746);
	at[24] = 5.7000;
	points[25] = (0, -2100, -350);
	angles[25] = (-46.6133, 261.7697, -78.7435);
	at[25] = 5.8000;
	points[26] = (0, -2100, -350);
	angles[26] = (-41.8085, 266.5439, -84.8235);
	at[26] = 5.9000;
	points[27] = (0, -2100, -350);
	angles[27] = (-36.7200, 270, -90);
	at[27] = 6;
	points[28] = (0, -2100, -350);
	angles[28] = (-31.4787, 272.3654, -94.5228);
	at[28] = 6.1000;
	points[29] = (0, -2100, -350);
	angles[29] = (-23.5492, 274.2393, -100.5105);
	at[29] = 6.2500;
	points[30] = (0, -2100, -350);
	angles[30] = (-15.7751, 274.4512, -105.9783);
	at[30] = 6.4000;
	points[31] = (0, -2100, -350);
	angles[31] = (-8.3780, 273.2477, -111.2776);
	at[31] = 6.5500;
	points[32] = (0, -2100, -350);
	angles[32] = (-1.5529, 270.7792, -116.6506);
	at[32] = 6.7000;
	points[33] = (0, -2100, -350);
	angles[33] = (6.3495, 265.7038, -124.1875);
	at[33] = 6.9000;
	points[34] = (0, -2100, -350);
	angles[34] = (12.5431, 258.8360, -132.2624);
	at[34] = 7.1000;
	points[35] = (0, -2100, -350);
	angles[35] = (16.7586, 250.5775, -140.7249);
	at[35] = 7.3000;
	points[36] = (0, -2100, -350);
	angles[36] = (18.5615, 243.8164, -147.0815);
	at[36] = 7.4500;
	points[37] = (0, -2100, -350);
	angles[37] = (19.2496, 234.5824, -155.1272);
	at[37] = 7.6500;
	points[38] = (0, -2100, -350);
	angles[38] = (17.8249, 223.5184, -163.7922);
	at[38] = 7.9000;
	points[39] = (0, -2100, -350);
	angles[39] = (15.4216, 215.5082, -169.2566);
	at[39] = 8.1000;
	points[40] = (0, -2100, -350);
	angles[40] = (11.6282, 206.7602, -174.1964);
	at[40] = 8.3500;
	points[41] = (0, -2100, -350);
	angles[41] = (7.7049, 199.3741, -177.3007);
	at[41] = 8.6000;
	points[42] = (0, -2100, -350);
	angles[42] = (3.6573, 192.1347, -179.2142);
	at[42] = 8.9000;
	points[43] = (0, -2100, -350);
	angles[43] = (0.9572, 186.5443, -179.8902);
	at[43] = 9.2000;
	points[44] = (0, -2100, -350);
	angles[44] = (0, 182.6100, -180);
	at[44] = 9.5000;
	points[45] = (0, -2100, -350);
	angles[45] = (0, 180.6637, -180);
	at[45] = 9.7500;
	points[46] = (0, -2100, -350);
	angles[46] = (0, 179.5738, -180);
	at[46] = 10.2000;
	points[47] = (0, -2100, -350);
	angles[47] = (0, 177.8787, -180);
	at[47] = 10.4500;
	points[48] = (0, -2100, -350);
	angles[48] = (-0.6690, 174.2283, -179.9324);
	at[48] = 10.7500;
	points[49] = (0, -2100, -350);
	angles[49] = (-3.6573, 167.8653, -179.2142);
	at[49] = 11.1000;
	points[50] = (0, -2100, -350);
	angles[50] = (-9.2467, 157.8269, -176.2532);
	at[50] = 11.5000;
	points[51] = (0, -2100, -350);
	angles[51] = (-14.7093, 146.3549, -170.4082);
	at[51] = 11.8500;
	points[52] = (0, -2100, -350);
	angles[52] = (-17.3061, 138.5647, -165.2871);
	at[52] = 12.0500;
	points[53] = (0, -2100, -350);
	angles[53] = (-18.9441, 129.9523, -158.8161);
	at[53] = 12.2500;
	points[54] = (0, -2100, -350);
	angles[54] = (-18.5616, 116.1837, -147.0815);
	at[54] = 12.5500;
	points[55] = (0, -2100, -350);
	angles[55] = (-16.7586, 109.4225, -140.7249);
	at[55] = 12.7000;
	points[56] = (0, -2100, -350);
	angles[56] = (-12.5432, 101.1641, -132.2623);
	at[56] = 12.9000;
	points[57] = (0, -2100, -350);
	angles[57] = (-6.3495, 94.2962, -124.1875);
	at[57] = 13.1000;
	points[58] = (0, -2100, -350);
	angles[58] = (1.5529, 89.2208, -116.6506);
	at[58] = 13.3000;
	points[59] = (0, -2100, -350);
	angles[59] = (8.3780, 86.7524, -111.2776);
	at[59] = 13.4500;
	points[60] = (0, -2100, -350);
	angles[60] = (15.7751, 85.5488, -105.9783);
	at[60] = 13.6000;
	points[61] = (0, -2100, -350);
	angles[61] = (23.5492, 85.7607, -100.5105);
	at[61] = 13.7500;
	points[62] = (0, -2100, -350);
	angles[62] = (31.4787, 87.6346, -94.5228);
	at[62] = 13.9000;
	points[63] = (0, -2100, -350);
	angles[63] = (36.7200, 90, -90);
	at[63] = 14;
	points[64] = (0, -2100, -350);
	angles[64] = (41.8085, 93.4561, -84.8235);
	at[64] = 14.1000;
	points[65] = (0, -2100, -350);
	angles[65] = (46.6133, 98.2303, -78.7435);
	at[65] = 14.2000;
	points[66] = (0, -2100, -350);
	angles[66] = (50.9644, 104.5895, -71.4746);
	at[66] = 14.3000;
	points[67] = (0, -2100, -350);
	angles[67] = (56.1498, 117.5992, -57.8112);
	at[67] = 14.4500;
	points[68] = (0, -2100, -350);
	angles[68] = (58.3294, 128.5746, -46.8594);
	at[68] = 14.5500;
	points[69] = (0, -2100, -350);
	angles[69] = (59.2168, 140.8086, -35.0097);
	at[69] = 14.6500;
	points[70] = (0, -2100, -350);
	angles[70] = (58.7256, 153.3005, -23.2607);
	at[70] = 14.7500;
	points[71] = (0, -2100, -350);
	angles[71] = (56.9608, 165.0275, -12.6362);
	at[71] = 14.8500;
	points[72] = (0, -2100, -350);
	angles[72] = (54.1687, 175.3847, -3.7446);
	at[72] = 14.9500;
	points[73] = (0, -2100, -350);
	angles[73] = (50.6372, 184.2593, 3.2955);
	at[73] = 15.0500;
	points[74] = (0, -2100, -350);
	angles[74] = (46.6250, 191.8355, 8.6608);
	at[74] = 15.1500;
	points[75] = (0, -2100, -350);
	angles[75] = (42.3368, 198.3940, 12.6237);
	at[75] = 15.2500;
	points[76] = (0, -2100, -350);
	angles[76] = (33.5195, 209.4951, 17.3472);
	at[76] = 15.4500;
	points[77] = (0, -2100, -350);
	angles[77] = (23.0424, 221.4786, 19.0873);
	at[77] = 15.7000;
	points[78] = (0, -2100, -350);
	angles[78] = (12.5175, 235.1935, 17.3159);
	at[78] = 16;
	points[79] = (0, -2100, -350);
	angles[79] = (6.0872, 246.8376, 13.9209);
	at[79] = 16.2500;
	points[80] = (0, -2100, -350);
	angles[80] = (1.9664, 258.7382, 9.7770);
	at[80] = 16.5000;
	points[81] = (0, -2100, -350);
	angles[81] = (-0.2635, 272.9893, 5.0332);
	at[81] = 16.8000;
	points[82] = (0, -2100, -350);
	angles[82] = (-0.3474, 291.1307, 0.8987);
	at[82] = 17.2000;
	points[83] = (0, -2100, -350);
	angles[83] = (0, 309.7011, 0);
	at[83] = 17.6500;
	points[84] = (0, -2100, -350);
	angles[84] = (0, 325.9505, 0);
	at[84] = 18.1000;
	points[85] = (0, -2100, -350);
	angles[85] = (0, 340.8077, 0);
	at[85] = 18.6000;
	points[86] = (0, -2100, -350);
	angles[86] = (0, 346.8120, 0);
	at[86] = 18.8500;
	points[87] = (0, -2100, -350);
	angles[87] = (0, 351.7769, 0);
	at[87] = 19.1000;
	points[88] = (0, -2100, -350);
	angles[88] = (0, 357.8787, 0);
	at[88] = 19.5500;
	points[89] = (0, -2100, -350);
	angles[89] = (0, 359.5737, 0);
	at[89] = 19.8000;
	points[90] = (0, -2100, -350);
	angles[90] = (0, 360, 0);
	at[90] = 20;
	mover = getEnt("iz_mover0", "targetname");
	if (!isDefined(mover))
		return;
	rider = getEnt("endmap_trig", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	rider = getEnt("iz_button0", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	mover thread iz_mover_play(points, angles, at, true, 1, 1);
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

iz_mover_play(points, angles, at, once, id, state)
{
	end = at[at.size - 1];
	seen = level.iz_press[id];
	wait 0.05;
	self iz_place(points[0], angles[0]);
	t = 0;
	for (;;)
	{
		if (level.iz_press[id] != seen)
		{
			seen = level.iz_press[id];
			state = level.iz_play[id];
		}
		rate = 0;
		if (state == 0)
			rate = 1;
		else if (state == 2)
			rate = -1;
		else if (state == 3)
			rate = 2;
		else if (state == 4)
			rate = -2;
		t += rate * 0.05;
		if (once && t >= end)
		{
			t = end;
			if (rate > 0)
				state = 1;
		}
		else if (once && t <= 0)
		{
			t = 0;
			if (rate < 0)
				state = 1;
		}
		else if (end > 0)
		{
			while (t >= end)
				t -= end;
			while (t < 0)
				t += end;
		}
		i = 1;
		while (i < at.size - 1 && at[i] < t)
			i++;
		f = 0;
		if (at[i] > at[i - 1])
			f = (t - at[i - 1]) / (at[i] - at[i - 1]);
		if (f < 0)
			f = 0;
		if (f > 1)
			f = 1;
		self iz_move(points[i - 1] + (points[i] - points[i - 1]) * f, angles[i - 1] + (angles[i] - angles[i - 1]) * f, 1);
		wait 0.05;
	}
}
