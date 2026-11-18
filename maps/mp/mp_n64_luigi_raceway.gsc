main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_n64_luigi_raceway", 0);

	setExpFog(13287.4014, 27282.2344, 0.8353, 0.9412, 1, 0);

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
	ambientPlay("iz_0_20", 2);
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
	level.iz_route[level.iz_route.size] = (-3126, 2610, 1476);
	level.iz_route[level.iz_route.size] = (-3132, 2229, 1476);
	level.iz_route[level.iz_route.size] = (-3133, -317, 1476);
	level.iz_route[level.iz_route.size] = (-3160, -3536, 1511);
	level.iz_route[level.iz_route.size] = (-3169, -5841, 1487);
	level.iz_route[level.iz_route.size] = (-3133, -7188, 1504);
	level.iz_route[level.iz_route.size] = (-2979, -8344, 1534);
	level.iz_route[level.iz_route.size] = (-2446, -9312, 1559);
	level.iz_route[level.iz_route.size] = (-1678, -10044, 1565);
	level.iz_route[level.iz_route.size] = (-612, -10532, 1563);
	level.iz_route[level.iz_route.size] = (575, -10667, 1561);
	level.iz_route[level.iz_route.size] = (1588, -10459, 1568);
	level.iz_route[level.iz_route.size] = (2401, -9988, 1564);
	level.iz_route[level.iz_route.size] = (3114, -9257, 1569);
	level.iz_route[level.iz_route.size] = (3549, -8209, 1559);
	level.iz_route[level.iz_route.size] = (3646, -6971, 1547);
	level.iz_route[level.iz_route.size] = (3348, -5913, 1526);
	level.iz_route[level.iz_route.size] = (2661, -5055, 1506);
	level.iz_route[level.iz_route.size] = (1721, -4268, 1495);
	level.iz_route[level.iz_route.size] = (781, -3699, 1470);
	level.iz_route[level.iz_route.size] = (-412, -2994, 1406);
	level.iz_route[level.iz_route.size] = (-1416, -2271, 1300);
	level.iz_route[level.iz_route.size] = (-1843, -1699, 1186);
	level.iz_route[level.iz_route.size] = (-2030, -1129, 1049);
	level.iz_route[level.iz_route.size] = (-2100, -413, 900);
	level.iz_route[level.iz_route.size] = (-2171, 398, 781);
	level.iz_route[level.iz_route.size] = (-2208, 1110, 747);
	level.iz_route[level.iz_route.size] = (-2233, 1878, 803);
	level.iz_route[level.iz_route.size] = (-2214, 2597, 929);
	level.iz_route[level.iz_route.size] = (-2153, 3119, 1047);
	level.iz_route[level.iz_route.size] = (-1958, 3532, 1155);
	level.iz_route[level.iz_route.size] = (-964, 4589, 1361);
	level.iz_route[level.iz_route.size] = (157, 5466, 1470);
	level.iz_route[level.iz_route.size] = (1079, 6216, 1492);
	level.iz_route[level.iz_route.size] = (1910, 7021, 1522);
	level.iz_route[level.iz_route.size] = (2308, 8123, 1549);
	level.iz_route[level.iz_route.size] = (2218, 9163, 1566);
	level.iz_route[level.iz_route.size] = (1748, 10057, 1577);
	level.iz_route[level.iz_route.size] = (1007, 10690, 1595);
	level.iz_route[level.iz_route.size] = (-42, 10970, 1582);
	level.iz_route[level.iz_route.size] = (-1135, 10890, 1562);
	level.iz_route[level.iz_route.size] = (-2003, 10384, 1579);
	level.iz_route[level.iz_route.size] = (-2627, 9560, 1559);
	level.iz_route[level.iz_route.size] = (-2970, 8458, 1517);
	level.iz_route[level.iz_route.size] = (-3097, 7219, 1499);
	level.iz_route[level.iz_route.size] = (-3097, 6044, 1484);
	level.iz_route[level.iz_route.size] = (-3115, 4671, 1481);
	level.iz_route[level.iz_route.size] = (-3115, 3856, 1476);
	level.iz_route[level.iz_route.size] = (-3115, 2906, 1476);
	level.iz_route[level.iz_route.size] = (-3115, 2806, 1476);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (64.4520, -3247.5906, 1767.7047);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-27.6456, -3219.9094, 1768.9844);
	angles[1] = (0, 0, 0);
	at[1] = 0.3500;
	points[2] = (-124.2311, -3196.3110, 1767.3701);
	angles[2] = (0, 0, 0);
	at[2] = 0.7000;
	points[3] = (-223.5382, -3175.4763, 1763.9725);
	angles[3] = (0, 0, 0);
	at[3] = 1.0500;
	points[4] = (-418.9213, -3141.0789, 1754.3190);
	angles[4] = (0, 0, 0);
	at[4] = 1.7500;
	points[5] = (-714.1890, -3100.6497, 1735.6024);
	angles[5] = (0, 0, 0);
	at[5] = 2.8000;
	points[6] = (-911.4370, -3079.9841, 1721.5945);
	angles[6] = (0, 0, 0);
	at[6] = 3.5000;
	points[7] = (-1109.0039, -3064.3701, 1706.9529);
	angles[7] = (0, 0, 0);
	at[7] = 4.2000;
	points[8] = (-1407.8781, -3052.5276, 1684.5867);
	angles[8] = (0, 0, 0);
	at[8] = 5.2500;
	points[9] = (-1506.4606, -3052.9250, 1677.4409);
	angles[9] = (0, 0, 0);
	at[9] = 5.6000;
	points[10] = (-1607.2126, -3056.6929, 1670.4725);
	angles[10] = (0, 0, 0);
	at[10] = 5.9500;
	points[11] = (-1702.3898, -3064.9172, 1664.4646);
	angles[11] = (0, 0, 0);
	at[11] = 6.3000;
	points[12] = (-1803.3740, -3082.8071, 1659.4174);
	angles[12] = (0, 0, 0);
	at[12] = 6.6500;
	points[13] = (-1888, -3114.3899, 1657.7245);
	angles[13] = (0, 0, 0);
	at[13] = 7;
	points[14] = (-1976.3503, -3162.2954, 1658.0276);
	angles[14] = (0, 0, 0);
	at[14] = 7.3500;
	points[15] = (-2062.2009, -3217.3506, 1659.3859);
	angles[15] = (0, 0, 0);
	at[15] = 7.7000;
	points[16] = (-2141.4055, -3273.3779, 1661.2166);
	angles[16] = (0, 0, 0);
	at[16] = 8.0500;
	points[17] = (-2222.6692, -3334.9922, 1663.4764);
	angles[17] = (0, 0, 0);
	at[17] = 8.4000;
	points[18] = (-2298.8269, -3395.9844, 1665.8386);
	angles[18] = (0, 0, 0);
	at[18] = 8.7500;
	points[19] = (-2450.4253, -3525.7009, 1670.9685);
	angles[19] = (0, 0, 0);
	at[19] = 9.4500;
	points[20] = (-2596.8936, -3661.1377, 1676.1102);
	angles[20] = (0, 0, 0);
	at[20] = 10.1500;
	points[21] = (-2737.9961, -3801.9568, 1680.8503);
	angles[21] = (0, 0, 0);
	at[21] = 10.8500;
	points[22] = (-2805.7402, -3873.9961, 1682.9055);
	angles[22] = (0, 0, 0);
	at[22] = 11.2000;
	points[23] = (-2935.9841, -4024.1731, 1685.9567);
	angles[23] = (0, 0, 0);
	at[23] = 11.9000;
	points[24] = (-2998.1694, -4104.4883, 1686.5984);
	angles[24] = (0, 0, 0);
	at[24] = 12.2500;
	points[25] = (-3052.8977, -4184.3701, 1686.1771);
	angles[25] = (0, 0, 0);
	at[25] = 12.6000;
	points[26] = (-3100.8230, -4271.9688, 1683.7559);
	angles[26] = (0, 0, 0);
	at[26] = 12.9500;
	points[27] = (-3128.3464, -4357.9922, 1678.5000);
	angles[27] = (0, 0, 0);
	at[27] = 13.3000;
	points[28] = (-3146.2954, -4457.5195, 1670.8151);
	angles[28] = (0, 0, 0);
	at[28] = 13.6500;
	points[29] = (-3157.8899, -4556.5356, 1662.4528);
	angles[29] = (0, 0, 0);
	at[29] = 14;
	points[30] = (-3171.4724, -4754.0942, 1644.7126);
	angles[30] = (0, 0, 0);
	at[30] = 14.7000;
	points[31] = (-3175.3899, -4855.0396, 1635.3149);
	angles[31] = (0, 0, 0);
	at[31] = 15.0500;
	points[32] = (-3179.8032, -5151.8110, 1606.9686);
	angles[32] = (0, 0, 0);
	at[32] = 16.1000;
	points[33] = (-3177.3662, -5449.7246, 1577.8977);
	angles[33] = (0, 0, 0);
	at[33] = 17.1500;
	points[34] = (-3170.7283, -5747.7168, 1548.5985);
	angles[34] = (0, 0, 0);
	at[34] = 18.2000;
	points[35] = (-3168, -5843.8188, 1539.1653);
	angles[35] = (0, 0, 0);
	at[35] = 18.5500;
	points[36] = (-3164.8779, -5946.8110, 1529.0984);
	angles[36] = (0, 0, 0);
	at[36] = 18.9000;
	points[37] = (-3161.8701, -6042.8350, 1519.7836);
	angles[37] = (0, 0, 0);
	at[37] = 19.2500;
	points[38] = (-3158.7009, -6146.0630, 1509.9172);
	angles[38] = (0, 0, 0);
	at[38] = 19.6000;
	points[39] = (-3156.1694, -6239.5273, 1501.2205);
	angles[39] = (0, 0, 0);
	at[39] = 19.9500;
	points[40] = (-3155.6692, -6437.0864, 1486.8149);
	angles[40] = (0, 0, 0);
	at[40] = 20.6500;
	points[41] = (-3154.5120, -6535.4331, 1484.6024);
	angles[41] = (0, 0, 0);
	at[41] = 21;
	points[42] = (-3151.1143, -6634.7246, 1486.9292);
	angles[42] = (0, 0, 0);
	at[42] = 21.3500;
	points[43] = (-3143.9133, -6830.8271, 1497.3110);
	angles[43] = (0, 0, 0);
	at[43] = 22.0500;
	points[44] = (-3146.2639, -7329.2129, 1512.2008);
	angles[44] = (0, 0, 0);
	at[44] = 23.8000;
	points[45] = (-3138.8740, -7526.0630, 1514.7008);
	angles[45] = (0, 0, 0);
	at[45] = 24.5000;
	points[46] = (-3132.8977, -7625.3936, 1514.1851);
	angles[46] = (0, 0, 0);
	at[46] = 24.8500;
	points[47] = (-3122.9844, -7724.4492, 1514.1378);
	angles[47] = (0, 0, 0);
	at[47] = 25.2000;
	points[48] = (-3106.2124, -7822.2837, 1515.4724);
	angles[48] = (0, 0, 0);
	at[48] = 25.5500;
	points[49] = (-3076.8699, -7914.4097, 1519.7677);
	angles[49] = (0, 0, 0);
	at[49] = 25.9000;
	points[50] = (-2984.1614, -8089.6460, 1535.8031);
	angles[50] = (0, 0, 0);
	at[50] = 26.6000;
	points[51] = (-2884.4292, -8261.4961, 1553.3386);
	angles[51] = (0, 0, 0);
	at[51] = 27.3000;
	points[52] = (-2729.7441, -8514.8818, 1581.0276);
	angles[52] = (0, 0, 0);
	at[52] = 28.3500;
	points[53] = (-2621.8584, -8680.6299, 1600.9921);
	angles[53] = (0, 0, 0);
	at[53] = 29.0500;
	points[54] = (-2564.9685, -8758.6611, 1612.1771);
	angles[54] = (0, 0, 0);
	at[54] = 29.4000;
	points[55] = (-2502.4607, -8836.3389, 1624.7599);
	angles[55] = (0, 0, 0);
	at[55] = 29.7500;
	points[56] = (-2374.0276, -8985.2363, 1651.1339);
	angles[56] = (0, 0, 0);
	at[56] = 30.4500;
	points[57] = (-2239.9922, -9129.1729, 1679.6654);
	angles[57] = (0, 0, 0);
	at[57] = 31.1500;
	points[58] = (-2100.0945, -9266.6924, 1710.8976);
	angles[58] = (0, 0, 0);
	at[58] = 31.8500;
	points[59] = (-2027.2874, -9332.1660, 1727.9370);
	angles[59] = (0, 0, 0);
	at[59] = 32.2000;
	points[60] = (-1955.9449, -9391.3389, 1745.3818);
	angles[60] = (0, 0, 0);
	at[60] = 32.5500;
	points[61] = (-1878.3544, -9456.6543, 1766.6694);
	angles[61] = (0, 0, 0);
	at[61] = 32.9000;
	points[62] = (-1809.0945, -9516.1426, 1786.6693);
	angles[62] = (0, 0, 0);
	at[62] = 33.2500;
	points[63] = (-1732.7086, -9582.0078, 1809.1261);
	angles[63] = (0, 0, 0);
	at[63] = 33.6000;
	points[64] = (-1661.1456, -9643.5039, 1830.3110);
	angles[64] = (0, 0, 0);
	at[64] = 33.9500;
	points[65] = (-1584.5630, -9708.8584, 1853.0078);
	angles[65] = (0, 0, 0);
	at[65] = 34.3000;
	points[66] = (-1512.5039, -9769.8037, 1874.3151);
	angles[66] = (0, 0, 0);
	at[66] = 34.6500;
	points[67] = (-1362.2559, -9894.6455, 1918.3544);
	angles[67] = (0, 0, 0);
	at[67] = 35.3500;
	points[68] = (-1057.2914, -10135.5508, 2004.8661);
	angles[68] = (0, 0, 0);
	at[68] = 36.7500;
	points[69] = (-899.6614, -10251.1416, 2047.2599);
	angles[69] = (0, 0, 0);
	at[69] = 37.4500;
	points[70] = (-820.9803, -10305.7480, 2067.5906);
	angles[70] = (0, 0, 0);
	at[70] = 37.8000;
	points[71] = (-655.8268, -10411.7324, 2107.8740);
	angles[71] = (0, 0, 0);
	at[71] = 38.5000;
	points[72] = (-570.7047, -10460.4336, 2126.9763);
	angles[72] = (0, 0, 0);
	at[72] = 38.8500;
	points[73] = (-483.1221, -10504.8027, 2145.0078);
	angles[73] = (0, 0, 0);
	at[73] = 39.2000;
	points[74] = (-391.9063, -10542.5986, 2161.4016);
	angles[74] = (0, 0, 0);
	at[74] = 39.5500;
	points[75] = (-300.0461, -10567.6777, 2174.2048);
	angles[75] = (0, 0, 0);
	at[75] = 39.9000;
	points[76] = (-212.3299, -10576.4570, 2181.9292);
	angles[76] = (0, 0, 0);
	at[76] = 40.2500;
	points[77] = (-105.8020, -10578.0322, 2188.4097);
	angles[77] = (0, 0, 0);
	at[77] = 40.6000;
	points[78] = (-12.2943, -10575.2363, 2192.7874);
	angles[78] = (0, 0, 0);
	at[78] = 40.9500;
	points[79] = (91.4634, -10569.2129, 2196.7559);
	angles[79] = (0, 0, 0);
	at[79] = 41.3000;
	points[80] = (286.6445, -10552.1650, 2202.5513);
	angles[80] = (0, 0, 0);
	at[80] = 42;
	points[81] = (389.0815, -10540.9844, 2204.9646);
	angles[81] = (0, 0, 0);
	at[81] = 42.3500;
	points[82] = (584.0433, -10516.2998, 2208.6733);
	angles[82] = (0, 0, 0);
	at[82] = 43.0500;
	points[83] = (782.9134, -10487.2051, 2211.4844);
	angles[83] = (0, 0, 0);
	at[83] = 43.7500;
	points[84] = (978.5866, -10455.0400, 2213.4568);
	angles[84] = (0, 0, 0);
	at[84] = 44.4500;
	points[85] = (1273.0198, -10400.1182, 2215.1182);
	angles[85] = (0, 0, 0);
	at[85] = 45.5000;
	points[86] = (1467.6810, -10359.2129, 2215.3860);
	angles[86] = (0, 0, 0);
	at[86] = 46.2000;
	points[87] = (1661.8190, -10314.0166, 2214.9529);
	angles[87] = (0, 0, 0);
	at[87] = 46.9000;
	points[88] = (1756.9016, -10290, 2214.4568);
	angles[88] = (0, 0, 0);
	at[88] = 47.2500;
	points[89] = (1856.3544, -10263.2285, 2213.7087);
	angles[89] = (0, 0, 0);
	at[89] = 47.6000;
	points[90] = (1950.7993, -10235.9453, 2212.7520);
	angles[90] = (0, 0, 0);
	at[90] = 47.9500;
	points[91] = (2043.9567, -10206.8506, 2211.5198);
	angles[91] = (0, 0, 0);
	at[91] = 48.3000;
	points[92] = (2142.2991, -10172.9531, 2209.8188);
	angles[92] = (0, 0, 0);
	at[92] = 48.6500;
	points[93] = (2230.1023, -10138.7793, 2207.8308);
	angles[93] = (0, 0, 0);
	at[93] = 49;
	points[94] = (2326.0789, -10094.4482, 2204.8269);
	angles[94] = (0, 0, 0);
	at[94] = 49.3500;
	points[95] = (2403.4448, -10047.6377, 2201.1379);
	angles[95] = (0, 0, 0);
	at[95] = 49.7000;
	points[96] = (2471.6497, -9986.3779, 2195.5354);
	angles[96] = (0, 0, 0);
	at[96] = 50.0500;
	points[97] = (2538.9253, -9907.1650, 2187.7324);
	angles[97] = (0, 0, 0);
	at[97] = 50.4000;
	points[98] = (2594.8230, -9830.1973, 2179.8818);
	angles[98] = (0, 0, 0);
	at[98] = 50.7500;
	points[99] = (2652.1497, -9742.5596, 2170.7559);
	angles[99] = (0, 0, 0);
	at[99] = 51.1000;
	points[100] = (2701.4055, -9661.1416, 2162.1536);
	angles[100] = (0, 0, 0);
	at[100] = 51.4500;
	points[101] = (2750.5828, -9575, 2152.9448);
	angles[101] = (0, 0, 0);
	at[101] = 51.8000;
	points[102] = (2799.3621, -9485.1973, 2143.2480);
	angles[102] = (0, 0, 0);
	at[102] = 52.1500;
	points[103] = (2844.0195, -9399.5273, 2133.9211);
	angles[103] = (0, 0, 0);
	at[103] = 52.5000;
	points[104] = (2932.9055, -9220.2363, 2114.1694);
	angles[104] = (0, 0, 0);
	at[104] = 53.2000;
	points[105] = (3016.5276, -9042.0469, 2094.2598);
	angles[105] = (0, 0, 0);
	at[105] = 53.9000;
	points[106] = (3137.5828, -8769.7246, 2063.2834);
	angles[106] = (0, 0, 0);
	at[106] = 54.9500;
	points[107] = (3290.0278, -8405.1973, 2020.5630);
	angles[107] = (0, 0, 0);
	at[107] = 56.3500;
	points[108] = (3364.5198, -8218.8184, 1997.9135);
	angles[108] = (0, 0, 0);
	at[108] = 57.0500;
	points[109] = (3398.8545, -8131.0635, 1986.9568);
	angles[109] = (0, 0, 0);
	at[109] = 57.4000;
	points[110] = (3436.4922, -8033.3862, 1974.4449);
	angles[110] = (0, 0, 0);
	at[110] = 57.7500;
	points[111] = (3470.0947, -7944.8423, 1962.6615);
	angles[111] = (0, 0, 0);
	at[111] = 58.1000;
	points[112] = (3506.5710, -7846.8901, 1948.7520);
	angles[112] = (0, 0, 0);
	at[112] = 58.4500;
	points[113] = (3536.2166, -7763.8584, 1934.9489);
	angles[113] = (0, 0, 0);
	at[113] = 58.8000;
	points[114] = (3560.9685, -7670.0396, 1914.1300);
	angles[114] = (0, 0, 0);
	at[114] = 59.1500;
	points[115] = (3576.5195, -7575.3545, 1888.4094);
	angles[115] = (0, 0, 0);
	at[115] = 59.5000;
	points[116] = (3584.5906, -7480.7871, 1859.2009);
	angles[116] = (0, 0, 0);
	at[116] = 59.8500;
	points[117] = (3586.6262, -7386.7324, 1827.6102);
	angles[117] = (0, 0, 0);
	at[117] = 60.2000;
	points[118] = (3583.7952, -7293.3071, 1794.5118);
	angles[118] = (0, 0, 0);
	at[118] = 60.5500;
	points[119] = (3577.0591, -7200.2754, 1760.6536);
	angles[119] = (0, 0, 0);
	at[119] = 60.9000;
	points[120] = (3555.3071, -7013.7007, 1694.1851);
	angles[120] = (0, 0, 0);
	at[120] = 61.6000;
	points[121] = (3542.7283, -6918.7798, 1665.3740);
	angles[121] = (0, 0, 0);
	at[121] = 61.9500;
	points[122] = (3529.9646, -6824.0947, 1645.6851);
	angles[122] = (0, 0, 0);
	at[122] = 62.3000;
	points[123] = (3513.0078, -6727.9927, 1629.7245);
	angles[123] = (0, 0, 0);
	at[123] = 62.6500;
	points[124] = (3474.3269, -6535.7876, 1601.4646);
	angles[124] = (0, 0, 0);
	at[124] = 63.3500;
	points[125] = (3409.4685, -6246.5356, 1563.1495);
	angles[125] = (0, 0, 0);
	at[125] = 64.4000;
	points[126] = (3362.1851, -6055.4727, 1539.6771);
	angles[126] = (0, 0, 0);
	at[126] = 65.1000;
	points[127] = (3335.7046, -5959.3311, 1528.5472);
	angles[127] = (0, 0, 0);
	at[127] = 65.4500;
	points[128] = (3302.7126, -5868.1890, 1519.7047);
	angles[128] = (0, 0, 0);
	at[128] = 65.8000;
	points[129] = (3256.6575, -5780.6299, 1515.2794);
	angles[129] = (0, 0, 0);
	at[129] = 66.1500;
	points[130] = (3204.3386, -5695.8662, 1513.2087);
	angles[130] = (0, 0, 0);
	at[130] = 66.5000;
	points[131] = (3148.7600, -5613.3857, 1512.3977);
	angles[131] = (0, 0, 0);
	at[131] = 66.8500;
	points[132] = (3031.1770, -5452.2046, 1511.9214);
	angles[132] = (0, 0, 0);
	at[132] = 67.5500;
	points[133] = (2969.3071, -5376.5752, 1510.3582);
	angles[133] = (0, 0, 0);
	at[133] = 67.9000;
	points[134] = (2835.3623, -5229.8823, 1507.4410);
	angles[134] = (0, 0, 0);
	at[134] = 68.6000;
	points[135] = (2697.4331, -5086.1421, 1505.0630);
	angles[135] = (0, 0, 0);
	at[135] = 69.3000;
	points[136] = (2627.5474, -5017.7954, 1504.7795);
	angles[136] = (0, 0, 0);
	at[136] = 69.6500;
	points[137] = (2336.3857, -4745.7085, 1504.8347);
	angles[137] = (0, 0, 0);
	at[137] = 71.0500;
	points[138] = (2200.6377, -4604.1338, 1490.5828);
	angles[138] = (0, 0, 0);
	at[138] = 71.7500;
	points[139] = (2127.4331, -4537.3623, 1487.7795);
	angles[139] = (0, 0, 0);
	at[139] = 72.1000;
	points[140] = (2049.6653, -4476.2598, 1490.7599);
	angles[140] = (0, 0, 0);
	at[140] = 72.4500;
	points[141] = (1969.0591, -4420.3545, 1498.4253);
	angles[141] = (0, 0, 0);
	at[141] = 72.8000;
	points[142] = (1809.8584, -4313.6616, 1521.2875);
	angles[142] = (0, 0, 0);
	at[142] = 73.5000;
	points[143] = (1722.5433, -4255, 1534.8542);
	angles[143] = (0, 0, 0);
	at[143] = 73.8500;
	points[144] = (1644.8859, -4202.9526, 1547.0984);
	angles[144] = (0, 0, 0);
	at[144] = 74.2000;
	points[145] = (1312.9055, -3982.5984, 1599.8385);
	angles[145] = (0, 0, 0);
	at[145] = 75.6000;
	points[146] = (982.4173, -3768.2205, 1651.4489);
	angles[146] = (0, 0, 0);
	at[146] = 77;
	points[147] = (730.8859, -3609.9922, 1689.1772);
	angles[147] = (0, 0, 0);
	at[147] = 78.0500;
	points[148] = (476.1260, -3456.6890, 1724.8859);
	angles[148] = (0, 0, 0);
	at[148] = 79.1000;
	points[149] = (394.0039, -3409.5630, 1735.5354);
	angles[149] = (0, 0, 0);
	at[149] = 79.4500;
	points[150] = (302.5835, -3359.0945, 1746.6221);
	angles[150] = (0, 0, 0);
	at[150] = 79.8000;
	points[151] = (219.0276, -3315.5471, 1755.7559);
	angles[151] = (0, 0, 0);
	at[151] = 80.1500;
	points[152] = (123.9110, -3270.8149, 1764.2598);
	angles[152] = (0, 0, 0);
	at[152] = 80.5000;
	points[153] = (64.4520, -3247.5906, 1767.7047);
	angles[153] = (0, 0, 0);
	at[153] = 80.7667;
	mover = getEnt("iz_obj_0", "targetname");
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
