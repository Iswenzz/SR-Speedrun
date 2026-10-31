main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_smb2_amida_lot", 0);

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
	thread iz_bumper("iz_bumper0", true);
	thread iz_bumper("iz_bumper1", true);
	thread iz_bumper("iz_bumper2", true);
	thread iz_bumper("iz_bumper3", true);
	thread iz_bumper("iz_bumper4", true);
	thread iz_bumper("iz_bumper5", true);
	thread iz_bumper("iz_bumper6", true);
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
	thread iz_mover6();
	thread iz_mover7();
}

iz_mover0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, -350, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, -2450, 0);
	angles[1] = (0, 0, 0);
	at[1] = 3.7500;
	points[2] = (0, -2450, 0);
	angles[2] = (0, 0, 0);
	at[2] = 4.6000;
	points[3] = (0, -2468.4253, 0);
	angles[3] = (0, 0, 0);
	at[3] = 4.6500;
	points[4] = (0, -4200, 0);
	angles[4] = (0, 0, 0);
	at[4] = 7;
	points[5] = (0, -4200, 0);
	angles[5] = (0, 0, 0);
	at[5] = 7.1000;
	points[6] = (0, -4185.7480, 0);
	angles[6] = (0, 0, 0);
	at[6] = 7.1500;
	points[7] = (0, -364.2591, 0);
	angles[7] = (0, 0, 0);
	at[7] = 13.8500;
	points[8] = (0, -350, 0);
	angles[8] = (0, 0, 0);
	at[8] = 13.9000;
	points[9] = (0, -350, 0);
	angles[9] = (0, 0, 0);
	at[9] = 14;
	points[10] = (0, -4202.2837, 0);
	angles[10] = (0, 0, 0);
	at[10] = 21;
	points[11] = (0, -4202.2837, 0);
	angles[11] = (0, 0, 0);
	at[11] = 21.1000;
	points[12] = (0, -4180.5513, 0);
	angles[12] = (0, 0, 0);
	at[12] = 21.1500;
	points[13] = (0, -2572.2048, 0);
	angles[13] = (0, 0, 0);
	at[13] = 23;
	points[14] = (0, -350, 0);
	angles[14] = (0, 0, 0);
	at[14] = 28;
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
	points[0] = (840, -4235, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (840, -4039.0159, 0);
	angles[1] = (0, 0, 0);
	at[1] = 0.3500;
	points[2] = (826, -4025, 0);
	angles[2] = (0, 0, 0);
	at[2] = 0.4000;
	points[3] = (574, -4025, 0);
	angles[3] = (0, 0, 0);
	at[3] = 0.8500;
	points[4] = (560, -4010.9841, 0);
	angles[4] = (0, 0, 0);
	at[4] = 0.9000;
	points[5] = (560, -3675, 0);
	angles[5] = (0, 0, 0);
	at[5] = 1.5000;
	points[6] = (280, -3675, 0);
	angles[6] = (0, 0, 0);
	at[6] = 2;
	points[7] = (280, -3255, 0);
	angles[7] = (0, 0, 0);
	at[7] = 2.7500;
	points[8] = (0, -3255, 0);
	angles[8] = (0, 0, 0);
	at[8] = 3.2500;
	points[9] = (0, -2975, 0);
	angles[9] = (0, 0, 0);
	at[9] = 3.7500;
	points[10] = (-280, -2975, 0);
	angles[10] = (0, 0, 0);
	at[10] = 4.2500;
	points[11] = (-280, -2779, 0);
	angles[11] = (0, 0, 0);
	at[11] = 4.6000;
	points[12] = (-294, -2765, 0);
	angles[12] = (0, 0, 0);
	at[12] = 4.6500;
	points[13] = (-546, -2765, 0);
	angles[13] = (0, 0, 0);
	at[13] = 5.1000;
	points[14] = (-560, -2751, 0);
	angles[14] = (0, 0, 0);
	at[14] = 5.1500;
	points[15] = (-560, -2359, 0);
	angles[15] = (0, 0, 0);
	at[15] = 5.8500;
	points[16] = (-574, -2345, 0);
	angles[16] = (0, 0, 0);
	at[16] = 5.9000;
	points[17] = (-826, -2345, 0);
	angles[17] = (0, 0, 0);
	at[17] = 6.3500;
	points[18] = (-840, -2331, 0);
	angles[18] = (0, 0, 0);
	at[18] = 6.4000;
	points[19] = (-840, -1659, 0);
	angles[19] = (0, 0, 0);
	at[19] = 7.6000;
	points[20] = (-826, -1645, 0);
	angles[20] = (0, 0, 0);
	at[20] = 7.6500;
	points[21] = (-574, -1645, 0);
	angles[21] = (0, 0, 0);
	at[21] = 8.1000;
	points[22] = (-560, -1631, 0);
	angles[22] = (0, 0, 0);
	at[22] = 8.1500;
	points[23] = (-560, -1435, 0);
	angles[23] = (0, 0, 0);
	at[23] = 8.5000;
	points[24] = (-840, -1435, 0);
	angles[24] = (0, 0, 0);
	at[24] = 9;
	points[25] = (-840, -735, 0);
	angles[25] = (0, 0, 0);
	at[25] = 10.2500;
	points[26] = (-560, -735, 0);
	angles[26] = (0, 0, 0);
	at[26] = 10.7500;
	points[27] = (-560, -539, 0);
	angles[27] = (0, 0, 0);
	at[27] = 11.1000;
	points[28] = (-546, -525, 0);
	angles[28] = (0, 0, 0);
	at[28] = 11.1500;
	points[29] = (-294, -525, 0);
	angles[29] = (0, 0, 0);
	at[29] = 11.6000;
	points[30] = (-280, -511, 0);
	angles[30] = (0, 0, 0);
	at[30] = 11.6500;
	points[31] = (-280, -175, 0);
	angles[31] = (0, 0, 0);
	at[31] = 12.2500;
	points[32] = (-280, -175, 0);
	angles[32] = (0, 0, 0);
	at[32] = 15.6000;
	points[33] = (-280, -189, 0);
	angles[33] = (0, 0, 0);
	at[33] = 15.6500;
	points[34] = (-280, -525, 0);
	angles[34] = (0, 0, 0);
	at[34] = 16.2500;
	points[35] = (-560, -525, 0);
	angles[35] = (0, 0, 0);
	at[35] = 16.7500;
	points[36] = (-560, -721, 0);
	angles[36] = (0, 0, 0);
	at[36] = 17.1000;
	points[37] = (-574, -735, 0);
	angles[37] = (0, 0, 0);
	at[37] = 17.1500;
	points[38] = (-826, -735, 0);
	angles[38] = (0, 0, 0);
	at[38] = 17.6000;
	points[39] = (-840, -749, 0);
	angles[39] = (0, 0, 0);
	at[39] = 17.6500;
	points[40] = (-840, -1421, 0);
	angles[40] = (0, 0, 0);
	at[40] = 18.8500;
	points[41] = (-826, -1435, 0);
	angles[41] = (0, 0, 0);
	at[41] = 18.9000;
	points[42] = (-574, -1435, 0);
	angles[42] = (0, 0, 0);
	at[42] = 19.3500;
	points[43] = (-560, -1449, 0);
	angles[43] = (0, 0, 0);
	at[43] = 19.4000;
	points[44] = (-560, -1645, 0);
	angles[44] = (0, 0, 0);
	at[44] = 19.7500;
	points[45] = (-840, -1645, 0);
	angles[45] = (0, 0, 0);
	at[45] = 20.2500;
	points[46] = (-840, -2345, 0);
	angles[46] = (0, 0, 0);
	at[46] = 21.5000;
	points[47] = (-560, -2345, 0);
	angles[47] = (0, 0, 0);
	at[47] = 22;
	points[48] = (-560, -2765, 0);
	angles[48] = (0, 0, 0);
	at[48] = 22.7500;
	points[49] = (-280, -2765, 0);
	angles[49] = (0, 0, 0);
	at[49] = 23.2500;
	points[50] = (-280, -2961, 0);
	angles[50] = (0, 0, 0);
	at[50] = 23.6000;
	points[51] = (-266, -2975, 0);
	angles[51] = (0, 0, 0);
	at[51] = 23.6500;
	points[52] = (-14, -2975, 0);
	angles[52] = (0, 0, 0);
	at[52] = 24.1000;
	points[53] = (0, -2989, 0);
	angles[53] = (0, 0, 0);
	at[53] = 24.1500;
	points[54] = (0, -3241, 0);
	angles[54] = (0, 0, 0);
	at[54] = 24.6000;
	points[55] = (14, -3255, 0);
	angles[55] = (0, 0, 0);
	at[55] = 24.6500;
	points[56] = (266, -3255, 0);
	angles[56] = (0, 0, 0);
	at[56] = 25.1000;
	points[57] = (280, -3269, 0);
	angles[57] = (0, 0, 0);
	at[57] = 25.1500;
	points[58] = (280, -3661, 0);
	angles[58] = (0, 0, 0);
	at[58] = 25.8500;
	points[59] = (294, -3675, 0);
	angles[59] = (0, 0, 0);
	at[59] = 25.9000;
	points[60] = (546, -3675, 0);
	angles[60] = (0, 0, 0);
	at[60] = 26.3500;
	points[61] = (560, -3689, 0);
	angles[61] = (0, 0, 0);
	at[61] = 26.4000;
	points[62] = (560, -4025, 0);
	angles[62] = (0, 0, 0);
	at[62] = 27;
	points[63] = (840, -4025, 0);
	angles[63] = (0, 0, 0);
	at[63] = 27.5000;
	points[64] = (840, -4220.9844, 0);
	angles[64] = (0, 0, 0);
	at[64] = 27.8500;
	points[65] = (840, -4235, 0);
	angles[65] = (0, 0, 0);
	at[65] = 27.9000;
	points[66] = (840, -4235, 0);
	angles[66] = (0, 0, 0);
	at[66] = 28;
	mover = getEnt("iz_mover1", "targetname");
	if (!isDefined(mover))
		return;
	rider = getEnt("iz_bumper0_touch", "targetname");
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
	points[0] = (560, -4235, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (560, -4039.0159, 0);
	angles[1] = (0, 0, 0);
	at[1] = 0.3500;
	points[2] = (574, -4025, 0);
	angles[2] = (0, 0, 0);
	at[2] = 0.4000;
	points[3] = (826, -4025, 0);
	angles[3] = (0, 0, 0);
	at[3] = 0.8500;
	points[4] = (840, -4010.9841, 0);
	angles[4] = (0, 0, 0);
	at[4] = 0.9000;
	points[5] = (840, -3479, 0);
	angles[5] = (0, 0, 0);
	at[5] = 1.8500;
	points[6] = (826, -3465, 0);
	angles[6] = (0, 0, 0);
	at[6] = 1.9000;
	points[7] = (574, -3465, 0);
	angles[7] = (0, 0, 0);
	at[7] = 2.3500;
	points[8] = (560, -3451, 0);
	angles[8] = (0, 0, 0);
	at[8] = 2.4000;
	points[9] = (560, -3115, 0);
	angles[9] = (0, 0, 0);
	at[9] = 3;
	points[10] = (840, -3115, 0);
	angles[10] = (0, 0, 0);
	at[10] = 3.5000;
	points[11] = (840, -2499, 0);
	angles[11] = (0, 0, 0);
	at[11] = 4.6000;
	points[12] = (826, -2485, 0);
	angles[12] = (0, 0, 0);
	at[12] = 4.6500;
	points[13] = (574, -2485, 0);
	angles[13] = (0, 0, 0);
	at[13] = 5.1000;
	points[14] = (560, -2471, 0);
	angles[14] = (0, 0, 0);
	at[14] = 5.1500;
	points[15] = (560, -2135, 0);
	angles[15] = (0, 0, 0);
	at[15] = 5.7500;
	points[16] = (280, -2135, 0);
	angles[16] = (0, 0, 0);
	at[16] = 6.2500;
	points[17] = (280, -1799, 0);
	angles[17] = (0, 0, 0);
	at[17] = 6.8500;
	points[18] = (266, -1785, 0);
	angles[18] = (0, 0, 0);
	at[18] = 6.9000;
	points[19] = (14, -1785, 0);
	angles[19] = (0, 0, 0);
	at[19] = 7.3500;
	points[20] = (0, -1771, 0);
	angles[20] = (0, 0, 0);
	at[20] = 7.4000;
	points[21] = (0, -1295, 0);
	angles[21] = (0, 0, 0);
	at[21] = 8.2500;
	points[22] = (-280, -1295, 0);
	angles[22] = (0, 0, 0);
	at[22] = 8.7500;
	points[23] = (-280, -1099, 0);
	angles[23] = (0, 0, 0);
	at[23] = 9.1000;
	points[24] = (-294, -1085, 0);
	angles[24] = (0, 0, 0);
	at[24] = 9.1500;
	points[25] = (-546, -1085, 0);
	angles[25] = (0, 0, 0);
	at[25] = 9.6000;
	points[26] = (-560, -1071, 0);
	angles[26] = (0, 0, 0);
	at[26] = 9.6500;
	points[27] = (-560, -735, 0);
	angles[27] = (0, 0, 0);
	at[27] = 10.2500;
	points[28] = (-840, -735, 0);
	angles[28] = (0, 0, 0);
	at[28] = 10.7500;
	points[29] = (-840, -399, 0);
	angles[29] = (0, 0, 0);
	at[29] = 11.3500;
	points[30] = (-826, -385, 0);
	angles[30] = (0, 0, 0);
	at[30] = 11.4000;
	points[31] = (-574, -385, 0);
	angles[31] = (0, 0, 0);
	at[31] = 11.8500;
	points[32] = (-560, -371, 0);
	angles[32] = (0, 0, 0);
	at[32] = 11.9000;
	points[33] = (-560, -175, 0);
	angles[33] = (0, 0, 0);
	at[33] = 12.2500;
	points[34] = (-560, -175, 0);
	angles[34] = (0, 0, 0);
	at[34] = 15.6000;
	points[35] = (-560, -189, 0);
	angles[35] = (0, 0, 0);
	at[35] = 15.6500;
	points[36] = (-560, -385, 0);
	angles[36] = (0, 0, 0);
	at[36] = 16;
	points[37] = (-840, -385, 0);
	angles[37] = (0, 0, 0);
	at[37] = 16.5000;
	points[38] = (-840, -721, 0);
	angles[38] = (0, 0, 0);
	at[38] = 17.1000;
	points[39] = (-826, -735, 0);
	angles[39] = (0, 0, 0);
	at[39] = 17.1500;
	points[40] = (-574, -735, 0);
	angles[40] = (0, 0, 0);
	at[40] = 17.6000;
	points[41] = (-560, -749, 0);
	angles[41] = (0, 0, 0);
	at[41] = 17.6500;
	points[42] = (-560, -1085, 0);
	angles[42] = (0, 0, 0);
	at[42] = 18.2500;
	points[43] = (-280, -1085, 0);
	angles[43] = (0, 0, 0);
	at[43] = 18.7500;
	points[44] = (-280, -1281, 0);
	angles[44] = (0, 0, 0);
	at[44] = 19.1000;
	points[45] = (-266, -1295, 0);
	angles[45] = (0, 0, 0);
	at[45] = 19.1500;
	points[46] = (-14, -1295, 0);
	angles[46] = (0, 0, 0);
	at[46] = 19.6000;
	points[47] = (0, -1309, 0);
	angles[47] = (0, 0, 0);
	at[47] = 19.6500;
	points[48] = (0, -1785, 0);
	angles[48] = (0, 0, 0);
	at[48] = 20.5000;
	points[49] = (280, -1785, 0);
	angles[49] = (0, 0, 0);
	at[49] = 21;
	points[50] = (280, -2121, 0);
	angles[50] = (0, 0, 0);
	at[50] = 21.6000;
	points[51] = (294, -2135, 0);
	angles[51] = (0, 0, 0);
	at[51] = 21.6500;
	points[52] = (546, -2135, 0);
	angles[52] = (0, 0, 0);
	at[52] = 22.1000;
	points[53] = (560, -2149, 0);
	angles[53] = (0, 0, 0);
	at[53] = 22.1500;
	points[54] = (560, -2485, 0);
	angles[54] = (0, 0, 0);
	at[54] = 22.7500;
	points[55] = (840, -2485, 0);
	angles[55] = (0, 0, 0);
	at[55] = 23.2500;
	points[56] = (840, -3101, 0);
	angles[56] = (0, 0, 0);
	at[56] = 24.3500;
	points[57] = (826, -3115, 0);
	angles[57] = (0, 0, 0);
	at[57] = 24.4000;
	points[58] = (574, -3115, 0);
	angles[58] = (0, 0, 0);
	at[58] = 24.8500;
	points[59] = (560, -3129, 0);
	angles[59] = (0, 0, 0);
	at[59] = 24.9000;
	points[60] = (560, -3465, 0);
	angles[60] = (0, 0, 0);
	at[60] = 25.5000;
	points[61] = (840, -3465, 0);
	angles[61] = (0, 0, 0);
	at[61] = 26;
	points[62] = (840, -4025, 0);
	angles[62] = (0, 0, 0);
	at[62] = 27;
	points[63] = (560, -4025, 0);
	angles[63] = (0, 0, 0);
	at[63] = 27.5000;
	points[64] = (560, -4220.9844, 0);
	angles[64] = (0, 0, 0);
	at[64] = 27.8500;
	points[65] = (560, -4235, 0);
	angles[65] = (0, 0, 0);
	at[65] = 27.9000;
	points[66] = (560, -4235, 0);
	angles[66] = (0, 0, 0);
	at[66] = 28;
	mover = getEnt("iz_mover2", "targetname");
	if (!isDefined(mover))
		return;
	rider = getEnt("iz_bumper1_touch", "targetname");
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
	points[0] = (280, -4235, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (280, -3815, 0);
	angles[1] = (0, 0, 0);
	at[1] = 0.7500;
	points[2] = (0, -3815, 0);
	angles[2] = (0, 0, 0);
	at[2] = 1.2500;
	points[3] = (0, -3255, 0);
	angles[3] = (0, 0, 0);
	at[3] = 2.2500;
	points[4] = (280, -3255, 0);
	angles[4] = (0, 0, 0);
	at[4] = 2.7500;
	points[5] = (280, -2835, 0);
	angles[5] = (0, 0, 0);
	at[5] = 3.5000;
	points[6] = (560, -2835, 0);
	angles[6] = (0, 0, 0);
	at[6] = 4;
	points[7] = (560, -2499, 0);
	angles[7] = (0, 0, 0);
	at[7] = 4.6000;
	points[8] = (574, -2485, 0);
	angles[8] = (0, 0, 0);
	at[8] = 4.6500;
	points[9] = (826, -2485, 0);
	angles[9] = (0, 0, 0);
	at[9] = 5.1000;
	points[10] = (840, -2471, 0);
	angles[10] = (0, 0, 0);
	at[10] = 5.1500;
	points[11] = (840, -1799, 0);
	angles[11] = (0, 0, 0);
	at[11] = 6.3500;
	points[12] = (826, -1785, 0);
	angles[12] = (0, 0, 0);
	at[12] = 6.4000;
	points[13] = (574, -1785, 0);
	angles[13] = (0, 0, 0);
	at[13] = 6.8500;
	points[14] = (560, -1771, 0);
	angles[14] = (0, 0, 0);
	at[14] = 6.9000;
	points[15] = (560, -1435, 0);
	angles[15] = (0, 0, 0);
	at[15] = 7.5000;
	points[16] = (280, -1435, 0);
	angles[16] = (0, 0, 0);
	at[16] = 8;
	points[17] = (280, -1099, 0);
	angles[17] = (0, 0, 0);
	at[17] = 8.6000;
	points[18] = (266, -1085, 0);
	angles[18] = (0, 0, 0);
	at[18] = 8.6500;
	points[19] = (14, -1085, 0);
	angles[19] = (0, 0, 0);
	at[19] = 9.1000;
	points[20] = (0, -1071, 0);
	angles[20] = (0, 0, 0);
	at[20] = 9.1500;
	points[21] = (0, -875, 0);
	angles[21] = (0, 0, 0);
	at[21] = 9.5000;
	points[22] = (-280, -875, 0);
	angles[22] = (0, 0, 0);
	at[22] = 10;
	points[23] = (-280, -539, 0);
	angles[23] = (0, 0, 0);
	at[23] = 10.6000;
	points[24] = (-294, -525, 0);
	angles[24] = (0, 0, 0);
	at[24] = 10.6500;
	points[25] = (-546, -525, 0);
	angles[25] = (0, 0, 0);
	at[25] = 11.1000;
	points[26] = (-560, -511, 0);
	angles[26] = (0, 0, 0);
	at[26] = 11.1500;
	points[27] = (-560, -399, 0);
	angles[27] = (0, 0, 0);
	at[27] = 11.3500;
	points[28] = (-574, -385, 0);
	angles[28] = (0, 0, 0);
	at[28] = 11.4000;
	points[29] = (-826, -385, 0);
	angles[29] = (0, 0, 0);
	at[29] = 11.8500;
	points[30] = (-840, -371, 0);
	angles[30] = (0, 0, 0);
	at[30] = 11.9000;
	points[31] = (-840, -175, 0);
	angles[31] = (0, 0, 0);
	at[31] = 12.2500;
	points[32] = (-840, -175, 0);
	angles[32] = (0, 0, 0);
	at[32] = 15.6000;
	points[33] = (-840, -189, 0);
	angles[33] = (0, 0, 0);
	at[33] = 15.6500;
	points[34] = (-840, -385, 0);
	angles[34] = (0, 0, 0);
	at[34] = 16;
	points[35] = (-560, -385, 0);
	angles[35] = (0, 0, 0);
	at[35] = 16.5000;
	points[36] = (-560, -525, 0);
	angles[36] = (0, 0, 0);
	at[36] = 16.7500;
	points[37] = (-280, -525, 0);
	angles[37] = (0, 0, 0);
	at[37] = 17.2500;
	points[38] = (-280, -861, 0);
	angles[38] = (0, 0, 0);
	at[38] = 17.8500;
	points[39] = (-266, -875, 0);
	angles[39] = (0, 0, 0);
	at[39] = 17.9000;
	points[40] = (-14, -875, 0);
	angles[40] = (0, 0, 0);
	at[40] = 18.3500;
	points[41] = (0, -889, 0);
	angles[41] = (0, 0, 0);
	at[41] = 18.4000;
	points[42] = (0, -1085, 0);
	angles[42] = (0, 0, 0);
	at[42] = 18.7500;
	points[43] = (280, -1085, 0);
	angles[43] = (0, 0, 0);
	at[43] = 19.2500;
	points[44] = (280, -1421, 0);
	angles[44] = (0, 0, 0);
	at[44] = 19.8500;
	points[45] = (294, -1435, 0);
	angles[45] = (0, 0, 0);
	at[45] = 19.9000;
	points[46] = (546, -1435, 0);
	angles[46] = (0, 0, 0);
	at[46] = 20.3500;
	points[47] = (560, -1449, 0);
	angles[47] = (0, 0, 0);
	at[47] = 20.4000;
	points[48] = (560, -1785, 0);
	angles[48] = (0, 0, 0);
	at[48] = 21;
	points[49] = (840, -1785, 0);
	angles[49] = (0, 0, 0);
	at[49] = 21.5000;
	points[50] = (840, -2485, 0);
	angles[50] = (0, 0, 0);
	at[50] = 22.7500;
	points[51] = (560, -2485, 0);
	angles[51] = (0, 0, 0);
	at[51] = 23.2500;
	points[52] = (560, -2821, 0);
	angles[52] = (0, 0, 0);
	at[52] = 23.8500;
	points[53] = (546, -2835, 0);
	angles[53] = (0, 0, 0);
	at[53] = 23.9000;
	points[54] = (294, -2835, 0);
	angles[54] = (0, 0, 0);
	at[54] = 24.3500;
	points[55] = (280, -2849, 0);
	angles[55] = (0, 0, 0);
	at[55] = 24.4000;
	points[56] = (280, -3241, 0);
	angles[56] = (0, 0, 0);
	at[56] = 25.1000;
	points[57] = (266, -3255, 0);
	angles[57] = (0, 0, 0);
	at[57] = 25.1500;
	points[58] = (14, -3255, 0);
	angles[58] = (0, 0, 0);
	at[58] = 25.6000;
	points[59] = (0, -3269, 0);
	angles[59] = (0, 0, 0);
	at[59] = 25.6500;
	points[60] = (0, -3801, 0);
	angles[60] = (0, 0, 0);
	at[60] = 26.6000;
	points[61] = (14, -3815, 0);
	angles[61] = (0, 0, 0);
	at[61] = 26.6500;
	points[62] = (266, -3815, 0);
	angles[62] = (0, 0, 0);
	at[62] = 27.1000;
	points[63] = (280, -3829, 0);
	angles[63] = (0, 0, 0);
	at[63] = 27.1500;
	points[64] = (280, -4220.9844, 0);
	angles[64] = (0, 0, 0);
	at[64] = 27.8500;
	points[65] = (280, -4235, 0);
	angles[65] = (0, 0, 0);
	at[65] = 27.9000;
	points[66] = (280, -4235, 0);
	angles[66] = (0, 0, 0);
	at[66] = 28;
	mover = getEnt("iz_mover3", "targetname");
	if (!isDefined(mover))
		return;
	rider = getEnt("iz_bumper2_touch", "targetname");
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
	points[0] = (-280, -4235, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-280, -4039.0159, 0);
	angles[1] = (0, 0, 0);
	at[1] = 0.3500;
	points[2] = (-266, -4025, 0);
	angles[2] = (0, 0, 0);
	at[2] = 0.4000;
	points[3] = (-14, -4025, 0);
	angles[3] = (0, 0, 0);
	at[3] = 0.8500;
	points[4] = (0, -4010.9841, 0);
	angles[4] = (0, 0, 0);
	at[4] = 0.9000;
	points[5] = (0, -3815, 0);
	angles[5] = (0, 0, 0);
	at[5] = 1.2500;
	points[6] = (280, -3815, 0);
	angles[6] = (0, 0, 0);
	at[6] = 1.7500;
	points[7] = (280, -3675, 0);
	angles[7] = (0, 0, 0);
	at[7] = 2;
	points[8] = (560, -3675, 0);
	angles[8] = (0, 0, 0);
	at[8] = 2.5000;
	points[9] = (560, -3479, 0);
	angles[9] = (0, 0, 0);
	at[9] = 2.8500;
	points[10] = (574, -3465, 0);
	angles[10] = (0, 0, 0);
	at[10] = 2.9000;
	points[11] = (826, -3465, 0);
	angles[11] = (0, 0, 0);
	at[11] = 3.3500;
	points[12] = (840, -3451, 0);
	angles[12] = (0, 0, 0);
	at[12] = 3.4000;
	points[13] = (840, -3115, 0);
	angles[13] = (0, 0, 0);
	at[13] = 4;
	points[14] = (560, -3115, 0);
	angles[14] = (0, 0, 0);
	at[14] = 4.5000;
	points[15] = (560, -2835, 0);
	angles[15] = (0, 0, 0);
	at[15] = 5;
	points[16] = (280, -2835, 0);
	angles[16] = (0, 0, 0);
	at[16] = 5.5000;
	points[17] = (280, -2639, 0);
	angles[17] = (0, 0, 0);
	at[17] = 5.8500;
	points[18] = (266, -2625, 0);
	angles[18] = (0, 0, 0);
	at[18] = 5.9000;
	points[19] = (14, -2625, 0);
	angles[19] = (0, 0, 0);
	at[19] = 6.3500;
	points[20] = (0, -2611, 0);
	angles[20] = (0, 0, 0);
	at[20] = 6.4000;
	points[21] = (0, -2359, 0);
	angles[21] = (0, 0, 0);
	at[21] = 6.8500;
	points[22] = (14, -2345, 0);
	angles[22] = (0, 0, 0);
	at[22] = 6.9000;
	points[23] = (266, -2345, 0);
	angles[23] = (0, 0, 0);
	at[23] = 7.3500;
	points[24] = (280, -2331, 0);
	angles[24] = (0, 0, 0);
	at[24] = 7.4000;
	points[25] = (280, -2135, 0);
	angles[25] = (0, 0, 0);
	at[25] = 7.7500;
	points[26] = (560, -2135, 0);
	angles[26] = (0, 0, 0);
	at[26] = 8.2500;
	points[27] = (560, -1799, 0);
	angles[27] = (0, 0, 0);
	at[27] = 8.8500;
	points[28] = (571.2008, -1785, 0);
	angles[28] = (0, 0, 0);
	at[28] = 8.9000;
	points[29] = (840, -1785, 0);
	angles[29] = (0, 0, 0);
	at[29] = 9.5000;
	points[30] = (840, -1225, 0);
	angles[30] = (0, 0, 0);
	at[30] = 10.5000;
	points[31] = (560, -1225, 0);
	angles[31] = (0, 0, 0);
	at[31] = 11;
	points[32] = (560, -889, 0);
	angles[32] = (0, 0, 0);
	at[32] = 11.6000;
	points[33] = (574, -875, 0);
	angles[33] = (0, 0, 0);
	at[33] = 11.6500;
	points[34] = (826, -875, 0);
	angles[34] = (0, 0, 0);
	at[34] = 12.1000;
	points[35] = (840, -861, 0);
	angles[35] = (0, 0, 0);
	at[35] = 12.1500;
	points[36] = (840, -385, 0);
	angles[36] = (0, 0, 0);
	at[36] = 13;
	points[37] = (560, -385, 0);
	angles[37] = (0, 0, 0);
	at[37] = 13.5000;
	points[38] = (560, -189, 0);
	angles[38] = (0, 0, 0);
	at[38] = 13.8500;
	points[39] = (560, -175, 0);
	angles[39] = (0, 0, 0);
	at[39] = 13.9000;
	points[40] = (560, -175, 0);
	angles[40] = (0, 0, 0);
	at[40] = 14;
	points[41] = (840, -455, 0);
	angles[41] = (0, 0, 0);
	at[41] = 15;
	points[42] = (840, -875, 0);
	angles[42] = (0, 0, 0);
	at[42] = 15.7500;
	points[43] = (560, -875, 0);
	angles[43] = (0, 0, 0);
	at[43] = 16.2500;
	points[44] = (560, -1211, 0);
	angles[44] = (0, 0, 0);
	at[44] = 16.8500;
	points[45] = (574, -1225, 0);
	angles[45] = (0, 0, 0);
	at[45] = 16.9000;
	points[46] = (826, -1225, 0);
	angles[46] = (0, 0, 0);
	at[46] = 17.3500;
	points[47] = (840, -1239, 0);
	angles[47] = (0, 0, 0);
	at[47] = 17.4000;
	points[48] = (840, -1771, 0);
	angles[48] = (0, 0, 0);
	at[48] = 18.3500;
	points[49] = (828.7993, -1785, 0);
	angles[49] = (0, 0, 0);
	at[49] = 18.4000;
	points[50] = (560, -1785, 0);
	angles[50] = (0, 0, 0);
	at[50] = 19;
	points[51] = (560, -2121, 0);
	angles[51] = (0, 0, 0);
	at[51] = 19.6000;
	points[52] = (546, -2135, 0);
	angles[52] = (0, 0, 0);
	at[52] = 19.6500;
	points[53] = (294, -2135, 0);
	angles[53] = (0, 0, 0);
	at[53] = 20.1000;
	points[54] = (280, -2149, 0);
	angles[54] = (0, 0, 0);
	at[54] = 20.1500;
	points[55] = (280, -2345, 0);
	angles[55] = (0, 0, 0);
	at[55] = 20.5000;
	points[56] = (0, -2345, 0);
	angles[56] = (0, 0, 0);
	at[56] = 21;
	points[57] = (0, -2625, 0);
	angles[57] = (0, 0, 0);
	at[57] = 21.5000;
	points[58] = (280, -2625, 0);
	angles[58] = (0, 0, 0);
	at[58] = 22;
	points[59] = (280, -2821, 0);
	angles[59] = (0, 0, 0);
	at[59] = 22.3500;
	points[60] = (294, -2835, 0);
	angles[60] = (0, 0, 0);
	at[60] = 22.4000;
	points[61] = (546, -2835, 0);
	angles[61] = (0, 0, 0);
	at[61] = 22.8500;
	points[62] = (560, -2849, 0);
	angles[62] = (0, 0, 0);
	at[62] = 22.9000;
	points[63] = (560, -3101, 0);
	angles[63] = (0, 0, 0);
	at[63] = 23.3500;
	points[64] = (574, -3115, 0);
	angles[64] = (0, 0, 0);
	at[64] = 23.4000;
	points[65] = (826, -3115, 0);
	angles[65] = (0, 0, 0);
	at[65] = 23.8500;
	points[66] = (840, -3129, 0);
	angles[66] = (0, 0, 0);
	at[66] = 23.9000;
	points[67] = (840, -3465, 0);
	angles[67] = (0, 0, 0);
	at[67] = 24.5000;
	points[68] = (560, -3465, 0);
	angles[68] = (0, 0, 0);
	at[68] = 25;
	points[69] = (560, -3661, 0);
	angles[69] = (0, 0, 0);
	at[69] = 25.3500;
	points[70] = (546, -3675, 0);
	angles[70] = (0, 0, 0);
	at[70] = 25.4000;
	points[71] = (294, -3675, 0);
	angles[71] = (0, 0, 0);
	at[71] = 25.8500;
	points[72] = (280, -3689, 0);
	angles[72] = (0, 0, 0);
	at[72] = 25.9000;
	points[73] = (280, -3801, 0);
	angles[73] = (0, 0, 0);
	at[73] = 26.1000;
	points[74] = (266, -3815, 0);
	angles[74] = (0, 0, 0);
	at[74] = 26.1500;
	points[75] = (14, -3815, 0);
	angles[75] = (0, 0, 0);
	at[75] = 26.6000;
	points[76] = (0, -3829, 0);
	angles[76] = (0, 0, 0);
	at[76] = 26.6500;
	points[77] = (0, -4025, 0);
	angles[77] = (0, 0, 0);
	at[77] = 27;
	points[78] = (-280, -4025, 0);
	angles[78] = (0, 0, 0);
	at[78] = 27.5000;
	points[79] = (-280, -4220.9844, 0);
	angles[79] = (0, 0, 0);
	at[79] = 27.8500;
	points[80] = (-280, -4235, 0);
	angles[80] = (0, 0, 0);
	at[80] = 27.9000;
	points[81] = (-280, -4235, 0);
	angles[81] = (0, 0, 0);
	at[81] = 28;
	mover = getEnt("iz_mover4", "targetname");
	if (!isDefined(mover))
		return;
	rider = getEnt("iz_bumper3_touch", "targetname");
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
	points[0] = (-560, -4235, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-560, -3899, 0);
	angles[1] = (0, 0, 0);
	at[1] = 0.6000;
	points[2] = (-574, -3885, 0);
	angles[2] = (0, 0, 0);
	at[2] = 0.6500;
	points[3] = (-826, -3885, 0);
	angles[3] = (0, 0, 0);
	at[3] = 1.1000;
	points[4] = (-840, -3871, 0);
	angles[4] = (0, 0, 0);
	at[4] = 1.1500;
	points[5] = (-840, -3255, 0);
	angles[5] = (0, 0, 0);
	at[5] = 2.2500;
	points[6] = (-560, -3255, 0);
	angles[6] = (0, 0, 0);
	at[6] = 2.7500;
	points[7] = (-560, -2779, 0);
	angles[7] = (0, 0, 0);
	at[7] = 3.6000;
	points[8] = (-546, -2765, 0);
	angles[8] = (0, 0, 0);
	at[8] = 3.6500;
	points[9] = (-294, -2765, 0);
	angles[9] = (0, 0, 0);
	at[9] = 4.1000;
	points[10] = (-280, -2751, 0);
	angles[10] = (0, 0, 0);
	at[10] = 4.1500;
	points[11] = (-280, -2135, 0);
	angles[11] = (0, 0, 0);
	at[11] = 5.2500;
	points[12] = (0, -2135, 0);
	angles[12] = (0, 0, 0);
	at[12] = 5.7500;
	points[13] = (0, -1799, 0);
	angles[13] = (0, 0, 0);
	at[13] = 6.3500;
	points[14] = (14, -1785, 0);
	angles[14] = (0, 0, 0);
	at[14] = 6.4000;
	points[15] = (266, -1785, 0);
	angles[15] = (0, 0, 0);
	at[15] = 6.8500;
	points[16] = (280, -1771, 0);
	angles[16] = (0, 0, 0);
	at[16] = 6.9000;
	points[17] = (280, -1435, 0);
	angles[17] = (0, 0, 0);
	at[17] = 7.5000;
	points[18] = (560, -1435, 0);
	angles[18] = (0, 0, 0);
	at[18] = 8;
	points[19] = (560, -1239, 0);
	angles[19] = (0, 0, 0);
	at[19] = 8.3500;
	points[20] = (574, -1225, 0);
	angles[20] = (0, 0, 0);
	at[20] = 8.4000;
	points[21] = (826, -1225, 0);
	angles[21] = (0, 0, 0);
	at[21] = 8.8500;
	points[22] = (840, -1211, 0);
	angles[22] = (0, 0, 0);
	at[22] = 8.9000;
	points[23] = (840, -875, 0);
	angles[23] = (0, 0, 0);
	at[23] = 9.5000;
	points[24] = (560, -875, 0);
	angles[24] = (0, 0, 0);
	at[24] = 10;
	points[25] = (560, -679, 0);
	angles[25] = (0, 0, 0);
	at[25] = 10.3500;
	points[26] = (546, -665, 0);
	angles[26] = (0, 0, 0);
	at[26] = 10.4000;
	points[27] = (294, -665, 0);
	angles[27] = (0, 0, 0);
	at[27] = 10.8500;
	points[28] = (280, -651, 0);
	angles[28] = (0, 0, 0);
	at[28] = 10.9000;
	points[29] = (280, -539, 0);
	angles[29] = (0, 0, 0);
	at[29] = 11.1000;
	points[30] = (266, -525, 0);
	angles[30] = (0, 0, 0);
	at[30] = 11.1500;
	points[31] = (14, -525, 0);
	angles[31] = (0, 0, 0);
	at[31] = 11.6000;
	points[32] = (0, -511, 0);
	angles[32] = (0, 0, 0);
	at[32] = 11.6500;
	points[33] = (0, -175, 0);
	angles[33] = (0, 0, 0);
	at[33] = 12.2500;
	points[34] = (0, -175, 0);
	angles[34] = (0, 0, 0);
	at[34] = 15.6000;
	points[35] = (0, -189, 0);
	angles[35] = (0, 0, 0);
	at[35] = 15.6500;
	points[36] = (0, -525, 0);
	angles[36] = (0, 0, 0);
	at[36] = 16.2500;
	points[37] = (280, -525, 0);
	angles[37] = (0, 0, 0);
	at[37] = 16.7500;
	points[38] = (280, -665, 0);
	angles[38] = (0, 0, 0);
	at[38] = 17;
	points[39] = (560, -665, 0);
	angles[39] = (0, 0, 0);
	at[39] = 17.5000;
	points[40] = (560, -861, 0);
	angles[40] = (0, 0, 0);
	at[40] = 17.8500;
	points[41] = (574, -875, 0);
	angles[41] = (0, 0, 0);
	at[41] = 17.9000;
	points[42] = (826, -875, 0);
	angles[42] = (0, 0, 0);
	at[42] = 18.3500;
	points[43] = (840, -889, 0);
	angles[43] = (0, 0, 0);
	at[43] = 18.4000;
	points[44] = (840, -1225, 0);
	angles[44] = (0, 0, 0);
	at[44] = 19;
	points[45] = (560, -1225, 0);
	angles[45] = (0, 0, 0);
	at[45] = 19.5000;
	points[46] = (560, -1421, 0);
	angles[46] = (0, 0, 0);
	at[46] = 19.8500;
	points[47] = (546, -1435, 0);
	angles[47] = (0, 0, 0);
	at[47] = 19.9000;
	points[48] = (294, -1435, 0);
	angles[48] = (0, 0, 0);
	at[48] = 20.3500;
	points[49] = (280, -1449, 0);
	angles[49] = (0, 0, 0);
	at[49] = 20.4000;
	points[50] = (280, -1785, 0);
	angles[50] = (0, 0, 0);
	at[50] = 21;
	points[51] = (0, -1785, 0);
	angles[51] = (0, 0, 0);
	at[51] = 21.5000;
	points[52] = (0, -2121, 0);
	angles[52] = (0, 0, 0);
	at[52] = 22.1000;
	points[53] = (-14, -2135, 0);
	angles[53] = (0, 0, 0);
	at[53] = 22.1500;
	points[54] = (-266, -2135, 0);
	angles[54] = (0, 0, 0);
	at[54] = 22.6000;
	points[55] = (-280, -2149, 0);
	angles[55] = (0, 0, 0);
	at[55] = 22.6500;
	points[56] = (-280, -2765, 0);
	angles[56] = (0, 0, 0);
	at[56] = 23.7500;
	points[57] = (-560, -2765, 0);
	angles[57] = (0, 0, 0);
	at[57] = 24.2500;
	points[58] = (-560, -3241, 0);
	angles[58] = (0, 0, 0);
	at[58] = 25.1000;
	points[59] = (-574, -3255, 0);
	angles[59] = (0, 0, 0);
	at[59] = 25.1500;
	points[60] = (-826, -3255, 0);
	angles[60] = (0, 0, 0);
	at[60] = 25.6000;
	points[61] = (-840, -3269, 0);
	angles[61] = (0, 0, 0);
	at[61] = 25.6500;
	points[62] = (-840, -3885, 0);
	angles[62] = (0, 0, 0);
	at[62] = 26.7500;
	points[63] = (-560, -3885, 0);
	angles[63] = (0, 0, 0);
	at[63] = 27.2500;
	points[64] = (-560, -4220.9844, 0);
	angles[64] = (0, 0, 0);
	at[64] = 27.8500;
	points[65] = (-560, -4235, 0);
	angles[65] = (0, 0, 0);
	at[65] = 27.9000;
	points[66] = (-560, -4235, 0);
	angles[66] = (0, 0, 0);
	at[66] = 28;
	mover = getEnt("iz_mover5", "targetname");
	if (!isDefined(mover))
		return;
	rider = getEnt("iz_bumper4_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover6()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-840, -4235, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-840, -3899, 0);
	angles[1] = (0, 0, 0);
	at[1] = 0.6000;
	points[2] = (-826, -3885, 0);
	angles[2] = (0, 0, 0);
	at[2] = 0.6500;
	points[3] = (-574, -3885, 0);
	angles[3] = (0, 0, 0);
	at[3] = 1.1000;
	points[4] = (-560, -3871, 0);
	angles[4] = (0, 0, 0);
	at[4] = 1.1500;
	points[5] = (-560, -3619, 0);
	angles[5] = (0, 0, 0);
	at[5] = 1.6000;
	points[6] = (-546, -3605, 0);
	angles[6] = (0, 0, 0);
	at[6] = 1.6500;
	points[7] = (-294, -3605, 0);
	angles[7] = (0, 0, 0);
	at[7] = 2.1000;
	points[8] = (-280, -3591, 0);
	angles[8] = (0, 0, 0);
	at[8] = 2.1500;
	points[9] = (-280, -2975, 0);
	angles[9] = (0, 0, 0);
	at[9] = 3.2500;
	points[10] = (0, -2975, 0);
	angles[10] = (0, 0, 0);
	at[10] = 3.7500;
	points[11] = (0, -2639, 0);
	angles[11] = (0, 0, 0);
	at[11] = 4.3500;
	points[12] = (14, -2625, 0);
	angles[12] = (0, 0, 0);
	at[12] = 4.4000;
	points[13] = (266, -2625, 0);
	angles[13] = (0, 0, 0);
	at[13] = 4.8500;
	points[14] = (280, -2611, 0);
	angles[14] = (0, 0, 0);
	at[14] = 4.9000;
	points[15] = (280, -2359, 0);
	angles[15] = (0, 0, 0);
	at[15] = 5.3500;
	points[16] = (266, -2345, 0);
	angles[16] = (0, 0, 0);
	at[16] = 5.4000;
	points[17] = (14, -2345, 0);
	angles[17] = (0, 0, 0);
	at[17] = 5.8500;
	points[18] = (0, -2331, 0);
	angles[18] = (0, 0, 0);
	at[18] = 5.9000;
	points[19] = (0, -2135, 0);
	angles[19] = (0, 0, 0);
	at[19] = 6.2500;
	points[20] = (-280, -2135, 0);
	angles[20] = (0, 0, 0);
	at[20] = 6.7500;
	points[21] = (-280, -1939, 0);
	angles[21] = (0, 0, 0);
	at[21] = 7.1000;
	points[22] = (-294, -1925, 0);
	angles[22] = (0, 0, 0);
	at[22] = 7.1500;
	points[23] = (-546, -1925, 0);
	angles[23] = (0, 0, 0);
	at[23] = 7.6000;
	points[24] = (-560, -1911, 0);
	angles[24] = (0, 0, 0);
	at[24] = 7.6500;
	points[25] = (-560, -1659, 0);
	angles[25] = (0, 0, 0);
	at[25] = 8.1000;
	points[26] = (-574, -1645, 0);
	angles[26] = (0, 0, 0);
	at[26] = 8.1500;
	points[27] = (-826, -1645, 0);
	angles[27] = (0, 0, 0);
	at[27] = 8.6000;
	points[28] = (-840, -1631, 0);
	angles[28] = (0, 0, 0);
	at[28] = 8.6500;
	points[29] = (-840, -1435, 0);
	angles[29] = (0, 0, 0);
	at[29] = 9;
	points[30] = (-560, -1435, 0);
	angles[30] = (0, 0, 0);
	at[30] = 9.5000;
	points[31] = (-560, -1099, 0);
	angles[31] = (0, 0, 0);
	at[31] = 10.1000;
	points[32] = (-546, -1085, 0);
	angles[32] = (0, 0, 0);
	at[32] = 10.1500;
	points[33] = (-294, -1085, 0);
	angles[33] = (0, 0, 0);
	at[33] = 10.6000;
	points[34] = (-280, -1071, 0);
	angles[34] = (0, 0, 0);
	at[34] = 10.6500;
	points[35] = (-280, -875, 0);
	angles[35] = (0, 0, 0);
	at[35] = 11;
	points[36] = (0, -875, 0);
	angles[36] = (0, 0, 0);
	at[36] = 11.5000;
	points[37] = (0, -539, 0);
	angles[37] = (0, 0, 0);
	at[37] = 12.1000;
	points[38] = (14, -525, 0);
	angles[38] = (0, 0, 0);
	at[38] = 12.1500;
	points[39] = (266, -525, 0);
	angles[39] = (0, 0, 0);
	at[39] = 12.6000;
	points[40] = (280, -511, 0);
	angles[40] = (0, 0, 0);
	at[40] = 12.6500;
	points[41] = (280, -175, 0);
	angles[41] = (0, 0, 0);
	at[41] = 13.2500;
	points[42] = (280, -175, 0);
	angles[42] = (0, 0, 0);
	at[42] = 14;
	points[43] = (280, -385, 0);
	angles[43] = (0, 0, 0);
	at[43] = 15;
	points[44] = (280, -525, 0);
	angles[44] = (0, 0, 0);
	at[44] = 15.2500;
	points[45] = (0, -525, 0);
	angles[45] = (0, 0, 0);
	at[45] = 15.7500;
	points[46] = (0, -861, 0);
	angles[46] = (0, 0, 0);
	at[46] = 16.3500;
	points[47] = (-14, -875, 0);
	angles[47] = (0, 0, 0);
	at[47] = 16.4000;
	points[48] = (-266, -875, 0);
	angles[48] = (0, 0, 0);
	at[48] = 16.8500;
	points[49] = (-280, -889, 0);
	angles[49] = (0, 0, 0);
	at[49] = 16.9000;
	points[50] = (-280, -1085, 0);
	angles[50] = (0, 0, 0);
	at[50] = 17.2500;
	points[51] = (-560, -1085, 0);
	angles[51] = (0, 0, 0);
	at[51] = 17.7500;
	points[52] = (-560, -1421, 0);
	angles[52] = (0, 0, 0);
	at[52] = 18.3500;
	points[53] = (-574, -1435, 0);
	angles[53] = (0, 0, 0);
	at[53] = 18.4000;
	points[54] = (-826, -1435, 0);
	angles[54] = (0, 0, 0);
	at[54] = 18.8500;
	points[55] = (-840, -1449, 0);
	angles[55] = (0, 0, 0);
	at[55] = 18.9000;
	points[56] = (-840, -1645, 0);
	angles[56] = (0, 0, 0);
	at[56] = 19.2500;
	points[57] = (-560, -1645, 0);
	angles[57] = (0, 0, 0);
	at[57] = 19.7500;
	points[58] = (-560, -1925, 0);
	angles[58] = (0, 0, 0);
	at[58] = 20.2500;
	points[59] = (-280, -1925, 0);
	angles[59] = (0, 0, 0);
	at[59] = 20.7500;
	points[60] = (-280, -2121, 0);
	angles[60] = (0, 0, 0);
	at[60] = 21.1000;
	points[61] = (-266, -2135, 0);
	angles[61] = (0, 0, 0);
	at[61] = 21.1500;
	points[62] = (-14, -2135, 0);
	angles[62] = (0, 0, 0);
	at[62] = 21.6000;
	points[63] = (0, -2149, 0);
	angles[63] = (0, 0, 0);
	at[63] = 21.6500;
	points[64] = (0, -2345, 0);
	angles[64] = (0, 0, 0);
	at[64] = 22;
	points[65] = (280, -2345, 0);
	angles[65] = (0, 0, 0);
	at[65] = 22.5000;
	points[66] = (280, -2625, 0);
	angles[66] = (0, 0, 0);
	at[66] = 23;
	points[67] = (0, -2625, 0);
	angles[67] = (0, 0, 0);
	at[67] = 23.5000;
	points[68] = (0, -2961, 0);
	angles[68] = (0, 0, 0);
	at[68] = 24.1000;
	points[69] = (-14, -2975, 0);
	angles[69] = (0, 0, 0);
	at[69] = 24.1500;
	points[70] = (-266, -2975, 0);
	angles[70] = (0, 0, 0);
	at[70] = 24.6000;
	points[71] = (-280, -2989, 0);
	angles[71] = (0, 0, 0);
	at[71] = 24.6500;
	points[72] = (-280, -3605, 0);
	angles[72] = (0, 0, 0);
	at[72] = 25.7500;
	points[73] = (-560, -3605, 0);
	angles[73] = (0, 0, 0);
	at[73] = 26.2500;
	points[74] = (-560, -3885, 0);
	angles[74] = (0, 0, 0);
	at[74] = 26.7500;
	points[75] = (-840, -3885, 0);
	angles[75] = (0, 0, 0);
	at[75] = 27.2500;
	points[76] = (-840, -4220.9844, 0);
	angles[76] = (0, 0, 0);
	at[76] = 27.8500;
	points[77] = (-840, -4235, 0);
	angles[77] = (0, 0, 0);
	at[77] = 27.9000;
	points[78] = (-840, -4235, 0);
	angles[78] = (0, 0, 0);
	at[78] = 28;
	mover = getEnt("iz_mover6", "targetname");
	if (!isDefined(mover))
		return;
	rider = getEnt("iz_bumper5_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover7()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, -4235, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, -4039.0159, 0);
	angles[1] = (0, 0, 0);
	at[1] = 0.3500;
	points[2] = (-14, -4025, 0);
	angles[2] = (0, 0, 0);
	at[2] = 0.4000;
	points[3] = (-266, -4025, 0);
	angles[3] = (0, 0, 0);
	at[3] = 0.8500;
	points[4] = (-280, -4010.9841, 0);
	angles[4] = (0, 0, 0);
	at[4] = 0.9000;
	points[5] = (-280, -3619, 0);
	angles[5] = (0, 0, 0);
	at[5] = 1.6000;
	points[6] = (-294, -3605, 0);
	angles[6] = (0, 0, 0);
	at[6] = 1.6500;
	points[7] = (-546, -3605, 0);
	angles[7] = (0, 0, 0);
	at[7] = 2.1000;
	points[8] = (-560, -3591, 0);
	angles[8] = (0, 0, 0);
	at[8] = 2.1500;
	points[9] = (-560, -3255, 0);
	angles[9] = (0, 0, 0);
	at[9] = 2.7500;
	points[10] = (-840, -3255, 0);
	angles[10] = (0, 0, 0);
	at[10] = 3.2500;
	points[11] = (-840, -2359, 0);
	angles[11] = (0, 0, 0);
	at[11] = 4.8500;
	points[12] = (-826, -2345, 0);
	angles[12] = (0, 0, 0);
	at[12] = 4.9000;
	points[13] = (-574, -2345, 0);
	angles[13] = (0, 0, 0);
	at[13] = 5.3500;
	points[14] = (-560, -2331, 0);
	angles[14] = (0, 0, 0);
	at[14] = 5.4000;
	points[15] = (-560, -1939, 0);
	angles[15] = (0, 0, 0);
	at[15] = 6.1000;
	points[16] = (-546, -1925, 0);
	angles[16] = (0, 0, 0);
	at[16] = 6.1500;
	points[17] = (-294, -1925, 0);
	angles[17] = (0, 0, 0);
	at[17] = 6.6000;
	points[18] = (-280, -1911, 0);
	angles[18] = (0, 0, 0);
	at[18] = 6.6500;
	points[19] = (-280, -1295, 0);
	angles[19] = (0, 0, 0);
	at[19] = 7.7500;
	points[20] = (0, -1295, 0);
	angles[20] = (0, 0, 0);
	at[20] = 8.2500;
	points[21] = (0, -1099, 0);
	angles[21] = (0, 0, 0);
	at[21] = 8.6000;
	points[22] = (14, -1085, 0);
	angles[22] = (0, 0, 0);
	at[22] = 8.6500;
	points[23] = (266, -1085, 0);
	angles[23] = (0, 0, 0);
	at[23] = 9.1000;
	points[24] = (280, -1071, 0);
	angles[24] = (0, 0, 0);
	at[24] = 9.1500;
	points[25] = (280, -679, 0);
	angles[25] = (0, 0, 0);
	at[25] = 9.8500;
	points[26] = (294, -665, 0);
	angles[26] = (0, 0, 0);
	at[26] = 9.9000;
	points[27] = (546, -665, 0);
	angles[27] = (0, 0, 0);
	at[27] = 10.3500;
	points[28] = (560, -651, 0);
	angles[28] = (0, 0, 0);
	at[28] = 10.4000;
	points[29] = (560, -399, 0);
	angles[29] = (0, 0, 0);
	at[29] = 10.8500;
	points[30] = (574, -385, 0);
	angles[30] = (0, 0, 0);
	at[30] = 10.9000;
	points[31] = (826, -385, 0);
	angles[31] = (0, 0, 0);
	at[31] = 11.3500;
	points[32] = (840, -371, 0);
	angles[32] = (0, 0, 0);
	at[32] = 11.4000;
	points[33] = (840, -175, 0);
	angles[33] = (0, 0, 0);
	at[33] = 11.7500;
	points[34] = (840, -175, 0);
	angles[34] = (0, 0, 0);
	at[34] = 16.1000;
	points[35] = (840, -189, 0);
	angles[35] = (0, 0, 0);
	at[35] = 16.1500;
	points[36] = (840, -385, 0);
	angles[36] = (0, 0, 0);
	at[36] = 16.5000;
	points[37] = (560, -385, 0);
	angles[37] = (0, 0, 0);
	at[37] = 17;
	points[38] = (560, -665, 0);
	angles[38] = (0, 0, 0);
	at[38] = 17.5000;
	points[39] = (280, -665, 0);
	angles[39] = (0, 0, 0);
	at[39] = 18;
	points[40] = (280, -1085, 0);
	angles[40] = (0, 0, 0);
	at[40] = 18.7500;
	points[41] = (0, -1085, 0);
	angles[41] = (0, 0, 0);
	at[41] = 19.2500;
	points[42] = (0, -1281, 0);
	angles[42] = (0, 0, 0);
	at[42] = 19.6000;
	points[43] = (-14, -1295, 0);
	angles[43] = (0, 0, 0);
	at[43] = 19.6500;
	points[44] = (-266, -1295, 0);
	angles[44] = (0, 0, 0);
	at[44] = 20.1000;
	points[45] = (-280, -1309, 0);
	angles[45] = (0, 0, 0);
	at[45] = 20.1500;
	points[46] = (-280, -1925, 0);
	angles[46] = (0, 0, 0);
	at[46] = 21.2500;
	points[47] = (-560, -1925, 0);
	angles[47] = (0, 0, 0);
	at[47] = 21.7500;
	points[48] = (-560, -2345, 0);
	angles[48] = (0, 0, 0);
	at[48] = 22.5000;
	points[49] = (-840, -2345, 0);
	angles[49] = (0, 0, 0);
	at[49] = 23;
	points[50] = (-840, -3241, 0);
	angles[50] = (0, 0, 0);
	at[50] = 24.6000;
	points[51] = (-826, -3255, 0);
	angles[51] = (0, 0, 0);
	at[51] = 24.6500;
	points[52] = (-574, -3255, 0);
	angles[52] = (0, 0, 0);
	at[52] = 25.1000;
	points[53] = (-560, -3269, 0);
	angles[53] = (0, 0, 0);
	at[53] = 25.1500;
	points[54] = (-560, -3605, 0);
	angles[54] = (0, 0, 0);
	at[54] = 25.7500;
	points[55] = (-280, -3605, 0);
	angles[55] = (0, 0, 0);
	at[55] = 26.2500;
	points[56] = (-280, -4025, 0);
	angles[56] = (0, 0, 0);
	at[56] = 27;
	points[57] = (0, -4025, 0);
	angles[57] = (0, 0, 0);
	at[57] = 27.5000;
	points[58] = (0, -4220.9844, 0);
	angles[58] = (0, 0, 0);
	at[58] = 27.8500;
	points[59] = (0, -4235, 0);
	angles[59] = (0, 0, 0);
	at[59] = 27.9000;
	points[60] = (0, -4235, 0);
	angles[60] = (0, 0, 0);
	at[60] = 28;
	mover = getEnt("iz_mover7", "targetname");
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
