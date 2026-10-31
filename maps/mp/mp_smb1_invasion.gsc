main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_smb1_invasion", 0);

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
	thread iz_mover2();
	thread iz_mover3();
	thread iz_mover4();
	thread iz_mover5();
}

iz_mover0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (175, -105, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (173.5480, -105, 0);
	angles[1] = (0, 0, 0);
	at[1] = 0.1500;
	points[2] = (169.4358, -105, 0);
	angles[2] = (0, 0, 0);
	at[2] = 0.3000;
	points[3] = (163.0252, -105, 0);
	angles[3] = (0, 0, 0);
	at[3] = 0.4500;
	points[4] = (154.6791, -105, 0);
	angles[4] = (0, 0, 0);
	at[4] = 0.6000;
	points[5] = (144.7598, -105, 0);
	angles[5] = (0, 0, 0);
	at[5] = 0.7500;
	points[6] = (133.6315, -105, 0);
	angles[6] = (0, 0, 0);
	at[6] = 0.9000;
	points[7] = (72.5465, -105, 0);
	angles[7] = (0, 0, 0);
	at[7] = 1.6500;
	points[8] = (61.7815, -105, 0);
	angles[8] = (0, 0, 0);
	at[8] = 1.8000;
	points[9] = (52.3465, -105, 0);
	angles[9] = (0, 0, 0);
	at[9] = 1.9500;
	points[10] = (44.6051, -105, 0);
	angles[10] = (0, 0, 0);
	at[10] = 2.1000;
	points[11] = (38.9200, -105, 0);
	angles[11] = (0, 0, 0);
	at[11] = 2.2500;
	points[12] = (35.6541, -105, 0);
	angles[12] = (0, 0, 0);
	at[12] = 2.4000;
	points[13] = (35, -105, 0);
	angles[13] = (0, 0, 0);
	at[13] = 2.5000;
	points[14] = (35.6541, -105, 0);
	angles[14] = (0, 0, 0);
	at[14] = 2.6000;
	points[15] = (38.9200, -105, 0);
	angles[15] = (0, 0, 0);
	at[15] = 2.7500;
	points[16] = (44.6051, -105, 0);
	angles[16] = (0, 0, 0);
	at[16] = 2.9000;
	points[17] = (52.3465, -105, 0);
	angles[17] = (0, 0, 0);
	at[17] = 3.0500;
	points[18] = (61.7815, -105, 0);
	angles[18] = (0, 0, 0);
	at[18] = 3.2000;
	points[19] = (72.5465, -105, 0);
	angles[19] = (0, 0, 0);
	at[19] = 3.3500;
	points[20] = (133.6315, -105, 0);
	angles[20] = (0, 0, 0);
	at[20] = 4.1000;
	points[21] = (144.7598, -105, 0);
	angles[21] = (0, 0, 0);
	at[21] = 4.2500;
	points[22] = (154.6791, -105, 0);
	angles[22] = (0, 0, 0);
	at[22] = 4.4000;
	points[23] = (163.0252, -105, 0);
	angles[23] = (0, 0, 0);
	at[23] = 4.5500;
	points[24] = (169.4358, -105, 0);
	angles[24] = (0, 0, 0);
	at[24] = 4.7000;
	points[25] = (173.5488, -105, 0);
	angles[25] = (0, 0, 0);
	at[25] = 4.8500;
	points[26] = (175, -105, 0);
	angles[26] = (0, 0, 0);
	at[26] = 5;
	mover = getEnt("iz_mover0", "targetname");
	if (!isDefined(mover))
		return;
	rider = getEnt("iz_bumper6_touch", "targetname");
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
	points[0] = (35, -315, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (35, -316.9599, 0);
	angles[1] = (0, 0, 0);
	at[1] = 0.2500;
	points[2] = (35, -319.8027, 0);
	angles[2] = (0, 0, 0);
	at[2] = 0.4000;
	points[3] = (35, -323.6728, 0);
	angles[3] = (0, 0, 0);
	at[3] = 0.5500;
	points[4] = (35, -333.7733, 0);
	angles[4] = (0, 0, 0);
	at[4] = 0.8500;
	points[5] = (35, -364.3158, 0);
	angles[5] = (0, 0, 0);
	at[5] = 1.6000;
	points[6] = (35, -374.8394, 0);
	angles[6] = (0, 0, 0);
	at[6] = 1.9000;
	points[7] = (35, -382.2181, 0);
	angles[7] = (0, 0, 0);
	at[7] = 2.2000;
	points[8] = (35, -384.2740, 0);
	angles[8] = (0, 0, 0);
	at[8] = 2.3500;
	points[9] = (35, -385, 0);
	angles[9] = (0, 0, 0);
	at[9] = 2.5000;
	points[10] = (35, -384.2740, 0);
	angles[10] = (0, 0, 0);
	at[10] = 2.6500;
	points[11] = (35, -382.2181, 0);
	angles[11] = (0, 0, 0);
	at[11] = 2.8000;
	points[12] = (35, -374.8394, 0);
	angles[12] = (0, 0, 0);
	at[12] = 3.1000;
	points[13] = (35, -364.3158, 0);
	angles[13] = (0, 0, 0);
	at[13] = 3.4000;
	points[14] = (35, -333.7733, 0);
	angles[14] = (0, 0, 0);
	at[14] = 4.1500;
	points[15] = (35, -323.6728, 0);
	angles[15] = (0, 0, 0);
	at[15] = 4.4500;
	points[16] = (35, -319.8027, 0);
	angles[16] = (0, 0, 0);
	at[16] = 4.6000;
	points[17] = (35, -316.9599, 0);
	angles[17] = (0, 0, 0);
	at[17] = 4.7500;
	points[18] = (35, -315, 0);
	angles[18] = (0, 0, 0);
	at[18] = 5;
	mover = getEnt("iz_mover1", "targetname");
	if (!isDefined(mover))
		return;
	rider = getEnt("iz_bumper7_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover2()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (35, -175, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (35.6541, -175, 0);
	angles[1] = (0, 0, 0);
	at[1] = 0.1000;
	points[2] = (38.9200, -175, 0);
	angles[2] = (0, 0, 0);
	at[2] = 0.2500;
	points[3] = (44.6051, -175, 0);
	angles[3] = (0, 0, 0);
	at[3] = 0.4000;
	points[4] = (52.3465, -175, 0);
	angles[4] = (0, 0, 0);
	at[4] = 0.5500;
	points[5] = (61.7815, -175, 0);
	angles[5] = (0, 0, 0);
	at[5] = 0.7000;
	points[6] = (72.5465, -175, 0);
	angles[6] = (0, 0, 0);
	at[6] = 0.8500;
	points[7] = (133.6315, -175, 0);
	angles[7] = (0, 0, 0);
	at[7] = 1.6000;
	points[8] = (144.7598, -175, 0);
	angles[8] = (0, 0, 0);
	at[8] = 1.7500;
	points[9] = (154.6791, -175, 0);
	angles[9] = (0, 0, 0);
	at[9] = 1.9000;
	points[10] = (163.0252, -175, 0);
	angles[10] = (0, 0, 0);
	at[10] = 2.0500;
	points[11] = (169.4358, -175, 0);
	angles[11] = (0, 0, 0);
	at[11] = 2.2000;
	points[12] = (173.5488, -175, 0);
	angles[12] = (0, 0, 0);
	at[12] = 2.3500;
	points[13] = (175, -175, 0);
	angles[13] = (0, 0, 0);
	at[13] = 2.5000;
	points[14] = (173.5480, -175, 0);
	angles[14] = (0, 0, 0);
	at[14] = 2.6500;
	points[15] = (169.4358, -175, 0);
	angles[15] = (0, 0, 0);
	at[15] = 2.8000;
	points[16] = (163.0252, -175, 0);
	angles[16] = (0, 0, 0);
	at[16] = 2.9500;
	points[17] = (154.6791, -175, 0);
	angles[17] = (0, 0, 0);
	at[17] = 3.1000;
	points[18] = (144.7598, -175, 0);
	angles[18] = (0, 0, 0);
	at[18] = 3.2500;
	points[19] = (133.6315, -175, 0);
	angles[19] = (0, 0, 0);
	at[19] = 3.4000;
	points[20] = (72.5465, -175, 0);
	angles[20] = (0, 0, 0);
	at[20] = 4.1500;
	points[21] = (61.7815, -175, 0);
	angles[21] = (0, 0, 0);
	at[21] = 4.3000;
	points[22] = (52.3465, -175, 0);
	angles[22] = (0, 0, 0);
	at[22] = 4.4500;
	points[23] = (44.6051, -175, 0);
	angles[23] = (0, 0, 0);
	at[23] = 4.6000;
	points[24] = (38.9200, -175, 0);
	angles[24] = (0, 0, 0);
	at[24] = 4.7500;
	points[25] = (35.6541, -175, 0);
	angles[25] = (0, 0, 0);
	at[25] = 4.9000;
	points[26] = (35, -175, 0);
	angles[26] = (0, 0, 0);
	at[26] = 5;
	mover = getEnt("iz_mover2", "targetname");
	if (!isDefined(mover))
		return;
	rider = getEnt("iz_bumper8_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover3()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (175, 245, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (174.3461, 245, 0);
	angles[1] = (0, 0, 0);
	at[1] = 0.0500;
	points[2] = (172.4555, 245, 0);
	angles[2] = (0, 0, 0);
	at[2] = 0.1000;
	points[3] = (169.4358, 245, 0);
	angles[3] = (0, 0, 0);
	at[3] = 0.1500;
	points[4] = (165.3945, 245, 0);
	angles[4] = (0, 0, 0);
	at[4] = 0.2000;
	points[5] = (154.6791, 245, 0);
	angles[5] = (0, 0, 0);
	at[5] = 0.3000;
	points[6] = (148.2185, 245, 0);
	angles[6] = (0, 0, 0);
	at[6] = 0.3500;
	points[7] = (133.6315, 245, 0);
	angles[7] = (0, 0, 0);
	at[7] = 0.4500;
	points[8] = (84.2799, 245, 0);
	angles[8] = (0, 0, 0);
	at[8] = 0.7500;
	points[9] = (68.8331, 245, 0);
	angles[9] = (0, 0, 0);
	at[9] = 0.8500;
	points[10] = (55.3213, 245, 0);
	angles[10] = (0, 0, 0);
	at[10] = 0.9500;
	points[11] = (49.5598, 245, 0);
	angles[11] = (0, 0, 0);
	at[11] = 1;
	points[12] = (40.5642, 245, 0);
	angles[12] = (0, 0, 0);
	at[12] = 1.1000;
	points[13] = (37.5446, 245, 0);
	angles[13] = (0, 0, 0);
	at[13] = 1.1500;
	points[14] = (35.6541, 245, 0);
	angles[14] = (0, 0, 0);
	at[14] = 1.2000;
	points[15] = (35, 245, 0);
	angles[15] = (0, 0, 0);
	at[15] = 1.2500;
	points[16] = (35, 244.3461, 0);
	angles[16] = (0, 0, 0);
	at[16] = 1.3000;
	points[17] = (35, 242.4555, 0);
	angles[17] = (0, 0, 0);
	at[17] = 1.3500;
	points[18] = (35, 239.4358, 0);
	angles[18] = (0, 0, 0);
	at[18] = 1.4000;
	points[19] = (35, 230.4402, 0);
	angles[19] = (0, 0, 0);
	at[19] = 1.5000;
	points[20] = (35, 224.6791, 0);
	angles[20] = (0, 0, 0);
	at[20] = 1.5500;
	points[21] = (35, 211.1669, 0);
	angles[21] = (0, 0, 0);
	at[21] = 1.6500;
	points[22] = (35, 195.7201, 0);
	angles[22] = (0, 0, 0);
	at[22] = 1.7500;
	points[23] = (35, 146.3685, 0);
	angles[23] = (0, 0, 0);
	at[23] = 2.0500;
	points[24] = (35, 131.7815, 0);
	angles[24] = (0, 0, 0);
	at[24] = 2.1500;
	points[25] = (35, 125.3209, 0);
	angles[25] = (0, 0, 0);
	at[25] = 2.2000;
	points[26] = (35, 114.6055, 0);
	angles[26] = (0, 0, 0);
	at[26] = 2.3000;
	points[27] = (35, 110.5642, 0);
	angles[27] = (0, 0, 0);
	at[27] = 2.3500;
	points[28] = (35, 107.5445, 0);
	angles[28] = (0, 0, 0);
	at[28] = 2.4000;
	points[29] = (35, 105.6539, 0);
	angles[29] = (0, 0, 0);
	at[29] = 2.4500;
	points[30] = (35, 105, 0);
	angles[30] = (0, 0, 0);
	at[30] = 2.5000;
	points[31] = (35.6541, 105, 0);
	angles[31] = (0, 0, 0);
	at[31] = 2.5500;
	points[32] = (37.5446, 105, 0);
	angles[32] = (0, 0, 0);
	at[32] = 2.6000;
	points[33] = (40.5642, 105, 0);
	angles[33] = (0, 0, 0);
	at[33] = 2.6500;
	points[34] = (49.5598, 105, 0);
	angles[34] = (0, 0, 0);
	at[34] = 2.7500;
	points[35] = (55.3213, 105, 0);
	angles[35] = (0, 0, 0);
	at[35] = 2.8000;
	points[36] = (68.8331, 105, 0);
	angles[36] = (0, 0, 0);
	at[36] = 2.9000;
	points[37] = (84.2799, 105, 0);
	angles[37] = (0, 0, 0);
	at[37] = 3;
	points[38] = (133.6315, 105, 0);
	angles[38] = (0, 0, 0);
	at[38] = 3.3000;
	points[39] = (148.2185, 105, 0);
	angles[39] = (0, 0, 0);
	at[39] = 3.4000;
	points[40] = (154.6791, 105, 0);
	angles[40] = (0, 0, 0);
	at[40] = 3.4500;
	points[41] = (165.3945, 105, 0);
	angles[41] = (0, 0, 0);
	at[41] = 3.5500;
	points[42] = (169.4358, 105, 0);
	angles[42] = (0, 0, 0);
	at[42] = 3.6000;
	points[43] = (172.4555, 105, 0);
	angles[43] = (0, 0, 0);
	at[43] = 3.6500;
	points[44] = (174.3461, 105, 0);
	angles[44] = (0, 0, 0);
	at[44] = 3.7000;
	points[45] = (175, 105, 0);
	angles[45] = (0, 0, 0);
	at[45] = 3.7500;
	points[46] = (175, 105.6539, 0);
	angles[46] = (0, 0, 0);
	at[46] = 3.8000;
	points[47] = (175, 107.5445, 0);
	angles[47] = (0, 0, 0);
	at[47] = 3.8500;
	points[48] = (175, 110.5642, 0);
	angles[48] = (0, 0, 0);
	at[48] = 3.9000;
	points[49] = (175, 119.5598, 0);
	angles[49] = (0, 0, 0);
	at[49] = 4;
	points[50] = (175, 125.3209, 0);
	angles[50] = (0, 0, 0);
	at[50] = 4.0500;
	points[51] = (175, 138.8331, 0);
	angles[51] = (0, 0, 0);
	at[51] = 4.1500;
	points[52] = (175, 154.2799, 0);
	angles[52] = (0, 0, 0);
	at[52] = 4.2500;
	points[53] = (175, 203.6315, 0);
	angles[53] = (0, 0, 0);
	at[53] = 4.5500;
	points[54] = (175, 218.2185, 0);
	angles[54] = (0, 0, 0);
	at[54] = 4.6500;
	points[55] = (175, 224.6791, 0);
	angles[55] = (0, 0, 0);
	at[55] = 4.7000;
	points[56] = (175, 235.3945, 0);
	angles[56] = (0, 0, 0);
	at[56] = 4.8000;
	points[57] = (175, 239.4358, 0);
	angles[57] = (0, 0, 0);
	at[57] = 4.8500;
	points[58] = (175, 242.4555, 0);
	angles[58] = (0, 0, 0);
	at[58] = 4.9000;
	points[59] = (175, 244.3461, 0);
	angles[59] = (0, 0, 0);
	at[59] = 4.9500;
	points[60] = (175, 245, 0);
	angles[60] = (0, 0, 0);
	at[60] = 5;
	mover = getEnt("iz_mover3", "targetname");
	if (!isDefined(mover))
		return;
	rider = getEnt("iz_bumper9_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover4()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (35, 105, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (35.6541, 105, 0);
	angles[1] = (0, 0, 0);
	at[1] = 0.0500;
	points[2] = (37.5446, 105, 0);
	angles[2] = (0, 0, 0);
	at[2] = 0.1000;
	points[3] = (40.5642, 105, 0);
	angles[3] = (0, 0, 0);
	at[3] = 0.1500;
	points[4] = (49.5598, 105, 0);
	angles[4] = (0, 0, 0);
	at[4] = 0.2500;
	points[5] = (55.3213, 105, 0);
	angles[5] = (0, 0, 0);
	at[5] = 0.3000;
	points[6] = (68.8331, 105, 0);
	angles[6] = (0, 0, 0);
	at[6] = 0.4000;
	points[7] = (84.2799, 105, 0);
	angles[7] = (0, 0, 0);
	at[7] = 0.5000;
	points[8] = (133.6315, 105, 0);
	angles[8] = (0, 0, 0);
	at[8] = 0.8000;
	points[9] = (148.2185, 105, 0);
	angles[9] = (0, 0, 0);
	at[9] = 0.9000;
	points[10] = (154.6791, 105, 0);
	angles[10] = (0, 0, 0);
	at[10] = 0.9500;
	points[11] = (165.3945, 105, 0);
	angles[11] = (0, 0, 0);
	at[11] = 1.0500;
	points[12] = (169.4358, 105, 0);
	angles[12] = (0, 0, 0);
	at[12] = 1.1000;
	points[13] = (172.4555, 105, 0);
	angles[13] = (0, 0, 0);
	at[13] = 1.1500;
	points[14] = (174.3461, 105, 0);
	angles[14] = (0, 0, 0);
	at[14] = 1.2000;
	points[15] = (175, 105, 0);
	angles[15] = (0, 0, 0);
	at[15] = 1.2500;
	points[16] = (175, 105.6539, 0);
	angles[16] = (0, 0, 0);
	at[16] = 1.3000;
	points[17] = (175, 107.5445, 0);
	angles[17] = (0, 0, 0);
	at[17] = 1.3500;
	points[18] = (175, 110.5642, 0);
	angles[18] = (0, 0, 0);
	at[18] = 1.4000;
	points[19] = (175, 119.5598, 0);
	angles[19] = (0, 0, 0);
	at[19] = 1.5000;
	points[20] = (175, 125.3209, 0);
	angles[20] = (0, 0, 0);
	at[20] = 1.5500;
	points[21] = (175, 138.8331, 0);
	angles[21] = (0, 0, 0);
	at[21] = 1.6500;
	points[22] = (175, 154.2799, 0);
	angles[22] = (0, 0, 0);
	at[22] = 1.7500;
	points[23] = (175, 203.6315, 0);
	angles[23] = (0, 0, 0);
	at[23] = 2.0500;
	points[24] = (175, 218.2185, 0);
	angles[24] = (0, 0, 0);
	at[24] = 2.1500;
	points[25] = (175, 224.6791, 0);
	angles[25] = (0, 0, 0);
	at[25] = 2.2000;
	points[26] = (175, 235.3945, 0);
	angles[26] = (0, 0, 0);
	at[26] = 2.3000;
	points[27] = (175, 239.4358, 0);
	angles[27] = (0, 0, 0);
	at[27] = 2.3500;
	points[28] = (175, 242.4555, 0);
	angles[28] = (0, 0, 0);
	at[28] = 2.4000;
	points[29] = (175, 244.3461, 0);
	angles[29] = (0, 0, 0);
	at[29] = 2.4500;
	points[30] = (175, 245, 0);
	angles[30] = (0, 0, 0);
	at[30] = 2.5000;
	points[31] = (174.3461, 245, 0);
	angles[31] = (0, 0, 0);
	at[31] = 2.5500;
	points[32] = (172.4555, 245, 0);
	angles[32] = (0, 0, 0);
	at[32] = 2.6000;
	points[33] = (169.4358, 245, 0);
	angles[33] = (0, 0, 0);
	at[33] = 2.6500;
	points[34] = (165.3945, 245, 0);
	angles[34] = (0, 0, 0);
	at[34] = 2.7000;
	points[35] = (154.6791, 245, 0);
	angles[35] = (0, 0, 0);
	at[35] = 2.8000;
	points[36] = (148.2185, 245, 0);
	angles[36] = (0, 0, 0);
	at[36] = 2.8500;
	points[37] = (133.6315, 245, 0);
	angles[37] = (0, 0, 0);
	at[37] = 2.9500;
	points[38] = (84.2799, 245, 0);
	angles[38] = (0, 0, 0);
	at[38] = 3.2500;
	points[39] = (68.8331, 245, 0);
	angles[39] = (0, 0, 0);
	at[39] = 3.3500;
	points[40] = (55.3213, 245, 0);
	angles[40] = (0, 0, 0);
	at[40] = 3.4500;
	points[41] = (49.5598, 245, 0);
	angles[41] = (0, 0, 0);
	at[41] = 3.5000;
	points[42] = (40.5642, 245, 0);
	angles[42] = (0, 0, 0);
	at[42] = 3.6000;
	points[43] = (37.5446, 245, 0);
	angles[43] = (0, 0, 0);
	at[43] = 3.6500;
	points[44] = (35.6541, 245, 0);
	angles[44] = (0, 0, 0);
	at[44] = 3.7000;
	points[45] = (35, 245, 0);
	angles[45] = (0, 0, 0);
	at[45] = 3.7500;
	points[46] = (35, 244.3461, 0);
	angles[46] = (0, 0, 0);
	at[46] = 3.8000;
	points[47] = (35, 242.4555, 0);
	angles[47] = (0, 0, 0);
	at[47] = 3.8500;
	points[48] = (35, 239.4358, 0);
	angles[48] = (0, 0, 0);
	at[48] = 3.9000;
	points[49] = (35, 230.4402, 0);
	angles[49] = (0, 0, 0);
	at[49] = 4;
	points[50] = (35, 224.6791, 0);
	angles[50] = (0, 0, 0);
	at[50] = 4.0500;
	points[51] = (35, 211.1669, 0);
	angles[51] = (0, 0, 0);
	at[51] = 4.1500;
	points[52] = (35, 195.7201, 0);
	angles[52] = (0, 0, 0);
	at[52] = 4.2500;
	points[53] = (35, 146.3685, 0);
	angles[53] = (0, 0, 0);
	at[53] = 4.5500;
	points[54] = (35, 131.7815, 0);
	angles[54] = (0, 0, 0);
	at[54] = 4.6500;
	points[55] = (35, 125.3209, 0);
	angles[55] = (0, 0, 0);
	at[55] = 4.7000;
	points[56] = (35, 114.6055, 0);
	angles[56] = (0, 0, 0);
	at[56] = 4.8000;
	points[57] = (35, 110.5642, 0);
	angles[57] = (0, 0, 0);
	at[57] = 4.8500;
	points[58] = (35, 107.5445, 0);
	angles[58] = (0, 0, 0);
	at[58] = 4.9000;
	points[59] = (35, 105.6539, 0);
	angles[59] = (0, 0, 0);
	at[59] = 4.9500;
	points[60] = (35, 105, 0);
	angles[60] = (0, 0, 0);
	at[60] = 5;
	mover = getEnt("iz_mover4", "targetname");
	if (!isDefined(mover))
		return;
	rider = getEnt("iz_bumper10_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover5()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (175, -385, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (175, -384.2740, 0);
	angles[1] = (0, 0, 0);
	at[1] = 0.1500;
	points[2] = (175, -382.2181, 0);
	angles[2] = (0, 0, 0);
	at[2] = 0.3000;
	points[3] = (175, -374.8394, 0);
	angles[3] = (0, 0, 0);
	at[3] = 0.6000;
	points[4] = (175, -364.3158, 0);
	angles[4] = (0, 0, 0);
	at[4] = 0.9000;
	points[5] = (175, -333.7733, 0);
	angles[5] = (0, 0, 0);
	at[5] = 1.6500;
	points[6] = (175, -323.6728, 0);
	angles[6] = (0, 0, 0);
	at[6] = 1.9500;
	points[7] = (175, -319.8027, 0);
	angles[7] = (0, 0, 0);
	at[7] = 2.1000;
	points[8] = (175, -316.9599, 0);
	angles[8] = (0, 0, 0);
	at[8] = 2.2500;
	points[9] = (175, -315, 0);
	angles[9] = (0, 0, 0);
	at[9] = 2.5000;
	points[10] = (175, -316.9599, 0);
	angles[10] = (0, 0, 0);
	at[10] = 2.7500;
	points[11] = (175, -319.8027, 0);
	angles[11] = (0, 0, 0);
	at[11] = 2.9000;
	points[12] = (175, -323.6728, 0);
	angles[12] = (0, 0, 0);
	at[12] = 3.0500;
	points[13] = (175, -333.7733, 0);
	angles[13] = (0, 0, 0);
	at[13] = 3.3500;
	points[14] = (175, -364.3158, 0);
	angles[14] = (0, 0, 0);
	at[14] = 4.1000;
	points[15] = (175, -374.8394, 0);
	angles[15] = (0, 0, 0);
	at[15] = 4.4000;
	points[16] = (175, -382.2181, 0);
	angles[16] = (0, 0, 0);
	at[16] = 4.7000;
	points[17] = (175, -384.2740, 0);
	angles[17] = (0, 0, 0);
	at[17] = 4.8500;
	points[18] = (175, -385, 0);
	angles[18] = (0, 0, 0);
	at[18] = 5;
	mover = getEnt("iz_mover5", "targetname");
	if (!isDefined(mover))
		return;
	rider = getEnt("iz_bumper11_touch", "targetname");
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
