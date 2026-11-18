main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_sw_yoshis_island", 0);

	setExpFog(0, 31988.1895, 0.5020, 1, 1, 0);

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
	ambientPlay("iz_0_syi", 2);
	level thread iz_music("iz_7_se_cr_dsy_env_birds");
}

iz_music(alias)
{
	for (;;)
	{
		level waittill("connected", player);
		player thread iz_music_player(alias);
	}
}

iz_music_player(alias)
{
	self endon("disconnect");
	self waittill("spawned_player");
	self playLocalSound(alias);
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
	level.iz_route[level.iz_route.size] = (7415, -3759, 4689);
	level.iz_route[level.iz_route.size] = (7448, -2771, 4660);
	level.iz_route[level.iz_route.size] = (7476, -1873, 4657);
	level.iz_route[level.iz_route.size] = (7457, -852, 4661);
	level.iz_route[level.iz_route.size] = (7157, -121, 4671);
	level.iz_route[level.iz_route.size] = (6496, 351, 4702);
	level.iz_route[level.iz_route.size] = (5678, 594, 4769);
	level.iz_route[level.iz_route.size] = (4959, 982, 4857);
	level.iz_route[level.iz_route.size] = (4705, 1683, 4988);
	level.iz_route[level.iz_route.size] = (4643, 2515, 5152);
	level.iz_route[level.iz_route.size] = (4243, 3131, 5278);
	level.iz_route[level.iz_route.size] = (3564, 3445, 5413);
	level.iz_route[level.iz_route.size] = (2818, 3345, 5477);
	level.iz_route[level.iz_route.size] = (2109, 2994, 5485);
	level.iz_route[level.iz_route.size] = (1321, 2407, 5455);
	level.iz_route[level.iz_route.size] = (-11, 1516, 4464);
	level.iz_route[level.iz_route.size] = (-1166, 849, 4477);
	level.iz_route[level.iz_route.size] = (-2327, 82, 4457);
	level.iz_route[level.iz_route.size] = (-3266, -618, 4447);
	level.iz_route[level.iz_route.size] = (-3652, -1486, 4494);
	level.iz_route[level.iz_route.size] = (-3433, -2329, 4567);
	level.iz_route[level.iz_route.size] = (-3032, -2926, 4614);
	level.iz_route[level.iz_route.size] = (-2632, -3600, 4681);
	level.iz_route[level.iz_route.size] = (-2041, -4110, 4747);
	level.iz_route[level.iz_route.size] = (-1321, -4371, 4793);
	level.iz_route[level.iz_route.size] = (-554, -4497, 4866);
	level.iz_route[level.iz_route.size] = (416, -4577, 5004);
	level.iz_route[level.iz_route.size] = (1074, -4946, 5119);
	level.iz_route[level.iz_route.size] = (1347, -5483, 5168);
	level.iz_route[level.iz_route.size] = (1421, -6162, 5206);
	level.iz_route[level.iz_route.size] = (1354, -6965, 5293);
	level.iz_route[level.iz_route.size] = (1290, -7673, 5426);
	level.iz_route[level.iz_route.size] = (1252, -8513, 5598);
	level.iz_route[level.iz_route.size] = (1444, -9262, 5856);
	level.iz_route[level.iz_route.size] = (1788, -9950, 6161);
	level.iz_route[level.iz_route.size] = (2300, -10365, 6418);
	level.iz_route[level.iz_route.size] = (2885, -10511, 6700);
	level.iz_route[level.iz_route.size] = (3450, -10318, 6881);
	level.iz_route[level.iz_route.size] = (3824, -9927, 7051);
	level.iz_route[level.iz_route.size] = (4005, -9424, 7215);
	level.iz_route[level.iz_route.size] = (4007, -8953, 7370);
	level.iz_route[level.iz_route.size] = (3935, -8605, 7454);
	level.iz_route[level.iz_route.size] = (2966, -5566, 8509);
	level.iz_route[level.iz_route.size] = (2738, -4822, 8840);
	level.iz_route[level.iz_route.size] = (2473, -4051, 8971);
	level.iz_route[level.iz_route.size] = (2009, -2410, 9048);
	level.iz_route[level.iz_route.size] = (1803, -1597, 9120);
	level.iz_route[level.iz_route.size] = (1815, -538, 9341);
	level.iz_route[level.iz_route.size] = (2357, 171, 9452);
	level.iz_route[level.iz_route.size] = (3170, 486, 9421);
	level.iz_route[level.iz_route.size] = (3976, 170, 9199);
	level.iz_route[level.iz_route.size] = (4502, -427, 8883);
	level.iz_route[level.iz_route.size] = (5155, -1760, 8294);
	level.iz_route[level.iz_route.size] = (6188, -3135, 7881);
	level.iz_route[level.iz_route.size] = (7266, -4664, 7231);
	level.iz_route[level.iz_route.size] = (8758, -7038, 5932);
	level.iz_route[level.iz_route.size] = (9548, -7714, 5401);
	level.iz_route[level.iz_route.size] = (10051, -8770, 5320);
	level.iz_route[level.iz_route.size] = (10116, -10052, 5245);
	level.iz_route[level.iz_route.size] = (9632, -11035, 5300);
	level.iz_route[level.iz_route.size] = (8794, -11395, 5299);
	level.iz_route[level.iz_route.size] = (7950, -11391, 5287);
	level.iz_route[level.iz_route.size] = (7199, -10912, 5203);
	level.iz_route[level.iz_route.size] = (6765, -10018, 5096);
	level.iz_route[level.iz_route.size] = (6924, -9106, 4969);
	level.iz_route[level.iz_route.size] = (7372, -8110, 4812);
	level.iz_route[level.iz_route.size] = (7397, -5851, 4694);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (5679.2524, 80.5756, 4736.9688);
	angles[0] = (0, -50.8458, 0);
	at[0] = 0;
	points[1] = (5684.8032, 93.0508, 4737.3623);
	angles[1] = (0, -40.7246, 0);
	at[1] = 0.0500;
	points[2] = (5698.0713, 116.0539, 4738.2676);
	angles[2] = (0, -32.8090, 0);
	at[2] = 0.1500;
	points[3] = (5764.4492, 231.0705, 4742.7954);
	angles[3] = (0, -29.9941, 0);
	at[3] = 0.6500;
	points[4] = (5771.1025, 242.5721, 4743.2676);
	angles[4] = (0, -27.4324, 0);
	at[4] = 0.7000;
	points[5] = (5778.6616, 268.0783, 4743.8188);
	angles[5] = (0, -19.8437, 0);
	at[5] = 0.8000;
	points[6] = (5786.4961, 293.4662, 4744.4097);
	angles[6] = (0, -17.8504, 0);
	at[6] = 0.9000;
	points[7] = (5849.1338, 496.5709, 4749.1733);
	angles[7] = (0, -17.1423, 0);
	at[7] = 1.7000;
	points[8] = (5960.5513, 877.7638, 4783.3857);
	angles[8] = (0, -16.2905, 0);
	at[8] = 3.2000;
	points[9] = (6004.2520, 1028.7638, 4809.9214);
	angles[9] = (0, -16.1333, 0);
	at[9] = 3.8000;
	points[10] = (6044.1338, 1152.3622, 4837.9531);
	angles[10] = (0, -17.9518, 0);
	at[10] = 4.3000;
	points[11] = (6048.1499, 1164.7126, 4840.7480);
	angles[11] = (0, -9.1119, 0);
	at[11] = 4.3500;
	points[12] = (6040.1973, 1175.8662, 4843.8188);
	angles[12] = (0, 9.1266, 0);
	at[12] = 4.4000;
	points[13] = (6033.9370, 1187.1851, 4846.8506);
	angles[13] = (0, 18.7797, 0);
	at[13] = 4.4500;
	points[14] = (6027.6772, 1198.5079, 4849.8423);
	angles[14] = (0, 23.7545, 0);
	at[14] = 4.5000;
	points[15] = (6021.4175, 1209.8268, 4852.8740);
	angles[15] = (0, 35.2562, 0);
	at[15] = 4.5500;
	points[16] = (6007.7559, 1212.0157, 4853.8979);
	angles[16] = (0, 54.9184, 0);
	at[16] = 4.6000;
	points[17] = (5994.9214, 1215.2047, 4855.1182);
	angles[17] = (0, 65.2204, 0);
	at[17] = 4.6500;
	points[18] = (5969.2520, 1221.5826, 4857.5986);
	angles[18] = (0, 73.2137, 0);
	at[18] = 4.7500;
	points[19] = (5956.3784, 1224.7716, 4858.8584);
	angles[19] = (0, 83.8899, 0);
	at[19] = 4.8000;
	points[20] = (5945.7871, 1216.7401, 4857.2837);
	angles[20] = (0, 103.9124, 0);
	at[20] = 4.8500;
	points[21] = (5935.1182, 1208.9606, 4855.7480);
	angles[21] = (0, 114.6329, 0);
	at[21] = 4.9000;
	points[22] = (5924.4492, 1201.1812, 4854.2124);
	angles[22] = (0, 120.2090, 0);
	at[22] = 4.9500;
	points[23] = (5903.1104, 1185.6260, 4851.1812);
	angles[23] = (0, 124.5557, 0);
	at[23] = 5.0500;
	points[24] = (5895.7090, 1175.4567, 4849.0947);
	angles[24] = (0, 136.6969, 0);
	at[24] = 5.1000;
	points[25] = (5890.9844, 1163.3110, 4846.4961);
	angles[25] = (0, 147.3301, 0);
	at[25] = 5.1500;
	points[26] = (5886.2598, 1151.1653, 4843.9370);
	angles[26] = (0, 152.8687, 0);
	at[26] = 5.2000;
	points[27] = (5876.7720, 1126.8701, 4838.7793);
	angles[27] = (0, 157.1849, 0);
	at[27] = 5.3000;
	points[28] = (5805.9448, 944.4882, 4801.0234);
	angles[28] = (0, 159.2241, 0);
	at[28] = 6.0500;
	points[29] = (5652.6377, 520.8898, 4767.0864);
	angles[29] = (0, 159.9291, 0);
	at[29] = 7.7500;
	points[30] = (5577.2441, 322.1020, 4766.8506);
	angles[30] = (0, 159.2400, 0);
	at[30] = 8.5500;
	points[31] = (5559.5278, 286.4256, 4767.9136);
	angles[31] = (0, 153.9837, 0);
	at[31] = 8.7000;
	points[32] = (5517.5591, 203.4626, 4770.5903);
	angles[32] = (0, 153.1754, 0);
	at[32] = 9.0500;
	points[33] = (5507.3618, 166.4224, 4761.4570);
	angles[33] = (0, 164.3041, 0);
	at[33] = 9.2000;
	points[34] = (5492.6377, 104.2567, 4743.1890);
	angles[34] = (0, 166.5992, 0);
	at[34] = 9.4500;
	points[35] = (5489.7241, 91.8236, 4739.5669);
	angles[35] = (0, 176.1915, 0);
	at[35] = 9.5000;
	points[36] = (5499.7637, 81.7031, 4737.6377);
	angles[36] = (0, 195.7232, 0);
	at[36] = 9.5500;
	points[37] = (5507.5986, 71.1831, 4735.4331);
	angles[37] = (0, 205.9217, 0);
	at[37] = 9.6000;
	points[38] = (5515.3940, 60.6626, 4733.2285);
	angles[38] = (0, 211.1401, 0);
	at[38] = 9.6500;
	points[39] = (5531.0239, 39.6224, 4728.8188);
	angles[39] = (0, 215.1656, 0);
	at[39] = 9.7500;
	points[40] = (5538.8193, 29.1021, 4726.6143);
	angles[40] = (0, 227.1292, 0);
	at[40] = 9.8000;
	points[41] = (5553.5044, 34.8896, 4728.5039);
	angles[41] = (0, 251.4584, 0);
	at[41] = 9.8500;
	points[42] = (5566.6143, 36.9198, 4729.4883);
	angles[42] = (0, 264.6546, 0);
	at[42] = 9.9000;
	points[43] = (5592.7954, 40.9803, 4731.4175);
	angles[43] = (0, 275.0810, 0);
	at[43] = 10;
	points[44] = (5632.0864, 47.0713, 4734.2915);
	angles[44] = (0, 278.3111, 0);
	at[44] = 10.1500;
	points[45] = (5643.0312, 54.3177, 4734.9214);
	angles[45] = (0, 291.6769, 0);
	at[45] = 10.2000;
	points[46] = (5653.7798, 62.1126, 4735.5513);
	angles[46] = (0, 298.6313, 0);
	at[46] = 10.2500;
	points[47] = (5675.2754, 77.7020, 4736.7324);
	angles[47] = (0, 304.0381, 0);
	at[47] = 10.3500;
	points[48] = (5679.2524, 80.5756, 4736.9688);
	angles[48] = (0, 309.1542, 0);
	at[48] = 10.3667;
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
	points[0] = (-2291.2363, -866.3347, 4454.0552);
	angles[0] = (0, -56.6941, 0);
	at[0] = 0;
	points[1] = (-2656.0435, -311.0921, 4456.5747);
	angles[1] = (0, -56.6941, 0);
	at[1] = 2.5000;
	points[2] = (-3057.3149, 267.6319, 4456.5747);
	angles[2] = (0, -55.2560, 0);
	at[2] = 5.1500;
	points[3] = (-3059.8386, 271.2712, 4456.5747);
	angles[3] = (0, -55.2560, 0);
	at[3] = 5.2000;
	points[4] = (-3059.8386, 271.2712, 4456.5747);
	angles[4] = (0, -55.2560, 0);
	at[4] = 5.9000;
	points[5] = (-3053.2639, 261.7886, 4456.5747);
	angles[5] = (0, -55.2560, 0);
	at[5] = 5.9500;
	points[6] = (-2659.4883, -305.9646, 4456.5747);
	angles[6] = (0, -55.2560, 0);
	at[6] = 8.5500;
	points[7] = (-2287.3308, -872.2795, 4454.0161);
	angles[7] = (0, -56.6941, 0);
	at[7] = 11.1000;
	points[8] = (-2287.3308, -872.2795, 4454.0161);
	angles[8] = (0, -56.6941, 0);
	at[8] = 11.8500;
	points[9] = (-2291.2363, -866.3347, 4454.0552);
	angles[9] = (0, -56.6941, 0);
	at[9] = 11.8667;
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
	points[0] = (2880.8308, 4293.0708, 5744.0552);
	angles[0] = (0, 147.4114, 0);
	at[0] = 0;
	points[1] = (2825.9802, 4174.7246, 5718.8188);
	angles[1] = (0, 156.7438, 0);
	at[1] = 0.7500;
	points[2] = (2816.2756, 4147.6772, 5712.9526);
	angles[2] = (0, 159.5996, 0);
	at[2] = 0.9167;
	points[3] = (2806.8975, 4105.6299, 5703.2285);
	angles[3] = (0, 166.2852, 0);
	at[3] = 1.1667;
	points[4] = (2785.5671, 3977.2048, 5672.6382);
	angles[4] = (0, 171.5222, 0);
	at[4] = 1.9167;
	points[5] = (2781.7754, 3909.0552, 5655.5513);
	angles[5] = (0, 177.9734, 0);
	at[5] = 2.3333;
	points[6] = (2782.0669, 3895.6890, 5640.7480);
	angles[6] = (0, 179.3821, 0);
	at[6] = 2.4167;
	points[7] = (2786.0828, 3856, 5621.1416);
	angles[7] = (0, 185.6653, 0);
	at[7] = 2.6667;
	points[8] = (2796.2834, 3832, 5608.7402);
	angles[8] = (0, 199.1193, 0);
	at[8] = 2.8333;
	points[9] = (2812.9331, 3810.5237, 5596.7720);
	angles[9] = (0, 211.7450, 0);
	at[9] = 3;
	points[10] = (2830.7795, 3790.0708, 5585.1577);
	angles[10] = (0, 218.0509, 0);
	at[10] = 3.1667;
	points[11] = (2840.0317, 3779.9724, 5569.6455);
	angles[11] = (0, 219.9187, 0);
	at[11] = 3.2500;
	points[12] = (2909.9841, 3712.8308, 5545.5908);
	angles[12] = (0, 228.3734, 0);
	at[12] = 3.8333;
	points[13] = (2978.2441, 3659.8701, 5525.1577);
	angles[13] = (0, 232.7461, 0);
	at[13] = 4.3333;
	points[14] = (3026.3860, 3627.4409, 5511.9292);
	angles[14] = (0, 236.7186, 0);
	at[14] = 4.6667;
	points[15] = (3052.3389, 3616.3188, 5506.7715);
	angles[15] = (0, 244.2421, 0);
	at[15] = 4.8333;
	points[16] = (3094.6338, 3604.0591, 5499.9609);
	angles[16] = (0, 252.3397, 0);
	at[16] = 5.0833;
	points[17] = (3166.2324, 3587.8860, 5489.3696);
	angles[17] = (0, 257.6245, 0);
	at[17] = 5.5000;
	points[18] = (3209.0159, 3581.2874, 5483.6616);
	angles[18] = (0, 261.3537, 0);
	at[18] = 5.7500;
	points[19] = (3253.2363, 3580.0669, 5478.8979);
	angles[19] = (0, 267.4589, 0);
	at[19] = 6;
	points[20] = (3341.5117, 3582.8860, 5469.7642);
	angles[20] = (0, 272.4705, 0);
	at[20] = 6.5000;
	points[21] = (3385.6812, 3587.0789, 5465.3936);
	angles[21] = (0, 275.3909, 0);
	at[21] = 6.7500;
	points[22] = (3413.7285, 3593.2048, 5463.3462);
	angles[22] = (0, 280.5097, 0);
	at[22] = 6.9167;
	points[23] = (3526.0474, 3630.7166, 5456.8896);
	angles[23] = (0, 289.7562, 0);
	at[23] = 7.5833;
	points[24] = (3592.9646, 3660.6536, 5455.2363);
	angles[24] = (0, 296.0175, 0);
	at[24] = 8;
	points[25] = (3640.0156, 3696.3936, 5458.4648);
	angles[25] = (0, 306.8728, 0);
	at[25] = 8.3333;
	points[26] = (3695.3425, 3745.0156, 5465.9844);
	angles[26] = (0, 311.5632, 0);
	at[26] = 8.7500;
	points[27] = (3747.4922, 3796.8425, 5475.7085);
	angles[27] = (0, 315.7742, 0);
	at[27] = 9.1667;
	points[28] = (3763.5002, 3819.0710, 5480.4722);
	angles[28] = (0, 322.1450, 0);
	at[28] = 9.3333;
	points[29] = (3770.2009, 3831.0945, 5489.4883);
	angles[29] = (0, 325.7207, 0);
	at[29] = 9.4167;
	points[30] = (3787.6458, 3866.8230, 5508.9370);
	angles[30] = (0, 332.5913, 0);
	at[30] = 9.6667;
	points[31] = (3818.4685, 3939.7244, 5549.4487);
	angles[31] = (0, 337.5294, 0);
	at[31] = 10.1667;
	points[32] = (3823.3582, 3952.1655, 5560.9448);
	angles[32] = (0, 337.9911, 0);
	at[32] = 10.2500;
	points[33] = (3832.7087, 3976.9292, 5566.6929);
	angles[33] = (0, 338.9670, 0);
	at[33] = 10.4167;
	points[34] = (3865.6733, 4072.2834, 5589.3306);
	angles[34] = (0, 341.5756, 0);
	at[34] = 11;
	points[35] = (3886.9883, 4156.3779, 5609.7642);
	angles[35] = (0, 348.2564, 0);
	at[35] = 11.5000;
	points[36] = (3884.0276, 4184.0552, 5617.0474);
	angles[36] = (0, 361.8401, 0);
	at[36] = 11.6667;
	points[37] = (3874.0039, 4211.0630, 5624.6064);
	angles[37] = (0, 374.4231, 0);
	at[37] = 11.8333;
	points[38] = (3840.6655, 4274.5273, 5642.9136);
	angles[38] = (0, 388.3694, 0);
	at[38] = 12.2500;
	points[39] = (3806.5552, 4319.6064, 5656.5352);
	angles[39] = (0, 398.8956, 0);
	at[39] = 12.5833;
	points[40] = (3771.9292, 4345.9448, 5665.3149);
	angles[40] = (0, 410.7275, 0);
	at[40] = 12.8333;
	points[41] = (3672.8857, 4406.6929, 5689.4097);
	angles[41] = (0, 419.9614, 0);
	at[41] = 13.5000;
	points[42] = (3608.0315, 4436.4565, 5702.7563);
	angles[42] = (0, 427.4686, 0);
	at[42] = 13.9167;
	points[43] = (3536.9529, 4455.9058, 5714.0947);
	angles[43] = (0, 434.8227, 0);
	at[43] = 14.3333;
	points[44] = (3408.3071, 4485, 5734.4487);
	angles[44] = (0, 437.9655, 0);
	at[44] = 15.0833;
	points[45] = (3336.5195, 4497.9922, 5745.0391);
	angles[45] = (0, 440.3137, 0);
	at[45] = 15.5000;
	points[46] = (3293.1455, 4499.6064, 5750.1577);
	angles[46] = (0, 448.0541, 0);
	at[46] = 15.7500;
	points[47] = (3220.1890, 4488.2285, 5755.7480);
	angles[47] = (0, 459.5225, 0);
	at[47] = 16.1667;
	points[48] = (3134.8347, 4465.5122, 5759.8428);
	angles[48] = (0, 466.2445, 0);
	at[48] = 16.6667;
	points[49] = (3080.4250, 4442.4409, 5760.3149);
	angles[49] = (0, 472.8207, 0);
	at[49] = 17;
	points[50] = (3000.3821, 4403.8584, 5759.8428);
	angles[50] = (0, 476.0952, 0);
	at[50] = 17.5000;
	points[51] = (2948.0474, 4376.0239, 5758.8188);
	angles[51] = (0, 478.3866, 0);
	at[51] = 17.8333;
	points[52] = (2925.2559, 4358.3467, 5756.6929);
	angles[52] = (0, 485.9017, 0);
	at[52] = 18;
	points[53] = (2898.7007, 4323.5435, 5750.2363);
	angles[53] = (0, 500.5055, 0);
	at[53] = 18.2500;
	points[54] = (2880.8308, 4293.0708, 5744.0552);
	angles[54] = (0, 507.4114, 0);
	at[54] = 18.4500;
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
	points[0] = (-635.1771, 753.1890, 3673.3977);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-635.1771, 753.1890, 3673.3977);
	angles[1] = (0, 0, 0);
	at[1] = 5.0667;
	points[2] = (-635.1771, 753.1890, 3704.4883);
	angles[2] = (0, 0, 0);
	at[2] = 5.1333;
	points[3] = (-635.1771, 753.1890, 3805.0237);
	angles[3] = (0, 0, 0);
	at[3] = 5.2000;
	points[4] = (-635.1771, 753.1890, 3898.5042);
	angles[4] = (0, 0, 0);
	at[4] = 5.2667;
	points[5] = (-635.1771, 753.1890, 3984.9214);
	angles[5] = (0, 0, 0);
	at[5] = 5.3333;
	points[6] = (-635.1771, 753.1890, 4064.2915);
	angles[6] = (0, 0, 0);
	at[6] = 5.4000;
	points[7] = (-635.1771, 753.1890, 4136.6143);
	angles[7] = (0, 0, 0);
	at[7] = 5.4667;
	points[8] = (-635.1771, 753.1890, 4201.8896);
	angles[8] = (0, 0, 0);
	at[8] = 5.5333;
	points[9] = (-635.1771, 753.1890, 4260.0786);
	angles[9] = (0, 0, 0);
	at[9] = 5.6000;
	points[10] = (-635.1771, 753.1890, 4311.2202);
	angles[10] = (0, 0, 0);
	at[10] = 5.6667;
	points[11] = (-635.1771, 753.1890, 4355.3149);
	angles[11] = (0, 0, 0);
	at[11] = 5.7333;
	points[12] = (-635.1771, 753.1890, 4392.3623);
	angles[12] = (0, 0, 0);
	at[12] = 5.8000;
	points[13] = (-635.1771, 753.1890, 4422.3623);
	angles[13] = (0, 0, 0);
	at[13] = 5.8667;
	points[14] = (-635.1771, 753.1890, 4445.2759);
	angles[14] = (0, 0, 0);
	at[14] = 5.9333;
	points[15] = (-635.1771, 753.1890, 4461.1421);
	angles[15] = (0, 0, 0);
	at[15] = 6;
	points[16] = (-635.1771, 753.1890, 4469.9609);
	angles[16] = (0, 0, 0);
	at[16] = 6.0667;
	points[17] = (-635.1771, 753.1890, 4471.9683);
	angles[17] = (0, 0, 0);
	at[17] = 6.1333;
	points[18] = (-635.1771, 753.1890, 4482.9136);
	angles[18] = (0, 0, 0);
	at[18] = 6.2000;
	points[19] = (-635.1771, 753.1890, 4486.6533);
	angles[19] = (0, 0, 0);
	at[19] = 6.2667;
	points[20] = (-635.1771, 753.1890, 4480.3149);
	angles[20] = (0, 0, 0);
	at[20] = 6.3333;
	points[21] = (-635.1771, 753.1890, 3686.6260);
	angles[21] = (0, 0, 0);
	at[21] = 9.3333;
	points[22] = (-635.1771, 753.1890, 3673.3977);
	angles[22] = (0, 0, 0);
	at[22] = 9.4000;
	points[23] = (-635.1771, 753.1890, 3673.3977);
	angles[23] = (0, 0, 0);
	at[23] = 12.4833;
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
	points[0] = (-1194.2874, 1158.8386, 4388.3462);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-1194.2874, 1158.8386, 3682.8191);
	angles[1] = (0, 0, 0);
	at[1] = 2.6667;
	points[2] = (-1194.2874, 1158.8386, 3669.5908);
	angles[2] = (0, 0, 0);
	at[2] = 2.7333;
	points[3] = (-1194.2874, 1158.8386, 3669.5908);
	angles[3] = (0, 0, 0);
	at[3] = 10.8667;
	points[4] = (-1194.2874, 1158.8386, 3674.4412);
	angles[4] = (0, 0, 0);
	at[4] = 10.9333;
	points[5] = (-1194.2874, 1158.8386, 3776.7402);
	angles[5] = (0, 0, 0);
	at[5] = 11;
	points[6] = (-1194.2874, 1158.8386, 3871.9841);
	angles[6] = (0, 0, 0);
	at[6] = 11.0667;
	points[7] = (-1194.2874, 1158.8386, 3960.1575);
	angles[7] = (0, 0, 0);
	at[7] = 11.1333;
	points[8] = (-1194.2874, 1158.8386, 4041.2993);
	angles[8] = (0, 0, 0);
	at[8] = 11.2000;
	points[9] = (-1194.2874, 1158.8386, 4115.3936);
	angles[9] = (0, 0, 0);
	at[9] = 11.2667;
	points[10] = (-1194.2874, 1158.8386, 4182.4019);
	angles[10] = (0, 0, 0);
	at[10] = 11.3333;
	points[11] = (-1194.2874, 1158.8386, 4242.3623);
	angles[11] = (0, 0, 0);
	at[11] = 11.4000;
	points[12] = (-1194.2874, 1158.8386, 4295.2754);
	angles[12] = (0, 0, 0);
	at[12] = 11.4667;
	points[13] = (-1194.2874, 1158.8386, 4341.1416);
	angles[13] = (0, 0, 0);
	at[13] = 11.5333;
	points[14] = (-1194.2874, 1158.8386, 4379.9604);
	angles[14] = (0, 0, 0);
	at[14] = 11.6000;
	points[15] = (-1194.2874, 1158.8386, 4411.6929);
	angles[15] = (0, 0, 0);
	at[15] = 11.6667;
	points[16] = (-1194.2874, 1158.8386, 4436.3779);
	angles[16] = (0, 0, 0);
	at[16] = 11.7333;
	points[17] = (-1194.2874, 1158.8386, 4454.0161);
	angles[17] = (0, 0, 0);
	at[17] = 11.8000;
	points[18] = (-1194.2874, 1158.8386, 4464.6064);
	angles[18] = (0, 0, 0);
	at[18] = 11.8667;
	points[19] = (-1194.2874, 1158.8386, 4468.1494);
	angles[19] = (0, 0, 0);
	at[19] = 11.9333;
	points[20] = (-1194.2874, 1158.8386, 4482.8345);
	angles[20] = (0, 0, 0);
	at[20] = 12.0667;
	points[21] = (-1194.2874, 1158.8386, 4480.9448);
	angles[21] = (0, 0, 0);
	at[21] = 12.1333;
	points[22] = (-1194.2874, 1158.8386, 4388.3462);
	angles[22] = (0, 0, 0);
	at[22] = 12.4833;
	mover = getEnt("iz_obj_4", "targetname");
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
