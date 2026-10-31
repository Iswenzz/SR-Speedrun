main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_smb2_hoppers", 0);

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
}

iz_mover0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (128.8000, -6230, 260.4000);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (86.2126, -6230, 376.6433);
	angles[1] = (-7.0912, 0, 0);
	at[1] = 0.0500;
	points[2] = (43.8598, -6230, 485.6339);
	angles[2] = (-13.8260, 0, 0);
	at[2] = 0.1000;
	points[3] = (1.8931, -6230, 587.2598);
	angles[3] = (-20.1847, 0, 0);
	at[3] = 0.1500;
	points[4] = (-39.5370, -6230, 681.4055);
	angles[4] = (-26.1476, 0, 0);
	at[4] = 0.2000;
	points[5] = (-80.2803, -6230, 767.9567);
	angles[5] = (-31.6951, 0, 0);
	at[5] = 0.2500;
	points[6] = (-120.1850, -6230, 846.8032);
	angles[6] = (-36.8077, 0, 0);
	at[6] = 0.3000;
	points[7] = (-159.1008, -6230, 917.8347);
	angles[7] = (-41.4656, 0, 0);
	at[7] = 0.3500;
	points[8] = (-196.8772, -6230, 980.9291);
	angles[8] = (-45.6490, 0, 0);
	at[8] = 0.4000;
	points[9] = (-233.3638, -6230, 1035.9843);
	angles[9] = (-49.3384, 0, 0);
	at[9] = 0.4500;
	points[10] = (-268.4087, -6230, 1082.8859);
	angles[10] = (-52.5142, 0, 0);
	at[10] = 0.5000;
	points[11] = (-301.8626, -6230, 1121.5118);
	angles[11] = (-55.1567, 0, 0);
	at[11] = 0.5500;
	points[12] = (-333.5736, -6230, 1151.7520);
	angles[12] = (-57.2462, 0, 0);
	at[12] = 0.6000;
	points[13] = (-363.3918, -6230, 1173.4922);
	angles[13] = (-58.7629, 0, 0);
	at[13] = 0.6500;
	points[14] = (-391.1657, -6230, 1186.6338);
	angles[14] = (-59.6874, 0, 0);
	at[14] = 0.7000;
	points[15] = (-416.7441, -6230, 1191.0433);
	angles[15] = (-60, 0, 0);
	at[15] = 0.7500;
	points[16] = (-439.9803, -6230, 1187.1851);
	angles[16] = (-59.6501, 0, 0);
	at[16] = 0.8000;
	points[17] = (-460.7166, -6230, 1175.5118);
	angles[17] = (-58.6239, 0, 0);
	at[17] = 0.8500;
	points[18] = (-478.8071, -6230, 1155.9016);
	angles[18] = (-56.9571, 0, 0);
	at[18] = 0.9000;
	points[19] = (-494.1024, -6230, 1128.2520);
	angles[19] = (-54.6859, 0, 0);
	at[19] = 0.9500;
	points[20] = (-506.4488, -6230, 1092.4409);
	angles[20] = (-51.8452, 0, 0);
	at[20] = 1;
	points[21] = (-515.6929, -6230, 1048.3623);
	angles[21] = (-48.4715, 0, 0);
	at[21] = 1.0500;
	points[22] = (-521.6890, -6230, 995.8976);
	angles[22] = (-44.6001, 0, 0);
	at[22] = 1.1000;
	points[23] = (-524.3622, -6230, 934.9409);
	angles[23] = (-40.2668, 0, 0);
	at[23] = 1.1500;
	points[24] = (-525.8701, -6230, 865.3662);
	angles[24] = (-35.5073, 0, 0);
	at[24] = 1.2000;
	points[25] = (-526.3976, -6230, 787.0748);
	angles[25] = (-30.3572, 0, 0);
	at[25] = 1.2500;
	points[26] = (-524.7874, -6230, 699.9449);
	angles[26] = (-24.8525, 0, 0);
	at[26] = 1.3000;
	points[27] = (-519.8819, -6230, 603.8661);
	angles[27] = (-19.0287, 0, 0);
	at[27] = 1.3500;
	points[28] = (-510.5237, -6230, 498.7283);
	angles[28] = (-12.9216, 0, 0);
	at[28] = 1.4000;
	points[29] = (-495.5512, -6230, 384.4118);
	angles[29] = (-6.5667, 0, 0);
	at[29] = 1.4500;
	points[30] = (-473.8149, -6230, 260.8087);
	angles[30] = (0, 0, 0);
	at[30] = 1.5000;
	points[31] = (-446.5748, -6230, 386.0591);
	angles[31] = (6.5667, 0, 0);
	at[31] = 1.5500;
	points[32] = (-416.2087, -6230, 501.5906);
	angles[32] = (12.9216, 0, 0);
	at[32] = 1.6000;
	points[33] = (-383.2248, -6230, 607.5591);
	angles[33] = (19.0287, 0, 0);
	at[33] = 1.6500;
	points[34] = (-348.1213, -6230, 704.1299);
	angles[34] = (24.8525, 0, 0);
	at[34] = 1.7000;
	points[35] = (-311.4012, -6230, 791.4606);
	angles[35] = (30.3573, 0, 0);
	at[35] = 1.7500;
	points[36] = (-273.5693, -6230, 869.7086);
	angles[36] = (35.5073, 0, 0);
	at[36] = 1.8000;
	points[37] = (-235.1260, -6230, 939.0433);
	angles[37] = (40.2668, 0, 0);
	at[37] = 1.8500;
	points[38] = (-196.5760, -6230, 999.6142);
	angles[38] = (44.6001, 0, 0);
	at[38] = 1.9000;
	points[39] = (-158.4221, -6230, 1051.5906);
	angles[39] = (48.4715, 0, 0);
	at[39] = 1.9500;
	points[40] = (-121.1657, -6230, 1095.1299);
	angles[40] = (51.8454, 0, 0);
	at[40] = 2;
	points[41] = (-85.3110, -6230, 1130.3898);
	angles[41] = (54.6859, 0, 0);
	at[41] = 2.0500;
	points[42] = (-51.3606, -6230, 1157.5276);
	angles[42] = (56.9571, 0, 0);
	at[42] = 2.1000;
	points[43] = (-19.8169, -6230, 1176.7126);
	angles[43] = (58.6238, 0, 0);
	at[43] = 2.1500;
	points[44] = (8.8169, -6230, 1188.1023);
	angles[44] = (59.6501, 0, 0);
	at[44] = 2.2000;
	points[45] = (34.2280, -6230, 1191.8544);
	angles[45] = (60, 0, 0);
	at[45] = 2.2500;
	points[46] = (57.2429, -6230, 1187.9568);
	angles[46] = (59.6874, 0, 0);
	at[46] = 2.3000;
	points[47] = (78.0311, -6230, 1176.2166);
	angles[47] = (58.7629, 0, 0);
	at[47] = 2.3500;
	points[48] = (96.5937, -6230, 1156.5276);
	angles[48] = (57.2462, 0, 0);
	at[48] = 2.4000;
	points[49] = (112.9319, -6230, 1128.7795);
	angles[49] = (55.1567, 0, 0);
	at[49] = 2.4500;
	points[50] = (127.0457, -6230, 1092.8622);
	angles[50] = (52.5142, 0, 0);
	at[50] = 2.5000;
	points[51] = (138.9366, -6230, 1048.6693);
	angles[51] = (49.3384, 0, 0);
	at[51] = 2.5500;
	points[52] = (148.6059, -6230, 996.0866);
	angles[52] = (45.6490, 0, 0);
	at[52] = 2.6000;
	points[53] = (156.0531, -6230, 935.0118);
	angles[53] = (41.4656, 0, 0);
	at[53] = 2.6500;
	points[54] = (161.2807, -6230, 865.3268);
	angles[54] = (36.8077, 0, 0);
	at[54] = 2.7000;
	points[55] = (164.2878, -6230, 786.9252);
	angles[55] = (31.6951, 0, 0);
	at[55] = 2.7500;
	points[56] = (165.0768, -6230, 699.7047);
	angles[56] = (26.1476, 0, 0);
	at[56] = 2.8000;
	points[57] = (163.6480, -6230, 603.5512);
	angles[57] = (20.1847, 0, 0);
	at[57] = 2.8500;
	points[58] = (159.7433, -6230, 498.3543);
	angles[58] = (13.8259, 0, 0);
	at[58] = 2.9000;
	points[59] = (149.8673, -6230, 384.0083);
	angles[59] = (7.0912, 0, 0);
	at[59] = 2.9500;
	points[60] = (128.8000, -6230, 260.4000);
	angles[60] = (0, 0, 0);
	at[60] = 3;
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
	points[0] = (-473.8149, -4830, 260.8087);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-446.5748, -4830, 386.0591);
	angles[1] = (6.5667, 0, 0);
	at[1] = 0.0500;
	points[2] = (-416.2087, -4830, 501.5906);
	angles[2] = (12.9216, 0, 0);
	at[2] = 0.1000;
	points[3] = (-383.2248, -4830, 607.5591);
	angles[3] = (19.0287, 0, 0);
	at[3] = 0.1500;
	points[4] = (-348.1213, -4830, 704.1299);
	angles[4] = (24.8525, 0, 0);
	at[4] = 0.2000;
	points[5] = (-311.4012, -4830, 791.4606);
	angles[5] = (30.3573, 0, 0);
	at[5] = 0.2500;
	points[6] = (-273.5693, -4830, 869.7086);
	angles[6] = (35.5073, 0, 0);
	at[6] = 0.3000;
	points[7] = (-235.1260, -4830, 939.0433);
	angles[7] = (40.2668, 0, 0);
	at[7] = 0.3500;
	points[8] = (-196.5760, -4830, 999.6142);
	angles[8] = (44.6001, 0, 0);
	at[8] = 0.4000;
	points[9] = (-158.4221, -4830, 1051.5906);
	angles[9] = (48.4715, 0, 0);
	at[9] = 0.4500;
	points[10] = (-121.1657, -4830, 1095.1299);
	angles[10] = (51.8454, 0, 0);
	at[10] = 0.5000;
	points[11] = (-85.3110, -4830, 1130.3898);
	angles[11] = (54.6859, 0, 0);
	at[11] = 0.5500;
	points[12] = (-51.3606, -4830, 1157.5276);
	angles[12] = (56.9571, 0, 0);
	at[12] = 0.6000;
	points[13] = (-19.8170, -4830, 1176.7126);
	angles[13] = (58.6238, 0, 0);
	at[13] = 0.6500;
	points[14] = (8.8168, -4830, 1188.1023);
	angles[14] = (59.6501, 0, 0);
	at[14] = 0.7000;
	points[15] = (34.2280, -4830, 1191.8544);
	angles[15] = (60, 0, 0);
	at[15] = 0.7500;
	points[16] = (57.2425, -4830, 1187.9568);
	angles[16] = (59.6874, 0, 0);
	at[16] = 0.8000;
	points[17] = (78.0311, -4830, 1176.2166);
	angles[17] = (58.7629, 0, 0);
	at[17] = 0.8500;
	points[18] = (96.5937, -4830, 1156.5276);
	angles[18] = (57.2462, 0, 0);
	at[18] = 0.9000;
	points[19] = (112.9319, -4830, 1128.7795);
	angles[19] = (55.1567, 0, 0);
	at[19] = 0.9500;
	points[20] = (127.0457, -4830, 1092.8622);
	angles[20] = (52.5142, 0, 0);
	at[20] = 1;
	points[21] = (138.9366, -4830, 1048.6693);
	angles[21] = (49.3384, 0, 0);
	at[21] = 1.0500;
	points[22] = (148.6059, -4830, 996.0866);
	angles[22] = (45.6490, 0, 0);
	at[22] = 1.1000;
	points[23] = (156.0531, -4830, 935.0118);
	angles[23] = (41.4656, 0, 0);
	at[23] = 1.1500;
	points[24] = (161.2807, -4830, 865.3268);
	angles[24] = (36.8077, 0, 0);
	at[24] = 1.2000;
	points[25] = (164.2878, -4830, 786.9252);
	angles[25] = (31.6951, 0, 0);
	at[25] = 1.2500;
	points[26] = (165.0768, -4830, 699.7047);
	angles[26] = (26.1476, 0, 0);
	at[26] = 1.3000;
	points[27] = (163.6480, -4830, 603.5512);
	angles[27] = (20.1847, 0, 0);
	at[27] = 1.3500;
	points[28] = (159.7433, -4830, 498.3543);
	angles[28] = (13.8260, 0, 0);
	at[28] = 1.4000;
	points[29] = (149.8673, -4830, 384.0083);
	angles[29] = (7.0912, 0, 0);
	at[29] = 1.4500;
	points[30] = (128.8000, -4830, 260.4000);
	angles[30] = (0, 0, 0);
	at[30] = 1.5000;
	points[31] = (86.2126, -4830, 385.6138);
	angles[31] = (-7.0912, 0, 0);
	at[31] = 1.5500;
	points[32] = (43.8598, -4830, 501.1024);
	angles[32] = (-13.8260, 0, 0);
	at[32] = 1.6000;
	points[33] = (1.8931, -4830, 607.0315);
	angles[33] = (-20.1847, 0, 0);
	at[33] = 1.6500;
	points[34] = (-39.5370, -4830, 703.5551);
	angles[34] = (-26.1476, 0, 0);
	at[34] = 1.7000;
	points[35] = (-80.2803, -4830, 790.8386);
	angles[35] = (-31.6951, 0, 0);
	at[35] = 1.7500;
	points[36] = (-120.1843, -4830, 869.0512);
	angles[36] = (-36.8077, 0, 0);
	at[36] = 1.8000;
	points[37] = (-159.1008, -4830, 938.3347);
	angles[37] = (-41.4656, 0, 0);
	at[37] = 1.8500;
	points[38] = (-196.8772, -4830, 998.8701);
	angles[38] = (-45.6490, 0, 0);
	at[38] = 1.9000;
	points[39] = (-233.3638, -4830, 1050.8188);
	angles[39] = (-49.3384, 0, 0);
	at[39] = 1.9500;
	points[40] = (-268.4087, -4830, 1094.3229);
	angles[40] = (-52.5142, 0, 0);
	at[40] = 2;
	points[41] = (-301.8626, -4830, 1129.5630);
	angles[41] = (-55.1567, 0, 0);
	at[41] = 2.0500;
	points[42] = (-333.5736, -4830, 1156.6929);
	angles[42] = (-57.2461, 0, 0);
	at[42] = 2.1000;
	points[43] = (-363.3918, -4830, 1175.8740);
	angles[43] = (-58.7629, 0, 0);
	at[43] = 2.1500;
	points[44] = (-391.1657, -4830, 1187.2717);
	angles[44] = (-59.6874, 0, 0);
	at[44] = 2.2000;
	points[45] = (-416.7441, -4830, 1191.0433);
	angles[45] = (-60, 0, 0);
	at[45] = 2.2500;
	points[46] = (-439.9803, -4830, 1187.1851);
	angles[46] = (-59.6501, 0, 0);
	at[46] = 2.3000;
	points[47] = (-460.7166, -4830, 1175.5118);
	angles[47] = (-58.6239, 0, 0);
	at[47] = 2.3500;
	points[48] = (-478.8071, -4830, 1155.9016);
	angles[48] = (-56.9571, 0, 0);
	at[48] = 2.4000;
	points[49] = (-494.1024, -4830, 1128.2520);
	angles[49] = (-54.6859, 0, 0);
	at[49] = 2.4500;
	points[50] = (-506.4488, -4830, 1092.4409);
	angles[50] = (-51.8452, 0, 0);
	at[50] = 2.5000;
	points[51] = (-515.6929, -4830, 1048.3623);
	angles[51] = (-48.4715, 0, 0);
	at[51] = 2.5500;
	points[52] = (-521.6890, -4830, 995.8976);
	angles[52] = (-44.6001, 0, 0);
	at[52] = 2.6000;
	points[53] = (-524.3622, -4830, 934.9409);
	angles[53] = (-40.2668, 0, 0);
	at[53] = 2.6500;
	points[54] = (-525.8701, -4830, 865.3662);
	angles[54] = (-35.5073, 0, 0);
	at[54] = 2.7000;
	points[55] = (-526.3976, -4830, 787.0748);
	angles[55] = (-30.3572, 0, 0);
	at[55] = 2.7500;
	points[56] = (-524.7874, -4830, 699.9449);
	angles[56] = (-24.8525, 0, 0);
	at[56] = 2.8000;
	points[57] = (-519.8819, -4830, 603.8701);
	angles[57] = (-19.0287, 0, 0);
	at[57] = 2.8500;
	points[58] = (-510.5237, -4830, 498.7283);
	angles[58] = (-12.9216, 0, 0);
	at[58] = 2.9000;
	points[59] = (-495.5512, -4830, 384.4118);
	angles[59] = (-6.5667, 0, 0);
	at[59] = 2.9500;
	points[60] = (-473.8149, -4830, 260.8087);
	angles[60] = (0, 0, 0);
	at[60] = 3;
	mover = getEnt("iz_mover1", "targetname");
	if (!isDefined(mover))
		return;
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
