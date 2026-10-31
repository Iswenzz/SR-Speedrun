main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_smb2_combination", 0);

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
	ambientPlay("iz_0_nabe", 2);
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
	points[0] = (0, -4970, 1050);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, -4970, 1048.4725);
	angles[1] = (0, 0, 0);
	at[1] = 0.2500;
	points[2] = (0, -4970, 1042.9370);
	angles[2] = (0, 0, 0);
	at[2] = 0.5500;
	points[3] = (0, -4970, 1033.8583);
	angles[3] = (0, 0, 0);
	at[3] = 0.8500;
	points[4] = (0, -4970, 1021.7835);
	angles[4] = (0, 0, 0);
	at[4] = 1.1500;
	points[5] = (0, -4970, 1007.2599);
	angles[5] = (0, 0, 0);
	at[5] = 1.4500;
	points[6] = (0, -4970, 987.9449);
	angles[6] = (0, 0, 0);
	at[6] = 1.8000;
	points[7] = (0, -4970, 969.9843);
	angles[7] = (0, 0, 0);
	at[7] = 2.1000;
	points[8] = (0, -4970, 910.9095);
	angles[8] = (0, 0, 0);
	at[8] = 3.0500;
	points[9] = (0, -4970, 896.3228);
	angles[9] = (0, 0, 0);
	at[9] = 3.3000;
	points[10] = (0, -4970, 882.7402);
	angles[10] = (0, 0, 0);
	at[10] = 3.5500;
	points[11] = (0, -4970, 868.2166);
	angles[11] = (0, 0, 0);
	at[11] = 3.8500;
	points[12] = (0, -4970, 857.9606);
	angles[12] = (0, 0, 0);
	at[12] = 4.1000;
	points[13] = (0, -4970, 849.7244);
	angles[13] = (0, 0, 0);
	at[13] = 4.3500;
	points[14] = (0, -4970, 844.7953);
	angles[14] = (0, 0, 0);
	at[14] = 4.5500;
	points[15] = (0, -4970, 840.5512);
	angles[15] = (0, 0, 0);
	at[15] = 4.8500;
	points[16] = (0, -4970, 840);
	angles[16] = (0, 0.9331, 0);
	at[16] = 5.3000;
	points[17] = (0, -4970, 840);
	angles[17] = (0, 3.5770, 0);
	at[17] = 5.6000;
	points[18] = (0, -4970, 840);
	angles[18] = (0, 7.6982, 0);
	at[18] = 5.9000;
	points[19] = (0, -4970, 840);
	angles[19] = (0, 14.0625, 0);
	at[19] = 6.2500;
	points[20] = (0, -4970, 840);
	angles[20] = (0, 22.9343, 0);
	at[20] = 6.6500;
	points[21] = (0, -4970, 840);
	angles[21] = (0, 63.4061, 0);
	at[21] = 8.2000;
	points[22] = (0, -4970, 840);
	angles[22] = (0, 77.9071, 0);
	at[22] = 8.8500;
	points[23] = (0, -4970, 840);
	angles[23] = (0, 83.8253, 0);
	at[23] = 9.2000;
	points[24] = (0, -4970, 840);
	angles[24] = (0, 87.9442, 0);
	at[24] = 9.5500;
	points[25] = (0, -4970, 840);
	angles[25] = (0, 89.7619, 0);
	at[25] = 9.8500;
	points[26] = (0, -4970, 840.9803);
	angles[26] = (0, 90, 0);
	at[26] = 10.2000;
	points[27] = (0, -4970, 844.7953);
	angles[27] = (0, 90, 0);
	at[27] = 10.4500;
	points[28] = (0, -4970, 852.7599);
	angles[28] = (0, 90, 0);
	at[28] = 10.7500;
	points[29] = (0, -4970, 863.8898);
	angles[29] = (0, 90, 0);
	at[29] = 11.0500;
	points[30] = (0, -4970, 877.6614);
	angles[30] = (0, 90, 0);
	at[30] = 11.3500;
	points[31] = (0, -4970, 890.7520);
	angles[31] = (0, 90, 0);
	at[31] = 11.6000;
	points[32] = (0, -4970, 907.9291);
	angles[32] = (0, 90, 0);
	at[32] = 11.9000;
	points[33] = (0, -4970, 969.9843);
	angles[33] = (0, 90, 0);
	at[33] = 12.9000;
	points[34] = (0, -4970, 990.8307);
	angles[34] = (0, 90, 0);
	at[34] = 13.2500;
	points[35] = (0, -4970, 1009.8267);
	angles[35] = (0, 90, 0);
	at[35] = 13.6000;
	points[36] = (0, -4970, 1023.9803);
	angles[36] = (0, 90, 0);
	at[36] = 13.9000;
	points[37] = (0, -4970, 1035.5945);
	angles[37] = (0, 90, 0);
	at[37] = 14.2000;
	points[38] = (0, -4970, 1044.1180);
	angles[38] = (0, 90, 0);
	at[38] = 14.5000;
	points[39] = (0, -4970, 1049.0197);
	angles[39] = (0, 90, 0);
	at[39] = 14.8000;
	points[40] = (0, -4970, 1050.5511);
	angles[40] = (0, 90, 0);
	at[40] = 15.1500;
	points[41] = (0, -4970, 1053.8149);
	angles[41] = (0, 90, 0);
	at[41] = 15.4000;
	points[42] = (0, -4970, 1059.7244);
	angles[42] = (0, 90, 0);
	at[42] = 15.6500;
	points[43] = (0, -4970, 1069.8583);
	angles[43] = (0, 90, 0);
	at[43] = 15.9500;
	points[44] = (0, -4970, 1085.2047);
	angles[44] = (0, 90, 0);
	at[44] = 16.3000;
	points[45] = (0, -4970, 1106.3229);
	angles[45] = (0, 90, 0);
	at[45] = 16.7000;
	points[46] = (0, -4970, 1126.9568);
	angles[46] = (0, 90, 0);
	at[46] = 17.0500;
	points[47] = (0, -4970, 1195.0276);
	angles[47] = (0, 90, 0);
	at[47] = 18.1500;
	points[48] = (0, -4970, 1211.9646);
	angles[48] = (0, 90, 0);
	at[48] = 18.4500;
	points[49] = (0, -4970, 1227.1851);
	angles[49] = (0, 90, 0);
	at[49] = 18.7500;
	points[50] = (0, -4970, 1242.0394);
	angles[50] = (0, 90, 0);
	at[50] = 19.1000;
	points[51] = (0, -4970, 1251.6575);
	angles[51] = (0, 90, 0);
	at[51] = 19.4000;
	points[52] = (0, -4970, 1257.8229);
	angles[52] = (0, 90, 0);
	at[52] = 19.7000;
	points[53] = (0, -4970, 1259.4489);
	angles[53] = (0, 90, 0);
	at[53] = 19.8500;
	points[54] = (0, -4970, 1260);
	angles[54] = (0, 90, 0);
	at[54] = 20;
	points[55] = (0, -4970, 1260);
	angles[55] = (0, 89.0668, 0);
	at[55] = 20.3000;
	points[56] = (0, -4970, 1260);
	angles[56] = (0, 86.4231, 0);
	at[56] = 20.6000;
	points[57] = (0, -4970, 1260);
	angles[57] = (0, 82.3017, 0);
	at[57] = 20.9000;
	points[58] = (0, -4970, 1260);
	angles[58] = (0, 75.9376, 0);
	at[58] = 21.2500;
	points[59] = (0, -4970, 1260);
	angles[59] = (0, 62.1546, 0);
	at[59] = 21.8500;
	points[60] = (0, -4970, 1260);
	angles[60] = (0, 24.1372, 0);
	at[60] = 23.3000;
	points[61] = (0, -4970, 1260);
	angles[61] = (0, 15.0883, 0);
	at[61] = 23.7000;
	points[62] = (0, -4970, 1260);
	angles[62] = (0, 8.5124, 0);
	at[62] = 24.0500;
	points[63] = (0, -4970, 1260);
	angles[63] = (0, 3.5770, 0);
	at[63] = 24.4000;
	points[64] = (0, -4970, 1260);
	angles[64] = (0, 0.9331, 0);
	at[64] = 24.7000;
	points[65] = (0, -4970, 1259.4489);
	angles[65] = (0, 0, 0);
	at[65] = 25.1500;
	points[66] = (0, -4970, 1255.2047);
	angles[66] = (0, 0, 0);
	at[66] = 25.4500;
	points[67] = (0, -4970, 1250.2756);
	angles[67] = (0, 0, 0);
	at[67] = 25.6500;
	points[68] = (0, -4970, 1242.0394);
	angles[68] = (0, 0, 0);
	at[68] = 25.9000;
	points[69] = (0, -4970, 1231.7834);
	angles[69] = (0, 0, 0);
	at[69] = 26.1500;
	points[70] = (0, -4970, 1217.2599);
	angles[70] = (0, 0, 0);
	at[70] = 26.4500;
	points[71] = (0, -4970, 1203.6772);
	angles[71] = (0, 0, 0);
	at[71] = 26.7000;
	points[72] = (0, -4970, 1189.0906);
	angles[72] = (0, 0, 0);
	at[72] = 26.9500;
	points[73] = (0, -4970, 1130.0157);
	angles[73] = (0, 0, 0);
	at[73] = 27.9000;
	points[74] = (0, -4970, 1112.0552);
	angles[74] = (0, 0, 0);
	at[74] = 28.2000;
	points[75] = (0, -4970, 1092.7401);
	angles[75] = (0, 0, 0);
	at[75] = 28.5500;
	points[76] = (0, -4970, 1078.2166);
	angles[76] = (0, 0, 0);
	at[76] = 28.8500;
	points[77] = (0, -4970, 1066.1417);
	angles[77] = (0, 0, 0);
	at[77] = 29.1500;
	points[78] = (0, -4970, 1057.0630);
	angles[78] = (0, 0, 0);
	at[78] = 29.4500;
	points[79] = (0, -4970, 1051.5197);
	angles[79] = (0, 0, 0);
	at[79] = 29.7500;
	points[80] = (0, -4970, 1050);
	angles[80] = (0, 0, 0);
	at[80] = 30;
	mover = getEnt("iz_mover0", "targetname");
	if (!isDefined(mover))
		return;
	rider = getEnt("endmap_trig", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	mover thread iz_mover_play(points, angles, at, false, 1, 0);
}

iz_mover1()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, -4970, 1050);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, -4970, 1051.5197);
	angles[1] = (0, 0, 0);
	at[1] = 0.2500;
	points[2] = (0, -4970, 1055.8820);
	angles[2] = (0, 0, 0);
	at[2] = 0.5000;
	points[3] = (0, -4970, 1062.7599);
	angles[3] = (0, 0, 0);
	at[3] = 0.7500;
	points[4] = (0, -4970, 1073.8898);
	angles[4] = (0, 0, 0);
	at[4] = 1.0500;
	points[5] = (0, -4970, 1087.6615);
	angles[5] = (0, 0, 0);
	at[5] = 1.3500;
	points[6] = (0, -4970, 1106.3229);
	angles[6] = (0, 0, 0);
	at[6] = 1.7000;
	points[7] = (0, -4970, 1126.9568);
	angles[7] = (0, 0, 0);
	at[7] = 2.0500;
	points[8] = (0, -4970, 1195.0276);
	angles[8] = (0, 0, 0);
	at[8] = 3.1500;
	points[9] = (0, -4970, 1211.9646);
	angles[9] = (0, 0, 0);
	at[9] = 3.4500;
	points[10] = (0, -4970, 1227.1851);
	angles[10] = (0, 0, 0);
	at[10] = 3.7500;
	points[11] = (0, -4970, 1242.0394);
	angles[11] = (0, 0, 0);
	at[11] = 4.1000;
	points[12] = (0, -4970, 1251.6575);
	angles[12] = (0, 0, 0);
	at[12] = 4.4000;
	points[13] = (0, -4970, 1257.8229);
	angles[13] = (0, 0, 0);
	at[13] = 4.7000;
	points[14] = (0, -4970, 1259.4489);
	angles[14] = (0, 0, 0);
	at[14] = 4.8500;
	points[15] = (0, -4970, 1260);
	angles[15] = (0, 0, 0);
	at[15] = 5;
	points[16] = (0, -4970, 1260);
	angles[16] = (0, -0.9331, 0);
	at[16] = 5.3000;
	points[17] = (0, -4970, 1260);
	angles[17] = (0, -3.5770, 0);
	at[17] = 5.6000;
	points[18] = (0, -4970, 1260);
	angles[18] = (0, -7.6982, 0);
	at[18] = 5.9000;
	points[19] = (0, -4970, 1260);
	angles[19] = (0, -14.0625, 0);
	at[19] = 6.2500;
	points[20] = (0, -4970, 1260);
	angles[20] = (0, -27.8454, 0);
	at[20] = 6.8500;
	points[21] = (0, -4970, 1260);
	angles[21] = (0, -67.0657, 0);
	at[21] = 8.3500;
	points[22] = (0, -4970, 1260);
	angles[22] = (0, -75.9376, 0);
	at[22] = 8.7500;
	points[23] = (0, -4970, 1260);
	angles[23] = (0, -82.3017, 0);
	at[23] = 9.1000;
	points[24] = (0, -4970, 1260);
	angles[24] = (0, -86.4231, 0);
	at[24] = 9.4000;
	points[25] = (0, -4970, 1260);
	angles[25] = (0, -88.7387, 0);
	at[25] = 9.6500;
	points[26] = (0, -4970, 1260);
	angles[26] = (0, -89.8934, 0);
	at[26] = 9.9000;
	points[27] = (0, -4970, 1259.4489);
	angles[27] = (0, -90, 0);
	at[27] = 10.1500;
	points[28] = (0, -4970, 1256.1851);
	angles[28] = (0, -90, 0);
	at[28] = 10.4000;
	points[29] = (0, -4970, 1250.2756);
	angles[29] = (0, -90, 0);
	at[29] = 10.6500;
	points[30] = (0, -4970, 1243.8583);
	angles[30] = (0, -90, 0);
	at[30] = 10.8500;
	points[31] = (0, -4970, 1236.1102);
	angles[31] = (0, -90, 0);
	at[31] = 11.0500;
	points[32] = (0, -4970, 1224.7953);
	angles[32] = (0, -90, 0);
	at[32] = 11.3000;
	points[33] = (0, -4970, 1211.9646);
	angles[33] = (0, -90, 0);
	at[33] = 11.5500;
	points[34] = (0, -4970, 1186.0787);
	angles[34] = (0, -90, 0);
	at[34] = 12;
	points[35] = (0, -4970, 1133.0985);
	angles[35] = (0, -90, 0);
	at[35] = 12.8500;
	points[36] = (0, -4970, 1112.0552);
	angles[36] = (0, -90, 0);
	at[36] = 13.2000;
	points[37] = (0, -4970, 1092.7401);
	angles[37] = (0, -90, 0);
	at[37] = 13.5500;
	points[38] = (0, -4970, 1078.2166);
	angles[38] = (0, -90, 0);
	at[38] = 13.8500;
	points[39] = (0, -4970, 1064.4055);
	angles[39] = (0, -90, 0);
	at[39] = 14.2000;
	points[40] = (0, -4970, 1055.8820);
	angles[40] = (0, -90, 0);
	at[40] = 14.5000;
	points[41] = (0, -4970, 1050.9803);
	angles[41] = (0, -90, 0);
	at[41] = 14.8000;
	points[42] = (0, -4970, 1049.4489);
	angles[42] = (0, -90, 0);
	at[42] = 15.1500;
	points[43] = (0, -4970, 1046.1851);
	angles[43] = (0, -90, 0);
	at[43] = 15.4000;
	points[44] = (0, -4970, 1038.8071);
	angles[44] = (0, -90, 0);
	at[44] = 15.7000;
	points[45] = (0, -4970, 1028.1614);
	angles[45] = (0, -90, 0);
	at[45] = 16;
	points[46] = (0, -4970, 1012.3386);
	angles[46] = (0, -90, 0);
	at[46] = 16.3500;
	points[47] = (0, -4970, 993.6772);
	angles[47] = (0, -90, 0);
	at[47] = 16.7000;
	points[48] = (0, -4970, 969.9843);
	angles[48] = (0, -90, 0);
	at[48] = 17.1000;
	points[49] = (0, -4970, 907.9291);
	angles[49] = (0, -90, 0);
	at[49] = 18.1000;
	points[50] = (0, -4970, 890.7520);
	angles[50] = (0, -90, 0);
	at[50] = 18.4000;
	points[51] = (0, -4970, 875.2047);
	angles[51] = (0, -90, 0);
	at[51] = 18.7000;
	points[52] = (0, -4970, 861.8386);
	angles[52] = (0, -90, 0);
	at[52] = 19;
	points[53] = (0, -4970, 851.1929);
	angles[53] = (0, -90, 0);
	at[53] = 19.3000;
	points[54] = (0, -4970, 843.8149);
	angles[54] = (0, -90, 0);
	at[54] = 19.6000;
	points[55] = (0, -4970, 840.5512);
	angles[55] = (0, -90, 0);
	at[55] = 19.8500;
	points[56] = (0, -4970, 840);
	angles[56] = (0, -89.5795, 0);
	at[56] = 20.2000;
	points[57] = (0, -4970, 840);
	angles[57] = (0, -87.4800, 0);
	at[57] = 20.5000;
	points[58] = (0, -4970, 840);
	angles[58] = (0, -83.8253, 0);
	at[58] = 20.8000;
	points[59] = (0, -4970, 840);
	angles[59] = (0, -77.9071, 0);
	at[59] = 21.1500;
	points[60] = (0, -4970, 840);
	angles[60] = (0, -63.4061, 0);
	at[60] = 21.8000;
	points[61] = (0, -4970, 840);
	angles[61] = (0, -22.9343, 0);
	at[61] = 23.3500;
	points[62] = (0, -4970, 840);
	angles[62] = (0, -14.0625, 0);
	at[62] = 23.7500;
	points[63] = (0, -4970, 840);
	angles[63] = (0, -7.6982, 0);
	at[63] = 24.1000;
	points[64] = (0, -4970, 840);
	angles[64] = (0, -3.5770, 0);
	at[64] = 24.4000;
	points[65] = (0, -4970, 840);
	angles[65] = (0, -0.9331, 0);
	at[65] = 24.7000;
	points[66] = (0, -4970, 840.5512);
	angles[66] = (0, 0, 0);
	at[66] = 25.1500;
	points[67] = (0, -4970, 844.7953);
	angles[67] = (0, 0, 0);
	at[67] = 25.4500;
	points[68] = (0, -4970, 849.7244);
	angles[68] = (0, 0, 0);
	at[68] = 25.6500;
	points[69] = (0, -4970, 857.9606);
	angles[69] = (0, 0, 0);
	at[69] = 25.9000;
	points[70] = (0, -4970, 868.2166);
	angles[70] = (0, 0, 0);
	at[70] = 26.1500;
	points[71] = (0, -4970, 882.7402);
	angles[71] = (0, 0, 0);
	at[71] = 26.4500;
	points[72] = (0, -4970, 896.3228);
	angles[72] = (0, 0, 0);
	at[72] = 26.7000;
	points[73] = (0, -4970, 910.9095);
	angles[73] = (0, 0, 0);
	at[73] = 26.9500;
	points[74] = (0, -4970, 969.9843);
	angles[74] = (0, 0, 0);
	at[74] = 27.9000;
	points[75] = (0, -4970, 987.9449);
	angles[75] = (0, 0, 0);
	at[75] = 28.2000;
	points[76] = (0, -4970, 1007.2599);
	angles[76] = (0, 0, 0);
	at[76] = 28.5500;
	points[77] = (0, -4970, 1021.7835);
	angles[77] = (0, 0, 0);
	at[77] = 28.8500;
	points[78] = (0, -4970, 1033.8583);
	angles[78] = (0, 0, 0);
	at[78] = 29.1500;
	points[79] = (0, -4970, 1042.9370);
	angles[79] = (0, 0, 0);
	at[79] = 29.4500;
	points[80] = (0, -4970, 1048.4803);
	angles[80] = (0, 0, 0);
	at[80] = 29.7500;
	points[81] = (0, -4970, 1050);
	angles[81] = (0, 0, 0);
	at[81] = 30;
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
