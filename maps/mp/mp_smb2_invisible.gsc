main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_smb2_invisible", 0);

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
	points[0] = (0, -14000, 840);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, -13998.5830, 839.7480);
	angles[1] = (0, 0.0268, 0.0268);
	at[1] = 0.0500;
	points[2] = (0, -13994.3311, 839.0079);
	angles[2] = (0, 0.1066, 0.1066);
	at[2] = 0.1000;
	points[3] = (0, -13987.3232, 837.7756);
	angles[3] = (0, 0.2381, 0.2381);
	at[3] = 0.1500;
	points[4] = (0, -13977.5986, 836.0748);
	angles[4] = (0, 0.4205, 0.4205);
	at[4] = 0.2000;
	points[5] = (0, -13965.1973, 833.9094);
	angles[5] = (0, 0.6525, 0.6525);
	at[5] = 0.2500;
	points[6] = (0, -13950.3154, 831.2913);
	angles[6] = (0, 0.9331, 0.9331);
	at[6] = 0.3000;
	points[7] = (0, -13932.7959, 828.2244);
	angles[7] = (0, 1.2613, 1.2613);
	at[7] = 0.3500;
	points[8] = (0, -13912.8340, 824.7323);
	angles[8] = (0, 1.6358, 1.6358);
	at[8] = 0.4000;
	points[9] = (0, -13890.4326, 820.8110);
	angles[9] = (0, 2.0558, 2.0558);
	at[9] = 0.4500;
	points[10] = (0, -13865.7480, 816.4803);
	angles[10] = (0, 2.5200, 2.5200);
	at[10] = 0.5000;
	points[11] = (0, -13838.7002, 811.7402);
	angles[11] = (0, 3.0274, 3.0274);
	at[11] = 0.5500;
	points[12] = (0, -13809.4492, 806.6181);
	angles[12] = (0, 3.5770, 3.5770);
	at[12] = 0.6000;
	points[13] = (0, -13777.9521, 801.1024);
	angles[13] = (0, 4.1675, 4.1675);
	at[13] = 0.6500;
	points[14] = (0, -13744.3701, 795.2205);
	angles[14] = (0, 4.7981, 4.7981);
	at[14] = 0.7000;
	points[15] = (0, -13708.7402, 788.9686);
	angles[15] = (0, 5.4675, 5.4675);
	at[15] = 0.7500;
	points[16] = (0, -13670.9854, 782.3701);
	angles[16] = (0, 6.1747, 6.1747);
	at[16] = 0.8000;
	points[17] = (0, -13631.3779, 775.4252);
	angles[17] = (0, 6.9187, 6.9187);
	at[17] = 0.8500;
	points[18] = (0, -13589.8828, 768.1536);
	angles[18] = (0, 7.6982, 7.6982);
	at[18] = 0.9000;
	points[19] = (0, -13546.4561, 760.5512);
	angles[19] = (0, 8.5124, 8.5124);
	at[19] = 0.9500;
	points[20] = (0, -13501.3379, 752.6417);
	angles[20] = (0, 9.3600, 9.3600);
	at[20] = 1;
	points[21] = (0, -13454.4102, 744.4292);
	angles[21] = (0, 10.2400, 10.2400);
	at[21] = 1.0500;
	points[22] = (0, -13405.9062, 735.9252);
	angles[22] = (0, 11.1514, 11.1514);
	at[22] = 1.1000;
	points[23] = (0, -13355.7080, 727.1339);
	angles[23] = (0, 12.0929, 12.0929);
	at[23] = 1.1500;
	points[24] = (0, -13303.9766, 718.0748);
	angles[24] = (0, 13.0637, 13.0637);
	at[24] = 1.2000;
	points[25] = (0, -13250.7881, 708.7520);
	angles[25] = (0, 14.0625, 14.0625);
	at[25] = 1.2500;
	points[26] = (0, -13196.1025, 699.1772);
	angles[26] = (0, 15.0883, 15.0883);
	at[26] = 1.3000;
	points[27] = (0, -13140.1182, 689.3583);
	angles[27] = (0, 16.1400, 16.1400);
	at[27] = 1.3500;
	points[28] = (0, -13082.7168, 679.3110);
	angles[28] = (0, 17.2167, 17.2167);
	at[28] = 1.4000;
	points[29] = (0, -13024.1338, 669.0394);
	angles[29] = (0, 18.3170, 18.3170);
	at[29] = 1.4500;
	points[30] = (0, -12964.2910, 658.5591);
	angles[30] = (0, 19.4400, 19.4400);
	at[30] = 1.5000;
	points[31] = (0, -12903.3066, 647.8780);
	angles[31] = (0, 20.5846, 20.5846);
	at[31] = 1.5500;
	points[32] = (0, -12841.2207, 637.0039);
	angles[32] = (0, 21.7498, 21.7498);
	at[32] = 1.6000;
	points[33] = (0, -12714.0156, 614.7166);
	angles[33] = (0, 24.1373, 24.1373);
	at[33] = 1.7000;
	points[34] = (0, -12649.0156, 603.3307);
	angles[34] = (0, 25.3575, 25.3575);
	at[34] = 1.7500;
	points[35] = (0, -12516.4961, 580.1102);
	angles[35] = (0, 27.8454, 27.8454);
	at[35] = 1.8500;
	points[36] = (0, -12380.9062, 556.3661);
	angles[36] = (0, 30.3895, 30.3895);
	at[36] = 1.9500;
	points[37] = (0, -12242.8740, 532.1733);
	angles[37] = (0, 32.9812, 32.9812);
	at[37] = 2.0500;
	points[38] = (0, -12102.7168, 507.6221);
	angles[38] = (0, 35.6118, 35.6118);
	at[38] = 2.1500;
	points[39] = (0, -11960.9062, 482.7914);
	angles[39] = (0, 38.2725, 38.2725);
	at[39] = 2.2500;
	points[40] = (0, -11818.0322, 457.7559);
	angles[40] = (0, 40.9548, 40.9548);
	at[40] = 2.3500;
	points[41] = (0, -11386.9688, 382.2457);
	angles[41] = (0, 49.0451, 49.0451);
	at[41] = 2.6500;
	points[42] = (0, -11244.0947, 357.2095);
	angles[42] = (0, 51.7275, 51.7275);
	at[42] = 2.7500;
	points[43] = (0, -11102.2832, 332.3760);
	angles[43] = (0, 54.3883, 54.3883);
	at[43] = 2.8500;
	points[44] = (0, -10962.1260, 307.8252);
	angles[44] = (0, 57.0188, 57.0188);
	at[44] = 2.9500;
	points[45] = (0, -10892.8350, 295.6799);
	angles[45] = (0, 58.3200, 58.3200);
	at[45] = 3;
	points[46] = (0, -10755.9844, 271.7028);
	angles[46] = (0, 60.8889, 60.8889);
	at[46] = 3.1000;
	points[47] = (0, -10688.5039, 259.8910);
	angles[47] = (0, 62.1545, 62.1545);
	at[47] = 3.1500;
	points[48] = (0, -10555.9844, 236.6701);
	angles[48] = (0, 64.6426, 64.6426);
	at[48] = 3.2500;
	points[49] = (0, -10490.9844, 225.2819);
	angles[49] = (0, 65.8627, 65.8627);
	at[49] = 3.3000;
	points[50] = (0, -10363.7793, 202.9972);
	angles[50] = (0, 68.2503, 68.2503);
	at[50] = 3.4000;
	points[51] = (0, -10301.6924, 192.1228);
	angles[51] = (0, 69.4154, 69.4154);
	at[51] = 3.4500;
	points[52] = (0, -10240.7090, 181.4402);
	angles[52] = (0, 70.5600, 70.5600);
	at[52] = 3.5000;
	points[53] = (0, -10180.8662, 170.9583);
	angles[53] = (0, 71.6830, 71.6830);
	at[53] = 3.5500;
	points[54] = (0, -10122.2832, 160.6886);
	angles[54] = (0, 72.7833, 72.7833);
	at[54] = 3.6000;
	points[55] = (0, -10064.8818, 150.6406);
	angles[55] = (0, 73.8599, 73.8599);
	at[55] = 3.6500;
	points[56] = (0, -10008.8975, 140.8244);
	angles[56] = (0, 74.9117, 74.9117);
	at[56] = 3.7000;
	points[57] = (0, -9954.2129, 131.2508);
	angles[57] = (0, 75.9376, 75.9376);
	at[57] = 3.7500;
	points[58] = (0, -9901.0234, 121.9276);
	angles[58] = (0, 76.9363, 76.9363);
	at[58] = 3.8000;
	points[59] = (0, -9849.2910, 112.8681);
	angles[59] = (0, 77.9070, 77.9070);
	at[59] = 3.8500;
	points[60] = (0, -9799.0947, 104.0795);
	angles[60] = (0, 78.8486, 78.8486);
	at[60] = 3.9000;
	points[61] = (0, -9750.5908, 95.5736);
	angles[61] = (0, 79.7600, 79.7600);
	at[61] = 3.9500;
	points[62] = (0, -9703.6621, 87.3598);
	angles[62] = (0, 80.6400, 80.6400);
	at[62] = 4;
	points[63] = (0, -9658.5430, 79.4484);
	angles[63] = (0, 81.4877, 81.4877);
	at[63] = 4.0500;
	points[64] = (0, -9615.1182, 71.8500);
	angles[64] = (0, 82.3018, 82.3018);
	at[64] = 4.1000;
	points[65] = (0, -9573.6221, 64.5736);
	angles[65] = (0, 83.0814, 83.0814);
	at[65] = 4.1500;
	points[66] = (0, -9534.0156, 57.6315);
	angles[66] = (0, 83.8253, 83.8253);
	at[66] = 4.2000;
	points[67] = (0, -9496.2598, 51.0303);
	angles[67] = (0, 84.5324, 84.5324);
	at[67] = 4.2500;
	points[68] = (0, -9460.6299, 44.7815);
	angles[68] = (0, 85.2020, 85.2020);
	at[68] = 4.3000;
	points[69] = (0, -9427.0479, 38.8970);
	angles[69] = (0, 85.8324, 85.8324);
	at[69] = 4.3500;
	points[70] = (0, -9395.5518, 33.3849);
	angles[70] = (0, 86.4230, 86.4230);
	at[70] = 4.4000;
	points[71] = (0, -9366.2998, 28.2564);
	angles[71] = (0, 86.9725, 86.9725);
	at[71] = 4.4500;
	points[72] = (0, -9339.2520, 23.5198);
	angles[72] = (0, 87.4799, 87.4799);
	at[72] = 4.5000;
	points[73] = (0, -9314.5674, 19.1877);
	angles[73] = (0, 87.9442, 87.9442);
	at[73] = 4.5500;
	points[74] = (0, -9292.1650, 15.2678);
	angles[74] = (0, 88.3642, 88.3642);
	at[74] = 4.6000;
	points[75] = (0, -9272.2051, 11.7712);
	angles[75] = (0, 88.7387, 88.7387);
	at[75] = 4.6500;
	points[76] = (0, -9254.6855, 8.7095);
	angles[76] = (0, 89.0669, 89.0669);
	at[76] = 4.7000;
	points[77] = (0, -9239.8027, 6.0902);
	angles[77] = (0, 89.3475, 89.3475);
	at[77] = 4.7500;
	points[78] = (0, -9227.4023, 3.9247);
	angles[78] = (0, 89.5795, 89.5795);
	at[78] = 4.8000;
	points[79] = (0, -9217.6768, 2.2232);
	angles[79] = (0, 89.7619, 89.7619);
	at[79] = 4.8500;
	points[80] = (0, -9210.6699, 0.9941);
	angles[80] = (0, 89.8934, 89.8934);
	at[80] = 4.9000;
	points[81] = (0, -9206.4180, 0.2501);
	angles[81] = (0, 89.9732, 89.9732);
	at[81] = 4.9500;
	points[82] = (0, -9205, 0);
	angles[82] = (0, 90, 90);
	at[82] = 5;
	points[83] = (0, -9205, 0);
	angles[83] = (0, 90, 90);
	at[83] = 1000;
	mover = getEnt("iz_mover0", "targetname");
	if (!isDefined(mover))
		return;
	rider = getEnt("endmap_trig", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	mover thread iz_mover_play(points, angles, at, false, 1, 1);
}

iz_mover1()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, -14000, 840);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, -13998.5830, 839.7480);
	angles[1] = (0, 0.0267, 0.0267);
	at[1] = 0.0500;
	points[2] = (0, -13994.3311, 839.0079);
	angles[2] = (0, 0.1062, 0.1062);
	at[2] = 0.1000;
	points[3] = (0, -13987.3232, 837.7874);
	angles[3] = (0, 0.2372, 0.2372);
	at[3] = 0.1500;
	points[4] = (0, -13977.6768, 836.0867);
	angles[4] = (0, 0.4189, 0.4189);
	at[4] = 0.2000;
	points[5] = (0, -13965.3545, 833.9292);
	angles[5] = (0, 0.6500, 0.6500);
	at[5] = 0.2500;
	points[6] = (0, -13950.4336, 831.3268);
	angles[6] = (0, 0.9296, 0.9296);
	at[6] = 0.3000;
	points[7] = (0, -13933.0703, 828.2756);
	angles[7] = (0, 1.2565, 1.2565);
	at[7] = 0.3500;
	points[8] = (0, -13913.1885, 824.7874);
	angles[8] = (0, 1.6296, 1.6296);
	at[8] = 0.4000;
	points[9] = (0, -13890.8662, 820.8820);
	angles[9] = (0, 2.0480, 2.0480);
	at[9] = 0.4500;
	points[10] = (0, -13866.2207, 816.5709);
	angles[10] = (0, 2.5104, 2.5105);
	at[10] = 0.5000;
	points[11] = (0, -13839.3701, 811.8543);
	angles[11] = (0, 3.0160, 3.0160);
	at[11] = 0.5500;
	points[12] = (0, -13810.1582, 806.7441);
	angles[12] = (0, 3.5635, 3.5635);
	at[12] = 0.6000;
	points[13] = (0, -13778.8193, 801.2480);
	angles[13] = (0, 4.1519, 4.1519);
	at[13] = 0.6500;
	points[14] = (0, -14000, 840);
	angles[14] = (0, 0, 0);
	at[14] = 0.7000;
	points[15] = (0, -14000, 840);
	angles[15] = (0, 0, 0);
	at[15] = 0.9000;
	points[16] = (0, -13548.1494, 760.8425);
	angles[16] = (0, 8.4811, 8.4811);
	at[16] = 0.9500;
	points[17] = (0, -13503.1504, 752.9606);
	angles[17] = (0, 9.3257, 9.3257);
	at[17] = 1;
	points[18] = (0, -13456.4570, 744.7717);
	angles[18] = (0, 10.2027, 10.2027);
	at[18] = 1.0500;
	points[19] = (0, -13407.9922, 736.2953);
	angles[19] = (0, 11.1109, 11.1109);
	at[19] = 1.1000;
	points[20] = (0, -13358.0322, 727.5394);
	angles[20] = (0, 12.0492, 12.0492);
	at[20] = 1.1500;
	points[21] = (0, -13306.4961, 718.5079);
	angles[21] = (0, 13.0168, 13.0168);
	at[21] = 1.2000;
	points[22] = (0, -13253.4648, 709.2205);
	angles[22] = (0, 14.0122, 14.0122);
	at[22] = 1.2500;
	points[23] = (0, -13198.9766, 699.6771);
	angles[23] = (0, 15.0346, 15.0346);
	at[23] = 1.3000;
	points[24] = (0, -13143.1494, 689.8937);
	angles[24] = (0, 16.0829, 16.0829);
	at[24] = 1.3500;
	points[25] = (0, -14000, 840);
	angles[25] = (0, 0, 0);
	at[25] = 1.4000;
	points[26] = (0, -14000, 840);
	angles[26] = (0, 0, 0);
	at[26] = 1.7000;
	points[27] = (0, -12653.5430, 604.1299);
	angles[27] = (0, 25.2719, 25.2719);
	at[27] = 1.7500;
	points[28] = (0, -12521.3779, 580.9764);
	angles[28] = (0, 27.7527, 27.7527);
	at[28] = 1.8500;
	points[29] = (0, -12386.2197, 557.2953);
	angles[29] = (0, 30.2897, 30.2897);
	at[29] = 1.9500;
	points[30] = (0, -12248.5439, 533.1693);
	angles[30] = (0, 32.8745, 32.8745);
	at[30] = 2.0500;
	points[31] = (0, -12108.7412, 508.6811);
	angles[31] = (0, 35.4983, 35.4983);
	at[31] = 2.1500;
	points[32] = (0, -14000, 840);
	angles[32] = (0, 0, 0);
	at[32] = 2.2000;
	points[33] = (0, -14000, 840);
	angles[33] = (0, 0, 0);
	at[33] = 2.3000;
	points[34] = (0, -11824.7637, 458.9331);
	angles[34] = (0, 40.8287, 40.8287);
	at[34] = 2.3500;
	points[35] = (0, -11323.1494, 371.0583);
	angles[35] = (0, 50.2438, 50.2438);
	at[35] = 2.7000;
	points[36] = (0, -14000, 840);
	angles[36] = (0, 0, 0);
	at[36] = 2.7500;
	points[37] = (0, -14000, 840);
	angles[37] = (0, 0, 0);
	at[37] = 2.8500;
	points[38] = (0, -11040.1182, 321.4835);
	angles[38] = (0, 55.5554, 55.5554);
	at[38] = 2.9000;
	points[39] = (0, -10901.1025, 297.1303);
	angles[39] = (0, 58.1645, 58.1645);
	at[39] = 3;
	points[40] = (0, -10832.4414, 285.0980);
	angles[40] = (0, 59.4538, 59.4538);
	at[40] = 3.0500;
	points[41] = (0, -10696.9688, 261.3717);
	angles[41] = (0, 61.9959, 61.9959);
	at[41] = 3.1500;
	points[42] = (0, -10630.3535, 249.6965);
	angles[42] = (0, 63.2468, 63.2468);
	at[42] = 3.2000;
	points[43] = (0, -14000, 840);
	angles[43] = (0, 0, 0);
	at[43] = 3.2500;
	points[44] = (0, -14000, 840);
	angles[44] = (0, 0, 0);
	at[44] = 3.3500;
	points[45] = (0, -10372.3232, 204.4902);
	angles[45] = (0, 68.0904, 68.0904);
	at[45] = 3.4000;
	points[46] = (0, -10310.2363, 193.6114);
	angles[46] = (0, 69.2559, 69.2559);
	at[46] = 3.4500;
	points[47] = (0, -10249.1738, 182.9232);
	angles[47] = (0, 70.4011, 70.4011);
	at[47] = 3.5000;
	points[48] = (0, -10189.3301, 172.4346);
	angles[48] = (0, 71.5250, 71.5250);
	at[48] = 3.5500;
	points[49] = (0, -10130.6299, 162.1543);
	angles[49] = (0, 72.6264, 72.6264);
	at[49] = 3.6000;
	points[50] = (0, -14000, 840);
	angles[50] = (0, 0, 0);
	at[50] = 3.6500;
	points[51] = (0, -14000, 840);
	angles[51] = (0, 0, 0);
	at[51] = 3.7500;
	points[52] = (0, -9908.9766, 123.3287);
	angles[52] = (0, 76.7862, 76.7862);
	at[52] = 3.8000;
	points[53] = (0, -9857.2051, 114.2468);
	angles[53] = (0, 77.7594, 77.7594);
	at[53] = 3.8500;
	points[54] = (0, -9806.8506, 105.4327);
	angles[54] = (0, 78.7037, 78.7037);
	at[54] = 3.9000;
	points[55] = (0, -9758.1494, 96.8996);
	angles[55] = (0, 79.6179, 79.6179);
	at[55] = 3.9500;
	points[56] = (0, -14000, 840);
	angles[56] = (0, 0, 0);
	at[56] = 4;
	points[57] = (0, -14000, 840);
	angles[57] = (0, 0, 0);
	at[57] = 4.1000;
	points[58] = (0, -9580.3936, 65.7614);
	angles[58] = (0, 82.9541, 82.9541);
	at[58] = 4.1500;
	points[59] = (0, -9540.5117, 58.7768);
	angles[59] = (0, 83.7026, 83.7026);
	at[59] = 4.2000;
	points[60] = (0, -9502.5596, 52.1311);
	angles[60] = (0, 84.4146, 84.4146);
	at[60] = 4.2500;
	points[61] = (0, -9466.6533, 45.8339);
	angles[61] = (0, 85.0893, 85.0893);
	at[61] = 4.3000;
	points[62] = (0, -14000, 840);
	angles[62] = (0, 0, 0);
	at[62] = 4.3500;
	points[63] = (0, -14000, 840);
	angles[63] = (0, 0, 0);
	at[63] = 4.4500;
	points[64] = (0, -9343.9375, 24.3463);
	angles[64] = (0, 87.3915, 87.3915);
	at[64] = 4.5000;
	points[65] = (0, -9318.8975, 19.9496);
	angles[65] = (0, 87.8626, 87.8626);
	at[65] = 4.5500;
	points[66] = (0, -9296.1416, 15.9614);
	angles[66] = (0, 88.2898, 88.2898);
	at[66] = 4.6000;
	points[67] = (0, -14000, 840);
	angles[67] = (0, 0, 0);
	at[67] = 4.6500;
	points[68] = (0, -14000, 840);
	angles[68] = (0, 0, 0);
	at[68] = 4.7000;
	points[69] = (0, -9242.4404, 6.5587);
	angles[69] = (0, 89.2972, 89.2972);
	at[69] = 4.7500;
	points[70] = (0, -14000, 840);
	angles[70] = (0, 0, 0);
	at[70] = 4.8000;
	points[71] = (0, -14000, 840);
	angles[71] = (0, 0, 0);
	at[71] = 4.8500;
	points[72] = (0, -9211.8506, 1.2036);
	angles[72] = (0, 89.8711, 89.8711);
	at[72] = 4.9000;
	points[73] = (0, -14000, 840);
	angles[73] = (0, 0, 0);
	at[73] = 4.9500;
	points[74] = (0, -14000, 840);
	angles[74] = (0, 0, 0);
	at[74] = 5;
	points[75] = (0, -9205, 0);
	angles[75] = (0, 90, 90);
	at[75] = 5.0500;
	points[76] = (0, -14000, 840);
	angles[76] = (0, 0, 0);
	at[76] = 5.1000;
	points[77] = (0, -14000, 840);
	angles[77] = (0, 0, 0);
	at[77] = 1000;
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
