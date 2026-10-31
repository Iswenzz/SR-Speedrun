main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_smb1_diving", 0);

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
	ambientPlay("iz_0_st2", 2);
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
	thread iz_bumper("iz_bumper0", true);
	thread iz_bumper("iz_bumper1", true);
	thread iz_bumper("iz_bumper2", true);
	thread iz_bumper("iz_bumper3", true);
	thread iz_bumper("iz_bumper4", true);
	thread iz_bumper("iz_bumper5", true);
	thread iz_bumper("iz_bumper6", true);
	thread iz_bumper("iz_bumper7", true);
	thread iz_bumper("iz_bumper8", true);
	thread iz_bumper("iz_bumper9", true);
	thread iz_bumper("iz_bumper10", true);
	thread iz_bumper("iz_bumper11", true);
	thread iz_bumper("iz_bumper12", true);
	thread iz_bumper("iz_bumper13", true);
	thread iz_bumper("iz_bumper14", true);
	thread iz_bumper("iz_bumper15", true);
	thread iz_bumper("iz_bumper16", true);
	thread iz_bumper("iz_bumper17", true);
	thread iz_bumper("iz_bumper18", true);
	thread iz_bumper("iz_bumper19", true);
	thread iz_bumper("iz_bumper20", true);
	thread iz_bumper("iz_bumper21", true);
	thread iz_bumper("iz_bumper22", true);
	thread iz_bumper("iz_bumper23", true);
	thread iz_bumper("iz_bumper24", true);
	thread iz_bumper("iz_bumper25", true);
	thread iz_bumper("iz_bumper26", true);
	thread iz_bumper("iz_bumper27", true);
	thread iz_bumper("iz_bumper28", true);
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
	points[0] = (0, 0, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (221.7598, 0, 0);
	angles[1] = (0, 0, 0);
	at[1] = 0.6000;
	points[2] = (221.7598, 0, 0);
	angles[2] = (0, 0, 0);
	at[2] = 0.6500;
	points[3] = (-221.7598, 0, 0);
	angles[3] = (0, 0, 0);
	at[3] = 1.8500;
	points[4] = (-221.7598, 0, 0);
	angles[4] = (0, 0, 0);
	at[4] = 1.9000;
	points[5] = (221.7598, 0, 0);
	angles[5] = (0, 0, 0);
	at[5] = 3.1000;
	points[6] = (221.7598, 0, 0);
	angles[6] = (0, 0, 0);
	at[6] = 3.1500;
	points[7] = (-221.7598, 0, 0);
	angles[7] = (0, 0, 0);
	at[7] = 4.3500;
	points[8] = (-221.7598, 0, 0);
	angles[8] = (0, 0, 0);
	at[8] = 4.4000;
	points[9] = (221.7598, 0, 0);
	angles[9] = (0, 0, 0);
	at[9] = 5.6000;
	points[10] = (221.7598, 0, 0);
	angles[10] = (0, 0, 0);
	at[10] = 5.6500;
	points[11] = (-221.7598, 0, 0);
	angles[11] = (0, 0, 0);
	at[11] = 6.8500;
	points[12] = (-221.7598, 0, 0);
	angles[12] = (0, 0, 0);
	at[12] = 6.9000;
	points[13] = (221.7598, 0, 0);
	angles[13] = (0, 0, 0);
	at[13] = 8.1000;
	points[14] = (221.7598, 0, 0);
	angles[14] = (0, 0, 0);
	at[14] = 8.1500;
	points[15] = (-221.7598, 0, 0);
	angles[15] = (0, 0, 0);
	at[15] = 9.3500;
	points[16] = (-221.7598, 0, 0);
	angles[16] = (0, 0, 0);
	at[16] = 9.4000;
	points[17] = (221.7598, 0, 0);
	angles[17] = (0, 0, 0);
	at[17] = 10.6000;
	points[18] = (221.7598, 0, 0);
	angles[18] = (0, 0, 0);
	at[18] = 10.6500;
	points[19] = (-221.7598, 0, 0);
	angles[19] = (0, 0, 0);
	at[19] = 11.8500;
	points[20] = (-221.7598, 0, 0);
	angles[20] = (0, 0, 0);
	at[20] = 11.9000;
	points[21] = (221.7598, 0, 0);
	angles[21] = (0, 0, 0);
	at[21] = 13.1000;
	points[22] = (221.7598, 0, 0);
	angles[22] = (0, 0, 0);
	at[22] = 13.1500;
	points[23] = (-221.7598, 0, 0);
	angles[23] = (0, 0, 0);
	at[23] = 14.3500;
	points[24] = (-221.7598, 0, 0);
	angles[24] = (0, 0, 0);
	at[24] = 14.4000;
	points[25] = (221.7598, 0, 0);
	angles[25] = (0, 0, 0);
	at[25] = 15.6000;
	points[26] = (221.7598, 0, 0);
	angles[26] = (0, 0, 0);
	at[26] = 15.6500;
	points[27] = (-221.7598, 0, 0);
	angles[27] = (0, 0, 0);
	at[27] = 16.8500;
	points[28] = (-221.7598, 0, 0);
	angles[28] = (0, 0, 0);
	at[28] = 16.9000;
	points[29] = (221.7598, 0, 0);
	angles[29] = (0, 0, 0);
	at[29] = 18.1000;
	points[30] = (221.7598, 0, 0);
	angles[30] = (0, 0, 0);
	at[30] = 18.1500;
	points[31] = (-221.7598, 0, 0);
	angles[31] = (0, 0, 0);
	at[31] = 19.3500;
	points[32] = (-221.7598, 0, 0);
	angles[32] = (0, 0, 0);
	at[32] = 19.4000;
	points[33] = (221.7598, 0, 0);
	angles[33] = (0, 0, 0);
	at[33] = 20.6000;
	points[34] = (221.7598, 0, 0);
	angles[34] = (0, 0, 0);
	at[34] = 20.6500;
	points[35] = (-221.7598, 0, 0);
	angles[35] = (0, 0, 0);
	at[35] = 21.8500;
	points[36] = (-221.7598, 0, 0);
	angles[36] = (0, 0, 0);
	at[36] = 21.9000;
	points[37] = (221.7598, 0, 0);
	angles[37] = (0, 0, 0);
	at[37] = 23.1000;
	points[38] = (221.7598, 0, 0);
	angles[38] = (0, 0, 0);
	at[38] = 23.1500;
	points[39] = (-221.7598, 0, 0);
	angles[39] = (0, 0, 0);
	at[39] = 24.3500;
	points[40] = (-221.7598, 0, 0);
	angles[40] = (0, 0, 0);
	at[40] = 24.4000;
	points[41] = (221.7598, 0, 0);
	angles[41] = (0, 0, 0);
	at[41] = 25.6000;
	points[42] = (221.7598, 0, 0);
	angles[42] = (0, 0, 0);
	at[42] = 25.6500;
	points[43] = (-221.7598, 0, 0);
	angles[43] = (0, 0, 0);
	at[43] = 26.8500;
	points[44] = (-221.7598, 0, 0);
	angles[44] = (0, 0, 0);
	at[44] = 26.9000;
	points[45] = (221.7598, 0, 0);
	angles[45] = (0, 0, 0);
	at[45] = 28.1000;
	points[46] = (221.7598, 0, 0);
	angles[46] = (0, 0, 0);
	at[46] = 28.1500;
	points[47] = (-221.7598, 0, 0);
	angles[47] = (0, 0, 0);
	at[47] = 29.3500;
	points[48] = (-221.7598, 0, 0);
	angles[48] = (0, 0, 0);
	at[48] = 29.4000;
	points[49] = (0, 0, 0);
	angles[49] = (0, 0, 0);
	at[49] = 30;
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
