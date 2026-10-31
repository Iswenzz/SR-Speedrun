main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_smb2_totalitarian", 0);

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
	ambientPlay("iz_0_cave", 2);
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
	thread iz_mover2();
}

iz_mover0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (210, -630, -1750);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (210, -630, -1750.5945);
	angles[1] = (0, 0, 0);
	at[1] = 0.0500;
	points[2] = (210, -630, -1752.5474);
	angles[2] = (0, 0, 0);
	at[2] = 0.1000;
	points[3] = (210, -630, -1756.1024);
	angles[3] = (0, 0, 0);
	at[3] = 0.1500;
	points[4] = (210, -630, -1761.4922);
	angles[4] = (0, 0, 0);
	at[4] = 0.2000;
	points[5] = (210, -630, -1768.9685);
	angles[5] = (0, 0, 0);
	at[5] = 0.2500;
	points[6] = (210, -630, -1778.7756);
	angles[6] = (0, 0, 0);
	at[6] = 0.3000;
	points[7] = (210, -630, -1791.1536);
	angles[7] = (0, 0, 0);
	at[7] = 0.3500;
	points[8] = (210, -630, -1806.3347);
	angles[8] = (0, 0, 0);
	at[8] = 0.4000;
	points[9] = (210, -630, -1824.5787);
	angles[9] = (0, 0, 0);
	at[9] = 0.4500;
	points[10] = (210, -630, -1846.1182);
	angles[10] = (0, 0, 0);
	at[10] = 0.5000;
	points[11] = (210, -630, -1871.1969);
	angles[11] = (0, 0, 0);
	at[11] = 0.5500;
	points[12] = (210, -630, -1900.0591);
	angles[12] = (0, 0, 0);
	at[12] = 0.6000;
	points[13] = (210, -630, -1932.9528);
	angles[13] = (0, 0, 0);
	at[13] = 0.6500;
	points[14] = (210, -630, -1970.1063);
	angles[14] = (0, 0, 0);
	at[14] = 0.7000;
	points[15] = (210, -630, -2011.7795);
	angles[15] = (0, 0, 0);
	at[15] = 0.7500;
	points[16] = (210, -630, -2058.2048);
	angles[16] = (0, 0, 0);
	at[16] = 0.8000;
	points[17] = (210, -630, -2109.6260);
	angles[17] = (0, 0, 0);
	at[17] = 0.8500;
	points[18] = (210, -630, -2166.2834);
	angles[18] = (0, 0, 0);
	at[18] = 0.9000;
	points[19] = (210, -630, -2228.4211);
	angles[19] = (0, 0, 0);
	at[19] = 0.9500;
	points[20] = (210, -630, -2296.2954);
	angles[20] = (0, 0, 0);
	at[20] = 1;
	points[21] = (210, -630, -2370.1301);
	angles[21] = (0, 0, 0);
	at[21] = 1.0500;
	points[22] = (210, -630, -2450.1733);
	angles[22] = (0, 0, 0);
	at[22] = 1.1000;
	points[23] = (210, -630, -2536.6733);
	angles[23] = (0, 0, 0);
	at[23] = 1.1500;
	points[24] = (210, -630, -2629.8662);
	angles[24] = (0, 0, 0);
	at[24] = 1.2000;
	points[25] = (210, -630, -2730);
	angles[25] = (0, 0, 0);
	at[25] = 1.2500;
	points[26] = (210, -630, -2713.2439);
	angles[26] = (0, 0, 0);
	at[26] = 1.3000;
	points[27] = (210, -630, -2699.6694);
	angles[27] = (0, 0, 0);
	at[27] = 1.3500;
	points[28] = (210, -630, -2689.5828);
	angles[28] = (0, 0, 0);
	at[28] = 1.4000;
	points[29] = (210, -630, -2683.3032);
	angles[29] = (0, 0, 0);
	at[29] = 1.4500;
	points[30] = (210, -630, -2681.1416);
	angles[30] = (0, 0, 0);
	at[30] = 1.5000;
	points[31] = (210, -630, -2686.2207);
	angles[31] = (0, 0, 0);
	at[31] = 1.5500;
	points[32] = (210, -630, -2698.3389);
	angles[32] = (0, 0, 0);
	at[32] = 1.6000;
	points[33] = (210, -630, -2712.7991);
	angles[33] = (0, 0, 0);
	at[33] = 1.6500;
	points[34] = (210, -630, -2724.9172);
	angles[34] = (0, 0, 0);
	at[34] = 1.7000;
	points[35] = (210, -630, -2730);
	angles[35] = (0, 0, 0);
	at[35] = 1.7500;
	points[36] = (210, -630, -2730);
	angles[36] = (0, 0, 0);
	at[36] = 2;
	points[37] = (210, -630, -2729.1931);
	angles[37] = (0, 0, 0);
	at[37] = 2.0500;
	points[38] = (210, -630, -2726.8071);
	angles[38] = (0, 0, 0);
	at[38] = 2.1000;
	points[39] = (210, -630, -2722.8938);
	angles[39] = (0, 0, 0);
	at[39] = 2.1500;
	points[40] = (210, -630, -2717.5120);
	angles[40] = (0, 0, 0);
	at[40] = 2.2000;
	points[41] = (210, -630, -2710.7168);
	angles[41] = (0, 0, 0);
	at[41] = 2.2500;
	points[42] = (210, -630, -2702.5588);
	angles[42] = (0, 0, 0);
	at[42] = 2.3000;
	points[43] = (210, -630, -2693.0945);
	angles[43] = (0, 0, 0);
	at[43] = 2.3500;
	points[44] = (210, -630, -2682.3779);
	angles[44] = (0, 0, 0);
	at[44] = 2.4000;
	points[45] = (210, -630, -2670.4648);
	angles[45] = (0, 0, 0);
	at[45] = 2.4500;
	points[46] = (210, -630, -2657.4094);
	angles[46] = (0, 0, 0);
	at[46] = 2.5000;
	points[47] = (210, -630, -2643.2639);
	angles[47] = (0, 0, 0);
	at[47] = 2.5500;
	points[48] = (210, -630, -2628.0786);
	angles[48] = (0, 0, 0);
	at[48] = 2.6000;
	points[49] = (210, -630, -2611.9172);
	angles[49] = (0, 0, 0);
	at[49] = 2.6500;
	points[50] = (210, -630, -2576.8740);
	angles[50] = (0, 0, 0);
	at[50] = 2.7500;
	points[51] = (210, -630, -2538.5630);
	angles[51] = (0, 0, 0);
	at[51] = 2.8500;
	points[52] = (210, -630, -2518.3191);
	angles[52] = (0, 0, 0);
	at[52] = 2.9000;
	points[53] = (210, -630, -2475.9292);
	angles[53] = (0, 0, 0);
	at[53] = 3;
	points[54] = (210, -630, -2431.3506);
	angles[54] = (0, 0, 0);
	at[54] = 3.1000;
	points[55] = (210, -630, -2361.3662);
	angles[55] = (0, 0, 0);
	at[55] = 3.2500;
	points[56] = (210, -630, -2313.2559);
	angles[56] = (0, 0, 0);
	at[56] = 3.3500;
	points[57] = (210, -630, -2142.5828);
	angles[57] = (0, 0, 0);
	at[57] = 3.7000;
	points[58] = (210, -630, -2094.9607);
	angles[58] = (0, 0, 0);
	at[58] = 3.8000;
	points[59] = (210, -630, -2048.6497);
	angles[59] = (0, 0, 0);
	at[59] = 3.9000;
	points[60] = (210, -630, -2004.0709);
	angles[60] = (0, 0, 0);
	at[60] = 4;
	points[61] = (210, -630, -1961.6810);
	angles[61] = (0, 0, 0);
	at[61] = 4.1000;
	points[62] = (210, -630, -1921.8977);
	angles[62] = (0, 0, 0);
	at[62] = 4.2000;
	points[63] = (210, -630, -1903.1261);
	angles[63] = (0, 0, 0);
	at[63] = 4.2500;
	points[64] = (210, -630, -1868.0826);
	angles[64] = (0, 0, 0);
	at[64] = 4.3500;
	points[65] = (210, -630, -1836.7362);
	angles[65] = (0, 0, 0);
	at[65] = 4.4500;
	points[66] = (210, -630, -1822.5906);
	angles[66] = (0, 0, 0);
	at[66] = 4.5000;
	points[67] = (210, -630, -1809.5355);
	angles[67] = (0, 0, 0);
	at[67] = 4.5500;
	points[68] = (210, -630, -1797.6221);
	angles[68] = (0, 0, 0);
	at[68] = 4.6000;
	points[69] = (210, -630, -1786.9056);
	angles[69] = (0, 0, 0);
	at[69] = 4.6500;
	points[70] = (210, -630, -1777.4409);
	angles[70] = (0, 0, 0);
	at[70] = 4.7000;
	points[71] = (210, -630, -1769.2834);
	angles[71] = (0, 0, 0);
	at[71] = 4.7500;
	points[72] = (210, -630, -1762.4883);
	angles[72] = (0, 0, 0);
	at[72] = 4.8000;
	points[73] = (210, -630, -1757.1063);
	angles[73] = (0, 0, 0);
	at[73] = 4.8500;
	points[74] = (210, -630, -1753.1930);
	angles[74] = (0, 0, 0);
	at[74] = 4.9000;
	points[75] = (210, -630, -1750.8032);
	angles[75] = (0, 0, 0);
	at[75] = 4.9500;
	points[76] = (210, -630, -1750);
	angles[76] = (0, 0, 0);
	at[76] = 5;
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
	points[0] = (210, -630, -1750);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (210, -630, -1750.5945);
	angles[1] = (0, 0, 0);
	at[1] = 0.0500;
	points[2] = (210, -630, -1752.5474);
	angles[2] = (0, 0, 0);
	at[2] = 0.1000;
	points[3] = (210, -630, -1756.1024);
	angles[3] = (0, 0, 0);
	at[3] = 0.1500;
	points[4] = (210, -630, -1761.4922);
	angles[4] = (0, 0, 0);
	at[4] = 0.2000;
	points[5] = (210, -630, -1768.9685);
	angles[5] = (0, 0, 0);
	at[5] = 0.2500;
	points[6] = (210, -630, -1778.7756);
	angles[6] = (0, 0, 0);
	at[6] = 0.3000;
	points[7] = (210, -630, -1791.1536);
	angles[7] = (0, 0, 0);
	at[7] = 0.3500;
	points[8] = (210, -630, -1806.3347);
	angles[8] = (0, 0, 0);
	at[8] = 0.4000;
	points[9] = (210, -630, -1824.5787);
	angles[9] = (0, 0, 0);
	at[9] = 0.4500;
	points[10] = (210, -630, -1846.1182);
	angles[10] = (0, 0, 0);
	at[10] = 0.5000;
	points[11] = (210, -630, -1871.1969);
	angles[11] = (0, 0, 0);
	at[11] = 0.5500;
	points[12] = (210, -630, -1900.0591);
	angles[12] = (0, 0, 0);
	at[12] = 0.6000;
	points[13] = (210, -630, -1932.9528);
	angles[13] = (0, 0, 0);
	at[13] = 0.6500;
	points[14] = (210, -630, -1970.1063);
	angles[14] = (0, 0, 0);
	at[14] = 0.7000;
	points[15] = (210, -630, -2011.7795);
	angles[15] = (0, 0, 0);
	at[15] = 0.7500;
	points[16] = (210, -630, -2058.2048);
	angles[16] = (0, 0, 0);
	at[16] = 0.8000;
	points[17] = (210, -630, -2109.6260);
	angles[17] = (0, 0, 0);
	at[17] = 0.8500;
	points[18] = (210, -630, -2166.2834);
	angles[18] = (0, 0, 0);
	at[18] = 0.9000;
	points[19] = (210, -630, -2228.4211);
	angles[19] = (0, 0, 0);
	at[19] = 0.9500;
	points[20] = (210, -630, -2296.2954);
	angles[20] = (0, 0, 0);
	at[20] = 1;
	points[21] = (210, -630, -2370.1301);
	angles[21] = (0, 0, 0);
	at[21] = 1.0500;
	points[22] = (210, -630, -2450.1733);
	angles[22] = (0, 0, 0);
	at[22] = 1.1000;
	points[23] = (210, -630, -2536.6733);
	angles[23] = (0, 0, 0);
	at[23] = 1.1500;
	points[24] = (210, -630, -2629.8662);
	angles[24] = (0, 0, 0);
	at[24] = 1.2000;
	points[25] = (210, -630, -2730);
	angles[25] = (0, 0, 0);
	at[25] = 1.2500;
	points[26] = (210, -630, -2713.2439);
	angles[26] = (0, 0, 0);
	at[26] = 1.3000;
	points[27] = (210, -630, -2699.6694);
	angles[27] = (0, 0, 0);
	at[27] = 1.3500;
	points[28] = (210, -630, -2689.5828);
	angles[28] = (0, 0, 0);
	at[28] = 1.4000;
	points[29] = (210, -630, -2683.3032);
	angles[29] = (0, 0, 0);
	at[29] = 1.4500;
	points[30] = (210, -630, -2681.1416);
	angles[30] = (0, 0, 0);
	at[30] = 1.5000;
	points[31] = (210, -630, -2686.2207);
	angles[31] = (0, 0, 0);
	at[31] = 1.5500;
	points[32] = (210, -630, -2698.3389);
	angles[32] = (0, 0, 0);
	at[32] = 1.6000;
	points[33] = (210, -630, -2712.7991);
	angles[33] = (0, 0, 0);
	at[33] = 1.6500;
	points[34] = (210, -630, -2724.9172);
	angles[34] = (0, 0, 0);
	at[34] = 1.7000;
	points[35] = (210, -630, -2730);
	angles[35] = (0, 0, 0);
	at[35] = 1.7500;
	points[36] = (210, -630, -2730);
	angles[36] = (0, 0, 0);
	at[36] = 2;
	points[37] = (210, -630, -2729.1931);
	angles[37] = (0, 0, 0);
	at[37] = 2.0500;
	points[38] = (210, -630, -2726.8071);
	angles[38] = (0, 0, 0);
	at[38] = 2.1000;
	points[39] = (210, -630, -2722.8938);
	angles[39] = (0, 0, 0);
	at[39] = 2.1500;
	points[40] = (210, -630, -2717.5120);
	angles[40] = (0, 0, 0);
	at[40] = 2.2000;
	points[41] = (210, -630, -2710.7168);
	angles[41] = (0, 0, 0);
	at[41] = 2.2500;
	points[42] = (210, -630, -2702.5588);
	angles[42] = (0, 0, 0);
	at[42] = 2.3000;
	points[43] = (210, -630, -2693.0945);
	angles[43] = (0, 0, 0);
	at[43] = 2.3500;
	points[44] = (210, -630, -2682.3779);
	angles[44] = (0, 0, 0);
	at[44] = 2.4000;
	points[45] = (210, -630, -2670.4648);
	angles[45] = (0, 0, 0);
	at[45] = 2.4500;
	points[46] = (210, -630, -2657.4094);
	angles[46] = (0, 0, 0);
	at[46] = 2.5000;
	points[47] = (210, -630, -2643.2639);
	angles[47] = (0, 0, 0);
	at[47] = 2.5500;
	points[48] = (210, -630, -2628.0786);
	angles[48] = (0, 0, 0);
	at[48] = 2.6000;
	points[49] = (210, -630, -2611.9172);
	angles[49] = (0, 0, 0);
	at[49] = 2.6500;
	points[50] = (210, -630, -2576.8740);
	angles[50] = (0, 0, 0);
	at[50] = 2.7500;
	points[51] = (210, -630, -2538.5630);
	angles[51] = (0, 0, 0);
	at[51] = 2.8500;
	points[52] = (210, -630, -2518.3191);
	angles[52] = (0, 0, 0);
	at[52] = 2.9000;
	points[53] = (210, -630, -2475.9292);
	angles[53] = (0, 0, 0);
	at[53] = 3;
	points[54] = (210, -630, -2431.3506);
	angles[54] = (0, 0, 0);
	at[54] = 3.1000;
	points[55] = (210, -630, -2361.3662);
	angles[55] = (0, 0, 0);
	at[55] = 3.2500;
	points[56] = (210, -630, -2313.2559);
	angles[56] = (0, 0, 0);
	at[56] = 3.3500;
	points[57] = (210, -630, -2142.5828);
	angles[57] = (0, 0, 0);
	at[57] = 3.7000;
	points[58] = (210, -630, -2094.9607);
	angles[58] = (0, 0, 0);
	at[58] = 3.8000;
	points[59] = (210, -630, -2048.6497);
	angles[59] = (0, 0, 0);
	at[59] = 3.9000;
	points[60] = (210, -630, -2004.0709);
	angles[60] = (0, 0, 0);
	at[60] = 4;
	points[61] = (210, -630, -1961.6810);
	angles[61] = (0, 0, 0);
	at[61] = 4.1000;
	points[62] = (210, -630, -1921.8977);
	angles[62] = (0, 0, 0);
	at[62] = 4.2000;
	points[63] = (210, -630, -1903.1261);
	angles[63] = (0, 0, 0);
	at[63] = 4.2500;
	points[64] = (210, -630, -1868.0826);
	angles[64] = (0, 0, 0);
	at[64] = 4.3500;
	points[65] = (210, -630, -1836.7362);
	angles[65] = (0, 0, 0);
	at[65] = 4.4500;
	points[66] = (210, -630, -1822.5906);
	angles[66] = (0, 0, 0);
	at[66] = 4.5000;
	points[67] = (210, -630, -1809.5355);
	angles[67] = (0, 0, 0);
	at[67] = 4.5500;
	points[68] = (210, -630, -1797.6221);
	angles[68] = (0, 0, 0);
	at[68] = 4.6000;
	points[69] = (210, -630, -1786.9056);
	angles[69] = (0, 0, 0);
	at[69] = 4.6500;
	points[70] = (210, -630, -1777.4409);
	angles[70] = (0, 0, 0);
	at[70] = 4.7000;
	points[71] = (210, -630, -1769.2834);
	angles[71] = (0, 0, 0);
	at[71] = 4.7500;
	points[72] = (210, -630, -1762.4883);
	angles[72] = (0, 0, 0);
	at[72] = 4.8000;
	points[73] = (210, -630, -1757.1063);
	angles[73] = (0, 0, 0);
	at[73] = 4.8500;
	points[74] = (210, -630, -1753.1930);
	angles[74] = (0, 0, 0);
	at[74] = 4.9000;
	points[75] = (210, -630, -1750.8032);
	angles[75] = (0, 0, 0);
	at[75] = 4.9500;
	points[76] = (210, -630, -1750);
	angles[76] = (0, 0, 0);
	at[76] = 5;
	mover = getEnt("iz_mover1", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_play(points, angles, at, false, 1, 0);
}

iz_mover2()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (210, -630, -1750);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (210, -630, -1750.5945);
	angles[1] = (0, 0, 0);
	at[1] = 0.0500;
	points[2] = (210, -630, -1752.5474);
	angles[2] = (0, 0, 0);
	at[2] = 0.1000;
	points[3] = (210, -630, -1756.1024);
	angles[3] = (0, 0, 0);
	at[3] = 0.1500;
	points[4] = (210, -630, -1761.4922);
	angles[4] = (0, 0, 0);
	at[4] = 0.2000;
	points[5] = (210, -630, -1768.9685);
	angles[5] = (0, 0, 0);
	at[5] = 0.2500;
	points[6] = (210, -630, -1778.7756);
	angles[6] = (0, 0, 0);
	at[6] = 0.3000;
	points[7] = (210, -630, -1791.1536);
	angles[7] = (0, 0, 0);
	at[7] = 0.3500;
	points[8] = (210, -630, -1806.3347);
	angles[8] = (0, 0, 0);
	at[8] = 0.4000;
	points[9] = (210, -630, -1824.5787);
	angles[9] = (0, 0, 0);
	at[9] = 0.4500;
	points[10] = (210, -630, -1846.1182);
	angles[10] = (0, 0, 0);
	at[10] = 0.5000;
	points[11] = (210, -630, -1871.1969);
	angles[11] = (0, 0, 0);
	at[11] = 0.5500;
	points[12] = (210, -630, -1900.0591);
	angles[12] = (0, 0, 0);
	at[12] = 0.6000;
	points[13] = (210, -630, -1932.9528);
	angles[13] = (0, 0, 0);
	at[13] = 0.6500;
	points[14] = (210, -630, -1970.1063);
	angles[14] = (0, 0, 0);
	at[14] = 0.7000;
	points[15] = (210, -630, -2011.7795);
	angles[15] = (0, 0, 0);
	at[15] = 0.7500;
	points[16] = (210, -630, -2058.2048);
	angles[16] = (0, 0, 0);
	at[16] = 0.8000;
	points[17] = (210, -630, -2109.6260);
	angles[17] = (0, 0, 0);
	at[17] = 0.8500;
	points[18] = (210, -630, -2166.2834);
	angles[18] = (0, 0, 0);
	at[18] = 0.9000;
	points[19] = (210, -630, -2228.4211);
	angles[19] = (0, 0, 0);
	at[19] = 0.9500;
	points[20] = (210, -630, -2296.2954);
	angles[20] = (0, 0, 0);
	at[20] = 1;
	points[21] = (210, -630, -2370.1301);
	angles[21] = (0, 0, 0);
	at[21] = 1.0500;
	points[22] = (210, -630, -2450.1733);
	angles[22] = (0, 0, 0);
	at[22] = 1.1000;
	points[23] = (210, -630, -2536.6733);
	angles[23] = (0, 0, 0);
	at[23] = 1.1500;
	points[24] = (210, -630, -2629.8662);
	angles[24] = (0, 0, 0);
	at[24] = 1.2000;
	points[25] = (210, -630, -2730);
	angles[25] = (0, 0, 0);
	at[25] = 1.2500;
	points[26] = (210, -630, -2713.2439);
	angles[26] = (0, 0, 0);
	at[26] = 1.3000;
	points[27] = (210, -630, -2699.6694);
	angles[27] = (0, 0, 0);
	at[27] = 1.3500;
	points[28] = (210, -630, -2689.5828);
	angles[28] = (0, 0, 0);
	at[28] = 1.4000;
	points[29] = (210, -630, -2683.3032);
	angles[29] = (0, 0, 0);
	at[29] = 1.4500;
	points[30] = (210, -630, -2681.1416);
	angles[30] = (0, 0, 0);
	at[30] = 1.5000;
	points[31] = (210, -630, -2686.2207);
	angles[31] = (0, 0, 0);
	at[31] = 1.5500;
	points[32] = (210, -630, -2698.3389);
	angles[32] = (0, 0, 0);
	at[32] = 1.6000;
	points[33] = (210, -630, -2712.7991);
	angles[33] = (0, 0, 0);
	at[33] = 1.6500;
	points[34] = (210, -630, -2724.9172);
	angles[34] = (0, 0, 0);
	at[34] = 1.7000;
	points[35] = (210, -630, -2730);
	angles[35] = (0, 0, 0);
	at[35] = 1.7500;
	points[36] = (210, -630, -2730);
	angles[36] = (0, 0, 0);
	at[36] = 2;
	points[37] = (210, -630, -2729.1931);
	angles[37] = (0, 0, 0);
	at[37] = 2.0500;
	points[38] = (210, -630, -2726.8071);
	angles[38] = (0, 0, 0);
	at[38] = 2.1000;
	points[39] = (210, -630, -2722.8938);
	angles[39] = (0, 0, 0);
	at[39] = 2.1500;
	points[40] = (210, -630, -2717.5120);
	angles[40] = (0, 0, 0);
	at[40] = 2.2000;
	points[41] = (210, -630, -2710.7168);
	angles[41] = (0, 0, 0);
	at[41] = 2.2500;
	points[42] = (210, -630, -2702.5588);
	angles[42] = (0, 0, 0);
	at[42] = 2.3000;
	points[43] = (210, -630, -2693.0945);
	angles[43] = (0, 0, 0);
	at[43] = 2.3500;
	points[44] = (210, -630, -2682.3779);
	angles[44] = (0, 0, 0);
	at[44] = 2.4000;
	points[45] = (210, -630, -2670.4648);
	angles[45] = (0, 0, 0);
	at[45] = 2.4500;
	points[46] = (210, -630, -2657.4094);
	angles[46] = (0, 0, 0);
	at[46] = 2.5000;
	points[47] = (210, -630, -2643.2639);
	angles[47] = (0, 0, 0);
	at[47] = 2.5500;
	points[48] = (210, -630, -2628.0786);
	angles[48] = (0, 0, 0);
	at[48] = 2.6000;
	points[49] = (210, -630, -2611.9172);
	angles[49] = (0, 0, 0);
	at[49] = 2.6500;
	points[50] = (210, -630, -2576.8740);
	angles[50] = (0, 0, 0);
	at[50] = 2.7500;
	points[51] = (210, -630, -2538.5630);
	angles[51] = (0, 0, 0);
	at[51] = 2.8500;
	points[52] = (210, -630, -2518.3191);
	angles[52] = (0, 0, 0);
	at[52] = 2.9000;
	points[53] = (210, -630, -2475.9292);
	angles[53] = (0, 0, 0);
	at[53] = 3;
	points[54] = (210, -630, -2431.3506);
	angles[54] = (0, 0, 0);
	at[54] = 3.1000;
	points[55] = (210, -630, -2361.3662);
	angles[55] = (0, 0, 0);
	at[55] = 3.2500;
	points[56] = (210, -630, -2313.2559);
	angles[56] = (0, 0, 0);
	at[56] = 3.3500;
	points[57] = (210, -630, -2142.5828);
	angles[57] = (0, 0, 0);
	at[57] = 3.7000;
	points[58] = (210, -630, -2094.9607);
	angles[58] = (0, 0, 0);
	at[58] = 3.8000;
	points[59] = (210, -630, -2048.6497);
	angles[59] = (0, 0, 0);
	at[59] = 3.9000;
	points[60] = (210, -630, -2004.0709);
	angles[60] = (0, 0, 0);
	at[60] = 4;
	points[61] = (210, -630, -1961.6810);
	angles[61] = (0, 0, 0);
	at[61] = 4.1000;
	points[62] = (210, -630, -1921.8977);
	angles[62] = (0, 0, 0);
	at[62] = 4.2000;
	points[63] = (210, -630, -1903.1261);
	angles[63] = (0, 0, 0);
	at[63] = 4.2500;
	points[64] = (210, -630, -1868.0826);
	angles[64] = (0, 0, 0);
	at[64] = 4.3500;
	points[65] = (210, -630, -1836.7362);
	angles[65] = (0, 0, 0);
	at[65] = 4.4500;
	points[66] = (210, -630, -1822.5906);
	angles[66] = (0, 0, 0);
	at[66] = 4.5000;
	points[67] = (210, -630, -1809.5355);
	angles[67] = (0, 0, 0);
	at[67] = 4.5500;
	points[68] = (210, -630, -1797.6221);
	angles[68] = (0, 0, 0);
	at[68] = 4.6000;
	points[69] = (210, -630, -1786.9056);
	angles[69] = (0, 0, 0);
	at[69] = 4.6500;
	points[70] = (210, -630, -1777.4409);
	angles[70] = (0, 0, 0);
	at[70] = 4.7000;
	points[71] = (210, -630, -1769.2834);
	angles[71] = (0, 0, 0);
	at[71] = 4.7500;
	points[72] = (210, -630, -1762.4883);
	angles[72] = (0, 0, 0);
	at[72] = 4.8000;
	points[73] = (210, -630, -1757.1063);
	angles[73] = (0, 0, 0);
	at[73] = 4.8500;
	points[74] = (210, -630, -1753.1930);
	angles[74] = (0, 0, 0);
	at[74] = 4.9000;
	points[75] = (210, -630, -1750.8032);
	angles[75] = (0, 0, 0);
	at[75] = 4.9500;
	points[76] = (210, -630, -1750);
	angles[76] = (0, 0, 0);
	at[76] = 5;
	mover = getEnt("iz_mover2", "targetname");
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
