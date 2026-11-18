main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_wiiu_sunshineairpor", 0);

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
	ambientPlay("iz_0_ussa", 2);
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
	level.iz_route[level.iz_route.size] = (9811, 10661, 13846);
	level.iz_route[level.iz_route.size] = (9823, 9081, 13845);
	level.iz_route[level.iz_route.size] = (9770, 7782, 13854);
	level.iz_route[level.iz_route.size] = (9152, 7035, 13870);
	level.iz_route[level.iz_route.size] = (8190, 6401, 13920);
	level.iz_route[level.iz_route.size] = (8173, 5609, 13944);
	level.iz_route[level.iz_route.size] = (9274, 4962, 13949);
	level.iz_route[level.iz_route.size] = (10187, 4433, 13527);
	level.iz_route[level.iz_route.size] = (11685, 3851, 13521);
	level.iz_route[level.iz_route.size] = (12865, 4011, 13517);
	level.iz_route[level.iz_route.size] = (13720, 4514, 13547);
	level.iz_route[level.iz_route.size] = (14203, 4809, 13512);
	level.iz_route[level.iz_route.size] = (14797, 4690, 13524);
	level.iz_route[level.iz_route.size] = (15212, 4871, 13524);
	level.iz_route[level.iz_route.size] = (16466, 5494, 13524);
	level.iz_route[level.iz_route.size] = (17350, 6335, 13524);
	level.iz_route[level.iz_route.size] = (17994, 6654, 13524);
	level.iz_route[level.iz_route.size] = (18518, 6896, 13623);
	level.iz_route[level.iz_route.size] = (19297, 7318, 13860);
	level.iz_route[level.iz_route.size] = (20698, 8000, 13855);
	level.iz_route[level.iz_route.size] = (21624, 8506, 13880);
	level.iz_route[level.iz_route.size] = (21895, 9332, 13921);
	level.iz_route[level.iz_route.size] = (21444, 10213, 13913);
	level.iz_route[level.iz_route.size] = (20237, 10602, 13819);
	level.iz_route[level.iz_route.size] = (19692, 10781, 13839);
	level.iz_route[level.iz_route.size] = (18332, 11204, 13497);
	level.iz_route[level.iz_route.size] = (16755, 11528, 13502);
	level.iz_route[level.iz_route.size] = (16010, 12315, 13505);
	level.iz_route[level.iz_route.size] = (16641, 14015, 13503);
	level.iz_route[level.iz_route.size] = (17030, 15017, 13502);
	level.iz_route[level.iz_route.size] = (17398, 16000, 13500);
	level.iz_route[level.iz_route.size] = (17440, 17782, 13494);
	level.iz_route[level.iz_route.size] = (17602, 18627, 13494);
	level.iz_route[level.iz_route.size] = (17156, 19393, 13494);
	level.iz_route[level.iz_route.size] = (16559, 20432, 13556);
	level.iz_route[level.iz_route.size] = (15754, 21200, 13614);
	level.iz_route[level.iz_route.size] = (14624, 22235, 13772);
	level.iz_route[level.iz_route.size] = (13808, 23081, 13889);
	level.iz_route[level.iz_route.size] = (11869, 24984, 13949);
	level.iz_route[level.iz_route.size] = (10856, 25994, 14261);
	level.iz_route[level.iz_route.size] = (10078, 26647, 14700);
	level.iz_route[level.iz_route.size] = (9345, 27454, 15616);
	level.iz_route[level.iz_route.size] = (8484, 28237, 15793);
	level.iz_route[level.iz_route.size] = (7657, 29194, 16059);
	level.iz_route[level.iz_route.size] = (7394, 30631, 16276);
	level.iz_route[level.iz_route.size] = (7934, 31959, 16485);
	level.iz_route[level.iz_route.size] = (9811, 32668, 16762);
	level.iz_route[level.iz_route.size] = (11402, 31640, 16777);
	level.iz_route[level.iz_route.size] = (11731, 30032, 16550);
	level.iz_route[level.iz_route.size] = (10973, 28542, 16122);
	level.iz_route[level.iz_route.size] = (7451, 20699, 14118);
	level.iz_route[level.iz_route.size] = (6728, 18787, 14100);
	level.iz_route[level.iz_route.size] = (6141, 17293, 14093);
	level.iz_route[level.iz_route.size] = (6524, 15516, 14034);
	level.iz_route[level.iz_route.size] = (8142, 14953, 13881);
	level.iz_route[level.iz_route.size] = (9557, 14540, 13846);
	level.iz_route[level.iz_route.size] = (9903, 13326, 13845);
	level.iz_route[level.iz_route.size] = (9901, 11534, 13845);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (22885.1172, 14304.6465, 13696.4570);
	angles[0] = (0, 41.3972, 0);
	at[0] = 0;
	points[1] = (21944.2520, 15236.1025, 13812.4805);
	angles[1] = (0, 45.2108, 0);
	at[1] = 1.5000;
	points[2] = (21628.5430, 15542.8350, 13859.8428);
	angles[2] = (0, 45.9432, 0);
	at[2] = 2;
	points[3] = (20025.4336, 17037.3613, 14177.1660);
	angles[3] = (0, 47.0071, 0);
	at[3] = 4.5000;
	points[4] = (19714.4883, 17337.1660, 14272.1260);
	angles[4] = (0, 46.0494, 0);
	at[4] = 5;
	points[5] = (18186.7324, 18838.4258, 14834.6455);
	angles[5] = (0, 45.5009, 0);
	at[5] = 7.5000;
	points[6] = (17882.9531, 19136.1035, 14957.0869);
	angles[6] = (0, 45.6091, 0);
	at[6] = 8;
	points[7] = (16386.5742, 20591.3398, 15697.0469);
	angles[7] = (0, 45.7988, 0);
	at[7] = 10.5000;
	points[8] = (14621.6143, 22373.0703, 16575.9453);
	angles[8] = (0, 44.7222, 0);
	at[8] = 13.5000;
	points[9] = (14330.9062, 22676.1797, 16716.4570);
	angles[9] = (0, 43.8256, 0);
	at[9] = 14;
	points[10] = (13175.2764, 23901.3379, 17266.2207);
	angles[10] = (0, 43.4131, 0);
	at[10] = 16;
	points[11] = (11364.1729, 25712.9922, 17973.3848);
	angles[11] = (0, 44.9844, 0);
	at[11] = 19;
	points[12] = (9283.3857, 27774.5293, 18989.5664);
	angles[12] = (0, 45.2681, 0);
	at[12] = 22.5000;
	points[13] = (8983.9766, 28043.5039, 19170.7090);
	angles[13] = (0, 48.1324, 0);
	at[13] = 23;
	points[14] = (7780.2759, 29047.9922, 19995.8652);
	angles[14] = (0, 50.1506, 0);
	at[14] = 25;
	points[15] = (7506.1812, 29330.1973, 20192.5586);
	angles[15] = (0, 43.2318, 0);
	at[15] = 25.5000;
	points[16] = (7273.0317, 29659.8047, 20374.6855);
	angles[16] = (0, 36.9642, 0);
	at[16] = 26;
	points[17] = (7039.8423, 29989.4102, 20556.8105);
	angles[17] = (0, 35.6388, 0);
	at[17] = 26.5000;
	points[18] = (5873.9766, 31637.3613, 21467.4805);
	angles[18] = (0, 35.2782, 0);
	at[18] = 29;
	points[19] = (5719.6851, 32017.0879, 21603.9375);
	angles[19] = (0, 21.5863, 0);
	at[19] = 29.5000;
	points[20] = (5634.8823, 32441.0254, 21700.2363);
	angles[20] = (0, 13.4802, 0);
	at[20] = 30;
	points[21] = (5550.0786, 32864.9219, 21796.5371);
	angles[21] = (0, 11.7772, 0);
	at[21] = 30.5000;
	points[22] = (5210.7876, 34560.6328, 22181.6914);
	angles[22] = (0, 11.3151, 0);
	at[22] = 32.5000;
	points[23] = (5131.6929, 34985.9453, 22275.1953);
	angles[23] = (0, 10.0549, 0);
	at[23] = 33;
	points[24] = (5043.7798, 35854.1328, 22427.6777);
	angles[24] = (0, 5.9764, 0);
	at[24] = 34;
	points[25] = (4736.1812, 38892.6797, 22961.4160);
	angles[25] = (0, 5.7807, 0);
	at[25] = 37.5000;
	points[26] = (4822.5986, 39321.5352, 22998.5449);
	angles[26] = (0, -9.1234, 0);
	at[26] = 38;
	points[27] = (5043.3076, 40177.1641, 23058.5039);
	angles[27] = (0, -14.2160, 0);
	at[27] = 39;
	points[28] = (6036.4961, 44028.3438, 23328.2695);
	angles[28] = (0, -15.5856, 0);
	at[28] = 43.5000;
	points[29] = (6309.3311, 44378.3438, 23327.5605);
	angles[29] = (0, -32.6860, 0);
	at[29] = 44;
	points[30] = (6578.4648, 44730.3164, 23327.5605);
	angles[30] = (0, -36.4016, 0);
	at[30] = 44.5000;
	points[31] = (9000.5508, 47896.0664, 23327.5605);
	angles[31] = (0, -37.4175, 0);
	at[31] = 49;
	points[32] = (9329.4092, 48175.5938, 23327.5605);
	angles[32] = (0, -51.3051, 0);
	at[32] = 49.5000;
	points[33] = (9726.0635, 48372.4414, 23327.5605);
	angles[33] = (0, -60.9377, 0);
	at[33] = 50;
	points[34] = (10122.7568, 48569.6875, 23327.5605);
	angles[34] = (0, -63.0142, 0);
	at[34] = 50.5000;
	points[35] = (14486.0244, 50737.4023, 23327.5605);
	angles[35] = (0, -63.5817, 0);
	at[35] = 56;
	points[36] = (14913.6621, 50817.3242, 23327.5605);
	angles[36] = (0, -78.7703, 0);
	at[36] = 56.5000;
	points[37] = (15355.8662, 50842.5195, 23327.5605);
	angles[37] = (0, -85.0342, 0);
	at[37] = 57;
	points[38] = (15798.0713, 50867.7188, 23327.5605);
	angles[38] = (0, -86.3810, 0);
	at[38] = 57.5000;
	points[39] = (21104.4473, 51168.8945, 23327.5605);
	angles[39] = (0, -86.7492, 0);
	at[39] = 63.5000;
	points[40] = (21541.0254, 51164.1719, 23306.6543);
	angles[40] = (0, -92.3086, 0);
	at[40] = 64;
	points[41] = (21956.4961, 51046.8516, 23207.5586);
	angles[41] = (0, -102.7902, 0);
	at[41] = 64.5000;
	points[42] = (22371.9688, 50929.9219, 23108.4238);
	angles[42] = (0, -105.1118, 0);
	at[42] = 65;
	points[43] = (28603.9355, 49172.0469, 21621.4570);
	angles[43] = (0, -105.7510, 0);
	at[43] = 72.5000;
	points[44] = (29020.7090, 49120.0820, 21596.8887);
	angles[44] = (0, -94.9570, 0);
	at[44] = 73;
	points[45] = (29440.0391, 49195.6680, 21717.9531);
	angles[45] = (0, -83.2115, 0);
	at[45] = 73.5000;
	points[46] = (29859.3320, 49270.8672, 21838.9766);
	angles[46] = (0, -80.5407, 0);
	at[46] = 74;
	points[47] = (34891.1836, 50176.3789, 23291.4180);
	angles[47] = (0, -79.7984, 0);
	at[47] = 80;
	points[48] = (35158.5820, 50475.1953, 23327.5605);
	angles[48] = (0, -44.9178, 0);
	at[48] = 80.5000;
	points[49] = (35361.2617, 50868.8945, 23327.5605);
	angles[49] = (0, -31.0416, 0);
	at[49] = 81;
	points[50] = (35563.8984, 51262.9922, 23327.5605);
	angles[50] = (0, -28.0477, 0);
	at[50] = 81.5000;
	points[51] = (37793.1094, 55594.8828, 23327.5605);
	angles[51] = (0, -27.2294, 0);
	at[51] = 87;
	points[52] = (37787.8359, 55994.0938, 23310.7871);
	angles[52] = (0, 1.4046, 0);
	at[52] = 87.5000;
	points[53] = (37607.8359, 56397.6367, 23279.8828);
	angles[53] = (0, 19.1181, 0);
	at[53] = 88;
	points[54] = (37427.8750, 56801.1836, 23248.9766);
	angles[54] = (0, 22.9818, 0);
	at[54] = 88.5000;
	points[55] = (33828.1484, 64871.6523, 22631.1035);
	angles[55] = (0, 24.0388, 0);
	at[55] = 98.5000;
	points[56] = (33503.5859, 65114.1758, 22592.7949);
	angles[56] = (0, 52.8701, 0);
	at[56] = 99;
	points[57] = (33084.8828, 65251.9688, 22549.7246);
	angles[57] = (0, 67.6861, 0);
	at[57] = 99.5000;
	points[58] = (32666.1816, 65389.7656, 22506.6152);
	angles[58] = (0, 70.8991, 0);
	at[58] = 100;
	points[59] = (23454.6074, 68422.4453, 21558.4648);
	angles[59] = (0, 71.7778, 0);
	at[59] = 111;
	points[60] = (23015.7480, 68477.1641, 21555.9062);
	angles[60] = (0, 80.9030, 0);
	at[60] = 111.5000;
	points[61] = (22135.4746, 68576.3750, 21555.9062);
	angles[61] = (0, 83.4463, 0);
	at[61] = 112.5000;
	points[62] = (10251.9287, 69915.7500, 21555.9062);
	angles[62] = (0, 83.5692, 0);
	at[62] = 126;
	points[63] = (9837.5195, 69903.1484, 21555.9062);
	angles[63] = (0, 95.2127, 0);
	at[63] = 126.5000;
	points[64] = (9560.9053, 69557.4844, 21555.9062);
	angles[64] = (0, 130.9494, 0);
	at[64] = 127;
	points[65] = (9284.3311, 69211.4141, 21555.9062);
	angles[65] = (0, 139.1157, 0);
	at[65] = 127.5000;
	points[66] = (3475.6890, 61946.8477, 21555.9062);
	angles[66] = (0, 141.3544, 0);
	at[66] = 138;
	points[67] = (3211.9136, 61594.0938, 21555.9062);
	angles[67] = (0, 144.4485, 0);
	at[67] = 138.5000;
	points[68] = (3085.7559, 61169.6836, 21555.9062);
	angles[68] = (0, 159.3390, 0);
	at[68] = 139;
	points[69] = (2959.5984, 60745.2773, 21555.9062);
	angles[69] = (0, 162.5681, 0);
	at[69] = 139.5000;
	points[70] = (2076.4961, 57773.2266, 21555.9062);
	angles[70] = (0, 163.4510, 0);
	at[70] = 143;
	points[71] = (2025.4449, 57346.8516, 21555.7891);
	angles[71] = (0, 175.4086, 0);
	at[71] = 143.5000;
	points[72] = (2131.7913, 56916.9258, 21555.3945);
	angles[72] = (0, 189.8949, 0);
	at[72] = 144;
	points[73] = (2238.1379, 56487.0078, 21555);
	angles[73] = (0, 193.0345, 0);
	at[73] = 144.5000;
	points[74] = (2982.5671, 53477.1641, 21552.2832);
	angles[74] = (0, 193.8929, 0);
	at[74] = 148;
	points[75] = (3080.5945, 53045.2734, 21551.9297);
	angles[75] = (0, 192.7996, 0);
	at[75] = 148.5000;
	points[76] = (3735.1731, 50014.9609, 21549.5684);
	angles[76] = (0, 192.1884, 0);
	at[76] = 152;
	points[77] = (3841, 49585.4336, 21549.1738);
	angles[77] = (0, 194.4867, 0);
	at[77] = 152.5000;
	points[78] = (4156.7720, 48757.8711, 21548.0312);
	angles[78] = (0, 200.5887, 0);
	at[78] = 153.5000;
	points[79] = (5261.9688, 45861.4180, 21543.9766);
	angles[79] = (0, 200.8838, 0);
	at[79] = 157;
	points[80] = (5506.1421, 45503.9414, 21542.2832);
	angles[80] = (0, 215.0888, 0);
	at[80] = 157.5000;
	points[81] = (5822.0864, 45193.3086, 21539.6836);
	angles[81] = (0, 223.2651, 0);
	at[81] = 158;
	points[82] = (6138.0317, 44883.0742, 21537.0488);
	angles[82] = (0, 225.0253, 0);
	at[82] = 158.5000;
	points[83] = (8665.5508, 42400, 21516.1426);
	angles[83] = (0, 225.5065, 0);
	at[83] = 162.5000;
	points[84] = (8920.4326, 42048.4258, 21514.6074);
	angles[84] = (0, 214.2870, 0);
	at[84] = 163;
	points[85] = (9087.9531, 41638.5820, 21514.6074);
	angles[85] = (0, 204.8187, 0);
	at[85] = 163.5000;
	points[86] = (9255.4326, 41228.3438, 21514.6074);
	angles[86] = (0, 202.7780, 0);
	at[86] = 164;
	points[87] = (10595.3936, 37948.2695, 21514.6074);
	angles[87] = (0, 202.2202, 0);
	at[87] = 168;
	points[88] = (10748.8184, 37534.5273, 21514.6074);
	angles[88] = (0, 199.4998, 0);
	at[88] = 168.5000;
	points[89] = (10806.1807, 37095.3555, 21514.6855);
	angles[89] = (0, 190.0390, 0);
	at[89] = 169;
	points[90] = (10863.5430, 36656.1406, 21514.7246);
	angles[90] = (0, 188, 0);
	at[90] = 169.5000;
	points[91] = (11150.4336, 34460.2344, 21515);
	angles[91] = (0, 187.4430, 0);
	at[91] = 172;
	points[92] = (11159.6064, 34035.1992, 21447.0469);
	angles[92] = (0, 180.3346, 0);
	at[92] = 172.5000;
	points[93] = (11095.9453, 33631.5352, 21276.2207);
	angles[93] = (0, 173.1515, 0);
	at[93] = 173;
	points[94] = (11032.2441, 33227.9141, 21105.3945);
	angles[94] = (0, 171.4964, 0);
	at[94] = 173.5000;
	points[95] = (10522.8740, 29998.6621, 19738.7793);
	angles[95] = (0, 170.7793, 0);
	at[95] = 177.5000;
	points[96] = (10324.4092, 29215.9844, 19374.3711);
	angles[96] = (0, 166.0730, 0);
	at[96] = 178.5000;
	points[97] = (9336.8506, 25300.8672, 17553.8965);
	angles[97] = (0, 165.8430, 0);
	at[97] = 183.5000;
	points[98] = (9217.3623, 24910.1973, 17383.3457);
	angles[98] = (0, 163.2448, 0);
	at[98] = 184;
	points[99] = (8339.2520, 22176.9688, 16212.5596);
	angles[99] = (0, 162.1894, 0);
	at[99] = 187.5000;
	points[100] = (8203.6611, 21786.3789, 16057.8340);
	angles[100] = (0, 160.3792, 0);
	at[100] = 188;
	points[101] = (7830.5513, 21004.2129, 15874.3311);
	angles[101] = (0, 154.7592, 0);
	at[101] = 189;
	points[102] = (6897.7163, 19048.8184, 15415.4727);
	angles[102] = (0, 154.4971, 0);
	at[102] = 191.5000;
	points[103] = (6713.4253, 18655.9453, 15327.3623);
	angles[103] = (0, 155.0879, 0);
	at[103] = 192;
	points[104] = (5503.0708, 15843.7402, 14838.6221);
	angles[104] = (0, 156.7127, 0);
	at[104] = 195.5000;
	points[105] = (5324.6851, 15440.0791, 14806.1025);
	angles[105] = (0, 156.2143, 0);
	at[105] = 196;
	points[106] = (2808.5198, 9782.0869, 14481.1807);
	angles[106] = (0, 156.0248, 0);
	at[106] = 203;
	points[107] = (2627.0591, 9379.0156, 14453.5039);
	angles[107] = (0, 155.7384, 0);
	at[107] = 203.5000;
	points[108] = (797.2874, 5357.9136, 14137.2041);
	angles[108] = (0, 155.5324, 0);
	at[108] = 208.5000;
	points[109] = (614.3032, 4955.3936, 14116.2607);
	angles[109] = (0, 155.5578, 0);
	at[109] = 209;
	points[110] = (-1215.7086, 922.0158, 14122.9521);
	angles[110] = (0, 155.5956, 0);
	at[110] = 214;
	points[111] = (-1379.1458, 514.0591, 14079.1729);
	angles[111] = (0, 158.0826, 0);
	at[111] = 214.5000;
	points[112] = (-2459.0354, -2356.7993, 13627.0479);
	angles[112] = (0, 159.3859, 0);
	at[112] = 218;
	points[113] = (-2350.4883, -2745.6731, 13603.9375);
	angles[113] = (0, 192.5684, 0);
	at[113] = 218.5000;
	points[114] = (-2121.5630, -3124.8149, 13599.8828);
	angles[114] = (0, 207.1150, 0);
	at[114] = 219;
	points[115] = (-1892.6338, -3503.9568, 13595.7881);
	angles[115] = (0, 210.2631, 0);
	at[115] = 219.5000;
	points[116] = (167.6996, -6916.2202, 13559.1738);
	angles[116] = (0, 211.1237, 0);
	at[116] = 224;
	points[117] = (470.6614, -7236.4170, 13549.5273);
	angles[117] = (0, 221.9372, 0);
	at[117] = 224.5000;
	points[118] = (1105.8859, -7853.4253, 13528.0713);
	angles[118] = (0, 225.6530, 0);
	at[118] = 225.5000;
	points[119] = (4281.9688, -10938.5430, 13420.8672);
	angles[119] = (0, 225.8325, 0);
	at[119] = 230.5000;
	points[120] = (4654.1338, -11131.7725, 13413.3467);
	angles[120] = (0, 244.6803, 0);
	at[120] = 231;
	points[121] = (5094.2520, -11181.4971, 13409.9219);
	angles[121] = (0, 259.4726, 0);
	at[121] = 231.5000;
	points[122] = (5534.3311, -11231.1816, 13406.4561);
	angles[122] = (0, 262.6795, 0);
	at[122] = 232;
	points[123] = (8615.0791, -11579.1338, 13382.3232);
	angles[123] = (0, 263.5563, 0);
	at[123] = 235.5000;
	points[124] = (9052.5586, -11520.5117, 13380.5508);
	angles[124] = (0, 275.2696, 0);
	at[124] = 236;
	points[125] = (9489.7637, -11449.6064, 13378.9766);
	angles[125] = (0, 278.3636, 0);
	at[125] = 236.5000;
	points[126] = (13861.7715, -10740.7480, 13362.9932);
	angles[126] = (0, 279.2095, 0);
	at[126] = 241.5000;
	points[127] = (14287.2842, -10631.4570, 13366.1816);
	angles[127] = (0, 285.7392, 0);
	at[127] = 242;
	points[128] = (14690.3936, -10448.3467, 13378.5439);
	angles[128] = (0, 292.5615, 0);
	at[128] = 242.5000;
	points[129] = (15093.5039, -10265.2363, 13390.9053);
	angles[129] = (0, 294.0295, 0);
	at[129] = 243;
	points[130] = (18318.2676, -8800.3154, 13489.8027);
	angles[130] = (0, 294.4308, 0);
	at[130] = 247;
	points[131] = (18712.1270, -8599.0947, 13495.6299);
	angles[131] = (0, 297.4067, 0);
	at[131] = 247.5000;
	points[132] = (21397.7559, -7049.9609, 13485.8271);
	angles[132] = (0, 299.9775, 0);
	at[132] = 251;
	points[133] = (21785.6699, -6836.3779, 13484.3701);
	angles[133] = (0, 298.7549, 0);
	at[133] = 251.5000;
	points[134] = (23352.9531, -6010.3149, 13478.6621);
	angles[134] = (0, 297.7957, 0);
	at[134] = 253.5000;
	points[135] = (26132.3223, -4636.5747, 13468.4648);
	angles[135] = (0, 296.2814, 0);
	at[135] = 257;
	points[136] = (26526.6523, -4435.0396, 13467.0469);
	angles[136] = (0, 297.1973, 0);
	at[136] = 257.5000;
	points[137] = (28867.0879, -3176.2207, 13458.4648);
	angles[137] = (0, 298.2740, 0);
	at[137] = 260.5000;
	points[138] = (29086.8105, -2807.7876, 13457.6777);
	angles[138] = (0, 325.0674, 0);
	at[138] = 261;
	points[139] = (29268.3066, -2403.7676, 13457.0088);
	angles[139] = (0, 333.4973, 0);
	at[139] = 261.5000;
	points[140] = (29812.7949, -1191.7166, 13455);
	angles[140] = (0, 335.7860, 0);
	at[140] = 263;
	points[141] = (29813.6211, -757.5316, 13455);
	angles[141] = (0, 356.9098, 0);
	at[141] = 263.5000;
	points[142] = (29773.1895, -316.4658, 13455.1572);
	angles[142] = (0, 363.4442, 0);
	at[142] = 264;
	points[143] = (29652.0078, 1006.7402, 13455.5908);
	angles[143] = (0, 365.2158, 0);
	at[143] = 265.5000;
	points[144] = (29621.6543, 1448.3308, 13455.7090);
	angles[144] = (0, 363.5628, 0);
	at[144] = 266;
	points[145] = (29587.4023, 4105.5903, 13455.8271);
	angles[145] = (0, 360.8618, 0);
	at[145] = 269;
	points[146] = (29519.2148, 6762.1655, 13456.0635);
	angles[146] = (0, 361.4698, 0);
	at[146] = 272;
	points[147] = (29389.5664, 7183.9370, 13456.5352);
	angles[147] = (0, 374.5607, 0);
	at[147] = 272.5000;
	points[148] = (29105.8281, 8023.0708, 13457.5986);
	angles[148] = (0, 378.4910, 0);
	at[148] = 273.5000;
	points[149] = (28885.9844, 8391.8906, 13458.3857);
	angles[149] = (0, 392.4247, 0);
	at[149] = 274;
	points[150] = (28559.6855, 8691.4170, 13459.6064);
	angles[150] = (0, 404.2087, 0);
	at[150] = 274.5000;
	points[151] = (27907.1270, 9290.4336, 13462.0078);
	angles[151] = (0, 407.3007, 0);
	at[151] = 275.5000;
	points[152] = (27590.5918, 9600.0400, 13463.1895);
	angles[152] = (0, 405.5905, 0);
	at[152] = 276;
	points[153] = (26033.8594, 11175.1182, 13468.8975);
	angles[153] = (0, 404.9116, 0);
	at[153] = 278.5000;
	points[154] = (24778.1895, 12424.8828, 13473.5039);
	angles[154] = (0, 405.4143, 0);
	at[154] = 280.5000;
	points[155] = (23485.3555, 13636.2197, 13478.2275);
	angles[155] = (0, 406.8611, 0);
	at[155] = 282.5000;
	points[156] = (23189.9219, 13950.0791, 13554.7637);
	angles[156] = (0, 403.2231, 0);
	at[156] = 283;
	points[157] = (22885.1172, 14304.6465, 13696.4570);
	angles[157] = (0, 401.3972, 0);
	at[157] = 283.5500;
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
	points[0] = (8010.5117, 21834.1738, 16194.9219);
	angles[0] = (0, -26.3799, 0);
	at[0] = 0;
	points[1] = (8736.6934, 23308.8574, 16855.8262);
	angles[1] = (0, -26.2170, 0);
	at[1] = 2;
	points[2] = (8892.9141, 23686.3770, 17025.3145);
	angles[2] = (0, -22.3548, 0);
	at[2] = 2.5000;
	points[3] = (9307.2051, 24837.8750, 17542.8730);
	angles[3] = (0, -19.8136, 0);
	at[3] = 4;
	points[4] = (9459.7246, 25219.4102, 17707.4023);
	angles[4] = (0, -21.9921, 0);
	at[4] = 4.5000;
	points[5] = (10130.2754, 26735.7871, 18331.6133);
	angles[5] = (0, -23.8516, 0);
	at[5] = 6.5000;
	points[6] = (11168.1113, 29070.9453, 19060.9062);
	angles[6] = (0, -23.9632, 0);
	at[6] = 9.5000;
	points[7] = (11363.7012, 29458.3086, 19148.6230);
	angles[7] = (0, -26.3267, 0);
	at[7] = 10;
	points[8] = (13344.8818, 33329.6836, 19988.1504);
	angles[8] = (0, -27.1011, 0);
	at[8] = 15;
	points[9] = (13530.0791, 33719.1719, 20084.9609);
	angles[9] = (0, -25.0286, 0);
	at[9] = 15.5000;
	points[10] = (13684.8828, 34114.2109, 20212.0469);
	angles[10] = (0, -22.1901, 0);
	at[10] = 16;
	points[11] = (14304.1729, 35694.4102, 20720.2754);
	angles[11] = (0, -21.4021, 0);
	at[11] = 18;
	points[12] = (14464.8428, 36089.2539, 20839.5684);
	angles[12] = (0, -22.3168, 0);
	at[12] = 18.5000;
	points[13] = (15502.1260, 38456.3398, 21458.5430);
	angles[13] = (0, -23.6633, 0);
	at[13] = 21.5000;
	points[14] = (15761.6143, 38783.8594, 21541.1426);
	angles[14] = (0, -39.9144, 0);
	at[14] = 22;
	points[15] = (16124.0947, 39031.6523, 21599.2910);
	angles[15] = (0, -52.2729, 0);
	at[15] = 22.5000;
	points[16] = (17574.0156, 40022.8359, 21831.7715);
	angles[16] = (0, -55.6358, 0);
	at[16] = 24.5000;
	points[17] = (17961.1426, 40212.2070, 21889.6055);
	angles[17] = (0, -65.5096, 0);
	at[17] = 25;
	points[18] = (18391.9688, 40297.6367, 21946.8516);
	angles[18] = (0, -75.9239, 0);
	at[18] = 25.5000;
	points[19] = (19684.3711, 40553.9336, 22118.5430);
	angles[19] = (0, -78.7543, 0);
	at[19] = 27;
	points[20] = (20109.1738, 40575.5898, 22177.6387);
	angles[20] = (0, -89.4934, 0);
	at[20] = 27.5000;
	points[21] = (20516.6152, 40414.5703, 22242.0859);
	angles[21] = (0, -106.7936, 0);
	at[21] = 28;
	points[22] = (20924.0938, 40253.1484, 22306.5742);
	angles[22] = (0, -110.5600, 0);
	at[22] = 28.5000;
	points[23] = (22146.4570, 39769.2930, 22499.9219);
	angles[23] = (0, -111.5797, 0);
	at[23] = 30;
	points[24] = (22574.5664, 39665.7500, 22515.3555);
	angles[24] = (0, -104.3212, 0);
	at[24] = 30.5000;
	points[25] = (24747.5977, 39239.1367, 22515.3555);
	angles[25] = (0, -101.1129, 0);
	at[25] = 33;
	points[26] = (25166.7324, 39356.8516, 22515.3555);
	angles[26] = (0, -78.4909, 0);
	at[26] = 33.5000;
	points[27] = (25583.3477, 39507.0859, 22515.3555);
	angles[27] = (0, -71.9502, 0);
	at[27] = 34;
	points[28] = (27249.8418, 40108.6641, 22515.3555);
	angles[28] = (0, -70.1630, 0);
	at[28] = 36;
	points[29] = (27573.7012, 40394.0938, 22515.3555);
	angles[29] = (0, -50.1377, 0);
	at[29] = 36.5000;
	points[30] = (27864.3711, 40728.3477, 22515.3555);
	angles[30] = (0, -42.9757, 0);
	at[30] = 37;
	points[31] = (29027.0078, 42065.3516, 22515.3555);
	angles[31] = (0, -41.0178, 0);
	at[31] = 39;
	points[32] = (29199.9609, 42470.8672, 22515.3555);
	angles[32] = (0, -26.2493, 0);
	at[32] = 39.5000;
	points[33] = (29362.9141, 42882.6758, 22515.3555);
	angles[33] = (0, -22.5904, 0);
	at[33] = 40;
	points[34] = (30014.8438, 44530.3125, 22515.3555);
	angles[34] = (0, -21.5920, 0);
	at[34] = 42;
	points[35] = (30045.6309, 44971.2617, 22515.3555);
	angles[35] = (0, -7.4615, 0);
	at[35] = 42.5000;
	points[36] = (30071.0625, 45413.3867, 22515.3555);
	angles[36] = (0, -4.1912, 0);
	at[36] = 43;
	points[37] = (30147.5195, 46739.7617, 22515.3555);
	angles[37] = (0, -3.3058, 0);
	at[37] = 44.5000;
	points[38] = (30132.5215, 47174.0156, 22515.3555);
	angles[38] = (0, 4.1961, 0);
	at[38] = 45;
	points[39] = (29940.1973, 47573.2266, 22515.3555);
	angles[39] = (0, 21.0609, 0);
	at[39] = 45.5000;
	points[40] = (29747.9141, 47972.0469, 22515.3555);
	angles[40] = (0, 24.7288, 0);
	at[40] = 46;
	points[41] = (28786.4590, 49966.9297, 22515.3555);
	angles[41] = (0, 25.7315, 0);
	at[41] = 48.5000;
	points[42] = (28489.4883, 50277.9570, 22515.3555);
	angles[42] = (0, 43.3772, 0);
	at[42] = 49;
	points[43] = (28129.5273, 50536.2227, 22515.3555);
	angles[43] = (0, 51.9986, 0);
	at[43] = 49.5000;
	points[44] = (27769.5664, 50794.0977, 22515.3555);
	angles[44] = (0, 53.8554, 0);
	at[44] = 50;
	points[45] = (26329.7266, 51826.3789, 22515.3555);
	angles[45] = (0, 54.3619, 0);
	at[45] = 52;
	points[46] = (25917.9141, 51973.2305, 22515.3555);
	angles[46] = (0, 69.1059, 0);
	at[46] = 52.5000;
	points[47] = (25488.6230, 52082.2852, 22515.3555);
	angles[47] = (0, 74.3158, 0);
	at[47] = 53;
	points[48] = (24200.8262, 52409.4492, 22515.3555);
	angles[48] = (0, 75.7275, 0);
	at[48] = 54.5000;
	points[49] = (23769.7637, 52498.4258, 22515.3555);
	angles[49] = (0, 79.8633, 0);
	at[49] = 55;
	points[50] = (23328.0312, 52466.1445, 22515.3555);
	angles[50] = (0, 91.0907, 0);
	at[50] = 55.5000;
	points[51] = (22886.3008, 52433.8555, 22515.3555);
	angles[51] = (0, 93.5146, 0);
	at[51] = 56;
	points[52] = (21119.3711, 52304.7266, 22515.3555);
	angles[52] = (0, 94.1758, 0);
	at[52] = 58;
	points[53] = (20695.7480, 52181.8906, 22515.3555);
	angles[53] = (0, 104.6976, 0);
	at[53] = 58.5000;
	points[54] = (20275.6699, 52041.7305, 22515.3555);
	angles[54] = (0, 107.6721, 0);
	at[54] = 59;
	points[55] = (19015.4727, 51620.4727, 22515.3555);
	angles[55] = (0, 108.4773, 0);
	at[55] = 60.5000;
	points[56] = (18620, 51429.9180, 22515.3555);
	angles[56] = (0, 116.3833, 0);
	at[56] = 61;
	points[57] = (18252.6777, 51182.6797, 22515.3555);
	angles[57] = (0, 122.3378, 0);
	at[57] = 61.5000;
	points[58] = (17150.6699, 50440.1602, 22515.3555);
	angles[58] = (0, 123.9518, 0);
	at[58] = 63;
	points[59] = (16774.2520, 50207.0859, 22515.3555);
	angles[59] = (0, 121.6212, 0);
	at[59] = 63.5000;
	points[60] = (14855.2363, 49101.9648, 22515.3555);
	angles[60] = (0, 119.9408, 0);
	at[60] = 66;
	points[61] = (14504.7637, 48831.4961, 22515.3555);
	angles[61] = (0, 126.3287, 0);
	at[61] = 66.5000;
	points[62] = (13114.9209, 47733.0742, 22515.3555);
	angles[62] = (0, 128.3219, 0);
	at[62] = 68.5000;
	points[63] = (12774.3301, 47451.1836, 22515.3555);
	angles[63] = (0, 130.1457, 0);
	at[63] = 69;
	points[64] = (12478.9375, 47120.8672, 22515.3555);
	angles[64] = (0, 136.4482, 0);
	at[64] = 69.5000;
	points[65] = (12183.5830, 46790.9453, 22515.3555);
	angles[65] = (0, 137.8033, 0);
	at[65] = 70;
	points[66] = (11002.1270, 45470.8633, 22515.3555);
	angles[66] = (0, 138.1729, 0);
	at[66] = 72;
	points[67] = (10716.0244, 45133.8594, 22515.3555);
	angles[67] = (0, 140.5217, 0);
	at[67] = 72.5000;
	points[68] = (10485.1973, 44755.9062, 22515.3555);
	angles[68] = (0, 146.8559, 0);
	at[68] = 73;
	points[69] = (9792.7168, 43621.6523, 22515.3555);
	angles[69] = (0, 148.5731, 0);
	at[69] = 74.5000;
	points[70] = (9574.3311, 43237.7969, 22515.3555);
	angles[70] = (0, 151.1805, 0);
	at[70] = 75;
	points[71] = (9411.3389, 42825.5938, 22515.3555);
	angles[71] = (0, 156.8565, 0);
	at[71] = 75.5000;
	points[72] = (8759.4492, 41178.3477, 22515.3555);
	angles[72] = (0, 158.4068, 0);
	at[72] = 77.5000;
	points[73] = (8639.8428, 40753.1484, 22515.3555);
	angles[73] = (0, 163.9511, 0);
	at[73] = 78;
	points[74] = (8134.9214, 38596.7695, 22515.3555);
	angles[74] = (0, 166.8187, 0);
	at[74] = 80.5000;
	points[75] = (7616.7324, 36443.6992, 22515.3555);
	angles[75] = (0, 166.4619, 0);
	at[75] = 83;
	points[76] = (7534.8423, 36011.1406, 22475.1172);
	angles[76] = (0, 169.1053, 0);
	at[76] = 83.5000;
	points[77] = (7164.2124, 33844.8438, 22202.7949);
	angles[77] = (0, 170.2903, 0);
	at[77] = 86;
	points[78] = (7105.1572, 33413.3086, 22132.8359);
	angles[78] = (0, 172.7747, 0);
	at[78] = 86.5000;
	points[79] = (7095.7090, 32987.3633, 22011.7344);
	angles[79] = (0, 177.4265, 0);
	at[79] = 87;
	points[80] = (7067.4805, 31709.5664, 21648.3457);
	angles[80] = (0, 178.7202, 0);
	at[80] = 88.5000;
	points[81] = (7071.2202, 31283.8203, 21529.1738);
	angles[81] = (0, 181.2692, 0);
	at[81] = 89;
	points[82] = (7124.4487, 30858.5449, 21417.3613);
	angles[82] = (0, 185.8761, 0);
	at[82] = 89.5000;
	points[83] = (7230.8267, 30008.0723, 21193.6602);
	angles[83] = (0, 187.0732, 0);
	at[83] = 90.5000;
	points[84] = (7330.1577, 29607.1641, 21061.6543);
	angles[84] = (0, 196.1720, 0);
	at[84] = 91;
	points[85] = (7549.8032, 29269.8418, 20876.9297);
	angles[85] = (0, 209.3026, 0);
	at[85] = 91.5000;
	points[86] = (8429.7246, 27921.0234, 20138.5820);
	angles[86] = (0, 213.3534, 0);
	at[86] = 93.5000;
	points[87] = (9145.7871, 26935.7090, 19607.5977);
	angles[87] = (0, 215.9820, 0);
	at[87] = 95;
	points[88] = (9399.8428, 26617.6387, 19438.5039);
	angles[88] = (0, 219.8525, 0);
	at[88] = 95.5000;
	points[89] = (9724.4883, 26347.2441, 19305.6309);
	angles[89] = (0, 228.0303, 0);
	at[89] = 96;
	points[90] = (11023.1104, 25265.5898, 18774.2520);
	angles[90] = (0, 230.2046, 0);
	at[90] = 98;
	points[91] = (11343.1895, 24992.1660, 18636.6133);
	angles[91] = (0, 229.4606, 0);
	at[91] = 98.5000;
	points[92] = (12609.9209, 23889.6836, 18072.1660);
	angles[92] = (0, 228.9666, 0);
	at[92] = 100.5000;
	points[93] = (12924.4492, 23617.8730, 17920.3555);
	angles[93] = (0, 229.2253, 0);
	at[93] = 101;
	points[94] = (14470.4336, 22306.0234, 17029.7637);
	angles[94] = (0, 229.6832, 0);
	at[94] = 103.5000;
	points[95] = (14774.7637, 22038.3457, 16851.2207);
	angles[95] = (0, 228.6483, 0);
	at[95] = 104;
	points[96] = (15979.7246, 20954.2129, 16136.0244);
	angles[96] = (0, 228.0219, 0);
	at[96] = 106;
	points[97] = (16257.5986, 20658.9766, 15958.8193);
	angles[97] = (0, 223.6268, 0);
	at[97] = 106.5000;
	points[98] = (17067.7949, 19748.9766, 15428.6621);
	angles[98] = (0, 221.6985, 0);
	at[98] = 108;
	points[99] = (17341.4570, 19449.2910, 15251.7715);
	angles[99] = (0, 222.7603, 0);
	at[99] = 108.5000;
	points[100] = (17640.4727, 19175.2754, 15073.8193);
	angles[100] = (0, 226.4795, 0);
	at[100] = 109;
	points[101] = (18238.5430, 18627.2051, 14717.9531);
	angles[101] = (0, 227.4506, 0);
	at[101] = 110;
	points[102] = (18539.8047, 18344.6074, 14559.6855);
	angles[102] = (0, 226.7387, 0);
	at[102] = 110.5000;
	points[103] = (20058.3066, 16884.6055, 13876.4570);
	angles[103] = (0, 226.1256, 0);
	at[103] = 113;
	points[104] = (20370.2363, 16590.5117, 13768.9766);
	angles[104] = (0, 226.7208, 0);
	at[104] = 113.5000;
	points[105] = (21328.1895, 15702.6768, 13524.8037);
	angles[105] = (0, 227.1704, 0);
	at[105] = 115;
	points[106] = (21647.7949, 15405.1182, 13457.6777);
	angles[106] = (0, 226.9836, 0);
	at[106] = 115.5000;
	points[107] = (23253.7793, 13880.2754, 13457.9531);
	angles[107] = (0, 226.5828, 0);
	at[107] = 118;
	points[108] = (24220.9062, 12969.1338, 13459.8428);
	angles[108] = (0, 226.7057, 0);
	at[108] = 119.5000;
	points[109] = (24545.1172, 12667.4023, 13460.3154);
	angles[109] = (0, 227.1647, 0);
	at[109] = 120;
	points[110] = (25866.3398, 11487.1270, 13460.3154);
	angles[110] = (0, 228.2231, 0);
	at[110] = 122;
	points[111] = (26191.7324, 11186.8105, 13460.5117);
	angles[111] = (0, 226.9934, 0);
	at[111] = 122.5000;
	points[112] = (27447.9141, 9937.4805, 13463.3066);
	angles[112] = (0, 225.1598, 0);
	at[112] = 124.5000;
	points[113] = (27769.3320, 9632.8350, 13462.5596);
	angles[113] = (0, 226.4257, 0);
	at[113] = 125;
	points[114] = (29387.5996, 8121.0239, 13456.5752);
	angles[114] = (0, 226.9480, 0);
	at[114] = 127.5000;
	points[115] = (29502.8730, 7695.9058, 13456.1426);
	angles[115] = (0, 201.6785, 0);
	at[115] = 128;
	points[116] = (29610.5117, 7266.2603, 13455.7480);
	angles[116] = (0, 195.7010, 0);
	at[116] = 128.5000;
	points[117] = (29825.7891, 6407.0083, 13454.9609);
	angles[117] = (0, 194.1401, 0);
	at[117] = 129.5000;
	points[118] = (29890.1582, 5973.1104, 13454.7246);
	angles[118] = (0, 186.8543, 0);
	at[118] = 130;
	points[119] = (29868.5820, 5530.7085, 13454.8037);
	angles[119] = (0, 179.2798, 0);
	at[119] = 130.5000;
	points[120] = (29803.7793, 4203.5435, 13455.0391);
	angles[120] = (0, 177.2248, 0);
	at[120] = 132;
	points[121] = (29788.1094, 3761.0354, 13455.1191);
	angles[121] = (0, 178.2858, 0);
	at[121] = 132.5000;
	points[122] = (29800.6699, 1989.4252, 13455.0391);
	angles[122] = (0, 180.4009, 0);
	at[122] = 134.5000;
	points[123] = (29797.3633, 1546.6693, 13455.0791);
	angles[123] = (0, 179.2546, 0);
	at[123] = 135;
	points[124] = (29704.2520, -222.5378, 13455.3936);
	angles[124] = (0, 176.9928, 0);
	at[124] = 137;
	points[125] = (29648.2285, -661.1378, 13455.6309);
	angles[125] = (0, 172.7125, 0);
	at[125] = 137.5000;
	points[126] = (29496.1426, -1533.8149, 13456.1807);
	angles[126] = (0, 170.2353, 0);
	at[126] = 138.5000;
	points[127] = (29404.7637, -1963.8779, 13456.4971);
	angles[127] = (0, 166.7047, 0);
	at[127] = 139;
	points[128] = (29153.6230, -2328.7126, 13457.4014);
	angles[128] = (0, 150.0656, 0);
	at[128] = 139.5000;
	points[129] = (28902.4805, -2693.5474, 13458.3467);
	angles[129] = (0, 146.4481, 0);
	at[129] = 140;
	points[130] = (28400.2383, -3423.2166, 13460.1572);
	angles[130] = (0, 145.5045, 0);
	at[130] = 141;
	points[131] = (28023.6211, -3651.9370, 13461.5361);
	angles[131] = (0, 125.7593, 0);
	at[131] = 141.5000;
	points[132] = (27639.6074, -3872.6260, 13462.9531);
	angles[132] = (0, 121.1473, 0);
	at[132] = 142;
	points[133] = (26487.5586, -4534.6851, 13467.1660);
	angles[133] = (0, 119.8980, 0);
	at[133] = 143.5000;
	points[134] = (26088.7012, -4727.0474, 13468.6221);
	angles[134] = (0, 116.4612, 0);
	at[134] = 144;
	points[135] = (24488.1895, -5486.6143, 13474.4893);
	angles[135] = (0, 115.3561, 0);
	at[135] = 146;
	points[136] = (22476.1406, -6411.8501, 13481.8506);
	angles[136] = (0, 114.6985, 0);
	at[136] = 148.5000;
	points[137] = (22076.8906, -6603.3857, 13483.3076);
	angles[137] = (0, 115.7720, 0);
	at[137] = 149;
	points[138] = (20498.8184, -7408.6221, 13489.0938);
	angles[138] = (0, 117.0318, 0);
	at[138] = 151;
	points[139] = (20107.0078, -7615.1182, 13490.5518);
	angles[139] = (0, 117.7621, 0);
	at[139] = 151.5000;
	points[140] = (18545.1973, -8451.4961, 13496.2598);
	angles[140] = (0, 118.1688, 0);
	at[140] = 153.5000;
	points[141] = (17744.3301, -8829.0156, 13471.4961);
	angles[141] = (0, 115.2620, 0);
	at[141] = 154.5000;
	points[142] = (14537.1650, -10331.7324, 13367.4404);
	angles[142] = (0, 115.1055, 0);
	at[142] = 158.5000;
	points[143] = (14114.3311, -10425.9453, 13362.0869);
	angles[143] = (0, 101.8117, 0);
	at[143] = 159;
	points[144] = (13671.4971, -10434.9209, 13363.7002);
	angles[144] = (0, 93.4503, 0);
	at[144] = 159.5000;
	points[145] = (13228.7012, -10443.8574, 13365.3154);
	angles[145] = (0, 91.6499, 0);
	at[145] = 160;
	points[146] = (10128.9365, -10506.4961, 13376.6143);
	angles[146] = (0, 91.1578, 0);
	at[146] = 163.5000;
	points[147] = (9688.3467, -10495.3945, 13378.2285);
	angles[147] = (0, 87.1963, 0);
	at[147] = 164;
	points[148] = (9258.3857, -10388.9766, 13379.8027);
	angles[148] = (0, 78.4894, 0);
	at[148] = 164.5000;
	points[149] = (8828.4648, -10282.5986, 13381.3779);
	angles[149] = (0, 76.6140, 0);
	at[149] = 165;
	points[150] = (2809.2915, -8793.1895, 13403.3467);
	angles[150] = (0, 76.1015, 0);
	at[150] = 172;
	points[151] = (2489.7913, -8503.6611, 13404.4883);
	angles[151] = (0, 51.5044, 0);
	at[151] = 172.5000;
	points[152] = (2195.0750, -8173.0317, 13405.5908);
	angles[152] = (0, 43.8197, 0);
	at[152] = 173;
	points[153] = (1900.3583, -7842.4019, 13406.6533);
	angles[153] = (0, 42.1658, 0);
	at[153] = 173.5000;
	points[154] = (-1341.5275, -4205.5117, 13418.4648);
	angles[154] = (0, 41.7137, 0);
	at[154] = 179;
	points[155] = (-1372.6576, -3800.9724, 13466.7715);
	angles[155] = (0, 8.5136, 0);
	at[155] = 179.5000;
	points[156] = (-1304.0355, -3368.4412, 13532.9531);
	angles[156] = (0, -5.2101, 0);
	at[156] = 180;
	points[157] = (-1235.4094, -2935.9094, 13599.1338);
	angles[157] = (0, -8.1973, 0);
	at[157] = 180.5000;
	points[158] = (-755.0472, 91.8366, 14062.3232);
	angles[158] = (0, -9.0150, 0);
	at[158] = 184;
	points[159] = (-674.3741, 521.4528, 14120.9453);
	angles[159] = (0, -11.6799, 0);
	at[159] = 184.5000;
	points[160] = (-498.7520, 928.0591, 14120.3154);
	angles[160] = (0, -20.8550, 0);
	at[160] = 185;
	points[161] = (-323.1288, 1334.6654, 14119.6855);
	angles[161] = (0, -22.8228, 0);
	at[161] = 185.5000;
	points[162] = (379.3610, 2961.0945, 14117.1270);
	angles[162] = (0, -23.3594, 0);
	at[162] = 187.5000;
	points[163] = (547.4016, 3370.7441, 14116.4961);
	angles[163] = (0, -22.0689, 0);
	at[163] = 188;
	points[164] = (1934.6221, 7107.7949, 14111.4170);
	angles[164] = (0, -20.3652, 0);
	at[164] = 192.5000;
	points[165] = (2090.0591, 7521.9297, 14128.8193);
	angles[165] = (0, -20.5787, 0);
	at[165] = 193;
	points[166] = (3809.8662, 12068.5049, 14457.2832);
	angles[166] = (0, -20.7197, 0);
	at[166] = 198.5000;
	points[167] = (3988.5432, 12470.9443, 14503.1104);
	angles[167] = (0, -23.5472, 0);
	at[167] = 199;
	points[168] = (5273.0312, 15271.6143, 14847.7959);
	angles[168] = (0, -24.6376, 0);
	at[168] = 202.5000;
	points[169] = (5434.8032, 15681.6934, 14888.8193);
	angles[169] = (0, -21.8666, 0);
	at[169] = 203;
	points[170] = (6531.7324, 18568.5820, 15162.5195);
	angles[170] = (0, -20.8049, 0);
	at[170] = 206.5000;
	points[171] = (7235.0786, 20153.8203, 15524.0947);
	angles[171] = (0, -23.9483, 0);
	at[171] = 208.5000;
	points[172] = (7571.4570, 20920.1582, 15813.7012);
	angles[172] = (0, -23.7035, 0);
	at[172] = 209.5000;
	points[173] = (7742.4805, 21300.5137, 15962.5596);
	angles[173] = (0, -24.4810, 0);
	at[173] = 210;
	points[174] = (7927.9136, 21669.3691, 16122.9141);
	angles[174] = (0, -26.2150, 0);
	at[174] = 210.5000;
	points[175] = (8010.5117, 21834.1738, 16194.9219);
	angles[175] = (0, -26.3799, 0);
	at[175] = 210.7330;
	mover = getEnt("iz_obj_1", "targetname");
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
