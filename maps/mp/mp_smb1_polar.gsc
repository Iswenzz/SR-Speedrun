main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_smb1_polar", 0);

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
	points[0] = (0, 0, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 0, 0);
	angles[1] = (0, 56.2500, 0);
	at[1] = 6.2500;
	points[2] = (0, 0, 0);
	angles[2] = (0, 112.5001, 0);
	at[2] = 12.5000;
	points[3] = (0, 0, 0);
	angles[3] = (0, 168.7500, 0);
	at[3] = 18.7500;
	points[4] = (0, 0, 0);
	angles[4] = (0, 225, 0);
	at[4] = 25;
	points[5] = (0, 0, 0);
	angles[5] = (0, 281.2501, 0);
	at[5] = 31.2500;
	points[6] = (0, 0, 0);
	angles[6] = (0, 337.5001, 0);
	at[6] = 37.5000;
	points[7] = (0, 0, 0);
	angles[7] = (0, 393.7500, 0);
	at[7] = 43.7500;
	points[8] = (0, 0, 0);
	angles[8] = (0, 450, 0);
	at[8] = 50;
	points[9] = (0, 0, 0);
	angles[9] = (0, 506.2499, 0);
	at[9] = 56.2500;
	points[10] = (0, 0, 0);
	angles[10] = (0, 562.5000, 0);
	at[10] = 62.5000;
	points[11] = (0, 0, 0);
	angles[11] = (0, 618.7501, 0);
	at[11] = 68.7500;
	points[12] = (0, 0, 0);
	angles[12] = (0, 675, 0);
	at[12] = 75;
	points[13] = (0, 0, 0);
	angles[13] = (0, 731.2500, 0);
	at[13] = 81.2500;
	points[14] = (0, 0, 0);
	angles[14] = (0, 787.5000, 0);
	at[14] = 87.5000;
	points[15] = (0, 0, 0);
	angles[15] = (0, 843.7499, 0);
	at[15] = 93.7500;
	points[16] = (0, 0, 0);
	angles[16] = (0, 900, 0);
	at[16] = 100;
	mover = getEnt("iz_mover0", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, false);
}

iz_mover1()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, 0, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 0, 0);
	angles[1] = (0, -56.2500, 0);
	at[1] = 6.2500;
	points[2] = (0, 0, 0);
	angles[2] = (0, -112.5001, 0);
	at[2] = 12.5000;
	points[3] = (0, 0, 0);
	angles[3] = (0, -168.7500, 0);
	at[3] = 18.7500;
	points[4] = (0, 0, 0);
	angles[4] = (0, -225, 0);
	at[4] = 25;
	points[5] = (0, 0, 0);
	angles[5] = (0, -281.2501, 0);
	at[5] = 31.2500;
	points[6] = (0, 0, 0);
	angles[6] = (0, -337.5001, 0);
	at[6] = 37.5000;
	points[7] = (0, 0, 0);
	angles[7] = (0, -393.7500, 0);
	at[7] = 43.7500;
	points[8] = (0, 0, 0);
	angles[8] = (0, -450, 0);
	at[8] = 50;
	points[9] = (0, 0, 0);
	angles[9] = (0, -506.2499, 0);
	at[9] = 56.2500;
	points[10] = (0, 0, 0);
	angles[10] = (0, -562.5000, 0);
	at[10] = 62.5000;
	points[11] = (0, 0, 0);
	angles[11] = (0, -618.7501, 0);
	at[11] = 68.7500;
	points[12] = (0, 0, 0);
	angles[12] = (0, -675, 0);
	at[12] = 75;
	points[13] = (0, 0, 0);
	angles[13] = (0, -731.2500, 0);
	at[13] = 81.2500;
	points[14] = (0, 0, 0);
	angles[14] = (0, -787.5000, 0);
	at[14] = 87.5000;
	points[15] = (0, 0, 0);
	angles[15] = (0, -843.7499, 0);
	at[15] = 93.7500;
	points[16] = (0, 0, 0);
	angles[16] = (0, -900, 0);
	at[16] = 100;
	mover = getEnt("iz_mover1", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, false);
}

iz_mover2()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, 0, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 0, 0);
	angles[1] = (0, 56.2500, 0);
	at[1] = 6.2500;
	points[2] = (0, 0, 0);
	angles[2] = (0, 112.5001, 0);
	at[2] = 12.5000;
	points[3] = (0, 0, 0);
	angles[3] = (0, 168.7500, 0);
	at[3] = 18.7500;
	points[4] = (0, 0, 0);
	angles[4] = (0, 225, 0);
	at[4] = 25;
	points[5] = (0, 0, 0);
	angles[5] = (0, 281.2501, 0);
	at[5] = 31.2500;
	points[6] = (0, 0, 0);
	angles[6] = (0, 337.5001, 0);
	at[6] = 37.5000;
	points[7] = (0, 0, 0);
	angles[7] = (0, 393.7500, 0);
	at[7] = 43.7500;
	points[8] = (0, 0, 0);
	angles[8] = (0, 450, 0);
	at[8] = 50;
	points[9] = (0, 0, 0);
	angles[9] = (0, 506.2499, 0);
	at[9] = 56.2500;
	points[10] = (0, 0, 0);
	angles[10] = (0, 562.5000, 0);
	at[10] = 62.5000;
	points[11] = (0, 0, 0);
	angles[11] = (0, 618.7501, 0);
	at[11] = 68.7500;
	points[12] = (0, 0, 0);
	angles[12] = (0, 675, 0);
	at[12] = 75;
	points[13] = (0, 0, 0);
	angles[13] = (0, 731.2500, 0);
	at[13] = 81.2500;
	points[14] = (0, 0, 0);
	angles[14] = (0, 787.5000, 0);
	at[14] = 87.5000;
	points[15] = (0, 0, 0);
	angles[15] = (0, 843.7499, 0);
	at[15] = 93.7500;
	points[16] = (0, 0, 0);
	angles[16] = (0, 900, 0);
	at[16] = 100;
	mover = getEnt("iz_mover2", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, false);
}

iz_mover3()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, 0, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 0, 0);
	angles[1] = (0, -56.2500, 0);
	at[1] = 6.2500;
	points[2] = (0, 0, 0);
	angles[2] = (0, -112.5001, 0);
	at[2] = 12.5000;
	points[3] = (0, 0, 0);
	angles[3] = (0, -168.7500, 0);
	at[3] = 18.7500;
	points[4] = (0, 0, 0);
	angles[4] = (0, -225, 0);
	at[4] = 25;
	points[5] = (0, 0, 0);
	angles[5] = (0, -281.2501, 0);
	at[5] = 31.2500;
	points[6] = (0, 0, 0);
	angles[6] = (0, -337.5001, 0);
	at[6] = 37.5000;
	points[7] = (0, 0, 0);
	angles[7] = (0, -393.7500, 0);
	at[7] = 43.7500;
	points[8] = (0, 0, 0);
	angles[8] = (0, -450, 0);
	at[8] = 50;
	points[9] = (0, 0, 0);
	angles[9] = (0, -506.2499, 0);
	at[9] = 56.2500;
	points[10] = (0, 0, 0);
	angles[10] = (0, -562.5000, 0);
	at[10] = 62.5000;
	points[11] = (0, 0, 0);
	angles[11] = (0, -618.7501, 0);
	at[11] = 68.7500;
	points[12] = (0, 0, 0);
	angles[12] = (0, -675, 0);
	at[12] = 75;
	points[13] = (0, 0, 0);
	angles[13] = (0, -731.2500, 0);
	at[13] = 81.2500;
	points[14] = (0, 0, 0);
	angles[14] = (0, -787.5000, 0);
	at[14] = 87.5000;
	points[15] = (0, 0, 0);
	angles[15] = (0, -843.7499, 0);
	at[15] = 93.7500;
	points[16] = (0, 0, 0);
	angles[16] = (0, -900, 0);
	at[16] = 100;
	mover = getEnt("iz_mover3", "targetname");
	if (!isDefined(mover))
		return;
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
	mover thread iz_mover_loop(points, angles, at, false, false);
}

iz_mover4()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, 0, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 0, 0);
	angles[1] = (0, 55.8000, 0);
	at[1] = 3.1000;
	points[2] = (0, 0, 0);
	angles[2] = (0, 112.5001, 0);
	at[2] = 6.2500;
	points[3] = (0, 0, 0);
	angles[3] = (0, 168.3000, 0);
	at[3] = 9.3500;
	points[4] = (0, 0, 0);
	angles[4] = (0, 225, 0);
	at[4] = 12.5000;
	points[5] = (0, 0, 0);
	angles[5] = (0, 280.8000, 0);
	at[5] = 15.6000;
	points[6] = (0, 0, 0);
	angles[6] = (0, 337.5001, 0);
	at[6] = 18.7500;
	points[7] = (0, 0, 0);
	angles[7] = (0, 393.3000, 0);
	at[7] = 21.8500;
	points[8] = (0, 0, 0);
	angles[8] = (0, 450, 0);
	at[8] = 25;
	points[9] = (0, 0, 0);
	angles[9] = (0, 505.8000, 0);
	at[9] = 28.1000;
	points[10] = (0, 0, 0);
	angles[10] = (0, 562.5000, 0);
	at[10] = 31.2500;
	points[11] = (0, 0, 0);
	angles[11] = (0, 618.3000, 0);
	at[11] = 34.3500;
	points[12] = (0, 0, 0);
	angles[12] = (0, 675, 0);
	at[12] = 37.5000;
	points[13] = (0, 0, 0);
	angles[13] = (0, 730.8000, 0);
	at[13] = 40.6000;
	points[14] = (0, 0, 0);
	angles[14] = (0, 787.5000, 0);
	at[14] = 43.7500;
	points[15] = (0, 0, 0);
	angles[15] = (0, 843.2999, 0);
	at[15] = 46.8500;
	points[16] = (0, 0, 0);
	angles[16] = (0, 900, 0);
	at[16] = 50;
	points[17] = (0, 0, 0);
	angles[17] = (0, 955.7999, 0);
	at[17] = 53.1000;
	points[18] = (0, 0, 0);
	angles[18] = (0, 1012.5000, 0);
	at[18] = 56.2500;
	points[19] = (0, 0, 0);
	angles[19] = (0, 1068.2999, 0);
	at[19] = 59.3500;
	points[20] = (0, 0, 0);
	angles[20] = (0, 1125, 0);
	at[20] = 62.5000;
	points[21] = (0, 0, 0);
	angles[21] = (0, 1180.7999, 0);
	at[21] = 65.6000;
	points[22] = (0, 0, 0);
	angles[22] = (0, 1237.5000, 0);
	at[22] = 68.7500;
	points[23] = (0, 0, 0);
	angles[23] = (0, 1293.2999, 0);
	at[23] = 71.8500;
	points[24] = (0, 0, 0);
	angles[24] = (0, 1350, 0);
	at[24] = 75;
	points[25] = (0, 0, 0);
	angles[25] = (0, 1405.7999, 0);
	at[25] = 78.1000;
	points[26] = (0, 0, 0);
	angles[26] = (0, 1462.5000, 0);
	at[26] = 81.2500;
	points[27] = (0, 0, 0);
	angles[27] = (0, 1518.2999, 0);
	at[27] = 84.3500;
	points[28] = (0, 0, 0);
	angles[28] = (0, 1575, 0);
	at[28] = 87.5000;
	points[29] = (0, 0, 0);
	angles[29] = (0, 1630.7999, 0);
	at[29] = 90.6000;
	points[30] = (0, 0, 0);
	angles[30] = (0, 1687.4999, 0);
	at[30] = 93.7500;
	points[31] = (0, 0, 0);
	angles[31] = (0, 1743.2999, 0);
	at[31] = 96.8500;
	points[32] = (0, 0, 0);
	angles[32] = (0, 1800, 0);
	at[32] = 100;
	mover = getEnt("iz_mover4", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover5()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, 0, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 0, 0);
	angles[1] = (0, -55.8000, 0);
	at[1] = 3.1000;
	points[2] = (0, 0, 0);
	angles[2] = (0, -112.5001, 0);
	at[2] = 6.2500;
	points[3] = (0, 0, 0);
	angles[3] = (0, -168.3000, 0);
	at[3] = 9.3500;
	points[4] = (0, 0, 0);
	angles[4] = (0, -225, 0);
	at[4] = 12.5000;
	points[5] = (0, 0, 0);
	angles[5] = (0, -280.8000, 0);
	at[5] = 15.6000;
	points[6] = (0, 0, 0);
	angles[6] = (0, -337.5000, 0);
	at[6] = 18.7500;
	points[7] = (0, 0, 0);
	angles[7] = (0, -393.3000, 0);
	at[7] = 21.8500;
	points[8] = (0, 0, 0);
	angles[8] = (0, -450, 0);
	at[8] = 25;
	points[9] = (0, 0, 0);
	angles[9] = (0, -505.8000, 0);
	at[9] = 28.1000;
	points[10] = (0, 0, 0);
	angles[10] = (0, -562.5000, 0);
	at[10] = 31.2500;
	points[11] = (0, 0, 0);
	angles[11] = (0, -618.3000, 0);
	at[11] = 34.3500;
	points[12] = (0, 0, 0);
	angles[12] = (0, -675, 0);
	at[12] = 37.5000;
	points[13] = (0, 0, 0);
	angles[13] = (0, -730.8000, 0);
	at[13] = 40.6000;
	points[14] = (0, 0, 0);
	angles[14] = (0, -787.5000, 0);
	at[14] = 43.7500;
	points[15] = (0, 0, 0);
	angles[15] = (0, -843.2999, 0);
	at[15] = 46.8500;
	points[16] = (0, 0, 0);
	angles[16] = (0, -900, 0);
	at[16] = 50;
	points[17] = (0, 0, 0);
	angles[17] = (0, -955.7999, 0);
	at[17] = 53.1000;
	points[18] = (0, 0, 0);
	angles[18] = (0, -1012.5000, 0);
	at[18] = 56.2500;
	points[19] = (0, 0, 0);
	angles[19] = (0, -1068.2999, 0);
	at[19] = 59.3500;
	points[20] = (0, 0, 0);
	angles[20] = (0, -1125, 0);
	at[20] = 62.5000;
	points[21] = (0, 0, 0);
	angles[21] = (0, -1180.7999, 0);
	at[21] = 65.6000;
	points[22] = (0, 0, 0);
	angles[22] = (0, -1237.5000, 0);
	at[22] = 68.7500;
	points[23] = (0, 0, 0);
	angles[23] = (0, -1293.2999, 0);
	at[23] = 71.8500;
	points[24] = (0, 0, 0);
	angles[24] = (0, -1350, 0);
	at[24] = 75;
	points[25] = (0, 0, 0);
	angles[25] = (0, -1405.7999, 0);
	at[25] = 78.1000;
	points[26] = (0, 0, 0);
	angles[26] = (0, -1462.5000, 0);
	at[26] = 81.2500;
	points[27] = (0, 0, 0);
	angles[27] = (0, -1518.2999, 0);
	at[27] = 84.3500;
	points[28] = (0, 0, 0);
	angles[28] = (0, -1575, 0);
	at[28] = 87.5000;
	points[29] = (0, 0, 0);
	angles[29] = (0, -1630.7999, 0);
	at[29] = 90.6000;
	points[30] = (0, 0, 0);
	angles[30] = (0, -1687.4999, 0);
	at[30] = 93.7500;
	points[31] = (0, 0, 0);
	angles[31] = (0, -1743.2999, 0);
	at[31] = 96.8500;
	points[32] = (0, 0, 0);
	angles[32] = (0, -1800, 0);
	at[32] = 100;
	mover = getEnt("iz_mover5", "targetname");
	if (!isDefined(mover))
		return;
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
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover6()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, 0, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 0, 0);
	angles[1] = (0, 55.8000, 0);
	at[1] = 1.5500;
	points[2] = (0, 0, 0);
	angles[2] = (0, 111.6001, 0);
	at[2] = 3.1000;
	points[3] = (0, 0, 0);
	angles[3] = (0, 167.4000, 0);
	at[3] = 4.6500;
	points[4] = (0, 0, 0);
	angles[4] = (0, 225, 0);
	at[4] = 6.2500;
	points[5] = (0, 0, 0);
	angles[5] = (0, 280.8000, 0);
	at[5] = 7.8000;
	points[6] = (0, 0, 0);
	angles[6] = (0, 336.6000, 0);
	at[6] = 9.3500;
	points[7] = (0, 0, 0);
	angles[7] = (0, 392.4000, 0);
	at[7] = 10.9000;
	points[8] = (0, 0, 0);
	angles[8] = (0, 450, 0);
	at[8] = 12.5000;
	points[9] = (0, 0, 0);
	angles[9] = (0, 505.8000, 0);
	at[9] = 14.0500;
	points[10] = (0, 0, 0);
	angles[10] = (0, 561.6000, 0);
	at[10] = 15.6000;
	points[11] = (0, 0, 0);
	angles[11] = (0, 617.4001, 0);
	at[11] = 17.1500;
	points[12] = (0, 0, 0);
	angles[12] = (0, 675, 0);
	at[12] = 18.7500;
	points[13] = (0, 0, 0);
	angles[13] = (0, 730.8000, 0);
	at[13] = 20.3000;
	points[14] = (0, 0, 0);
	angles[14] = (0, 786.6000, 0);
	at[14] = 21.8500;
	points[15] = (0, 0, 0);
	angles[15] = (0, 842.4000, 0);
	at[15] = 23.4000;
	points[16] = (0, 0, 0);
	angles[16] = (0, 900, 0);
	at[16] = 25;
	points[17] = (0, 0, 0);
	angles[17] = (0, 955.7999, 0);
	at[17] = 26.5500;
	points[18] = (0, 0, 0);
	angles[18] = (0, 1011.5999, 0);
	at[18] = 28.1000;
	points[19] = (0, 0, 0);
	angles[19] = (0, 1067.4000, 0);
	at[19] = 29.6500;
	points[20] = (0, 0, 0);
	angles[20] = (0, 1125, 0);
	at[20] = 31.2500;
	points[21] = (0, 0, 0);
	angles[21] = (0, 1180.7999, 0);
	at[21] = 32.8000;
	points[22] = (0, 0, 0);
	angles[22] = (0, 1236.6000, 0);
	at[22] = 34.3500;
	points[23] = (0, 0, 0);
	angles[23] = (0, 1292.4001, 0);
	at[23] = 35.9000;
	points[24] = (0, 0, 0);
	angles[24] = (0, 1350, 0);
	at[24] = 37.5000;
	points[25] = (0, 0, 0);
	angles[25] = (0, 1405.7999, 0);
	at[25] = 39.0500;
	points[26] = (0, 0, 0);
	angles[26] = (0, 1461.6000, 0);
	at[26] = 40.6000;
	points[27] = (0, 0, 0);
	angles[27] = (0, 1517.4001, 0);
	at[27] = 42.1500;
	points[28] = (0, 0, 0);
	angles[28] = (0, 1575, 0);
	at[28] = 43.7500;
	points[29] = (0, 0, 0);
	angles[29] = (0, 1630.7999, 0);
	at[29] = 45.3000;
	points[30] = (0, 0, 0);
	angles[30] = (0, 1686.5999, 0);
	at[30] = 46.8500;
	points[31] = (0, 0, 0);
	angles[31] = (0, 1742.4003, 0);
	at[31] = 48.4000;
	points[32] = (0, 0, 0);
	angles[32] = (0, 1800, 0);
	at[32] = 50;
	points[33] = (0, 0, 0);
	angles[33] = (0, 1855.8000, 0);
	at[33] = 51.5500;
	points[34] = (0, 0, 0);
	angles[34] = (0, 1911.5999, 0);
	at[34] = 53.1000;
	points[35] = (0, 0, 0);
	angles[35] = (0, 1967.3999, 0);
	at[35] = 54.6500;
	points[36] = (0, 0, 0);
	angles[36] = (0, 2025, 0);
	at[36] = 56.2500;
	points[37] = (0, 0, 0);
	angles[37] = (0, 2080.8000, 0);
	at[37] = 57.8000;
	points[38] = (0, 0, 0);
	angles[38] = (0, 2136.5999, 0);
	at[38] = 59.3500;
	points[39] = (0, 0, 0);
	angles[39] = (0, 2192.4001, 0);
	at[39] = 60.9000;
	points[40] = (0, 0, 0);
	angles[40] = (0, 2250, 0);
	at[40] = 62.5000;
	points[41] = (0, 0, 0);
	angles[41] = (0, 2305.8000, 0);
	at[41] = 64.0500;
	points[42] = (0, 0, 0);
	angles[42] = (0, 2361.5999, 0);
	at[42] = 65.6000;
	points[43] = (0, 0, 0);
	angles[43] = (0, 2417.4001, 0);
	at[43] = 67.1500;
	points[44] = (0, 0, 0);
	angles[44] = (0, 2475, 0);
	at[44] = 68.7500;
	points[45] = (0, 0, 0);
	angles[45] = (0, 2530.8000, 0);
	at[45] = 70.3000;
	points[46] = (0, 0, 0);
	angles[46] = (0, 2586.5999, 0);
	at[46] = 71.8500;
	points[47] = (0, 0, 0);
	angles[47] = (0, 2642.4004, 0);
	at[47] = 73.4000;
	points[48] = (0, 0, 0);
	angles[48] = (0, 2700, 0);
	at[48] = 75;
	points[49] = (0, 0, 0);
	angles[49] = (0, 2755.7998, 0);
	at[49] = 76.5500;
	points[50] = (0, 0, 0);
	angles[50] = (0, 2811.5999, 0);
	at[50] = 78.1000;
	points[51] = (0, 0, 0);
	angles[51] = (0, 2867.4001, 0);
	at[51] = 79.6500;
	points[52] = (0, 0, 0);
	angles[52] = (0, 2925, 0);
	at[52] = 81.2500;
	points[53] = (0, 0, 0);
	angles[53] = (0, 2980.8000, 0);
	at[53] = 82.8000;
	points[54] = (0, 0, 0);
	angles[54] = (0, 3036.5999, 0);
	at[54] = 84.3500;
	points[55] = (0, 0, 0);
	angles[55] = (0, 3092.4001, 0);
	at[55] = 85.9000;
	points[56] = (0, 0, 0);
	angles[56] = (0, 3150, 0);
	at[56] = 87.5000;
	points[57] = (0, 0, 0);
	angles[57] = (0, 3205.8003, 0);
	at[57] = 89.0500;
	points[58] = (0, 0, 0);
	angles[58] = (0, 3261.5999, 0);
	at[58] = 90.6000;
	points[59] = (0, 0, 0);
	angles[59] = (0, 3317.4001, 0);
	at[59] = 92.1500;
	points[60] = (0, 0, 0);
	angles[60] = (0, 3375, 0);
	at[60] = 93.7500;
	points[61] = (0, 0, 0);
	angles[61] = (0, 3430.8000, 0);
	at[61] = 95.3000;
	points[62] = (0, 0, 0);
	angles[62] = (0, 3486.5999, 0);
	at[62] = 96.8500;
	points[63] = (0, 0, 0);
	angles[63] = (0, 3542.4001, 0);
	at[63] = 98.4000;
	points[64] = (0, 0, 0);
	angles[64] = (0, 3600, 0);
	at[64] = 100;
	mover = getEnt("iz_mover6", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover7()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, 0, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 0, 0);
	angles[1] = (0, -56.2500, 0);
	at[1] = 6.2500;
	points[2] = (0, 0, 0);
	angles[2] = (0, -112.5001, 0);
	at[2] = 12.5000;
	points[3] = (0, 0, 0);
	angles[3] = (0, -168.7500, 0);
	at[3] = 18.7500;
	points[4] = (0, 0, 0);
	angles[4] = (0, -225, 0);
	at[4] = 25;
	points[5] = (0, 0, 0);
	angles[5] = (0, -281.2501, 0);
	at[5] = 31.2500;
	points[6] = (0, 0, 0);
	angles[6] = (0, -337.5001, 0);
	at[6] = 37.5000;
	points[7] = (0, 0, 0);
	angles[7] = (0, -393.7500, 0);
	at[7] = 43.7500;
	points[8] = (0, 0, 0);
	angles[8] = (0, -450, 0);
	at[8] = 50;
	points[9] = (0, 0, 0);
	angles[9] = (0, -506.2499, 0);
	at[9] = 56.2500;
	points[10] = (0, 0, 0);
	angles[10] = (0, -562.5000, 0);
	at[10] = 62.5000;
	points[11] = (0, 0, 0);
	angles[11] = (0, -618.7501, 0);
	at[11] = 68.7500;
	points[12] = (0, 0, 0);
	angles[12] = (0, -675, 0);
	at[12] = 75;
	points[13] = (0, 0, 0);
	angles[13] = (0, -731.2500, 0);
	at[13] = 81.2500;
	points[14] = (0, 0, 0);
	angles[14] = (0, -787.5000, 0);
	at[14] = 87.5000;
	points[15] = (0, 0, 0);
	angles[15] = (0, -843.7499, 0);
	at[15] = 93.7500;
	points[16] = (0, 0, 0);
	angles[16] = (0, -900, 0);
	at[16] = 100;
	mover = getEnt("iz_mover7", "targetname");
	if (!isDefined(mover))
		return;
	rider = getEnt("endmap_trig", "targetname");
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
