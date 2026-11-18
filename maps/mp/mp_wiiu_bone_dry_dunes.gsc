main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_wiiu_bone_dry_dunes", 0);

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
	ambientPlay("iz_0_ubdd", 2);
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
	level.iz_route[level.iz_route.size] = (-280, 3025, 3600);
	level.iz_route[level.iz_route.size] = (1137, 2685, 3600);
	level.iz_route[level.iz_route.size] = (2244, 2369, 3612);
	level.iz_route[level.iz_route.size] = (3192, 2081, 3643);
	level.iz_route[level.iz_route.size] = (3812, 1775, 3691);
	level.iz_route[level.iz_route.size] = (4088, 1361, 3728);
	level.iz_route[level.iz_route.size] = (4084, 781, 3751);
	level.iz_route[level.iz_route.size] = (3800, 358, 3736);
	level.iz_route[level.iz_route.size] = (3222, -95, 3716);
	level.iz_route[level.iz_route.size] = (2590, -756, 3716);
	level.iz_route[level.iz_route.size] = (2268, -1525, 3740);
	level.iz_route[level.iz_route.size] = (2415, -2321, 3738);
	level.iz_route[level.iz_route.size] = (2819, -3210, 3763);
	level.iz_route[level.iz_route.size] = (2946, -3923, 3845);
	level.iz_route[level.iz_route.size] = (2786, -4693, 3943);
	level.iz_route[level.iz_route.size] = (2399, -5262, 4023);
	level.iz_route[level.iz_route.size] = (1812, -5821, 4125);
	level.iz_route[level.iz_route.size] = (1140, -6283, 4258);
	level.iz_route[level.iz_route.size] = (184, -6715, 4443);
	level.iz_route[level.iz_route.size] = (-757, -7234, 4649);
	level.iz_route[level.iz_route.size] = (-1497, -7761, 4846);
	level.iz_route[level.iz_route.size] = (-1836, -8076, 4958);
	level.iz_route[level.iz_route.size] = (-2029, -8446, 5048);
	level.iz_route[level.iz_route.size] = (-2079, -8948, 5134);
	level.iz_route[level.iz_route.size] = (-1983, -9592, 5246);
	level.iz_route[level.iz_route.size] = (-2026, -10331, 5442);
	level.iz_route[level.iz_route.size] = (-2207, -10833, 5590);
	level.iz_route[level.iz_route.size] = (-2528, -11268, 5736);
	level.iz_route[level.iz_route.size] = (-3025, -11601, 5873);
	level.iz_route[level.iz_route.size] = (-3672, -11728, 5969);
	level.iz_route[level.iz_route.size] = (-4335, -11558, 5980);
	level.iz_route[level.iz_route.size] = (-4907, -11172, 5912);
	level.iz_route[level.iz_route.size] = (-5168, -10594, 5755);
	level.iz_route[level.iz_route.size] = (-5237, -9958, 5585);
	level.iz_route[level.iz_route.size] = (-5106, -9342, 5445);
	level.iz_route[level.iz_route.size] = (-4710, -8447, 5329);
	level.iz_route[level.iz_route.size] = (-4494, -7646, 5292);
	level.iz_route[level.iz_route.size] = (-4505, -7240, 5288);
	level.iz_route[level.iz_route.size] = (-4655, -6930, 5269);
	level.iz_route[level.iz_route.size] = (-4907, -6731, 5235);
	level.iz_route[level.iz_route.size] = (-5196, -6664, 5192);
	level.iz_route[level.iz_route.size] = (-5628, -6668, 5129);
	level.iz_route[level.iz_route.size] = (-6601, -6747, 5038);
	level.iz_route[level.iz_route.size] = (-7387, -6860, 5020);
	level.iz_route[level.iz_route.size] = (-8124, -6860, 5002);
	level.iz_route[level.iz_route.size] = (-8795, -6658, 5107);
	level.iz_route[level.iz_route.size] = (-9311, -6382, 5106);
	level.iz_route[level.iz_route.size] = (-9710, -6041, 5121);
	level.iz_route[level.iz_route.size] = (-10023, -5589, 5148);
	level.iz_route[level.iz_route.size] = (-10258, -5079, 5107);
	level.iz_route[level.iz_route.size] = (-10350, -4501, 5124);
	level.iz_route[level.iz_route.size] = (-10294, -3872, 5089);
	level.iz_route[level.iz_route.size] = (-10122, -3189, 5030);
	level.iz_route[level.iz_route.size] = (-9712, -2487, 5059);
	level.iz_route[level.iz_route.size] = (-9252, -2094, 5169);
	level.iz_route[level.iz_route.size] = (-8610, -1777, 5137);
	level.iz_route[level.iz_route.size] = (-7962, -1624, 5097);
	level.iz_route[level.iz_route.size] = (-7409, -1611, 5106);
	level.iz_route[level.iz_route.size] = (-7010, -1365, 5119);
	level.iz_route[level.iz_route.size] = (-6730, -922, 5172);
	level.iz_route[level.iz_route.size] = (-6534, -85, 5329);
	level.iz_route[level.iz_route.size] = (-6155, 388, 5387);
	level.iz_route[level.iz_route.size] = (-5707, 626, 5449);
	level.iz_route[level.iz_route.size] = (-5299, 599, 5520);
	level.iz_route[level.iz_route.size] = (-4936, 413, 5589);
	level.iz_route[level.iz_route.size] = (-4647, 38, 5598);
	level.iz_route[level.iz_route.size] = (-4421, -574, 5535);
	level.iz_route[level.iz_route.size] = (-4162, -1115, 5584);
	level.iz_route[level.iz_route.size] = (-3819, -1755, 5708);
	level.iz_route[level.iz_route.size] = (-3398, -2344, 5757);
	level.iz_route[level.iz_route.size] = (-2920, -2949, 5892);
	level.iz_route[level.iz_route.size] = (-2436, -3322, 6006);
	level.iz_route[level.iz_route.size] = (-1874, -3498, 6038);
	level.iz_route[level.iz_route.size] = (-1307, -3465, 6123);
	level.iz_route[level.iz_route.size] = (-877, -3139, 6215);
	level.iz_route[level.iz_route.size] = (-510, -2716, 6195);
	level.iz_route[level.iz_route.size] = (-96, -2165, 6099);
	level.iz_route[level.iz_route.size] = (267, -1550, 6026);
	level.iz_route[level.iz_route.size] = (565, -978, 5939);
	level.iz_route[level.iz_route.size] = (1044, -181, 5812);
	level.iz_route[level.iz_route.size] = (1958, 1130, 5357);
	level.iz_route[level.iz_route.size] = (2076, 1388, 5280);
	level.iz_route[level.iz_route.size] = (2651, 2608, 5215);
	level.iz_route[level.iz_route.size] = (3955, 5439, 4672);
	level.iz_route[level.iz_route.size] = (4155, 5902, 4309);
	level.iz_route[level.iz_route.size] = (4464, 6528, 4236);
	level.iz_route[level.iz_route.size] = (4704, 7179, 4205);
	level.iz_route[level.iz_route.size] = (4807, 7672, 4196);
	level.iz_route[level.iz_route.size] = (4723, 8104, 4295);
	level.iz_route[level.iz_route.size] = (4566, 8441, 4359);
	level.iz_route[level.iz_route.size] = (4310, 8681, 4367);
	level.iz_route[level.iz_route.size] = (3853, 8787, 4330);
	level.iz_route[level.iz_route.size] = (3313, 8741, 4241);
	level.iz_route[level.iz_route.size] = (2590, 8523, 4121);
	level.iz_route[level.iz_route.size] = (1984, 8205, 4025);
	level.iz_route[level.iz_route.size] = (1487, 7950, 4010);
	level.iz_route[level.iz_route.size] = (876, 7693, 3977);
	level.iz_route[level.iz_route.size] = (253, 7723, 3966);
	level.iz_route[level.iz_route.size] = (-438, 7814, 4021);
	level.iz_route[level.iz_route.size] = (-1091, 7843, 3995);
	level.iz_route[level.iz_route.size] = (-1614, 7760, 3975);
	level.iz_route[level.iz_route.size] = (-2228, 7488, 3961);
	level.iz_route[level.iz_route.size] = (-2742, 7096, 3893);
	level.iz_route[level.iz_route.size] = (-3180, 6651, 3812);
	level.iz_route[level.iz_route.size] = (-3424, 6126, 3739);
	level.iz_route[level.iz_route.size] = (-3560, 5595, 3686);
	level.iz_route[level.iz_route.size] = (-3556, 5099, 3647);
	level.iz_route[level.iz_route.size] = (-3450, 4575, 3616);
	level.iz_route[level.iz_route.size] = (-3190, 4157, 3607);
	level.iz_route[level.iz_route.size] = (-2701, 3781, 3603);
	level.iz_route[level.iz_route.size] = (-1998, 3464, 3600);
	level.iz_route[level.iz_route.size] = (-886, 3163, 3600);
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
	thread iz_obj_3();
	thread iz_obj_4();
	thread iz_obj_5();
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (1808.2008, -8353.3857, 4592.2046);
	angles[0] = (0, 170.5834, 16.2171);
	at[0] = 0;
	points[1] = (1806.0591, -8573.4248, 4642.0474);
	angles[1] = (0, 179.2731, 12.8354);
	at[1] = 0.5000;
	points[2] = (1799.5079, -9653.7012, 4885.0786);
	angles[2] = (0, 179.6526, 12.6783);
	at[2] = 3;
	points[3] = (1719.8347, -9850.4727, 4941.1416);
	angles[3] = (0, 156.6963, 14.8461);
	at[3] = 3.5000;
	points[4] = (1361.4371, -10627.8340, 5169.0156);
	angles[4] = (0, 155.2486, 14.9078);
	at[4] = 5.5000;
	points[5] = (1253.1260, -10810.3154, 5222.4805);
	angles[5] = (0, 142.5237, 13.0811);
	at[5] = 6;
	points[6] = (1101.8190, -10965.5117, 5267.8740);
	angles[6] = (0, 136.0142, 11.8869);
	at[6] = 6.5000;
	points[7] = (647.8859, -11431.1025, 5404.0947);
	angles[7] = (0, 135.7272, 11.8304);
	at[7] = 8;
	points[8] = (468.8858, -11553.8975, 5439.3701);
	angles[8] = (0, 121.8748, 8.5755);
	at[8] = 8.5000;
	points[9] = (-475.0197, -12110.7090, 5597.8345);
	angles[9] = (0, 120.5350, 8.2279);
	at[9] = 11;
	points[10] = (-673.5984, -12203.2285, 5622.8350);
	angles[10] = (0, 112.0199, 5.5599);
	at[10] = 11.5000;
	points[11] = (-2122.0786, -12738.5049, 5757.9922);
	angles[11] = (0, 108.9648, 4.8306);
	at[11] = 15;
	points[12] = (-2337.1694, -12788.8584, 5773.6221);
	angles[12] = (0, 103.4223, 4.0783);
	at[12] = 15.5000;
	points[13] = (-4488.0708, -13292.4404, 5929.8032);
	angles[13] = (0, 103.1770, 4.0441);
	at[13] = 20.5000;
	points[14] = (-4703.4648, -13341.3779, 5940.7871);
	angles[14] = (0, 102.1808, 0.9160);
	at[14] = 21;
	points[15] = (-4920.6299, -13382.5586, 5926.8506);
	angles[15] = (0, 100.8035, -3.4129);
	at[15] = 21.5000;
	points[16] = (-7526.3779, -13876.9297, 5759.7642);
	angles[16] = (0, 100.7424, -3.6046);
	at[16] = 27.5000;
	points[17] = (-7739.2520, -13861.6143, 5743.3071);
	angles[17] = (0, 76.6345, -4.7610);
	at[17] = 28;
	points[18] = (-7947.8745, -13789.8027, 5724.3306);
	angles[18] = (0, 71.2545, -4.9102);
	at[18] = 28.5000;
	points[19] = (-10242.9521, -13000.2754, 5515.5903);
	angles[19] = (0, 71.0161, -4.9158);
	at[19] = 34;
	points[20] = (-10561.4961, -12735.6689, 5449.7637);
	angles[20] = (0, 50.3796, -9.0174);
	at[20] = 34.5000;
	points[21] = (-12216.6543, -11307.7949, 5095.0396);
	angles[21] = (0, 49.2159, -9.2168);
	at[21] = 37;
	points[22] = (-12601.4961, -11138.7793, 5057.5195);
	angles[22] = (0, 76.4449, -2.3867);
	at[22] = 37.5000;
	points[23] = (-13041.6934, -11089.8828, 5054.4487);
	angles[23] = (0, 83.3551, -0.4844);
	at[23] = 38;
	points[24] = (-17003.4258, -10649.8037, 5026.6538);
	angles[24] = (0, 83.6613, -0.3997);
	at[24] = 42.5000;
	points[25] = (-17287.3633, -10772.9531, 5012.0864);
	angles[25] = (0, 142.8569, -4.2492);
	at[25] = 43;
	points[26] = (-17282.2441, -11214.3701, 4976.4175);
	angles[26] = (0, 179.0109, -4.6498);
	at[26] = 43.5000;
	points[27] = (-17185, -19601.7715, 4297.9922);
	angles[27] = (0, 180.6645, -4.6239);
	at[27] = 53;
	points[28] = (-17015.1172, -19892.1660, 4275.7480);
	angles[28] = (0, 236.9072, -2.1761);
	at[28] = 53.5000;
	points[29] = (-16574.1738, -19934.0566, 4275.6299);
	angles[29] = (0, 263.3788, -0.1130);
	at[29] = 54;
	points[30] = (-16133.2676, -19975.9844, 4275.5117);
	angles[30] = (0, 264.5200, -0.0202);
	at[30] = 54.5000;
	points[31] = (10762.8350, -22532.3633, 4267.9136);
	angles[31] = (0, 264.5706, -0.0161);
	at[31] = 85;
	points[32] = (10905.3945, -22222.5586, 4272.0078);
	angles[32] = (0, 344.9275, 0.7237);
	at[32] = 85.5000;
	points[33] = (10935.9062, -21780.7480, 4277.7168);
	angles[33] = (0, 355.5750, 0.7369);
	at[33] = 86;
	points[34] = (11332.7559, -16037.0479, 4351.7720);
	angles[34] = (0, 356.0476, 0.7369);
	at[34] = 92.5000;
	points[35] = (11184.9209, -15864.8037, 4359.9604);
	angles[35] = (0, 399.6431, 2.0508);
	at[35] = 93;
	points[36] = (9566.4570, -14046.2998, 4448.7007);
	angles[36] = (0, 401.6696, 2.0878);
	at[36] = 98.5000;
	points[37] = (9426.6533, -13874.8037, 4456.5747);
	angles[37] = (0, 398.8098, 2.0282);
	at[37] = 99;
	points[38] = (7908.1890, -11971.8896, 4542.5986);
	angles[38] = (0, 398.5886, 2.0234);
	at[38] = 104.5000;
	points[39] = (7780.5117, -11791.8105, 4545.2363);
	angles[39] = (0, 392.3146, -0.5647);
	at[39] = 105;
	points[40] = (7670.3545, -11599.8037, 4539.0947);
	angles[40] = (0, 389.9441, -1.5425);
	at[40] = 105.5000;
	points[41] = (6789.1738, -10063.6221, 4490.0786);
	angles[41] = (0, 389.8390, -1.5858);
	at[41] = 109.5000;
	points[42] = (6709.4487, -9859.6855, 4478.5039);
	angles[42] = (0, 376.8270, -3.7643);
	at[42] = 110;
	points[43] = (6656.6143, -9645.2764, 4462.1260);
	angles[43] = (0, 373.9667, -4.2199);
	at[43] = 110.5000;
	points[44] = (6339.6064, -8358.6221, 4363.8979);
	angles[44] = (0, 373.8400, -4.2398);
	at[44] = 113.5000;
	points[45] = (6301.8110, -8142.7563, 4344.0552);
	angles[45] = (0, 365.2015, -6.2809);
	at[45] = 114;
	points[46] = (6303.0713, -7923.2285, 4315.1182);
	angles[46] = (0, 359.9062, -7.4578);
	at[46] = 114.5000;
	points[47] = (6313.1499, -6166.7720, 4083.5828);
	angles[47] = (0, 360.7380, -7.5358);
	at[47] = 118.5000;
	points[48] = (6272.4019, -5951.0239, 4054.0552);
	angles[48] = (0, 369.9789, -7.6632);
	at[48] = 119;
	points[49] = (6114.0947, -5087.4805, 3935.8977);
	angles[49] = (0, 370.3889, -7.6643);
	at[49] = 121;
	points[50] = (5990.3545, -4914.8423, 3911.1929);
	angles[50] = (0, 401.2078, -6.2233);
	at[50] = 121.5000;
	points[51] = (5835.5518, -4758.1499, 3888.2756);
	angles[51] = (0, 404.5087, -5.9525);
	at[51] = 122;
	points[52] = (5525.9448, -4444.7642, 3842.4409);
	angles[52] = (0, 404.6545, -5.9401);
	at[52] = 123;
	points[53] = (5325.0391, -4463.5825, 3845.0513);
	angles[53] = (0, 461.5330, 1.6316);
	at[53] = 123.5000;
	points[54] = (5112.7559, -4525.9058, 3853.9922);
	angles[54] = (0, 466.1598, 2.2856);
	at[54] = 124;
	points[55] = (4688.1104, -4650.6299, 3871.8782);
	angles[55] = (0, 468.6588, 2.7512);
	at[55] = 125;
	points[56] = (4519.7637, -4792.5986, 3897.0474);
	angles[56] = (0, 488.9885, 6.3361);
	at[56] = 125.5000;
	points[57] = (4013.3860, -5216.0635, 3972.0474);
	angles[57] = (0, 489.9030, 6.4810);
	at[57] = 127;
	points[58] = (3878.6851, -5388.6611, 3999.4094);
	angles[58] = (0, 503.1367, 7.1698);
	at[58] = 127.5000;
	points[59] = (3233.8545, -6278.0317, 4138.2676);
	angles[59] = (0, 504.0562, 7.2039);
	at[59] = 130;
	points[60] = (3084.1221, -6435.3149, 4161.7715);
	angles[60] = (0, 490.1796, 5.2514);
	at[60] = 130.5000;
	points[61] = (2902.5591, -6560.9448, 4178.6616);
	angles[61] = (0, 484.9202, 4.4213);
	at[61] = 131;
	points[62] = (2539.4292, -6812.2837, 4212.5200);
	angles[62] = (0, 484.6880, 4.3837);
	at[62] = 132;
	points[63] = (2363.8110, -6943.4644, 4231.5356);
	angles[63] = (0, 490.3757, 5.9297);
	at[63] = 132.5000;
	points[64] = (2242.2087, -7124.6460, 4269.2915);
	angles[64] = (0, 505.4554, 9.6678);
	at[64] = 133;
	points[65] = (1999.0078, -7487.0078, 4344.8428);
	angles[65] = (0, 506.1323, 9.8204);
	at[65] = 134;
	points[66] = (1919.5315, -7682.0869, 4394.2915);
	angles[66] = (0, 525.3784, 15.0861);
	at[66] = 134.5000;
	points[67] = (1884.7401, -7891.8506, 4456.1416);
	angles[67] = (0, 530.3616, 16.1718);
	at[67] = 135;
	points[68] = (1808.2008, -8353.3857, 4592.2046);
	angles[68] = (0, 530.5834, 16.2171);
	at[68] = 136.1000;
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
	points[0] = (6532.1260, -9139.9219, 4423.5435);
	angles[0] = (0, 13.8400, -4.2398);
	at[0] = 0;
	points[1] = (6320.7876, -8282.1660, 4358.0708);
	angles[1] = (0, 13.8400, -4.2398);
	at[1] = 2;
	points[2] = (6302.2441, -8064.4883, 4333.7402);
	angles[2] = (0, 1.4108, -7.1300);
	at[2] = 2.5000;
	points[3] = (6312.3228, -6308.0713, 4102.2046);
	angles[3] = (0, -0.3289, -7.5085);
	at[3] = 6.5000;
	points[4] = (6297.8740, -6089.9214, 4073.0317);
	angles[4] = (0, 7.3544, -7.6470);
	at[4] = 7;
	points[5] = (6258.2681, -5874.0552, 4043.5042);
	angles[5] = (0, 10.2602, -7.6640);
	at[5] = 7.5000;
	points[6] = (6139.5278, -5226.4175, 3954.9214);
	angles[6] = (0, 10.3889, -7.6643);
	at[6] = 9;
	points[7] = (6090, -5015.6694, 3925.9412);
	angles[7] = (0, 19.4031, -7.4584);
	at[7] = 9.5000;
	points[8] = (5935.1577, -4858.9766, 3903.0237);
	angles[8] = (0, 43.5732, -6.0313);
	at[8] = 10;
	points[9] = (5625.5518, -4545.5908, 3857.1892);
	angles[9] = (0, 44.6529, -5.9402);
	at[9] = 11;
	points[10] = (5461.6533, -4423.4648, 3839.2952);
	angles[10] = (0, 67.9125, -3.1685);
	at[10] = 11.5000;
	points[11] = (5249.3701, -4485.7876, 3848.2402);
	angles[11] = (0, 104.6788, 2.0777);
	at[11] = 12;
	points[12] = (4824.7241, -4610.5117, 3866.1260);
	angles[12] = (0, 106.3617, 2.3138);
	at[12] = 13;
	points[13] = (4628.3857, -4701.7720, 3880.9607);
	angles[13] = (0, 123.1509, 5.3728);
	at[13] = 13.5000;
	points[14] = (4459.6064, -4842.9136, 3905.9568);
	angles[14] = (0, 129.6160, 6.4358);
	at[14] = 14;
	points[15] = (4122.0078, -5125.2363, 3955.9451);
	angles[15] = (0, 129.9026, 6.4810);
	at[15] = 15;
	points[16] = (3961.6536, -5274.2124, 3981.5354);
	angles[16] = (0, 137.2592, 6.9090);
	at[16] = 15.5000;
	points[17] = (3832.7048, -5452.0869, 4009.2913);
	angles[17] = (0, 143.7677, 7.1934);
	at[17] = 16;
	points[18] = (3187.8740, -6341.4565, 4148.1494);
	angles[18] = (0, 144.0562, 7.2039);
	at[18] = 18.5000;
	points[19] = (3019.3896, -6480.1182, 4167.7954);
	angles[19] = (0, 126.4106, 4.6608);
	at[19] = 19;
	points[20] = (2474.6968, -6857.0864, 4218.5825);
	angles[20] = (0, 124.6877, 4.3836);
	at[20] = 20.5000;
	points[21] = (2320.4568, -7008.0713, 4245);
	angles[21] = (0, 141.1309, 8.6595);
	at[21] = 21;
	points[22] = (2198.8542, -7189.2520, 4282.7559);
	angles[22] = (0, 145.9206, 9.7728);
	at[22] = 21.5000;
	points[23] = (1955.6536, -7551.6143, 4358.3071);
	angles[23] = (0, 146.1331, 9.8206);
	at[23] = 22.5000;
	points[24] = (1907.1261, -7756.8896, 4416.3389);
	angles[24] = (0, 168.9431, 15.8753);
	at[24] = 23;
	points[25] = (1837.5433, -8176.4570, 4540.0396);
	angles[25] = (0, 170.5806, 16.2166);
	at[25] = 24;
	points[26] = (1807.1890, -8387.0479, 4600.1577);
	angles[26] = (0, 173.7287, 15.0424);
	at[26] = 24.5000;
	points[27] = (1805.8781, -8603.1104, 4648.7402);
	angles[27] = (0, 179.4036, 12.7815);
	at[27] = 25;
	points[28] = (1799.3268, -9683.3857, 4891.7715);
	angles[28] = (0, 177.2859, 13.0019);
	at[28] = 27.5000;
	points[29] = (1707.5237, -9877.1660, 4948.9370);
	angles[29] = (0, 156.1985, 14.8683);
	at[29] = 28;
	points[30] = (1349.1299, -10654.5273, 5176.8506);
	angles[30] = (0, 155.2486, 14.9078);
	at[30] = 30;
	points[31] = (1232.3386, -10831.6533, 5228.7012);
	angles[31] = (0, 140.1815, 12.6708);
	at[31] = 30.5000;
	points[32] = (1081.0276, -10986.8506, 5274.1338);
	angles[32] = (0, 135.9155, 11.8675);
	at[32] = 31;
	points[33] = (627.0984, -11452.4414, 5410.3149);
	angles[33] = (0, 135.7272, 11.8304);
	at[33] = 32.5000;
	points[34] = (442.9528, -11569.2129, 5443.7012);
	angles[34] = (0, 121.4139, 8.4565);
	at[34] = 33;
	points[35] = (-500.9528, -12125.9844, 5602.1655);
	angles[35] = (0, 120.5350, 8.2279);
	at[35] = 35.5000;
	points[36] = (-702.0236, -12213.7803, 5625.4722);
	angles[36] = (0, 111.4355, 5.3706);
	at[36] = 36;
	points[37] = (-1943.2992, -12673.4648, 5741.4565);
	angles[37] = (0, 110.3214, 5.0078);
	at[37] = 39;
	points[38] = (-2151.6301, -12745.4336, 5760.1577);
	angles[38] = (0, 106.9745, 4.5654);
	at[38] = 39.5000;
	points[39] = (-2366.7166, -12795.7871, 5775.7480);
	angles[39] = (0, 103.3380, 4.0665);
	at[39] = 40;
	points[40] = (-4517.5986, -13299.3701, 5931.9292);
	angles[40] = (0, 103.1770, 4.0441);
	at[40] = 45;
	points[41] = (-4733.3071, -13347.0479, 5938.8584);
	angles[41] = (0, 101.6868, -0.6379);
	at[41] = 45.5000;
	points[42] = (-4950.4722, -13388.2285, 5924.9214);
	angles[42] = (0, 100.7825, -3.4788);
	at[42] = 46;
	points[43] = (-7556.1812, -13882.5986, 5757.8740);
	angles[43] = (0, 100.7424, -3.6046);
	at[43] = 52;
	points[44] = (-7767.9131, -13851.7334, 5740.7085);
	angles[44] = (0, 74.7041, -4.8194);
	at[44] = 52.5000;
	points[45] = (-7976.5747, -13779.9600, 5721.7324);
	angles[45] = (0, 71.1725, -4.9121);
	at[45] = 53;
	points[46] = (-10062.9922, -13062.2051, 5531.9683);
	angles[46] = (0, 71.0161, -4.9158);
	at[46] = 58;
	points[47] = (-10278.4648, -12979.8818, 5510.4331);
	angles[47] = (0, 66.9673, -5.7935);
	at[47] = 58.5000;
	points[48] = (-10609.4883, -12694.2910, 5439.4878);
	angles[48] = (0, 49.9795, -9.0864);
	at[48] = 59;
	points[49] = (-12264.6455, -11266.3779, 5084.7637);
	angles[49] = (0, 49.2159, -9.2168);
	at[49] = 61.5000;
	points[50] = (-12665.2754, -11131.6924, 5057.0864);
	angles[50] = (0, 79.3982, -1.5767);
	at[50] = 62;
	points[51] = (-13105.4727, -11082.7949, 5054.0156);
	angles[51] = (0, 83.4804, -0.4497);
	at[51] = 62.5000;
	points[52] = (-17067.2051, -10642.7168, 5026.1812);
	angles[52] = (0, 83.6613, -0.3997);
	at[52] = 67;
	points[53] = (-17286.6543, -10836.9287, 5006.9292);
	angles[53] = (0, 155.4153, -4.5959);
	at[53] = 67.5000;
	points[54] = (-17281.5352, -11278.3467, 4971.2202);
	angles[54] = (0, 179.5796, -4.6413);
	at[54] = 68;
	points[55] = (-17184.2520, -19665.7480, 4292.8350);
	angles[55] = (0, 180.6645, -4.6239);
	at[55] = 77.5000;
	points[56] = (-16951.2207, -19898.2285, 4275.7480);
	angles[56] = (0, 246.2537, -1.4790);
	at[56] = 78;
	points[57] = (-16510.2754, -19940.1582, 4275.5903);
	angles[57] = (0, 263.7886, -0.0797);
	at[57] = 78.5000;
	points[58] = (-16069.3701, -19982.0469, 4275.4727);
	angles[58] = (0, 264.5373, -0.0188);
	at[58] = 79;
	points[59] = (10826.7715, -22538.4258, 4267.8740);
	angles[59] = (0, 264.5706, -0.0161);
	at[59] = 109.5000;
	points[60] = (10909.8037, -22158.5449, 4272.8345);
	angles[60] = (0, 349.4699, 0.7324);
	at[60] = 110;
	points[61] = (10940.3545, -21716.6934, 4278.5435);
	angles[61] = (0, 355.7685, 0.7369);
	at[61] = 110.5000;
	points[62] = (11306.6533, -16414.8438, 4346.8901);
	angles[62] = (0, 356.0476, 0.7369);
	at[62] = 116.5000;
	points[63] = (11309.0557, -16004.2119, 4353.1494);
	angles[63] = (0, 370.9492, 1.2780);
	at[63] = 117;
	points[64] = (11161.8896, -15838.8984, 4361.2207);
	angles[64] = (0, 400.3399, 2.0638);
	at[64] = 117.5000;
	points[65] = (9543.4258, -14020.4326, 4449.9604);
	angles[65] = (0, 401.6696, 2.0878);
	at[65] = 123;
	points[66] = (9405.0391, -13847.7168, 4457.7954);
	angles[66] = (0, 398.7338, 2.0265);
	at[66] = 123.5000;
	points[67] = (7886.5747, -11944.8037, 4543.8188);
	angles[67] = (0, 398.5886, 2.0234);
	at[67] = 129;
	points[68] = (7763.2676, -11761.7715, 4544.2520);
	angles[68] = (0, 391.4636, -0.9160);
	at[68] = 129.5000;
	points[69] = (6771.9292, -10033.5439, 4489.0947);
	angles[69] = (0, 389.8390, -1.5858);
	at[69] = 134;
	points[70] = (6701.1816, -9826.1416, 4475.9448);
	angles[70] = (0, 375.6045, -3.9603);
	at[70] = 134.5000;
	points[71] = (6532.1260, -9139.9219, 4423.5435);
	angles[71] = (0, 373.8400, -4.2398);
	at[71] = 136.1000;
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
	points[0] = (-7349.7246, 2804.9448, 3314.7993);
	angles[0] = (0, -77.8666, 0.8483);
	at[0] = 0;
	points[1] = (-7224.8428, 2811.9766, 3324.8899);
	angles[1] = (0, -85.2845, 3.9894);
	at[1] = 0.2833;
	points[2] = (-7099.9609, 2819.0078, 3334.9844);
	angles[2] = (0, -86.5287, 4.5094);
	at[2] = 0.5667;
	points[3] = (-6225.7480, 2868.2205, 3405.6377);
	angles[3] = (0, -86.7779, 4.6132);
	at[3] = 2.5500;
	points[4] = (-6102.5195, 2859.5906, 3412.5630);
	angles[4] = (0, -96.9837, 2.6129);
	at[4] = 2.8333;
	points[5] = (-5982.1655, 2824.0986, 3414.0513);
	angles[5] = (0, -104.8531, 1.0061);
	at[5] = 3.1167;
	points[6] = (-5500.7090, 2682.1260, 3420.0120);
	angles[6] = (0, -107.0298, 0.6130);
	at[6] = 4.2500;
	points[7] = (-5268.7793, 2586.1731, 3419.9961);
	angles[7] = (0, -112.2924, 0.0171);
	at[7] = 4.8167;
	points[8] = (-4572.8740, 2298.7244, 3419.9961);
	angles[8] = (0, -112.5201, 0);
	at[8] = 6.5167;
	points[9] = (-3419.5354, 1804.0946, 3419.9961);
	angles[9] = (0, -113.2127, 0);
	at[9] = 9.3500;
	points[10] = (-3181.4688, 1724.8503, 3420.0198);
	angles[10] = (0, -108.1757, 0.0053);
	at[10] = 9.9167;
	points[11] = (-2346.0039, 1453.4487, 3420.1023);
	angles[11] = (0, -107.9965, 0.0055);
	at[11] = 11.9000;
	points[12] = (-1022.2599, 1062.0552, 3421.4333);
	angles[12] = (0, -106.4036, 0.0574);
	at[12] = 15.0167;
	points[13] = (-903.7441, 1022.0433, 3421.3230);
	angles[13] = (0, -110.3912, -0.1338);
	at[13] = 15.3000;
	points[14] = (-792.9843, 963.0630, 3420.2324);
	angles[14] = (0, -116.7594, -0.4374);
	at[14] = 15.5833;
	points[15] = (-349.9343, 727.1339, 3415.8740);
	angles[15] = (0, -118.0349, -0.4977);
	at[15] = 16.7167;
	points[16] = (-250.9323, 655.4488, 3418.5120);
	angles[16] = (0, -129.4582, 2.0136);
	at[16] = 17;
	points[17] = (-181.9815, 551.3071, 3430.6851);
	angles[17] = (0, -143.6230, 4.9954);
	at[17] = 17.2833;
	points[18] = (-44.0799, 343.0189, 3455.0237);
	angles[18] = (0, -146.4126, 5.5498);
	at[18] = 17.8500;
	points[19] = (6.9044, 230.7768, 3466.6299);
	angles[19] = (0, -157.9454, 5.3040);
	at[19] = 18.1333;
	points[20] = (38.6674, 109.8705, 3477.6340);
	angles[20] = (0, -164.0563, 5.0813);
	at[20] = 18.4167;
	points[21] = (102.1933, -131.9417, 3499.6379);
	angles[21] = (0, -165.2466, 5.0312);
	at[21] = 18.9833;
	points[22] = (123.2598, -254.6043, 3507.7676);
	angles[22] = (0, -171.8244, 3.3215);
	at[22] = 19.2667;
	points[23] = (127.9740, -379.9524, 3511.5078);
	angles[23] = (0, -176.8421, 1.9790);
	at[23] = 19.5500;
	points[24] = (151.5445, -1006.6929, 3530.2085);
	angles[24] = (0, -177.8461, 1.7079);
	at[24] = 20.9667;
	points[25] = (161.7437, -1131.1102, 3537.5471);
	angles[25] = (0, -174.1991, 4.0901);
	at[25] = 21.2500;
	points[26] = (185.7433, -1253.1890, 3553.9412);
	angles[26] = (0, -169.7711, 6.9399);
	at[26] = 21.5333;
	points[27] = (257.7421, -1619.4291, 3603.1221);
	angles[27] = (0, -168.8823, 7.5038);
	at[27] = 22.3833;
	points[28] = (292.1768, -1738.9449, 3614.6182);
	angles[28] = (0, -162.6653, 4.7027);
	at[28] = 22.6667;
	points[29] = (337.6051, -1855.7521, 3620.9526);
	angles[29] = (0, -159.4008, 3.1963);
	at[29] = 22.9500;
	points[30] = (428.4606, -2089.3701, 3633.6221);
	angles[30] = (0, -158.7665, 2.9017);
	at[30] = 23.5167;
	points[31] = (484.4252, -2201.1338, 3639.5906);
	angles[31] = (0, -152.6683, 2.7114);
	at[31] = 23.8000;
	points[32] = (547.3347, -2309.5669, 3645.3152);
	angles[32] = (0, -150.3433, 2.6321);
	at[32] = 24.0833;
	points[33] = (736.0709, -2634.8623, 3662.4961);
	angles[33] = (0, -149.8800, 2.6158);
	at[33] = 24.9333;
	points[34] = (911.5000, -2967.4292, 3680.6653);
	angles[34] = (0, -152.4748, 2.7849);
	at[34] = 25.7833;
	points[35] = (1068.5748, -3308.9568, 3700.0513);
	angles[35] = (0, -155.6256, 2.9708);
	at[35] = 26.6333;
	points[36] = (1119.1143, -3423.0159, 3712.7244);
	angles[36] = (0, -156.1474, 6.1047);
	at[36] = 26.9167;
	points[37] = (1218.7953, -3650.9922, 3745.6499);
	angles[37] = (0, -156.3761, 7.4984);
	at[37] = 27.4833;
	points[38] = (1233.1300, -3772.8662, 3759.4409);
	angles[38] = (0, -173.6026, 6.3796);
	at[38] = 27.7667;
	points[39] = (1234.1378, -3897.7009, 3772.2322);
	angles[39] = (0, -178.5475, 5.9426);
	at[39] = 28.0500;
	points[40] = (1235.1456, -4022.5195, 3785.0237);
	angles[40] = (0, -179.3721, 5.8653);
	at[40] = 28.3333;
	points[41] = (1223.5906, -4144.6851, 3799.4961);
	angles[41] = (0, -188.7889, 7.2084);
	at[41] = 28.6167;
	points[42] = (1176.0630, -4259.2124, 3818.7952);
	angles[42] = (0, -200.2277, 8.6046);
	at[42] = 28.9000;
	points[43] = (1081.0078, -4488.3071, 3857.3938);
	angles[43] = (0, -202.4729, 8.8396);
	at[43] = 29.4667;
	points[44] = (1028.4094, -4599.7246, 3877.3347);
	angles[44] = (0, -206.7261, 9.3692);
	at[44] = 29.7500;
	points[45] = (952.1181, -4696.6929, 3900.2795);
	angles[45] = (0, -216.2717, 10.3678);
	at[45] = 30.0333;
	points[46] = (799.5433, -4890.6299, 3946.1812);
	angles[46] = (0, -218.1414, 10.5305);
	at[46] = 30.6000;
	points[47] = (717.7835, -4982.0474, 3969.6851);
	angles[47] = (0, -223.3566, 10.9775);
	at[47] = 30.8833;
	points[48] = (622.3583, -5059.6455, 3994.6062);
	angles[48] = (0, -229.6269, 11.3963);
	at[48] = 31.1667;
	points[49] = (431.5079, -5214.8027, 4044.5278);
	angles[49] = (0, -230.8504, 11.4626);
	at[49] = 31.7333;
	points[50] = (332.5008, -5286.9292, 4069.7246);
	angles[50] = (0, -235.2037, 11.6940);
	at[50] = 32.0167;
	points[51] = (224.6130, -5345.5908, 4095.6299);
	angles[51] = (0, -240.4302, 11.8849);
	at[51] = 32.3000;
	points[52] = (-206.9366, -5580.1182, 4199.2520);
	angles[52] = (0, -241.4773, 11.9116);
	at[52] = 33.4333;
	points[53] = (-318.0284, -5631.5356, 4224.7637);
	angles[53] = (0, -246.8337, 11.7031);
	at[53] = 33.7167;
	points[54] = (-434.8465, -5670.0396, 4249.6064);
	angles[54] = (0, -250.9314, 11.4761);
	at[54] = 34;
	points[55] = (-902.1260, -5824.1338, 4349.0552);
	angles[55] = (0, -251.7505, 11.4237);
	at[55] = 35.1333;
	points[56] = (-1022.5748, -5849.0552, 4371.1812);
	angles[56] = (0, -259.0552, 10.0564);
	at[56] = 35.4167;
	points[57] = (-1145.2992, -5865.4331, 4391.6143);
	angles[57] = (0, -261.8300, 9.4904);
	at[57] = 35.7000;
	points[58] = (-1636.1968, -5931.1021, 4473.3857);
	angles[58] = (0, -262.3839, 9.3746);
	at[58] = 36.8333;
	points[59] = (-1759.3820, -5942.7168, 4492.2046);
	angles[59] = (0, -266.2516, 8.1080);
	at[59] = 37.1167;
	points[60] = (-1884.0748, -5938.7798, 4505.7876);
	angles[60] = (0, -270.8804, 6.5341);
	at[60] = 37.4000;
	points[61] = (-2507.5435, -5919.1338, 4573.7007);
	angles[61] = (0, -271.8038, 6.2134);
	at[61] = 38.8167;
	points[62] = (-2631.9844, -5911.8901, 4577.5591);
	angles[62] = (0, -273.8316, 0.2989);
	at[62] = 39.1000;
	points[63] = (-2755.9646, -5898.5435, 4563.4648);
	angles[63] = (0, -275.7562, -5.3228);
	at[63] = 39.3833;
	points[64] = (-3375.8740, -5831.8115, 4492.9922);
	angles[64] = (0, -276.1448, -6.4487);
	at[64] = 40.8000;
	points[65] = (-3492.2954, -5796.8110, 4461.9292);
	angles[65] = (0, -284.9803, -13.0787);
	at[65] = 41.0833;
	points[66] = (-3957.7559, -5656.2207, 4337.2837);
	angles[66] = (0, -286.8046, -14.3781);
	at[66] = 42.2167;
	points[67] = (-4069.9214, -5611.6929, 4305.4331);
	angles[67] = (0, -293.6025, -14.9087);
	at[67] = 42.5000;
	points[68] = (-4174.8818, -5551.3384, 4272.5200);
	angles[68] = (0, -298.8396, -15.1793);
	at[68] = 42.7833;
	points[69] = (-4699.8032, -5249.6460, 4107.7954);
	angles[69] = (0, -300.3969, -15.0522);
	at[69] = 44.2000;
	points[70] = (-4939.8428, -5081.7715, 4037.5591);
	angles[70] = (0, -304.8025, -13.5444);
	at[70] = 44.7667;
	points[71] = (-5660.1577, -4578.7402, 3826.6143);
	angles[71] = (0, -304.9278, -13.5000);
	at[71] = 46.4667;
	points[72] = (-5773.3071, -4484.6064, 3798.5750);
	angles[72] = (0, -311.0794, -10.0197);
	at[72] = 46.7500;
	points[73] = (-5878.9766, -4379.2520, 3778.2678);
	angles[73] = (0, -314.2768, -8.1314);
	at[73] = 47.0333;
	points[74] = (-6512.9917, -3747.1616, 3656.4214);
	angles[74] = (0, -314.9131, -7.7501);
	at[74] = 48.7333;
	points[75] = (-6614.7246, -3637.8857, 3638.6301);
	angles[75] = (0, -317.9714, -6.3856);
	at[75] = 49.0167;
	points[76] = (-6801.8506, -3403.2520, 3613.3542);
	angles[76] = (0, -321.3304, -4.8580);
	at[76] = 49.5833;
	points[77] = (-7737.6377, -2230.2166, 3486.8662);
	angles[77] = (0, -321.2949, -4.8827);
	at[77] = 52.4167;
	points[78] = (-9718.3076, 219.5638, 3210.4883);
	angles[78] = (0, -321.0442, -5.0137);
	at[78] = 58.3667;
	points[79] = (-9804.8428, 342.2732, 3212.2400);
	angles[79] = (0, -324.9932, 0.9419);
	at[79] = 58.6500;
	points[80] = (-9971.5352, 592.6221, 3227.8818);
	angles[80] = (0, -326.3036, 2.9205);
	at[80] = 59.2167;
	points[81] = (-10040.5117, 724.4488, 3236.3503);
	angles[81] = (0, -334.4399, 3.3372);
	at[81] = 59.5000;
	points[82] = (-10082.5986, 868.7165, 3246.0356);
	angles[82] = (0, -342.1841, 3.6357);
	at[82] = 59.7833;
	points[83] = (-10166.7715, 1157.2480, 3265.4094);
	angles[83] = (0, -347.8904, 3.7280);
	at[83] = 60.3500;
	points[84] = (-10091.0625, 1288.3503, 3273.5000);
	angles[84] = (0, -381.9785, 3.3321);
	at[84] = 60.6333;
	points[85] = (-10017.9141, 1419.7402, 3281.6223);
	angles[85] = (0, -387.9111, 3.1359);
	at[85] = 60.9167;
	points[86] = (-9934.2520, 1543.8032, 3289.2126);
	angles[86] = (0, -395.4961, 2.8410);
	at[86] = 61.2000;
	points[87] = (-9836.1416, 1657.8544, 3296.0669);
	angles[87] = (0, -399.8314, 2.6500);
	at[87] = 61.4833;
	points[88] = (-9639.9609, 1885.9568, 3309.7834);
	angles[88] = (0, -400.6753, 2.6110);
	at[88] = 62.0500;
	points[89] = (-9514.5674, 1967.4567, 3312.7913);
	angles[89] = (0, -415.7268, 1.2686);
	at[89] = 62.3333;
	points[90] = (-9384.6064, 2043.5079, 3315.1538);
	angles[90] = (0, -419.0054, 0.9610);
	at[90] = 62.6167;
	points[91] = (-8734.8428, 2423.7834, 3326.9685);
	angles[91] = (0, -419.6616, 0.8990);
	at[91] = 64.0333;
	points[92] = (-8612.0479, 2460.3267, 3325.9844);
	angles[92] = (0, -431.8058, -0.2819);
	at[92] = 64.3167;
	points[93] = (-8491.0635, 2493.6851, 3324.7717);
	angles[93] = (0, -434.1205, -0.5072);
	at[93] = 64.6000;
	points[94] = (-7402.3228, 2793.9055, 3313.8896);
	angles[94] = (0, -434.5836, -0.5522);
	at[94] = 67.1500;
	points[95] = (-7349.7246, 2804.9448, 3314.7993);
	angles[95] = (0, -437.8666, 0.8483);
	at[95] = 67.2833;
	mover = getEnt("iz_obj_2", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_3()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (348.5925, -5278.1890, 4065.8662);
	angles[0] = (0, 126.2631, 11.6232);
	at[0] = 0;
	points[1] = (240.7051, -5336.8506, 4091.7717);
	angles[1] = (0, 119.8155, 11.8781);
	at[1] = 0.2833;
	points[2] = (-190.8449, -5571.3779, 4195.3940);
	angles[2] = (0, 118.5229, 11.9116);
	at[2] = 1.4167;
	points[3] = (-300.6043, -5625.7876, 4221.0630);
	angles[3] = (0, 114.9936, 11.7856);
	at[3] = 1.7000;
	points[4] = (-417.4252, -5664.2915, 4245.9058);
	angles[4] = (0, 109.3735, 11.4949);
	at[4] = 1.9833;
	points[5] = (-884.7007, -5818.3862, 4345.3545);
	angles[5] = (0, 108.2498, 11.4238);
	at[5] = 3.1167;
	points[6] = (-1004.2716, -5846.6143, 4368.1494);
	angles[6] = (0, 102.1850, 10.3013);
	at[6] = 3.4000;
	points[7] = (-1126.9961, -5862.9922, 4388.5830);
	angles[7] = (0, 98.3763, 9.5333);
	at[7] = 3.6833;
	points[8] = (-1740.7834, -5943.3076, 4490.1968);
	angles[8] = (0, 95.8201, 8.7924);
	at[8] = 5.1000;
	points[9] = (-1865.4763, -5939.3701, 4503.7798);
	angles[9] = (0, 89.4632, 6.6528);
	at[9] = 5.3833;
	points[10] = (-2488.9448, -5919.7241, 4571.6929);
	angles[10] = (0, 88.1962, 6.2134);
	at[10] = 6.8000;
	points[11] = (-2613.4922, -5913.8975, 4579.6455);
	angles[11] = (0, 86.7074, 1.8773);
	at[11] = 7.0833;
	points[12] = (-2737.4724, -5900.5508, 4565.5513);
	angles[12] = (0, 84.3348, -5.0586);
	at[12] = 7.3667;
	points[13] = (-3357.3818, -5833.8188, 4495.0791);
	angles[13] = (0, 83.8552, -6.4487);
	at[13] = 8.7833;
	points[14] = (-3474.9409, -5802.0469, 4466.5747);
	angles[14] = (0, 75.4449, -12.7719);
	at[14] = 9.0667;
	points[15] = (-3940.4331, -5661.4565, 4341.9292);
	angles[15] = (0, 73.1957, -14.3779);
	at[15] = 10.2000;
	points[16] = (-4054.2520, -5620.7090, 4310.3545);
	angles[16] = (0, 68.7234, -14.7498);
	at[16] = 10.4833;
	points[17] = (-4159.2124, -5560.3545, 4277.4019);
	angles[17] = (0, 61.5508, -15.1633);
	at[17] = 10.7667;
	points[18] = (-4684.1338, -5258.6221, 4112.7163);
	angles[18] = (0, 60.1099, -15.2190);
	at[18] = 12.1833;
	points[19] = (-4801.2993, -5178.5039, 4078.1104);
	angles[19] = (0, 56.1036, -13.8627);
	at[19] = 12.4667;
	points[20] = (-5641.6929, -4591.6533, 3832.0195);
	angles[20] = (0, 55.0722, -13.5000);
	at[20] = 14.4500;
	points[21] = (-5757.0474, -4500.8267, 3801.6931);
	angles[21] = (0, 50.3568, -10.8515);
	at[21] = 14.7333;
	points[22] = (-5862.7559, -4395.4722, 3781.3860);
	angles[22] = (0, 45.9602, -8.2728);
	at[22] = 15.0167;
	points[23] = (-6496.7720, -3763.3545, 3659.5435);
	angles[23] = (0, 45.0869, -7.7501);
	at[23] = 16.7167;
	points[24] = (-6600.3149, -3655.9172, 3640.5708);
	angles[24] = (0, 43.3167, -6.9637);
	at[24] = 17;
	points[25] = (-6787.4409, -3421.2834, 3615.2952);
	angles[25] = (0, 38.7052, -4.8743);
	at[25] = 17.5667;
	points[26] = (-7723.1108, -2248.1104, 3488.9172);
	angles[26] = (0, 38.6119, -4.8340);
	at[26] = 20.4000;
	points[27] = (-9703.8193, 201.6331, 3212.5120);
	angles[27] = (0, 38.9558, -5.0137);
	at[27] = 26.3500;
	points[28] = (-9792.0078, 323.0331, 3211.0356);
	angles[28] = (0, 35.5071, 0.1855);
	at[28] = 26.6333;
	points[29] = (-9958.7402, 573.3859, 3226.6772);
	angles[29] = (0, 33.7104, 2.8995);
	at[29] = 27.2000;
	points[30] = (-10034.0557, 702.2756, 3234.8621);
	angles[30] = (0, 27.7299, 3.2411);
	at[30] = 27.4833;
	points[31] = (-10076.1416, 846.5394, 3244.5474);
	angles[31] = (0, 18.1805, 3.6229);
	at[31] = 27.7667;
	points[32] = (-10160.2764, 1135.0708, 3263.9214);
	angles[32] = (0, 16.3154, 3.6860);
	at[32] = 28.3333;
	points[33] = (-10102.2832, 1268.1536, 3272.2480);
	angles[33] = (0, -19.3408, 3.4080);
	at[33] = 28.6167;
	points[34] = (-10029.1729, 1399.5433, 3280.3743);
	angles[34] = (0, -27.4694, 3.1517);
	at[34] = 28.9000;
	points[35] = (-9949.3311, 1526.2755, 3288.1577);
	angles[35] = (0, -33.5649, 2.9209);
	at[35] = 29.1833;
	points[36] = (-9851.2207, 1640.3229, 3295.0156);
	angles[36] = (0, -39.5087, 2.6648);
	at[36] = 29.4667;
	points[37] = (-9655.0400, 1868.4252, 3308.7285);
	angles[37] = (0, -40.6664, 2.6115);
	at[37] = 30.0333;
	points[38] = (-9534.5273, 1955.7638, 3312.4250);
	angles[38] = (0, -54.2655, 1.4044);
	at[38] = 30.3167;
	points[39] = (-9404.6064, 2031.8190, 3314.7915);
	angles[39] = (0, -58.7612, 0.9840);
	at[39] = 30.6000;
	points[40] = (-8754.8428, 2412.0906, 3326.6023);
	angles[40] = (0, -59.6616, 0.8990);
	at[40] = 32.0167;
	points[41] = (-8631.5352, 2454.9568, 3326.1772);
	angles[41] = (0, -71.1545, -0.2184);
	at[41] = 32.3000;
	points[42] = (-8510.5508, 2488.3149, 3324.9685);
	angles[42] = (0, -74.0117, -0.4966);
	at[42] = 32.5833;
	points[43] = (-7421.8115, 2788.5396, 3314.0825);
	angles[43] = (0, -74.5836, -0.5522);
	at[43] = 35.1333;
	points[44] = (-7298.7402, 2807.8149, 3318.9172);
	angles[44] = (0, -82.5021, 2.8180);
	at[44] = 35.4167;
	points[45] = (-7048.9766, 2821.8779, 3339.1064);
	angles[45] = (0, -86.6587, 4.5636);
	at[45] = 35.9833;
	points[46] = (-6174.7642, 2871.0906, 3409.7561);
	angles[46] = (0, -86.7779, 4.6132);
	at[46] = 37.9667;
	points[47] = (-6053.3857, 2845.1025, 3413.1694);
	angles[47] = (0, -101.9075, 1.6117);
	at[47] = 38.2500;
	points[48] = (-5933.0317, 2809.6101, 3414.6614);
	angles[48] = (0, -105.6761, 0.8363);
	at[48] = 38.5333;
	points[49] = (-5571.9287, 2703.1299, 3419.1301);
	angles[49] = (0, -106.4270, 0.6812);
	at[49] = 39.3833;
	points[50] = (-5453.4253, 2662.4331, 3419.9961);
	angles[50] = (0, -109.8526, 0.2937);
	at[50] = 39.6667;
	points[51] = (-4525.7876, 2278.5237, 3419.9961);
	angles[51] = (0, -112.8814, 0);
	at[51] = 41.9333;
	points[52] = (-3487.7874, 1833.3623, 3419.9961);
	angles[52] = (0, -113.2127, 0);
	at[52] = 44.4833;
	points[53] = (-3371.4490, 1786.5669, 3420);
	angles[53] = (0, -111.0777, 0.0023);
	at[53] = 44.7667;
	points[54] = (-3132.7441, 1709.0236, 3420.0237);
	angles[54] = (0, -108.0821, 0.0054);
	at[54] = 45.3333;
	points[55] = (-2297.2795, 1437.6219, 3420.1101);
	angles[55] = (0, -107.9965, 0.0055);
	at[55] = 47.3167;
	points[56] = (-973.1142, 1047.5906, 3421.4844);
	angles[56] = (0, -106.4036, 0.0574);
	at[56] = 50.4333;
	points[57] = (-858.5276, 997.9646, 3420.8779);
	angles[57] = (0, -114.3759, -0.3242);
	at[57] = 50.7167;
	points[58] = (-747.7638, 938.9843, 3419.7876);
	angles[58] = (0, -117.4252, -0.4689);
	at[58] = 51;
	points[59] = (-304.7166, 703.0551, 3415.4292);
	angles[59] = (0, -118.0353, -0.4977);
	at[59] = 52.1333;
	points[60] = (-222.7835, 612.9330, 3423.4802);
	angles[60] = (0, -138.2867, 3.9005);
	at[60] = 52.4167;
	points[61] = (-153.8327, 508.7914, 3435.6536);
	angles[61] = (0, -145.1192, 5.2944);
	at[61] = 52.7000;
	points[62] = (-15.9311, 300.5031, 3459.9919);
	angles[62] = (0, -146.4542, 5.5580);
	at[62] = 53.2667;
	points[63] = (19.8715, 181.4177, 3471.1218);
	angles[63] = (0, -161.7699, 5.1716);
	at[63] = 53.5500;
	points[64] = (115.1602, -181.3008, 3504.1299);
	angles[64] = (0, -165.2643, 5.0304);
	at[64] = 54.4000;
	points[65] = (125.1843, -305.7768, 3509.2954);
	angles[65] = (0, -174.9660, 2.4836);
	at[65] = 54.6833;
	points[66] = (129.8984, -431.1260, 3513.0356);
	angles[66] = (0, -177.3660, 1.8376);
	at[66] = 54.9667;
	points[67] = (153.4689, -1057.8622, 3531.7363);
	angles[67] = (0, -177.8462, 1.7079);
	at[67] = 56.3833;
	points[68] = (171.5414, -1180.9489, 3544.2400);
	angles[68] = (0, -171.4329, 5.8776);
	at[68] = 56.6667;
	points[69] = (195.5410, -1303.0276, 3560.6340);
	angles[69] = (0, -169.3055, 7.2357);
	at[69] = 56.9500;
	points[70] = (267.5398, -1669.2677, 3609.8149);
	angles[70] = (0, -168.8801, 7.5052);
	at[70] = 57.8000;
	points[71] = (310.7224, -1786.6300, 3617.2048);
	angles[71] = (0, -160.6203, 3.7611);
	at[71] = 58.0833;
	points[72] = (447.0079, -2137.0591, 3636.2046);
	angles[72] = (0, -157.8724, 2.8726);
	at[72] = 58.9333;
	points[73] = (510.1063, -2245.4016, 3641.9250);
	angles[73] = (0, -151.2126, 2.6623);
	at[73] = 59.2167;
	points[74] = (761.7559, -2679.1299, 3664.8347);
	angles[74] = (0, -150.1406, 2.6330);
	at[74] = 60.3500;
	points[75] = (934.6575, -3013.0435, 3683.1890);
	angles[75] = (0, -153.0836, 2.8215);
	at[75] = 61.2000;
	points[76] = (1089.6693, -3355.5708, 3702.7085);
	angles[76] = (0, -155.7113, 3.4279);
	at[76] = 62.0500;
	points[77] = (1189.3031, -3583.5393, 3735.9094);
	angles[77] = (0, -156.3638, 7.4240);
	at[77] = 62.6167;
	points[78] = (1232.5315, -3698.9961, 3751.8740);
	angles[78] = (0, -162.5790, 7.1778);
	at[78] = 62.9000;
	points[79] = (1233.5394, -3823.8306, 3764.6653);
	angles[79] = (0, -176.6985, 6.1114);
	at[79] = 63.1833;
	points[80] = (1235.5591, -4073.5042, 3790.2441);
	angles[80] = (0, -179.4582, 5.8572);
	at[80] = 63.7500;
	points[81] = (1204.1851, -4191.4565, 3807.3740);
	angles[81] = (0, -195.9270, 8.1177);
	at[81] = 64.0333;
	points[82] = (1156.6575, -4305.9844, 3826.6733);
	angles[82] = (0, -201.4321, 8.7323);
	at[82] = 64.3167;
	points[83] = (1061.6063, -4535.0396, 3865.2717);
	angles[83] = (0, -202.5065, 8.8430);
	at[83] = 64.8833;
	points[84] = (997.2638, -4639.2915, 3886.7007);
	angles[84] = (0, -212.6875, 10.0253);
	at[84] = 65.1667;
	points[85] = (920.9764, -4736.2598, 3909.6458);
	angles[85] = (0, -217.2747, 10.4565);
	at[85] = 65.4500;
	points[86] = (768.3976, -4930.1968, 3955.5513);
	angles[86] = (0, -218.1693, 10.5329);
	at[86] = 66.0167;
	points[87] = (678.8268, -5013.7007, 3979.8818);
	angles[87] = (0, -227.2780, 11.2549);
	at[87] = 66.3000;
	points[88] = (392.5516, -5246.4961, 4054.6851);
	angles[88] = (0, -230.8687, 11.4635);
	at[88] = 67.1500;
	points[89] = (348.5925, -5278.1890, 4065.8662);
	angles[89] = (0, -233.7368, 11.6232);
	at[89] = 67.2833;
	mover = getEnt("iz_obj_3", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_4()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-2328.6772, 6986.2603, 3860.5945);
	angles[0] = (0, 60.6333, 0);
	at[0] = 0;
	points[1] = (-2334.0984, 6991.8506, 3861.9448);
	angles[1] = (0, 48.3881, 0);
	at[1] = 0.0667;
	points[2] = (-2351.3032, 7009.6064, 3866.2285);
	angles[2] = (0, 44.3907, 0);
	at[2] = 0.2667;
	points[3] = (-2785.0393, 7457.3628, 3974.2126);
	angles[3] = (0, 44.0528, 0);
	at[3] = 5.3333;
	points[4] = (-2806.0237, 7479.0552, 3979.4490);
	angles[4] = (0, 44.0307, 0);
	at[4] = 5.6000;
	points[5] = (-2819.5237, 7493.0317, 3982.7954);
	angles[5] = (0, 44.0039, 0);
	at[5] = 5.7333;
	points[6] = (-2851.0708, 7526.1021, 3990.7480);
	angles[6] = (0, 43.1446, 0);
	at[6] = 6.1333;
	points[7] = (-2856.6182, 7532.4805, 3992.2834);
	angles[7] = (0, 40.7122, 0);
	at[7] = 6.2000;
	points[8] = (-2851.2637, 7528.3857, 3991.2205);
	angles[8] = (0, 20.3784, 0);
	at[8] = 6.2667;
	points[9] = (-2844.9763, 7522.7563, 3989.8428);
	angles[9] = (0, -25.3420, 0);
	at[9] = 6.3333;
	points[10] = (-2846.6182, 7527.2832, 3990.8267);
	angles[10] = (0, 4.9254, 0);
	at[10] = 6.4000;
	points[11] = (-2847.9133, 7535.1577, 3992.5198);
	angles[11] = (0, 5.0210, 0);
	at[11] = 6.4667;
	points[12] = (-2846.0237, 7542.9531, 3994.0552);
	angles[12] = (0, -11.3186, 0);
	at[12] = 6.5333;
	points[13] = (-2838.7126, 7545.8662, 3994.4094);
	angles[13] = (0, -48.6924, 0);
	at[13] = 6.6000;
	points[14] = (-2831.3936, 7542.4014, 3993.4253);
	angles[14] = (0, -89.1590, 0);
	at[14] = 6.6667;
	points[15] = (-2826.1338, 7536.2207, 3991.9688);
	angles[15] = (0, -117.5155, 0);
	at[15] = 6.7333;
	points[16] = (-2819.9568, 7530.8662, 3990.6692);
	angles[16] = (0, -125.6521, 0);
	at[16] = 6.8000;
	points[17] = (-2824.1968, 7535.1968, 3991.6929);
	angles[17] = (0, -105.5642, 0);
	at[17] = 6.8667;
	points[18] = (-2830.0276, 7541.1025, 3993.1104);
	angles[18] = (0, -59.4682, 0);
	at[18] = 6.9333;
	points[19] = (-2833.6379, 7544.4097, 3993.9370);
	angles[19] = (0, -31.8245, 0);
	at[19] = 7;
	points[20] = (-2828.3464, 7538.7012, 3992.5593);
	angles[20] = (0, -84.3067, 0);
	at[20] = 7.0667;
	points[21] = (-2822.3503, 7532.3623, 3991.0630);
	angles[21] = (0, -114.0807, 0);
	at[21] = 7.1333;
	points[22] = (-2817.3464, 7527.0869, 3989.8032);
	angles[22] = (0, -127.2096, 0);
	at[22] = 7.2000;
	points[23] = (-2806.9058, 7516.1025, 3987.1655);
	angles[23] = (0, -134.8560, 0);
	at[23] = 7.3333;
	points[24] = (-2371.2126, 7059.5674, 3877.6182);
	angles[24] = (0, -136.3574, 0);
	at[24] = 12.4667;
	points[25] = (-2338.1143, 7024.8428, 3869.2874);
	angles[25] = (0, -136.3826, 0);
	at[25] = 12.8667;
	points[26] = (-2325.1614, 7011.2207, 3866.0276);
	angles[26] = (0, -136.4073, 0);
	at[26] = 13;
	points[27] = (-2316.0710, 7001.6929, 3863.7324);
	angles[27] = (0, -136.4628, 0);
	at[27] = 13.1333;
	points[28] = (-2293.5630, 6977.5986, 3857.9646);
	angles[28] = (0, -137.3959, 0);
	at[28] = 13.4000;
	points[29] = (-2294.5906, 6977.6772, 3857.9963);
	angles[29] = (0, -150.3339, 0);
	at[29] = 13.4667;
	points[30] = (-2300.6575, 6983.4253, 3859.3857);
	angles[30] = (0, -183.0602, 0);
	at[30] = 13.5333;
	points[31] = (-2306.6694, 6989.0942, 3860.7561);
	angles[31] = (0, -238.5717, 0);
	at[31] = 13.6000;
	points[32] = (-2307.2441, 6983.7012, 3859.5708);
	angles[32] = (0, -206.6312, 0);
	at[32] = 13.6667;
	points[33] = (-2312.7678, 6977.9531, 3858.4211);
	angles[33] = (0, -221.2761, 0);
	at[33] = 13.7333;
	points[34] = (-2320.5828, 6978.7012, 3858.7480);
	angles[34] = (0, -257.7252, 0);
	at[34] = 13.8000;
	points[35] = (-2320.2244, 6977.4414, 3858.4685);
	angles[35] = (0, -226.0954, 0);
	at[35] = 13.8667;
	points[36] = (-2314.4607, 6971.4961, 3857.0354);
	angles[36] = (0, -178.0659, 0);
	at[36] = 13.9333;
	points[37] = (-2308.7952, 6965.6689, 3855.6260);
	angles[37] = (0, -153.4471, 0);
	at[37] = 14;
	points[38] = (-2310.4724, 6967.4414, 3856.0591);
	angles[38] = (0, -167.9914, 0);
	at[38] = 14.0667;
	points[39] = (-2321.4763, 6978.8188, 3858.8032);
	angles[39] = (0, -267.7773, 0);
	at[39] = 14.2000;
	points[40] = (-2327.0984, 6984.6460, 3860.2009);
	angles[40] = (0, -295.3156, 0);
	at[40] = 14.2667;
	points[41] = (-2328.6772, 6986.2603, 3860.5945);
	angles[41] = (0, -299.3666, 0);
	at[41] = 14.2833;
	mover = getEnt("iz_obj_4", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_5()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-2554.8464, 7698.5435, 4016.2600);
	angles[0] = (0, -144.7464, 0);
	at[0] = 0;
	points[1] = (-2534.4373, 7672.5986, 4010.1577);
	angles[1] = (0, -141.8032, 0);
	at[1] = 0.2667;
	points[2] = (-2367.1497, 7460.5117, 3960.3152);
	angles[2] = (0, -142.0311, 0);
	at[2] = 2.4667;
	points[3] = (-2353.5630, 7442.9526, 3956.2205);
	angles[3] = (0, -142.3644, 0);
	at[3] = 2.6667;
	points[4] = (-2131.2441, 7150.5908, 3887.8818);
	angles[4] = (0, -141.5525, 0);
	at[4] = 5.6667;
	points[5] = (-2120.6497, 7138.4253, 3884.9802);
	angles[5] = (0, -138.4480, 0);
	at[5] = 5.8000;
	points[6] = (-2114.4883, 7133.3462, 3883.6929);
	angles[6] = (0, -131.9787, 0);
	at[6] = 5.8667;
	points[7] = (-2101.5591, 7123.3467, 3881.1536);
	angles[7] = (0, -127.1319, 0);
	at[7] = 6;
	points[8] = (-2094.1851, 7120.0791, 3880.2085);
	angles[8] = (0, -115.2190, 0);
	at[8] = 6.0667;
	points[9] = (-2079.0117, 7125.7085, 3880.8267);
	angles[9] = (0, -71.2158, 0);
	at[9] = 6.2000;
	points[10] = (-2074.6062, 7132.3623, 3882.0393);
	angles[10] = (0, -45.3880, 0);
	at[10] = 6.2667;
	points[11] = (-2074.8818, 7140.3936, 3883.7048);
	angles[11] = (0, -15.6012, 0);
	at[11] = 6.3333;
	points[12] = (-2078.0237, 7147.8345, 3885.3584);
	angles[12] = (0, 9.0933, 0);
	at[12] = 6.4000;
	points[13] = (-2082.7876, 7154.2910, 3886.8740);
	angles[13] = (0, 25.5532, 0);
	at[13] = 6.4667;
	points[14] = (-2087.8071, 7160.6304, 3888.3740);
	angles[14] = (0, 33.1185, 0);
	at[14] = 6.5333;
	points[15] = (-2097.8149, 7173.2681, 3891.3506);
	angles[15] = (0, 37.4791, 0);
	at[15] = 6.6667;
	points[16] = (-2325.0471, 7461.9292, 3959.1338);
	angles[16] = (0, 38.3418, 0);
	at[16] = 9.6667;
	points[17] = (-2338.8542, 7479.3311, 3963.2285);
	angles[17] = (0, 38.4763, 0);
	at[17] = 9.8667;
	points[18] = (-2538.3857, 7727.2441, 4021.6536);
	angles[18] = (0, 40.7214, 0);
	at[18] = 12.4667;
	points[19] = (-2544.0393, 7733.0317, 4023.0315);
	angles[19] = (0, 43.6461, 0);
	at[19] = 12.5333;
	points[20] = (-2558.1970, 7740.8662, 4025.1182);
	angles[20] = (0, 61.1626, 0);
	at[20] = 12.6667;
	points[21] = (-2566.2520, 7740.1182, 4025.2754);
	angles[21] = (0, 84.4870, 0);
	at[21] = 12.7333;
	points[22] = (-2572.4763, 7735.1577, 4024.4490);
	angles[22] = (0, 114.8601, 0);
	at[22] = 12.8000;
	points[23] = (-2572.8818, 7727.3618, 4022.8347);
	angles[23] = (0, 153.6274, 0);
	at[23] = 12.8667;
	points[24] = (-2569.7324, 7719.8428, 4021.1812);
	angles[24] = (0, 183.2548, 0);
	at[24] = 12.9333;
	points[25] = (-2565.8188, 7712.9922, 4019.6458);
	angles[25] = (0, 200.4521, 0);
	at[25] = 13;
	points[26] = (-2561.0195, 7706.5747, 4018.1497);
	angles[26] = (0, 210.1954, 0);
	at[26] = 13.0667;
	points[27] = (-2554.8464, 7698.5435, 4016.2600);
	angles[27] = (0, 215.2535, 0);
	at[27] = 13.1500;
	mover = getEnt("iz_obj_5", "targetname");
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
