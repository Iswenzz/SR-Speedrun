main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_smb1_coffee_cup", 0);

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
	ambientPlay("iz_0_st8", 2);
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
	thread iz_bumper("iz_bumper29", true);
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
	points[0] = (0, -875, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-16.7465, -874.5433, 0);
	angles[1] = (0, 5.4005, 0);
	at[1] = 0.0500;
	points[2] = (-51.4902, -873.1851, 0);
	angles[2] = (0, 10.8011, 0);
	at[2] = 0.1000;
	points[3] = (-82.2850, -870.9489, 0);
	angles[3] = (0, 16.2016, 0);
	at[3] = 0.1500;
	points[4] = (-109.5870, -867.8268, 0);
	angles[4] = (0, 21.6022, 0);
	at[4] = 0.2000;
	points[5] = (-163.8071, -858.9921, 0);
	angles[5] = (0, 32.4032, 0);
	at[5] = 0.3000;
	points[6] = (-190.6976, -853.2992, 0);
	angles[6] = (0, 37.8038, 0);
	at[6] = 0.3500;
	points[7] = (-243.8535, -839.4489, 0);
	angles[7] = (0, 48.6049, 0);
	at[7] = 0.4500;
	points[8] = (-296.0665, -822.3544, 0);
	angles[8] = (0, 59.4060, 0);
	at[8] = 0.5500;
	points[9] = (-347.1516, -802.0945, 0);
	angles[9] = (0, 70.2070, 0);
	at[9] = 0.6500;
	points[10] = (-396.8937, -778.7717, 0);
	angles[10] = (0, 81.0081, 0);
	at[10] = 0.7500;
	points[11] = (-421.2047, -765.9764, 0);
	angles[11] = (0, 86.4086, 0);
	at[11] = 0.8000;
	points[12] = (-468.6024, -738.1772, 0);
	angles[12] = (0, 97.2097, 0);
	at[12] = 0.9000;
	points[13] = (-491.6142, -723.1968, 0);
	angles[13] = (0, 102.6102, 0);
	at[13] = 0.9500;
	points[14] = (-536.2166, -691.0905, 0);
	angles[14] = (0, 113.4114, 0);
	at[14] = 1.0500;
	points[15] = (-557.7087, -674, 0);
	angles[15] = (0, 118.8119, 0);
	at[15] = 1.1000;
	points[16] = (-599.0236, -637.7756, 0);
	angles[16] = (0, 129.6129, 0);
	at[16] = 1.2000;
	points[17] = (-618.7559, -618.6653, 0);
	angles[17] = (0, 135.0135, 0);
	at[17] = 1.2500;
	points[18] = (-637.8701, -598.9134, 0);
	angles[18] = (0, 140.4140, 0);
	at[18] = 1.3000;
	points[19] = (-674.0827, -557.6102, 0);
	angles[19] = (0, 151.2151, 0);
	at[19] = 1.4000;
	points[20] = (-707.5748, -514.0630, 0);
	angles[20] = (0, 162.0162, 0);
	at[20] = 1.5000;
	points[21] = (-723.2678, -491.5000, 0);
	angles[21] = (0, 167.4167, 0);
	at[21] = 1.5500;
	points[22] = (-752.5157, -445, 0);
	angles[22] = (0, 178.2178, 0);
	at[22] = 1.6500;
	points[23] = (-766.0433, -421.0748, 0);
	angles[23] = (0, 183.6184, 0);
	at[23] = 1.7000;
	points[24] = (-790.8740, -372.0705, 0);
	angles[24] = (0, 194.4195, 0);
	at[24] = 1.8000;
	points[25] = (-812.6575, -321.6417, 0);
	angles[25] = (0, 205.2205, 0);
	at[25] = 1.9000;
	points[26] = (-831.3425, -269.9650, 0);
	angles[26] = (0, 216.0216, 0);
	at[26] = 2;
	points[27] = (-839.4803, -243.7295, 0);
	angles[27] = (0, 221.4221, 0);
	at[27] = 2.0500;
	points[28] = (-846.8188, -217.2413, 0);
	angles[28] = (0, 226.8226, 0);
	at[28] = 2.1000;
	points[29] = (-859.0197, -163.6776, 0);
	angles[29] = (0, 237.6237, 0);
	at[29] = 2.2000;
	points[30] = (-867.8386, -109.4583, 0);
	angles[30] = (0, 248.4248, 0);
	at[30] = 2.3000;
	points[31] = (-870.9606, -82.1492, 0);
	angles[31] = (0, 253.8253, 0);
	at[31] = 2.3500;
	points[32] = (-873.2008, -54.7724, 0);
	angles[32] = (0, 259.2259, 0);
	at[32] = 2.4000;
	points[33] = (-874.9921, 0.1475, 0);
	angles[33] = (0, 270.0270, 0);
	at[33] = 2.5000;
	points[34] = (-874.5433, 27.6008, 0);
	angles[34] = (0, 275.4275, 0);
	at[34] = 2.5500;
	points[35] = (-870.9252, 82.4374, 0);
	angles[35] = (0, 286.2287, 0);
	at[35] = 2.6500;
	points[36] = (-867.8110, 109.7173, 0);
	angles[36] = (0, 291.6291, 0);
	at[36] = 2.7000;
	points[37] = (-858.9645, 163.9504, 0);
	angles[37] = (0, 302.4303, 0);
	at[37] = 2.8000;
	points[38] = (-846.7480, 217.5236, 0);
	angles[38] = (0, 313.2313, 0);
	at[38] = 2.9000;
	points[39] = (-839.4055, 243.9850, 0);
	angles[39] = (0, 318.6320, 0);
	at[39] = 2.9500;
	points[40] = (-822.2952, 296.2087, 0);
	angles[40] = (0, 329.4329, 0);
	at[40] = 3.0500;
	points[41] = (-802.0394, 347.2772, 0);
	angles[41] = (0, 340.2341, 0);
	at[41] = 3.1500;
	points[42] = (-790.7559, 372.3209, 0);
	angles[42] = (0, 345.6346, 0);
	at[42] = 3.2000;
	points[43] = (-765.9055, 421.3346, 0);
	angles[43] = (0, 356.4357, 0);
	at[43] = 3.3000;
	points[44] = (-738.1063, 468.7126, 0);
	angles[44] = (0, 367.2368, 0);
	at[44] = 3.4000;
	points[45] = (-723.1142, 491.7402, 0);
	angles[45] = (0, 372.6372, 0);
	at[45] = 3.4500;
	points[46] = (-691.0040, 536.3228, 0);
	angles[46] = (0, 383.4384, 0);
	at[46] = 3.5500;
	points[47] = (-673.9095, 557.8229, 0);
	angles[47] = (0, 388.8390, 0);
	at[47] = 3.6000;
	points[48] = (-637.6732, 599.1299, 0);
	angles[48] = (0, 399.6400, 0);
	at[48] = 3.7000;
	points[49] = (-618.5748, 618.8583, 0);
	angles[49] = (0, 405.0405, 0);
	at[49] = 3.7500;
	points[50] = (-598.8189, 637.9607, 0);
	angles[50] = (0, 410.4412, 0);
	at[50] = 3.8000;
	points[51] = (-557.5079, 674.1693, 0);
	angles[51] = (0, 421.2422, 0);
	at[51] = 3.9000;
	points[52] = (-513.9410, 707.6575, 0);
	angles[52] = (0, 432.0432, 0);
	at[52] = 4;
	points[53] = (-491.3937, 723.3464, 0);
	angles[53] = (0, 437.4438, 0);
	at[53] = 4.0500;
	points[54] = (-444.8819, 752.5827, 0);
	angles[54] = (0, 448.2449, 0);
	at[54] = 4.1500;
	points[55] = (-420.9606, 766.1063, 0);
	angles[55] = (0, 453.6453, 0);
	at[55] = 4.2000;
	points[56] = (-371.9512, 790.9291, 0);
	angles[56] = (0, 464.4464, 0);
	at[56] = 4.3000;
	points[57] = (-346.8862, 802.2087, 0);
	angles[57] = (0, 469.8469, 0);
	at[57] = 4.3500;
	points[58] = (-295.8150, 822.4370, 0);
	angles[58] = (0, 480.6481, 0);
	at[58] = 4.4500;
	points[59] = (-243.5980, 839.5157, 0);
	angles[59] = (0, 491.4492, 0);
	at[59] = 4.5500;
	points[60] = (-217.1134, 846.8543, 0);
	angles[60] = (0, 496.8497, 0);
	at[60] = 4.6000;
	points[61] = (-163.5488, 859.0394, 0);
	angles[61] = (0, 507.6507, 0);
	at[61] = 4.7000;
	points[62] = (-109.3134, 867.8583, 0);
	angles[62] = (0, 518.4518, 0);
	at[62] = 4.8000;
	points[63] = (-82.0205, 870.9685, 0);
	angles[63] = (0, 523.8524, 0);
	at[63] = 4.8500;
	points[64] = (-27.2007, 874.5512, 0);
	angles[64] = (0, 534.6534, 0);
	at[64] = 4.9500;
	points[65] = (0.2771, 874.9921, 0);
	angles[65] = (0, 540.0540, 0);
	at[65] = 5;
	points[66] = (27.7541, 874.5315, 0);
	angles[66] = (0, 545.4546, 0);
	at[66] = 5.0500;
	points[67] = (82.5721, 870.9173, 0);
	angles[67] = (0, 556.2556, 0);
	at[67] = 5.1500;
	points[68] = (109.8622, 867.7914, 0);
	angles[68] = (0, 561.6562, 0);
	at[68] = 5.2000;
	points[69] = (164.0933, 858.9331, 0);
	angles[69] = (0, 572.4573, 0);
	at[69] = 5.3000;
	points[70] = (190.9567, 853.2441, 0);
	angles[70] = (0, 577.8577, 0);
	at[70] = 5.3500;
	points[71] = (244.1299, 839.3622, 0);
	angles[71] = (0, 588.6589, 0);
	at[71] = 5.4500;
	points[72] = (270.3520, 831.2166, 0);
	angles[72] = (0, 594.0594, 0);
	at[72] = 5.5000;
	points[73] = (322.0205, 812.5118, 0);
	angles[73] = (0, 604.8605, 0);
	at[73] = 5.6000;
	points[74] = (372.4532, 790.6929, 0);
	angles[74] = (0, 615.6617, 0);
	at[74] = 5.7000;
	points[75] = (421.4488, 765.8425, 0);
	angles[75] = (0, 626.4627, 0);
	at[75] = 5.8000;
	points[76] = (445.3583, 752.3032, 0);
	angles[76] = (0, 631.8632, 0);
	at[76] = 5.8500;
	points[77] = (491.8543, 723.0355, 0);
	angles[77] = (0, 642.6642, 0);
	at[77] = 5.9500;
	points[78] = (536.4213, 690.9252, 0);
	angles[78] = (0, 653.4655, 0);
	at[78] = 6.0500;
	points[79] = (557.9370, 673.8189, 0);
	angles[79] = (0, 658.8660, 0);
	at[79] = 6.1000;
	points[80] = (578.8622, 656.0433, 0);
	angles[80] = (0, 664.2664, 0);
	at[80] = 6.1500;
	points[81] = (618.9685, 618.4685, 0);
	angles[81] = (0, 675.0675, 0);
	at[81] = 6.2500;
	points[82] = (638.0511, 598.7283, 0);
	angles[82] = (0, 680.4681, 0);
	at[82] = 6.3000;
	points[83] = (674.2598, 557.3976, 0);
	angles[83] = (0, 691.2692, 0);
	at[83] = 6.4000;
	points[84] = (691.3425, 535.8858, 0);
	angles[84] = (0, 696.6697, 0);
	at[84] = 6.4500;
	points[85] = (723.4213, 491.2834, 0);
	angles[85] = (0, 707.4708, 0);
	at[85] = 6.5500;
	points[86] = (738.4016, 468.2441, 0);
	angles[86] = (0, 712.8713, 0);
	at[86] = 6.6000;
	points[87] = (766.1693, 420.8465, 0);
	angles[87] = (0, 723.6724, 0);
	at[87] = 6.7000;
	points[88] = (790.9843, 371.8213, 0);
	angles[88] = (0, 734.4736, 0);
	at[88] = 6.8000;
	points[89] = (812.7638, 321.3721, 0);
	angles[89] = (0, 745.2745, 0);
	at[89] = 6.9000;
	points[90] = (831.4252, 269.7032, 0);
	angles[90] = (0, 756.0756, 0);
	at[90] = 7;
	points[91] = (839.5670, 243.4559, 0);
	angles[91] = (0, 761.4763, 0);
	at[91] = 7.0500;
	points[92] = (853.3976, 190.2850, 0);
	angles[92] = (0, 772.2772, 0);
	at[92] = 7.1500;
	points[93] = (859.0669, 163.4095, 0);
	angles[93] = (0, 777.6777, 0);
	at[93] = 7.2000;
	points[94] = (867.8820, 109.1693, 0);
	angles[94] = (0, 788.4789, 0);
	at[94] = 7.3000;
	points[95] = (870.9803, 81.8882, 0);
	angles[95] = (0, 793.8794, 0);
	at[95] = 7.3500;
	points[96] = (874.5591, 27.0498, 0);
	angles[96] = (0, 804.6805, 0);
	at[96] = 7.4500;
	points[97] = (874.9921, -0.4041, 0);
	angles[97] = (0, 810.0811, 0);
	at[97] = 7.5000;
	points[98] = (873.1653, -55.3220, 0);
	angles[98] = (0, 820.8821, 0);
	at[98] = 7.6000;
	points[99] = (870.9055, -82.6972, 0);
	angles[99] = (0, 826.2828, 0);
	at[99] = 7.6500;
	points[100] = (863.7717, -137.1705, 0);
	angles[100] = (0, 837.0837, 0);
	at[100] = 7.7500;
	points[101] = (858.9055, -164.2185, 0);
	angles[101] = (0, 842.4843, 0);
	at[101] = 7.8000;
	points[102] = (846.6851, -217.7740, 0);
	angles[102] = (0, 853.2854, 0);
	at[102] = 7.9000;
	points[103] = (839.3267, -244.2579, 0);
	angles[103] = (0, 858.6860, 0);
	at[103] = 7.9500;
	points[104] = (831.1654, -270.4878, 0);
	angles[104] = (0, 864.0864, 0);
	at[104] = 8;
	points[105] = (812.4567, -322.1539, 0);
	angles[105] = (0, 874.8876, 0);
	at[105] = 8.1000;
	points[106] = (790.6378, -372.5693, 0);
	angles[106] = (0, 885.6886, 0);
	at[106] = 8.2000;
	points[107] = (765.7795, -421.5591, 0);
	angles[107] = (0, 896.4897, 0);
	at[107] = 8.3000;
	points[108] = (737.9606, -468.9410, 0);
	angles[108] = (0, 907.2906, 0);
	at[108] = 8.4000;
	points[109] = (722.9685, -491.9567, 0);
	angles[109] = (0, 912.6913, 0);
	at[109] = 8.4500;
	points[110] = (707.2520, -514.5079, 0);
	angles[110] = (0, 918.0918, 0);
	at[110] = 8.5000;
	points[111] = (673.7323, -558.0355, 0);
	angles[111] = (0, 928.8929, 0);
	at[111] = 8.6000;
	points[112] = (655.9449, -578.9803, 0);
	angles[112] = (0, 934.2933, 0);
	at[112] = 8.6500;
	points[113] = (618.3661, -619.0551, 0);
	angles[113] = (0, 945.0946, 0);
	at[113] = 8.7500;
	points[114] = (598.6221, -638.1496, 0);
	angles[114] = (0, 950.4951, 0);
	at[114] = 8.8000;
	points[115] = (557.2795, -674.3504, 0);
	angles[115] = (0, 961.2960, 0);
	at[115] = 8.9000;
	points[116] = (535.7795, -691.4252, 0);
	angles[116] = (0, 966.6967, 0);
	at[116] = 8.9500;
	points[117] = (491.1575, -723.5000, 0);
	angles[117] = (0, 977.4977, 0);
	at[117] = 9.0500;
	points[118] = (468.1339, -738.4725, 0);
	angles[118] = (0, 982.8983, 0);
	at[118] = 9.1000;
	points[119] = (420.7205, -766.2402, 0);
	angles[119] = (0, 993.6995, 0);
	at[119] = 9.2000;
	points[120] = (396.4016, -779.0158, 0);
	angles[120] = (0, 999.0999, 0);
	at[120] = 9.2500;
	points[121] = (346.6457, -802.3110, 0);
	angles[121] = (0, 1009.9011, 0);
	at[121] = 9.3500;
	points[122] = (295.5496, -822.5355, 0);
	angles[122] = (0, 1020.7020, 0);
	at[122] = 9.4500;
	points[123] = (243.3264, -839.6024, 0);
	angles[123] = (0, 1031.5033, 0);
	at[123] = 9.5500;
	points[124] = (216.8516, -846.9213, 0);
	angles[124] = (0, 1036.9037, 0);
	at[124] = 9.6000;
	points[125] = (163.2673, -859.0945, 0);
	angles[125] = (0, 1047.7047, 0);
	at[125] = 9.7000;
	points[126] = (109.0417, -867.8937, 0);
	angles[126] = (0, 1058.5059, 0);
	at[126] = 9.8000;
	points[127] = (81.7382, -871.0040, 0);
	angles[127] = (0, 1063.9064, 0);
	at[127] = 9.8500;
	points[128] = (50.7697, -873.2205, 0);
	angles[128] = (0, 1069.3069, 0);
	at[128] = 9.9000;
	points[129] = (16.1577, -874.5591, 0);
	angles[129] = (0, 1074.7075, 0);
	at[129] = 9.9500;
	points[130] = (0, -875, 0);
	angles[130] = (0, 1080, 0);
	at[130] = 10;
	mover = getEnt("iz_mover0", "targetname");
	if (!isDefined(mover))
		return;
	rider = getEnt("endmap_trig", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	rider = getEnt("iz_bumper0_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	rider = getEnt("iz_bumper1_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	rider = getEnt("iz_bumper2_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	rider = getEnt("iz_bumper3_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	rider = getEnt("iz_bumper4_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	rider = getEnt("iz_bumper5_touch", "targetname");
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
	points[0] = (-757.0551, -437.1496, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-765.0157, -422.4055, 0);
	angles[1] = (0, 5.4005, 0);
	at[1] = 0.0500;
	points[2] = (-781.1851, -391.6256, 0);
	angles[2] = (0, 10.8011, 0);
	at[2] = 0.1000;
	points[3] = (-794.6732, -363.8481, 0);
	angles[3] = (0, 16.2016, 0);
	at[3] = 0.1500;
	points[4] = (-815.9607, -313.1827, 0);
	angles[4] = (0, 27.0027, 0);
	at[4] = 0.2500;
	points[5] = (-834.1181, -261.3287, 0);
	angles[5] = (0, 37.8038, 0);
	at[5] = 0.3500;
	points[6] = (-849.0590, -208.4669, 0);
	angles[6] = (0, 48.6049, 0);
	at[6] = 0.4500;
	points[7] = (-855.3032, -181.6996, 0);
	angles[7] = (0, 54.0055, 0);
	at[7] = 0.5000;
	points[8] = (-865.2637, -127.6764, 0);
	angles[8] = (0, 64.8066, 0);
	at[8] = 0.6000;
	points[9] = (-868.9645, -100.4465, 0);
	angles[9] = (0, 70.2070, 0);
	at[9] = 0.6500;
	points[10] = (-873.7402, -45.7154, 0);
	angles[10] = (0, 81.0081, 0);
	at[10] = 0.7500;
	points[11] = (-874.7913, -18.2683, 0);
	angles[11] = (0, 86.4086, 0);
	at[11] = 0.8000;
	points[12] = (-874.9370, 9.1989, 0);
	angles[12] = (0, 91.8092, 0);
	at[12] = 0.8500;
	points[13] = (-872.5354, 64.0839, 0);
	angles[13] = (0, 102.6102, 0);
	at[13] = 0.9500;
	points[14] = (-869.9961, 91.4465, 0);
	angles[14] = (0, 108.0107, 0);
	at[14] = 1;
	points[15] = (-862.3071, 145.8402, 0);
	angles[15] = (0, 118.8119, 0);
	at[15] = 1.1000;
	points[16] = (-857.1772, 172.8433, 0);
	angles[16] = (0, 124.2124, 0);
	at[16] = 1.1500;
	points[17] = (-844.4174, 226.2728, 0);
	angles[17] = (0, 135.0135, 0);
	at[17] = 1.2500;
	points[18] = (-828.4213, 278.7681, 0);
	angles[18] = (0, 145.8145, 0);
	at[18] = 1.3500;
	points[19] = (-819.4567, 304.2150, 0);
	angles[19] = (0, 151.2151, 0);
	at[19] = 1.4000;
	points[20] = (-809.3898, 329.9315, 0);
	angles[20] = (0, 156.6158, 0);
	at[20] = 1.4500;
	points[21] = (-797.2599, 357.5662, 0);
	angles[21] = (0, 162.0162, 0);
	at[21] = 1.5000;
	points[22] = (-783.2086, 386.8815, 0);
	angles[22] = (0, 167.4167, 0);
	at[22] = 1.5500;
	points[23] = (-770.0197, 413.0118, 0);
	angles[23] = (0, 172.8173, 0);
	at[23] = 1.6000;
	points[24] = (-760.0040, 431.9134, 0);
	angles[24] = (0, 178.2178, 0);
	at[24] = 1.6500;
	points[25] = (-750.6653, 447.9292, 0);
	angles[25] = (0, 183.6184, 0);
	at[25] = 1.7000;
	points[26] = (-737.8425, 468.3268, 0);
	angles[26] = (0, 189.0189, 0);
	at[26] = 1.7500;
	points[27] = (-720.8464, 494.2874, 0);
	angles[27] = (0, 194.4195, 0);
	at[27] = 1.8000;
	points[28] = (-702.5118, 520.8544, 0);
	angles[28] = (0, 199.8200, 0);
	at[28] = 1.8500;
	points[29] = (-685.1221, 544.0276, 0);
	angles[29] = (0, 205.2205, 0);
	at[29] = 1.9000;
	points[30] = (-667.9134, 565.1496, 0);
	angles[30] = (0, 210.6210, 0);
	at[30] = 1.9500;
	points[31] = (-631.4410, 605.6968, 0);
	angles[31] = (0, 221.4221, 0);
	at[31] = 2.0500;
	points[32] = (-592.1693, 644.1142, 0);
	angles[32] = (0, 232.2233, 0);
	at[32] = 2.1500;
	points[33] = (-571.6024, 662.3386, 0);
	angles[33] = (0, 237.6237, 0);
	at[33] = 2.2000;
	points[34] = (-528.7795, 696.7441, 0);
	angles[34] = (0, 248.4248, 0);
	at[34] = 2.3000;
	points[35] = (-506.5512, 712.9134, 0);
	angles[35] = (0, 253.8253, 0);
	at[35] = 2.3500;
	points[36] = (-460.6614, 743.1141, 0);
	angles[36] = (0, 264.6266, 0);
	at[36] = 2.4500;
	points[37] = (-437.0236, 757.1339, 0);
	angles[37] = (0, 270.0270, 0);
	at[37] = 2.5000;
	points[38] = (-388.5331, 782.9489, 0);
	angles[38] = (0, 280.8281, 0);
	at[38] = 2.6000;
	points[39] = (-338.5555, 805.7559, 0);
	angles[39] = (0, 291.6291, 0);
	at[39] = 2.7000;
	points[40] = (-287.2689, 825.4803, 0);
	angles[40] = (0, 302.4303, 0);
	at[40] = 2.8000;
	points[41] = (-261.2043, 834.1536, 0);
	angles[41] = (0, 307.8307, 0);
	at[41] = 2.8500;
	points[42] = (-208.3339, 849.0945, 0);
	angles[42] = (0, 318.6318, 0);
	at[42] = 2.9500;
	points[43] = (-181.5701, 855.3307, 0);
	angles[43] = (0, 324.0324, 0);
	at[43] = 3;
	points[44] = (-154.6264, 860.7323, 0);
	angles[44] = (0, 329.4330, 0);
	at[44] = 3.0500;
	points[45] = (-100.3094, 868.9882, 0);
	angles[45] = (0, 340.2341, 0);
	at[45] = 3.1500;
	points[46] = (-72.9878, 871.8071, 0);
	angles[46] = (0, 345.6346, 0);
	at[46] = 3.2000;
	points[47] = (-18.1204, 874.7913, 0);
	angles[47] = (0, 356.4357, 0);
	at[47] = 3.3000;
	points[48] = (9.3354, 874.9370, 0);
	angles[48] = (0, 361.8362, 0);
	at[48] = 3.3500;
	points[49] = (64.2362, 872.5236, 0);
	angles[49] = (0, 372.6373, 0);
	at[49] = 3.4500;
	points[50] = (91.5760, 869.9882, 0);
	angles[50] = (0, 378.0378, 0);
	at[50] = 3.5000;
	points[51] = (145.9835, 862.2795, 0);
	angles[51] = (0, 388.8390, 0);
	at[51] = 3.6000;
	points[52] = (172.9693, 857.1497, 0);
	angles[52] = (0, 394.2394, 0);
	at[52] = 3.6500;
	points[53] = (226.4043, 844.3819, 0);
	angles[53] = (0, 405.0405, 0);
	at[53] = 3.7500;
	points[54] = (278.9662, 828.3386, 0);
	angles[54] = (0, 415.8416, 0);
	at[54] = 3.8500;
	points[55] = (330.4359, 809.1221, 0);
	angles[55] = (0, 426.6427, 0);
	at[55] = 3.9500;
	points[56] = (380.6307, 786.8071, 0);
	angles[56] = (0, 437.4438, 0);
	at[56] = 4.0500;
	points[57] = (405.2087, 774.5000, 0);
	angles[57] = (0, 442.8444, 0);
	at[57] = 4.1000;
	points[58] = (453.1496, 747.6771, 0);
	angles[58] = (0, 453.6454, 0);
	at[58] = 4.2000;
	points[59] = (476.4843, 733.1575, 0);
	angles[59] = (0, 459.0459, 0);
	at[59] = 4.2500;
	points[60] = (521.7283, 701.9961, 0);
	angles[60] = (0, 469.8469, 0);
	at[60] = 4.3500;
	points[61] = (543.5827, 685.3544, 0);
	angles[61] = (0, 475.2476, 0);
	at[61] = 4.4000;
	points[62] = (585.6575, 650.0118, 0);
	angles[62] = (0, 486.0486, 0);
	at[62] = 4.5000;
	points[63] = (605.7953, 631.3504, 0);
	angles[63] = (0, 491.4492, 0);
	at[63] = 4.5500;
	points[64] = (644.2126, 592.0551, 0);
	angles[64] = (0, 502.2502, 0);
	at[64] = 4.6500;
	points[65] = (662.4252, 571.5079, 0);
	angles[65] = (0, 507.6507, 0);
	at[65] = 4.7000;
	points[66] = (696.8307, 528.6614, 0);
	angles[66] = (0, 518.4519, 0);
	at[66] = 4.8000;
	points[67] = (712.9843, 506.4488, 0);
	angles[67] = (0, 523.8524, 0);
	at[67] = 4.8500;
	points[68] = (728.4488, 483.7205, 0);
	angles[68] = (0, 529.2529, 0);
	at[68] = 4.9000;
	points[69] = (757.1968, 436.9095, 0);
	angles[69] = (0, 540.0540, 0);
	at[69] = 5;
	points[70] = (783.0079, 388.4181, 0);
	angles[70] = (0, 550.8551, 0);
	at[70] = 5.1000;
	points[71] = (794.7953, 363.5870, 0);
	angles[71] = (0, 556.2556, 0);
	at[71] = 5.1500;
	points[72] = (816.0590, 312.9362, 0);
	angles[72] = (0, 567.0568, 0);
	at[72] = 5.2500;
	points[73] = (834.1969, 261.0776, 0);
	angles[73] = (0, 577.8577, 0);
	at[73] = 5.3500;
	points[74] = (849.1299, 208.1906, 0);
	angles[74] = (0, 588.6589, 0);
	at[74] = 5.4500;
	points[75] = (855.3583, 181.4457, 0);
	angles[75] = (0, 594.0594, 0);
	at[75] = 5.5000;
	points[76] = (860.7638, 154.4941, 0);
	angles[76] = (0, 599.4600, 0);
	at[76] = 5.5500;
	points[77] = (868.9921, 100.1839, 0);
	angles[77] = (0, 610.2611, 0);
	at[77] = 5.6500;
	points[78] = (873.7559, 45.4539, 0);
	angles[78] = (0, 621.0621, 0);
	at[78] = 5.7500;
	points[79] = (874.7913, 17.9924, 0);
	angles[79] = (0, 626.4627, 0);
	at[79] = 5.8000;
	points[80] = (874.9370, -9.4868, 0);
	angles[80] = (0, 631.8632, 0);
	at[80] = 5.8500;
	points[81] = (872.5079, -64.3693, 0);
	angles[81] = (0, 642.6642, 0);
	at[81] = 5.9500;
	points[82] = (869.9685, -91.7197, 0);
	angles[82] = (0, 648.0649, 0);
	at[82] = 6;
	points[83] = (862.2520, -146.1244, 0);
	angles[83] = (0, 658.8660, 0);
	at[83] = 6.1000;
	points[84] = (857.1221, -173.1004, 0);
	angles[84] = (0, 664.2665, 0);
	at[84] = 6.1500;
	points[85] = (844.3386, -226.5480, 0);
	angles[85] = (0, 675.0675, 0);
	at[85] = 6.2500;
	points[86] = (836.7244, -252.9311, 0);
	angles[86] = (0, 680.4681, 0);
	at[86] = 6.3000;
	points[87] = (819.0787, -304.9689, 0);
	angles[87] = (0, 691.2692, 0);
	at[87] = 6.4000;
	points[88] = (798.2874, -355.8339, 0);
	angles[88] = (0, 702.0703, 0);
	at[88] = 6.5000;
	points[89] = (774.4370, -405.3228, 0);
	angles[89] = (0, 712.8713, 0);
	at[89] = 6.6000;
	points[90] = (761.3898, -429.5039, 0);
	angles[90] = (0, 718.2719, 0);
	at[90] = 6.6500;
	points[91] = (733.0906, -476.5945, 0);
	angles[91] = (0, 729.0729, 0);
	at[91] = 6.7500;
	points[92] = (701.9173, -521.8268, 0);
	angles[92] = (0, 739.8740, 0);
	at[92] = 6.8500;
	points[93] = (685.2677, -543.6968, 0);
	angles[93] = (0, 745.2745, 0);
	at[93] = 6.9000;
	points[94] = (649.9252, -585.7520, 0);
	angles[94] = (0, 756.0757, 0);
	at[94] = 7;
	points[95] = (631.2441, -605.9055, 0);
	angles[95] = (0, 761.4761, 0);
	at[95] = 7.0500;
	points[96] = (611.9252, -625.4174, 0);
	angles[96] = (0, 766.8768, 0);
	at[96] = 7.1000;
	points[97] = (571.3976, -662.5197, 0);
	angles[97] = (0, 777.6779, 0);
	at[97] = 7.2000;
	points[98] = (550.2559, -680.0551, 0);
	angles[98] = (0, 783.0783, 0);
	at[98] = 7.2500;
	points[99] = (506.3386, -713.0709, 0);
	angles[99] = (0, 793.8794, 0);
	at[99] = 7.3500;
	points[100] = (483.6142, -728.5197, 0);
	angles[100] = (0, 799.2800, 0);
	at[100] = 7.4000;
	points[101] = (436.7992, -757.2598, 0);
	angles[101] = (0, 810.0811, 0);
	at[101] = 7.5000;
	points[102] = (388.2878, -783.0709, 0);
	angles[102] = (0, 820.8821, 0);
	at[102] = 7.6000;
	points[103] = (363.4709, -794.8504, 0);
	angles[103] = (0, 826.2828, 0);
	at[103] = 7.6500;
	points[104] = (312.8110, -816.1103, 0);
	angles[104] = (0, 837.0838, 0);
	at[104] = 7.7500;
	points[105] = (260.9354, -834.2401, 0);
	angles[105] = (0, 847.8848, 0);
	at[105] = 7.8500;
	points[106] = (208.0594, -849.1614, 0);
	angles[106] = (0, 858.6860, 0);
	at[106] = 7.9500;
	points[107] = (181.3063, -855.3859, 0);
	angles[107] = (0, 864.0865, 0);
	at[107] = 8;
	points[108] = (127.2622, -865.3347, 0);
	angles[108] = (0, 874.8875, 0);
	at[108] = 8.1000;
	points[109] = (100.0524, -869.0079, 0);
	angles[109] = (0, 880.2881, 0);
	at[109] = 8.1500;
	points[110] = (45.3035, -873.7678, 0);
	angles[110] = (0, 891.0891, 0);
	at[110] = 8.2500;
	points[111] = (17.8656, -874.7953, 0);
	angles[111] = (0, 896.4897, 0);
	at[111] = 8.3000;
	points[112] = (-37.0770, -874.1653, 0);
	angles[112] = (0, 907.2906, 0);
	at[112] = 8.4000;
	points[113] = (-64.4949, -872.5001, 0);
	angles[113] = (0, 912.6913, 0);
	at[113] = 8.4500;
	points[114] = (-119.1087, -866.5315, 0);
	angles[114] = (0, 923.4924, 0);
	at[114] = 8.5500;
	points[115] = (-146.2524, -862.2323, 0);
	angles[115] = (0, 928.8929, 0);
	at[115] = 8.6000;
	points[116] = (-173.2472, -857.0945, 0);
	angles[116] = (0, 934.2933, 0);
	at[116] = 8.6500;
	points[117] = (-226.6783, -844.3031, 0);
	angles[117] = (0, 945.0945, 0);
	at[117] = 8.7500;
	points[118] = (-279.2138, -828.2559, 0);
	angles[118] = (0, 955.8956, 0);
	at[118] = 8.8500;
	points[119] = (-305.1039, -819.0276, 0);
	angles[119] = (0, 961.2960, 0);
	at[119] = 8.9000;
	points[120] = (-355.9528, -798.2323, 0);
	angles[120] = (0, 972.0972, 0);
	at[120] = 9;
	points[121] = (-405.4370, -774.3819, 0);
	angles[121] = (0, 982.8983, 0);
	at[121] = 9.1000;
	points[122] = (-453.3819, -747.5355, 0);
	angles[122] = (0, 993.6993, 0);
	at[122] = 9.2000;
	points[123] = (-476.7008, -733.0197, 0);
	angles[123] = (0, 999.0999, 0);
	at[123] = 9.2500;
	points[124] = (-521.9331, -701.8346, 0);
	angles[124] = (0, 1009.9011, 0);
	at[124] = 9.3500;
	points[125] = (-543.7992, -685.1851, 0);
	angles[125] = (0, 1015.3015, 0);
	at[125] = 9.4000;
	points[126] = (-565.1181, -667.8465, 0);
	angles[126] = (0, 1020.7020, 0);
	at[126] = 9.4500;
	points[127] = (-606, -631.1497, 0);
	angles[127] = (0, 1031.5033, 0);
	at[127] = 9.5500;
	points[128] = (-625.5197, -611.8229, 0);
	angles[128] = (0, 1036.9037, 0);
	at[128] = 9.6000;
	points[129] = (-662.6102, -571.2834, 0);
	angles[129] = (0, 1047.7048, 0);
	at[129] = 9.7000;
	points[130] = (-680.1418, -550.1496, 0);
	angles[130] = (0, 1053.1052, 0);
	at[130] = 9.7500;
	points[131] = (-713.1535, -506.2126, 0);
	angles[131] = (0, 1063.9064, 0);
	at[131] = 9.8500;
	points[132] = (-728.5236, -483.4724, 0);
	angles[132] = (0, 1069.3069, 0);
	at[132] = 9.9000;
	points[133] = (-757.3425, -436.6772, 0);
	angles[133] = (0, 1080.1080, 0);
	at[133] = 10;
	mover = getEnt("iz_mover1", "targetname");
	if (!isDefined(mover))
		return;
	rider = getEnt("iz_bumper6_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	rider = getEnt("iz_bumper7_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	rider = getEnt("iz_bumper8_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	rider = getEnt("iz_bumper9_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	mover thread iz_mover_loop(points, angles, at, false, false);
}

iz_mover2()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-757.0551, 437.1496, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-748.3701, 451.4724, 0);
	angles[1] = (0, 5.4005, 0);
	at[1] = 0.0500;
	points[2] = (-729.9961, 480.9922, 0);
	angles[2] = (0, 10.8011, 0);
	at[2] = 0.1000;
	points[3] = (-712.8307, 506.6614, 0);
	angles[3] = (0, 16.2016, 0);
	at[3] = 0.1500;
	points[4] = (-679.7953, 550.5787, 0);
	angles[4] = (0, 27.0027, 0);
	at[4] = 0.2500;
	points[5] = (-662.2520, 571.7008, 0);
	angles[5] = (0, 32.4032, 0);
	at[5] = 0.3000;
	points[6] = (-625.1417, 612.2244, 0);
	angles[6] = (0, 43.2044, 0);
	at[6] = 0.4000;
	points[7] = (-605.6063, 631.5355, 0);
	angles[7] = (0, 48.6049, 0);
	at[7] = 0.4500;
	points[8] = (-564.6968, 668.2048, 0);
	angles[8] = (0, 59.4060, 0);
	at[8] = 0.5500;
	points[9] = (-543.3622, 685.5275, 0);
	angles[9] = (0, 64.8066, 0);
	at[9] = 0.6000;
	points[10] = (-499.1220, 718.0867, 0);
	angles[10] = (0, 75.6075, 0);
	at[10] = 0.7000;
	points[11] = (-476.2362, 733.3149, 0);
	angles[11] = (0, 81.0081, 0);
	at[11] = 0.7500;
	points[12] = (-429.1417, 761.5945, 0);
	angles[12] = (0, 91.8092, 0);
	at[12] = 0.8500;
	points[13] = (-404.9449, 774.6339, 0);
	angles[13] = (0, 97.2097, 0);
	at[13] = 0.9000;
	points[14] = (-355.4473, 798.4606, 0);
	angles[14] = (0, 108.0107, 0);
	at[14] = 1;
	points[15] = (-304.5874, 819.2166, 0);
	angles[15] = (0, 118.8119, 0);
	at[15] = 1.1000;
	points[16] = (-278.6909, 828.4370, 0);
	angles[16] = (0, 124.2124, 0);
	at[16] = 1.1500;
	points[17] = (-226.1461, 844.4528, 0);
	angles[17] = (0, 135.0135, 0);
	at[17] = 1.2500;
	points[18] = (-199.5126, 851.2480, 0);
	angles[18] = (0, 140.4140, 0);
	at[18] = 1.3000;
	points[19] = (-145.7087, 862.3307, 0);
	angles[19] = (0, 151.2151, 0);
	at[19] = 1.4000;
	points[20] = (-118.5626, 866.6063, 0);
	angles[20] = (0, 156.6158, 0);
	at[20] = 1.4500;
	points[21] = (-63.9457, 872.5512, 0);
	angles[21] = (0, 167.4167, 0);
	at[21] = 1.5500;
	points[22] = (-9.0696, 874.9449, 0);
	angles[22] = (0, 178.2178, 0);
	at[22] = 1.6500;
	points[23] = (18.4174, 874.7913, 0);
	angles[23] = (0, 183.6184, 0);
	at[23] = 1.7000;
	points[24] = (45.8547, 873.7402, 0);
	angles[24] = (0, 189.0189, 0);
	at[24] = 1.7500;
	points[25] = (100.6004, 868.9449, 0);
	angles[25] = (0, 199.8200, 0);
	at[25] = 1.8500;
	points[26] = (127.8083, 865.2480, 0);
	angles[26] = (0, 205.2205, 0);
	at[26] = 1.9000;
	points[27] = (181.8445, 855.2756, 0);
	angles[27] = (0, 216.0216, 0);
	at[27] = 2;
	points[28] = (208.5953, 849.0315, 0);
	angles[28] = (0, 221.4221, 0);
	at[28] = 2.0500;
	points[29] = (261.4610, 834.0787, 0);
	angles[29] = (0, 232.2233, 0);
	at[29] = 2.1500;
	points[30] = (313.3264, 815.9056, 0);
	angles[30] = (0, 243.0243, 0);
	at[30] = 2.2500;
	points[31] = (363.9732, 794.6181, 0);
	angles[31] = (0, 253.8253, 0);
	at[31] = 2.3500;
	points[32] = (413.2205, 770.2795, 0);
	angles[32] = (0, 264.6264, 0);
	at[32] = 2.4500;
	points[33] = (437.2795, 756.9882, 0);
	angles[33] = (0, 270.0270, 0);
	at[33] = 2.5000;
	points[34] = (484.0748, 728.2166, 0);
	angles[34] = (0, 280.8281, 0);
	at[34] = 2.6000;
	points[35] = (506.7914, 712.7480, 0);
	angles[35] = (0, 286.2287, 0);
	at[35] = 2.6500;
	points[36] = (550.6851, 679.7087, 0);
	angles[36] = (0, 297.0298, 0);
	at[36] = 2.7500;
	points[37] = (571.8150, 662.1614, 0);
	angles[37] = (0, 302.4303, 0);
	at[37] = 2.8000;
	points[38] = (612.3268, 625.0355, 0);
	angles[38] = (0, 313.2313, 0);
	at[38] = 2.9000;
	points[39] = (631.6339, 605.5157, 0);
	angles[39] = (0, 318.6320, 0);
	at[39] = 2.9500;
	points[40] = (668.2993, 564.5787, 0);
	angles[40] = (0, 329.4329, 0);
	at[40] = 3.0500;
	points[41] = (685.6102, 543.2638, 0);
	angles[41] = (0, 334.8335, 0);
	at[41] = 3.1000;
	points[42] = (718.1732, 499, 0);
	angles[42] = (0, 345.6346, 0);
	at[42] = 3.2000;
	points[43] = (733.3818, 476.1339, 0);
	angles[43] = (0, 351.0351, 0);
	at[43] = 3.2500;
	points[44] = (747.8937, 452.7835, 0);
	angles[44] = (0, 356.4357, 0);
	at[44] = 3.3000;
	points[45] = (774.6968, 404.8346, 0);
	angles[45] = (0, 367.2368, 0);
	at[45] = 3.4000;
	points[46] = (798.5118, 355.3299, 0);
	angles[46] = (0, 378.0378, 0);
	at[46] = 3.5000;
	points[47] = (809.2834, 330.0417, 0);
	angles[47] = (0, 383.4384, 0);
	at[47] = 3.5500;
	points[48] = (828.4724, 278.5713, 0);
	angles[48] = (0, 394.2394, 0);
	at[48] = 3.6500;
	points[49] = (844.4882, 226.0173, 0);
	angles[49] = (0, 405.0405, 0);
	at[49] = 3.7500;
	points[50] = (851.2756, 199.3882, 0);
	angles[50] = (0, 410.4412, 0);
	at[50] = 3.8000;
	points[51] = (862.3504, 145.5827, 0);
	angles[51] = (0, 421.2422, 0);
	at[51] = 3.9000;
	points[52] = (866.6220, 118.4287, 0);
	angles[52] = (0, 426.6427, 0);
	at[52] = 3.9500;
	points[53] = (872.5552, 63.8201, 0);
	angles[53] = (0, 437.4438, 0);
	at[53] = 4.0500;
	points[54] = (874.9528, 8.9360, 0);
	angles[54] = (0, 448.2449, 0);
	at[54] = 4.1500;
	points[55] = (874.7834, -18.5445, 0);
	angles[55] = (0, 453.6453, 0);
	at[55] = 4.2000;
	points[56] = (873.7244, -46.0055, 0);
	angles[56] = (0, 459.0459, 0);
	at[56] = 4.2500;
	points[57] = (868.9292, -100.7327, 0);
	angles[57] = (0, 469.8469, 0);
	at[57] = 4.3500;
	points[58] = (860.6575, -155.0374, 0);
	angles[58] = (0, 480.6481, 0);
	at[58] = 4.4500;
	points[59] = (855.2402, -181.9846, 0);
	angles[59] = (0, 486.0486, 0);
	at[59] = 4.5000;
	points[60] = (848.9961, -208.7244, 0);
	angles[60] = (0, 491.4492, 0);
	at[60] = 4.5500;
	points[61] = (834.0275, -261.6028, 0);
	angles[61] = (0, 502.2502, 0);
	at[61] = 4.6500;
	points[62] = (815.8583, -313.4516, 0);
	angles[62] = (0, 513.0513, 0);
	at[62] = 4.7500;
	points[63] = (794.5630, -364.0882, 0);
	angles[63] = (0, 523.8524, 0);
	at[63] = 4.8500;
	points[64] = (782.7598, -388.9118, 0);
	angles[64] = (0, 529.2529, 0);
	at[64] = 4.9000;
	points[65] = (756.9252, -437.3898, 0);
	angles[65] = (0, 540.0540, 0);
	at[65] = 5;
	points[66] = (742.8976, -461.0157, 0);
	angles[66] = (0, 545.4546, 0);
	at[66] = 5.0500;
	points[67] = (712.6693, -506.8976, 0);
	angles[67] = (0, 556.2556, 0);
	at[67] = 5.1500;
	points[68] = (696.5000, -529.1024, 0);
	angles[68] = (0, 561.6562, 0);
	at[68] = 5.2000;
	points[69] = (662.0670, -571.9291, 0);
	angles[69] = (0, 572.4573, 0);
	at[69] = 5.3000;
	points[70] = (643.8465, -592.4646, 0);
	angles[70] = (0, 577.8577, 0);
	at[70] = 5.3500;
	points[71] = (605.4016, -631.7363, 0);
	angles[71] = (0, 588.6589, 0);
	at[71] = 5.4500;
	points[72] = (585.2520, -650.3859, 0);
	angles[72] = (0, 594.0594, 0);
	at[72] = 5.5000;
	points[73] = (543.1496, -685.6969, 0);
	angles[73] = (0, 604.8605, 0);
	at[73] = 5.6000;
	points[74] = (521.2795, -702.3189, 0);
	angles[74] = (0, 610.2611, 0);
	at[74] = 5.6500;
	points[75] = (476.0197, -733.4606, 0);
	angles[75] = (0, 621.0621, 0);
	at[75] = 5.7500;
	points[76] = (452.6732, -747.9567, 0);
	angles[76] = (0, 626.4627, 0);
	at[76] = 5.8000;
	points[77] = (404.7166, -774.7520, 0);
	angles[77] = (0, 637.2638, 0);
	at[77] = 5.9000;
	points[78] = (355.1980, -798.5670, 0);
	angles[78] = (0, 648.0648, 0);
	at[78] = 6;
	points[79] = (304.3189, -819.3229, 0);
	angles[79] = (0, 658.8660, 0);
	at[79] = 6.1000;
	points[80] = (252.2815, -836.9252, 0);
	angles[80] = (0, 669.6669, 0);
	at[80] = 6.2000;
	points[81] = (225.8732, -844.5276, 0);
	angles[81] = (0, 675.0675, 0);
	at[81] = 6.2500;
	points[82] = (172.4295, -857.2638, 0);
	angles[82] = (0, 685.8686, 0);
	at[82] = 6.3500;
	points[83] = (145.4417, -862.3701, 0);
	angles[83] = (0, 691.2692, 0);
	at[83] = 6.4000;
	points[84] = (91.0295, -870.0433, 0);
	angles[84] = (0, 702.0701, 0);
	at[84] = 6.5000;
	points[85] = (63.6878, -872.5630, 0);
	angles[85] = (0, 707.4708, 0);
	at[85] = 6.5500;
	points[86] = (8.7842, -874.9528, 0);
	angles[86] = (0, 718.2718, 0);
	at[86] = 6.6500;
	points[87] = (-18.6723, -874.7913, 0);
	angles[87] = (0, 723.6724, 0);
	at[87] = 6.7000;
	points[88] = (-46.1386, -873.7205, 0);
	angles[88] = (0, 729.0729, 0);
	at[88] = 6.7500;
	points[89] = (-100.8587, -868.9173, 0);
	angles[89] = (0, 739.8740, 0);
	at[89] = 6.8500;
	points[90] = (-155.1705, -860.6378, 0);
	angles[90] = (0, 750.6750, 0);
	at[90] = 6.9500;
	points[91] = (-182.1114, -855.2126, 0);
	angles[91] = (0, 756.0756, 0);
	at[91] = 7;
	points[92] = (-235.4032, -841.8819, 0);
	angles[92] = (0, 766.8767, 0);
	at[92] = 7.1000;
	points[93] = (-261.7315, -833.9882, 0);
	angles[93] = (0, 772.2772, 0);
	at[93] = 7.1500;
	points[94] = (-313.5701, -815.8150, 0);
	angles[94] = (0, 783.0783, 0);
	at[94] = 7.2500;
	points[95] = (-364.2106, -794.5079, 0);
	angles[95] = (0, 793.8794, 0);
	at[95] = 7.3500;
	points[96] = (-389.0280, -782.7047, 0);
	angles[96] = (0, 799.2798, 0);
	at[96] = 7.4000;
	points[97] = (-437.5000, -756.8544, 0);
	angles[97] = (0, 810.0811, 0);
	at[97] = 7.5000;
	points[98] = (-461.1339, -742.8189, 0);
	angles[98] = (0, 815.4816, 0);
	at[98] = 7.5500;
	points[99] = (-507, -712.5945, 0);
	angles[99] = (0, 826.2828, 0);
	at[99] = 7.6500;
	points[100] = (-529.2205, -696.4134, 0);
	angles[100] = (0, 831.6831, 0);
	at[100] = 7.7000;
	points[101] = (-572.0236, -661.9803, 0);
	angles[101] = (0, 842.4843, 0);
	at[101] = 7.8000;
	points[102] = (-612.5079, -624.8543, 0);
	angles[102] = (0, 853.2854, 0);
	at[102] = 7.9000;
	points[103] = (-631.8228, -605.2993, 0);
	angles[103] = (0, 858.6860, 0);
	at[103] = 7.9500;
	points[104] = (-650.4803, -585.1417, 0);
	angles[104] = (0, 864.0864, 0);
	at[104] = 8;
	points[105] = (-685.7834, -543.0315, 0);
	angles[105] = (0, 874.8876, 0);
	at[105] = 8.1000;
	points[106] = (-702.4016, -521.1732, 0);
	angles[106] = (0, 880.2880, 0);
	at[106] = 8.1500;
	points[107] = (-733.5354, -475.8898, 0);
	angles[107] = (0, 891.0891, 0);
	at[107] = 8.2500;
	points[108] = (-748.0276, -452.5630, 0);
	angles[108] = (0, 896.4897, 0);
	at[108] = 8.3000;
	points[109] = (-774.8228, -404.5905, 0);
	angles[109] = (0, 907.2906, 0);
	at[109] = 8.4000;
	points[110] = (-787.1024, -380.0173, 0);
	angles[110] = (0, 912.6913, 0);
	at[110] = 8.4500;
	points[111] = (-809.3819, -329.7988, 0);
	angles[111] = (0, 923.4924, 0);
	at[111] = 8.5500;
	points[112] = (-828.5630, -278.3012, 0);
	angles[112] = (0, 934.2933, 0);
	at[112] = 8.6500;
	points[113] = (-844.5630, -225.7410, 0);
	angles[113] = (0, 945.0946, 0);
	at[113] = 8.7500;
	points[114] = (-851.3386, -199.1213, 0);
	angles[114] = (0, 950.4951, 0);
	at[114] = 8.8000;
	points[115] = (-862.4016, -145.2969, 0);
	angles[115] = (0, 961.2960, 0);
	at[115] = 8.9000;
	points[116] = (-870.0591, -90.8984, 0);
	angles[116] = (0, 972.0972, 0);
	at[116] = 9;
	points[117] = (-872.5866, -63.5350, 0);
	angles[117] = (0, 977.4977, 0);
	at[117] = 9.0500;
	points[118] = (-874.9449, -8.6481, 0);
	angles[118] = (0, 988.2988, 0);
	at[118] = 9.1500;
	points[119] = (-874.7913, 18.8185, 0);
	angles[119] = (0, 993.6995, 0);
	at[119] = 9.2000;
	points[120] = (-873.7126, 46.2665, 0);
	angles[120] = (0, 999.0999, 0);
	at[120] = 9.2500;
	points[121] = (-868.9016, 100.9953, 0);
	angles[121] = (0, 1009.9011, 0);
	at[121] = 9.3500;
	points[122] = (-865.1772, 128.2232, 0);
	angles[122] = (0, 1015.3015, 0);
	at[122] = 9.4000;
	points[123] = (-855.1890, 182.2394, 0);
	angles[123] = (0, 1026.1027, 0);
	at[123] = 9.5000;
	points[124] = (-848.9252, 209.0024, 0);
	angles[124] = (0, 1031.5033, 0);
	at[124] = 9.5500;
	points[125] = (-833.9528, 261.8547, 0);
	angles[125] = (0, 1042.3042, 0);
	at[125] = 9.6500;
	points[126] = (-815.7678, 313.6972, 0);
	angles[126] = (0, 1053.1053, 0);
	at[126] = 9.7500;
	points[127] = (-794.4449, 364.3492, 0);
	angles[127] = (0, 1063.9064, 0);
	at[127] = 9.8500;
	points[128] = (-780.8583, 392.2689, 0);
	angles[128] = (0, 1069.3069, 0);
	at[128] = 9.9000;
	points[129] = (-764.7362, 422.9291, 0);
	angles[129] = (0, 1074.7075, 0);
	at[129] = 9.9500;
	points[130] = (-757.0551, 437.1496, 0);
	angles[130] = (0, 1080, 0);
	at[130] = 10;
	mover = getEnt("iz_mover2", "targetname");
	if (!isDefined(mover))
		return;
	rider = getEnt("iz_bumper10_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	rider = getEnt("iz_bumper11_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	rider = getEnt("iz_bumper12_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	rider = getEnt("iz_bumper13_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	rider = getEnt("iz_bumper14_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	rider = getEnt("iz_bumper15_touch", "targetname");
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
	points[0] = (0.0022, 874.9921, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (16.7483, 874.5394, 0);
	angles[1] = (0, 5.4006, 0);
	at[1] = 0.0500;
	points[2] = (51.4913, 873.1812, 0);
	angles[2] = (0, 10.8011, 0);
	at[2] = 0.1000;
	points[3] = (82.2858, 870.9489, 0);
	angles[3] = (0, 16.2016, 0);
	at[3] = 0.1500;
	points[4] = (109.5878, 867.8268, 0);
	angles[4] = (0, 21.6022, 0);
	at[4] = 0.2000;
	points[5] = (163.8079, 858.9921, 0);
	angles[5] = (0, 32.4032, 0);
	at[5] = 0.3000;
	points[6] = (190.6988, 853.2992, 0);
	angles[6] = (0, 37.8038, 0);
	at[6] = 0.3500;
	points[7] = (243.8555, 839.4489, 0);
	angles[7] = (0, 48.6049, 0);
	at[7] = 0.4500;
	points[8] = (296.0677, 822.3544, 0);
	angles[8] = (0, 59.4059, 0);
	at[8] = 0.5500;
	points[9] = (347.1539, 802.0945, 0);
	angles[9] = (0, 70.2070, 0);
	at[9] = 0.6500;
	points[10] = (372.1906, 790.8189, 0);
	angles[10] = (0, 75.6075, 0);
	at[10] = 0.7000;
	points[11] = (421.2047, 765.9764, 0);
	angles[11] = (0, 86.4086, 0);
	at[11] = 0.8000;
	points[12] = (468.6024, 738.1772, 0);
	angles[12] = (0, 97.2099, 0);
	at[12] = 0.9000;
	points[13] = (491.6142, 723.1929, 0);
	angles[13] = (0, 102.6104, 0);
	at[13] = 0.9500;
	points[14] = (536.2166, 691.0866, 0);
	angles[14] = (0, 113.4114, 0);
	at[14] = 1.0500;
	points[15] = (557.7087, 673.9960, 0);
	angles[15] = (0, 118.8119, 0);
	at[15] = 1.1000;
	points[16] = (599.0197, 637.7678, 0);
	angles[16] = (0, 129.6129, 0);
	at[16] = 1.2000;
	points[17] = (618.7520, 618.6614, 0);
	angles[17] = (0, 135.0136, 0);
	at[17] = 1.2500;
	points[18] = (656.3071, 578.5630, 0);
	angles[18] = (0, 145.8145, 0);
	at[18] = 1.3500;
	points[19] = (674.0827, 557.6063, 0);
	angles[19] = (0, 151.2151, 0);
	at[19] = 1.4000;
	points[20] = (707.5748, 514.0630, 0);
	angles[20] = (0, 162.0162, 0);
	at[20] = 1.5000;
	points[21] = (723.2678, 491.5000, 0);
	angles[21] = (0, 167.4167, 0);
	at[21] = 1.5500;
	points[22] = (752.5157, 445, 0);
	angles[22] = (0, 178.2178, 0);
	at[22] = 1.6500;
	points[23] = (766.0433, 421.0748, 0);
	angles[23] = (0, 183.6183, 0);
	at[23] = 1.7000;
	points[24] = (790.8740, 372.0705, 0);
	angles[24] = (0, 194.4195, 0);
	at[24] = 1.8000;
	points[25] = (812.6575, 321.6417, 0);
	angles[25] = (0, 205.2206, 0);
	at[25] = 1.9000;
	points[26] = (831.3425, 269.9650, 0);
	angles[26] = (0, 216.0217, 0);
	at[26] = 2;
	points[27] = (839.4803, 243.7295, 0);
	angles[27] = (0, 221.4221, 0);
	at[27] = 2.0500;
	points[28] = (846.8268, 217.2413, 0);
	angles[28] = (0, 226.8227, 0);
	at[28] = 2.1000;
	points[29] = (859.0197, 163.6768, 0);
	angles[29] = (0, 237.6237, 0);
	at[29] = 2.2000;
	points[30] = (867.8386, 109.4571, 0);
	angles[30] = (0, 248.4248, 0);
	at[30] = 2.3000;
	points[31] = (870.9606, 82.1472, 0);
	angles[31] = (0, 253.8253, 0);
	at[31] = 2.3500;
	points[32] = (874.5394, 27.3358, 0);
	angles[32] = (0, 264.6264, 0);
	at[32] = 2.4500;
	points[33] = (874.9843, -0.1470, 0);
	angles[33] = (0, 270.0270, 0);
	at[33] = 2.5000;
	points[34] = (874.5394, -27.5996, 0);
	angles[34] = (0, 275.4275, 0);
	at[34] = 2.5500;
	points[35] = (870.9252, -82.4354, 0);
	angles[35] = (0, 286.2287, 0);
	at[35] = 2.6500;
	points[36] = (867.8110, -109.7158, 0);
	angles[36] = (0, 291.6291, 0);
	at[36] = 2.7000;
	points[37] = (858.9645, -163.9484, 0);
	angles[37] = (0, 302.4303, 0);
	at[37] = 2.8000;
	points[38] = (846.7480, -217.5221, 0);
	angles[38] = (0, 313.2313, 0);
	at[38] = 2.9000;
	points[39] = (839.4055, -243.9835, 0);
	angles[39] = (0, 318.6318, 0);
	at[39] = 2.9500;
	points[40] = (831.2520, -270.2268, 0);
	angles[40] = (0, 324.0324, 0);
	at[40] = 3;
	points[41] = (812.5670, -321.8846, 0);
	angles[41] = (0, 334.8335, 0);
	at[41] = 3.1000;
	points[42] = (790.7559, -372.3201, 0);
	angles[42] = (0, 345.6346, 0);
	at[42] = 3.2000;
	points[43] = (765.9135, -421.3307, 0);
	angles[43] = (0, 356.4357, 0);
	at[43] = 3.3000;
	points[44] = (738.1063, -468.7087, 0);
	angles[44] = (0, 367.2367, 0);
	at[44] = 3.4000;
	points[45] = (723.1142, -491.7402, 0);
	angles[45] = (0, 372.6373, 0);
	at[45] = 3.4500;
	points[46] = (691.0040, -536.3228, 0);
	angles[46] = (0, 383.4384, 0);
	at[46] = 3.5500;
	points[47] = (673.9095, -557.8229, 0);
	angles[47] = (0, 388.8389, 0);
	at[47] = 3.6000;
	points[48] = (637.6653, -599.1260, 0);
	angles[48] = (0, 399.6400, 0);
	at[48] = 3.7000;
	points[49] = (618.5709, -618.8504, 0);
	angles[49] = (0, 405.0405, 0);
	at[49] = 3.7500;
	points[50] = (598.8149, -637.9528, 0);
	angles[50] = (0, 410.4412, 0);
	at[50] = 3.8000;
	points[51] = (557.5118, -674.1693, 0);
	angles[51] = (0, 421.2421, 0);
	at[51] = 3.9000;
	points[52] = (535.9843, -691.2599, 0);
	angles[52] = (0, 426.6427, 0);
	at[52] = 3.9500;
	points[53] = (491.3976, -723.3464, 0);
	angles[53] = (0, 437.4438, 0);
	at[53] = 4.0500;
	points[54] = (444.8819, -752.5827, 0);
	angles[54] = (0, 448.2449, 0);
	at[54] = 4.1500;
	points[55] = (420.9606, -766.1063, 0);
	angles[55] = (0, 453.6453, 0);
	at[55] = 4.2000;
	points[56] = (371.9528, -790.9291, 0);
	angles[56] = (0, 464.4465, 0);
	at[56] = 4.3000;
	points[57] = (346.8886, -802.2087, 0);
	angles[57] = (0, 469.8469, 0);
	at[57] = 4.3500;
	points[58] = (295.8177, -822.4370, 0);
	angles[58] = (0, 480.6481, 0);
	at[58] = 4.4500;
	points[59] = (243.6008, -839.5157, 0);
	angles[59] = (0, 491.4492, 0);
	at[59] = 4.5500;
	points[60] = (217.1161, -846.8543, 0);
	angles[60] = (0, 496.8497, 0);
	at[60] = 4.6000;
	points[61] = (163.5516, -859.0394, 0);
	angles[61] = (0, 507.6508, 0);
	at[61] = 4.7000;
	points[62] = (109.3154, -867.8583, 0);
	angles[62] = (0, 518.4518, 0);
	at[62] = 4.8000;
	points[63] = (82.0224, -870.9685, 0);
	angles[63] = (0, 523.8524, 0);
	at[63] = 4.8500;
	points[64] = (54.6260, -873.2087, 0);
	angles[64] = (0, 529.2529, 0);
	at[64] = 4.9000;
	points[65] = (-0.2748, -874.9843, 0);
	angles[65] = (0, 540.0541, 0);
	at[65] = 5;
	points[66] = (-27.7510, -874.5315, 0);
	angles[66] = (0, 545.4545, 0);
	at[66] = 5.0500;
	points[67] = (-82.5693, -870.9134, 0);
	angles[67] = (0, 556.2556, 0);
	at[67] = 5.1500;
	points[68] = (-109.8595, -867.7914, 0);
	angles[68] = (0, 561.6562, 0);
	at[68] = 5.2000;
	points[69] = (-164.0906, -858.9331, 0);
	angles[69] = (0, 572.4573, 0);
	at[69] = 5.3000;
	points[70] = (-190.9543, -853.2441, 0);
	angles[70] = (0, 577.8578, 0);
	at[70] = 5.3500;
	points[71] = (-244.1272, -839.3622, 0);
	angles[71] = (0, 588.6589, 0);
	at[71] = 5.4500;
	points[72] = (-270.3496, -831.2166, 0);
	angles[72] = (0, 594.0594, 0);
	at[72] = 5.5000;
	points[73] = (-322.0181, -812.5118, 0);
	angles[73] = (0, 604.8605, 0);
	at[73] = 5.6000;
	points[74] = (-372.4512, -790.6929, 0);
	angles[74] = (0, 615.6617, 0);
	at[74] = 5.7000;
	points[75] = (-421.4449, -765.8425, 0);
	angles[75] = (0, 626.4627, 0);
	at[75] = 5.8000;
	points[76] = (-445.3583, -752.3032, 0);
	angles[76] = (0, 631.8632, 0);
	at[76] = 5.8500;
	points[77] = (-491.8543, -723.0355, 0);
	angles[77] = (0, 642.6642, 0);
	at[77] = 5.9500;
	points[78] = (-514.3898, -707.3346, 0);
	angles[78] = (0, 648.0648, 0);
	at[78] = 6;
	points[79] = (-557.9370, -673.8189, 0);
	angles[79] = (0, 658.8658, 0);
	at[79] = 6.1000;
	points[80] = (-599.2166, -637.5787, 0);
	angles[80] = (0, 669.6669, 0);
	at[80] = 6.2000;
	points[81] = (-618.9606, -618.4645, 0);
	angles[81] = (0, 675.0675, 0);
	at[81] = 6.2500;
	points[82] = (-638.0433, -598.7244, 0);
	angles[82] = (0, 680.4681, 0);
	at[82] = 6.3000;
	points[83] = (-674.2559, -557.3976, 0);
	angles[83] = (0, 691.2692, 0);
	at[83] = 6.4000;
	points[84] = (-691.3386, -535.8858, 0);
	angles[84] = (0, 696.6697, 0);
	at[84] = 6.4500;
	points[85] = (-723.4213, -491.2834, 0);
	angles[85] = (0, 707.4708, 0);
	at[85] = 6.5500;
	points[86] = (-738.4016, -468.2441, 0);
	angles[86] = (0, 712.8713, 0);
	at[86] = 6.6000;
	points[87] = (-766.1693, -420.8504, 0);
	angles[87] = (0, 723.6724, 0);
	at[87] = 6.7000;
	points[88] = (-790.9843, -371.8217, 0);
	angles[88] = (0, 734.4734, 0);
	at[88] = 6.8000;
	points[89] = (-812.7717, -321.3721, 0);
	angles[89] = (0, 745.2745, 0);
	at[89] = 6.9000;
	points[90] = (-831.4252, -269.7032, 0);
	angles[90] = (0, 756.0756, 0);
	at[90] = 7;
	points[91] = (-839.5670, -243.4559, 0);
	angles[91] = (0, 761.4763, 0);
	at[91] = 7.0500;
	points[92] = (-853.3976, -190.2847, 0);
	angles[92] = (0, 772.2773, 0);
	at[92] = 7.1500;
	points[93] = (-859.0669, -163.4087, 0);
	angles[93] = (0, 777.6777, 0);
	at[93] = 7.2000;
	points[94] = (-867.8820, -109.1693, 0);
	angles[94] = (0, 788.4789, 0);
	at[94] = 7.3000;
	points[95] = (-870.9803, -81.8874, 0);
	angles[95] = (0, 793.8794, 0);
	at[95] = 7.3500;
	points[96] = (-874.5512, -27.0493, 0);
	angles[96] = (0, 804.6804, 0);
	at[96] = 7.4500;
	points[97] = (-874.9843, 0.4042, 0);
	angles[97] = (0, 810.0811, 0);
	at[97] = 7.5000;
	points[98] = (-873.1575, 55.3213, 0);
	angles[98] = (0, 820.8821, 0);
	at[98] = 7.6000;
	points[99] = (-870.9055, 82.6972, 0);
	angles[99] = (0, 826.2828, 0);
	at[99] = 7.6500;
	points[100] = (-863.7717, 137.1713, 0);
	angles[100] = (0, 837.0838, 0);
	at[100] = 7.7500;
	points[101] = (-858.9055, 164.2193, 0);
	angles[101] = (0, 842.4843, 0);
	at[101] = 7.8000;
	points[102] = (-846.6851, 217.7748, 0);
	angles[102] = (0, 853.2854, 0);
	at[102] = 7.9000;
	points[103] = (-839.3267, 244.2587, 0);
	angles[103] = (0, 858.6859, 0);
	at[103] = 7.9500;
	points[104] = (-822.4174, 296.1000, 0);
	angles[104] = (0, 869.4869, 0);
	at[104] = 8.0500;
	points[105] = (-812.7717, 321.6008, 0);
	angles[105] = (0, 874.8876, 0);
	at[105] = 8.1000;
	points[106] = (-801.4646, 348.3437, 0);
	angles[106] = (0, 880.2881, 0);
	at[106] = 8.1500;
	points[107] = (-787.7520, 377.6031, 0);
	angles[107] = (0, 885.6886, 0);
	at[107] = 8.2000;
	points[108] = (-773.9764, 405.3071, 0);
	angles[108] = (0, 891.0891, 0);
	at[108] = 8.2500;
	points[109] = (-762.9292, 426.5354, 0);
	angles[109] = (0, 896.4896, 0);
	at[109] = 8.3000;
	points[110] = (-753.8425, 442.6654, 0);
	angles[110] = (0, 901.8903, 0);
	at[110] = 8.3500;
	points[111] = (-742.5197, 460.9843, 0);
	angles[111] = (0, 907.2906, 0);
	at[111] = 8.4000;
	points[112] = (-726.5669, 485.6693, 0);
	angles[112] = (0, 912.6913, 0);
	at[112] = 8.4500;
	points[113] = (-708.3425, 512.5945, 0);
	angles[113] = (0, 918.0917, 0);
	at[113] = 8.5000;
	points[114] = (-690.6141, 536.9213, 0);
	angles[114] = (0, 923.4924, 0);
	at[114] = 8.5500;
	points[115] = (-673.4528, 558.5236, 0);
	angles[115] = (0, 928.8929, 0);
	at[115] = 8.6000;
	points[116] = (-655.9134, 579.0276, 0);
	angles[116] = (0, 934.2933, 0);
	at[116] = 8.6500;
	points[117] = (-618.3622, 619.0551, 0);
	angles[117] = (0, 945.0946, 0);
	at[117] = 8.7500;
	points[118] = (-598.6181, 638.1457, 0);
	angles[118] = (0, 950.4951, 0);
	at[118] = 8.8000;
	points[119] = (-557.2795, 674.3504, 0);
	angles[119] = (0, 961.2960, 0);
	at[119] = 8.9000;
	points[120] = (-535.7795, 691.4252, 0);
	angles[120] = (0, 966.6967, 0);
	at[120] = 8.9500;
	points[121] = (-491.1575, 723.5079, 0);
	angles[121] = (0, 977.4977, 0);
	at[121] = 9.0500;
	points[122] = (-468.1339, 738.4725, 0);
	angles[122] = (0, 982.8983, 0);
	at[122] = 9.1000;
	points[123] = (-420.7205, 766.2402, 0);
	angles[123] = (0, 993.6993, 0);
	at[123] = 9.2000;
	points[124] = (-396.4016, 779.0158, 0);
	angles[124] = (0, 999.0999, 0);
	at[124] = 9.2500;
	points[125] = (-346.6441, 802.3110, 0);
	angles[125] = (0, 1009.9011, 0);
	at[125] = 9.3500;
	points[126] = (-295.5468, 822.5355, 0);
	angles[126] = (0, 1020.7020, 0);
	at[126] = 9.4500;
	points[127] = (-243.3236, 839.6024, 0);
	angles[127] = (0, 1031.5032, 0);
	at[127] = 9.5500;
	points[128] = (-190.1579, 853.4252, 0);
	angles[128] = (0, 1042.3042, 0);
	at[128] = 9.6500;
	points[129] = (-163.2638, 859.0945, 0);
	angles[129] = (0, 1047.7048, 0);
	at[129] = 9.7000;
	points[130] = (-109.0382, 867.8937, 0);
	angles[130] = (0, 1058.5060, 0);
	at[130] = 9.8000;
	points[131] = (-81.7346, 871.0040, 0);
	angles[131] = (0, 1063.9065, 0);
	at[131] = 9.8500;
	points[132] = (-54.3677, 873.1378, 0);
	angles[132] = (0, 1069.3069, 0);
	at[132] = 9.9000;
	points[133] = (0.5514, 875, 0);
	angles[133] = (0, 1080.1080, 0);
	at[133] = 10;
	mover = getEnt("iz_mover3", "targetname");
	if (!isDefined(mover))
		return;
	rider = getEnt("iz_bumper16_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	rider = getEnt("iz_bumper17_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	rider = getEnt("iz_bumper18_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	rider = getEnt("iz_bumper19_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	mover thread iz_mover_loop(points, angles, at, false, false);
}

iz_mover4()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (757.0551, 437.1496, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (765.0157, 422.4055, 0);
	angles[1] = (0, 5.4005, 0);
	at[1] = 0.0500;
	points[2] = (781.1851, 391.6248, 0);
	angles[2] = (0, 10.8011, 0);
	at[2] = 0.1000;
	points[3] = (794.6732, 363.8473, 0);
	angles[3] = (0, 16.2016, 0);
	at[3] = 0.1500;
	points[4] = (815.9607, 313.1827, 0);
	angles[4] = (0, 27.0027, 0);
	at[4] = 0.2500;
	points[5] = (834.1181, 261.3287, 0);
	angles[5] = (0, 37.8038, 0);
	at[5] = 0.3500;
	points[6] = (849.0590, 208.4677, 0);
	angles[6] = (0, 48.6049, 0);
	at[6] = 0.4500;
	points[7] = (855.3032, 181.7004, 0);
	angles[7] = (0, 54.0055, 0);
	at[7] = 0.5000;
	points[8] = (865.2637, 127.6772, 0);
	angles[8] = (0, 64.8066, 0);
	at[8] = 0.6000;
	points[9] = (868.9645, 100.4472, 0);
	angles[9] = (0, 70.2070, 0);
	at[9] = 0.6500;
	points[10] = (873.7480, 45.7157, 0);
	angles[10] = (0, 81.0081, 0);
	at[10] = 0.7500;
	points[11] = (874.7953, 18.2686, 0);
	angles[11] = (0, 86.4086, 0);
	at[11] = 0.8000;
	points[12] = (874.9449, -9.1991, 0);
	angles[12] = (0, 91.8092, 0);
	at[12] = 0.8500;
	points[13] = (872.5433, -64.0846, 0);
	angles[13] = (0, 102.6102, 0);
	at[13] = 0.9500;
	points[14] = (869.9961, -91.4473, 0);
	angles[14] = (0, 108.0107, 0);
	at[14] = 1;
	points[15] = (862.3071, -145.8394, 0);
	angles[15] = (0, 118.8119, 0);
	at[15] = 1.1000;
	points[16] = (857.1772, -172.8425, 0);
	angles[16] = (0, 124.2124, 0);
	at[16] = 1.1500;
	points[17] = (844.4174, -226.2728, 0);
	angles[17] = (0, 135.0135, 0);
	at[17] = 1.2500;
	points[18] = (836.7992, -252.6827, 0);
	angles[18] = (0, 140.4140, 0);
	at[18] = 1.3000;
	points[19] = (819.1732, -304.7122, 0);
	angles[19] = (0, 151.2151, 0);
	at[19] = 1.4000;
	points[20] = (798.4055, -355.5693, 0);
	angles[20] = (0, 162.0162, 0);
	at[20] = 1.5000;
	points[21] = (774.5630, -405.0787, 0);
	angles[21] = (0, 172.8173, 0);
	at[21] = 1.6000;
	points[22] = (747.7480, -453.0354, 0);
	angles[22] = (0, 183.6184, 0);
	at[22] = 1.7000;
	points[23] = (733.2441, -476.3504, 0);
	angles[23] = (0, 189.0189, 0);
	at[23] = 1.7500;
	points[24] = (702.0709, -521.6141, 0);
	angles[24] = (0, 199.8200, 0);
	at[24] = 1.8500;
	points[25] = (685.4449, -543.4646, 0);
	angles[25] = (0, 205.2205, 0);
	at[25] = 1.9000;
	points[26] = (650.1141, -585.5512, 0);
	angles[26] = (0, 216.0216, 0);
	at[26] = 2;
	points[27] = (631.4449, -605.6968, 0);
	angles[27] = (0, 221.4221, 0);
	at[27] = 2.0500;
	points[28] = (592.1732, -644.1181, 0);
	angles[28] = (0, 232.2233, 0);
	at[28] = 2.1500;
	points[29] = (571.6024, -662.3386, 0);
	angles[29] = (0, 237.6237, 0);
	at[29] = 2.2000;
	points[30] = (528.7795, -696.7441, 0);
	angles[30] = (0, 248.4248, 0);
	at[30] = 2.3000;
	points[31] = (506.5512, -712.9134, 0);
	angles[31] = (0, 253.8253, 0);
	at[31] = 2.3500;
	points[32] = (460.6654, -743.1141, 0);
	angles[32] = (0, 264.6264, 0);
	at[32] = 2.4500;
	points[33] = (437.0236, -757.1339, 0);
	angles[33] = (0, 270.0270, 0);
	at[33] = 2.5000;
	points[34] = (388.5342, -782.9489, 0);
	angles[34] = (0, 280.8281, 0);
	at[34] = 2.6000;
	points[35] = (338.5579, -805.7559, 0);
	angles[35] = (0, 291.6291, 0);
	at[35] = 2.7000;
	points[36] = (313.0575, -816.0118, 0);
	angles[36] = (0, 297.0298, 0);
	at[36] = 2.7500;
	points[37] = (261.2079, -834.1536, 0);
	angles[37] = (0, 307.8307, 0);
	at[37] = 2.8500;
	points[38] = (234.8752, -842.0354, 0);
	angles[38] = (0, 313.2313, 0);
	at[38] = 2.9000;
	points[39] = (181.5744, -855.3307, 0);
	angles[39] = (0, 324.0324, 0);
	at[39] = 3;
	points[40] = (154.6307, -860.7323, 0);
	angles[40] = (0, 329.4329, 0);
	at[40] = 3.0500;
	points[41] = (100.3134, -868.9882, 0);
	angles[41] = (0, 340.2341, 0);
	at[41] = 3.1500;
	points[42] = (45.5906, -873.7480, 0);
	angles[42] = (0, 351.0351, 0);
	at[42] = 3.2500;
	points[43] = (18.1230, -874.7953, 0);
	angles[43] = (0, 356.4357, 0);
	at[43] = 3.3000;
	points[44] = (-9.3335, -874.9449, 0);
	angles[44] = (0, 361.8362, 0);
	at[44] = 3.3500;
	points[45] = (-64.2350, -872.5236, 0);
	angles[45] = (0, 372.6372, 0);
	at[45] = 3.4500;
	points[46] = (-91.5756, -869.9882, 0);
	angles[46] = (0, 378.0378, 0);
	at[46] = 3.5000;
	points[47] = (-145.9823, -862.2795, 0);
	angles[47] = (0, 388.8390, 0);
	at[47] = 3.6000;
	points[48] = (-172.9677, -857.1497, 0);
	angles[48] = (0, 394.2394, 0);
	at[48] = 3.6500;
	points[49] = (-226.4032, -844.3819, 0);
	angles[49] = (0, 405.0405, 0);
	at[49] = 3.7500;
	points[50] = (-278.9642, -828.3386, 0);
	angles[50] = (0, 415.8417, 0);
	at[50] = 3.8500;
	points[51] = (-330.4335, -809.1221, 0);
	angles[51] = (0, 426.6427, 0);
	at[51] = 3.9500;
	points[52] = (-380.6284, -786.8071, 0);
	angles[52] = (0, 437.4438, 0);
	at[52] = 4.0500;
	points[53] = (-405.2087, -774.5000, 0);
	angles[53] = (0, 442.8444, 0);
	at[53] = 4.1000;
	points[54] = (-453.1457, -747.6771, 0);
	angles[54] = (0, 453.6453, 0);
	at[54] = 4.2000;
	points[55] = (-476.4803, -733.1575, 0);
	angles[55] = (0, 459.0459, 0);
	at[55] = 4.2500;
	points[56] = (-521.7244, -701.9961, 0);
	angles[56] = (0, 469.8469, 0);
	at[56] = 4.3500;
	points[57] = (-543.5827, -685.3583, 0);
	angles[57] = (0, 475.2476, 0);
	at[57] = 4.4000;
	points[58] = (-585.6614, -650.0197, 0);
	angles[58] = (0, 486.0486, 0);
	at[58] = 4.5000;
	points[59] = (-605.7992, -631.3543, 0);
	angles[59] = (0, 491.4492, 0);
	at[59] = 4.5500;
	points[60] = (-644.2166, -592.0590, 0);
	angles[60] = (0, 502.2502, 0);
	at[60] = 4.6500;
	points[61] = (-662.4252, -571.5079, 0);
	angles[61] = (0, 507.6507, 0);
	at[61] = 4.7000;
	points[62] = (-696.8307, -528.6614, 0);
	angles[62] = (0, 518.4518, 0);
	at[62] = 4.8000;
	points[63] = (-712.9843, -506.4488, 0);
	angles[63] = (0, 523.8524, 0);
	at[63] = 4.8500;
	points[64] = (-728.4488, -483.7205, 0);
	angles[64] = (0, 529.2529, 0);
	at[64] = 4.9000;
	points[65] = (-757.1968, -436.9095, 0);
	angles[65] = (0, 540.0540, 0);
	at[65] = 5;
	points[66] = (-783.0079, -388.4181, 0);
	angles[66] = (0, 550.8551, 0);
	at[66] = 5.1000;
	points[67] = (-794.7953, -363.5870, 0);
	angles[67] = (0, 556.2556, 0);
	at[67] = 5.1500;
	points[68] = (-816.0590, -312.9362, 0);
	angles[68] = (0, 567.0568, 0);
	at[68] = 5.2500;
	points[69] = (-834.1969, -261.0776, 0);
	angles[69] = (0, 577.8577, 0);
	at[69] = 5.3500;
	points[70] = (-849.1299, -208.1906, 0);
	angles[70] = (0, 588.6589, 0);
	at[70] = 5.4500;
	points[71] = (-855.3583, -181.4465, 0);
	angles[71] = (0, 594.0594, 0);
	at[71] = 5.5000;
	points[72] = (-860.7638, -154.4949, 0);
	angles[72] = (0, 599.4600, 0);
	at[72] = 5.5500;
	points[73] = (-868.9921, -100.1854, 0);
	angles[73] = (0, 610.2611, 0);
	at[73] = 5.6500;
	points[74] = (-871.8229, -72.8449, 0);
	angles[74] = (0, 615.6617, 0);
	at[74] = 5.7000;
	points[75] = (-874.7953, -17.9927, 0);
	angles[75] = (0, 626.4627, 0);
	at[75] = 5.8000;
	points[76] = (-874.9449, 9.4875, 0);
	angles[76] = (0, 631.8632, 0);
	at[76] = 5.8500;
	points[77] = (-872.5157, 64.3709, 0);
	angles[77] = (0, 642.6642, 0);
	at[77] = 5.9500;
	points[78] = (-869.9685, 91.7217, 0);
	angles[78] = (0, 648.0648, 0);
	at[78] = 6;
	points[79] = (-862.2520, 146.1264, 0);
	angles[79] = (0, 658.8660, 0);
	at[79] = 6.1000;
	points[80] = (-857.1221, 173.1024, 0);
	angles[80] = (0, 664.2664, 0);
	at[80] = 6.1500;
	points[81] = (-844.3386, 226.5492, 0);
	angles[81] = (0, 675.0675, 0);
	at[81] = 6.2500;
	points[82] = (-836.7244, 252.9323, 0);
	angles[82] = (0, 680.4681, 0);
	at[82] = 6.3000;
	points[83] = (-819.0787, 304.9697, 0);
	angles[83] = (0, 691.2692, 0);
	at[83] = 6.4000;
	points[84] = (-798.2874, 355.8347, 0);
	angles[84] = (0, 702.0701, 0);
	at[84] = 6.5000;
	points[85] = (-774.4370, 405.3228, 0);
	angles[85] = (0, 712.8713, 0);
	at[85] = 6.6000;
	points[86] = (-761.3898, 429.5079, 0);
	angles[86] = (0, 718.2718, 0);
	at[86] = 6.6500;
	points[87] = (-733.0906, 476.5984, 0);
	angles[87] = (0, 729.0729, 0);
	at[87] = 6.7500;
	points[88] = (-717.8583, 499.4567, 0);
	angles[88] = (0, 734.4736, 0);
	at[88] = 6.8000;
	points[89] = (-685.2677, 543.7008, 0);
	angles[89] = (0, 745.2745, 0);
	at[89] = 6.9000;
	points[90] = (-649.9291, 585.7559, 0);
	angles[90] = (0, 756.0756, 0);
	at[90] = 7;
	points[91] = (-631.2520, 605.9134, 0);
	angles[91] = (0, 761.4763, 0);
	at[91] = 7.0500;
	points[92] = (-611.9291, 625.4252, 0);
	angles[92] = (0, 766.8767, 0);
	at[92] = 7.1000;
	points[93] = (-571.3937, 662.5197, 0);
	angles[93] = (0, 777.6777, 0);
	at[93] = 7.2000;
	points[94] = (-550.2520, 680.0591, 0);
	angles[94] = (0, 783.0783, 0);
	at[94] = 7.2500;
	points[95] = (-506.3347, 713.0709, 0);
	angles[95] = (0, 793.8794, 0);
	at[95] = 7.3500;
	points[96] = (-460.4173, 743.2598, 0);
	angles[96] = (0, 804.6805, 0);
	at[96] = 7.4500;
	points[97] = (-436.7953, 757.2598, 0);
	angles[97] = (0, 810.0811, 0);
	at[97] = 7.5000;
	points[98] = (-412.7323, 770.5394, 0);
	angles[98] = (0, 815.4816, 0);
	at[98] = 7.5500;
	points[99] = (-363.4689, 794.8504, 0);
	angles[99] = (0, 826.2828, 0);
	at[99] = 7.6500;
	points[100] = (-312.8091, 816.1103, 0);
	angles[100] = (0, 837.0837, 0);
	at[100] = 7.7500;
	points[101] = (-260.9327, 834.2401, 0);
	angles[101] = (0, 847.8848, 0);
	at[101] = 7.8500;
	points[102] = (-208.0567, 849.1614, 0);
	angles[102] = (0, 858.6860, 0);
	at[102] = 7.9500;
	points[103] = (-181.3036, 855.3859, 0);
	angles[103] = (0, 864.0864, 0);
	at[103] = 8;
	points[104] = (-127.2598, 865.3347, 0);
	angles[104] = (0, 874.8876, 0);
	at[104] = 8.1000;
	points[105] = (-100.0504, 869.0157, 0);
	angles[105] = (0, 880.2880, 0);
	at[105] = 8.1500;
	points[106] = (-45.3020, 873.7678, 0);
	angles[106] = (0, 891.0891, 0);
	at[106] = 8.2500;
	points[107] = (-17.8638, 874.8032, 0);
	angles[107] = (0, 896.4897, 0);
	at[107] = 8.3000;
	points[108] = (37.0801, 874.1733, 0);
	angles[108] = (0, 907.2906, 0);
	at[108] = 8.4000;
	points[109] = (64.4980, 872.5079, 0);
	angles[109] = (0, 912.6913, 0);
	at[109] = 8.4500;
	points[110] = (119.1114, 866.5315, 0);
	angles[110] = (0, 923.4924, 0);
	at[110] = 8.5500;
	points[111] = (146.2543, 862.2323, 0);
	angles[111] = (0, 928.8929, 0);
	at[111] = 8.6000;
	points[112] = (173.2500, 857.0945, 0);
	angles[112] = (0, 934.2933, 0);
	at[112] = 8.6500;
	points[113] = (226.6811, 844.3031, 0);
	angles[113] = (0, 945.0946, 0);
	at[113] = 8.7500;
	points[114] = (279.2166, 828.2559, 0);
	angles[114] = (0, 955.8956, 0);
	at[114] = 8.8500;
	points[115] = (305.1063, 819.0276, 0);
	angles[115] = (0, 961.2960, 0);
	at[115] = 8.9000;
	points[116] = (355.9543, 798.2323, 0);
	angles[116] = (0, 972.0972, 0);
	at[116] = 9;
	points[117] = (405.4370, 774.3819, 0);
	angles[117] = (0, 982.8983, 0);
	at[117] = 9.1000;
	points[118] = (453.3819, 747.5316, 0);
	angles[118] = (0, 993.6995, 0);
	at[118] = 9.2000;
	points[119] = (476.7047, 733.0197, 0);
	angles[119] = (0, 999.0999, 0);
	at[119] = 9.2500;
	points[120] = (521.9331, 701.8346, 0);
	angles[120] = (0, 1009.9011, 0);
	at[120] = 9.3500;
	points[121] = (543.7992, 685.1851, 0);
	angles[121] = (0, 1015.3015, 0);
	at[121] = 9.4000;
	points[122] = (565.1221, 667.8465, 0);
	angles[122] = (0, 1020.7020, 0);
	at[122] = 9.4500;
	points[123] = (606.0079, 631.1536, 0);
	angles[123] = (0, 1031.5033, 0);
	at[123] = 9.5500;
	points[124] = (625.5276, 611.8307, 0);
	angles[124] = (0, 1036.9037, 0);
	at[124] = 9.6000;
	points[125] = (662.6142, 571.2834, 0);
	angles[125] = (0, 1047.7047, 0);
	at[125] = 9.7000;
	points[126] = (680.1418, 550.1496, 0);
	angles[126] = (0, 1053.1053, 0);
	at[126] = 9.7500;
	points[127] = (713.1535, 506.2126, 0);
	angles[127] = (0, 1063.9064, 0);
	at[127] = 9.8500;
	points[128] = (730.3819, 480.3819, 0);
	angles[128] = (0, 1069.3069, 0);
	at[128] = 9.9000;
	points[129] = (748.6771, 450.9685, 0);
	angles[129] = (0, 1074.7075, 0);
	at[129] = 9.9500;
	points[130] = (757.0551, 437.1496, 0);
	angles[130] = (0, 1080, 0);
	at[130] = 10;
	mover = getEnt("iz_mover4", "targetname");
	if (!isDefined(mover))
		return;
	rider = getEnt("iz_bumper20_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	rider = getEnt("iz_bumper21_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	rider = getEnt("iz_bumper22_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	rider = getEnt("iz_bumper23_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	rider = getEnt("iz_bumper24_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	rider = getEnt("iz_bumper25_touch", "targetname");
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
	points[0] = (757.0551, -437.1496, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (748.3701, -451.4724, 0);
	angles[1] = (0, 5.4005, 0);
	at[1] = 0.0500;
	points[2] = (729.9961, -480.9922, 0);
	angles[2] = (0, 10.8010, 0);
	at[2] = 0.1000;
	points[3] = (712.8307, -506.6614, 0);
	angles[3] = (0, 16.2016, 0);
	at[3] = 0.1500;
	points[4] = (679.7953, -550.5787, 0);
	angles[4] = (0, 27.0027, 0);
	at[4] = 0.2500;
	points[5] = (662.2520, -571.7008, 0);
	angles[5] = (0, 32.4032, 0);
	at[5] = 0.3000;
	points[6] = (625.1339, -612.2166, 0);
	angles[6] = (0, 43.2044, 0);
	at[6] = 0.4000;
	points[7] = (605.6024, -631.5276, 0);
	angles[7] = (0, 48.6049, 0);
	at[7] = 0.4500;
	points[8] = (585.4370, -650.2087, 0);
	angles[8] = (0, 54.0055, 0);
	at[8] = 0.5000;
	points[9] = (543.3661, -685.5275, 0);
	angles[9] = (0, 64.8066, 0);
	at[9] = 0.6000;
	points[10] = (521.4921, -702.1614, 0);
	angles[10] = (0, 70.2070, 0);
	at[10] = 0.6500;
	points[11] = (476.2402, -733.3149, 0);
	angles[11] = (0, 81.0081, 0);
	at[11] = 0.7500;
	points[12] = (429.1417, -761.5945, 0);
	angles[12] = (0, 91.8092, 0);
	at[12] = 0.8500;
	points[13] = (404.9488, -774.6339, 0);
	angles[13] = (0, 97.2097, 0);
	at[13] = 0.9000;
	points[14] = (355.4496, -798.4567, 0);
	angles[14] = (0, 108.0107, 0);
	at[14] = 1;
	points[15] = (304.5898, -819.2166, 0);
	angles[15] = (0, 118.8119, 0);
	at[15] = 1.1000;
	points[16] = (278.6937, -828.4370, 0);
	angles[16] = (0, 124.2124, 0);
	at[16] = 1.1500;
	points[17] = (226.1484, -844.4528, 0);
	angles[17] = (0, 135.0136, 0);
	at[17] = 1.2500;
	points[18] = (199.5154, -851.2480, 0);
	angles[18] = (0, 140.4140, 0);
	at[18] = 1.3000;
	points[19] = (145.7106, -862.3307, 0);
	angles[19] = (0, 151.2151, 0);
	at[19] = 1.4000;
	points[20] = (118.5646, -866.6063, 0);
	angles[20] = (0, 156.6157, 0);
	at[20] = 1.4500;
	points[21] = (63.9472, -872.5433, 0);
	angles[21] = (0, 167.4167, 0);
	at[21] = 1.5500;
	points[22] = (36.5294, -874.1968, 0);
	angles[22] = (0, 172.8173, 0);
	at[22] = 1.6000;
	points[23] = (-18.4146, -874.7834, 0);
	angles[23] = (0, 183.6183, 0);
	at[23] = 1.7000;
	points[24] = (-45.8512, -873.7323, 0);
	angles[24] = (0, 189.0189, 0);
	at[24] = 1.7500;
	points[25] = (-100.5976, -868.9449, 0);
	angles[25] = (0, 199.8200, 0);
	at[25] = 1.8500;
	points[26] = (-127.8059, -865.2480, 0);
	angles[26] = (0, 205.2205, 0);
	at[26] = 1.9000;
	points[27] = (-181.8425, -855.2756, 0);
	angles[27] = (0, 216.0216, 0);
	at[27] = 2;
	points[28] = (-208.5921, -849.0315, 0);
	angles[28] = (0, 221.4221, 0);
	at[28] = 2.0500;
	points[29] = (-261.4583, -834.0787, 0);
	angles[29] = (0, 232.2233, 0);
	at[29] = 2.1500;
	points[30] = (-287.5299, -825.3897, 0);
	angles[30] = (0, 237.6237, 0);
	at[30] = 2.2000;
	points[31] = (-338.7980, -805.6575, 0);
	angles[31] = (0, 248.4250, 0);
	at[31] = 2.3000;
	points[32] = (-388.7815, -782.8307, 0);
	angles[32] = (0, 259.2259, 0);
	at[32] = 2.4000;
	points[33] = (-437.2756, -756.9882, 0);
	angles[33] = (0, 270.0270, 0);
	at[33] = 2.5000;
	points[34] = (-484.0748, -728.2166, 0);
	angles[34] = (0, 280.8281, 0);
	at[34] = 2.6000;
	points[35] = (-506.7874, -712.7480, 0);
	angles[35] = (0, 286.2285, 0);
	at[35] = 2.6500;
	points[36] = (-550.6851, -679.7087, 0);
	angles[36] = (0, 297.0297, 0);
	at[36] = 2.7500;
	points[37] = (-571.8150, -662.1614, 0);
	angles[37] = (0, 302.4303, 0);
	at[37] = 2.8000;
	points[38] = (-612.3189, -625.0315, 0);
	angles[38] = (0, 313.2313, 0);
	at[38] = 2.9000;
	points[39] = (-631.6260, -605.5079, 0);
	angles[39] = (0, 318.6318, 0);
	at[39] = 2.9500;
	points[40] = (-650.2914, -585.3425, 0);
	angles[40] = (0, 324.0324, 0);
	at[40] = 3;
	points[41] = (-685.6063, -543.2677, 0);
	angles[41] = (0, 334.8335, 0);
	at[41] = 3.1000;
	points[42] = (-702.2402, -521.3819, 0);
	angles[42] = (0, 340.2341, 0);
	at[42] = 3.1500;
	points[43] = (-733.3818, -476.1339, 0);
	angles[43] = (0, 351.0352, 0);
	at[43] = 3.2500;
	points[44] = (-747.8937, -452.7835, 0);
	angles[44] = (0, 356.4356, 0);
	at[44] = 3.3000;
	points[45] = (-774.6968, -404.8346, 0);
	angles[45] = (0, 367.2367, 0);
	at[45] = 3.4000;
	points[46] = (-798.5118, -355.3303, 0);
	angles[46] = (0, 378.0378, 0);
	at[46] = 3.5000;
	points[47] = (-819.2717, -304.4539, 0);
	angles[47] = (0, 388.8389, 0);
	at[47] = 3.6000;
	points[48] = (-836.8859, -252.4047, 0);
	angles[48] = (0, 399.6400, 0);
	at[48] = 3.7000;
	points[49] = (-844.4882, -226.0165, 0);
	angles[49] = (0, 405.0405, 0);
	at[49] = 3.7500;
	points[50] = (-851.2756, -199.3874, 0);
	angles[50] = (0, 410.4410, 0);
	at[50] = 3.8000;
	points[51] = (-862.3504, -145.5819, 0);
	angles[51] = (0, 421.2422, 0);
	at[51] = 3.9000;
	points[52] = (-870.0236, -91.1728, 0);
	angles[52] = (0, 432.0432, 0);
	at[52] = 4;
	points[53] = (-872.5512, -63.8197, 0);
	angles[53] = (0, 437.4438, 0);
	at[53] = 4.0500;
	points[54] = (-874.9449, -8.9358, 0);
	angles[54] = (0, 448.2449, 0);
	at[54] = 4.1500;
	points[55] = (-874.7756, 18.5441, 0);
	angles[55] = (0, 453.6453, 0);
	at[55] = 4.2000;
	points[56] = (-873.7205, 46.0043, 0);
	angles[56] = (0, 459.0459, 0);
	at[56] = 4.2500;
	points[57] = (-868.9292, 100.7327, 0);
	angles[57] = (0, 469.8469, 0);
	at[57] = 4.3500;
	points[58] = (-860.6575, 155.0374, 0);
	angles[58] = (0, 480.6480, 0);
	at[58] = 4.4500;
	points[59] = (-855.2402, 181.9854, 0);
	angles[59] = (0, 486.0486, 0);
	at[59] = 4.5000;
	points[60] = (-841.9174, 235.2791, 0);
	angles[60] = (0, 496.8497, 0);
	at[60] = 4.6000;
	points[61] = (-825.4528, 287.4634, 0);
	angles[61] = (0, 507.6507, 0);
	at[61] = 4.7000;
	points[62] = (-816.1929, 312.8693, 0);
	angles[62] = (0, 513.0513, 0);
	at[62] = 4.7500;
	points[63] = (-805.5867, 338.9469, 0);
	angles[63] = (0, 518.4518, 0);
	at[63] = 4.8000;
	points[64] = (-792.5670, 367.5748, 0);
	angles[64] = (0, 523.8524, 0);
	at[64] = 4.8500;
	points[65] = (-778.4843, 396.3780, 0);
	angles[65] = (0, 529.2529, 0);
	at[65] = 4.9000;
	points[66] = (-766.2756, 420.2244, 0);
	angles[66] = (0, 534.6534, 0);
	at[66] = 4.9500;
	points[67] = (-756.9646, 437.3071, 0);
	angles[67] = (0, 540.0540, 0);
	at[67] = 5;
	points[68] = (-746.8858, 454.0472, 0);
	angles[68] = (0, 545.4546, 0);
	at[68] = 5.0500;
	points[69] = (-732.3898, 476.7677, 0);
	angles[69] = (0, 550.8550, 0);
	at[69] = 5.1000;
	points[70] = (-714.6141, 503.5079, 0);
	angles[70] = (0, 556.2557, 0);
	at[70] = 5.1500;
	points[71] = (-696.4882, 529.1181, 0);
	angles[71] = (0, 561.6561, 0);
	at[71] = 5.2000;
	points[72] = (-679.2953, 551.3622, 0);
	angles[72] = (0, 567.0567, 0);
	at[72] = 5.2500;
	points[73] = (-661.9607, 572.1102, 0);
	angles[73] = (0, 572.4573, 0);
	at[73] = 5.3000;
	points[74] = (-624.9370, 612.4094, 0);
	angles[74] = (0, 583.2584, 0);
	at[74] = 5.4000;
	points[75] = (-605.3976, 631.7323, 0);
	angles[75] = (0, 588.6588, 0);
	at[75] = 5.4500;
	points[76] = (-585.2480, 650.3818, 0);
	angles[76] = (0, 594.0594, 0);
	at[76] = 5.5000;
	points[77] = (-543.1496, 685.6969, 0);
	angles[77] = (0, 604.8605, 0);
	at[77] = 5.6000;
	points[78] = (-521.2795, 702.3189, 0);
	angles[78] = (0, 610.2611, 0);
	at[78] = 5.6500;
	points[79] = (-476.0158, 733.4606, 0);
	angles[79] = (0, 621.0621, 0);
	at[79] = 5.7500;
	points[80] = (-428.8898, 761.7323, 0);
	angles[80] = (0, 631.8632, 0);
	at[80] = 5.8500;
	points[81] = (-404.7166, 774.7520, 0);
	angles[81] = (0, 637.2637, 0);
	at[81] = 5.9000;
	points[82] = (-380.1307, 787.0433, 0);
	angles[82] = (0, 642.6642, 0);
	at[82] = 5.9500;
	points[83] = (-329.9221, 809.3347, 0);
	angles[83] = (0, 653.4653, 0);
	at[83] = 6.0500;
	points[84] = (-278.4409, 828.5197, 0);
	angles[84] = (0, 664.2664, 0);
	at[84] = 6.1500;
	points[85] = (-225.8697, 844.5276, 0);
	angles[85] = (0, 675.0675, 0);
	at[85] = 6.2500;
	points[86] = (-172.4260, 857.2638, 0);
	angles[86] = (0, 685.8686, 0);
	at[86] = 6.3500;
	points[87] = (-145.4382, 862.3779, 0);
	angles[87] = (0, 691.2690, 0);
	at[87] = 6.4000;
	points[88] = (-91.0252, 870.0433, 0);
	angles[88] = (0, 702.0703, 0);
	at[88] = 6.5000;
	points[89] = (-63.6839, 872.5630, 0);
	angles[89] = (0, 707.4707, 0);
	at[89] = 6.5500;
	points[90] = (-8.7818, 874.9449, 0);
	angles[90] = (0, 718.2718, 0);
	at[90] = 6.6500;
	points[91] = (18.6741, 874.7756, 0);
	angles[91] = (0, 723.6724, 0);
	at[91] = 6.7000;
	points[92] = (73.5386, 871.7599, 0);
	angles[92] = (0, 734.4734, 0);
	at[92] = 6.8000;
	points[93] = (100.8595, 868.9173, 0);
	angles[93] = (0, 739.8740, 0);
	at[93] = 6.8500;
	points[94] = (155.1713, 860.6378, 0);
	angles[94] = (0, 750.6750, 0);
	at[94] = 6.9500;
	points[95] = (182.1126, 855.2126, 0);
	angles[95] = (0, 756.0756, 0);
	at[95] = 7;
	points[96] = (235.4051, 841.8819, 0);
	angles[96] = (0, 766.8767, 0);
	at[96] = 7.1000;
	points[97] = (261.7335, 833.9882, 0);
	angles[97] = (0, 772.2772, 0);
	at[97] = 7.1500;
	points[98] = (313.5728, 815.8150, 0);
	angles[98] = (0, 783.0783, 0);
	at[98] = 7.2500;
	points[99] = (364.2130, 794.5079, 0);
	angles[99] = (0, 793.8794, 0);
	at[99] = 7.3500;
	points[100] = (389.0307, 782.7047, 0);
	angles[100] = (0, 799.2798, 0);
	at[100] = 7.4000;
	points[101] = (437.5040, 756.8544, 0);
	angles[101] = (0, 810.0811, 0);
	at[101] = 7.5000;
	points[102] = (461.1339, 742.8189, 0);
	angles[102] = (0, 815.4816, 0);
	at[102] = 7.5500;
	points[103] = (507.0039, 712.5945, 0);
	angles[103] = (0, 826.2826, 0);
	at[103] = 7.6500;
	points[104] = (529.2205, 696.4134, 0);
	angles[104] = (0, 831.6831, 0);
	at[104] = 7.7000;
	points[105] = (572.0236, 661.9764, 0);
	angles[105] = (0, 842.4843, 0);
	at[105] = 7.8000;
	points[106] = (592.5787, 643.7402, 0);
	angles[106] = (0, 847.8848, 0);
	at[106] = 7.8500;
	points[107] = (631.8228, 605.2953, 0);
	angles[107] = (0, 858.6858, 0);
	at[107] = 7.9500;
	points[108] = (650.4803, 585.1378, 0);
	angles[108] = (0, 864.0864, 0);
	at[108] = 8;
	points[109] = (685.7834, 543.0315, 0);
	angles[109] = (0, 874.8876, 0);
	at[109] = 8.1000;
	points[110] = (702.4016, 521.1732, 0);
	angles[110] = (0, 880.2880, 0);
	at[110] = 8.1500;
	points[111] = (733.5354, 475.8898, 0);
	angles[111] = (0, 891.0891, 0);
	at[111] = 8.2500;
	points[112] = (748.0276, 452.5630, 0);
	angles[112] = (0, 896.4896, 0);
	at[112] = 8.3000;
	points[113] = (774.8228, 404.5905, 0);
	angles[113] = (0, 907.2906, 0);
	at[113] = 8.4000;
	points[114] = (787.1024, 380.0173, 0);
	angles[114] = (0, 912.6912, 0);
	at[114] = 8.4500;
	points[115] = (809.3819, 329.7980, 0);
	angles[115] = (0, 923.4924, 0);
	at[115] = 8.5500;
	points[116] = (828.5630, 278.3012, 0);
	angles[116] = (0, 934.2933, 0);
	at[116] = 8.6500;
	points[117] = (844.5630, 225.7410, 0);
	angles[117] = (0, 945.0945, 0);
	at[117] = 8.7500;
	points[118] = (857.2913, 172.3024, 0);
	angles[118] = (0, 955.8956, 0);
	at[118] = 8.8500;
	points[119] = (862.4016, 145.2957, 0);
	angles[119] = (0, 961.2960, 0);
	at[119] = 8.9000;
	points[120] = (870.0591, 90.8972, 0);
	angles[120] = (0, 972.0972, 0);
	at[120] = 9;
	points[121] = (872.5787, 63.5335, 0);
	angles[121] = (0, 977.4977, 0);
	at[121] = 9.0500;
	points[122] = (874.9449, 8.6477, 0);
	angles[122] = (0, 988.2986, 0);
	at[122] = 9.1500;
	points[123] = (874.7756, -18.8181, 0);
	angles[123] = (0, 993.6993, 0);
	at[123] = 9.2000;
	points[124] = (873.7048, -46.2658, 0);
	angles[124] = (0, 999.0999, 0);
	at[124] = 9.2500;
	points[125] = (868.9016, -100.9941, 0);
	angles[125] = (0, 1009.9011, 0);
	at[125] = 9.3500;
	points[126] = (865.1851, -128.2213, 0);
	angles[126] = (0, 1015.3015, 0);
	at[126] = 9.4000;
	points[127] = (855.1890, -182.2374, 0);
	angles[127] = (0, 1026.1025, 0);
	at[127] = 9.5000;
	points[128] = (848.9252, -209.0020, 0);
	angles[128] = (0, 1031.5032, 0);
	at[128] = 9.5500;
	points[129] = (833.9528, -261.8539, 0);
	angles[129] = (0, 1042.3042, 0);
	at[129] = 9.6500;
	points[130] = (815.7678, -313.6972, 0);
	angles[130] = (0, 1053.1052, 0);
	at[130] = 9.7500;
	points[131] = (794.4449, -364.3484, 0);
	angles[131] = (0, 1063.9064, 0);
	at[131] = 9.8500;
	points[132] = (782.5867, -389.1063, 0);
	angles[132] = (0, 1069.3069, 0);
	at[132] = 9.9000;
	points[133] = (756.7993, -437.6299, 0);
	angles[133] = (0, 1080.1080, 0);
	at[133] = 10;
	mover = getEnt("iz_mover5", "targetname");
	if (!isDefined(mover))
		return;
	rider = getEnt("iz_bumper26_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	rider = getEnt("iz_bumper27_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	rider = getEnt("iz_bumper28_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	rider = getEnt("iz_bumper29_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	mover thread iz_mover_loop(points, angles, at, false, false);
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
