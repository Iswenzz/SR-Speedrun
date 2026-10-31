main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_smb2_gimmick", 0);

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
	ambientPlay("iz_0_sf", 2);
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
	thread iz_mover1();
}

iz_mover0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-277.1260, -5775, -1050);
	angles[0] = (0, 0, -0.0055);
	at[0] = 0;
	points[1] = (-277.1260, -5775, -1050);
	angles[1] = (0, 0, 0.9276);
	at[1] = 0.6000;
	points[2] = (-277.1260, -5775, -1050);
	angles[2] = (0, 0, 3.5715);
	at[2] = 1.2000;
	points[3] = (-277.1260, -5775, -1050);
	angles[3] = (0, 0, 8.0956);
	at[3] = 1.8500;
	points[4] = (-277.1260, -5775, -1050);
	angles[4] = (0, 0, 14.0570);
	at[4] = 2.5000;
	points[5] = (-277.1260, -5775, -1050);
	angles[5] = (0, 0, 28.4711);
	at[5] = 3.7500;
	points[6] = (-277.1260, -5775, -1050);
	angles[6] = (0, 0, 65.2493);
	at[6] = 6.5500;
	points[7] = (-277.1260, -5775, -1050);
	angles[7] = (0, 0, 73.3193);
	at[7] = 7.2500;
	points[8] = (-277.1260, -5775, -1050);
	angles[8] = (0, 0, 79.7545);
	at[8] = 7.9000;
	points[9] = (-277.1260, -5775, -1050);
	angles[9] = (0, 0, 84.1781);
	at[9] = 8.4500;
	points[10] = (-277.1260, -5775, -1050);
	angles[10] = (0, 0, 87.4745);
	at[10] = 9;
	points[11] = (-277.1260, -5775, -1050);
	angles[11] = (0, 0, 89.3420);
	at[11] = 9.5000;
	points[12] = (-277.1260, -5775, -1050);
	angles[12] = (0, 0, 89.9945);
	at[12] = 10;
	points[13] = (-277.1260, -5775, -1050);
	angles[13] = (0, 0, 89.9945);
	at[13] = 1000;
	mover = getEnt("iz_mover0", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_play(points, angles, at, false, 1, 1);
}

iz_mover1()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-1644.5040, -6257.0078, -1750);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-1644.5040, -6256.8901, -1749.4802);
	angles[1] = (0, 0, 0);
	at[1] = 0.1500;
	points[2] = (-1644.5040, -6256.5356, -1747.9646);
	angles[2] = (0, 0, 0);
	at[2] = 0.3000;
	points[3] = (-1644.5118, -6255.1572, -1742.0197);
	angles[3] = (0, 0, 0);
	at[3] = 0.6000;
	points[4] = (-1644.5157, -6252.8740, -1732.4095);
	angles[4] = (0, 0, 0);
	at[4] = 0.9000;
	points[5] = (-1644.5237, -6249.7642, -1719.3976);
	angles[5] = (0, 0, 0);
	at[5] = 1.2000;
	points[6] = (-1644.5315, -6245.7876, -1703.2245);
	angles[6] = (0, 0, 0);
	at[6] = 1.5000;
	points[7] = (-1644.5433, -6240.1577, -1680.6930);
	angles[7] = (0, 0, 0);
	at[7] = 1.8500;
	points[8] = (-1644.5669, -6233.4648, -1654.5984);
	angles[8] = (0, 0, 0);
	at[8] = 2.2000;
	points[9] = (-1644.5865, -6224.6064, -1620.9135);
	angles[9] = (0, 0, 0);
	at[9] = 2.6000;
	points[10] = (-1644.6063, -6215.7871, -1588.5118);
	angles[10] = (0, 0, 0);
	at[10] = 2.9500;
	points[11] = (-1644.6300, -6206.1021, -1553.7834);
	angles[11] = (0, 0, 0);
	at[11] = 3.3000;
	points[12] = (-1644.6575, -6193.9761, -1511.7677);
	angles[12] = (0, 0, 0);
	at[12] = 3.7000;
	points[13] = (-1644.6851, -6180.8267, -1467.8308);
	angles[13] = (0, 0, 0);
	at[13] = 4.1000;
	points[14] = (-1644.7126, -6166.6533, -1422.5591);
	angles[14] = (0, 0, 0);
	at[14] = 4.5000;
	points[15] = (-1644.7480, -6149.6064, -1370.7756);
	angles[15] = (0, 0, 0);
	at[15] = 4.9500;
	points[16] = (-1644.7834, -6129.4092, -1313.1654);
	angles[16] = (0, 0, 0);
	at[16] = 5.4500;
	points[17] = (-1644.8110, -6114.5278, -1273.3898);
	angles[17] = (0, 0, 0);
	at[17] = 5.8000;
	points[18] = (-1644.8544, -6087.8345, -1207.5276);
	angles[18] = (0, 0, 0);
	at[18] = 6.4000;
	points[19] = (-1644.8740, -6073.9766, -1176.2166);
	angles[19] = (0, 0, 0);
	at[19] = 6.7000;
	points[20] = (-1644.8898, -6062.1655, -1151.1929);
	angles[20] = (0, 0, 0);
	at[20] = 6.9500;
	points[21] = (-1644.9095, -6047.7563, -1122.6653);
	angles[21] = (0, 0, 0);
	at[21] = 7.2500;
	points[22] = (-1644.9213, -6035.5117, -1100.3149);
	angles[22] = (0, 0, 0);
	at[22] = 7.5000;
	points[23] = (-1644.9370, -6020.6299, -1075.4016);
	angles[23] = (0, 0, 0);
	at[23] = 7.8000;
	points[24] = (-1644.9528, -6008.0708, -1056.4174);
	angles[24] = (0, 0, 0);
	at[24] = 8.0500;
	points[25] = (-1644.9646, -5995.3940, -1039.1930);
	angles[25] = (0, 0, 0);
	at[25] = 8.3000;
	points[26] = (-1644.9724, -5982.5981, -1023.8740);
	angles[26] = (0, 0, 0);
	at[26] = 8.5500;
	points[27] = (-1644.9803, -5969.6855, -1010.6024);
	angles[27] = (0, 0, 0);
	at[27] = 8.8000;
	points[28] = (-1644.9843, -5956.7319, -999.5315);
	angles[28] = (0, 0, 0);
	at[28] = 9.0500;
	points[29] = (-1644.9921, -5946.2993, -992.3425);
	angles[29] = (0, 0, 0);
	at[29] = 9.2500;
	points[30] = (-1644.9921, -5933.2280, -985.5788);
	angles[30] = (0, 0, 0);
	at[30] = 9.5000;
	points[31] = (-1645, -5920.1182, -981.4213);
	angles[31] = (0, 0, 0);
	at[31] = 9.7500;
	points[32] = (-1645, -5909.6064, -980.0551);
	angles[32] = (0, 0, 0);
	at[32] = 9.9500;
	points[33] = (-1645, -5813.5039, -980);
	angles[33] = (0, 0, 0);
	at[33] = 11.8000;
	points[34] = (-1645, -5780.9448, -980);
	angles[34] = (0, 0, 0);
	at[34] = 12.4500;
	points[35] = (-1645, -5749.4487, -980);
	angles[35] = (0, 0, 0);
	at[35] = 13.1000;
	points[36] = (-1645, -5717.0869, -980);
	angles[36] = (0, 0, 0);
	at[36] = 13.8000;
	points[37] = (-1645, -5695.1572, -980);
	angles[37] = (0, 0, 0);
	at[37] = 14.3000;
	points[38] = (-1645, -5676.3779, -980);
	angles[38] = (0, 0, 0);
	at[38] = 14.7500;
	points[39] = (-1645, -5652.9136, -980);
	angles[39] = (0, 0, 0);
	at[39] = 15.3500;
	points[40] = (-1645, -5629.8032, -980);
	angles[40] = (0, 0, 0);
	at[40] = 16;
	points[41] = (-1645, -5609.3311, -980);
	angles[41] = (0, 0, 0);
	at[41] = 16.6500;
	points[42] = (-1645, -5595.5908, -980);
	angles[42] = (0, 0, 0);
	at[42] = 17.1500;
	points[43] = (-1645, -5581.5752, -980);
	angles[43] = (0, 0, 0);
	at[43] = 17.7500;
	points[44] = (-1645, -5571.2993, -980);
	angles[44] = (0, 0, 0);
	at[44] = 18.3000;
	points[45] = (-1645, -5563.6616, -980);
	angles[45] = (0, 0, 0);
	at[45] = 18.8500;
	points[46] = (-1645, -5559.1733, -980);
	angles[46] = (0, 0, 0);
	at[46] = 19.3500;
	points[47] = (-1645, -5557.0474, -980);
	angles[47] = (0, 0, 0);
	at[47] = 19.9000;
	points[48] = (-1645, -5557.0078, -980);
	angles[48] = (0, 0, 0);
	at[48] = 1000;
	mover = getEnt("iz_mover1", "targetname");
	if (!isDefined(mover))
		return;
	rider = getEnt("iz_button0", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	mover thread iz_mover_play(points, angles, at, false, 1, 1);
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
