main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_smb2_switch_inferno", 0);

	thread iz_sounds();

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
	ambientPlay("iz_0_nabe", 2);
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
	level.iz_play[2] = -1;
	level.iz_press[2] = 0;
	level.iz_play[3] = -1;
	level.iz_press[3] = 0;
	thread iz_button("iz_button0", 3, 0);
	thread iz_button("iz_button1", 3, 0);
	thread iz_button("iz_button2", 3, 0);
	thread iz_button("iz_button3", 3, 0);
	thread iz_button("iz_button4", 3, 0);
	thread iz_button("iz_button5", 3, 0);
	thread iz_button("iz_button6", 3, 0);
	thread iz_button("iz_button7", 3, 0);
	thread iz_button("iz_button8", 3, 0);
	thread iz_button("iz_button9", 3, 0);
	thread iz_button("iz_button10", 3, 0);
	thread iz_button("iz_button11", 3, 0);
	thread iz_button("iz_button12", 3, 0);
	thread iz_button("iz_button13", 3, 0);
	thread iz_button("iz_button14", 3, 0);
	thread iz_button("iz_button15", 3, 0);
	thread iz_button("iz_button16", 3, 0);
	thread iz_button("iz_button17", 3, 0);
	thread iz_button("iz_button18", 3, 0);
	thread iz_button("iz_button19", 3, 0);
	thread iz_button("iz_button20", 3, 0);
	thread iz_button("iz_button21", 3, 0);
	thread iz_button("iz_button22", 3, 0);
	thread iz_button("iz_button23", 3, 0);
	thread iz_button("iz_button24", 3, 0);
	thread iz_button("iz_button25", 3, 0);
	thread iz_button("iz_button26", 2, 0);
	thread iz_button("iz_button27", 2, 0);
	thread iz_button("iz_button28", 2, 0);
	thread iz_button("iz_button29", 2, 0);
	thread iz_button("iz_button30", 2, 0);
	thread iz_button("iz_button31", 2, 0);
	thread iz_button("iz_button32", 2, 0);
	thread iz_button("iz_button33", 2, 0);
	thread iz_button("iz_button34", 2, 0);
	thread iz_button("iz_button35", 2, 0);
	thread iz_button("iz_button36", 2, 0);
	thread iz_button("iz_button37", 2, 0);
	thread iz_button("iz_button38", 2, 0);
	thread iz_button("iz_button39", 2, 0);
	thread iz_button("iz_button40", 2, 0);
	thread iz_button("iz_button41", 2, 0);
	thread iz_button("iz_button42", 2, 0);
	thread iz_button("iz_button43", 2, 0);
	thread iz_button("iz_button44", 2, 0);
	thread iz_button("iz_button45", 2, 0);
	thread iz_button("iz_button46", 2, 0);
	thread iz_button("iz_button47", 2, 0);
	thread iz_button("iz_button48", 2, 0);
	thread iz_button("iz_button49", 2, 0);
	thread iz_button("iz_button50", 2, 0);
	thread iz_button("iz_button51", 2, 0);
	thread iz_button("iz_button52", 1, 0);
	thread iz_button("iz_button53", 1, 0);
	thread iz_button("iz_button54", 1, 0);
	thread iz_button("iz_button55", 1, 0);
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
}

iz_mover0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, -1512, 91);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, -1512, 91.7610);
	angles[1] = (0, 0, 0);
	at[1] = 0.0500;
	points[2] = (0, -1512, 93.9402);
	angles[2] = (0, 0, 0);
	at[2] = 0.1000;
	points[3] = (0, -1512, 97.3783);
	angles[3] = (0, 0, 0);
	at[3] = 0.1500;
	points[4] = (0, -1512, 107.4059);
	angles[4] = (0, 0, 0);
	at[4] = 0.2500;
	points[5] = (0, -1512, 120.5835);
	angles[5] = (0, 0, 0);
	at[5] = 0.3500;
	points[6] = (0, -1512, 159.0402);
	angles[6] = (0, 0, 0);
	at[6] = 0.6000;
	points[7] = (0, -1512, 173.3201);
	angles[7] = (0, 0, 0);
	at[7] = 0.7000;
	points[8] = (0, -1512, 185.0799);
	angles[8] = (0, 0, 0);
	at[8] = 0.8000;
	points[9] = (0, -1512, 189.6209);
	angles[9] = (0, 0, 0);
	at[9] = 0.8500;
	points[10] = (0, -1512, 193.0598);
	angles[10] = (0, 0, 0);
	at[10] = 0.9000;
	points[11] = (0, -1512, 195.2386);
	angles[11] = (0, 0, 0);
	at[11] = 0.9500;
	points[12] = (0, -1512, 196);
	angles[12] = (0, 0, 0);
	at[12] = 1;
	points[13] = (0, -1512, 196.0279);
	angles[13] = (0, 0, 0);
	at[13] = 1.9500;
	points[14] = (0, -1512, 195.2665);
	angles[14] = (0, 0, 0);
	at[14] = 2.0500;
	points[15] = (0, -1512, 193.0874);
	angles[15] = (0, 0, 0);
	at[15] = 2.1000;
	points[16] = (0, -1512, 189.6476);
	angles[16] = (0, 0, 0);
	at[16] = 2.1500;
	points[17] = (0, -1512, 185.1051);
	angles[17] = (0, 0, 0);
	at[17] = 2.2000;
	points[18] = (0, -1512, 179.6173);
	angles[18] = (0, 0, 0);
	at[18] = 2.2500;
	points[19] = (0, -1512, 166.4362);
	angles[19] = (0, 0, 0);
	at[19] = 2.3500;
	points[20] = (0, -1512, 127.9697);
	angles[20] = (0, 0, 0);
	at[20] = 2.6000;
	points[21] = (0, -1512, 113.6862);
	angles[21] = (0, 0, 0);
	at[21] = 2.7000;
	points[22] = (0, -1512, 107.4106);
	angles[22] = (0, 0, 0);
	at[22] = 2.7500;
	points[23] = (0, -1512, 97.3803);
	angles[23] = (0, 0, 0);
	at[23] = 2.8500;
	points[24] = (0, -1512, 93.9406);
	angles[24] = (0, 0, 0);
	at[24] = 2.9000;
	points[25] = (0, -1512, 91.7614);
	angles[25] = (0, 0, 0);
	at[25] = 2.9500;
	points[26] = (0, -1512, 91);
	angles[26] = (0, 0, 0);
	at[26] = 3;
	mover = getEnt("iz_mover0", "targetname");
	if (!isDefined(mover))
		return;
	rider = getEnt("endmap_trig", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	mover thread iz_mover_play(points, angles, at, true, 1, 1);
}

iz_mover1()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, 0, 140);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 0, -70);
	angles[1] = (0, 0, 0);
	at[1] = 0.0500;
	points[2] = (0, 0, -70);
	angles[2] = (0, 0, 0);
	at[2] = 0.2500;
	points[3] = (0, 0, -70);
	angles[3] = (0, 0, 0);
	at[3] = 2.9500;
	points[4] = (0, 0, 140);
	angles[4] = (0, 0, 0);
	at[4] = 3;
	mover = getEnt("iz_mover1", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_play(points, angles, at, true, 1, 1);
}

iz_mover2()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (2730, -6412.0083, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (2722.9016, -6412.0083, 0);
	angles[1] = (0, 0, 0);
	at[1] = 0.0500;
	points[2] = (2702.0825, -6412.0083, 0);
	angles[2] = (0, 0, 0);
	at[2] = 0.1000;
	points[3] = (2668.2795, -6412.0083, 0);
	angles[3] = (0, 0, 0);
	at[3] = 0.1500;
	points[4] = (2622.2007, -6412.0083, 0);
	angles[4] = (0, 0, 0);
	at[4] = 0.2000;
	points[5] = (2564.5708, -6412.0083, 0);
	angles[5] = (0, 0, 0);
	at[5] = 0.2500;
	points[6] = (2496.1104, -6412.0083, 0);
	angles[6] = (0, 0, 0);
	at[6] = 0.3000;
	points[7] = (2417.5474, -6412.0083, 0);
	angles[7] = (0, 0, 0);
	at[7] = 0.3500;
	points[8] = (2329.5984, -6412.0083, 0);
	angles[8] = (0, 0, 0);
	at[8] = 0.4000;
	points[9] = (2232.9844, -6412.0083, 0);
	angles[9] = (0, 0, 0);
	at[9] = 0.4500;
	points[10] = (2128.4331, -6412.0083, 0);
	angles[10] = (0, 0, 0);
	at[10] = 0.5000;
	points[11] = (2016.6654, -6412.0083, 0);
	angles[11] = (0, 0, 0);
	at[11] = 0.5500;
	points[12] = (1898.4015, -6412.0083, 0);
	angles[12] = (0, 0, 0);
	at[12] = 0.6000;
	points[13] = (1774.3583, -6412.0083, 0);
	angles[13] = (0, 0, 0);
	at[13] = 0.6500;
	points[14] = (1645.2677, -6412.0083, 0);
	angles[14] = (0, 0, 0);
	at[14] = 0.7000;
	points[15] = (1511.8386, -6412.0083, 0);
	angles[15] = (0, 0, 0);
	at[15] = 0.7500;
	points[16] = (1374.7992, -6412.0083, 0);
	angles[16] = (0, 0, 0);
	at[16] = 0.8000;
	points[17] = (1234.8779, -6412.0083, 0);
	angles[17] = (0, 0, 0);
	at[17] = 0.8500;
	points[18] = (1092.7914, -6412.0083, 0);
	angles[18] = (0, 0, 0);
	at[18] = 0.9000;
	points[19] = (660.7441, -6412.0083, 0);
	angles[19] = (0, 0, 0);
	at[19] = 1.0500;
	points[20] = (517.2126, -6412.0083, 0);
	angles[20] = (0, 0, 0);
	at[20] = 1.1000;
	points[21] = (375.1236, -6412.0083, 0);
	angles[21] = (0, 0, 0);
	at[21] = 1.1500;
	points[22] = (235.2000, -6412.0083, 0);
	angles[22] = (0, 0, 0);
	at[22] = 1.2000;
	points[23] = (98.1638, -6412.0083, 0);
	angles[23] = (0, 0, 0);
	at[23] = 1.2500;
	points[24] = (-35.2625, -6412.0083, 0);
	angles[24] = (0, 0, 0);
	at[24] = 1.3000;
	points[25] = (-164.3579, -6412.0083, 0);
	angles[25] = (0, 0, 0);
	at[25] = 1.3500;
	points[26] = (-288.4000, -6412.0083, 0);
	angles[26] = (0, 0, 0);
	at[26] = 1.4000;
	points[27] = (-406.6693, -6412.0083, 0);
	angles[27] = (0, 0, 0);
	at[27] = 1.4500;
	points[28] = (-518.4370, -6412.0083, 0);
	angles[28] = (0, 0, 0);
	at[28] = 1.5000;
	points[29] = (-622.9882, -6412.0083, 0);
	angles[29] = (0, 0, 0);
	at[29] = 1.5500;
	points[30] = (-719.5984, -6412.0083, 0);
	angles[30] = (0, 0, 0);
	at[30] = 1.6000;
	points[31] = (-807.5472, -6412.0083, 0);
	angles[31] = (0, 0, 0);
	at[31] = 1.6500;
	points[32] = (-886.1102, -6412.0083, 0);
	angles[32] = (0, 0, 0);
	at[32] = 1.7000;
	points[33] = (-954.5709, -6412.0083, 0);
	angles[33] = (0, 0, 0);
	at[33] = 1.7500;
	points[34] = (-1012.2008, -6412.0083, 0);
	angles[34] = (0, 0, 0);
	at[34] = 1.8000;
	points[35] = (-1058.2795, -6412.0083, 0);
	angles[35] = (0, 0, 0);
	at[35] = 1.8500;
	points[36] = (-1092.0906, -6412.0083, 0);
	angles[36] = (0, 0, 0);
	at[36] = 1.9000;
	points[37] = (-1112.9016, -6412.0083, 0);
	angles[37] = (0, 0, 0);
	at[37] = 1.9500;
	points[38] = (-1120, -6412.0083, 0);
	angles[38] = (0, 0, 0);
	at[38] = 2;
	points[39] = (-1112.9016, -6412.0083, 0);
	angles[39] = (0, 0, 0);
	at[39] = 2.0500;
	points[40] = (-1092.0826, -6412.0083, 0);
	angles[40] = (0, 0, 0);
	at[40] = 2.1000;
	points[41] = (-1058.2795, -6412.0083, 0);
	angles[41] = (0, 0, 0);
	at[41] = 2.1500;
	points[42] = (-1012.2008, -6412.0083, 0);
	angles[42] = (0, 0, 0);
	at[42] = 2.2000;
	points[43] = (-954.5709, -6412.0083, 0);
	angles[43] = (0, 0, 0);
	at[43] = 2.2500;
	points[44] = (-886.1141, -6412.0083, 0);
	angles[44] = (0, 0, 0);
	at[44] = 2.3000;
	points[45] = (-807.5472, -6412.0083, 0);
	angles[45] = (0, 0, 0);
	at[45] = 2.3500;
	points[46] = (-719.5984, -6412.0083, 0);
	angles[46] = (0, 0, 0);
	at[46] = 2.4000;
	points[47] = (-622.9882, -6412.0083, 0);
	angles[47] = (0, 0, 0);
	at[47] = 2.4500;
	points[48] = (-518.4370, -6412.0083, 0);
	angles[48] = (0, 0, 0);
	at[48] = 2.5000;
	points[49] = (-406.6653, -6412.0083, 0);
	angles[49] = (0, 0, 0);
	at[49] = 2.5500;
	points[50] = (-288.4000, -6412.0083, 0);
	angles[50] = (0, 0, 0);
	at[50] = 2.6000;
	points[51] = (-164.3579, -6412.0083, 0);
	angles[51] = (0, 0, 0);
	at[51] = 2.6500;
	points[52] = (-35.2622, -6412.0083, 0);
	angles[52] = (0, 0, 0);
	at[52] = 2.7000;
	points[53] = (98.1638, -6412.0083, 0);
	angles[53] = (0, 0, 0);
	at[53] = 2.7500;
	points[54] = (235.2000, -6412.0083, 0);
	angles[54] = (0, 0, 0);
	at[54] = 2.8000;
	points[55] = (375.1228, -6412.0083, 0);
	angles[55] = (0, 0, 0);
	at[55] = 2.8500;
	points[56] = (517.2126, -6412.0083, 0);
	angles[56] = (0, 0, 0);
	at[56] = 2.9000;
	points[57] = (949.2559, -6412.0083, 0);
	angles[57] = (0, 0, 0);
	at[57] = 3.0500;
	points[58] = (1092.7834, -6412.0083, 0);
	angles[58] = (0, 0, 0);
	at[58] = 3.1000;
	points[59] = (1234.8779, -6412.0083, 0);
	angles[59] = (0, 0, 0);
	at[59] = 3.1500;
	points[60] = (1374.7992, -6412.0083, 0);
	angles[60] = (0, 0, 0);
	at[60] = 3.2000;
	points[61] = (1511.8386, -6412.0083, 0);
	angles[61] = (0, 0, 0);
	at[61] = 3.2500;
	points[62] = (1645.2599, -6412.0083, 0);
	angles[62] = (0, 0, 0);
	at[62] = 3.3000;
	points[63] = (1774.3583, -6412.0083, 0);
	angles[63] = (0, 0, 0);
	at[63] = 3.3500;
	points[64] = (1898.4015, -6412.0083, 0);
	angles[64] = (0, 0, 0);
	at[64] = 3.4000;
	points[65] = (2016.6654, -6412.0083, 0);
	angles[65] = (0, 0, 0);
	at[65] = 3.4500;
	points[66] = (2128.4331, -6412.0083, 0);
	angles[66] = (0, 0, 0);
	at[66] = 3.5000;
	points[67] = (2232.9844, -6412.0083, 0);
	angles[67] = (0, 0, 0);
	at[67] = 3.5500;
	points[68] = (2329.5984, -6412.0083, 0);
	angles[68] = (0, 0, 0);
	at[68] = 3.6000;
	points[69] = (2417.5474, -6412.0083, 0);
	angles[69] = (0, 0, 0);
	at[69] = 3.6500;
	points[70] = (2496.1104, -6412.0083, 0);
	angles[70] = (0, 0, 0);
	at[70] = 3.7000;
	points[71] = (2564.5708, -6412.0083, 0);
	angles[71] = (0, 0, 0);
	at[71] = 3.7500;
	points[72] = (2622.2007, -6412.0083, 0);
	angles[72] = (0, 0, 0);
	at[72] = 3.8000;
	points[73] = (2668.2795, -6412.0083, 0);
	angles[73] = (0, 0, 0);
	at[73] = 3.8500;
	points[74] = (2702.0825, -6412.0083, 0);
	angles[74] = (0, 0, 0);
	at[74] = 3.9000;
	points[75] = (2722.9016, -6412.0083, 0);
	angles[75] = (0, 0, 0);
	at[75] = 3.9500;
	points[76] = (2730, -6412.0083, 0);
	angles[76] = (0, 0, 0);
	at[76] = 4;
	mover = getEnt("iz_mover2", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_play(points, angles, at, true, 2, 1);
}

iz_mover3()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-2730, -6412.0083, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2722.9016, -6412.0083, 0);
	angles[1] = (0, 0, 0);
	at[1] = 0.0500;
	points[2] = (-2702.0825, -6412.0083, 0);
	angles[2] = (0, 0, 0);
	at[2] = 0.1000;
	points[3] = (-2668.2795, -6412.0083, 0);
	angles[3] = (0, 0, 0);
	at[3] = 0.1500;
	points[4] = (-2622.2007, -6412.0083, 0);
	angles[4] = (0, 0, 0);
	at[4] = 0.2000;
	points[5] = (-2564.5708, -6412.0083, 0);
	angles[5] = (0, 0, 0);
	at[5] = 0.2500;
	points[6] = (-2496.1104, -6412.0083, 0);
	angles[6] = (0, 0, 0);
	at[6] = 0.3000;
	points[7] = (-2417.5474, -6412.0083, 0);
	angles[7] = (0, 0, 0);
	at[7] = 0.3500;
	points[8] = (-2329.5984, -6412.0083, 0);
	angles[8] = (0, 0, 0);
	at[8] = 0.4000;
	points[9] = (-2232.9844, -6412.0083, 0);
	angles[9] = (0, 0, 0);
	at[9] = 0.4500;
	points[10] = (-2128.4331, -6412.0083, 0);
	angles[10] = (0, 0, 0);
	at[10] = 0.5000;
	points[11] = (-2016.6654, -6412.0083, 0);
	angles[11] = (0, 0, 0);
	at[11] = 0.5500;
	points[12] = (-1898.4015, -6412.0083, 0);
	angles[12] = (0, 0, 0);
	at[12] = 0.6000;
	points[13] = (-1774.3583, -6412.0083, 0);
	angles[13] = (0, 0, 0);
	at[13] = 0.6500;
	points[14] = (-1645.2677, -6412.0083, 0);
	angles[14] = (0, 0, 0);
	at[14] = 0.7000;
	points[15] = (-1511.8386, -6412.0083, 0);
	angles[15] = (0, 0, 0);
	at[15] = 0.7500;
	points[16] = (-1374.7992, -6412.0083, 0);
	angles[16] = (0, 0, 0);
	at[16] = 0.8000;
	points[17] = (-1234.8779, -6412.0083, 0);
	angles[17] = (0, 0, 0);
	at[17] = 0.8500;
	points[18] = (-1092.7914, -6412.0083, 0);
	angles[18] = (0, 0, 0);
	at[18] = 0.9000;
	points[19] = (-660.7441, -6412.0083, 0);
	angles[19] = (0, 0, 0);
	at[19] = 1.0500;
	points[20] = (-517.2126, -6412.0083, 0);
	angles[20] = (0, 0, 0);
	at[20] = 1.1000;
	points[21] = (-375.1236, -6412.0083, 0);
	angles[21] = (0, 0, 0);
	at[21] = 1.1500;
	points[22] = (-235.2000, -6412.0083, 0);
	angles[22] = (0, 0, 0);
	at[22] = 1.2000;
	points[23] = (-98.1638, -6412.0083, 0);
	angles[23] = (0, 0, 0);
	at[23] = 1.2500;
	points[24] = (35.2625, -6412.0083, 0);
	angles[24] = (0, 0, 0);
	at[24] = 1.3000;
	points[25] = (164.3579, -6412.0083, 0);
	angles[25] = (0, 0, 0);
	at[25] = 1.3500;
	points[26] = (288.4000, -6412.0083, 0);
	angles[26] = (0, 0, 0);
	at[26] = 1.4000;
	points[27] = (406.6693, -6412.0083, 0);
	angles[27] = (0, 0, 0);
	at[27] = 1.4500;
	points[28] = (518.4370, -6412.0083, 0);
	angles[28] = (0, 0, 0);
	at[28] = 1.5000;
	points[29] = (622.9882, -6412.0083, 0);
	angles[29] = (0, 0, 0);
	at[29] = 1.5500;
	points[30] = (719.5984, -6412.0083, 0);
	angles[30] = (0, 0, 0);
	at[30] = 1.6000;
	points[31] = (807.5472, -6412.0083, 0);
	angles[31] = (0, 0, 0);
	at[31] = 1.6500;
	points[32] = (886.1102, -6412.0083, 0);
	angles[32] = (0, 0, 0);
	at[32] = 1.7000;
	points[33] = (954.5709, -6412.0083, 0);
	angles[33] = (0, 0, 0);
	at[33] = 1.7500;
	points[34] = (1012.2008, -6412.0083, 0);
	angles[34] = (0, 0, 0);
	at[34] = 1.8000;
	points[35] = (1058.2795, -6412.0083, 0);
	angles[35] = (0, 0, 0);
	at[35] = 1.8500;
	points[36] = (1092.0906, -6412.0083, 0);
	angles[36] = (0, 0, 0);
	at[36] = 1.9000;
	points[37] = (1112.9016, -6412.0083, 0);
	angles[37] = (0, 0, 0);
	at[37] = 1.9500;
	points[38] = (1120, -6412.0083, 0);
	angles[38] = (0, 0, 0);
	at[38] = 2;
	points[39] = (1112.9016, -6412.0083, 0);
	angles[39] = (0, 0, 0);
	at[39] = 2.0500;
	points[40] = (1092.0826, -6412.0083, 0);
	angles[40] = (0, 0, 0);
	at[40] = 2.1000;
	points[41] = (1058.2795, -6412.0083, 0);
	angles[41] = (0, 0, 0);
	at[41] = 2.1500;
	points[42] = (1012.2008, -6412.0083, 0);
	angles[42] = (0, 0, 0);
	at[42] = 2.2000;
	points[43] = (954.5709, -6412.0083, 0);
	angles[43] = (0, 0, 0);
	at[43] = 2.2500;
	points[44] = (886.1141, -6412.0083, 0);
	angles[44] = (0, 0, 0);
	at[44] = 2.3000;
	points[45] = (807.5472, -6412.0083, 0);
	angles[45] = (0, 0, 0);
	at[45] = 2.3500;
	points[46] = (719.5984, -6412.0083, 0);
	angles[46] = (0, 0, 0);
	at[46] = 2.4000;
	points[47] = (622.9882, -6412.0083, 0);
	angles[47] = (0, 0, 0);
	at[47] = 2.4500;
	points[48] = (518.4370, -6412.0083, 0);
	angles[48] = (0, 0, 0);
	at[48] = 2.5000;
	points[49] = (406.6653, -6412.0083, 0);
	angles[49] = (0, 0, 0);
	at[49] = 2.5500;
	points[50] = (288.4000, -6412.0083, 0);
	angles[50] = (0, 0, 0);
	at[50] = 2.6000;
	points[51] = (164.3579, -6412.0083, 0);
	angles[51] = (0, 0, 0);
	at[51] = 2.6500;
	points[52] = (35.2622, -6412.0083, 0);
	angles[52] = (0, 0, 0);
	at[52] = 2.7000;
	points[53] = (-98.1638, -6412.0083, 0);
	angles[53] = (0, 0, 0);
	at[53] = 2.7500;
	points[54] = (-235.2000, -6412.0083, 0);
	angles[54] = (0, 0, 0);
	at[54] = 2.8000;
	points[55] = (-375.1228, -6412.0083, 0);
	angles[55] = (0, 0, 0);
	at[55] = 2.8500;
	points[56] = (-517.2126, -6412.0083, 0);
	angles[56] = (0, 0, 0);
	at[56] = 2.9000;
	points[57] = (-949.2559, -6412.0083, 0);
	angles[57] = (0, 0, 0);
	at[57] = 3.0500;
	points[58] = (-1092.7834, -6412.0083, 0);
	angles[58] = (0, 0, 0);
	at[58] = 3.1000;
	points[59] = (-1234.8779, -6412.0083, 0);
	angles[59] = (0, 0, 0);
	at[59] = 3.1500;
	points[60] = (-1374.7992, -6412.0083, 0);
	angles[60] = (0, 0, 0);
	at[60] = 3.2000;
	points[61] = (-1511.8386, -6412.0083, 0);
	angles[61] = (0, 0, 0);
	at[61] = 3.2500;
	points[62] = (-1645.2599, -6412.0083, 0);
	angles[62] = (0, 0, 0);
	at[62] = 3.3000;
	points[63] = (-1774.3583, -6412.0083, 0);
	angles[63] = (0, 0, 0);
	at[63] = 3.3500;
	points[64] = (-1898.4015, -6412.0083, 0);
	angles[64] = (0, 0, 0);
	at[64] = 3.4000;
	points[65] = (-2016.6654, -6412.0083, 0);
	angles[65] = (0, 0, 0);
	at[65] = 3.4500;
	points[66] = (-2128.4331, -6412.0083, 0);
	angles[66] = (0, 0, 0);
	at[66] = 3.5000;
	points[67] = (-2232.9844, -6412.0083, 0);
	angles[67] = (0, 0, 0);
	at[67] = 3.5500;
	points[68] = (-2329.5984, -6412.0083, 0);
	angles[68] = (0, 0, 0);
	at[68] = 3.6000;
	points[69] = (-2417.5474, -6412.0083, 0);
	angles[69] = (0, 0, 0);
	at[69] = 3.6500;
	points[70] = (-2496.1104, -6412.0083, 0);
	angles[70] = (0, 0, 0);
	at[70] = 3.7000;
	points[71] = (-2564.5708, -6412.0083, 0);
	angles[71] = (0, 0, 0);
	at[71] = 3.7500;
	points[72] = (-2622.2007, -6412.0083, 0);
	angles[72] = (0, 0, 0);
	at[72] = 3.8000;
	points[73] = (-2668.2795, -6412.0083, 0);
	angles[73] = (0, 0, 0);
	at[73] = 3.8500;
	points[74] = (-2702.0825, -6412.0083, 0);
	angles[74] = (0, 0, 0);
	at[74] = 3.9000;
	points[75] = (-2722.9016, -6412.0083, 0);
	angles[75] = (0, 0, 0);
	at[75] = 3.9500;
	points[76] = (-2730, -6412.0083, 0);
	angles[76] = (0, 0, 0);
	at[76] = 4;
	mover = getEnt("iz_mover3", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_play(points, angles, at, true, 3, 1);
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
