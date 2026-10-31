main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_smb1_tram", 0);

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
	thread iz_bumper("iz_bumper4", false);
	thread iz_bumper("iz_bumper5", false);
	thread iz_bumper("iz_bumper6", false);
	thread iz_bumper("iz_bumper7", false);
	thread iz_bumper("iz_bumper8", false);
	thread iz_bumper("iz_bumper9", false);
	thread iz_bumper("iz_bumper10", false);
	thread iz_bumper("iz_bumper11", false);
	thread iz_bumper("iz_bumper12", false);
	thread iz_bumper("iz_bumper13", false);
	thread iz_bumper("iz_bumper14", false);
	thread iz_bumper("iz_bumper15", false);
	thread iz_bumper("iz_bumper16", false);
	thread iz_bumper("iz_bumper17", false);
	thread iz_bumper("iz_bumper18", false);
	thread iz_bumper("iz_bumper19", false);
	thread iz_bumper("iz_bumper20", false);
	thread iz_bumper("iz_bumper21", false);
	thread iz_bumper("iz_bumper22", false);
	thread iz_bumper("iz_bumper23", false);
	thread iz_bumper("iz_bumper24", false);
	thread iz_bumper("iz_bumper25", false);
	thread iz_bumper("iz_bumper26", false);
	thread iz_bumper("iz_bumper27", false);
	thread iz_bumper("iz_bumper28", false);
	thread iz_bumper("iz_bumper29", false);
	thread iz_bumper("iz_bumper30", false);
	thread iz_bumper("iz_bumper31", false);
	thread iz_bumper("iz_bumper32", false);
	thread iz_bumper("iz_bumper33", false);
	thread iz_bumper("iz_bumper34", false);
	thread iz_bumper("iz_bumper35", false);
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
	thread iz_mover8();
	thread iz_mover9();
	thread iz_mover10();
	thread iz_mover11();
	thread iz_mover12();
	thread iz_mover13();
	thread iz_mover14();
	thread iz_mover15();
	thread iz_mover16();
	thread iz_mover17();
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
	angles[1] = (0, 0, -45);
	at[1] = 7.5000;
	points[2] = (0, 0, 0);
	angles[2] = (0, 0, -90);
	at[2] = 15;
	points[3] = (0, 0, 0);
	angles[3] = (0, 0, -147.7500);
	at[3] = 15.2500;
	points[4] = (0, 0, 0);
	angles[4] = (0, 0, -205.5000);
	at[4] = 15.5000;
	points[5] = (0, 0, 0);
	angles[5] = (0, 0, -263.2501);
	at[5] = 15.7500;
	points[6] = (0, 0, 0);
	angles[6] = (0, 0, -321);
	at[6] = 16;
	points[7] = (0, 0, 0);
	angles[7] = (0, 0, -385.4999);
	at[7] = 26.7500;
	points[8] = (0, 0, 0);
	angles[8] = (0, 0, -450);
	at[8] = 37.5000;
	points[9] = (0, 0, 0);
	angles[9] = (0, 0, -507.7500);
	at[9] = 37.7500;
	points[10] = (0, 0, 0);
	angles[10] = (0, 0, -565.5000);
	at[10] = 38;
	points[11] = (0, 0, 0);
	angles[11] = (0, 0, -623.2501);
	at[11] = 38.2500;
	points[12] = (0, 0, 0);
	angles[12] = (0, 0, -681);
	at[12] = 38.5000;
	points[13] = (0, 0, 0);
	angles[13] = (0, 0, -765);
	at[13] = 52.5000;
	points[14] = (0, 0, 0);
	angles[14] = (0, 0, -765);
	at[14] = 60;
	mover = getEnt("iz_mover0", "targetname");
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

iz_mover1()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, 0, 0);
	angles[0] = (0, 0, 0.0037);
	at[0] = 0;
	points[1] = (0, 0, 0);
	angles[1] = (0, 0, -52.4963);
	at[1] = 8.7500;
	points[2] = (0, 0, 0);
	angles[2] = (0, 0, -104.9964);
	at[2] = 17.5000;
	points[3] = (0, 0, 0);
	angles[3] = (0, 0, -162.7464);
	at[3] = 17.7500;
	points[4] = (0, 0, 0);
	angles[4] = (0, 0, -220.4964);
	at[4] = 18;
	points[5] = (0, 0, 0);
	angles[5] = (0, 0, -278.2464);
	at[5] = 18.2500;
	points[6] = (0, 0, 0);
	angles[6] = (0, 0, -335.9963);
	at[6] = 18.5000;
	points[7] = (0, 0, 0);
	angles[7] = (0, 0, -400.4963);
	at[7] = 29.2500;
	points[8] = (0, 0, 0);
	angles[8] = (0, 0, -464.9963);
	at[8] = 40;
	points[9] = (0, 0, 0);
	angles[9] = (0, 0, -522.7464);
	at[9] = 40.2500;
	points[10] = (0, 0, 0);
	angles[10] = (0, 0, -580.4964);
	at[10] = 40.5000;
	points[11] = (0, 0, 0);
	angles[11] = (0, 0, -638.2463);
	at[11] = 40.7500;
	points[12] = (0, 0, 0);
	angles[12] = (0, 0, -695.9963);
	at[12] = 41;
	points[13] = (0, 0, 0);
	angles[13] = (0, 0, -779.9963);
	at[13] = 55;
	points[14] = (0, 0, 0);
	angles[14] = (0, 0, -779.9963);
	at[14] = 60;
	mover = getEnt("iz_mover1", "targetname");
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
	mover thread iz_mover_loop(points, angles, at, false, false);
}

iz_mover2()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, 0, 0);
	angles[0] = (0, 0, 0.0018);
	at[0] = 0;
	points[1] = (0, 0, 0);
	angles[1] = (0, 0, -59.9981);
	at[1] = 10;
	points[2] = (0, 0, 0);
	angles[2] = (0, 0, -119.9981);
	at[2] = 20;
	points[3] = (0, 0, 0);
	angles[3] = (0, 0, -177.7482);
	at[3] = 20.2500;
	points[4] = (0, 0, 0);
	angles[4] = (0, 0, -235.4982);
	at[4] = 20.5000;
	points[5] = (0, 0, 0);
	angles[5] = (0, 0, -293.2481);
	at[5] = 20.7500;
	points[6] = (0, 0, 0);
	angles[6] = (0, 0, -350.9982);
	at[6] = 21;
	points[7] = (0, 0, 0);
	angles[7] = (0, 0, -415.4981);
	at[7] = 31.7500;
	points[8] = (0, 0, 0);
	angles[8] = (0, 0, -479.9981);
	at[8] = 42.5000;
	points[9] = (0, 0, 0);
	angles[9] = (0, 0, -537.7482);
	at[9] = 42.7500;
	points[10] = (0, 0, 0);
	angles[10] = (0, 0, -595.4982);
	at[10] = 43;
	points[11] = (0, 0, 0);
	angles[11] = (0, 0, -653.2482);
	at[11] = 43.2500;
	points[12] = (0, 0, 0);
	angles[12] = (0, 0, -710.9982);
	at[12] = 43.5000;
	points[13] = (0, 0, 0);
	angles[13] = (0, 0, -794.9982);
	at[13] = 57.5000;
	points[14] = (0, 0, 0);
	angles[14] = (0, 0, -794.9982);
	at[14] = 60;
	mover = getEnt("iz_mover2", "targetname");
	if (!isDefined(mover))
		return;
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
	angles[1] = (0, 0, -67.5000);
	at[1] = 11.2500;
	points[2] = (0, 0, 0);
	angles[2] = (0, 0, -135);
	at[2] = 22.5000;
	points[3] = (0, 0, 0);
	angles[3] = (0, 0, -192.7500);
	at[3] = 22.7500;
	points[4] = (0, 0, 0);
	angles[4] = (0, 0, -250.4999);
	at[4] = 23;
	points[5] = (0, 0, 0);
	angles[5] = (0, 0, -308.2500);
	at[5] = 23.2500;
	points[6] = (0, 0, 0);
	angles[6] = (0, 0, -366);
	at[6] = 23.5000;
	points[7] = (0, 0, 0);
	angles[7] = (0, 0, -430.5000);
	at[7] = 34.2500;
	points[8] = (0, 0, 0);
	angles[8] = (0, 0, -495);
	at[8] = 45;
	points[9] = (0, 0, 0);
	angles[9] = (0, 0, -552.7500);
	at[9] = 45.2500;
	points[10] = (0, 0, 0);
	angles[10] = (0, 0, -610.4999);
	at[10] = 45.5000;
	points[11] = (0, 0, 0);
	angles[11] = (0, 0, -668.2501);
	at[11] = 45.7500;
	points[12] = (0, 0, 0);
	angles[12] = (0, 0, -726);
	at[12] = 46;
	points[13] = (0, 0, 0);
	angles[13] = (0, 0, -810);
	at[13] = 60;
	mover = getEnt("iz_mover3", "targetname");
	if (!isDefined(mover))
		return;
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
	mover thread iz_mover_loop(points, angles, at, false, false);
}

iz_mover4()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, 0, 0);
	angles[0] = (0, 0, 0.0037);
	at[0] = 0;
	points[1] = (0, 0, 0);
	angles[1] = (0, 0, -74.9963);
	at[1] = 12.5000;
	points[2] = (0, 0, 0);
	angles[2] = (0, 0, -149.9964);
	at[2] = 25;
	points[3] = (0, 0, 0);
	angles[3] = (0, 0, -207.7463);
	at[3] = 25.2500;
	points[4] = (0, 0, 0);
	angles[4] = (0, 0, -265.4963);
	at[4] = 25.5000;
	points[5] = (0, 0, 0);
	angles[5] = (0, 0, -323.2464);
	at[5] = 25.7500;
	points[6] = (0, 0, 0);
	angles[6] = (0, 0, -380.9963);
	at[6] = 26;
	points[7] = (0, 0, 0);
	angles[7] = (0, 0, -445.4963);
	at[7] = 36.7500;
	points[8] = (0, 0, 0);
	angles[8] = (0, 0, -509.9964);
	at[8] = 47.5000;
	points[9] = (0, 0, 0);
	angles[9] = (0, 0, -567.7463);
	at[9] = 47.7500;
	points[10] = (0, 0, 0);
	angles[10] = (0, 0, -625.4963);
	at[10] = 48;
	points[11] = (0, 0, 0);
	angles[11] = (0, 0, -683.2463);
	at[11] = 48.2500;
	points[12] = (0, 0, 0);
	angles[12] = (0, 0, -740.9963);
	at[12] = 48.5000;
	points[13] = (0, 0, 0);
	angles[13] = (0, 0, -809.9963);
	at[13] = 60;
	mover = getEnt("iz_mover4", "targetname");
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

iz_mover5()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, 0, 0);
	angles[0] = (0, 0, 0.0018);
	at[0] = 0;
	points[1] = (0, 0, 0);
	angles[1] = (0, 0, -82.4982);
	at[1] = 13.7500;
	points[2] = (0, 0, 0);
	angles[2] = (0, 0, -164.9982);
	at[2] = 27.5000;
	points[3] = (0, 0, 0);
	angles[3] = (0, 0, -222.7482);
	at[3] = 27.7500;
	points[4] = (0, 0, 0);
	angles[4] = (0, 0, -280.4982);
	at[4] = 28;
	points[5] = (0, 0, 0);
	angles[5] = (0, 0, -338.2482);
	at[5] = 28.2500;
	points[6] = (0, 0, 0);
	angles[6] = (0, 0, -395.9982);
	at[6] = 28.5000;
	points[7] = (0, 0, 0);
	angles[7] = (0, 0, -460.4982);
	at[7] = 39.2500;
	points[8] = (0, 0, 0);
	angles[8] = (0, 0, -524.9982);
	at[8] = 50;
	points[9] = (0, 0, 0);
	angles[9] = (0, 0, -582.7481);
	at[9] = 50.2500;
	points[10] = (0, 0, 0);
	angles[10] = (0, 0, -640.4982);
	at[10] = 50.5000;
	points[11] = (0, 0, 0);
	angles[11] = (0, 0, -698.2481);
	at[11] = 50.7500;
	points[12] = (0, 0, 0);
	angles[12] = (0, 0, -755.9981);
	at[12] = 51;
	points[13] = (0, 0, 0);
	angles[13] = (0, 0, -809.9981);
	at[13] = 60;
	mover = getEnt("iz_mover5", "targetname");
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
	mover thread iz_mover_loop(points, angles, at, false, false);
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
	angles[1] = (0, 0, -45);
	at[1] = 7.5000;
	points[2] = (0, 0, 0);
	angles[2] = (0, 0, -90);
	at[2] = 15;
	points[3] = (0, 0, 0);
	angles[3] = (0, 0, -180);
	at[3] = 30;
	points[4] = (0, 0, 0);
	angles[4] = (0, 0, -237.7501);
	at[4] = 30.2500;
	points[5] = (0, 0, 0);
	angles[5] = (0, 0, -295.4999);
	at[5] = 30.5000;
	points[6] = (0, 0, 0);
	angles[6] = (0, 0, -353.2500);
	at[6] = 30.7500;
	points[7] = (0, 0, 0);
	angles[7] = (0, 0, -411);
	at[7] = 31;
	points[8] = (0, 0, 0);
	angles[8] = (0, 0, -475.5001);
	at[8] = 41.7500;
	points[9] = (0, 0, 0);
	angles[9] = (0, 0, -540);
	at[9] = 52.5000;
	points[10] = (0, 0, 0);
	angles[10] = (0, 0, -597.7500);
	at[10] = 52.7500;
	points[11] = (0, 0, 0);
	angles[11] = (0, 0, -655.4999);
	at[11] = 53;
	points[12] = (0, 0, 0);
	angles[12] = (0, 0, -713.2500);
	at[12] = 53.2500;
	points[13] = (0, 0, 0);
	angles[13] = (0, 0, -771);
	at[13] = 53.5000;
	points[14] = (0, 0, 0);
	angles[14] = (0, 0, -810);
	at[14] = 60;
	mover = getEnt("iz_mover6", "targetname");
	if (!isDefined(mover))
		return;
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
	mover thread iz_mover_loop(points, angles, at, false, false);
}

iz_mover7()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, 0, 0);
	angles[0] = (0, 0, 0.0037);
	at[0] = 0;
	points[1] = (0, 0, 0);
	angles[1] = (0, 0, -48.5963);
	at[1] = 8.1000;
	points[2] = (0, 0, 0);
	angles[2] = (0, 0, -97.4964);
	at[2] = 16.2500;
	points[3] = (0, 0, 0);
	angles[3] = (0, 0, -146.0963);
	at[3] = 24.3500;
	points[4] = (0, 0, 0);
	angles[4] = (0, 0, -194.9964);
	at[4] = 32.5000;
	points[5] = (0, 0, 0);
	angles[5] = (0, 0, -252.7463);
	at[5] = 32.7500;
	points[6] = (0, 0, 0);
	angles[6] = (0, 0, -310.4963);
	at[6] = 33;
	points[7] = (0, 0, 0);
	angles[7] = (0, 0, -368.2463);
	at[7] = 33.2500;
	points[8] = (0, 0, 0);
	angles[8] = (0, 0, -425.9963);
	at[8] = 33.5000;
	points[9] = (0, 0, 0);
	angles[9] = (0, 0, -490.4963);
	at[9] = 44.2500;
	points[10] = (0, 0, 0);
	angles[10] = (0, 0, -554.9963);
	at[10] = 55;
	points[11] = (0, 0, 0);
	angles[11] = (0, 0, -612.7463);
	at[11] = 55.2500;
	points[12] = (0, 0, 0);
	angles[12] = (0, 0, -670.4963);
	at[12] = 55.5000;
	points[13] = (0, 0, 0);
	angles[13] = (0, 0, -728.2463);
	at[13] = 55.7500;
	points[14] = (0, 0, 0);
	angles[14] = (0, 0, -785.9963);
	at[14] = 56;
	points[15] = (0, 0, 0);
	angles[15] = (0, 0, -809.9963);
	at[15] = 60;
	mover = getEnt("iz_mover7", "targetname");
	if (!isDefined(mover))
		return;
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
	rider = getEnt("iz_bumper30_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	rider = getEnt("iz_bumper31_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	mover thread iz_mover_loop(points, angles, at, false, false);
}

iz_mover8()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, 0, 0);
	angles[0] = (0, 0, 0.0018);
	at[0] = 0;
	points[1] = (0, 0, 0);
	angles[1] = (0, 0, -52.4981);
	at[1] = 8.7500;
	points[2] = (0, 0, 0);
	angles[2] = (0, 0, -104.9982);
	at[2] = 17.5000;
	points[3] = (0, 0, 0);
	angles[3] = (0, 0, -157.4982);
	at[3] = 26.2500;
	points[4] = (0, 0, 0);
	angles[4] = (0, 0, -209.9982);
	at[4] = 35;
	points[5] = (0, 0, 0);
	angles[5] = (0, 0, -267.7481);
	at[5] = 35.2500;
	points[6] = (0, 0, 0);
	angles[6] = (0, 0, -325.4982);
	at[6] = 35.5000;
	points[7] = (0, 0, 0);
	angles[7] = (0, 0, -383.2482);
	at[7] = 35.7500;
	points[8] = (0, 0, 0);
	angles[8] = (0, 0, -440.9982);
	at[8] = 36;
	points[9] = (0, 0, 0);
	angles[9] = (0, 0, -505.4981);
	at[9] = 46.7500;
	points[10] = (0, 0, 0);
	angles[10] = (0, 0, -569.9982);
	at[10] = 57.5000;
	points[11] = (0, 0, 0);
	angles[11] = (0, 0, -627.7481);
	at[11] = 57.7500;
	points[12] = (0, 0, 0);
	angles[12] = (0, 0, -685.4982);
	at[12] = 58;
	points[13] = (0, 0, 0);
	angles[13] = (0, 0, -743.2482);
	at[13] = 58.2500;
	points[14] = (0, 0, 0);
	angles[14] = (0, 0, -800.9982);
	at[14] = 58.5000;
	points[15] = (0, 0, 0);
	angles[15] = (0, 0, -809.9981);
	at[15] = 60;
	mover = getEnt("iz_mover8", "targetname");
	if (!isDefined(mover))
		return;
	rider = getEnt("iz_bumper32_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	rider = getEnt("iz_bumper33_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	rider = getEnt("iz_bumper34_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	rider = getEnt("iz_bumper35_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	mover thread iz_mover_loop(points, angles, at, false, false);
}

iz_mover9()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, 0, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 0, 0);
	angles[1] = (0, 0, -45);
	at[1] = 7.5000;
	points[2] = (0, 0, 0);
	angles[2] = (0, 0, -90);
	at[2] = 15;
	points[3] = (0, 0, 0);
	angles[3] = (0, 0, -180);
	at[3] = 30;
	points[4] = (0, 0, 0);
	angles[4] = (0, 0, -225);
	at[4] = 37.5000;
	points[5] = (0, 0, 0);
	angles[5] = (0, 0, -270);
	at[5] = 45;
	points[6] = (0, 0, 0);
	angles[6] = (0, 0, -360);
	at[6] = 60;
	mover = getEnt("iz_mover9", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover10()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, 0, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 0, 0);
	angles[1] = (0, 0, -45);
	at[1] = 7.5000;
	points[2] = (0, 0, 0);
	angles[2] = (0, 0, -90);
	at[2] = 15;
	points[3] = (0, 0, 0);
	angles[3] = (0, 0, -180);
	at[3] = 30;
	points[4] = (0, 0, 0);
	angles[4] = (0, 0, -225);
	at[4] = 37.5000;
	points[5] = (0, 0, 0);
	angles[5] = (0, 0, -270);
	at[5] = 45;
	points[6] = (0, 0, 0);
	angles[6] = (0, 0, -360);
	at[6] = 60;
	mover = getEnt("iz_mover10", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover11()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, 0, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 0, 0);
	angles[1] = (0, 0, -45);
	at[1] = 7.5000;
	points[2] = (0, 0, 0);
	angles[2] = (0, 0, -90);
	at[2] = 15;
	points[3] = (0, 0, 0);
	angles[3] = (0, 0, -180);
	at[3] = 30;
	points[4] = (0, 0, 0);
	angles[4] = (0, 0, -225);
	at[4] = 37.5000;
	points[5] = (0, 0, 0);
	angles[5] = (0, 0, -270);
	at[5] = 45;
	points[6] = (0, 0, 0);
	angles[6] = (0, 0, -360);
	at[6] = 60;
	mover = getEnt("iz_mover11", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover12()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, 0, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 0, 0);
	angles[1] = (0, 0, -45);
	at[1] = 7.5000;
	points[2] = (0, 0, 0);
	angles[2] = (0, 0, -90);
	at[2] = 15;
	points[3] = (0, 0, 0);
	angles[3] = (0, 0, -180);
	at[3] = 30;
	points[4] = (0, 0, 0);
	angles[4] = (0, 0, -225);
	at[4] = 37.5000;
	points[5] = (0, 0, 0);
	angles[5] = (0, 0, -270);
	at[5] = 45;
	points[6] = (0, 0, 0);
	angles[6] = (0, 0, -360);
	at[6] = 60;
	mover = getEnt("iz_mover12", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover13()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, 0, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 0, 0);
	angles[1] = (0, 0, -45);
	at[1] = 7.5000;
	points[2] = (0, 0, 0);
	angles[2] = (0, 0, -90);
	at[2] = 15;
	points[3] = (0, 0, 0);
	angles[3] = (0, 0, -180);
	at[3] = 30;
	points[4] = (0, 0, 0);
	angles[4] = (0, 0, -225);
	at[4] = 37.5000;
	points[5] = (0, 0, 0);
	angles[5] = (0, 0, -270);
	at[5] = 45;
	points[6] = (0, 0, 0);
	angles[6] = (0, 0, -360);
	at[6] = 60;
	mover = getEnt("iz_mover13", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover14()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, 0, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 0, 0);
	angles[1] = (0, 0, -45);
	at[1] = 7.5000;
	points[2] = (0, 0, 0);
	angles[2] = (0, 0, -90);
	at[2] = 15;
	points[3] = (0, 0, 0);
	angles[3] = (0, 0, -180);
	at[3] = 30;
	points[4] = (0, 0, 0);
	angles[4] = (0, 0, -225);
	at[4] = 37.5000;
	points[5] = (0, 0, 0);
	angles[5] = (0, 0, -270);
	at[5] = 45;
	points[6] = (0, 0, 0);
	angles[6] = (0, 0, -360);
	at[6] = 60;
	mover = getEnt("iz_mover14", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover15()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, 0, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 0, 0);
	angles[1] = (0, 0, -45);
	at[1] = 7.5000;
	points[2] = (0, 0, 0);
	angles[2] = (0, 0, -90);
	at[2] = 15;
	points[3] = (0, 0, 0);
	angles[3] = (0, 0, -180);
	at[3] = 30;
	points[4] = (0, 0, 0);
	angles[4] = (0, 0, -225);
	at[4] = 37.5000;
	points[5] = (0, 0, 0);
	angles[5] = (0, 0, -270);
	at[5] = 45;
	points[6] = (0, 0, 0);
	angles[6] = (0, 0, -360);
	at[6] = 60;
	mover = getEnt("iz_mover15", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover16()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, 0, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 0, 0);
	angles[1] = (0, 0, -45);
	at[1] = 7.5000;
	points[2] = (0, 0, 0);
	angles[2] = (0, 0, -90);
	at[2] = 15;
	points[3] = (0, 0, 0);
	angles[3] = (0, 0, -180);
	at[3] = 30;
	points[4] = (0, 0, 0);
	angles[4] = (0, 0, -225);
	at[4] = 37.5000;
	points[5] = (0, 0, 0);
	angles[5] = (0, 0, -270);
	at[5] = 45;
	points[6] = (0, 0, 0);
	angles[6] = (0, 0, -360);
	at[6] = 60;
	mover = getEnt("iz_mover16", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover17()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, 0, 0);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 0, 0);
	angles[1] = (0, 0, -45);
	at[1] = 7.5000;
	points[2] = (0, 0, 0);
	angles[2] = (0, 0, -90);
	at[2] = 15;
	points[3] = (0, 0, 0);
	angles[3] = (0, 0, -180);
	at[3] = 30;
	points[4] = (0, 0, 0);
	angles[4] = (0, 0, -225);
	at[4] = 37.5000;
	points[5] = (0, 0, 0);
	angles[5] = (0, 0, -270);
	at[5] = 45;
	points[6] = (0, 0, 0);
	angles[6] = (0, 0, -360);
	at[6] = 60;
	mover = getEnt("iz_mover17", "targetname");
	if (!isDefined(mover))
		return;
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
