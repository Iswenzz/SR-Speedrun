main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_wiiu_dry_dry_desert", 0);

	setExpFog(4429.1338, 64099.4023, 0.6784, 0.6431, 0.0627, 0);

	level.iz_cue = [];
	level.iz_cue["iz_cue_boost"] = true;
	level.iz_cue["iz_cue_bounce"] = true;
	level.iz_cue["iz_cue_cannon"] = true;
	level.iz_cue["iz_cue_finish"] = true;
	level.iz_cue["iz_cue_item"] = true;
	level.iz_cue["iz_cue_jump"] = true;
	thread iz_sounds();

	thread iz_course();
	thread sr\api\_speedrun::createNormalWays("Normal Way;");

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
	ambientPlay("iz_0_urddd", 2);
}

iz_course()
{
	iz_course_route();
	level.iz_course_gates = 0;
	gates = getEntArray("iz_gate", "targetname");
	for (i = 0; i < gates.size; i++)
	{
		gates[i].iz_order = int(gates[i].script_noteworthy);
		if (gates[i].iz_order > level.iz_course_gates)
			level.iz_course_gates = gates[i].iz_order;
	}
	iz_course_each("iz_gate", ::iz_course_gate);
	iz_course_each("iz_finish", ::iz_course_finish);
	iz_course_each("iz_boost", ::iz_course_boost);
	iz_course_each("iz_cannon", ::iz_course_cannon);
	iz_course_each("iz_jump", ::iz_course_jump);
	iz_course_each("iz_fall", ::iz_course_fall);
	iz_course_each("iz_itembox", ::iz_course_itembox);
	gone = 0;
	for (i = 0; gone < 16; i++)
	{
		mover = getEnt("iz_obj_" + i, "targetname");
		if (!isDefined(mover))
		{
			gone++;
			continue;
		}
		gone = 0;
		mover notSolid();
		if (isDefined(mover.radius))
			mover thread iz_course_hazard();
	}

	for (;;)
	{
		level waittill("player_spawn", player);
		player.iz_gate = 0;
	}
}

// One of the course's own sounds from whoever makes it, no sooner than
// rest milliseconds after they last made it.
iz_course_cue(name, rest)
{
	alias = "iz_cue_" + name;
	if (!isDefined(level.iz_cue) || !isDefined(level.iz_cue[alias]))
		return;
	if (rest > 0)
	{
		if (!isDefined(self.iz_cued))
			self.iz_cued = [];
		if (isDefined(self.iz_cued[name]) && getTime() - self.iz_cued[name] < rest)
			return;
		self.iz_cued[name] = getTime();
	}
	self playSound(alias);
}

iz_course_each(name, run)
{
	ents = getEntArray(name, "targetname");
	for (i = 0; i < ents.size; i++)
		ents[i] thread [[run]]();
}

iz_course_gate()
{
	for (;;)
	{
		self waittill("trigger", player);
		if (isDefined(player.iz_gate) && player.iz_gate == self.iz_order - 1)
			player.iz_gate = self.iz_order;
	}
}

iz_course_finish()
{
	for (;;)
	{
		self waittill("trigger", player);
		if (!isDefined(player.iz_gate) || player.iz_gate < level.iz_course_gates)
			continue;
		player.iz_gate = 0;
		player iz_course_cue("finish", 0);
		player sr\api\_speedrun::finishWay("normal_0");
	}
}

iz_course_boost()
{
	speed = int(self.script_noteworthy);
	for (;;)
	{
		self waittill("trigger", player);
		if (!isPlayer(player) || !isAlive(player))
			continue;

		velocity = player getVelocity();
		way = (velocity[0], velocity[1], 0);
		player iz_course_cue("boost", 1000);
		if (length(way) >= speed)
			continue;
		if (length(way) < 50)
			way = anglesToForward((0, player getPlayerAngles()[1], 0));
		else
			way = vectorNormalize(way);
		player setVelocity((way[0] * speed, way[1] * speed, velocity[2]));
	}
}

iz_course_jump()
{
	toss = strTok(self.script_noteworthy, " ");
	if (toss.size != 4)
		return;
	speed = int(toss[0]);
	rise = int(toss[1]);
	rest = int(toss[2]);
	cue = toss[3];
	for (;;)
	{
		self waittill("trigger", player);
		now = getTime();
		if (!isPlayer(player) || !isAlive(player))
			continue;
		if (rest > 0)
		{
			if (isDefined(player.iz_thrown) && now - player.iz_thrown < rest)
				continue;
			player.iz_thrown = now;
		}

		velocity = player getVelocity();
		if (rest > 0)
		{
			player setVelocity((velocity[0], velocity[1], rise));
			player iz_course_cue(cue, 0);
			continue;
		}
		player iz_course_cue(cue, 1000);
		way = (velocity[0], velocity[1], 0);
		pace = length(way);
		if (pace < 50)
			way = anglesToForward((0, player getPlayerAngles()[1], 0));
		else
			way = vectorNormalize(way);
		if (pace < speed)
			pace = speed;
		player setVelocity((way[0] * pace, way[1] * pace, rise));
	}
}

iz_course_cannon()
{
	ends = getEntArray("iz_cannon_end", "targetname");
	for (i = 0; i < ends.size; i++)
	{
		flight = strTok(ends[i].script_noteworthy, " ");
		if (flight.size == 3 && flight[0] == self.script_noteworthy)
			self.iz_end = ends[i].origin;
	}
	if (!isDefined(self.iz_end))
		return;
	for (;;)
	{
		self waittill("trigger", player);
		if (!isPlayer(player) || !isAlive(player))
			continue;

		velocity = player getVelocity();
		speed = length((velocity[0], velocity[1], 0));
		way = vectorNormalize((self.iz_end[0] - player.origin[0], self.iz_end[1] - player.origin[1], 0));
		player setOrigin(self.iz_end);
		player iz_course_cue("cannon", 0);
		player setPlayerAngles((0, vectorToAngles(way)[1], 0));
		player setVelocity((way[0] * speed, way[1] * speed, velocity[2]));
	}
}

iz_course_fall()
{
	for (;;)
	{
		self waittill("trigger", player);
		if (isPlayer(player) && isAlive(player))
			player suicide();
	}
}

iz_course_itembox()
{
	self notSolid();
	reach = 60;
	if (isDefined(self.radius))
		reach = self.radius;
	marks = getEntArray("iz_itembox_mark", "targetname");
	for (i = 0; i < marks.size; i++)
		if (distance(marks[i].origin, self.origin) < 4)
			self.iz_mark = marks[i];
	if (isDefined(self.iz_mark))
	{
		self.iz_mark notSolid();
		self.iz_mark thread iz_course_turn();
		self.iz_mark thread iz_course_slide();
	}
	self thread iz_course_spin();
	self thread iz_course_slide();
	for (;;)
	{
		wait 0.05;
		players = getEntArray("player", "classname");
		for (i = 0; i < players.size; i++)
		{
			if (!isAlive(players[i]) || distance(players[i].origin + (0, 0, 35), self.origin) > reach)
				continue;
			self.iz_taken = true;
			self iz_course_cue("item", 0);
			self hide();
			if (isDefined(self.iz_mark))
				self.iz_mark hide();
			wait 3;
			self show();
			if (isDefined(self.iz_mark))
				self.iz_mark show();
			self.iz_taken = undefined;
			break;
		}
	}
}

iz_course_hazard()
{
	reach = self.radius;
	for (;;)
	{
		wait 0.05;
		players = getEntArray("player", "classname");
		for (i = 0; i < players.size; i++)
		{
			player = players[i];
			if (!isAlive(player))
				continue;
			away = (player.origin[0] - self.origin[0], player.origin[1] - self.origin[1], 0);
			if (length(away) > reach || player.origin[2] > self.origin[2] + reach * 2 || player.origin[2] + 72 < self.origin[2])
				continue;
			now = getTime();
			if (isDefined(player.iz_struck) && now - player.iz_struck < 1500)
				continue;
			player.iz_struck = now;
			if (length(away) < 1)
				away = anglesToForward((0, randomInt(360), 0));
			away = vectorNormalize(away);
			player setVelocity((away[0] * 320, away[1] * 320, 240));
			player notify("iz_hit", self);
		}
	}
}

iz_course_slide()
{
	if (!isDefined(self.script_noteworthy))
		return;
	path = strTok(self.script_noteworthy, " ");
	if (path.size != 8)
		return;
	from = (int(path[0]), int(path[1]), int(path[2]));
	to = (int(path[3]), int(path[4]), int(path[5]));
	way = int(path[6]) / 2000;
	if (way < 0.1)
		return;
	if (int(path[7]) > 0)
		wait int(path[7]) / 1000;
	for (;;)
	{
		self moveTo(to, way, way / 2, way / 2);
		wait way;
		self moveTo(from, way, way / 2, way / 2);
		wait way;
	}
}

iz_course_spin()
{
	for (;;)
	{
		self rotateVelocity((40, 110, 25), 10);
		wait 10;
	}
}

iz_course_turn()
{
	for (;;)
	{
		self rotateYaw(360, 8);
		wait 8;
	}
}

iz_course_route()
{
	level.iz_route = [];
	level.iz_route[level.iz_route.size] = (2468, 2014, 1132);
	level.iz_route[level.iz_route.size] = (2480, 1004, 1135);
	level.iz_route[level.iz_route.size] = (2479, 52, 1140);
	level.iz_route[level.iz_route.size] = (2479, -923, 1136);
	level.iz_route[level.iz_route.size] = (2473, -2379, 1130);
	level.iz_route[level.iz_route.size] = (2387, -3299, 1121);
	level.iz_route[level.iz_route.size] = (2110, -4365, 1111);
	level.iz_route[level.iz_route.size] = (1693, -5092, 1119);
	level.iz_route[level.iz_route.size] = (1086, -5605, 1125);
	level.iz_route[level.iz_route.size] = (200, -5927, 1113);
	level.iz_route[level.iz_route.size] = (-669, -6021, 1071);
	level.iz_route[level.iz_route.size] = (-1565, -5884, 983);
	level.iz_route[level.iz_route.size] = (-2340, -5376, 821);
	level.iz_route[level.iz_route.size] = (-2871, -4695, 765);
	level.iz_route[level.iz_route.size] = (-3383, -4095, 787);
	level.iz_route[level.iz_route.size] = (-3743, -3872, 802);
	level.iz_route[level.iz_route.size] = (-4199, -3844, 777);
	level.iz_route[level.iz_route.size] = (-4659, -4116, 693);
	level.iz_route[level.iz_route.size] = (-5017, -4506, 632);
	level.iz_route[level.iz_route.size] = (-5247, -4893, 606);
	level.iz_route[level.iz_route.size] = (-5626, -5122, 599);
	level.iz_route[level.iz_route.size] = (-6122, -5204, 592);
	level.iz_route[level.iz_route.size] = (-6593, -5164, 602);
	level.iz_route[level.iz_route.size] = (-6979, -4824, 627);
	level.iz_route[level.iz_route.size] = (-7142, -4512, 642);
	level.iz_route[level.iz_route.size] = (-7265, -4235, 659);
	level.iz_route[level.iz_route.size] = (-7461, -3971, 685);
	level.iz_route[level.iz_route.size] = (-7790, -3862, 713);
	level.iz_route[level.iz_route.size] = (-8163, -3878, 737);
	level.iz_route[level.iz_route.size] = (-8550, -4003, 760);
	level.iz_route[level.iz_route.size] = (-8904, -4272, 780);
	level.iz_route[level.iz_route.size] = (-9152, -4554, 797);
	level.iz_route[level.iz_route.size] = (-9453, -4904, 834);
	level.iz_route[level.iz_route.size] = (-9699, -5123, 870);
	level.iz_route[level.iz_route.size] = (-10003, -5300, 919);
	level.iz_route[level.iz_route.size] = (-10446, -5522, 995);
	level.iz_route[level.iz_route.size] = (-10899, -5626, 1082);
	level.iz_route[level.iz_route.size] = (-11404, -5688, 1167);
	level.iz_route[level.iz_route.size] = (-11863, -5740, 1246);
	level.iz_route[level.iz_route.size] = (-12475, -5670, 1328);
	level.iz_route[level.iz_route.size] = (-13066, -5463, 1392);
	level.iz_route[level.iz_route.size] = (-13437, -5201, 1405);
	level.iz_route[level.iz_route.size] = (-13552, -4916, 1365);
	level.iz_route[level.iz_route.size] = (-13617, -4563, 1313);
	level.iz_route[level.iz_route.size] = (-13615, -4110, 1241);
	level.iz_route[level.iz_route.size] = (-13564, -3705, 1171);
	level.iz_route[level.iz_route.size] = (-13485, -3113, 1070);
	level.iz_route[level.iz_route.size] = (-13393, -2535, 983);
	level.iz_route[level.iz_route.size] = (-13221, -1663, 873);
	level.iz_route[level.iz_route.size] = (-13105, -708, 810);
	level.iz_route[level.iz_route.size] = (-12843, -259, 809);
	level.iz_route[level.iz_route.size] = (-12626, 391, 637);
	level.iz_route[level.iz_route.size] = (-12512, 961, 504);
	level.iz_route[level.iz_route.size] = (-12448, 1421, 456);
	level.iz_route[level.iz_route.size] = (-12562, 1996, 505);
	level.iz_route[level.iz_route.size] = (-12840, 2788, 701);
	level.iz_route[level.iz_route.size] = (-12814, 3203, 816);
	level.iz_route[level.iz_route.size] = (-12773, 4104, 821);
	level.iz_route[level.iz_route.size] = (-12768, 4546, 840);
	level.iz_route[level.iz_route.size] = (-12837, 5020, 864);
	level.iz_route[level.iz_route.size] = (-12920, 5864, 907);
	level.iz_route[level.iz_route.size] = (-12958, 6671, 969);
	level.iz_route[level.iz_route.size] = (-12863, 7287, 1037);
	level.iz_route[level.iz_route.size] = (-12670, 7966, 1102);
	level.iz_route[level.iz_route.size] = (-12392, 8729, 1166);
	level.iz_route[level.iz_route.size] = (-11971, 9213, 1147);
	level.iz_route[level.iz_route.size] = (-11499, 9687, 1135);
	level.iz_route[level.iz_route.size] = (-10937, 10016, 1066);
	level.iz_route[level.iz_route.size] = (-10244, 10310, 945);
	level.iz_route[level.iz_route.size] = (-9237, 10538, 773);
	level.iz_route[level.iz_route.size] = (-8597, 10620, 668);
	level.iz_route[level.iz_route.size] = (-7953, 10495, 549);
	level.iz_route[level.iz_route.size] = (-7154, 10356, 553);
	level.iz_route[level.iz_route.size] = (-6442, 10275, 549);
	level.iz_route[level.iz_route.size] = (-5422, 10187, 549);
	level.iz_route[level.iz_route.size] = (-4123, 10081, 549);
	level.iz_route[level.iz_route.size] = (-2815, 10053, 550);
	level.iz_route[level.iz_route.size] = (-1508, 9900, 549);
	level.iz_route[level.iz_route.size] = (108, 9639, 695);
	level.iz_route[level.iz_route.size] = (934, 9524, 763);
	level.iz_route[level.iz_route.size] = (1909, 9516, 864);
	level.iz_route[level.iz_route.size] = (2601, 9508, 955);
	level.iz_route[level.iz_route.size] = (3117, 9420, 1040);
	level.iz_route[level.iz_route.size] = (3357, 9108, 1053);
	level.iz_route[level.iz_route.size] = (3432, 8803, 1045);
	level.iz_route[level.iz_route.size] = (3476, 8464, 1034);
	level.iz_route[level.iz_route.size] = (3467, 7997, 1020);
	level.iz_route[level.iz_route.size] = (3176, 7449, 984);
	level.iz_route[level.iz_route.size] = (2678, 6774, 954);
	level.iz_route[level.iz_route.size] = (2326, 6263, 970);
	level.iz_route[level.iz_route.size] = (2182, 5764, 999);
	level.iz_route[level.iz_route.size] = (2141, 5248, 1033);
	level.iz_route[level.iz_route.size] = (2234, 4690, 1073);
	level.iz_route[level.iz_route.size] = (2402, 4135, 1100);
	level.iz_route[level.iz_route.size] = (2481, 3672, 1108);
	level.iz_route[level.iz_route.size] = (2474, 3110, 1118);
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

iz_anims()
{
	thread iz_obj_0();
	thread iz_obj_1();
	thread iz_obj_2();
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-2955.8896, -5153.0312, 761.8622);
	angles[0] = (0, -145, 0);
	at[0] = 0;
	points[1] = (-2825.1338, -5062.4409, 761.3504);
	angles[1] = (0, -145, 0);
	at[1] = 0.6000;
	points[2] = (-2705.2715, -4979.3701, 766.0315);
	angles[2] = (0, -145, 0);
	at[2] = 1.1500;
	points[3] = (-2585.4136, -4896.3384, 779.8819);
	angles[3] = (0, -145, 0);
	at[3] = 1.7000;
	points[4] = (-2432.8623, -4790.6299, 805.9252);
	angles[4] = (0, -145, 0);
	at[4] = 2.4000;
	points[5] = (-2432.8623, -4790.6299, 805.9252);
	angles[5] = (0, -145, 0);
	at[5] = 2.9000;
	points[6] = (-2586.1023, -4896.8110, 779.8189);
	angles[6] = (0, -145, 0);
	at[6] = 3.6000;
	points[7] = (-2705.9646, -4979.8818, 766.0197);
	angles[7] = (0, -145, 0);
	at[7] = 4.1500;
	points[8] = (-2825.8230, -5062.9136, 761.3622);
	angles[8] = (0, -145, 0);
	at[8] = 4.7000;
	points[9] = (-2956.5789, -5153.5039, 761.9055);
	angles[9] = (0, -145, 0);
	at[9] = 5.3000;
	points[10] = (-2960.2126, -5156.0234, 762.1378);
	angles[10] = (0, -145, 0);
	at[10] = 5.3500;
	points[11] = (-2960.2126, -5156.0234, 762.1378);
	angles[11] = (0, -145, 0);
	at[11] = 5.8000;
	points[12] = (-2955.8896, -5153.0312, 761.8622);
	angles[12] = (0, -145, 0);
	at[12] = 5.8333;
	mover = getEnt("iz_obj_0", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_1()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-6207.0083, -4994.9609, 596.6929);
	angles[0] = (0, -115, 0);
	at[0] = 0;
	points[1] = (-6259.8823, -5130.2759, 588.1929);
	angles[1] = (0, -115, 0);
	at[1] = 0.5500;
	points[2] = (-6307.9526, -5253.3076, 593.9488);
	angles[2] = (0, -115, 0);
	at[2] = 1.0500;
	points[3] = (-6360.8271, -5388.6611, 616.9291);
	angles[3] = (0, -115, 0);
	at[3] = 1.6000;
	points[4] = (-6432.9131, -5573.1895, 665.6732);
	angles[4] = (0, -115, 0);
	at[4] = 2.3500;
	points[5] = (-6432.9131, -5573.1895, 665.6732);
	angles[5] = (0, -115, 0);
	at[5] = 2.8500;
	points[6] = (-6427.2837, -5558.7402, 661.5512);
	angles[6] = (0, -115, 0);
	at[6] = 2.9000;
	points[7] = (-6359.9604, -5386.4961, 616.5394);
	angles[7] = (0, -115, 0);
	at[7] = 3.6000;
	points[8] = (-6307.0864, -5251.1416, 593.8465);
	angles[8] = (0, -115, 0);
	at[8] = 4.1500;
	points[9] = (-6259.0161, -5128.1104, 588.1024);
	angles[9] = (0, -115, 0);
	at[9] = 4.6500;
	points[10] = (-6206.1812, -4992.7954, 596.8386);
	angles[10] = (0, -115, 0);
	at[10] = 5.2000;
	points[11] = (-6204.5669, -4988.7007, 597.1063);
	angles[11] = (0, -115, 0);
	at[11] = 5.2500;
	points[12] = (-6204.5669, -4988.7007, 597.1063);
	angles[12] = (0, -115, 0);
	at[12] = 5.7000;
	points[13] = (-6207.0083, -4994.9609, 596.6929);
	angles[13] = (0, -115, 0);
	at[13] = 5.7333;
	mover = getEnt("iz_obj_1", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_2()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-9204.6455, -4970.7085, 802.6299);
	angles[0] = (0, -55, 0);
	at[0] = 0;
	points[1] = (-9275, -4892.2046, 806.9528);
	angles[1] = (0, -55, 0);
	at[1] = 0.4000;
	points[2] = (-9345.3545, -4813.7007, 818.6299);
	angles[2] = (0, -55, 0);
	at[2] = 0.8000;
	points[3] = (-9468.5039, -4676.3779, 854.3740);
	angles[3] = (0, -55, 0);
	at[3] = 1.5000;
	points[4] = (-9471.4180, -4673.0708, 855.2520);
	angles[4] = (0, -55, 0);
	at[4] = 1.5500;
	points[5] = (-9471.4180, -4673.0708, 855.2520);
	angles[5] = (0, -55, 0);
	at[5] = 2;
	points[6] = (-9349.4883, -4809.1338, 819.2126);
	angles[6] = (0, -55, 0);
	at[6] = 2.7000;
	points[7] = (-9279.1338, -4887.6382, 807.6299);
	angles[7] = (0, -55, 0);
	at[7] = 3.1000;
	points[8] = (-9199.9609, -4975.9448, 802.2402);
	angles[8] = (0, -55, 0);
	at[8] = 3.5500;
	points[9] = (-9199.9609, -4975.9448, 802.2402);
	angles[9] = (0, -55, 0);
	at[9] = 4.0500;
	points[10] = (-9204.6455, -4970.7085, 802.6299);
	angles[10] = (0, -55, 0);
	at[10] = 4.0667;
	mover = getEnt("iz_obj_2", "targetname");
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
