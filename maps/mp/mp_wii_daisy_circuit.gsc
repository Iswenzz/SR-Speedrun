main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_wii_daisy_circuit", 0);

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
	ambientPlay("iz_0_n_daisy32", 2);
	iz_emitter("iz_1_se_cc_env_sea", (7677.1655, 5019.6851, 743.1689), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (5928.2974, 4695.5439, 690.2085), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (4179.4297, 4371.4033, 637.2480), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (2430.5623, 4047.2629, 584.2877), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (734.5479, 4174.5532, 538.8228), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-961.4662, 4301.8433, 493.3580), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-2657.4805, 4429.1338, 447.8932), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-2890.3167, 6724.9336, 438.2265), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-2301.7500, 8562.2607, 438.2265), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-1713.1832, 10399.5869, 438.2265), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-6216.6577, 4362.7280, 438.2265), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-6216.3706, 5581.1475, 438.2265), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-6216.0840, 6799.5669, 438.2265), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-6802.9551, 8597.5938, 438.2265), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-7389.8262, 10395.6211, 438.2265), 0, 12.0104);
	iz_emitter("iz_2_se_cc_env_fountain", (1778.1523, -1027.6780, 736.5153), 0, 12.0104);
	iz_emitter("iz_2_se_cc_env_fountain", (-2436.0820, -1032.2908, 736.5153), 0, 12.0104);
	iz_emitter("iz_3_se_cc_env_audience", (3838.5828, 2509.8425, 439.9606), 0, 12.0104);
	iz_emitter("iz_3_se_cc_env_audience", (1919.2914, 2362.2048, 439.9606), 0, 12.0104);
	iz_emitter("iz_3_se_cc_env_audience", (0, 2214.5669, 439.9606), 0, 12.0104);
	iz_emitter("iz_3_se_cc_env_audience", (-1254.9213, 2436.0237, 439.9606), 0, 12.0104);
	iz_emitter("iz_3_se_cc_env_audience", (-2509.8425, 2657.4805, 439.9606), 0, 12.0104);
	iz_emitter("iz_4_se_cc_env_audience_m", (3465.7046, -2889.9758, 664.3701), 0, 12.0104);
	iz_emitter("iz_4_se_cc_env_audience_m", (1599.5743, -2889.7576, 664.3701), 0, 12.0104);
	iz_emitter("iz_4_se_cc_env_audience_m", (-266.5557, -2889.5396, 664.3701), 0, 12.0104);
	iz_emitter("iz_4_se_cc_env_audience_m", (-2132.6858, -2889.3215, 664.3701), 0, 12.0104);
	iz_emitter("iz_4_se_cc_env_audience_m", (-3998.8159, -2889.1033, 664.3701), 0, 12.0104);
	iz_emitter("iz_4_se_cc_env_audience_m", (3464.0967, 816.1143, 679.8129), 0, 12.0104);
	iz_emitter("iz_4_se_cc_env_audience_m", (1619.5615, 813.1102, 679.8129), 0, 12.0104);
	iz_emitter("iz_4_se_cc_env_audience_m", (-224.9736, 810.1061, 679.8129), 0, 12.0104);
	iz_emitter("iz_4_se_cc_env_audience_m", (-2069.5085, 807.1019, 679.8129), 0, 12.0104);
	iz_emitter("iz_4_se_cc_env_audience_m", (-3914.0437, 804.0978, 679.8129), 0, 12.0104);
	iz_emitter("iz_4_se_cc_env_audience_m", (-4995.5298, -121.1739, 679.8129), 0, 12.0104);
}

iz_emitter(alias, origin, interval, length)
{
	ent = spawn("script_origin", origin);
	if (interval <= 0)
		ent playLoopSound(alias);
	else
		ent thread iz_emitter_random(alias, interval, length);
}

// One play at a time: copies started over one another ran out the
// engine's 32 voices, and the sounds that lost theirs restarted.
iz_emitter_random(alias, interval, length)
{
	for (;;)
	{
		wait(randomFloatRange(interval * 0.25, interval));
		self playSound(alias);
		wait(length);
	}
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
	level.iz_route[level.iz_route.size] = (1626, 2955, 295);
	level.iz_route[level.iz_route.size] = (3303, 3206, 299);
	level.iz_route[level.iz_route.size] = (4923, 3732, 441);
	level.iz_route[level.iz_route.size] = (6055, 4060, 571);
	level.iz_route[level.iz_route.size] = (7248, 4064, 591);
	level.iz_route[level.iz_route.size] = (7949, 3420, 591);
	level.iz_route[level.iz_route.size] = (8880, 2666, 591);
	level.iz_route[level.iz_route.size] = (8883, 1283, 591);
	level.iz_route[level.iz_route.size] = (8130, 492, 591);
	level.iz_route[level.iz_route.size] = (6961, 478, 591);
	level.iz_route[level.iz_route.size] = (6662, -280, 591);
	level.iz_route[level.iz_route.size] = (6662, -696, 591);
	level.iz_route[level.iz_route.size] = (5605, -695, 591);
	level.iz_route[level.iz_route.size] = (4665, -696, 591);
	level.iz_route[level.iz_route.size] = (3633, -528, 591);
	level.iz_route[level.iz_route.size] = (3102, 116, 591);
	level.iz_route[level.iz_route.size] = (2372, 360, 591);
	level.iz_route[level.iz_route.size] = (1485, 359, 591);
	level.iz_route[level.iz_route.size] = (747, 86, 591);
	level.iz_route[level.iz_route.size] = (235, -539, 591);
	level.iz_route[level.iz_route.size] = (-619, -1539, 591);
	level.iz_route[level.iz_route.size] = (-1348, -2126, 591);
	level.iz_route[level.iz_route.size] = (-2115, -2417, 591);
	level.iz_route[level.iz_route.size] = (-3074, -2424, 591);
	level.iz_route[level.iz_route.size] = (-3826, -2143, 591);
	level.iz_route[level.iz_route.size] = (-4409, -1395, 591);
	level.iz_route[level.iz_route.size] = (-5450, -1038, 591);
	level.iz_route[level.iz_route.size] = (-6539, -1336, 571);
	level.iz_route[level.iz_route.size] = (-7452, -912, 538);
	level.iz_route[level.iz_route.size] = (-7727, -132, 514);
	level.iz_route[level.iz_route.size] = (-7374, 766, 478);
	level.iz_route[level.iz_route.size] = (-6611, 1143, 466);
	level.iz_route[level.iz_route.size] = (-5942, 1774, 457);
	level.iz_route[level.iz_route.size] = (-5808, 2640, 421);
	level.iz_route[level.iz_route.size] = (-5258, 3395, 350);
	level.iz_route[level.iz_route.size] = (-4885, 3883, 302);
	level.iz_route[level.iz_route.size] = (-4855, 4240, 295);
	level.iz_route[level.iz_route.size] = (-4855, 5059, 295);
	level.iz_route[level.iz_route.size] = (-4855, 5938, 295);
	level.iz_route[level.iz_route.size] = (-4856, 6847, 295);
	level.iz_route[level.iz_route.size] = (-5018, 7724, 295);
	level.iz_route[level.iz_route.size] = (-5704, 9281, 295);
	level.iz_route[level.iz_route.size] = (-5705, 10547, 295);
	level.iz_route[level.iz_route.size] = (-4663, 11255, 295);
	level.iz_route[level.iz_route.size] = (-3487, 10777, 295);
	level.iz_route[level.iz_route.size] = (-3245, 9537, 295);
	level.iz_route[level.iz_route.size] = (-4044, 7749, 295);
	level.iz_route[level.iz_route.size] = (-4223, 6853, 295);
	level.iz_route[level.iz_route.size] = (-4223, 6186, 295);
	level.iz_route[level.iz_route.size] = (-4221, 5418, 295);
	level.iz_route[level.iz_route.size] = (-4166, 4664, 296);
	level.iz_route[level.iz_route.size] = (-3917, 4160, 296);
	level.iz_route[level.iz_route.size] = (-2856, 3587, 295);
	level.iz_route[level.iz_route.size] = (-1208, 3130, 295);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-3586.5237, 9001.3779, 693.9843);
	angles[0] = (0, -39.2390, 0);
	at[0] = 0;
	points[1] = (-3558.9529, 9066.2207, 690.7244);
	angles[1] = (0, -30.2050, 0);
	at[1] = 0.1167;
	points[2] = (-3538.0315, 9135.8271, 687.7520);
	angles[2] = (0, -22.9428, 0);
	at[2] = 0.2333;
	points[3] = (-3520.5276, 9206.6533, 684.9370);
	angles[3] = (0, -18.0776, 0);
	at[3] = 0.3500;
	points[4] = (-3491.9568, 9348.5439, 679.6024);
	angles[4] = (0, -12.5964, 0);
	at[4] = 0.5833;
	points[5] = (-3469.3503, 9492.1260, 674.4016);
	angles[5] = (0, -9.5144, 0);
	at[5] = 0.8167;
	points[6] = (-3453.1143, 9635.7090, 669.2441);
	angles[6] = (0, -6.7872, 0);
	at[6] = 1.0500;
	points[7] = (-3448.6260, 9707.9131, 666.5984);
	angles[7] = (0, -4.8841, 0);
	at[7] = 1.1667;
	points[8] = (-3450.2048, 9777.9531, 663.8661);
	angles[8] = (0, -0.9583, 0);
	at[8] = 1.2833;
	points[9] = (-3463.3743, 9849.0156, 660.7913);
	angles[9] = (0, 5.4319, 0);
	at[9] = 1.4000;
	points[10] = (-3481.7598, 9919.4102, 657.6417);
	angles[10] = (0, 10.4139, 0);
	at[10] = 1.5167;
	points[11] = (-3525.3228, 10058.3467, 651.3583);
	angles[11] = (0, 16.1296, 0);
	at[11] = 1.7500;
	points[12] = (-3574.0552, 10194.8828, 645.2520);
	angles[12] = (0, 19.0629, 0);
	at[12] = 1.9833;
	points[13] = (-3656.6104, 10397.0869, 636.8307);
	angles[13] = (0, 22.5473, 0);
	at[13] = 2.3333;
	points[14] = (-3688.0984, 10460.1572, 634.8464);
	angles[14] = (0, 25.0651, 0);
	at[14] = 2.4500;
	points[15] = (-3730.7441, 10517.5195, 634.5787);
	angles[15] = (0, 31.7372, 0);
	at[15] = 2.5667;
	points[16] = (-3780.8228, 10570.6689, 635.3583);
	angles[16] = (0, 38.0280, 0);
	at[16] = 2.6833;
	points[17] = (-3833.1851, 10620.5508, 636.5945);
	angles[17] = (0, 42.5446, 0);
	at[17] = 2.8000;
	points[18] = (-3942.4805, 10715.9453, 639.7126);
	angles[18] = (0, 47.7113, 0);
	at[18] = 3.0333;
	points[19] = (-4109.7246, 10852.7959, 643.5669);
	angles[19] = (0, 50.7104, 0);
	at[19] = 3.3833;
	points[20] = (-4283.8584, 10983.1885, 645.5511);
	angles[20] = (0, 53.2014, 0);
	at[20] = 3.7333;
	points[21] = (-4402.2837, 11067.4414, 647.7402);
	angles[21] = (0, 54.4218, 0);
	at[21] = 3.9667;
	points[22] = (-4520.9448, 11145.3936, 652.4685);
	angles[22] = (0, 56.4924, 0);
	at[22] = 4.2000;
	points[23] = (-4954.4487, 11411.3779, 676.5197);
	angles[23] = (0, 58.7418, 0);
	at[23] = 5.0167;
	points[24] = (-5142.5591, 11523.1104, 687.2874);
	angles[24] = (0, 59.4370, 0);
	at[24] = 5.3667;
	points[25] = (-5203.1104, 11556.3789, 690.7205);
	angles[25] = (0, 60.4836, 0);
	at[25] = 5.4833;
	points[26] = (-5332.2837, 11621.5742, 698.1457);
	angles[26] = (0, 62.7933, 0);
	at[26] = 5.7167;
	points[27] = (-5528.6611, 11713.9766, 709.5354);
	angles[27] = (0, 64.8651, 0);
	at[27] = 6.0667;
	points[28] = (-5595.3540, 11743.4648, 713.3976);
	angles[28] = (0, 65.6214, 0);
	at[28] = 6.1833;
	points[29] = (-5660.7085, 11768.9375, 717.0906);
	angles[29] = (0, 67.4196, 0);
	at[29] = 6.3000;
	points[30] = (-6003.3071, 11889.4893, 736.3622);
	angles[30] = (0, 70.2519, 0);
	at[30] = 6.8833;
	points[31] = (-6069.9209, 11915.5117, 740.3977);
	angles[31] = (0, 69.2644, 0);
	at[31] = 7;
	points[32] = (-6134.3701, 11946.6143, 744.8386);
	angles[32] = (0, 66.2139, 0);
	at[32] = 7.1167;
	points[33] = (-6259.1338, 12019.2520, 754.5512);
	angles[33] = (0, 60.9808, 0);
	at[33] = 7.3500;
	points[34] = (-6382.2441, 12095.9844, 764.6496);
	angles[34] = (0, 58.5756, 0);
	at[34] = 7.5833;
	points[35] = (-6503.1494, 12176.1807, 775.1693);
	angles[35] = (0, 56.6518, 0);
	at[35] = 7.8167;
	points[36] = (-6559.4092, 12218.8975, 780.7993);
	angles[36] = (0, 54.0650, 0);
	at[36] = 7.9333;
	points[37] = (-6608.2285, 12271.9688, 787.9961);
	angles[37] = (0, 47.5648, 0);
	at[37] = 8.0500;
	points[38] = (-6651.3784, 12329.8037, 795.8819);
	angles[38] = (0, 41.6190, 0);
	at[38] = 8.1667;
	points[39] = (-6689.9609, 12390.6689, 804.0748);
	angles[39] = (0, 36.4789, 0);
	at[39] = 8.2833;
	points[40] = (-6720.6299, 12456.0635, 812.4960);
	angles[40] = (0, 29.6146, 0);
	at[40] = 8.4000;
	points[41] = (-6722.5195, 12526.5361, 819.9134);
	angles[41] = (0, 14.0062, 0);
	at[41] = 8.5167;
	points[42] = (-6712.2441, 12598.1504, 826.9056);
	angles[42] = (0, 2.1466, 0);
	at[42] = 8.6333;
	points[43] = (-6695.7485, 12668.3066, 833.8032);
	angles[43] = (0, -6.2149, 0);
	at[43] = 8.7500;
	points[44] = (-6668.9766, 12735.5908, 840.9685);
	angles[44] = (0, -15.4240, 0);
	at[44] = 8.8667;
	points[45] = (-6619.0161, 12785.4727, 847.9016);
	angles[45] = (0, -31.6022, 0);
	at[45] = 8.9833;
	points[46] = (-6561.1816, 12828.8975, 854.5945);
	angles[46] = (0, -43.0409, 0);
	at[46] = 9.1000;
	points[47] = (-6500.5908, 12868.4258, 861.1771);
	angles[47] = (0, -50.4805, 0);
	at[47] = 9.2167;
	points[48] = (-6437.7954, 12903.8184, 867.7008);
	angles[48] = (0, -56.0394, 0);
	at[48] = 9.3333;
	points[49] = (-6372.6772, 12932.5986, 874.1575);
	angles[49] = (0, -61.8924, 0);
	at[49] = 9.4500;
	points[50] = (-6304.8818, 12953.3477, 880.6812);
	angles[50] = (0, -67.8780, 0);
	at[50] = 9.5667;
	points[51] = (-6164.6851, 12990.3936, 894.0316);
	angles[51] = (0, -73.7063, 0);
	at[51] = 9.8000;
	points[52] = (-5812.0864, 13071.8896, 926.1693);
	angles[52] = (0, -77.5193, 0);
	at[52] = 10.3833;
	points[53] = (-5670.9453, 13098.1895, 937.4410);
	angles[53] = (0, -79.4181, 0);
	at[53] = 10.6167;
	points[54] = (-5456.6147, 13122.3232, 950.8741);
	angles[54] = (0, -83.4934, 0);
	at[54] = 10.9667;
	points[55] = (-5095.3154, 13152.7168, 970.8977);
	angles[55] = (0, -85.4997, 0);
	at[55] = 11.5500;
	points[56] = (-4804.5669, 13168.7402, 983.0552);
	angles[56] = (0, -87.4153, 0);
	at[56] = 12.0167;
	points[57] = (-4736.7324, 13168.3467, 983.5551);
	angles[57] = (0, -89.1427, 0);
	at[57] = 12.1333;
	points[58] = (-4519.0552, 13154.4883, 977.9016);
	angles[58] = (0, -93.5671, 0);
	at[58] = 12.4833;
	points[59] = (-4229.7637, 13127.4414, 966.2638);
	angles[59] = (0, -95.5092, 0);
	at[59] = 12.9500;
	points[60] = (-4014.5671, 13103.4648, 957.3504);
	angles[60] = (0, -96.4461, 0);
	at[60] = 13.3000;
	points[61] = (-3945.1575, 13094.4092, 955.1929);
	angles[61] = (0, -97.0692, 0);
	at[61] = 13.4167;
	points[62] = (-3729.6299, 13059.5283, 951.2834);
	angles[62] = (0, -99.2226, 0);
	at[62] = 13.7667;
	points[63] = (-3515.3345, 13020, 947.9489);
	angles[63] = (0, -100.5328, 0);
	at[63] = 14.1167;
	points[64] = (-3373.1731, 12989.9609, 945.3780);
	angles[64] = (0, -101.8448, 0);
	at[64] = 14.3500;
	points[65] = (-3302.3032, 12971.4170, 943.5275);
	angles[65] = (0, -103.6306, 0);
	at[65] = 14.4667;
	points[66] = (-3238.5513, 12942.7959, 939.8622);
	angles[66] = (0, -109.8186, 0);
	at[66] = 14.5833;
	points[67] = (-3177.5789, 12903.9375, 934.5551);
	angles[67] = (0, -116.8171, 0);
	at[67] = 14.7000;
	points[68] = (-3120.1614, 12859.8428, 928.4764);
	angles[68] = (0, -122.6797, 0);
	at[68] = 14.8167;
	points[69] = (-3066.5471, 12811.2598, 921.8386);
	angles[69] = (0, -127.9910, 0);
	at[69] = 14.9333;
	points[70] = (-3022.6379, 12756.2207, 914.7244);
	angles[70] = (0, -136.5106, 0);
	at[70] = 15.0500;
	points[71] = (-3005.5630, 12685.9053, 906.8111);
	angles[71] = (0, -152.7766, 0);
	at[71] = 15.1667;
	points[72] = (-2998.6182, 12614.2520, 898.9370);
	angles[72] = (0, -164.3110, 0);
	at[72] = 15.2833;
	points[73] = (-2996.6301, 12542.2041, 890.9606);
	angles[73] = (0, -171.9041, 0);
	at[73] = 15.4000;
	points[74] = (-3000.5276, 12470, 882.6614);
	angles[74] = (0, -178.2247, 0);
	at[74] = 15.5167;
	points[75] = (-3021.1179, 12402.2842, 873.4213);
	angles[75] = (0, -188.8378, 0);
	at[75] = 15.6333;
	points[76] = (-3084.2046, 12273.3467, 854.1732);
	angles[76] = (0, -202.7438, 0);
	at[76] = 15.8667;
	points[77] = (-3120.1851, 12210.7871, 844.8859);
	angles[77] = (0, -206.6756, 0);
	at[77] = 15.9833;
	points[78] = (-3160.4133, 12152.2041, 836.7441);
	angles[78] = (0, -211.4131, 0);
	at[78] = 16.1000;
	points[79] = (-3211.0789, 12101.3779, 831.2638);
	angles[79] = (0, -218.8525, 0);
	at[79] = 16.2167;
	points[80] = (-3265.5828, 12053.3066, 826.6260);
	angles[80] = (0, -224.0868, 0);
	at[80] = 16.3333;
	points[81] = (-3378.7559, 11962.7168, 818.2874);
	angles[81] = (0, -230.0880, 0);
	at[81] = 16.5667;
	points[82] = (-3437.9094, 11920.7871, 814.3937);
	angles[82] = (0, -232.7090, 0);
	at[82] = 16.6833;
	points[83] = (-3498.8779, 11885.7490, 810.8937);
	angles[83] = (0, -236.9421, 0);
	at[83] = 16.8000;
	points[84] = (-3694.7954, 11790.4326, 801.0867);
	angles[84] = (0, -243.6086, 0);
	at[84] = 17.1500;
	points[85] = (-3958.7402, 11668.1494, 788.5630);
	angles[85] = (0, -245.1169, 0);
	at[85] = 17.6167;
	points[86] = (-4022.2048, 11639.2520, 785.7480);
	angles[86] = (0, -245.4017, 0);
	at[86] = 17.7333;
	points[87] = (-4419.8428, 11462.7559, 769.1654);
	angles[87] = (0, -245.4585, 0);
	at[87] = 18.4333;
	points[88] = (-4485.3936, 11430.3936, 766.2126);
	angles[88] = (0, -244.4150, 0);
	at[88] = 18.5500;
	points[89] = (-4547.1260, 11396.2598, 763.1299);
	angles[89] = (0, -242.5316, 0);
	at[89] = 18.6667;
	points[90] = (-4733.5830, 11286.3389, 753.2205);
	angles[90] = (0, -239.6341, 0);
	at[90] = 19.0167;
	points[91] = (-4981.4961, 11134.2920, 739.7087);
	angles[91] = (0, -238.2793, 0);
	at[91] = 19.4833;
	points[92] = (-5164.2129, 11014.5283, 729.5315);
	angles[92] = (0, -236.3545, 0);
	at[92] = 19.8333;
	points[93] = (-5218.5430, 10971.0635, 726.3582);
	angles[93] = (0, -233.3555, 0);
	at[93] = 19.9500;
	points[94] = (-5270.6694, 10921.7314, 723.1772);
	angles[94] = (0, -229.6143, 0);
	at[94] = 20.0667;
	points[95] = (-5418.3071, 10762.0869, 713.7087);
	angles[95] = (0, -222.8179, 0);
	at[95] = 20.4167;
	points[96] = (-5510.5117, 10650.6299, 707.2953);
	angles[96] = (0, -219.9834, 0);
	at[96] = 20.6500;
	points[97] = (-5592.0469, 10532.7168, 699.4843);
	angles[97] = (0, -215.2585, 0);
	at[97] = 20.8833;
	points[98] = (-5703.2681, 10345.7871, 686.5512);
	angles[98] = (0, -210.6113, 0);
	at[98] = 21.2333;
	points[99] = (-5767.8350, 10215.9062, 679.9055);
	angles[99] = (0, -206.6410, 0);
	at[99] = 21.4667;
	points[100] = (-5788.7012, 10149.0938, 679.4843);
	angles[100] = (0, -200.9114, 0);
	at[100] = 21.5833;
	points[101] = (-5799.4092, 10076.4961, 682.0630);
	angles[101] = (0, -194.1200, 0);
	at[101] = 21.7000;
	points[102] = (-5811.6934, 9932.3232, 689.2559);
	angles[102] = (0, -186.6499, 0);
	at[102] = 21.9333;
	points[103] = (-5819.0942, 9714.6455, 701.6771);
	angles[103] = (0, -181.8852, 0);
	at[103] = 22.2833;
	points[104] = (-5818.0713, 9642.5195, 705.8740);
	angles[104] = (0, -180.3114, 0);
	at[104] = 22.4000;
	points[105] = (-5812.0474, 9572.9531, 709.7087);
	angles[105] = (0, -177.0398, 0);
	at[105] = 22.5167;
	points[106] = (-5797.8345, 9500.7090, 713.6812);
	angles[106] = (0, -172.5470, 0);
	at[106] = 22.6333;
	points[107] = (-5762.3232, 9360.7090, 721.5079);
	angles[107] = (0, -167.0030, 0);
	at[107] = 22.8667;
	points[108] = (-5720.8271, 9221.5752, 729.2638);
	angles[108] = (0, -163.9439, 0);
	at[108] = 23.1000;
	points[109] = (-5672.0864, 9085.7480, 736.5945);
	angles[109] = (0, -160.4692, 0);
	at[109] = 23.3333;
	points[110] = (-5638.7402, 9022.4023, 739.5433);
	angles[110] = (0, -155.4928, 0);
	at[110] = 23.4500;
	points[111] = (-5597.7954, 8963.5039, 741.7992);
	angles[111] = (0, -149.8912, 0);
	at[111] = 23.5667;
	points[112] = (-5507.9526, 8849.2920, 745.7913);
	angles[112] = (0, -143.2923, 0);
	at[112] = 23.8000;
	points[113] = (-5412.7954, 8739.8027, 749.5197);
	angles[113] = (0, -139.6598, 0);
	at[113] = 24.0333;
	points[114] = (-5362.4409, 8686.8115, 751.3977);
	angles[114] = (0, -137.8093, 0);
	at[114] = 24.1500;
	points[115] = (-5310.6299, 8639.8428, 753.3347);
	angles[115] = (0, -134.3208, 0);
	at[115] = 24.2667;
	points[116] = (-5251.0239, 8596.9688, 755.9095);
	angles[116] = (0, -129.5994, 0);
	at[116] = 24.3833;
	points[117] = (-5128.6616, 8520.1572, 761.2126);
	angles[117] = (0, -123.3888, 0);
	at[117] = 24.6167;
	points[118] = (-5000.7871, 8452.0479, 765.9016);
	angles[118] = (0, -118.6610, 0);
	at[118] = 24.8500;
	points[119] = (-4933.7798, 8423.4258, 767.6142);
	angles[119] = (0, -115.4535, 0);
	at[119] = 24.9667;
	points[120] = (-4864.4097, 8404.1338, 768.1299);
	angles[120] = (0, -109.3654, 0);
	at[120] = 25.0833;
	points[121] = (-4794.3701, 8402.0479, 766.4528);
	angles[121] = (0, -99.6933, 0);
	at[121] = 25.2000;
	points[122] = (-4721.7324, 8405.9053, 763.9606);
	angles[122] = (0, -92.8813, 0);
	at[122] = 25.3167;
	points[123] = (-4504.9214, 8430.2363, 755.1575);
	angles[123] = (0, -83.9661, 0);
	at[123] = 25.6667;
	points[124] = (-4290.5513, 8468.8193, 745.3622);
	angles[124] = (0, -79.4568, 0);
	at[124] = 26.0167;
	points[125] = (-4220.1577, 8486.6934, 741.8819);
	angles[125] = (0, -77.2889, 0);
	at[125] = 26.1333;
	points[126] = (-4153.7793, 8510.4727, 738.3110);
	angles[126] = (0, -72.9169, 0);
	at[126] = 26.2500;
	points[127] = (-4092.4016, 8545.9453, 734.3425);
	angles[127] = (0, -65.7418, 0);
	at[127] = 26.3667;
	points[128] = (-4032.4805, 8587.0469, 730.0945);
	angles[128] = (0, -60.2428, 0);
	at[128] = 26.4833;
	points[129] = (-3916.9175, 8675.4727, 721.4252);
	angles[129] = (0, -53.9765, 0);
	at[129] = 26.7167;
	points[130] = (-3806.2561, 8768.7803, 712.7402);
	angles[130] = (0, -50.5089, 0);
	at[130] = 26.9500;
	points[131] = (-3700.0669, 8867.6377, 704.0670);
	angles[131] = (0, -47.4316, 0);
	at[131] = 27.1833;
	points[132] = (-3649.9175, 8919.8037, 699.8032);
	angles[132] = (0, -45.3812, 0);
	at[132] = 27.3000;
	points[133] = (-3603.2324, 8976.0234, 695.6221);
	angles[133] = (0, -42, 0);
	at[133] = 27.4167;
	points[134] = (-3586.5237, 9001.3779, 693.9843);
	angles[134] = (0, -39.2390, 0);
	at[134] = 27.4667;
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
	points[0] = (-3100.8110, 4323.8979, 547.5315);
	angles[0] = (0, -123.7835, 0);
	at[0] = 0;
	points[1] = (-2867.6614, 4162.8740, 536.9685);
	angles[1] = (0, -124.3831, 0);
	at[1] = 0.4000;
	points[2] = (-2788.2876, 4111.2598, 533.6457);
	angles[2] = (0, -123.4645, 0);
	at[2] = 0.5333;
	points[3] = (-2707.5789, 4065.3152, 531.4134);
	angles[3] = (0, -120.7877, 0);
	at[3] = 0.6667;
	points[4] = (-2533.1536, 3991.1812, 530.8504);
	angles[4] = (0, -114.0578, 0);
	at[4] = 0.9333;
	points[5] = (-2179.0120, 3854.4529, 532.2559);
	angles[5] = (0, -110.9064, 0);
	at[5] = 1.4667;
	points[6] = (-2002.6299, 3791.7126, 535.9843);
	angles[6] = (0, -109.5946, 0);
	at[6] = 1.7333;
	points[7] = (-1822.6536, 3731.3936, 541.6929);
	angles[7] = (0, -108.6476, 0);
	at[7] = 2;
	points[8] = (-1641.9686, 3673.1377, 546.1378);
	angles[8] = (0, -107.8874, 0);
	at[8] = 2.2667;
	points[9] = (-1552.8307, 3646.8977, 545.3307);
	angles[9] = (0, -106.8816, 0);
	at[9] = 2.4000;
	points[10] = (-1369.8188, 3599.5747, 535.9803);
	angles[10] = (0, -104.7991, 0);
	at[10] = 2.6667;
	points[11] = (-1094.6221, 3533.0591, 518.9330);
	angles[11] = (0, -103.4732, 0);
	at[11] = 3.0667;
	points[12] = (-817.4567, 3476.8347, 503);
	angles[12] = (0, -101.2985, 0);
	at[12] = 3.4667;
	points[13] = (-537.4410, 3425.5159, 487.8976);
	angles[13] = (0, -100.2307, 0);
	at[13] = 3.8667;
	points[14] = (-446.4055, 3411.1455, 484.3858);
	angles[14] = (0, -99.4535, 0);
	at[14] = 4;
	points[15] = (-164.6976, 3370.9373, 475.7599);
	angles[15] = (0, -98.0366, 0);
	at[15] = 4.4000;
	points[16] = (21.8854, 3349.0159, 472.4449);
	angles[16] = (0, -96.5196, 0);
	at[16] = 4.6667;
	points[17] = (210.9079, 3340.1140, 476.4055);
	angles[17] = (0, -93.1345, 0);
	at[17] = 4.9333;
	points[18] = (495.5866, 3333.8113, 485.2717);
	angles[18] = (0, -91.1642, 0);
	at[18] = 5.3333;
	points[19] = (587.8189, 3334.1260, 487.9607);
	angles[19] = (0, -90.2390, 0);
	at[19] = 5.4667;
	points[20] = (872.1890, 3345.6968, 495.6929);
	angles[20] = (0, -87.6349, 0);
	at[20] = 5.8667;
	points[21] = (1153.9094, 3363.1101, 503.3543);
	angles[21] = (0, -86.1017, 0);
	at[21] = 6.2667;
	points[22] = (1626.1812, 3410.5632, 516.2087);
	angles[22] = (0, -84.0138, 0);
	at[22] = 6.9333;
	points[23] = (1717.7008, 3420.5747, 518.7048);
	angles[23] = (0, -83.8768, 0);
	at[23] = 7.0667;
	points[24] = (2000.5669, 3452.7441, 526.4291);
	angles[24] = (0, -83.3522, 0);
	at[24] = 7.4667;
	points[25] = (2186.8267, 3480.2717, 531.5236);
	angles[25] = (0, -81.2800, 0);
	at[25] = 7.7333;
	points[26] = (2369.4922, 3527.3152, 536.4685);
	angles[26] = (0, -76.2216, 0);
	at[26] = 8;
	points[27] = (2642.0237, 3608.1653, 543.9291);
	angles[27] = (0, -73.3353, 0);
	at[27] = 8.4000;
	points[28] = (2730.1377, 3637.3623, 546.4843);
	angles[28] = (0, -72.1934, 0);
	at[28] = 8.5333;
	points[29] = (2818.9922, 3671.3191, 549.2441);
	angles[29] = (0, -70.3073, 0);
	at[29] = 8.6667;
	points[30] = (3081.9097, 3779.2954, 557.7244);
	angles[30] = (0, -67.6508, 0);
	at[30] = 9.0667;
	points[31] = (3256.3701, 3854.7480, 563.6890);
	angles[31] = (0, -66.6239, 0);
	at[31] = 9.3333;
	points[32] = (3339.6143, 3892.9880, 566.8464);
	angles[32] = (0, -65.8595, 0);
	at[32] = 9.4667;
	points[33] = (3596.4607, 4015.6694, 577.1339);
	angles[33] = (0, -64.2198, 0);
	at[33] = 9.8667;
	points[34] = (3762.6812, 4105.4727, 584.7992);
	angles[34] = (0, -61.3714, 0);
	at[34] = 10.1333;
	points[35] = (3835.5393, 4163.1499, 589.9213);
	angles[35] = (0, -54.8408, 0);
	at[35] = 10.2667;
	points[36] = (3900.5593, 4232.2441, 596.2402);
	angles[36] = (0, -47.9629, 0);
	at[36] = 10.4000;
	points[37] = (3961.6536, 4304.2915, 602.8543);
	angles[37] = (0, -43.4299, 0);
	at[37] = 10.5333;
	points[38] = (4020.1968, 4378.7798, 609.6772);
	angles[38] = (0, -40.2857, 0);
	at[38] = 10.6667;
	points[39] = (4075.3545, 4455.3936, 616.6339);
	angles[39] = (0, -37.4734, 0);
	at[39] = 10.8000;
	points[40] = (4121.3384, 4535.4722, 623.6890);
	angles[40] = (0, -32.2696, 0);
	at[40] = 10.9333;
	points[41] = (4154.7246, 4624.1733, 631.4410);
	angles[41] = (0, -25.3071, 0);
	at[41] = 11.0667;
	points[42] = (4182.8740, 4714.3701, 639.2559);
	angles[42] = (0, -20.5751, 0);
	at[42] = 11.2000;
	points[43] = (4207.1655, 4805.6299, 646.9764);
	angles[43] = (0, -17.1682, 0);
	at[43] = 11.3333;
	points[44] = (4226.8110, 4898.1499, 654.4764);
	angles[44] = (0, -13.9390, 0);
	at[44] = 11.4667;
	points[45] = (4236.5356, 4991.4961, 661.2008);
	angles[45] = (0, -8.5088, 0);
	at[45] = 11.6000;
	points[46] = (4225.7876, 5084.6851, 666.0905);
	angles[46] = (0, 0.5318, 0);
	at[46] = 11.7333;
	points[47] = (4208.5830, 5177.1260, 670.3898);
	angles[47] = (0, 6.3922, 0);
	at[47] = 11.8667;
	points[48] = (4165.7480, 5361.8110, 678.4135);
	angles[48] = (0, 12.2058, 0);
	at[48] = 12.1333;
	points[49] = (4140.7480, 5453.0708, 682.1969);
	angles[49] = (0, 14.1215, 0);
	at[49] = 12.2667;
	points[50] = (4111.6929, 5544.0552, 685.8386);
	angles[50] = (0, 16.4050, 0);
	at[50] = 12.4000;
	points[51] = (4074.1733, 5627.3232, 688.8976);
	angles[51] = (0, 21.8721, 0);
	at[51] = 12.5333;
	points[52] = (4019.2126, 5704.9214, 691.1181);
	angles[52] = (0, 29.9470, 0);
	at[52] = 12.6667;
	points[53] = (3959.4094, 5778.5830, 692.9764);
	angles[53] = (0, 35.3098, 0);
	at[53] = 12.8000;
	points[54] = (3833.9805, 5920.9058, 696.3032);
	angles[54] = (0, 40.5517, 0);
	at[54] = 13.0667;
	points[55] = (3704.5198, 6059.2520, 699.5197);
	angles[55] = (0, 42.8058, 0);
	at[55] = 13.3333;
	points[56] = (3504.7205, 6258.0312, 705.1260);
	angles[56] = (0, 45.3404, 0);
	at[56] = 13.7333;
	points[57] = (3229.6299, 6518.6221, 712.5630);
	angles[57] = (0, 46.8275, 0);
	at[57] = 14.2667;
	points[58] = (3089.5552, 6645.1182, 715.7008);
	angles[58] = (0, 47.9516, 0);
	at[58] = 14.5333;
	points[59] = (3019.1692, 6703.9370, 716.6811);
	angles[59] = (0, 49.4193, 0);
	at[59] = 14.6667;
	points[60] = (2868.0552, 6819.4097, 717.1929);
	angles[60] = (0, 52.2378, 0);
	at[60] = 14.9333;
	points[61] = (2483.2874, 7096.6929, 716.8307);
	angles[61] = (0, 54.7150, 0);
	at[61] = 15.6000;
	points[62] = (2246.8347, 7254.1343, 716.4960);
	angles[62] = (0, 56.8926, 0);
	at[62] = 16;
	points[63] = (2001.9016, 7391.1807, 716.4960);
	angles[63] = (0, 60.9058, 0);
	at[63] = 16.4000;
	points[64] = (1750.1536, 7524.4492, 716.4960);
	angles[64] = (0, 62.1435, 0);
	at[64] = 16.8000;
	points[65] = (1411.9922, 7698.0317, 716.4960);
	angles[65] = (0, 63.0091, 0);
	at[65] = 17.3333;
	points[66] = (1160.5276, 7820.5908, 716.4960);
	angles[66] = (0, 64.4194, 0);
	at[66] = 17.7333;
	points[67] = (898.4921, 7933.2285, 716.4960);
	angles[67] = (0, 66.8594, 0);
	at[67] = 18.1333;
	points[68] = (635.6024, 8040.0791, 716.4960);
	angles[68] = (0, 67.9720, 0);
	at[68] = 18.5333;
	points[69] = (369.8295, 8142.6377, 716.4960);
	angles[69] = (0, 69.0766, 0);
	at[69] = 18.9333;
	points[70] = (190.4055, 8205.8262, 716.4960);
	angles[70] = (0, 70.6572, 0);
	at[70] = 19.2000;
	points[71] = (104.7291, 8230.6699, 716.4960);
	angles[71] = (0, 72.6990, 0);
	at[71] = 19.3333;
	points[72] = (12.3847, 8253.5039, 716.4960);
	angles[72] = (0, 74.7441, 0);
	at[72] = 19.4667;
	points[73] = (-358.7961, 8332.8740, 716.4960);
	angles[73] = (0, 78.2773, 0);
	at[73] = 20;
	points[74] = (-730.8425, 8401.1816, 716.4960);
	angles[74] = (0, 80.0065, 0);
	at[74] = 20.5333;
	points[75] = (-916.1339, 8427.7949, 716.4960);
	angles[75] = (0, 82.0219, 0);
	at[75] = 20.8000;
	points[76] = (-1104.9448, 8440.5908, 716.4960);
	angles[76] = (0, 85.7182, 0);
	at[76] = 21.0667;
	points[77] = (-1389.2480, 8450.3545, 716.4960);
	angles[77] = (0, 88.1006, 0);
	at[77] = 21.4667;
	points[78] = (-1768.6024, 8454.4492, 716.4960);
	angles[78] = (0, 89.7373, 0);
	at[78] = 22;
	points[79] = (-1956.8741, 8450.4336, 716.4960);
	angles[79] = (0, 91.3369, 0);
	at[79] = 22.2667;
	points[80] = (-2049.1655, 8443.5439, 716.5511);
	angles[80] = (0, 93.1422, 0);
	at[80] = 22.4000;
	points[81] = (-2332.0237, 8412.5195, 716.9055);
	angles[81] = (0, 96.3428, 0);
	at[81] = 22.8000;
	points[82] = (-2707.3345, 8360.3545, 717.1418);
	angles[82] = (0, 98.3337, 0);
	at[82] = 23.3333;
	points[83] = (-2894.5396, 8327.2832, 716.7992);
	angles[83] = (0, 100.0811, 0);
	at[83] = 23.6000;
	points[84] = (-2982.7205, 8304.9219, 716.0709);
	angles[84] = (0, 102.8912, 0);
	at[84] = 23.7333;
	points[85] = (-3073.6614, 8273.8193, 714.6693);
	angles[85] = (0, 106.4939, 0);
	at[85] = 23.8667;
	points[86] = (-3249.4136, 8204.6064, 711.2717);
	angles[86] = (0, 110.8778, 0);
	at[86] = 24.1333;
	points[87] = (-3423.2637, 8129.4097, 707.4843);
	angles[87] = (0, 113.1451, 0);
	at[87] = 24.4000;
	points[88] = (-3595.4529, 8048.3857, 703.4882);
	angles[88] = (0, 115.1323, 0);
	at[88] = 24.6667;
	points[89] = (-3676.2205, 8005.1968, 701.5315);
	angles[89] = (0, 117.2166, 0);
	at[89] = 24.8000;
	points[90] = (-3755.8464, 7952.8345, 699.2874);
	angles[90] = (0, 120.9647, 0);
	at[90] = 24.9333;
	points[91] = (-3907.3623, 7839.7642, 694.5394);
	angles[91] = (0, 126.0840, 0);
	at[91] = 25.2000;
	points[92] = (-4052.8740, 7718.1099, 689.8858);
	angles[92] = (0, 129.6875, 0);
	at[92] = 25.4667;
	points[93] = (-4121.1025, 7652.7163, 687.8110);
	angles[93] = (0, 132.3810, 0);
	at[93] = 25.6000;
	points[94] = (-4176.3779, 7577.7954, 686.6378);
	angles[94] = (0, 139.9050, 0);
	at[94] = 25.7333;
	points[95] = (-4216.8110, 7492.7168, 686.5748);
	angles[95] = (0, 148.6057, 0);
	at[95] = 25.8667;
	points[96] = (-4283.7793, 7315.2754, 687.1024);
	angles[96] = (0, 157.9090, 0);
	at[96] = 26.1333;
	points[97] = (-4338.1890, 7133.3862, 687.3464);
	angles[97] = (0, 162.9652, 0);
	at[97] = 26.4000;
	points[98] = (-4355.2759, 7043.2681, 686.5512);
	angles[98] = (0, 167.1824, 0);
	at[98] = 26.5333;
	points[99] = (-4362.1655, 6948.3857, 684.9174);
	angles[99] = (0, 172.3607, 0);
	at[99] = 26.6667;
	points[100] = (-4367.4014, 6664.0161, 679.0512);
	angles[100] = (0, 178.9287, 0);
	at[100] = 27.0667;
	points[101] = (-4364.4487, 6473.7402, 674.4921);
	angles[101] = (0, 180.7449, 0);
	at[101] = 27.3333;
	points[102] = (-4360.0396, 6382.4019, 671.8464);
	angles[102] = (0, 182.1167, 0);
	at[102] = 27.4667;
	points[103] = (-4326.9688, 6099.7246, 661.4961);
	angles[103] = (0, 186.8298, 0);
	at[103] = 27.8667;
	points[104] = (-4283.8975, 5818.8979, 649.4291);
	angles[104] = (0, 188.9785, 0);
	at[104] = 28.2667;
	points[105] = (-4265.9053, 5725, 644.3898);
	angles[105] = (0, 190.2262, 0);
	at[105] = 28.4000;
	points[106] = (-4241.9688, 5637.1260, 637.1299);
	angles[106] = (0, 193.4309, 0);
	at[106] = 28.5333;
	points[107] = (-4211.9688, 5547.0864, 627.4252);
	angles[107] = (0, 196.3963, 0);
	at[107] = 28.6667;
	points[108] = (-4146.2993, 5370.6299, 606.7244);
	angles[108] = (0, 199.9776, 0);
	at[108] = 28.9333;
	points[109] = (-4071.9292, 5197.0474, 586.6260);
	angles[109] = (0, 203.1465, 0);
	at[109] = 29.2000;
	points[110] = (-4026.4175, 5117.0078, 579.6181);
	angles[110] = (0, 207.5778, 0);
	at[110] = 29.3333;
	points[111] = (-3969.4094, 5041.6934, 575.8110);
	angles[111] = (0, 213.2889, 0);
	at[111] = 29.4667;
	points[112] = (-3908.6299, 4968.5435, 572.9646);
	angles[112] = (0, 217.0873, 0);
	at[112] = 29.6000;
	points[113] = (-3782.2756, 4827.9136, 568.3779);
	angles[113] = (0, 221.4081, 0);
	at[113] = 29.8667;
	points[114] = (-3715.6260, 4759.6064, 566.2283);
	angles[114] = (0, 223.2167, 0);
	at[114] = 30;
	points[115] = (-3647.5908, 4698.5039, 563.9252);
	angles[115] = (0, 226.4935, 0);
	at[115] = 30.1333;
	points[116] = (-3493.4409, 4587.2046, 559.2244);
	angles[116] = (0, 233.1570, 0);
	at[116] = 30.4000;
	points[117] = (-3100.8110, 4323.8979, 547.5315);
	angles[117] = (0, 236.2165, 0);
	at[117] = 31.0667;
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
	points[0] = (-882.5591, 4541.6143, 809.5906);
	angles[0] = (0, 57.8975, 0);
	at[0] = 0;
	points[1] = (-1149.6260, 4700.2759, 795.8897);
	angles[1] = (0, 59.6861, 0);
	at[1] = 0.5000;
	points[2] = (-1259.2638, 4758.6616, 789.8661);
	angles[2] = (0, 61.7224, 0);
	at[2] = 0.7000;
	points[3] = (-1314.4646, 4781.6143, 786.8976);
	angles[3] = (0, 64.8708, 0);
	at[3] = 0.8000;
	points[4] = (-1434.3386, 4817.0474, 780.4173);
	angles[4] = (0, 71.4529, 0);
	at[4] = 1;
	points[5] = (-1554.9016, 4846.7720, 773.8859);
	angles[5] = (0, 75.0427, 0);
	at[5] = 1.2000;
	points[6] = (-1676.8583, 4871.4565, 767.3268);
	angles[6] = (0, 77.8869, 0);
	at[6] = 1.4000;
	points[7] = (-1738.5001, 4880.5117, 764.0630);
	angles[7] = (0, 79.8383, 0);
	at[7] = 1.5000;
	points[8] = (-1798.3425, 4883.7402, 760.9961);
	angles[8] = (0, 83.8269, 0);
	at[8] = 1.6000;
	points[9] = (-1859.4685, 4876.4175, 758.0315);
	angles[9] = (0, 90.2655, 0);
	at[9] = 1.7000;
	points[10] = (-1981.6851, 4851.7324, 752.2599);
	angles[10] = (0, 98.6152, 0);
	at[10] = 1.9000;
	points[11] = (-2102.5984, 4821.7324, 746.6339);
	angles[11] = (0, 102.6192, 0);
	at[11] = 2.1000;
	points[12] = (-2222.5354, 4787.6772, 741.1299);
	angles[12] = (0, 105.1606, 0);
	at[12] = 2.3000;
	points[13] = (-2281.6299, 4768.5435, 738.4646);
	angles[13] = (0, 106.6102, 0);
	at[13] = 2.4000;
	points[14] = (-2337.0435, 4745.8267, 736.0709);
	angles[14] = (0, 109.8846, 0);
	at[14] = 2.5000;
	points[15] = (-2390.1458, 4712.9136, 734.2165);
	angles[15] = (0, 115.8626, 0);
	at[15] = 2.6000;
	points[16] = (-2440.0630, 4675.9844, 732.6772);
	angles[16] = (0, 121.0382, 0);
	at[16] = 2.7000;
	points[17] = (-2534.4373, 4594.7637, 729.8071);
	angles[17] = (0, 128.5345, 0);
	at[17] = 2.9000;
	points[18] = (-2577.8428, 4550.7871, 728.2874);
	angles[18] = (0, 132.0024, 0);
	at[18] = 3;
	points[19] = (-2614.9568, 4502.3623, 726.3661);
	angles[19] = (0, 137.9101, 0);
	at[19] = 3.1000;
	points[20] = (-2638.3503, 4444.6064, 723.5118);
	angles[20] = (0, 147.7736, 0);
	at[20] = 3.2000;
	points[21] = (-2671.1655, 4325, 717.4134);
	angles[21] = (0, 160.3722, 0);
	at[21] = 3.4000;
	points[22] = (-2694.9172, 4202.7559, 711.4331);
	angles[22] = (0, 167.0196, 0);
	at[22] = 3.6000;
	points[23] = (-2701.9922, 4141.5747, 708.7678);
	angles[23] = (0, 170.3277, 0);
	at[23] = 3.7000;
	points[24] = (-2698.9604, 4080.5117, 706.9135);
	angles[24] = (0, 176.9659, 0);
	at[24] = 3.8000;
	points[25] = (-2672.8347, 3959.1733, 704.4174);
	angles[25] = (0, 188.3437, 0);
	at[25] = 4;
	points[26] = (-2639.2837, 3839.3938, 702.5788);
	angles[26] = (0, 193.8652, 0);
	at[26] = 4.2000;
	points[27] = (-2598.5117, 3721.5906, 701.7677);
	angles[27] = (0, 198.1907, 0);
	at[27] = 4.4000;
	points[28] = (-2568.1809, 3668.9883, 703.3898);
	angles[28] = (0, 204.8597, 0);
	at[28] = 4.5000;
	points[29] = (-2524.1692, 3625.5039, 707.9528);
	angles[29] = (0, 214.8683, 0);
	at[29] = 4.6000;
	points[30] = (-2475.9448, 3586.7795, 713.3819);
	angles[30] = (0, 222.7380, 0);
	at[30] = 4.7000;
	points[31] = (-2372.8977, 3517.7874, 724.6339);
	angles[31] = (0, 233.0176, 0);
	at[31] = 4.9000;
	points[32] = (-2318.3386, 3489.9526, 729.0079);
	angles[32] = (0, 238.1525, 0);
	at[32] = 5;
	points[33] = (-2261.2087, 3467.6575, 732.4252);
	angles[33] = (0, 243.2325, 0);
	at[33] = 5.1000;
	points[34] = (-2143.4568, 3427.1733, 738.9489);
	angles[34] = (0, 249.0520, 0);
	at[34] = 5.3000;
	points[35] = (-2024.7087, 3391.5000, 745.4410);
	angles[35] = (0, 252.3793, 0);
	at[35] = 5.5000;
	points[36] = (-1964.6102, 3377.3701, 748.9252);
	angles[36] = (0, 254.8158, 0);
	at[36] = 5.6000;
	points[37] = (-1903.4449, 3370.4094, 752.8937);
	angles[37] = (0, 259.1474, 0);
	at[37] = 5.7000;
	points[38] = (-1717.7914, 3362.5986, 765.4252);
	angles[38] = (0, 266.8728, 0);
	at[38] = 6;
	points[39] = (-1593.9331, 3364.6890, 773.8976);
	angles[39] = (0, 270.2534, 0);
	at[39] = 6.2000;
	points[40] = (-1532.9489, 3372.5198, 778.1536);
	angles[40] = (0, 274.0540, 0);
	at[40] = 6.3000;
	points[41] = (-1473.1141, 3386.0273, 782.5591);
	angles[41] = (0, 278.2576, 0);
	at[41] = 6.4000;
	points[42] = (-1233.8425, 3453.6653, 799.8188);
	angles[42] = (0, 285.8269, 0);
	at[42] = 6.8000;
	points[43] = (-1118.3307, 3494.6812, 805.6457);
	angles[43] = (0, 289.1587, 0);
	at[43] = 7;
	points[44] = (-948.8622, 3572.9844, 807.9764);
	angles[44] = (0, 294.2519, 0);
	at[44] = 7.3000;
	points[45] = (-725.7953, 3679.7285, 811.8543);
	angles[45] = (0, 295.2643, 0);
	at[45] = 7.7000;
	points[46] = (-387.4102, 3837.6731, 828.5591);
	angles[46] = (0, 295.1842, 0);
	at[46] = 8.3000;
	points[47] = (-333.4776, 3863.7324, 831.4410);
	angles[47] = (0, 295.4884, 0);
	at[47] = 8.4000;
	points[48] = (0.7751, 4029.4487, 849.2363);
	angles[48] = (0, 296.7028, 0);
	at[48] = 9;
	points[49] = (163.0524, 4118.3857, 848.0788);
	angles[49] = (0, 298.6620, 0);
	at[49] = 9.3000;
	points[50] = (431.8425, 4272.9136, 839.7993);
	angles[50] = (0, 300.2816, 0);
	at[50] = 9.8000;
	points[51] = (741.9567, 4478.0708, 821.1575);
	angles[51] = (0, 303.0850, 0);
	at[51] = 10.4000;
	points[52] = (905.4213, 4565.7876, 809.4095);
	angles[52] = (0, 298.3794, 0);
	at[52] = 10.7000;
	points[53] = (1073.7086, 4645.5513, 797.7480);
	angles[53] = (0, 295.2974, 0);
	at[53] = 11;
	points[54] = (1130.4882, 4667.8740, 794.9567);
	angles[54] = (0, 293.1584, 0);
	at[54] = 11.1000;
	points[55] = (1189.4133, 4685.6694, 793.8898);
	angles[55] = (0, 290.0254, 0);
	at[55] = 11.2000;
	points[56] = (1370.4291, 4732.2046, 792.9725);
	angles[56] = (0, 284.9125, 0);
	at[56] = 11.5000;
	points[57] = (1492.1023, 4759.0552, 792.4331);
	angles[57] = (0, 282.9390, 0);
	at[57] = 11.7000;
	points[58] = (1553.4568, 4770.3936, 791.8425);
	angles[58] = (0, 281.6676, 0);
	at[58] = 11.8000;
	points[59] = (1612.8977, 4777.7954, 790.5473);
	angles[59] = (0, 279.0848, 0);
	at[59] = 11.9000;
	points[60] = (1737.3779, 4777.4409, 784.8661);
	angles[60] = (0, 272.0060, 0);
	at[60] = 12.1000;
	points[61] = (1923.4213, 4767.1260, 774.9094);
	angles[61] = (0, 267.2657, 0);
	at[61] = 12.4000;
	points[62] = (2046.7954, 4756.0630, 767.9646);
	angles[62] = (0, 265.3450, 0);
	at[62] = 12.6000;
	points[63] = (2109.5276, 4747.9526, 764.3583);
	angles[63] = (0, 263.9004, 0);
	at[63] = 12.7000;
	points[64] = (2167.7520, 4734.6460, 760.8897);
	angles[64] = (0, 260.3165, 0);
	at[64] = 12.8000;
	points[65] = (2285.4607, 4694.6851, 753.3779);
	angles[65] = (0, 253.3470, 0);
	at[65] = 13;
	points[66] = (2399.6931, 4646.6538, 745.7441);
	angles[66] = (0, 248.4818, 0);
	at[66] = 13.2000;
	points[67] = (2455.4172, 4618.1890, 741.8464);
	angles[67] = (0, 245.5932, 0);
	at[67] = 13.3000;
	points[68] = (2503.8740, 4582.7168, 738.0984);
	angles[68] = (0, 239.0548, 0);
	at[68] = 13.4000;
	points[69] = (2544.7876, 4536.0234, 734.2953);
	angles[69] = (0, 230.3757, 0);
	at[69] = 13.5000;
	points[70] = (2617.9607, 4435.3545, 726.8937);
	angles[70] = (0, 219.6000, 0);
	at[70] = 13.7000;
	points[71] = (2682.5474, 4329.8032, 719.9803);
	angles[71] = (0, 213.1971, 0);
	at[71] = 13.9000;
	points[72] = (2708.7598, 4273.4644, 717.0118);
	angles[72] = (0, 208.6575, 0);
	at[72] = 14;
	points[73] = (2722.2600, 4213.8584, 715.2166);
	angles[73] = (0, 200.7834, 0);
	at[73] = 14.1000;
	points[74] = (2730.9841, 4152.2051, 713.8465);
	angles[74] = (0, 194.6646, 0);
	at[74] = 14.2000;
	points[75] = (2741.5117, 4028.2285, 711.6102);
	angles[75] = (0, 187.2410, 0);
	at[75] = 14.4000;
	points[76] = (2742, 3903.5750, 709.8819);
	angles[76] = (0, 181.4986, 0);
	at[76] = 14.6000;
	points[77] = (2731.5591, 3844.4685, 709.4528);
	angles[77] = (0, 174.8535, 0);
	at[77] = 14.7000;
	points[78] = (2701.4802, 3789.6931, 709.5945);
	angles[78] = (0, 163.2525, 0);
	at[78] = 14.8000;
	points[79] = (2665.6892, 3739.0750, 709.9685);
	angles[79] = (0, 154.3942, 0);
	at[79] = 14.9000;
	points[80] = (2586.3386, 3643.0867, 711.2992);
	angles[80] = (0, 143.8869, 0);
	at[80] = 15.1000;
	points[81] = (2543.5354, 3597.6221, 712.3780);
	angles[81] = (0, 140.3584, 0);
	at[81] = 15.2000;
	points[82] = (2498.3938, 3555.5078, 714.0079);
	angles[82] = (0, 136.5725, 0);
	at[82] = 15.3000;
	points[83] = (2447.1338, 3522.5198, 717.3268);
	angles[83] = (0, 129.2753, 0);
	at[83] = 15.4000;
	points[84] = (2390.9055, 3497.7678, 722.0315);
	angles[84] = (0, 121.8108, 0);
	at[84] = 15.5000;
	points[85] = (2274.3425, 3454.6104, 732.3701);
	angles[85] = (0, 113.2788, 0);
	at[85] = 15.7000;
	points[86] = (2156.7480, 3416.1692, 742.9016);
	angles[86] = (0, 109.3823, 0);
	at[86] = 15.9000;
	points[87] = (2038.0157, 3382.2400, 752.8504);
	angles[87] = (0, 106.5132, 0);
	at[87] = 16.1000;
	points[88] = (1977.7599, 3370.1575, 756.7834);
	angles[88] = (0, 103.8994, 0);
	at[88] = 16.2000;
	points[89] = (1793.3110, 3344.0471, 767.3976);
	angles[89] = (0, 98.4231, 0);
	at[89] = 16.5000;
	points[90] = (1669.1851, 3333.6497, 773.8504);
	angles[90] = (0, 95.4024, 0);
	at[90] = 16.7000;
	points[91] = (1609.4370, 3334.4172, 776.5001);
	angles[91] = (0, 91.9540, 0);
	at[91] = 16.8000;
	points[92] = (1547.0670, 3343.4250, 778.5433);
	angles[92] = (0, 86.9495, 0);
	at[92] = 16.9000;
	points[93] = (1364.6497, 3381.5120, 783.5197);
	angles[93] = (0, 79.0812, 0);
	at[93] = 17.2000;
	points[94] = (1184.4567, 3428.2009, 788.2480);
	angles[94] = (0, 75.3815, 0);
	at[94] = 17.5000;
	points[95] = (1070, 3473.9568, 791.5354);
	angles[95] = (0, 69.7209, 0);
	at[95] = 17.7000;
	points[96] = (844.7756, 3579.9805, 799.0591);
	angles[96] = (0, 64.7285, 0);
	at[96] = 18.1000;
	points[97] = (519.2717, 3758.4016, 821.6102);
	angles[97] = (0, 61.2570, 0);
	at[97] = 18.7000;
	points[98] = (466.1299, 3786.1140, 824.8189);
	angles[98] = (0, 61.9491, 0);
	at[98] = 18.8000;
	points[99] = (129.5508, 3948.6221, 842.2559);
	angles[99] = (0, 64.1787, 0);
	at[99] = 19.4000;
	points[100] = (20.4720, 4003.2283, 844.7480);
	angles[100] = (0, 63.3978, 0);
	at[100] = 19.6000;
	points[101] = (-306.2709, 4183.9370, 828.0709);
	angles[101] = (0, 60.8099, 0);
	at[101] = 20.2000;
	points[102] = (-465.6378, 4275.9844, 819.6890);
	angles[102] = (0, 59.7999, 0);
	at[102] = 20.5000;
	points[103] = (-833.2244, 4511.1025, 811.1536);
	angles[103] = (0, 57.4249, 0);
	at[103] = 21.2000;
	points[104] = (-882.5591, 4541.6143, 809.5906);
	angles[104] = (0, 57.8975, 0);
	at[104] = 21.3000;
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
	points[0] = (-10664.9609, 13682.0869, 265.7480);
	angles[0] = (0, 88.0881, 0);
	at[0] = 0;
	points[1] = (-10699.1338, 13844.7246, 265.7480);
	angles[1] = (0, 71.9705, 0);
	at[1] = 0.1000;
	points[2] = (-10740.9854, 13998.5830, 265.7480);
	angles[2] = (0, 58.4195, 0);
	at[2] = 0.2000;
	points[3] = (-10824.6846, 14306.2998, 265.7480);
	angles[3] = (0, 39.3095, 0);
	at[3] = 0.4000;
	points[4] = (-10847.6377, 14459.2529, 265.7480);
	angles[4] = (0, 30.1754, 0);
	at[4] = 0.5000;
	points[5] = (-10735, 14757.5977, 265.7480);
	angles[5] = (0, 8.0339, 0);
	at[5] = 0.7000;
	points[6] = (-10565.9844, 15205.1182, 265.7480);
	angles[6] = (0, -9.0890, 0);
	at[6] = 1;
	points[7] = (-10477.7949, 15331.2598, 265.7480);
	angles[7] = (0, -16.1310, 0);
	at[7] = 1.1000;
	points[8] = (-10229.9609, 15531.8906, 265.7480);
	angles[8] = (0, -31.7726, 0);
	at[8] = 1.3000;
	points[9] = (-9982.0869, 15732.5586, 265.7480);
	angles[9] = (0, -40.5492, 0);
	at[9] = 1.5000;
	points[10] = (-9610.3154, 16033.5439, 265.7480);
	angles[10] = (0, -46.8441, 0);
	at[10] = 1.8000;
	points[11] = (-9114.6064, 16434.8828, 265.7480);
	angles[11] = (0, -49.7911, 0);
	at[11] = 2.2000;
	points[12] = (-8981.6533, 16521.6133, 265.7480);
	angles[12] = (0, -52.0949, 0);
	at[12] = 2.3000;
	points[13] = (-8419.8428, 16823.5430, 265.7480);
	angles[13] = (0, -58.9238, 0);
	at[13] = 2.7000;
	points[14] = (-7577.1260, 17276.3789, 265.7480);
	angles[14] = (0, -61.3023, 0);
	at[14] = 3.3000;
	points[15] = (-7433.0312, 17342.6777, 265.7480);
	angles[15] = (0, -62.6850, 0);
	at[15] = 3.4000;
	points[16] = (-6817.4805, 17509.7246, 265.7480);
	angles[16] = (0, -71.2630, 0);
	at[16] = 3.8000;
	points[17] = (-5432.5195, 17885.5918, 265.7480);
	angles[17] = (0, -75.2483, 0);
	at[17] = 4.7000;
	points[18] = (-5272.4409, 17886.1035, 265.7480);
	angles[18] = (0, -78.6141, 0);
	at[18] = 4.8000;
	points[19] = (-4635, 17908.1895, 265.7480);
	angles[19] = (0, -85.2656, 0);
	at[19] = 5.2000;
	points[20] = (-3200.8425, 17957.8750, 265.7480);
	angles[20] = (0, -87.8438, 0);
	at[20] = 6.1000;
	points[21] = (-3043.6221, 17944.8438, 265.7480);
	angles[21] = (0, -90.2986, 0);
	at[21] = 6.2000;
	points[22] = (-2735.7363, 17861.7715, 265.7480);
	angles[22] = (0, -97.0725, 0);
	at[22] = 6.4000;
	points[23] = (-2273.9016, 17737.1660, 265.7480);
	angles[23] = (0, -101.9072, 0);
	at[23] = 6.7000;
	points[24] = (-888.4094, 17363.3457, 265.7480);
	angles[24] = (0, -104.8995, 0);
	at[24] = 7.6000;
	points[25] = (-614.6339, 17200.2363, 265.7480);
	angles[25] = (0, -112.2964, 0);
	at[25] = 7.8000;
	points[26] = (-204.9350, 16953.3457, 265.7480);
	angles[26] = (0, -117.5829, 0);
	at[26] = 8.1000;
	points[27] = (1297.2913, 16048.0312, 265.7480);
	angles[27] = (0, -121.6660, 0);
	at[27] = 9.2000;
	points[28] = (1405.8661, 15930.1973, 265.7480);
	angles[28] = (0, -125.2799, 0);
	at[28] = 9.3000;
	points[29] = (1741.8268, 15589.6855, 265.7480);
	angles[29] = (0, -131.3632, 0);
	at[29] = 9.6000;
	points[30] = (2637.7166, 14681.6533, 265.7480);
	angles[30] = (0, -135.0424, 0);
	at[30] = 10.4000;
	points[31] = (2716.5198, 14546.2607, 265.7480);
	angles[31] = (0, -139.2082, 0);
	at[31] = 10.5000;
	points[32] = (2897.5747, 14103.4648, 265.7480);
	angles[32] = (0, -150.3399, 0);
	at[32] = 10.8000;
	points[33] = (3138.9844, 13513.1504, 265.7480);
	angles[33] = (0, -155.5900, 0);
	at[33] = 11.2000;
	points[34] = (3125.7561, 13361.1416, 265.7480);
	angles[34] = (0, -164.2150, 0);
	at[34] = 11.3000;
	points[35] = (3041.2283, 13053.6611, 265.7480);
	angles[35] = (0, -178.2596, 0);
	at[35] = 11.5000;
	points[36] = (2956.6968, 12746.1426, 265.7480);
	angles[36] = (0, -186.0796, 0);
	at[36] = 11.7000;
	points[37] = (2883.2480, 12612.6377, 265.7480);
	angles[37] = (0, -193.1231, 0);
	at[37] = 11.8000;
	points[38] = (2637.1299, 12409.8428, 265.7480);
	angles[38] = (0, -209.8287, 0);
	at[38] = 12;
	points[39] = (2391.0120, 12207.0469, 265.7480);
	angles[39] = (0, -219.2565, 0);
	at[39] = 12.2000;
	points[40] = (2243.0669, 12230.3545, 265.7480);
	angles[40] = (0, -234.6413, 0);
	at[40] = 12.3000;
	points[41] = (1937.9567, 12323.1104, 265.7480);
	angles[41] = (0, -257.3203, 0);
	at[41] = 12.5000;
	points[42] = (1632.8464, 12415.8662, 265.7480);
	angles[42] = (0, -270.6850, 0);
	at[42] = 12.7000;
	points[43] = (1517.5985, 12515.3555, 265.7480);
	angles[43] = (0, -280.8540, 0);
	at[43] = 12.8000;
	points[44] = (1422.2245, 12643.1104, 265.7480);
	angles[44] = (0, -291.4760, 0);
	at[44] = 12.9000;
	points[45] = (1231.4803, 12898.7012, 265.7480);
	angles[45] = (0, -305.7933, 0);
	at[45] = 13.1000;
	points[46] = (1040.7323, 13154.2529, 265.7480);
	angles[46] = (0, -313.7750, 0);
	at[46] = 13.3000;
	points[47] = (939.3858, 13277.1270, 265.7480);
	angles[47] = (0, -315.2757, 0);
	at[47] = 13.4000;
	points[48] = (82.8740, 14222.3623, 265.7480);
	angles[48] = (0, -317.6030, 0);
	at[48] = 14.2000;
	points[49] = (-35.5201, 14328.5830, 265.7480);
	angles[49] = (0, -315.6847, 0);
	at[49] = 14.3000;
	points[50] = (-1025.9213, 15132.4414, 265.7480);
	angles[50] = (0, -309.6305, 0);
	at[50] = 15.1000;
	points[51] = (-1157.0630, 15221.6143, 265.7480);
	angles[51] = (0, -307.7528, 0);
	at[51] = 15.2000;
	points[52] = (-1725.9803, 15509.9209, 265.7480);
	angles[52] = (0, -300.0581, 0);
	at[52] = 15.6000;
	points[53] = (-2579.3584, 15942.3623, 265.7480);
	angles[53] = (0, -297.3758, 0);
	at[53] = 16.2000;
	points[54] = (-2732.9211, 15975.3545, 265.7480);
	angles[54] = (0, -292.4733, 0);
	at[54] = 16.3000;
	points[55] = (-3367.8308, 16035.9062, 265.7480);
	angles[55] = (0, -280.4526, 0);
	at[55] = 16.7000;
	points[56] = (-4320.1968, 16126.8115, 265.7480);
	angles[56] = (0, -275.4354, 0);
	at[56] = 17.3000;
	points[57] = (-4476.6143, 16092.9141, 265.7480);
	angles[57] = (0, -271.1494, 0);
	at[57] = 17.4000;
	points[58] = (-4946.3779, 16002.6768, 265.7480);
	angles[58] = (0, -263.9154, 0);
	at[58] = 17.7000;
	points[59] = (-6042.4409, 15792.1260, 265.7480);
	angles[59] = (0, -259.6817, 0);
	at[59] = 18.4000;
	points[60] = (-6192.3623, 15742.0469, 265.7480);
	angles[60] = (0, -257.3872, 0);
	at[60] = 18.5000;
	points[61] = (-6765.2754, 15461.7324, 265.7480);
	angles[61] = (0, -247.8733, 0);
	at[61] = 18.9000;
	points[62] = (-7767.8345, 14971.1816, 265.7480);
	angles[62] = (0, -244.3858, 0);
	at[62] = 19.6000;
	points[63] = (-7903.2676, 14888.6221, 265.7480);
	angles[63] = (0, -242.5958, 0);
	at[63] = 19.7000;
	points[64] = (-8406.9287, 14497.3623, 265.7480);
	angles[64] = (0, -235.2150, 0);
	at[64] = 20.1000;
	points[65] = (-9288.3857, 13812.6777, 265.7480);
	angles[65] = (0, -232.5153, 0);
	at[65] = 20.8000;
	points[66] = (-9433.8584, 13754.1729, 265.7480);
	angles[66] = (0, -237.5036, 0);
	at[66] = 20.9000;
	points[67] = (-9895.9053, 13630.3145, 265.7480);
	angles[67] = (0, -248.0040, 0);
	at[67] = 21.2000;
	points[68] = (-10050.8271, 13602.6768, 265.7480);
	angles[68] = (0, -251.9485, 0);
	at[68] = 21.3000;
	points[69] = (-10525.1973, 13664.0166, 265.7480);
	angles[69] = (0, -267.1400, 0);
	at[69] = 21.6000;
	points[70] = (-10664.9609, 13682.0869, 265.7480);
	angles[70] = (0, -271.9120, 0);
	at[70] = 21.6833;
	mover = getEnt("iz_obj_3", "targetname");
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
