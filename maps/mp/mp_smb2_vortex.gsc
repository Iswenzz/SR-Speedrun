main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_smb2_vortex", 0);

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
	ambientPlay("iz_0_clocktower", 2);
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
	thread iz_button("iz_button0", 1, 3);
	thread iz_button("iz_button1", 1, 4);
	thread iz_button("iz_button2", 1, 2);
	thread iz_button("iz_button3", 1, 0);
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
	points[0] = (0.0027, -5040, 0);
	angles[0] = (0, -0.0055, 0);
	at[0] = 0;
	points[1] = (0.0027, -5040, 0);
	angles[1] = (0, 0.6583, 0);
	at[1] = 0.2500;
	points[2] = (0.0027, -5040, 0);
	angles[2] = (0, 2.6045, 0);
	at[2] = 0.5000;
	points[3] = (0.0027, -5040, 0);
	angles[3] = (0, 5.7658, 0);
	at[3] = 0.7500;
	points[4] = (0.0028, -5040, 0);
	angles[4] = (0, 10.0745, 0);
	at[4] = 1;
	points[5] = (0.0026, -5040, 0);
	angles[5] = (0, 15.4632, 0);
	at[5] = 1.2500;
	points[6] = (0.0026, -5040, 0);
	angles[6] = (0, 23.2604, 0);
	at[6] = 1.5500;
	points[7] = (0.0026, -5040, 0);
	angles[7] = (0, 30.7875, 0);
	at[7] = 1.8000;
	points[8] = (0.0026, -5040, 0);
	angles[8] = (0, 40.9546, 0);
	at[8] = 2.1000;
	points[9] = (0.0027, -5040, 0);
	angles[9] = (0, 52.2492, 0);
	at[9] = 2.4000;
	points[10] = (0.0027, -5040, 0);
	angles[10] = (0, 66.6958, 0);
	at[10] = 2.7500;
	points[11] = (0.0025, -5040, 0);
	angles[11] = (0, 82.3329, 0);
	at[11] = 3.1000;
	points[12] = (0.0028, -5040, 0);
	angles[12] = (0, 98.9756, 0);
	at[12] = 3.4500;
	points[13] = (0.0025, -5040, 0);
	angles[13] = (0, 137.1631, 0);
	at[13] = 4.2000;
	points[14] = (0.0026, -5040, 0);
	angles[14] = (0, 214.8969, 0);
	at[14] = 5.6500;
	points[15] = (0.0026, -5040, 0);
	angles[15] = (0, 246.0882, 0);
	at[15] = 6.2500;
	points[16] = (0.0025, -5040, 0);
	angles[16] = (0, 277.6561, 0);
	at[16] = 6.9000;
	points[17] = (0.0026, -5040, 0);
	angles[17] = (0, 303.7445, 0);
	at[17] = 7.5000;
	points[18] = (0.0025, -5040, 0);
	angles[18] = (0, 317.2271, 0);
	at[18] = 7.8500;
	points[19] = (0.0026, -5040, 0);
	angles[19] = (0, 327.5902, 0);
	at[19] = 8.1500;
	points[20] = (0.0027, -5040, 0);
	angles[20] = (0, 338.1244, 0);
	at[20] = 8.5000;
	points[21] = (0.0026, -5040, 0);
	angles[21] = (0, 345.6866, 0);
	at[21] = 8.8000;
	points[22] = (0.0028, -5040, 0);
	angles[22] = (0, 351.7714, 0);
	at[22] = 9.1000;
	points[23] = (0.0027, -5040, 0);
	angles[23] = (0, 356.2621, 0);
	at[23] = 9.4000;
	points[24] = (0.0027, -5040, 0);
	angles[24] = (0, 359.0420, 0);
	at[24] = 9.7000;
	points[25] = (0.0027, -5040, 0);
	angles[25] = (0, 359.9945, 0);
	at[25] = 10;
	points[26] = (0.0027, -5040, 0);
	angles[26] = (0, 359.0419, 0);
	at[26] = 10.3000;
	points[27] = (0.0027, -5040, 0);
	angles[27] = (0, 356.2620, 0);
	at[27] = 10.6000;
	points[28] = (0.0028, -5040, 0);
	angles[28] = (0, 351.7714, 0);
	at[28] = 10.9000;
	points[29] = (0.0026, -5040, 0);
	angles[29] = (0, 345.6866, 0);
	at[29] = 11.2000;
	points[30] = (0.0027, -5040, 0);
	angles[30] = (0, 338.1244, 0);
	at[30] = 11.5000;
	points[31] = (0.0026, -5040, 0);
	angles[31] = (0, 327.5902, 0);
	at[31] = 11.8500;
	points[32] = (0.0025, -5040, 0);
	angles[32] = (0, 317.2272, 0);
	at[32] = 12.1500;
	points[33] = (0.0026, -5040, 0);
	angles[33] = (0, 303.7445, 0);
	at[33] = 12.5000;
	points[34] = (0.0025, -5040, 0);
	angles[34] = (0, 277.6559, 0);
	at[34] = 13.1000;
	points[35] = (0.0026, -5040, 0);
	angles[35] = (0, 246.0882, 0);
	at[35] = 13.7500;
	points[36] = (0.0026, -5040, 0);
	angles[36] = (0, 214.8968, 0);
	at[36] = 14.3500;
	points[37] = (0.0025, -5040, 0);
	angles[37] = (0, 137.1630, 0);
	at[37] = 15.8000;
	points[38] = (0.0028, -5040, 0);
	angles[38] = (0, 98.9758, 0);
	at[38] = 16.5500;
	points[39] = (0.0025, -5040, 0);
	angles[39] = (0, 82.3331, 0);
	at[39] = 16.9000;
	points[40] = (0.0027, -5040, 0);
	angles[40] = (0, 66.6957, 0);
	at[40] = 17.2500;
	points[41] = (0.0027, -5040, 0);
	angles[41] = (0, 52.2493, 0);
	at[41] = 17.6000;
	points[42] = (0.0026, -5040, 0);
	angles[42] = (0, 40.9546, 0);
	at[42] = 17.9000;
	points[43] = (0.0026, -5040, 0);
	angles[43] = (0, 30.7874, 0);
	at[43] = 18.2000;
	points[44] = (0.0026, -5040, 0);
	angles[44] = (0, 23.2603, 0);
	at[44] = 18.4500;
	points[45] = (0.0026, -5040, 0);
	angles[45] = (0, 15.4632, 0);
	at[45] = 18.7500;
	points[46] = (0.0028, -5040, 0);
	angles[46] = (0, 10.0745, 0);
	at[46] = 19;
	points[47] = (0.0027, -5040, 0);
	angles[47] = (0, 5.7658, 0);
	at[47] = 19.2500;
	points[48] = (0.0027, -5040, 0);
	angles[48] = (0, 2.6045, 0);
	at[48] = 19.5000;
	points[49] = (0.0027, -5040, 0);
	angles[49] = (0, 0.6582, 0);
	at[49] = 19.7500;
	points[50] = (0.0027, -5040, 0);
	angles[50] = (0, -0.0055, 0);
	at[50] = 20;
	mover = getEnt("iz_mover0", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_play(points, angles, at, false, 1, 0);
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
