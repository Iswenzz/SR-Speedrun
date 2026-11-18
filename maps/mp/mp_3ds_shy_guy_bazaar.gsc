main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_3ds_shy_guy_bazaar", 0);

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
	ambientPlay("iz_0_107", 2);
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
	level.iz_route[level.iz_route.size] = (5521, 5548, 3298);
	level.iz_route[level.iz_route.size] = (5521, 4571, 3371);
	level.iz_route[level.iz_route.size] = (5521, 3573, 3440);
	level.iz_route[level.iz_route.size] = (5196, 2923, 3490);
	level.iz_route[level.iz_route.size] = (4478, 2311, 3574);
	level.iz_route[level.iz_route.size] = (4006, 1334, 3714);
	level.iz_route[level.iz_route.size] = (4222, 223, 3695);
	level.iz_route[level.iz_route.size] = (4526, -500, 3717);
	level.iz_route[level.iz_route.size] = (4547, -2449, 3849);
	level.iz_route[level.iz_route.size] = (4462, -3574, 3863);
	level.iz_route[level.iz_route.size] = (4327, -4280, 3849);
	level.iz_route[level.iz_route.size] = (3995, -4806, 3849);
	level.iz_route[level.iz_route.size] = (3321, -5286, 3849);
	level.iz_route[level.iz_route.size] = (3058, -5571, 3849);
	level.iz_route[level.iz_route.size] = (2601, -6027, 3849);
	level.iz_route[level.iz_route.size] = (2362, -6278, 3849);
	level.iz_route[level.iz_route.size] = (1986, -7027, 3849);
	level.iz_route[level.iz_route.size] = (1697, -7521, 3849);
	level.iz_route[level.iz_route.size] = (1447, -8551, 3849);
	level.iz_route[level.iz_route.size] = (1253, -9957, 3849);
	level.iz_route[level.iz_route.size] = (943, -10602, 3849);
	level.iz_route[level.iz_route.size] = (496, -11126, 3849);
	level.iz_route[level.iz_route.size] = (295, -11579, 3849);
	level.iz_route[level.iz_route.size] = (159, -12361, 3849);
	level.iz_route[level.iz_route.size] = (-33, -12879, 3849);
	level.iz_route[level.iz_route.size] = (-411, -13363, 3849);
	level.iz_route[level.iz_route.size] = (-983, -13770, 3849);
	level.iz_route[level.iz_route.size] = (-1575, -13923, 3849);
	level.iz_route[level.iz_route.size] = (-2170, -14059, 3849);
	level.iz_route[level.iz_route.size] = (-2847, -14087, 3849);
	level.iz_route[level.iz_route.size] = (-3558, -13973, 3865);
	level.iz_route[level.iz_route.size] = (-4531, -13907, 3857);
	level.iz_route[level.iz_route.size] = (-5594, -13849, 3878);
	level.iz_route[level.iz_route.size] = (-6468, -13444, 3931);
	level.iz_route[level.iz_route.size] = (-6567, -12445, 3955);
	level.iz_route[level.iz_route.size] = (-5869, -11680, 3964);
	level.iz_route[level.iz_route.size] = (-5249, -11152, 3973);
	level.iz_route[level.iz_route.size] = (-4623, -10571, 4004);
	level.iz_route[level.iz_route.size] = (-4164, -9964, 4043);
	level.iz_route[level.iz_route.size] = (-4105, -8996, 4092);
	level.iz_route[level.iz_route.size] = (-4975, -8547, 4091);
	level.iz_route[level.iz_route.size] = (-5906, -8989, 4050);
	level.iz_route[level.iz_route.size] = (-6474, -9775, 4038);
	level.iz_route[level.iz_route.size] = (-7077, -10392, 4037);
	level.iz_route[level.iz_route.size] = (-7638, -10896, 4041);
	level.iz_route[level.iz_route.size] = (-8250, -11095, 4047);
	level.iz_route[level.iz_route.size] = (-8865, -11045, 4049);
	level.iz_route[level.iz_route.size] = (-9291, -10574, 4050);
	level.iz_route[level.iz_route.size] = (-9321, -10066, 4047);
	level.iz_route[level.iz_route.size] = (-9170, -9395, 4041);
	level.iz_route[level.iz_route.size] = (-8958, -8720, 4041);
	level.iz_route[level.iz_route.size] = (-8769, -7957, 4041);
	level.iz_route[level.iz_route.size] = (-8597, -7227, 4041);
	level.iz_route[level.iz_route.size] = (-8483, -6567, 4041);
	level.iz_route[level.iz_route.size] = (-8444, -5846, 4041);
	level.iz_route[level.iz_route.size] = (-8282, -5196, 4041);
	level.iz_route[level.iz_route.size] = (-7938, -4545, 4041);
	level.iz_route[level.iz_route.size] = (-7605, -3927, 4041);
	level.iz_route[level.iz_route.size] = (-7343, -3416, 4318);
	level.iz_route[level.iz_route.size] = (-6909, -2668, 4455);
	level.iz_route[level.iz_route.size] = (-6462, -1868, 4431);
	level.iz_route[level.iz_route.size] = (-5970, -978, 4434);
	level.iz_route[level.iz_route.size] = (-5902, -858, 4492);
	level.iz_route[level.iz_route.size] = (-5658, -349, 4579);
	level.iz_route[level.iz_route.size] = (-4819, 1137, 4490);
	level.iz_route[level.iz_route.size] = (-4289, 2047, 4472);
	level.iz_route[level.iz_route.size] = (-4200, 2199, 4564);
	level.iz_route[level.iz_route.size] = (-3968, 2665, 4676);
	level.iz_route[level.iz_route.size] = (-2553, 5292, 4740);
	level.iz_route[level.iz_route.size] = (-1055, 8031, 4191);
	level.iz_route[level.iz_route.size] = (457, 10653, 3389);
	level.iz_route[level.iz_route.size] = (854, 11204, 3390);
	level.iz_route[level.iz_route.size] = (1273, 11605, 3391);
	level.iz_route[level.iz_route.size] = (1774, 11930, 3389);
	level.iz_route[level.iz_route.size] = (2923, 12179, 3387);
	level.iz_route[level.iz_route.size] = (4410, 12154, 3386);
	level.iz_route[level.iz_route.size] = (5184, 12000, 3386);
	level.iz_route[level.iz_route.size] = (5521, 11205, 3386);
	level.iz_route[level.iz_route.size] = (5521, 9743, 3290);
	level.iz_route[level.iz_route.size] = (5521, 8607, 3148);
	level.iz_route[level.iz_route.size] = (5521, 7945, 3155);
	level.iz_route[level.iz_route.size] = (5515, 7278, 3191);
	level.iz_route[level.iz_route.size] = (5509, 6563, 3228);
	level.iz_route[level.iz_route.size] = (5507, 6352, 3238);
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
	points[0] = (-2083.6614, 10566.3779, 4116.6538);
	angles[0] = (0, -81.1635, 0.0809);
	at[0] = 0;
	points[1] = (-2171.9370, 10560.6689, 4116.9292);
	angles[1] = (0, -77.8101, 0.2529);
	at[1] = 0.0667;
	points[2] = (-2349.1929, 10555.5117, 4117.8350);
	angles[2] = (0, -61.7317, 1.0526);
	at[2] = 0.2000;
	points[3] = (-2437.7324, 10547.7959, 4117.9922);
	angles[3] = (0, -48.7831, 1.6414);
	at[3] = 0.2667;
	points[4] = (-2524.7009, 10529.5664, 4117.6377);
	angles[4] = (0, -33.2206, 2.2405);
	at[4] = 0.3333;
	points[5] = (-2597.4175, 10487.3623, 4115.9844);
	angles[5] = (0, -19.7325, 2.6288);
	at[5] = 0.4000;
	points[6] = (-2659.1655, 10420.6689, 4112.8350);
	angles[6] = (0, -7, 2.8000);
	at[6] = 0.4667;
	points[7] = (-2715.4055, 10351.8506, 4109.4883);
	angles[7] = (0, 10.1155, 2.7965);
	at[7] = 0.5333;
	points[8] = (-2769.2402, 10281.8105, 4106.1025);
	angles[8] = (0, 32.3076, 2.4273);
	at[8] = 0.6000;
	points[9] = (-2872.8623, 10137.2041, 4099.1733);
	angles[9] = (0, 81.6534, 0.5044);
	at[9] = 0.7333;
	points[10] = (-2922.3188, 10062.9922, 4095.7087);
	angles[10] = (0, 101.6451, -0.4479);
	at[10] = 0.8000;
	points[11] = (-2969.4802, 9987.4014, 4092.2834);
	angles[11] = (0, 116.8683, -1.1138);
	at[11] = 0.8667;
	points[12] = (-3012.9568, 9909.3701, 4088.9370);
	angles[12] = (0, 128.4435, -1.5151);
	at[12] = 0.9333;
	points[13] = (-3043.8425, 9829.2920, 4086.1418);
	angles[13] = (0, 139.6175, -1.6545);
	at[13] = 1;
	points[14] = (-3060.3623, 9742.4404, 4084.9607);
	angles[14] = (0, 149.7781, -1.3392);
	at[14] = 1.0667;
	points[15] = (-3061.4883, 9654.3701, 4084.9214);
	angles[15] = (0, 160.5199, -0.8982);
	at[15] = 1.1333;
	points[16] = (-3036.7441, 9569.2129, 4085.3149);
	angles[16] = (0, 173.2062, -0.5333);
	at[16] = 1.2000;
	points[17] = (-2992.5630, 9493.7012, 4085.7087);
	angles[17] = (0, 186.0970, -0.2850);
	at[17] = 1.2667;
	points[18] = (-2936.3308, 9425.9053, 4085.9841);
	angles[18] = (0, 197.7107, -0.1360);
	at[18] = 1.3333;
	points[19] = (-2872.3938, 9363.8584, 4086.1418);
	angles[19] = (0, 207.4664, -0.0589);
	at[19] = 1.4000;
	points[20] = (-2804.2874, 9306.9688, 4086.2205);
	angles[20] = (0, 215.3395, -0.0289);
	at[20] = 1.4667;
	points[21] = (-2745.3779, 9262.4805, 4086.2205);
	angles[21] = (0, 221.4395, -0.0192);
	at[21] = 1.5333;
	points[22] = (-2668.5276, 9206.9688, 4086.2205);
	angles[22] = (0, 225.8333, -0.0127);
	at[22] = 1.6000;
	points[23] = (-2594.3857, 9154.4883, 4086.2205);
	angles[23] = (0, 228.9074, -0.0084);
	at[23] = 1.6667;
	points[24] = (-2526.3584, 9106.8896, 4086.2205);
	angles[24] = (0, 231.0163, -0.0055);
	at[24] = 1.7333;
	points[25] = (-2451.4214, 9054.8428, 4086.2205);
	angles[25] = (0, 232.4686, -0.0036);
	at[25] = 1.8000;
	points[26] = (-2370.1104, 8998.7012, 4086.2205);
	angles[26] = (0, 233.4768, -0.0024);
	at[26] = 1.8667;
	points[27] = (-2231.5906, 8903.6611, 4086.2205);
	angles[27] = (0, 234.6701, -0.0010);
	at[27] = 2;
	points[28] = (-2005.5826, 8749.8027, 4086.2205);
	angles[28] = (0, 235.4691, 0);
	at[28] = 2.2000;
	points[29] = (-1862.2126, 8652.7559, 4086.2205);
	angles[29] = (0, 235.7277, 0);
	at[29] = 2.3333;
	points[30] = (-1637.2126, 8501.1807, 4086.2205);
	angles[30] = (0, 235.9622, 0);
	at[30] = 2.5333;
	points[31] = (-1417.9253, 8354.2129, 4086.2205);
	angles[31] = (0, 236.1211, 0);
	at[31] = 2.7333;
	points[32] = (-1046.3937, 8106.6934, 4086.2205);
	angles[32] = (0, 236.3358, 0);
	at[32] = 3.0667;
	points[33] = (-825.8780, 7960.6694, 4086.2205);
	angles[33] = (0, 236.4612, 0);
	at[33] = 3.2667;
	points[34] = (-599.6575, 7811.6934, 4086.2205);
	angles[34] = (0, 236.5988, 0);
	at[34] = 3.4667;
	points[35] = (-454.2165, 7716.3779, 4086.2205);
	angles[35] = (0, 236.7025, 0);
	at[35] = 3.6000;
	points[36] = (-225.6488, 7567.5981, 4086.2205);
	angles[36] = (0, 236.8950, 0);
	at[36] = 3.8000;
	points[37] = (-83.0740, 7475.5908, 4086.2205);
	angles[37] = (0, 237.0631, 0);
	at[37] = 3.9333;
	points[38] = (75.6283, 7374.2124, 4086.2205);
	angles[38] = (0, 237.3008, 0);
	at[38] = 4.0667;
	points[39] = (217.3134, 7285.2759, 4086.2205);
	angles[39] = (0, 237.6746, 0);
	at[39] = 4.2000;
	points[40] = (304.4016, 7231.9292, 4086.2205);
	angles[40] = (0, 238.0141, 0);
	at[40] = 4.2667;
	points[41] = (371.6768, 7192.3623, 4086.2205);
	angles[41] = (0, 238.6216, 0);
	at[41] = 4.3333;
	points[42] = (445.6457, 7152.5981, 4086.1812);
	angles[42] = (0, 239.8265, -0.0072);
	at[42] = 4.4000;
	points[43] = (525.2441, 7114.9609, 4086.1025);
	angles[43] = (0, 241.6684, -0.0276);
	at[43] = 4.4667;
	points[44] = (606.9685, 7081.8506, 4085.9448);
	angles[44] = (0, 244.0114, -0.0553);
	at[44] = 4.5333;
	points[45] = (691.5590, 7053.4648, 4085.7087);
	angles[45] = (0, 246.7666, -0.0852);
	at[45] = 4.6000;
	points[46] = (777.3583, 7030.8662, 4085.4727);
	angles[46] = (0, 249.8878, -0.1125);
	at[46] = 4.6667;
	points[47] = (864.3740, 7014.5278, 4085.2363);
	angles[47] = (0, 253.3680, -0.1320);
	at[47] = 4.7333;
	points[48] = (952.4291, 7005.1177, 4085);
	angles[48] = (0, 257.2364, -0.1360);
	at[48] = 4.8000;
	points[49] = (1041.0552, 7003.6616, 4084.8425);
	angles[49] = (0, 261.5742, -0.1122);
	at[49] = 4.8667;
	points[50] = (1129.0237, 7011.5356, 4084.9607);
	angles[50] = (0, 266.5764, -0.0360);
	at[50] = 4.9333;
	points[51] = (1215.3268, 7031.7715, 4085.6694);
	angles[51] = (0, 272.7891, 0.1598);
	at[51] = 5;
	points[52] = (1290.2716, 7075.3936, 4087.7561);
	angles[52] = (0, 283.1644, 0.6503);
	at[52] = 5.0667;
	points[53] = (1349.4763, 7140, 4090.7874);
	angles[53] = (0, 295.0098, 1.1587);
	at[53] = 5.1333;
	points[54] = (1402.8859, 7211.2598, 4094.0552);
	angles[54] = (0, 304.6911, 1.5245);
	at[54] = 5.2000;
	points[55] = (1452.3661, 7285.3149, 4097.4014);
	angles[55] = (0, 312.1505, 1.7658);
	at[55] = 5.2667;
	points[56] = (1542.5748, 7437.9922, 4104.0552);
	angles[56] = (0, 322.2253, 2.0094);
	at[56] = 5.4000;
	points[57] = (1622.7008, 7597.2441, 4110.6299);
	angles[57] = (0, 328.8416, 2.0718);
	at[57] = 5.5333;
	points[58] = (1657.0197, 7679.6064, 4113.7402);
	angles[58] = (0, 331.9830, 2.0465);
	at[58] = 5.6000;
	points[59] = (1681.4724, 7764.2915, 4116.4565);
	angles[59] = (0, 336.7506, 1.9250);
	at[59] = 5.6667;
	points[60] = (1673.2007, 7848.5435, 4117.5986);
	angles[60] = (0, 347.4856, 1.5504);
	at[60] = 5.7333;
	points[61] = (1644.3229, 7932.8350, 4117.9526);
	angles[61] = (0, 358.3949, 1.1251);
	at[61] = 5.8000;
	points[62] = (1608.3623, 8014.3306, 4117.9922);
	angles[62] = (0, 367.1724, 0.7553);
	at[62] = 5.8667;
	points[63] = (1527.7047, 8172.6772, 4117.5986);
	angles[63] = (0, 378.5997, 0.2515);
	at[63] = 6;
	points[64] = (1401.6653, 8407.0869, 4116.7324);
	angles[64] = (0, 385.3978, -0.0536);
	at[64] = 6.2000;
	points[65] = (1371.0354, 8470.2363, 4116.6538);
	angles[65] = (0, 385.5544, -0.0611);
	at[65] = 6.2667;
	points[66] = (1451.4213, 8313.3467, 4117.0474);
	angles[66] = (0, 383.1389, 0.0488);
	at[66] = 6.4000;
	points[67] = (1536.1851, 8156.7720, 4117.6377);
	angles[67] = (0, 374.8927, 0.4181);
	at[67] = 6.5333;
	points[68] = (1616.1063, 7997.7563, 4117.9922);
	angles[68] = (0, 357.0095, 1.1827);
	at[68] = 6.6667;
	points[69] = (1651, 7915.8662, 4117.9136);
	angles[69] = (0, 342.6879, 1.7191);
	at[69] = 6.7333;
	points[70] = (1677.2401, 7831.7319, 4117.4805);
	angles[70] = (0, 324.8485, 2.2402);
	at[70] = 6.8000;
	points[71] = (1678.2599, 7747.5591, 4115.9844);
	angles[71] = (0, 307.3043, 2.5473);
	at[71] = 6.8667;
	points[72] = (1650.2323, 7661.9297, 4113.1104);
	angles[72] = (0, 289.5091, 2.5645);
	at[72] = 6.9333;
	points[73] = (1614.9528, 7580.3545, 4109.9604);
	angles[73] = (0, 267.4905, 2.2333);
	at[73] = 7;
	points[74] = (1575.9016, 7500.7480, 4106.6929);
	angles[74] = (0, 242.4072, 1.4649);
	at[74] = 7.0667;
	points[75] = (1489.2952, 7345.0391, 4100.0396);
	angles[75] = (0, 197.1498, -0.4641);
	at[75] = 7.2000;
	points[76] = (1442.3268, 7269.7246, 4096.6929);
	angles[76] = (0, 181.1555, -1.1183);
	at[76] = 7.2667;
	points[77] = (1392.6299, 7196.8110, 4093.3860);
	angles[77] = (0, 169.1930, -1.5273);
	at[77] = 7.3333;
	points[78] = (1338.5591, 7126.7720, 4090.1575);
	angles[78] = (0, 159.8650, -1.7576);
	at[78] = 7.4000;
	points[79] = (1274.9646, 7062.2837, 4087.1262);
	angles[79] = (0, 150.9385, -1.8402);
	at[79] = 7.4667;
	points[80] = (1197.4724, 7026.2207, 4085.4331);
	angles[80] = (0, 137.9520, -1.6303);
	at[80] = 7.5333;
	points[81] = (1111.4646, 7009.0947, 4084.9214);
	angles[81] = (0, 125.3091, -1.2293);
	at[81] = 7.6000;
	points[82] = (1022.7835, 7003.2285, 4084.8818);
	angles[82] = (0, 114.3886, -0.8430);
	at[82] = 7.6667;
	points[83] = (934.0866, 7006.4570, 4085.0396);
	angles[83] = (0, 105.1581, -0.5306);
	at[83] = 7.7333;
	points[84] = (846.2952, 7017.3623, 4085.2756);
	angles[84] = (0, 97.3570, -0.3000);
	at[84] = 7.8000;
	points[85] = (759.7402, 7035, 4085.5120);
	angles[85] = (0, 90.6981, -0.1414);
	at[85] = 7.8667;
	points[86] = (674.5275, 7058.7007, 4085.7874);
	angles[86] = (0, 84.9364, -0.0405);
	at[86] = 7.9333;
	points[87] = (590.6142, 7088.0312, 4085.9841);
	angles[87] = (0, 79.8781, 0.0165);
	at[87] = 8;
	points[88] = (508.2953, 7122.5200, 4086.1418);
	angles[88] = (0, 75.3810, 0.0410);
	at[88] = 8.0667;
	points[89] = (429.5709, 7160.8267, 4086.1812);
	angles[89] = (0, 71.3368, 0.0420);
	at[89] = 8.1333;
	points[90] = (359.7114, 7199.2129, 4086.2205);
	angles[90] = (0, 67.6962, 0.0291);
	at[90] = 8.2000;
	points[91] = (288.2571, 7241.6929, 4086.2205);
	angles[91] = (0, 64.7486, 0.0192);
	at[91] = 8.2667;
	points[92] = (200.5799, 7295.6304, 4086.2205);
	angles[92] = (0, 62.5335, 0.0126);
	at[92] = 8.3333;
	points[93] = (133.7051, 7337.5200, 4086.2205);
	angles[93] = (0, 60.9438, 0.0083);
	at[93] = 8.4000;
	points[94] = (60.1850, 7384.0161, 4086.2205);
	angles[94] = (0, 59.8135, 0.0054);
	at[94] = 8.4667;
	points[95] = (-96.9874, 7484.5273, 4086.2205);
	angles[95] = (0, 58.4138, 0.0023);
	at[95] = 8.6000;
	points[96] = (-240.7791, 7577.4019, 4086.2205);
	angles[96] = (0, 57.6742, 0.0010);
	at[96] = 8.7333;
	points[97] = (-395.4843, 7678.0317, 4086.2205);
	angles[97] = (0, 57.2542, 0);
	at[97] = 8.8667;
	points[98] = (-614.7284, 7821.5747, 4086.2205);
	angles[98] = (0, 56.8986, 0);
	at[98] = 9.0667;
	points[99] = (-840.6536, 7970.4336, 4086.2205);
	angles[99] = (0, 56.6839, 0);
	at[99] = 9.2667;
	points[100] = (-1652.4213, 8511.4180, 4086.2205);
	angles[100] = (0, 56.1883, 0);
	at[100] = 10;
	points[101] = (-1877.0552, 8662.7959, 4086.2205);
	angles[101] = (0, 56.0559, 0);
	at[101] = 10.2000;
	points[102] = (-2019.7678, 8759.4092, 4086.2205);
	angles[102] = (0, 55.9581, 0);
	at[102] = 10.3333;
	points[103] = (-2172.9331, 8863.6221, 4086.2205);
	angles[103] = (0, 55.8436, 0);
	at[103] = 10.4667;
	points[104] = (-2246.2322, 8913.6611, 4086.2205);
	angles[104] = (0, 55.7770, 0);
	at[104] = 10.5333;
	points[105] = (-2387.1101, 9010.3936, 4086.2205);
	angles[105] = (0, 55.6202, 0);
	at[105] = 10.6667;
	points[106] = (-2467.1731, 9065.7480, 4086.2205);
	angles[106] = (0, 55.5177, 0);
	at[106] = 10.7333;
	points[107] = (-2540.7483, 9116.9297, 4086.2205);
	angles[107] = (0, 55.3894, 0);
	at[107] = 10.8000;
	points[108] = (-2607.3071, 9163.5830, 4086.2205);
	angles[108] = (0, 55.2292, 0);
	at[108] = 10.8667;
	points[109] = (-2685.8779, 9219.3701, 4086.2205);
	angles[109] = (0, 55.0024, 0);
	at[109] = 10.9333;
	points[110] = (-2758.2598, 9271.9688, 4086.2205);
	angles[110] = (0, 54.5935, 0);
	at[110] = 11;
	points[111] = (-2819.1851, 9318.8193, 4086.2205);
	angles[111] = (0, 53.7463, -0.0027);
	at[111] = 11.0667;
	points[112] = (-2884.8938, 9375.1973, 4086.1418);
	angles[112] = (0, 52.0296, -0.0233);
	at[112] = 11.1333;
	points[113] = (-2947.7361, 9438.3467, 4085.9448);
	angles[113] = (0, 49.2425, -0.0613);
	at[113] = 11.2000;
	points[114] = (-3002.0986, 9507.4414, 4085.6301);
	angles[114] = (0, 44.9778, -0.1131);
	at[114] = 11.2667;
	points[115] = (-3043.9565, 9586.5352, 4085.2363);
	angles[115] = (0, 38.4413, -0.1678);
	at[115] = 11.3333;
	points[116] = (-3063.2756, 9671.8506, 4084.8818);
	angles[116] = (0, 28.8720, -0.1819);
	at[116] = 11.4000;
	points[117] = (-3057.5825, 9760.0791, 4085.0789);
	angles[117] = (0, 17.2789, -0.0494);
	at[117] = 11.4667;
	points[118] = (-3040.4451, 9844.2520, 4086.5750);
	angles[118] = (0, 7.1996, 0.3872);
	at[118] = 11.5333;
	points[119] = (-3004.2952, 9926.0625, 4089.6458);
	angles[119] = (0, -3.7575, 0.9779);
	at[119] = 11.6000;
	points[120] = (-2912.3506, 10078.3076, 4096.4175);
	angles[120] = (0, -19.5427, 1.7135);
	at[120] = 11.7333;
	points[121] = (-2862.6455, 10152.0469, 4099.8818);
	angles[121] = (0, -24.5567, 1.9056);
	at[121] = 11.8000;
	points[122] = (-2758.1851, 10296.4961, 4106.8110);
	angles[122] = (0, -31.1756, 2.0987);
	at[122] = 11.9333;
	points[123] = (-2646.4646, 10435.3555, 4113.5435);
	angles[123] = (0, -35.8245, 2.1293);
	at[123] = 12.0667;
	points[124] = (-2585.0042, 10498.4258, 4116.4961);
	angles[124] = (0, -39.2735, 2.0326);
	at[124] = 12.1333;
	points[125] = (-2506.9016, 10534.7646, 4117.7954);
	angles[125] = (0, -49.1029, 1.6288);
	at[125] = 12.2000;
	points[126] = (-2419.8818, 10549.9609, 4117.9922);
	angles[126] = (0, -59.9306, 1.1379);
	at[126] = 12.2667;
	points[127] = (-2331.1497, 10556.4170, 4117.7559);
	angles[127] = (0, -68.8880, 0.7024);
	at[127] = 12.3333;
	points[128] = (-2153.3308, 10561.2988, 4116.8506);
	angles[128] = (0, -79.9515, 0.1431);
	at[128] = 12.4667;
	points[129] = (-2083.6614, 10566.3779, 4116.6538);
	angles[129] = (0, -81.1635, 0.0809);
	at[129] = 12.5333;
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
	points[0] = (1247.3701, 7047.9531, 4086.2205);
	angles[0] = (0, 148.3806, -2.0717);
	at[0] = 0;
	points[1] = (1304.5984, 7140.9453, 4090.1968);
	angles[1] = (0, 148.4835, -2.0608);
	at[1] = 0.0833;
	points[2] = (1426.4489, 7327.0869, 4098.4253);
	angles[2] = (0, 152.2547, -1.9202);
	at[2] = 0.2500;
	points[3] = (1545.5789, 7514.1338, 4106.5747);
	angles[3] = (0, 163.0189, -1.4600);
	at[3] = 0.4167;
	points[4] = (1601.4370, 7610.1577, 4110.5513);
	angles[4] = (0, 173.2305, -0.9505);
	at[4] = 0.5000;
	points[5] = (1650.9763, 7710.6304, 4114.3306);
	angles[5] = (0, 187.7950, -0.1283);
	at[5] = 0.5833;
	points[6] = (1676.2717, 7814.9209, 4117.1260);
	angles[6] = (0, 203.2841, 0.8753);
	at[6] = 0.6667;
	points[7] = (1684.5709, 7925.5513, 4117.9526);
	angles[7] = (0, 223.0217, 1.6813);
	at[7] = 0.7500;
	points[8] = (1677.1732, 8035.9058, 4117.9136);
	angles[8] = (0, 248.3958, 2.4007);
	at[8] = 0.8333;
	points[9] = (1648.0393, 8142.7163, 4117.5591);
	angles[9] = (0, 278.1824, 2.8930);
	at[9] = 0.9167;
	points[10] = (1598.0789, 8241.3779, 4117.2051);
	angles[10] = (0, 309.9471, 2.8945);
	at[10] = 1;
	points[11] = (1532.0787, 8329.3701, 4116.8896);
	angles[11] = (0, 339.7206, 2.3858);
	at[11] = 1.0833;
	points[12] = (1454.0118, 8407.8350, 4116.6929);
	angles[12] = (0, 364.2838, 1.6900);
	at[12] = 1.1667;
	points[13] = (1367.6693, 8477.5596, 4116.6538);
	angles[13] = (0, 382.8501, 1.0996);
	at[13] = 1.2500;
	points[14] = (1290.5315, 8531.3779, 4116.6538);
	angles[14] = (0, 395.8679, 0.6822);
	at[14] = 1.3333;
	points[15] = (1184.6182, 8601.3389, 4116.6538);
	angles[15] = (0, 404.3149, 0.4111);
	at[15] = 1.4167;
	points[16] = (1101.0394, 8655.2363, 4116.6538);
	angles[16] = (0, 409.5906, 0.2446);
	at[16] = 1.5000;
	points[17] = (1006.8661, 8715.1182, 4116.6538);
	angles[17] = (0, 412.8567, 0.1449);
	at[17] = 1.5833;
	points[18] = (903.0315, 8780.5117, 4116.6538);
	angles[18] = (0, 414.8940, 0.0857);
	at[18] = 1.6667;
	points[19] = (815.6378, 8835.1182, 4116.6538);
	angles[19] = (0, 416.1717, 0.0506);
	at[19] = 1.7500;
	points[20] = (723.4724, 8892.4404, 4116.6538);
	angles[20] = (0, 416.9830, 0.0299);
	at[20] = 1.8333;
	points[21] = (626.8701, 8952.2051, 4116.6538);
	angles[21] = (0, 417.5115, 0.0177);
	at[21] = 1.9167;
	points[22] = (526.7244, 9013.8975, 4116.6538);
	angles[22] = (0, 417.8672, 0.0104);
	at[22] = 2;
	points[23] = (342.8114, 9126.6143, 4116.6538);
	angles[23] = (0, 418.2897, 0.0036);
	at[23] = 2.1667;
	points[24] = (54.7598, 9301.9287, 4116.6538);
	angles[24] = (0, 418.6158, 0);
	at[24] = 2.4167;
	points[25] = (-324.8642, 9531.2207, 4116.6538);
	angles[25] = (0, 418.8716, 0);
	at[25] = 2.7500;
	points[26] = (-611.8543, 9703.3857, 4116.6538);
	angles[26] = (0, 419.0255, 0);
	at[26] = 3;
	points[27] = (-800.4095, 9815.9453, 4116.6538);
	angles[27] = (0, 419.1235, 0);
	at[27] = 3.1667;
	points[28] = (-995.5197, 9931.9688, 4116.6538);
	angles[28] = (0, 419.2249, 0);
	at[28] = 3.3333;
	points[29] = (-1279.1456, 10099.6465, 4116.6538);
	angles[29] = (0, 419.3938, 0);
	at[29] = 3.5833;
	points[30] = (-1379.6339, 10158.7412, 4116.6538);
	angles[30] = (0, 419.4603, 0);
	at[30] = 3.6667;
	points[31] = (-1475.9489, 10215.1572, 4116.6538);
	angles[31] = (0, 419.5349, 0);
	at[31] = 3.7500;
	points[32] = (-1567.6339, 10268.7012, 4116.6538);
	angles[32] = (0, 419.6185, 0);
	at[32] = 3.8333;
	points[33] = (-1664.4370, 10324.9609, 4116.6538);
	angles[33] = (0, 419.7153, 0);
	at[33] = 3.9167;
	points[34] = (-1766.8307, 10384.0947, 4116.6538);
	angles[34] = (0, 419.8412, 0);
	at[34] = 4;
	points[35] = (-1858.9646, 10436.8506, 4116.6538);
	angles[35] = (0, 420.0043, 0);
	at[35] = 4.0833;
	points[36] = (-2056.7756, 10547.2041, 4116.6538);
	angles[36] = (0, 420.6870, 0);
	at[36] = 4.2500;
	points[37] = (-2145.9409, 10592.2842, 4116.6538);
	angles[37] = (0, 421.8597, 0.0064);
	at[37] = 4.3333;
	points[38] = (-2248.0078, 10633.4648, 4116.8506);
	angles[38] = (0, 424.7626, 0.0440);
	at[38] = 4.4167;
	points[39] = (-2353.2205, 10655.5117, 4117.2441);
	angles[39] = (0, 431.1510, 0.1221);
	at[39] = 4.5000;
	points[40] = (-2459.0435, 10628.7402, 4117.8740);
	angles[40] = (0, 446.4343, 0.2189);
	at[40] = 4.5833;
	points[41] = (-2531.7756, 10546.0234, 4117.7163);
	angles[41] = (0, 467.3284, 0.0615);
	at[41] = 4.6667;
	points[42] = (-2609.4487, 10467.6768, 4115.1182);
	angles[42] = (0, 478.1745, -0.5961);
	at[42] = 4.7500;
	points[43] = (-2681.7759, 10386.1807, 4111.1812);
	angles[43] = (0, 486.6072, -1.2300);
	at[43] = 4.8333;
	points[44] = (-2751.6536, 10299.3311, 4106.8901);
	angles[44] = (0, 492.6599, -1.6394);
	at[44] = 4.9167;
	points[45] = (-2883.6101, 10120.1973, 4098.2285);
	angles[45] = (0, 500.0623, -2.0371);
	at[45] = 5.0833;
	points[46] = (-2945.2993, 10028.2285, 4093.8977);
	angles[46] = (0, 502.6814, -2.1156);
	at[46] = 5.1667;
	points[47] = (-3002.9097, 9932.4805, 4089.6851);
	angles[47] = (0, 505.4935, -2.1360);
	at[47] = 5.2500;
	points[48] = (-3044.3582, 9832.0869, 4086.0632);
	angles[48] = (0, 511.5696, -2.0047);
	at[48] = 5.3333;
	points[49] = (-3062.0513, 9722.7949, 4084.8818);
	angles[49] = (0, 519.8860, -1.3952);
	at[49] = 5.4167;
	points[50] = (-3048.8230, 9613.9375, 4085.1182);
	angles[50] = (0, 531.9385, -0.7871);
	at[50] = 5.5000;
	points[51] = (-2999.6418, 9514.5674, 4085.6301);
	angles[51] = (0, 546.5103, -0.3858);
	at[51] = 5.5833;
	points[52] = (-2931.0081, 9429.7246, 4085.9841);
	angles[52] = (0, 560.0185, -0.1656);
	at[52] = 5.6667;
	points[53] = (-2851.1260, 9353.8975, 4086.1812);
	angles[53] = (0, 571.0362, -0.0658);
	at[53] = 5.7500;
	points[54] = (-2768.8857, 9287.8740, 4086.2205);
	angles[54] = (0, 579.4891, -0.0344);
	at[54] = 5.8333;
	points[55] = (-2681.0708, 9224.0156, 4086.2205);
	angles[55] = (0, 585.4603, -0.0205);
	at[55] = 5.9167;
	points[56] = (-2588.9607, 9159.3701, 4086.2205);
	angles[56] = (0, 589.3785, -0.0122);
	at[56] = 6;
	points[57] = (-2499.7166, 9097.8350, 4086.2205);
	angles[57] = (0, 591.8629, -0.0072);
	at[57] = 6.0833;
	points[58] = (-2399.8740, 9029.7246, 4086.2205);
	angles[58] = (0, 593.4475, -0.0043);
	at[58] = 6.1667;
	points[59] = (-2314.1338, 8971.6543, 4086.2205);
	angles[59] = (0, 594.4601, -0.0025);
	at[59] = 6.2500;
	points[60] = (-2222.7283, 8910.0791, 4086.2205);
	angles[60] = (0, 595.1144, -0.0015);
	at[60] = 6.3333;
	points[61] = (-2126.1614, 8845.3545, 4086.2205);
	angles[61] = (0, 595.5474, 0);
	at[61] = 6.4167;
	points[62] = (-1944.8386, 8724.3701, 4086.2205);
	angles[62] = (0, 596.0418, 0);
	at[62] = 6.5833;
	points[63] = (-1755.7598, 8598.7793, 4086.2205);
	angles[63] = (0, 596.2928, 0);
	at[63] = 6.7500;
	points[64] = (-1573.5276, 8478.1885, 4086.2205);
	angles[64] = (0, 596.4374, 0);
	at[64] = 6.9167;
	points[65] = (-1386.3859, 8354.6855, 4086.2205);
	angles[65] = (0, 596.5302, 0);
	at[65] = 7.0833;
	points[66] = (-552.2874, 7806.1421, 4086.2205);
	angles[66] = (0, 596.6948, 0);
	at[66] = 7.8333;
	points[67] = (-364.4748, 7682.7954, 4086.2205);
	angles[67] = (0, 596.6962, 0);
	at[67] = 8;
	points[68] = (-181.2429, 7562.3228, 4086.2205);
	angles[68] = (0, 596.6843, 0);
	at[68] = 8.1667;
	points[69] = (-85.1590, 7499.0947, 4086.2205);
	angles[69] = (0, 596.6716, 0);
	at[69] = 8.2500;
	points[70] = (7.3031, 7438.2285, 4086.2205);
	angles[70] = (0, 596.6534, 0);
	at[70] = 8.3333;
	points[71] = (95.7539, 7379.8823, 4086.2205);
	angles[71] = (0, 596.6288, 0);
	at[71] = 8.4167;
	points[72] = (286.8453, 7253.5039, 4086.2205);
	angles[72] = (0, 596.5467, 0);
	at[72] = 8.5833;
	points[73] = (373.1480, 7196.1812, 4086.2205);
	angles[73] = (0, 596.4808, 0);
	at[73] = 8.6667;
	points[74] = (320.7244, 7231.0234, 4086.2205);
	angles[74] = (0, 596.5732, 0);
	at[74] = 8.7500;
	points[75] = (229.5441, 7291.4570, 4086.2205);
	angles[75] = (0, 596.6622, 0);
	at[75] = 8.8333;
	points[76] = (131.0323, 7356.6143, 4086.2205);
	angles[76] = (0, 596.7647, 0);
	at[76] = 8.9167;
	points[77] = (-49.4335, 7475.5908, 4086.2205);
	angles[77] = (0, 597.1379, 0);
	at[77] = 9.0833;
	points[78] = (-239.3114, 7600.5117, 4086.2205);
	angles[78] = (0, 598.2198, 0);
	at[78] = 9.2500;
	points[79] = (-329.4933, 7659.8037, 4086.2205);
	angles[79] = (0, 599.4510, 0);
	at[79] = 9.3333;
	points[80] = (-515.9410, 7782.2837, 4086.2205);
	angles[80] = (0, 605.6234, 0);
	at[80] = 9.5000;
	points[81] = (-610.0590, 7844.0947, 4086.2205);
	angles[81] = (0, 612.6937, 0);
	at[81] = 9.5833;
	points[82] = (-701.6102, 7904.2524, 4086.2205);
	angles[82] = (0, 625.0440, 0);
	at[82] = 9.6667;
	points[83] = (-794.0787, 7964.9604, 4086.2205);
	angles[83] = (0, 645.3223, 0);
	at[83] = 9.7500;
	points[84] = (-980.7441, 8087.6377, 4086.2205);
	angles[84] = (0, 705.3090, 0);
	at[84] = 9.9167;
	points[85] = (-1073.5276, 8148.6616, 4086.2205);
	angles[85] = (0, 731.2653, 0);
	at[85] = 10;
	points[86] = (-1166.2874, 8209.6855, 4086.2205);
	angles[86] = (0, 749.0561, 0);
	at[86] = 10.0833;
	points[87] = (-1258.8071, 8270.5908, 4086.2205);
	angles[87] = (0, 760.1764, 0);
	at[87] = 10.1667;
	points[88] = (-1350.8542, 8331.2598, 4086.2205);
	angles[88] = (0, 766.8724, 0);
	at[88] = 10.2500;
	points[89] = (-1538.1771, 8454.8428, 4086.2205);
	angles[89] = (0, 773.1862, 0);
	at[89] = 10.4167;
	points[90] = (-1721.1300, 8575.8662, 4086.2205);
	angles[90] = (0, 775.3502, 0);
	at[90] = 10.5833;
	points[91] = (-1909.5630, 8700.9062, 4086.2205);
	angles[91] = (0, 776.0463, 0);
	at[91] = 10.7500;
	points[92] = (-2089.7046, 8820.9844, 4086.2205);
	angles[92] = (0, 776.2084, 0);
	at[92] = 10.9167;
	points[93] = (-2186.4685, 8885.7480, 4086.2205);
	angles[93] = (0, 776.1974, 0);
	at[93] = 11;
	points[94] = (-2279.9016, 8948.5830, 4086.2205);
	angles[94] = (0, 776.1452, 0);
	at[94] = 11.0833;
	points[95] = (-2367.8623, 9007.9922, 4086.2205);
	angles[95] = (0, 776.0593, 0);
	at[95] = 11.1667;
	points[96] = (-2556.2795, 9136.7324, 4086.2205);
	angles[96] = (0, 775.7493, 0);
	at[96] = 11.3333;
	points[97] = (-2639.1458, 9194.4092, 4086.2205);
	angles[97] = (0, 775.4832, 0);
	at[97] = 11.4167;
	points[98] = (-2739.2954, 9265.9453, 4086.2205);
	angles[98] = (0, 774.9832, 0);
	at[98] = 11.5000;
	points[99] = (-2818.7205, 9326.8115, 4086.2205);
	angles[99] = (0, 773.8362, -0.0035);
	at[99] = 11.5833;
	points[100] = (-2901.4373, 9399.8037, 4086.0632);
	angles[100] = (0, 771.3931, -0.0335);
	at[100] = 11.6667;
	points[101] = (-2975.8032, 9481.6934, 4085.7874);
	angles[101] = (0, 767.1957, -0.0886);
	at[101] = 11.7500;
	points[102] = (-3033.3857, 9574.1738, 4085.3149);
	angles[102] = (0, 760.1902, -0.1570);
	at[102] = 11.8333;
	points[103] = (-3061.7798, 9680.6699, 4084.8818);
	angles[103] = (0, 748.8220, -0.1793);
	at[103] = 11.9167;
	points[104] = (-3052.6182, 9790.7090, 4085.3149);
	angles[104] = (0, 734.5995, 0.0358);
	at[104] = 12;
	points[105] = (-3022.3228, 9894.9209, 4088.1494);
	angles[105] = (0, 721.4213, 0.7204);
	at[105] = 12.0833;
	points[106] = (-2968.4253, 9991.4570, 4092.2441);
	angles[106] = (0, 708.8318, 1.3432);
	at[106] = 12.1667;
	points[107] = (-2907.7085, 10085.1182, 4096.5747);
	angles[107] = (0, 699.8560, 1.7298);
	at[107] = 12.2500;
	points[108] = (-2777.9055, 10265.2363, 4105.2363);
	angles[108] = (0, 689.4248, 2.0770);
	at[108] = 12.4167;
	points[109] = (-2709.4688, 10352.4805, 4109.5278);
	angles[109] = (0, 686.2399, 2.1342);
	at[109] = 12.5000;
	points[110] = (-2636.6812, 10438.4248, 4113.7007);
	angles[110] = (0, 683.4020, 2.1328);
	at[110] = 12.5833;
	points[111] = (-2559, 10513.7793, 4117.0864);
	angles[111] = (0, 679.3627, 1.9377);
	at[111] = 12.6667;
	points[112] = (-2490.1062, 10600.4336, 4117.9922);
	angles[112] = (0, 680.2560, 1.2712);
	at[112] = 12.7500;
	points[113] = (-2396.3977, 10653.6221, 4117.4805);
	angles[113] = (0, 669.6841, 0.6482);
	at[113] = 12.8333;
	points[114] = (-2285.6458, 10644.4883, 4116.9292);
	angles[114] = (0, 651.2059, 0.3162);
	at[114] = 12.9167;
	points[115] = (-2183.0825, 10608.8184, 4116.6929);
	angles[115] = (0, 634.8046, 0.1556);
	at[115] = 13;
	points[116] = (-2085.3779, 10562.3623, 4116.6538);
	angles[116] = (0, 622.3998, 0.0874);
	at[116] = 13.0833;
	points[117] = (-1999.1143, 10515.7090, 4116.6538);
	angles[117] = (0, 613.9008, 0.0527);
	at[117] = 13.1667;
	points[118] = (-1891.2047, 10455.1582, 4116.6538);
	angles[118] = (0, 608.4779, 0.0314);
	at[118] = 13.2500;
	points[119] = (-1803.2440, 10405, 4116.6538);
	angles[119] = (0, 605.1188, 0.0186);
	at[119] = 13.3333;
	points[120] = (-1704.6536, 10348.2285, 4116.6538);
	angles[120] = (0, 603.0406, 0.0110);
	at[120] = 13.4167;
	points[121] = (-1601.2992, 10288.3076, 4116.6538);
	angles[121] = (0, 601.7419, 0.0065);
	at[121] = 13.5000;
	points[122] = (-1511.5001, 10235.9453, 4116.6538);
	angles[122] = (0, 600.9259, 0.0038);
	at[122] = 13.5833;
	points[123] = (-1416.8977, 10180.5908, 4116.6538);
	angles[123] = (0, 600.4039, 0.0023);
	at[123] = 13.6667;
	points[124] = (-1218.7401, 10064.0557, 4116.6538);
	angles[124] = (0, 599.8252, 0);
	at[124] = 13.8333;
	points[125] = (-1032.1063, 9953.6611, 4116.6538);
	angles[125] = (0, 599.5377, 0);
	at[125] = 14;
	points[126] = (-837.4449, 9838.0312, 4116.6538);
	angles[126] = (0, 599.3638, 0);
	at[126] = 14.1667;
	points[127] = (-552.9331, 9668.1104, 4116.6538);
	angles[127] = (0, 599.1814, 0);
	at[127] = 14.4167;
	points[128] = (-170.1732, 9438.0312, 4116.6538);
	angles[128] = (0, 598.9789, 0);
	at[128] = 14.7500;
	points[129] = (112.9854, 9266.6143, 4116.6538);
	angles[129] = (0, 598.8240, 0);
	at[129] = 15;
	points[130] = (306.6945, 9148.6621, 4116.6538);
	angles[130] = (0, 598.7079, 0);
	at[130] = 15.1667;
	points[131] = (492.4016, 9034.9609, 4116.6538);
	angles[131] = (0, 598.5748, 0);
	at[131] = 15.3333;
	points[132] = (687.1142, 8914.9609, 4116.6538);
	angles[132] = (0, 598.4113, 0);
	at[132] = 15.5000;
	points[133] = (781.0276, 8856.6934, 4116.6538);
	angles[133] = (0, 598.3107, 0);
	at[133] = 15.5833;
	points[134] = (870.2244, 8801.0625, 4116.6538);
	angles[134] = (0, 598.1954, 0);
	at[134] = 15.6667;
	points[135] = (1066.3071, 8677.4023, 4116.6538);
	angles[135] = (0, 597.8710, 0);
	at[135] = 15.8333;
	points[136] = (1154.0393, 8621.1416, 4116.6538);
	angles[136] = (0, 597.6282, 0);
	at[136] = 15.9167;
	points[137] = (1252.2008, 8557.0078, 4116.6538);
	angles[137] = (0, 597.2708, 0);
	at[137] = 16;
	points[138] = (1342.3701, 8495.7090, 4116.6538);
	angles[138] = (0, 596.5529, 0);
	at[138] = 16.0833;
	points[139] = (1422.7560, 8434.6846, 4116.6538);
	angles[139] = (0, 594.8110, 0.0069);
	at[139] = 16.1667;
	points[140] = (1503.8662, 8360.0391, 4116.8110);
	angles[140] = (0, 591.4119, 0.0361);
	at[140] = 16.2500;
	points[141] = (1574.9528, 8275.6299, 4117.0474);
	angles[141] = (0, 586.3312, 0.0803);
	at[141] = 16.3333;
	points[142] = (1631.4606, 8181.0239, 4117.4409);
	angles[142] = (0, 579.4443, 0.1278);
	at[142] = 16.4167;
	points[143] = (1668.5905, 8077.7954, 4117.7954);
	angles[143] = (0, 570.7908, 0.1568);
	at[143] = 16.5000;
	points[144] = (1684.1024, 7967.8740, 4117.9922);
	angles[144] = (0, 560.9320, 0.1266);
	at[144] = 16.5833;
	points[145] = (1680.5000, 7857.0869, 4117.5986);
	angles[145] = (0, 551.2828, -0.0382);
	at[145] = 16.6667;
	points[146] = (1665.3662, 7749.7246, 4115.5908);
	angles[146] = (0, 542.7620, -0.5307);
	at[146] = 16.7500;
	points[147] = (1621.6693, 7648.2285, 4112.0474);
	angles[147] = (0, 531.7350, -1.1124);
	at[147] = 16.8333;
	points[148] = (1567.7008, 7551.0630, 4108.1104);
	angles[148] = (0, 523.1135, -1.5099);
	at[148] = 16.9167;
	points[149] = (1449.7047, 7362.6768, 4100);
	angles[149] = (0, 513.0453, -1.9093);
	at[149] = 17.0833;
	points[150] = (1267.9686, 7082.5981, 4087.6772);
	angles[150] = (0, 508.4910, -2.0690);
	at[150] = 17.3333;
	points[151] = (1247.3701, 7047.9531, 4086.2205);
	angles[151] = (0, 508.3806, -2.0717);
	at[151] = 17.3667;
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
	points[0] = (-2425.9802, 10342.4414, 3909.6064);
	angles[0] = (0, 107.8092, 0);
	at[0] = 0;
	points[1] = (-2352.3347, 10420.0400, 3909.6064);
	angles[1] = (0, 86.5675, 0);
	at[1] = 0.0833;
	points[2] = (-2259.7166, 10471.9297, 3909.6064);
	angles[2] = (0, 66.0875, 0);
	at[2] = 0.1667;
	points[3] = (-2154.2678, 10450.5117, 3909.6064);
	angles[3] = (0, 57.1423, 0);
	at[3] = 0.2500;
	points[4] = (-2052.8386, 10405.8271, 3909.6064);
	angles[4] = (0, 50.2701, 0);
	at[4] = 0.3333;
	points[5] = (-1968.2716, 10360.1582, 3909.6064);
	angles[5] = (0, 41.4814, 0);
	at[5] = 0.4167;
	points[6] = (-1857.0355, 10296.8506, 3909.6064);
	angles[6] = (0, 27.1277, 0);
	at[6] = 0.5000;
	points[7] = (-1771.9528, 10247.5586, 3909.6064);
	angles[7] = (0, 4.5015, 0);
	at[7] = 0.5833;
	points[8] = (-1675.4882, 10191.2207, 3909.6064);
	angles[8] = (0, -25.6270, 0);
	at[8] = 0.6667;
	points[9] = (-1570.9607, 10129.7246, 3909.6064);
	angles[9] = (0, -56.2499, 0);
	at[9] = 0.7500;
	points[10] = (-1481.9174, 10077.0869, 3909.6064);
	angles[10] = (0, -80.2464, 0);
	at[10] = 0.8333;
	points[11] = (-1387.8110, 10021.2598, 3909.6064);
	angles[11] = (0, -96.2475, 0);
	at[11] = 0.9167;
	points[12] = (-1190.8937, 9903.9375, 3909.6064);
	angles[12] = (0, -112.1457, 0);
	at[12] = 1.0833;
	points[13] = (-1004.3228, 9792.2441, 3909.6064);
	angles[13] = (0, -117.8595, 0);
	at[13] = 1.2500;
	points[14] = (-809.5511, 9675.1572, 3909.6064);
	angles[14] = (0, -119.9218, 0);
	at[14] = 1.4167;
	points[15] = (-621.6968, 9561.8105, 3909.6064);
	angles[15] = (0, -120.7005, 0);
	at[15] = 1.5833;
	points[16] = (-145.0559, 9272.4805, 3909.6064);
	angles[16] = (0, -121.2635, 0);
	at[16] = 2;
	points[17] = (42.7134, 9157.7559, 3909.6064);
	angles[17] = (0, -121.3739, 0);
	at[17] = 2.1667;
	points[18] = (235.7224, 9039.3701, 3909.6064);
	angles[18] = (0, -121.4828, 0);
	at[18] = 2.3333;
	points[19] = (516.8898, 8865.7871, 3909.6064);
	angles[19] = (0, -121.6716, 0);
	at[19] = 2.5833;
	points[20] = (615.3779, 8804.6064, 3909.6064);
	angles[20] = (0, -121.7503, 0);
	at[20] = 2.6667;
	points[21] = (709.4331, 8745.9453, 3909.6064);
	angles[21] = (0, -121.8410, 0);
	at[21] = 2.7500;
	points[22] = (798.5670, 8690.0791, 3909.6064);
	angles[22] = (0, -121.9455, 0);
	at[22] = 2.8333;
	points[23] = (994.0394, 8566.2988, 3909.6064);
	angles[23] = (0, -122.2447, 0);
	at[23] = 3;
	points[24] = (1080.3781, 8510.7871, 3909.6064);
	angles[24] = (0, -122.4731, 0);
	at[24] = 3.0833;
	points[25] = (1181.9528, 8444.1338, 3909.6064);
	angles[25] = (0, -122.8369, 0);
	at[25] = 3.1667;
	points[26] = (1264.6182, 8387.5195, 3909.6064);
	angles[26] = (0, -123.6196, 0);
	at[26] = 3.2500;
	points[27] = (1349.0747, 8321.6934, 3908.8818);
	angles[27] = (0, -125.6620, -0.2110);
	at[27] = 3.3333;
	points[28] = (1428.2402, 8245.1963, 3906.0276);
	angles[28] = (0, -129.5134, -0.8050);
	at[28] = 3.4167;
	points[29] = (1494.2441, 8157.4414, 3900.8347);
	angles[29] = (0, -135.6841, -1.6622);
	at[29] = 3.5000;
	points[30] = (1538.4094, 8056.1421, 3894.0828);
	angles[30] = (0, -145.0073, -2.4566);
	at[30] = 3.5833;
	points[31] = (1550.7677, 7946.8110, 3890.1064);
	angles[31] = (0, -157.4303, -2.1645);
	at[31] = 3.6667;
	points[32] = (1536.3977, 7837.9927, 3899.5867);
	angles[32] = (0, -169.8867, 1.4293);
	at[32] = 3.7500;
	points[33] = (1511.0040, 7740.9058, 3939.2126);
	angles[33] = (0, -179.9982, 10.5906);
	at[33] = 3.8333;
	points[34] = (1468.9961, 7653.0312, 3992.2048);
	angles[34] = (0, -189.8431, 18.3615);
	at[34] = 3.9167;
	points[35] = (1371.4095, 7486.2598, 4103.6221);
	angles[35] = (0, -203.0590, 26.3076);
	at[35] = 4.0833;
	points[36] = (1262.7441, 7327.3228, 4216.1812);
	angles[36] = (0, -210.6687, 29.0161);
	at[36] = 4.2500;
	points[37] = (1203.2756, 7251.1807, 4271.7324);
	angles[37] = (0, -213.8345, 29.3968);
	at[37] = 4.3333;
	points[38] = (1138.0315, 7180.6694, 4324.3701);
	angles[38] = (0, -217.9917, 29.0655);
	at[38] = 4.4167;
	points[39] = (1049.9055, 7129.4883, 4361.4565);
	angles[39] = (0, -228.6665, 24.7807);
	at[39] = 4.5000;
	points[40] = (942.8307, 7105.3545, 4367.8350);
	angles[40] = (0, -241.7040, 16.1786);
	at[40] = 4.5833;
	points[41] = (832.9922, 7109.2129, 4363.0708);
	angles[41] = (0, -254.8242, 8.9052);
	at[41] = 4.6667;
	points[42] = (724.0472, 7133.8584, 4356.7720);
	angles[42] = (0, -266.5957, 4.1642);
	at[42] = 4.7500;
	points[43] = (621.0866, 7171.1421, 4352.0474);
	angles[43] = (0, -276.3552, 1.5566);
	at[43] = 4.8333;
	points[44] = (520.7953, 7217.5195, 4349.2915);
	angles[44] = (0, -284.0946, 0.4011);
	at[44] = 4.9167;
	points[45] = (424.9016, 7269.2915, 4348.4644);
	angles[45] = (0, -290.0925, 0.1171);
	at[45] = 5;
	points[46] = (340.9378, 7319.0156, 4348.4644);
	angles[46] = (0, -294.4440, 0.0695);
	at[46] = 5.0833;
	points[47] = (236.1894, 7382.9526, 4348.4644);
	angles[47] = (0, -297.3273, 0.0411);
	at[47] = 5.1667;
	points[48] = (149.4528, 7436.6929, 4348.4644);
	angles[48] = (0, -299.1593, 0.0243);
	at[48] = 5.2500;
	points[49] = (-46.5461, 7559.4487, 4348.4644);
	angles[49] = (0, -301.0762, 0.0085);
	at[49] = 5.4167;
	points[50] = (-135.4567, 7615.5513, 4348.4644);
	angles[50] = (0, -301.5643, 0.0050);
	at[50] = 5.5000;
	points[51] = (-229.0740, 7674.8423, 4348.4644);
	angles[51] = (0, -301.8900, 0.0030);
	at[51] = 5.5833;
	points[52] = (-326.9079, 7737.0083, 4348.4644);
	angles[52] = (0, -302.1156, 0.0018);
	at[52] = 5.6667;
	points[53] = (-605.4173, 7914.8818, 4348.4644);
	angles[53] = (0, -302.4945, 0);
	at[53] = 5.9167;
	points[54] = (-795.6299, 8037.0078, 4348.4644);
	angles[54] = (0, -302.6416, 0);
	at[54] = 6.0833;
	points[55] = (-1074.2677, 8216.8115, 4348.4644);
	angles[55] = (0, -302.8116, 0);
	at[55] = 6.3333;
	points[56] = (-1632.9922, 8580.5117, 4348.4644);
	angles[56] = (0, -303.1282, 0);
	at[56] = 6.8333;
	points[57] = (-1822.0117, 8704.6855, 4348.4644);
	angles[57] = (0, -303.2529, 0);
	at[57] = 7;
	points[58] = (-2001.9646, 8823.5830, 4348.4644);
	angles[58] = (0, -303.3987, 0);
	at[58] = 7.1667;
	points[59] = (-2100.2480, 8888.8584, 4348.4644);
	angles[59] = (0, -303.4858, 0);
	at[59] = 7.2500;
	points[60] = (-2194.2402, 8951.5752, 4348.4644);
	angles[60] = (0, -303.5876, 0);
	at[60] = 7.3333;
	points[61] = (-2374.0120, 9072.5586, 4348.4644);
	angles[61] = (0, -303.8464, 0);
	at[61] = 7.5000;
	points[62] = (-2472.4568, 9139.6064, 4348.4644);
	angles[62] = (0, -304.0352, 0);
	at[62] = 7.5833;
	points[63] = (-2559.9133, 9199.9609, 4348.4644);
	angles[63] = (0, -304.2906, 0);
	at[63] = 7.6667;
	points[64] = (-2653.5630, 9265.8662, 4348.4644);
	angles[64] = (0, -304.6704, 0);
	at[64] = 7.7500;
	points[65] = (-2741.2559, 9330.3154, 4348.4644);
	angles[65] = (0, -305.4928, 0);
	at[65] = 7.8333;
	points[66] = (-2819.5276, 9397.7949, 4348.4644);
	angles[66] = (0, -308.0294, 0);
	at[66] = 7.9167;
	points[67] = (-2886.0039, 9482.9131, 4348.4644);
	angles[67] = (0, -314.7004, 0);
	at[67] = 8;
	points[68] = (-2911.9055, 9589.2910, 4348.4644);
	angles[68] = (0, -329.1503, 0);
	at[68] = 8.0833;
	points[69] = (-2876.2759, 9692.8740, 4348.4644);
	angles[69] = (0, -349.6667, 0);
	at[69] = 8.1667;
	points[70] = (-2817.4253, 9787.0078, 4348.4644);
	angles[70] = (0, -366.2221, 0);
	at[70] = 8.2500;
	points[71] = (-2797.4763, 9838.0703, 4348.4644);
	angles[71] = (0, -369.6003, 0);
	at[71] = 8.3333;
	points[72] = (-2847.1062, 9739.3701, 4348.4644);
	angles[72] = (0, -355.6700, 0);
	at[72] = 8.4167;
	points[73] = (-2900.2756, 9642.4805, 4348.4644);
	angles[73] = (0, -333.1815, 0);
	at[73] = 8.5000;
	points[74] = (-2906.7834, 9534.2920, 4348.4644);
	angles[74] = (0, -313.0220, 0);
	at[74] = 8.5833;
	points[75] = (-2855.5828, 9437.8740, 4348.4644);
	angles[75] = (0, -299.5212, 0);
	at[75] = 8.6667;
	points[76] = (-2777.5393, 9359.4102, 4348.4644);
	angles[76] = (0, -287.8702, 0);
	at[76] = 8.7500;
	points[77] = (-2701.7441, 9300.7480, 4348.4644);
	angles[77] = (0, -272.9943, 0);
	at[77] = 8.8333;
	points[78] = (-2598.8386, 9227.1260, 4348.4644);
	angles[78] = (0, -250.4858, 0);
	at[78] = 8.9167;
	points[79] = (-2517.2283, 9170.3936, 4348.4644);
	angles[79] = (0, -220.5184, 0);
	at[79] = 9;
	points[80] = (-2424.0945, 9106.5752, 4348.4644);
	angles[80] = (0, -189.7421, 0);
	at[80] = 9.0833;
	points[81] = (-2325.5159, 9039.7637, 4348.4644);
	angles[81] = (0, -165.3654, 0);
	at[81] = 9.1667;
	points[82] = (-2239.0315, 8981.5752, 4348.4644);
	angles[82] = (0, -148.9920, 0);
	at[82] = 9.2500;
	points[83] = (-2147.3977, 8920.2754, 4348.4644);
	angles[83] = (0, -138.7937, 0);
	at[83] = 9.3333;
	points[84] = (-2051.1299, 8856.1816, 4348.4644);
	angles[84] = (0, -132.6152, 0);
	at[84] = 9.4167;
	points[85] = (-1775.0789, 8673.7793, 4348.4644);
	angles[85] = (0, -125.3131, 0);
	at[85] = 9.6667;
	points[86] = (-1680.5197, 8611.6533, 4348.4644);
	angles[86] = (0, -124.4846, 0);
	at[86] = 9.7500;
	points[87] = (-1585.7834, 8549.6064, 4348.4644);
	angles[87] = (0, -123.9676, 0);
	at[87] = 9.8333;
	points[88] = (-748.4331, 8006.6538, 4348.4644);
	angles[88] = (0, -122.8285, 0);
	at[88] = 10.5833;
	points[89] = (-558.0472, 7884.5273, 4348.4644);
	angles[89] = (0, -122.7213, 0);
	at[89] = 10.7500;
	points[90] = (-375.7063, 7768.0713, 4348.4644);
	angles[90] = (0, -122.6088, 0);
	at[90] = 10.9167;
	points[91] = (-181.2831, 7644.5669, 4348.4644);
	angles[91] = (0, -122.4774, 0);
	at[91] = 11.0833;
	points[92] = (0.5353, 7529.8423, 4348.4644);
	angles[92] = (0, -122.3127, 0);
	at[92] = 11.2500;
	points[93] = (102.5394, 7465.9058, 4348.4644);
	angles[93] = (0, -122.2016, 0);
	at[93] = 11.3333;
	points[94] = (286.9173, 7351.8110, 4348.4644);
	angles[94] = (0, -121.8629, 0);
	at[94] = 11.5000;
	points[95] = (387.6653, 7291.0630, 4348.4644);
	angles[95] = (0, -121.4920, 0);
	at[95] = 11.5833;
	points[96] = (472.8858, 7242.5986, 4348.6616);
	angles[96] = (0, -120.6221, 0.0639);
	at[96] = 11.6667;
	points[97] = (571.4449, 7193.0317, 4350.4331);
	angles[97] = (0, -118.8129, 0.4767);
	at[97] = 11.7500;
	points[98] = (673.6221, 7150.6694, 4354.2520);
	angles[98] = (0, -115.9557, 1.1526);
	at[98] = 11.8333;
	points[99] = (779.0906, 7119.2129, 4359.8818);
	angles[99] = (0, -111.7231, 1.9289);
	at[99] = 11.9167;
	points[100] = (888.2441, 7104.1733, 4365.9844);
	angles[100] = (0, -105.4568, 2.4150);
	at[100] = 12;
	points[101] = (997.9173, 7113.8584, 4367.0869);
	angles[101] = (0, -96.2928, 1.3594);
	at[101] = 12.0833;
	points[102] = (1098.3937, 7150.7090, 4347.5986);
	angles[102] = (0, -85.0035, -4.5509);
	at[102] = 12.1667;
	points[103] = (1172.0237, 7215.1973, 4298.4253);
	angles[103] = (0, -70.9112, -14.3925);
	at[103] = 12.2500;
	points[104] = (1234.6812, 7290.2759, 4243.0708);
	angles[104] = (0, -59.0524, -21.2263);
	at[104] = 12.3333;
	points[105] = (1291.6615, 7367.3232, 4187.4409);
	angles[105] = (0, -50.1939, -25.2890);
	at[105] = 12.4167;
	points[106] = (1396.8623, 7527.0869, 4075.5510);
	angles[106] = (0, -39.1087, -28.7991);
	at[106] = 12.5833;
	points[107] = (1445.5315, 7609.9219, 4020.0396);
	angles[107] = (0, -35.4492, -29.3419);
	at[107] = 12.6667;
	points[108] = (1490.4882, 7695.4722, 3965.7876);
	angles[108] = (0, -32.0698, -29.3184);
	at[108] = 12.7500;
	points[109] = (1527.6772, 7789.2520, 3914.6812);
	angles[109] = (0, -26.9446, -28.0819);
	at[109] = 12.8333;
	points[110] = (1545.7520, 7892.4014, 3892.0906);
	angles[110] = (0, -19.3776, -20.9451);
	at[110] = 12.9167;
	points[111] = (1548.7009, 8002.4805, 3891.2874);
	angles[111] = (0, -10.9889, -12.4832);
	at[111] = 13;
	points[112] = (1519.6182, 8108.8193, 3897.5354);
	angles[112] = (0, 0.6820, -6.2740);
	at[112] = 13.0833;
	points[113] = (1463.5591, 8202.5986, 3903.6970);
	angles[113] = (0, 13.5472, -2.5901);
	at[113] = 13.1667;
	points[114] = (1389.6890, 8284.8818, 3907.7480);
	angles[114] = (0, 25.4682, -0.7895);
	at[114] = 13.2500;
	points[115] = (1306.0984, 8356.6533, 3909.4844);
	angles[115] = (0, 35.4764, -0.1703);
	at[115] = 13.3333;
	points[116] = (1227.4724, 8413.4258, 3909.6064);
	angles[116] = (0, 43.2968, -0.0925);
	at[116] = 13.4167;
	points[117] = (1126.9213, 8480.4727, 3909.6064);
	angles[117] = (0, 48.6581, -0.0551);
	at[117] = 13.5000;
	points[118] = (946.2874, 8596.7715, 3909.6064);
	angles[118] = (0, 54.2998, -0.0193);
	at[118] = 13.6667;
	points[119] = (843.9843, 8661.4961, 3909.6064);
	angles[119] = (0, 55.6914, -0.0114);
	at[119] = 13.7500;
	points[120] = (662.5591, 8775.2363, 3909.6064);
	angles[120] = (0, 57.1662, -0.0040);
	at[120] = 13.9167;
	points[121] = (466.6418, 8896.9287, 3909.6064);
	angles[121] = (0, 57.8238, -0.0014);
	at[121] = 14.0833;
	points[122] = (282.7189, 9010.4336, 3909.6064);
	angles[122] = (0, 58.1565, 0);
	at[122] = 14.2500;
	points[123] = (90.1264, 9128.7402, 3909.6064);
	angles[123] = (0, 58.3553, 0);
	at[123] = 14.4167;
	points[124] = (-574.6614, 9533.3467, 3909.6064);
	angles[124] = (0, 58.7478, 0);
	at[124] = 15;
	points[125] = (-763.3937, 9647.3232, 3909.6064);
	angles[125] = (0, 58.8370, 0);
	at[125] = 15.1667;
	points[126] = (-1052.2716, 9820.9844, 3909.6064);
	angles[126] = (0, 58.9754, 0);
	at[126] = 15.4167;
	points[127] = (-1238.7166, 9932.4805, 3909.6064);
	angles[127] = (0, 59.0776, 0);
	at[127] = 15.5833;
	points[128] = (-1339.4646, 9992.5195, 3909.6064);
	angles[128] = (0, 59.1362, 0);
	at[128] = 15.6667;
	points[129] = (-1435.8977, 10049.8037, 3909.6064);
	angles[129] = (0, 59.2021, 0);
	at[129] = 15.7500;
	points[130] = (-1527.5118, 10104.0557, 3909.6064);
	angles[130] = (0, 59.2764, 0);
	at[130] = 15.8333;
	points[131] = (-1623.8110, 10160.8662, 3909.6064);
	angles[131] = (0, 59.3626, 0);
	at[131] = 15.9167;
	points[132] = (-1725.5198, 10220.4727, 3909.6064);
	angles[132] = (0, 59.4756, 0);
	at[132] = 16;
	points[133] = (-1816.3740, 10273.3467, 3909.6064);
	angles[133] = (0, 59.6240, 0);
	at[133] = 16.0833;
	points[134] = (-1917.4606, 10331.4570, 3909.6064);
	angles[134] = (0, 59.8433, 0);
	at[134] = 16.1667;
	points[135] = (-2010.5118, 10383.5039, 3909.6064);
	angles[135] = (0, 60.3088, 0);
	at[135] = 16.2500;
	points[136] = (-2103.7087, 10430.1182, 3909.6064);
	angles[136] = (0, 61.8280, 0);
	at[136] = 16.3333;
	points[137] = (-2205.3308, 10465.6299, 3909.6064);
	angles[137] = (0, 66.1832, 0);
	at[137] = 16.4167;
	points[138] = (-2313.9805, 10458.1094, 3909.6064);
	angles[138] = (0, 79.7691, 0);
	at[138] = 16.5000;
	points[139] = (-2381.7205, 10372.4805, 3909.6064);
	angles[139] = (0, 103.8050, 0);
	at[139] = 16.5833;
	points[140] = (-2425.9802, 10342.4414, 3909.6064);
	angles[140] = (0, 107.8091, 0);
	at[140] = 16.6333;
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
