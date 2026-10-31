main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_smb1_middle_jam", 0);

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
	thread iz_mover18();
	thread iz_mover19();
}

iz_mover0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-1120, 280, -7);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0.0013, 280, -7);
	angles[1] = (0, 0, 0);
	at[1] = 5;
	points[2] = (0.0013, -280, -7);
	angles[2] = (0, 0, 0);
	at[2] = 7.5000;
	points[3] = (-2240, -280, -7);
	angles[3] = (0, 0, 0);
	at[3] = 17.5000;
	points[4] = (-2240, 280, -7);
	angles[4] = (0, 0, 0);
	at[4] = 20;
	points[5] = (-1120, 280, -7);
	angles[5] = (0, 0, 0);
	at[5] = 25;
	mover = getEnt("iz_mover0", "targetname");
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

iz_mover1()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (1960, -280, -7);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (2240, -280, -7);
	angles[1] = (0, 0, 0);
	at[1] = 1.2500;
	points[2] = (2240, 280, -7);
	angles[2] = (0, 0, 0);
	at[2] = 3.7500;
	points[3] = (0, 280, -7);
	angles[3] = (0, 0, 0);
	at[3] = 13.7500;
	points[4] = (0, -280, -7);
	angles[4] = (0, 0, 0);
	at[4] = 16.2500;
	points[5] = (1960, -280, -7);
	angles[5] = (0, 0, 0);
	at[5] = 25;
	mover = getEnt("iz_mover1", "targetname");
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

iz_mover2()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-1680, 280, -7);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0.0013, 280, -7);
	angles[1] = (0, 0, 0);
	at[1] = 7.5000;
	points[2] = (0.0013, -280, -7);
	angles[2] = (0, 0, 0);
	at[2] = 10;
	points[3] = (-2240, -280, -7);
	angles[3] = (0, 0, 0);
	at[3] = 20;
	points[4] = (-2240, 280, -7);
	angles[4] = (0, 0, 0);
	at[4] = 22.5000;
	points[5] = (-1680, 280, -7);
	angles[5] = (0, 0, 0);
	at[5] = 25;
	mover = getEnt("iz_mover2", "targetname");
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

iz_mover3()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-1680, -280, -7);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2240, -280, -7);
	angles[1] = (0, 0, 0);
	at[1] = 2.5000;
	points[2] = (-2240, 280, -7);
	angles[2] = (0, 0, 0);
	at[2] = 5;
	points[3] = (0.0013, 280, -7);
	angles[3] = (0, 0, 0);
	at[3] = 15;
	points[4] = (0.0013, -280, -7);
	angles[4] = (0, 0, 0);
	at[4] = 17.5000;
	points[5] = (-1680, -280, -7);
	angles[5] = (0, 0, 0);
	at[5] = 25;
	mover = getEnt("iz_mover3", "targetname");
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

iz_mover4()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-560, -280, -7);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2240, -280, -7);
	angles[1] = (0, 0, 0);
	at[1] = 7.5000;
	points[2] = (-2240, 280, -7);
	angles[2] = (0, 0, 0);
	at[2] = 10;
	points[3] = (0.0013, 280, -7);
	angles[3] = (0, 0, 0);
	at[3] = 20;
	points[4] = (0.0013, -280, -7);
	angles[4] = (0, 0, 0);
	at[4] = 22.5000;
	points[5] = (-560, -280, -7);
	angles[5] = (0, 0, 0);
	at[5] = 25;
	mover = getEnt("iz_mover4", "targetname");
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

iz_mover5()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-2240, -280, -7);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2240, 280, -7);
	angles[1] = (0, 0, 0);
	at[1] = 2.5000;
	points[2] = (0.0013, 280, -7);
	angles[2] = (0, 0, 0);
	at[2] = 12.5000;
	points[3] = (0.0013, -280, -7);
	angles[3] = (0, 0, 0);
	at[3] = 15;
	points[4] = (-2240, -280, -7);
	angles[4] = (0, 0, 0);
	at[4] = 25;
	mover = getEnt("iz_mover5", "targetname");
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

iz_mover6()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-1120, -280, -7);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2240, -280, -7);
	angles[1] = (0, 0, 0);
	at[1] = 5;
	points[2] = (-2240, 280, -7);
	angles[2] = (0, 0, 0);
	at[2] = 7.5000;
	points[3] = (0.0013, 280, -7);
	angles[3] = (0, 0, 0);
	at[3] = 17.5000;
	points[4] = (0.0013, -280, -7);
	angles[4] = (0, 0, 0);
	at[4] = 20;
	points[5] = (-1120, -280, -7);
	angles[5] = (0, 0, 0);
	at[5] = 25;
	mover = getEnt("iz_mover6", "targetname");
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

iz_mover7()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0.0013, 280, -7);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0.0013, -280, -7);
	angles[1] = (0, 0, 0);
	at[1] = 2.5000;
	points[2] = (-2240, -280, -7);
	angles[2] = (0, 0, 0);
	at[2] = 12.5000;
	points[3] = (-2240, 280, -7);
	angles[3] = (0, 0, 0);
	at[3] = 15;
	points[4] = (0.0013, 280, -7);
	angles[4] = (0, 0, 0);
	at[4] = 25;
	mover = getEnt("iz_mover7", "targetname");
	if (!isDefined(mover))
		return;
	rider = getEnt("iz_bumper7_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover8()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (840, -280, -7);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (2240, -280, -7);
	angles[1] = (0, 0, 0);
	at[1] = 6.2500;
	points[2] = (2240, 280, -7);
	angles[2] = (0, 0, 0);
	at[2] = 8.7500;
	points[3] = (0, 280, -7);
	angles[3] = (0, 0, 0);
	at[3] = 18.7500;
	points[4] = (0, -280, -7);
	angles[4] = (0, 0, 0);
	at[4] = 21.2500;
	points[5] = (840, -280, -7);
	angles[5] = (0, 0, 0);
	at[5] = 25;
	mover = getEnt("iz_mover8", "targetname");
	if (!isDefined(mover))
		return;
	rider = getEnt("iz_bumper8_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover9()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (280, 280, -7);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 280, -7);
	angles[1] = (0, 0, 0);
	at[1] = 1.2500;
	points[2] = (0, -280, -7);
	angles[2] = (0, 0, 0);
	at[2] = 3.7500;
	points[3] = (2240, -280, -7);
	angles[3] = (0, 0, 0);
	at[3] = 13.7500;
	points[4] = (2240, 280, -7);
	angles[4] = (0, 0, 0);
	at[4] = 16.2500;
	points[5] = (280, 280, -7);
	angles[5] = (0, 0, 0);
	at[5] = 25;
	mover = getEnt("iz_mover9", "targetname");
	if (!isDefined(mover))
		return;
	rider = getEnt("iz_bumper9_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover10()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0.0013, -280, -7);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2240, -280, -7);
	angles[1] = (0, 0, 0);
	at[1] = 10;
	points[2] = (-2240, 280, -7);
	angles[2] = (0, 0, 0);
	at[2] = 12.5000;
	points[3] = (0.0013, 280, -7);
	angles[3] = (0, 0, 0);
	at[3] = 22.5000;
	points[4] = (0.0013, -280, -7);
	angles[4] = (0, 0, 0);
	at[4] = 25;
	mover = getEnt("iz_mover10", "targetname");
	if (!isDefined(mover))
		return;
	rider = getEnt("iz_bumper10_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover11()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (0, 0, -7);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, -280, -7);
	angles[1] = (0, 0, 0);
	at[1] = 1.2500;
	points[2] = (2240, -280, -7);
	angles[2] = (0, 0, 0);
	at[2] = 11.2500;
	points[3] = (2240, 280, -7);
	angles[3] = (0, 0, 0);
	at[3] = 13.7500;
	points[4] = (0, 280, -7);
	angles[4] = (0, 0, 0);
	at[4] = 23.7500;
	points[5] = (0, 0, -7);
	angles[5] = (0, 0, 0);
	at[5] = 25;
	mover = getEnt("iz_mover11", "targetname");
	if (!isDefined(mover))
		return;
	rider = getEnt("iz_bumper11_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover12()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (1400, 280, -7);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 280, -7);
	angles[1] = (0, 0, 0);
	at[1] = 6.2500;
	points[2] = (0, -280, -7);
	angles[2] = (0, 0, 0);
	at[2] = 8.7500;
	points[3] = (2240, -280, -7);
	angles[3] = (0, 0, 0);
	at[3] = 18.7500;
	points[4] = (2240, 280, -7);
	angles[4] = (0, 0, 0);
	at[4] = 21.2500;
	points[5] = (1400, 280, -7);
	angles[5] = (0, 0, 0);
	at[5] = 25;
	mover = getEnt("iz_mover12", "targetname");
	if (!isDefined(mover))
		return;
	rider = getEnt("iz_bumper12_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover13()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (840, 280, -7);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 280, -7);
	angles[1] = (0, 0, 0);
	at[1] = 3.7500;
	points[2] = (0, -280, -7);
	angles[2] = (0, 0, 0);
	at[2] = 6.2500;
	points[3] = (2240, -280, -7);
	angles[3] = (0, 0, 0);
	at[3] = 16.2500;
	points[4] = (2240, 280, -7);
	angles[4] = (0, 0, 0);
	at[4] = 18.7500;
	points[5] = (840, 280, -7);
	angles[5] = (0, 0, 0);
	at[5] = 25;
	mover = getEnt("iz_mover13", "targetname");
	if (!isDefined(mover))
		return;
	rider = getEnt("iz_bumper13_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover14()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (2240, 0, -7);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (2240, 280, -7);
	angles[1] = (0, 0, 0);
	at[1] = 1.2500;
	points[2] = (0, 280, -7);
	angles[2] = (0, 0, 0);
	at[2] = 11.2500;
	points[3] = (0, -280, -7);
	angles[3] = (0, 0, 0);
	at[3] = 13.7500;
	points[4] = (2240, -280, -7);
	angles[4] = (0, 0, 0);
	at[4] = 23.7500;
	points[5] = (2240, 0, -7);
	angles[5] = (0, 0, 0);
	at[5] = 25;
	mover = getEnt("iz_mover14", "targetname");
	if (!isDefined(mover))
		return;
	rider = getEnt("iz_bumper14_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover15()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (1960, 280, -7);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 280, -7);
	angles[1] = (0, 0, 0);
	at[1] = 8.7500;
	points[2] = (0, -280, -7);
	angles[2] = (0, 0, 0);
	at[2] = 11.2500;
	points[3] = (2240, -280, -7);
	angles[3] = (0, 0, 0);
	at[3] = 21.2500;
	points[4] = (2240, 280, -7);
	angles[4] = (0, 0, 0);
	at[4] = 23.7500;
	points[5] = (1960, 280, -7);
	angles[5] = (0, 0, 0);
	at[5] = 25;
	mover = getEnt("iz_mover15", "targetname");
	if (!isDefined(mover))
		return;
	rider = getEnt("iz_bumper15_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover16()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (1400, -280, -7);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (2240, -280, -7);
	angles[1] = (0, 0, 0);
	at[1] = 3.7500;
	points[2] = (2240, 280, -7);
	angles[2] = (0, 0, 0);
	at[2] = 6.2500;
	points[3] = (0, 280, -7);
	angles[3] = (0, 0, 0);
	at[3] = 16.2500;
	points[4] = (0, -280, -7);
	angles[4] = (0, 0, 0);
	at[4] = 18.7500;
	points[5] = (1400, -280, -7);
	angles[5] = (0, 0, 0);
	at[5] = 25;
	mover = getEnt("iz_mover16", "targetname");
	if (!isDefined(mover))
		return;
	rider = getEnt("iz_bumper16_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover17()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-2240, 280, -7);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0.0013, 280, -7);
	angles[1] = (0, 0, 0);
	at[1] = 10;
	points[2] = (0.0013, -280, -7);
	angles[2] = (0, 0, 0);
	at[2] = 12.5000;
	points[3] = (-2240, -280, -7);
	angles[3] = (0, 0, 0);
	at[3] = 22.5000;
	points[4] = (-2240, 280, -7);
	angles[4] = (0, 0, 0);
	at[4] = 25;
	mover = getEnt("iz_mover17", "targetname");
	if (!isDefined(mover))
		return;
	rider = getEnt("iz_bumper17_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover18()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-560, 280, -7);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0.0013, 280, -7);
	angles[1] = (0, 0, 0);
	at[1] = 2.5000;
	points[2] = (0.0013, -280, -7);
	angles[2] = (0, 0, 0);
	at[2] = 5;
	points[3] = (-2240, -280, -7);
	angles[3] = (0, 0, 0);
	at[3] = 15;
	points[4] = (-2240, 280, -7);
	angles[4] = (0, 0, 0);
	at[4] = 17.5000;
	points[5] = (-560, 280, -7);
	angles[5] = (0, 0, 0);
	at[5] = 25;
	mover = getEnt("iz_mover18", "targetname");
	if (!isDefined(mover))
		return;
	rider = getEnt("iz_bumper18_touch", "targetname");
	if (isDefined(rider))
	{
		rider enableLinkTo();
		rider linkTo(mover);
	}
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover19()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (280, -280, -7);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (2240, -280, -7);
	angles[1] = (0, 0, 0);
	at[1] = 8.7500;
	points[2] = (2240, 280, -7);
	angles[2] = (0, 0, 0);
	at[2] = 11.2500;
	points[3] = (0, 280, -7);
	angles[3] = (0, 0, 0);
	at[3] = 21.2500;
	points[4] = (0, -280, -7);
	angles[4] = (0, 0, 0);
	at[4] = 23.7500;
	points[5] = (280, -280, -7);
	angles[5] = (0, 0, 0);
	at[5] = 25;
	mover = getEnt("iz_mover19", "targetname");
	if (!isDefined(mover))
		return;
	rider = getEnt("iz_bumper19_touch", "targetname");
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
