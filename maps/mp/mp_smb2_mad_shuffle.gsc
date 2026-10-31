main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_smb2_mad_shuffle", 0);

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
	ambientPlay("iz_0_yuenchi", 2);
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
	thread iz_button("iz_button1", 1, 0);
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
	points[0] = (6384.0161, -5460, -35);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (6384.0161, -5460, -33.7277);
	angles[1] = (0, 0, 0);
	at[1] = 0.0500;
	points[2] = (6384.0161, -5460, -30.1974);
	angles[2] = (0, 0, 0);
	at[2] = 0.1000;
	points[3] = (6384.0161, -5460, -24.8394);
	angles[3] = (0, 0, 0);
	at[3] = 0.1500;
	points[4] = (6384.0161, -5460, -10.3600);
	angles[4] = (0, 0, 0);
	at[4] = 0.2500;
	points[5] = (6384.0161, -5460, 14.3158);
	angles[5] = (0, 0, 0);
	at[5] = 0.4000;
	points[6] = (6384.0161, -5460, 21.6093);
	angles[6] = (0, 0, 0);
	at[6] = 0.4500;
	points[7] = (6384.0161, -5460, 27.7200);
	angles[7] = (0, 0, 0);
	at[7] = 0.5000;
	points[8] = (6384.0161, -5460, 32.2179);
	angles[8] = (0, 0, 0);
	at[8] = 0.5500;
	points[9] = (6384.0161, -5460, 34.6730);
	angles[9] = (0, 0, 0);
	at[9] = 0.6000;
	points[10] = (6384.0161, -5460.6694, 35);
	angles[10] = (0, 0, 0);
	at[10] = 0.6500;
	points[11] = (6384.0161, -5465.5513, 35);
	angles[11] = (0, 0, 0);
	at[11] = 0.7000;
	points[12] = (6384.0161, -5474.5669, 35);
	angles[12] = (0, 0, 0);
	at[12] = 0.7500;
	points[13] = (6384.0161, -5486.7715, 35);
	angles[13] = (0, 0, 0);
	at[13] = 0.8000;
	points[14] = (6384.0161, -5501.3779, 35);
	angles[14] = (0, 0, 0);
	at[14] = 0.8500;
	points[15] = (6384.0161, -5550.7090, 35);
	angles[15] = (0, 0, 0);
	at[15] = 1;
	points[16] = (6384.0161, -5566.1812, 35);
	angles[16] = (0, 0, 0);
	at[16] = 1.0500;
	points[17] = (6384.0161, -5579.6851, 35);
	angles[17] = (0, 0, 0);
	at[17] = 1.1000;
	points[18] = (6384.0161, -5590.3940, 35);
	angles[18] = (0, 0, 0);
	at[18] = 1.1500;
	points[19] = (6384.0161, -5597.4409, 35);
	angles[19] = (0, 0, 0);
	at[19] = 1.2000;
	points[20] = (6384.0161, -5600, 35);
	angles[20] = (0, 0, 0);
	at[20] = 1.2500;
	points[21] = (6384.0161, -5600, 33.7277);
	angles[21] = (0, 0, 0);
	at[21] = 1.3000;
	points[22] = (6384.0161, -5600, 30.1974);
	angles[22] = (0, 0, 0);
	at[22] = 1.3500;
	points[23] = (6384.0161, -5600, 24.8394);
	angles[23] = (0, 0, 0);
	at[23] = 1.4000;
	points[24] = (6384.0161, -5600, 10.3600);
	angles[24] = (0, 0, 0);
	at[24] = 1.5000;
	points[25] = (6384.0161, -5600, -14.3158);
	angles[25] = (0, 0, 0);
	at[25] = 1.6500;
	points[26] = (6384.0161, -5600, -21.6093);
	angles[26] = (0, 0, 0);
	at[26] = 1.7000;
	points[27] = (6384.0161, -5600, -27.7200);
	angles[27] = (0, 0, 0);
	at[27] = 1.7500;
	points[28] = (6384.0161, -5600, -32.2179);
	angles[28] = (0, 0, 0);
	at[28] = 1.8000;
	points[29] = (6384.0161, -5600, -34.6730);
	angles[29] = (0, 0, 0);
	at[29] = 1.8500;
	points[30] = (6384.0161, -5599.3311, -35);
	angles[30] = (0, 0, 0);
	at[30] = 1.9000;
	points[31] = (6384.0161, -5594.4487, -35);
	angles[31] = (0, 0, 0);
	at[31] = 1.9500;
	points[32] = (6384.0161, -5585.4331, -35);
	angles[32] = (0, 0, 0);
	at[32] = 2;
	points[33] = (6384.0161, -5573.2285, -35);
	angles[33] = (0, 0, 0);
	at[33] = 2.0500;
	points[34] = (6384.0161, -5558.6221, -35);
	angles[34] = (0, 0, 0);
	at[34] = 2.1000;
	points[35] = (6384.0161, -5509.2915, -35);
	angles[35] = (0, 0, 0);
	at[35] = 2.2500;
	points[36] = (6384.0161, -5493.8188, -35);
	angles[36] = (0, 0, 0);
	at[36] = 2.3000;
	points[37] = (6384.0161, -5480.3149, -35);
	angles[37] = (0, 0, 0);
	at[37] = 2.3500;
	points[38] = (6384.0161, -5469.6060, -35);
	angles[38] = (0, 0, 0);
	at[38] = 2.4000;
	points[39] = (6384.0161, -5462.5591, -35);
	angles[39] = (0, 0, 0);
	at[39] = 2.4500;
	points[40] = (6384.0161, -5460, -35);
	angles[40] = (0, 0, 0);
	at[40] = 2.5000;
	points[41] = (6384.0161, -5460, -33.7277);
	angles[41] = (0, 0, 0);
	at[41] = 2.5500;
	points[42] = (6384.0161, -5460, -30.1974);
	angles[42] = (0, 0, 0);
	at[42] = 2.6000;
	points[43] = (6384.0161, -5460, -24.8394);
	angles[43] = (0, 0, 0);
	at[43] = 2.6500;
	points[44] = (6384.0161, -5460, -10.3600);
	angles[44] = (0, 0, 0);
	at[44] = 2.7500;
	points[45] = (6384.0161, -5460, 14.3158);
	angles[45] = (0, 0, 0);
	at[45] = 2.9000;
	points[46] = (6384.0161, -5460, 21.6093);
	angles[46] = (0, 0, 0);
	at[46] = 2.9500;
	points[47] = (6384.0161, -5460, 27.7200);
	angles[47] = (0, 0, 0);
	at[47] = 3;
	points[48] = (6384.0161, -5460, 32.2179);
	angles[48] = (0, 0, 0);
	at[48] = 3.0500;
	points[49] = (6384.0161, -5460, 34.6730);
	angles[49] = (0, 0, 0);
	at[49] = 3.1000;
	points[50] = (6384.0161, -5460.6694, 35);
	angles[50] = (0, 0, 0);
	at[50] = 3.1500;
	points[51] = (6384.0161, -5465.5513, 35);
	angles[51] = (0, 0, 0);
	at[51] = 3.2000;
	points[52] = (6384.0161, -5474.5669, 35);
	angles[52] = (0, 0, 0);
	at[52] = 3.2500;
	points[53] = (6384.0161, -5486.7715, 35);
	angles[53] = (0, 0, 0);
	at[53] = 3.3000;
	points[54] = (6384.0161, -5501.3779, 35);
	angles[54] = (0, 0, 0);
	at[54] = 3.3500;
	points[55] = (6384.0161, -5550.7090, 35);
	angles[55] = (0, 0, 0);
	at[55] = 3.5000;
	points[56] = (6384.0161, -5566.1812, 35);
	angles[56] = (0, 0, 0);
	at[56] = 3.5500;
	points[57] = (6384.0161, -5579.6851, 35);
	angles[57] = (0, 0, 0);
	at[57] = 3.6000;
	points[58] = (6384.0161, -5590.3940, 35);
	angles[58] = (0, 0, 0);
	at[58] = 3.6500;
	points[59] = (6384.0161, -5597.4409, 35);
	angles[59] = (0, 0, 0);
	at[59] = 3.7000;
	points[60] = (6384.0161, -5600, 35);
	angles[60] = (0, 0, 0);
	at[60] = 3.7500;
	points[61] = (6384.0161, -5600, 33.7277);
	angles[61] = (0, 0, 0);
	at[61] = 3.8000;
	points[62] = (6384.0161, -5600, 30.1974);
	angles[62] = (0, 0, 0);
	at[62] = 3.8500;
	points[63] = (6384.0161, -5600, 24.8394);
	angles[63] = (0, 0, 0);
	at[63] = 3.9000;
	points[64] = (6384.0161, -5600, 10.3600);
	angles[64] = (0, 0, 0);
	at[64] = 4;
	points[65] = (6384.0161, -5600, -14.3158);
	angles[65] = (0, 0, 0);
	at[65] = 4.1500;
	points[66] = (6384.0161, -5600, -21.6093);
	angles[66] = (0, 0, 0);
	at[66] = 4.2000;
	points[67] = (6384.0161, -5600, -27.7200);
	angles[67] = (0, 0, 0);
	at[67] = 4.2500;
	points[68] = (6384.0161, -5600, -32.2179);
	angles[68] = (0, 0, 0);
	at[68] = 4.3000;
	points[69] = (6384.0161, -5600, -34.6730);
	angles[69] = (0, 0, 0);
	at[69] = 4.3500;
	points[70] = (6384.0161, -5599.3311, -35);
	angles[70] = (0, 0, 0);
	at[70] = 4.4000;
	points[71] = (6384.0161, -5594.4487, -35);
	angles[71] = (0, 0, 0);
	at[71] = 4.4500;
	points[72] = (6384.0161, -5585.4331, -35);
	angles[72] = (0, 0, 0);
	at[72] = 4.5000;
	points[73] = (6384.0161, -5573.2285, -35);
	angles[73] = (0, 0, 0);
	at[73] = 4.5500;
	points[74] = (6384.0161, -5558.6221, -35);
	angles[74] = (0, 0, 0);
	at[74] = 4.6000;
	points[75] = (6384.0161, -5509.2915, -35);
	angles[75] = (0, 0, 0);
	at[75] = 4.7500;
	points[76] = (6384.0161, -5493.8188, -35);
	angles[76] = (0, 0, 0);
	at[76] = 4.8000;
	points[77] = (6384.0161, -5480.3149, -35);
	angles[77] = (0, 0, 0);
	at[77] = 4.8500;
	points[78] = (6384.0161, -5469.6060, -35);
	angles[78] = (0, 0, 0);
	at[78] = 4.9000;
	points[79] = (6384.0161, -5462.5591, -35);
	angles[79] = (0, 0, 0);
	at[79] = 4.9500;
	points[80] = (6384.0161, -5460, -35);
	angles[80] = (0, 0, 0);
	at[80] = 5;
	points[81] = (6384.0161, -5462.5591, -35);
	angles[81] = (0, 0, 0);
	at[81] = 5.0500;
	points[82] = (6384.0161, -5469.6060, -35);
	angles[82] = (0, 0, 0);
	at[82] = 5.1000;
	points[83] = (6384.0161, -5480.3149, -35);
	angles[83] = (0, 0, 0);
	at[83] = 5.1500;
	points[84] = (6384.0161, -5493.8188, -35);
	angles[84] = (0, 0, 0);
	at[84] = 5.2000;
	points[85] = (6384.0161, -5509.2915, -35);
	angles[85] = (0, 0, 0);
	at[85] = 5.2500;
	points[86] = (6384.0161, -5558.6221, -35);
	angles[86] = (0, 0, 0);
	at[86] = 5.4000;
	points[87] = (6384.0161, -5573.2285, -35);
	angles[87] = (0, 0, 0);
	at[87] = 5.4500;
	points[88] = (6384.0161, -5585.4331, -35);
	angles[88] = (0, 0, 0);
	at[88] = 5.5000;
	points[89] = (6384.0161, -5594.4487, -35);
	angles[89] = (0, 0, 0);
	at[89] = 5.5500;
	points[90] = (6384.0161, -5599.3311, -35);
	angles[90] = (0, 0, 0);
	at[90] = 5.6000;
	points[91] = (6384.0161, -5600, -34.6730);
	angles[91] = (0, 0, 0);
	at[91] = 5.6500;
	points[92] = (6384.0161, -5600, -32.2179);
	angles[92] = (0, 0, 0);
	at[92] = 5.7000;
	points[93] = (6384.0161, -5600, -27.7200);
	angles[93] = (0, 0, 0);
	at[93] = 5.7500;
	points[94] = (6384.0161, -5600, -21.6093);
	angles[94] = (0, 0, 0);
	at[94] = 5.8000;
	points[95] = (6384.0161, -5600, -14.3158);
	angles[95] = (0, 0, 0);
	at[95] = 5.8500;
	points[96] = (6384.0161, -5600, 10.3600);
	angles[96] = (0, 0, 0);
	at[96] = 6;
	points[97] = (6384.0161, -5600, 24.8394);
	angles[97] = (0, 0, 0);
	at[97] = 6.1000;
	points[98] = (6384.0161, -5600, 30.1974);
	angles[98] = (0, 0, 0);
	at[98] = 6.1500;
	points[99] = (6384.0161, -5600, 33.7277);
	angles[99] = (0, 0, 0);
	at[99] = 6.2000;
	points[100] = (6384.0161, -5600, 35);
	angles[100] = (0, 0, 0);
	at[100] = 6.2500;
	points[101] = (6384.0161, -5597.4409, 35);
	angles[101] = (0, 0, 0);
	at[101] = 6.3000;
	points[102] = (6384.0161, -5590.3940, 35);
	angles[102] = (0, 0, 0);
	at[102] = 6.3500;
	points[103] = (6384.0161, -5579.6851, 35);
	angles[103] = (0, 0, 0);
	at[103] = 6.4000;
	points[104] = (6384.0161, -5566.1812, 35);
	angles[104] = (0, 0, 0);
	at[104] = 6.4500;
	points[105] = (6384.0161, -5550.7090, 35);
	angles[105] = (0, 0, 0);
	at[105] = 6.5000;
	points[106] = (6384.0161, -5501.3779, 35);
	angles[106] = (0, 0, 0);
	at[106] = 6.6500;
	points[107] = (6384.0161, -5486.7715, 35);
	angles[107] = (0, 0, 0);
	at[107] = 6.7000;
	points[108] = (6384.0161, -5474.5669, 35);
	angles[108] = (0, 0, 0);
	at[108] = 6.7500;
	points[109] = (6384.0161, -5465.5513, 35);
	angles[109] = (0, 0, 0);
	at[109] = 6.8000;
	points[110] = (6384.0161, -5460.6694, 35);
	angles[110] = (0, 0, 0);
	at[110] = 6.8500;
	points[111] = (6384.0161, -5460, 34.6730);
	angles[111] = (0, 0, 0);
	at[111] = 6.9000;
	points[112] = (6384.0161, -5460, 32.2179);
	angles[112] = (0, 0, 0);
	at[112] = 6.9500;
	points[113] = (6384.0161, -5460, 27.7200);
	angles[113] = (0, 0, 0);
	at[113] = 7;
	points[114] = (6384.0161, -5460, 21.6093);
	angles[114] = (0, 0, 0);
	at[114] = 7.0500;
	points[115] = (6384.0161, -5460, 14.3158);
	angles[115] = (0, 0, 0);
	at[115] = 7.1000;
	points[116] = (6384.0161, -5460, -18.0835);
	angles[116] = (0, 0, 0);
	at[116] = 7.3000;
	points[117] = (6384.0161, -5460, -24.8394);
	angles[117] = (0, 0, 0);
	at[117] = 7.3500;
	points[118] = (6384.0161, -5460, -30.1974);
	angles[118] = (0, 0, 0);
	at[118] = 7.4000;
	points[119] = (6384.0161, -5460, -33.7277);
	angles[119] = (0, 0, 0);
	at[119] = 7.4500;
	points[120] = (6384.0161, -5460, -35);
	angles[120] = (0, 0, 0);
	at[120] = 7.5000;
	points[121] = (6384.0161, -5462.5591, -35);
	angles[121] = (0, 0, 0);
	at[121] = 7.5500;
	points[122] = (6384.0161, -5469.6060, -35);
	angles[122] = (0, 0, 0);
	at[122] = 7.6000;
	points[123] = (6384.0161, -5480.3149, -35);
	angles[123] = (0, 0, 0);
	at[123] = 7.6500;
	points[124] = (6384.0161, -5493.8188, -35);
	angles[124] = (0, 0, 0);
	at[124] = 7.7000;
	points[125] = (6384.0161, -5509.2915, -35);
	angles[125] = (0, 0, 0);
	at[125] = 7.7500;
	points[126] = (6384.0161, -5558.6221, -35);
	angles[126] = (0, 0, 0);
	at[126] = 7.9000;
	points[127] = (6384.0161, -5573.2285, -35);
	angles[127] = (0, 0, 0);
	at[127] = 7.9500;
	points[128] = (6384.0161, -5585.4331, -35);
	angles[128] = (0, 0, 0);
	at[128] = 8;
	points[129] = (6384.0161, -5594.4487, -35);
	angles[129] = (0, 0, 0);
	at[129] = 8.0500;
	points[130] = (6384.0161, -5599.3311, -35);
	angles[130] = (0, 0, 0);
	at[130] = 8.1000;
	points[131] = (6384.0161, -5600, -34.6730);
	angles[131] = (0, 0, 0);
	at[131] = 8.1500;
	points[132] = (6384.0161, -5600, -32.2179);
	angles[132] = (0, 0, 0);
	at[132] = 8.2000;
	points[133] = (6384.0161, -5600, -27.7200);
	angles[133] = (0, 0, 0);
	at[133] = 8.2500;
	points[134] = (6384.0161, -5600, -21.6093);
	angles[134] = (0, 0, 0);
	at[134] = 8.3000;
	points[135] = (6384.0161, -5600, -14.3158);
	angles[135] = (0, 0, 0);
	at[135] = 8.3500;
	points[136] = (6384.0161, -5600, 10.3600);
	angles[136] = (0, 0, 0);
	at[136] = 8.5000;
	points[137] = (6384.0161, -5600, 24.8395);
	angles[137] = (0, 0, 0);
	at[137] = 8.6000;
	points[138] = (6384.0161, -5600, 30.1974);
	angles[138] = (0, 0, 0);
	at[138] = 8.6500;
	points[139] = (6384.0161, -5600, 33.7277);
	angles[139] = (0, 0, 0);
	at[139] = 8.7000;
	points[140] = (6384.0161, -5600, 35);
	angles[140] = (0, 0, 0);
	at[140] = 8.7500;
	points[141] = (6384.0161, -5597.4409, 35);
	angles[141] = (0, 0, 0);
	at[141] = 8.8000;
	points[142] = (6384.0161, -5590.3940, 35);
	angles[142] = (0, 0, 0);
	at[142] = 8.8500;
	points[143] = (6384.0161, -5579.6851, 35);
	angles[143] = (0, 0, 0);
	at[143] = 8.9000;
	points[144] = (6384.0161, -5566.1812, 35);
	angles[144] = (0, 0, 0);
	at[144] = 8.9500;
	points[145] = (6384.0161, -5550.7090, 35);
	angles[145] = (0, 0, 0);
	at[145] = 9;
	points[146] = (6384.0161, -5501.3779, 35);
	angles[146] = (0, 0, 0);
	at[146] = 9.1500;
	points[147] = (6384.0161, -5486.7715, 35);
	angles[147] = (0, 0, 0);
	at[147] = 9.2000;
	points[148] = (6384.0161, -5474.5669, 35);
	angles[148] = (0, 0, 0);
	at[148] = 9.2500;
	points[149] = (6384.0161, -5465.5513, 35);
	angles[149] = (0, 0, 0);
	at[149] = 9.3000;
	points[150] = (6384.0161, -5460.6694, 35);
	angles[150] = (0, 0, 0);
	at[150] = 9.3500;
	points[151] = (6384.0161, -5460, 34.6730);
	angles[151] = (0, 0, 0);
	at[151] = 9.4000;
	points[152] = (6384.0161, -5460, 32.2179);
	angles[152] = (0, 0, 0);
	at[152] = 9.4500;
	points[153] = (6384.0161, -5460, 27.7200);
	angles[153] = (0, 0, 0);
	at[153] = 9.5000;
	points[154] = (6384.0161, -5460, 21.6093);
	angles[154] = (0, 0, 0);
	at[154] = 9.5500;
	points[155] = (6384.0161, -5460, 14.3158);
	angles[155] = (0, 0, 0);
	at[155] = 9.6000;
	points[156] = (6384.0161, -5460, -10.3600);
	angles[156] = (0, 0, 0);
	at[156] = 9.7500;
	points[157] = (6384.0161, -5460, -24.8395);
	angles[157] = (0, 0, 0);
	at[157] = 9.8500;
	points[158] = (6384.0161, -5460, -30.1974);
	angles[158] = (0, 0, 0);
	at[158] = 9.9000;
	points[159] = (6384.0161, -5460, -33.7277);
	angles[159] = (0, 0, 0);
	at[159] = 9.9500;
	points[160] = (6384.0161, -5460, -35);
	angles[160] = (0, 0, 0);
	at[160] = 10;
	mover = getEnt("iz_mover0", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_play(points, angles, at, false, 1, 0);
}

iz_mover1()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (6384.0161, -5600, 35);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (6384.0161, -5600, 33.7277);
	angles[1] = (0, 0, 0);
	at[1] = 0.0500;
	points[2] = (6384.0161, -5600, 30.1974);
	angles[2] = (0, 0, 0);
	at[2] = 0.1000;
	points[3] = (6384.0161, -5600, 24.8394);
	angles[3] = (0, 0, 0);
	at[3] = 0.1500;
	points[4] = (6384.0161, -5600, 10.3600);
	angles[4] = (0, 0, 0);
	at[4] = 0.2500;
	points[5] = (6384.0161, -5600, -14.3158);
	angles[5] = (0, 0, 0);
	at[5] = 0.4000;
	points[6] = (6384.0161, -5600, -21.6093);
	angles[6] = (0, 0, 0);
	at[6] = 0.4500;
	points[7] = (6384.0161, -5600, -27.7200);
	angles[7] = (0, 0, 0);
	at[7] = 0.5000;
	points[8] = (6384.0161, -5600, -32.2179);
	angles[8] = (0, 0, 0);
	at[8] = 0.5500;
	points[9] = (6384.0161, -5600, -34.6730);
	angles[9] = (0, 0, 0);
	at[9] = 0.6000;
	points[10] = (6384.0161, -5599.3311, -35);
	angles[10] = (0, 0, 0);
	at[10] = 0.6500;
	points[11] = (6384.0161, -5594.4487, -35);
	angles[11] = (0, 0, 0);
	at[11] = 0.7000;
	points[12] = (6384.0161, -5585.4331, -35);
	angles[12] = (0, 0, 0);
	at[12] = 0.7500;
	points[13] = (6384.0161, -5573.2285, -35);
	angles[13] = (0, 0, 0);
	at[13] = 0.8000;
	points[14] = (6384.0161, -5558.6221, -35);
	angles[14] = (0, 0, 0);
	at[14] = 0.8500;
	points[15] = (6384.0161, -5509.2915, -35);
	angles[15] = (0, 0, 0);
	at[15] = 1;
	points[16] = (6384.0161, -5493.8188, -35);
	angles[16] = (0, 0, 0);
	at[16] = 1.0500;
	points[17] = (6384.0161, -5480.3149, -35);
	angles[17] = (0, 0, 0);
	at[17] = 1.1000;
	points[18] = (6384.0161, -5469.6060, -35);
	angles[18] = (0, 0, 0);
	at[18] = 1.1500;
	points[19] = (6384.0161, -5462.5591, -35);
	angles[19] = (0, 0, 0);
	at[19] = 1.2000;
	points[20] = (6384.0161, -5460, -35);
	angles[20] = (0, 0, 0);
	at[20] = 1.2500;
	points[21] = (6384.0161, -5460, -33.7277);
	angles[21] = (0, 0, 0);
	at[21] = 1.3000;
	points[22] = (6384.0161, -5460, -30.1974);
	angles[22] = (0, 0, 0);
	at[22] = 1.3500;
	points[23] = (6384.0161, -5460, -24.8394);
	angles[23] = (0, 0, 0);
	at[23] = 1.4000;
	points[24] = (6384.0161, -5460, -10.3600);
	angles[24] = (0, 0, 0);
	at[24] = 1.5000;
	points[25] = (6384.0161, -5460, 14.3158);
	angles[25] = (0, 0, 0);
	at[25] = 1.6500;
	points[26] = (6384.0161, -5460, 21.6093);
	angles[26] = (0, 0, 0);
	at[26] = 1.7000;
	points[27] = (6384.0161, -5460, 27.7200);
	angles[27] = (0, 0, 0);
	at[27] = 1.7500;
	points[28] = (6384.0161, -5460, 32.2179);
	angles[28] = (0, 0, 0);
	at[28] = 1.8000;
	points[29] = (6384.0161, -5460, 34.6730);
	angles[29] = (0, 0, 0);
	at[29] = 1.8500;
	points[30] = (6384.0161, -5460.6694, 35);
	angles[30] = (0, 0, 0);
	at[30] = 1.9000;
	points[31] = (6384.0161, -5465.5513, 35);
	angles[31] = (0, 0, 0);
	at[31] = 1.9500;
	points[32] = (6384.0161, -5474.5669, 35);
	angles[32] = (0, 0, 0);
	at[32] = 2;
	points[33] = (6384.0161, -5486.7715, 35);
	angles[33] = (0, 0, 0);
	at[33] = 2.0500;
	points[34] = (6384.0161, -5501.3779, 35);
	angles[34] = (0, 0, 0);
	at[34] = 2.1000;
	points[35] = (6384.0161, -5550.7090, 35);
	angles[35] = (0, 0, 0);
	at[35] = 2.2500;
	points[36] = (6384.0161, -5566.1812, 35);
	angles[36] = (0, 0, 0);
	at[36] = 2.3000;
	points[37] = (6384.0161, -5579.6851, 35);
	angles[37] = (0, 0, 0);
	at[37] = 2.3500;
	points[38] = (6384.0161, -5590.3940, 35);
	angles[38] = (0, 0, 0);
	at[38] = 2.4000;
	points[39] = (6384.0161, -5597.4409, 35);
	angles[39] = (0, 0, 0);
	at[39] = 2.4500;
	points[40] = (6384.0161, -5600, 35);
	angles[40] = (0, 0, 0);
	at[40] = 2.5000;
	points[41] = (6384.0161, -5600, 33.7277);
	angles[41] = (0, 0, 0);
	at[41] = 2.5500;
	points[42] = (6384.0161, -5600, 30.1974);
	angles[42] = (0, 0, 0);
	at[42] = 2.6000;
	points[43] = (6384.0161, -5600, 24.8394);
	angles[43] = (0, 0, 0);
	at[43] = 2.6500;
	points[44] = (6384.0161, -5600, 10.3600);
	angles[44] = (0, 0, 0);
	at[44] = 2.7500;
	points[45] = (6384.0161, -5600, -14.3158);
	angles[45] = (0, 0, 0);
	at[45] = 2.9000;
	points[46] = (6384.0161, -5600, -21.6093);
	angles[46] = (0, 0, 0);
	at[46] = 2.9500;
	points[47] = (6384.0161, -5600, -27.7200);
	angles[47] = (0, 0, 0);
	at[47] = 3;
	points[48] = (6384.0161, -5600, -32.2179);
	angles[48] = (0, 0, 0);
	at[48] = 3.0500;
	points[49] = (6384.0161, -5600, -34.6730);
	angles[49] = (0, 0, 0);
	at[49] = 3.1000;
	points[50] = (6384.0161, -5599.3311, -35);
	angles[50] = (0, 0, 0);
	at[50] = 3.1500;
	points[51] = (6384.0161, -5594.4487, -35);
	angles[51] = (0, 0, 0);
	at[51] = 3.2000;
	points[52] = (6384.0161, -5585.4331, -35);
	angles[52] = (0, 0, 0);
	at[52] = 3.2500;
	points[53] = (6384.0161, -5573.2285, -35);
	angles[53] = (0, 0, 0);
	at[53] = 3.3000;
	points[54] = (6384.0161, -5558.6221, -35);
	angles[54] = (0, 0, 0);
	at[54] = 3.3500;
	points[55] = (6384.0161, -5509.2915, -35);
	angles[55] = (0, 0, 0);
	at[55] = 3.5000;
	points[56] = (6384.0161, -5493.8188, -35);
	angles[56] = (0, 0, 0);
	at[56] = 3.5500;
	points[57] = (6384.0161, -5480.3149, -35);
	angles[57] = (0, 0, 0);
	at[57] = 3.6000;
	points[58] = (6384.0161, -5469.6060, -35);
	angles[58] = (0, 0, 0);
	at[58] = 3.6500;
	points[59] = (6384.0161, -5462.5591, -35);
	angles[59] = (0, 0, 0);
	at[59] = 3.7000;
	points[60] = (6384.0161, -5460, -35);
	angles[60] = (0, 0, 0);
	at[60] = 3.7500;
	points[61] = (6384.0161, -5460, -33.7277);
	angles[61] = (0, 0, 0);
	at[61] = 3.8000;
	points[62] = (6384.0161, -5460, -30.1974);
	angles[62] = (0, 0, 0);
	at[62] = 3.8500;
	points[63] = (6384.0161, -5460, -24.8394);
	angles[63] = (0, 0, 0);
	at[63] = 3.9000;
	points[64] = (6384.0161, -5460, -10.3600);
	angles[64] = (0, 0, 0);
	at[64] = 4;
	points[65] = (6384.0161, -5460, 14.3158);
	angles[65] = (0, 0, 0);
	at[65] = 4.1500;
	points[66] = (6384.0161, -5460, 21.6093);
	angles[66] = (0, 0, 0);
	at[66] = 4.2000;
	points[67] = (6384.0161, -5460, 27.7200);
	angles[67] = (0, 0, 0);
	at[67] = 4.2500;
	points[68] = (6384.0161, -5460, 32.2179);
	angles[68] = (0, 0, 0);
	at[68] = 4.3000;
	points[69] = (6384.0161, -5460, 34.6730);
	angles[69] = (0, 0, 0);
	at[69] = 4.3500;
	points[70] = (6384.0161, -5460.6694, 35);
	angles[70] = (0, 0, 0);
	at[70] = 4.4000;
	points[71] = (6384.0161, -5465.5513, 35);
	angles[71] = (0, 0, 0);
	at[71] = 4.4500;
	points[72] = (6384.0161, -5474.5669, 35);
	angles[72] = (0, 0, 0);
	at[72] = 4.5000;
	points[73] = (6384.0161, -5486.7715, 35);
	angles[73] = (0, 0, 0);
	at[73] = 4.5500;
	points[74] = (6384.0161, -5501.3779, 35);
	angles[74] = (0, 0, 0);
	at[74] = 4.6000;
	points[75] = (6384.0161, -5550.7090, 35);
	angles[75] = (0, 0, 0);
	at[75] = 4.7500;
	points[76] = (6384.0161, -5566.1812, 35);
	angles[76] = (0, 0, 0);
	at[76] = 4.8000;
	points[77] = (6384.0161, -5579.6851, 35);
	angles[77] = (0, 0, 0);
	at[77] = 4.8500;
	points[78] = (6384.0161, -5590.3940, 35);
	angles[78] = (0, 0, 0);
	at[78] = 4.9000;
	points[79] = (6384.0161, -5597.4409, 35);
	angles[79] = (0, 0, 0);
	at[79] = 4.9500;
	points[80] = (6384.0161, -5600, 35);
	angles[80] = (0, 0, 0);
	at[80] = 5;
	points[81] = (6384.0161, -5597.4409, 35);
	angles[81] = (0, 0, 0);
	at[81] = 5.0500;
	points[82] = (6384.0161, -5590.3940, 35);
	angles[82] = (0, 0, 0);
	at[82] = 5.1000;
	points[83] = (6384.0161, -5579.6851, 35);
	angles[83] = (0, 0, 0);
	at[83] = 5.1500;
	points[84] = (6384.0161, -5566.1812, 35);
	angles[84] = (0, 0, 0);
	at[84] = 5.2000;
	points[85] = (6384.0161, -5550.7090, 35);
	angles[85] = (0, 0, 0);
	at[85] = 5.2500;
	points[86] = (6384.0161, -5501.3779, 35);
	angles[86] = (0, 0, 0);
	at[86] = 5.4000;
	points[87] = (6384.0161, -5486.7715, 35);
	angles[87] = (0, 0, 0);
	at[87] = 5.4500;
	points[88] = (6384.0161, -5474.5669, 35);
	angles[88] = (0, 0, 0);
	at[88] = 5.5000;
	points[89] = (6384.0161, -5465.5513, 35);
	angles[89] = (0, 0, 0);
	at[89] = 5.5500;
	points[90] = (6384.0161, -5460.6694, 35);
	angles[90] = (0, 0, 0);
	at[90] = 5.6000;
	points[91] = (6384.0161, -5460, 34.6730);
	angles[91] = (0, 0, 0);
	at[91] = 5.6500;
	points[92] = (6384.0161, -5460, 32.2179);
	angles[92] = (0, 0, 0);
	at[92] = 5.7000;
	points[93] = (6384.0161, -5460, 27.7200);
	angles[93] = (0, 0, 0);
	at[93] = 5.7500;
	points[94] = (6384.0161, -5460, 21.6093);
	angles[94] = (0, 0, 0);
	at[94] = 5.8000;
	points[95] = (6384.0161, -5460, 14.3158);
	angles[95] = (0, 0, 0);
	at[95] = 5.8500;
	points[96] = (6384.0161, -5460, -10.3600);
	angles[96] = (0, 0, 0);
	at[96] = 6;
	points[97] = (6384.0161, -5460, -24.8394);
	angles[97] = (0, 0, 0);
	at[97] = 6.1000;
	points[98] = (6384.0161, -5460, -30.1974);
	angles[98] = (0, 0, 0);
	at[98] = 6.1500;
	points[99] = (6384.0161, -5460, -33.7277);
	angles[99] = (0, 0, 0);
	at[99] = 6.2000;
	points[100] = (6384.0161, -5460, -35);
	angles[100] = (0, 0, 0);
	at[100] = 6.2500;
	points[101] = (6384.0161, -5462.5591, -35);
	angles[101] = (0, 0, 0);
	at[101] = 6.3000;
	points[102] = (6384.0161, -5469.6060, -35);
	angles[102] = (0, 0, 0);
	at[102] = 6.3500;
	points[103] = (6384.0161, -5480.3149, -35);
	angles[103] = (0, 0, 0);
	at[103] = 6.4000;
	points[104] = (6384.0161, -5493.8188, -35);
	angles[104] = (0, 0, 0);
	at[104] = 6.4500;
	points[105] = (6384.0161, -5509.2915, -35);
	angles[105] = (0, 0, 0);
	at[105] = 6.5000;
	points[106] = (6384.0161, -5558.6221, -35);
	angles[106] = (0, 0, 0);
	at[106] = 6.6500;
	points[107] = (6384.0161, -5573.2285, -35);
	angles[107] = (0, 0, 0);
	at[107] = 6.7000;
	points[108] = (6384.0161, -5585.4331, -35);
	angles[108] = (0, 0, 0);
	at[108] = 6.7500;
	points[109] = (6384.0161, -5594.4487, -35);
	angles[109] = (0, 0, 0);
	at[109] = 6.8000;
	points[110] = (6384.0161, -5599.3311, -35);
	angles[110] = (0, 0, 0);
	at[110] = 6.8500;
	points[111] = (6384.0161, -5600, -34.6730);
	angles[111] = (0, 0, 0);
	at[111] = 6.9000;
	points[112] = (6384.0161, -5600, -32.2179);
	angles[112] = (0, 0, 0);
	at[112] = 6.9500;
	points[113] = (6384.0161, -5600, -27.7200);
	angles[113] = (0, 0, 0);
	at[113] = 7;
	points[114] = (6384.0161, -5600, -21.6093);
	angles[114] = (0, 0, 0);
	at[114] = 7.0500;
	points[115] = (6384.0161, -5600, -14.3158);
	angles[115] = (0, 0, 0);
	at[115] = 7.1000;
	points[116] = (6384.0161, -5600, 18.0835);
	angles[116] = (0, 0, 0);
	at[116] = 7.3000;
	points[117] = (6384.0161, -5600, 24.8394);
	angles[117] = (0, 0, 0);
	at[117] = 7.3500;
	points[118] = (6384.0161, -5600, 30.1974);
	angles[118] = (0, 0, 0);
	at[118] = 7.4000;
	points[119] = (6384.0161, -5600, 33.7277);
	angles[119] = (0, 0, 0);
	at[119] = 7.4500;
	points[120] = (6384.0161, -5600, 35);
	angles[120] = (0, 0, 0);
	at[120] = 7.5000;
	points[121] = (6384.0161, -5597.4409, 35);
	angles[121] = (0, 0, 0);
	at[121] = 7.5500;
	points[122] = (6384.0161, -5590.3940, 35);
	angles[122] = (0, 0, 0);
	at[122] = 7.6000;
	points[123] = (6384.0161, -5579.6851, 35);
	angles[123] = (0, 0, 0);
	at[123] = 7.6500;
	points[124] = (6384.0161, -5566.1812, 35);
	angles[124] = (0, 0, 0);
	at[124] = 7.7000;
	points[125] = (6384.0161, -5550.7090, 35);
	angles[125] = (0, 0, 0);
	at[125] = 7.7500;
	points[126] = (6384.0161, -5501.3779, 35);
	angles[126] = (0, 0, 0);
	at[126] = 7.9000;
	points[127] = (6384.0161, -5486.7715, 35);
	angles[127] = (0, 0, 0);
	at[127] = 7.9500;
	points[128] = (6384.0161, -5474.5669, 35);
	angles[128] = (0, 0, 0);
	at[128] = 8;
	points[129] = (6384.0161, -5465.5513, 35);
	angles[129] = (0, 0, 0);
	at[129] = 8.0500;
	points[130] = (6384.0161, -5460.6694, 35);
	angles[130] = (0, 0, 0);
	at[130] = 8.1000;
	points[131] = (6384.0161, -5460, 34.6730);
	angles[131] = (0, 0, 0);
	at[131] = 8.1500;
	points[132] = (6384.0161, -5460, 32.2179);
	angles[132] = (0, 0, 0);
	at[132] = 8.2000;
	points[133] = (6384.0161, -5460, 27.7200);
	angles[133] = (0, 0, 0);
	at[133] = 8.2500;
	points[134] = (6384.0161, -5460, 21.6093);
	angles[134] = (0, 0, 0);
	at[134] = 8.3000;
	points[135] = (6384.0161, -5460, 14.3158);
	angles[135] = (0, 0, 0);
	at[135] = 8.3500;
	points[136] = (6384.0161, -5460, -10.3600);
	angles[136] = (0, 0, 0);
	at[136] = 8.5000;
	points[137] = (6384.0161, -5460, -24.8395);
	angles[137] = (0, 0, 0);
	at[137] = 8.6000;
	points[138] = (6384.0161, -5460, -30.1974);
	angles[138] = (0, 0, 0);
	at[138] = 8.6500;
	points[139] = (6384.0161, -5460, -33.7277);
	angles[139] = (0, 0, 0);
	at[139] = 8.7000;
	points[140] = (6384.0161, -5460, -35);
	angles[140] = (0, 0, 0);
	at[140] = 8.7500;
	points[141] = (6384.0161, -5462.5591, -35);
	angles[141] = (0, 0, 0);
	at[141] = 8.8000;
	points[142] = (6384.0161, -5469.6060, -35);
	angles[142] = (0, 0, 0);
	at[142] = 8.8500;
	points[143] = (6384.0161, -5480.3149, -35);
	angles[143] = (0, 0, 0);
	at[143] = 8.9000;
	points[144] = (6384.0161, -5493.8188, -35);
	angles[144] = (0, 0, 0);
	at[144] = 8.9500;
	points[145] = (6384.0161, -5509.2915, -35);
	angles[145] = (0, 0, 0);
	at[145] = 9;
	points[146] = (6384.0161, -5558.6221, -35);
	angles[146] = (0, 0, 0);
	at[146] = 9.1500;
	points[147] = (6384.0161, -5573.2285, -35);
	angles[147] = (0, 0, 0);
	at[147] = 9.2000;
	points[148] = (6384.0161, -5585.4331, -35);
	angles[148] = (0, 0, 0);
	at[148] = 9.2500;
	points[149] = (6384.0161, -5594.4487, -35);
	angles[149] = (0, 0, 0);
	at[149] = 9.3000;
	points[150] = (6384.0161, -5599.3311, -35);
	angles[150] = (0, 0, 0);
	at[150] = 9.3500;
	points[151] = (6384.0161, -5600, -34.6730);
	angles[151] = (0, 0, 0);
	at[151] = 9.4000;
	points[152] = (6384.0161, -5600, -32.2179);
	angles[152] = (0, 0, 0);
	at[152] = 9.4500;
	points[153] = (6384.0161, -5600, -27.7200);
	angles[153] = (0, 0, 0);
	at[153] = 9.5000;
	points[154] = (6384.0161, -5600, -21.6093);
	angles[154] = (0, 0, 0);
	at[154] = 9.5500;
	points[155] = (6384.0161, -5600, -14.3158);
	angles[155] = (0, 0, 0);
	at[155] = 9.6000;
	points[156] = (6384.0161, -5600, 10.3600);
	angles[156] = (0, 0, 0);
	at[156] = 9.7500;
	points[157] = (6384.0161, -5600, 24.8395);
	angles[157] = (0, 0, 0);
	at[157] = 9.8500;
	points[158] = (6384.0161, -5600, 30.1974);
	angles[158] = (0, 0, 0);
	at[158] = 9.9000;
	points[159] = (6384.0161, -5600, 33.7277);
	angles[159] = (0, 0, 0);
	at[159] = 9.9500;
	points[160] = (6384.0161, -5600, 35);
	angles[160] = (0, 0, 0);
	at[160] = 10;
	mover = getEnt("iz_mover1", "targetname");
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
