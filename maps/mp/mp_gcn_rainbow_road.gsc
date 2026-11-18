main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_gcn_rainbow_road", 0);

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

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
}

iz_sounds()
{
	ambientPlay("iz_0_71", 2);
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
	level.iz_route[level.iz_route.size] = (12797, -19081, 20501);
	level.iz_route[level.iz_route.size] = (12350, -18722, 20486);
	level.iz_route[level.iz_route.size] = (11952, -18385, 20392);
	level.iz_route[level.iz_route.size] = (11452, -17957, 20501);
	level.iz_route[level.iz_route.size] = (10576, -17240, 19546);
	level.iz_route[level.iz_route.size] = (9500, -16355, 19038);
	level.iz_route[level.iz_route.size] = (8588, -15608, 18631);
	level.iz_route[level.iz_route.size] = (7915, -15052, 18365);
	level.iz_route[level.iz_route.size] = (7577, -14717, 18209);
	level.iz_route[level.iz_route.size] = (7297, -14428, 18064);
	level.iz_route[level.iz_route.size] = (7124, -14172, 17938);
	level.iz_route[level.iz_route.size] = (7016, -13748, 17738);
	level.iz_route[level.iz_route.size] = (6938, -13251, 17552);
	level.iz_route[level.iz_route.size] = (6861, -12114, 17250);
	level.iz_route[level.iz_route.size] = (6943, -11322, 17017);
	level.iz_route[level.iz_route.size] = (7045, -11033, 16901);
	level.iz_route[level.iz_route.size] = (7223, -10741, 16763);
	level.iz_route[level.iz_route.size] = (7848, -9866, 16366);
	level.iz_route[level.iz_route.size] = (8642, -8793, 15994);
	level.iz_route[level.iz_route.size] = (9105, -8167, 15869);
	level.iz_route[level.iz_route.size] = (9227, -7827, 15839);
	level.iz_route[level.iz_route.size] = (9184, -7380, 15812);
	level.iz_route[level.iz_route.size] = (8925, -7070, 15769);
	level.iz_route[level.iz_route.size] = (8603, -6909, 15719);
	level.iz_route[level.iz_route.size] = (8167, -6812, 15665);
	level.iz_route[level.iz_route.size] = (7803, -6907, 15588);
	level.iz_route[level.iz_route.size] = (7386, -7104, 15479);
	level.iz_route[level.iz_route.size] = (7082, -7337, 15377);
	level.iz_route[level.iz_route.size] = (6765, -7710, 15241);
	level.iz_route[level.iz_route.size] = (6322, -8232, 15090);
	level.iz_route[level.iz_route.size] = (5932, -8706, 15036);
	level.iz_route[level.iz_route.size] = (5464, -9185, 15090);
	level.iz_route[level.iz_route.size] = (5087, -9373, 15148);
	level.iz_route[level.iz_route.size] = (4639, -9483, 15207);
	level.iz_route[level.iz_route.size] = (4216, -9319, 15230);
	level.iz_route[level.iz_route.size] = (4036, -9038, 15211);
	level.iz_route[level.iz_route.size] = (3979, -8746, 15167);
	level.iz_route[level.iz_route.size] = (4058, -8383, 15067);
	level.iz_route[level.iz_route.size] = (4223, -7928, 14909);
	level.iz_route[level.iz_route.size] = (4660, -7377, 14635);
	level.iz_route[level.iz_route.size] = (5387, -6540, 14236);
	level.iz_route[level.iz_route.size] = (6091, -5675, 14042);
	level.iz_route[level.iz_route.size] = (7403, -4101, 12893);
	level.iz_route[level.iz_route.size] = (8452, -2837, 12446);
	level.iz_route[level.iz_route.size] = (9313, -1793, 12186);
	level.iz_route[level.iz_route.size] = (10334, -564, 11858);
	level.iz_route[level.iz_route.size] = (11158, 419, 11705);
	level.iz_route[level.iz_route.size] = (12689, 2234, 10761);
	level.iz_route[level.iz_route.size] = (13841, 3441, 10517);
	level.iz_route[level.iz_route.size] = (14563, 4593, 10358);
	level.iz_route[level.iz_route.size] = (14933, 5595, 10283);
	level.iz_route[level.iz_route.size] = (14681, 6277, 10231);
	level.iz_route[level.iz_route.size] = (14222, 6911, 10277);
	level.iz_route[level.iz_route.size] = (13506, 7254, 10360);
	level.iz_route[level.iz_route.size] = (12732, 7250, 10489);
	level.iz_route[level.iz_route.size] = (11932, 6773, 10655);
	level.iz_route[level.iz_route.size] = (11578, 6064, 10768);
	level.iz_route[level.iz_route.size] = (11557, 5351, 10875);
	level.iz_route[level.iz_route.size] = (11872, 4443, 11064);
	level.iz_route[level.iz_route.size] = (12629, 4012, 11134);
	level.iz_route[level.iz_route.size] = (13621, 3996, 11202);
	level.iz_route[level.iz_route.size] = (14315, 4439, 11245);
	level.iz_route[level.iz_route.size] = (14752, 5129, 11344);
	level.iz_route[level.iz_route.size] = (14776, 5940, 11462);
	level.iz_route[level.iz_route.size] = (14562, 6548, 11558);
	level.iz_route[level.iz_route.size] = (13901, 7164, 11660);
	level.iz_route[level.iz_route.size] = (12881, 7387, 11679);
	level.iz_route[level.iz_route.size] = (11989, 7301, 11591);
	level.iz_route[level.iz_route.size] = (11430, 7229, 11416);
	level.iz_route[level.iz_route.size] = (10865, 7223, 11158);
	level.iz_route[level.iz_route.size] = (9997, 7272, 10696);
	level.iz_route[level.iz_route.size] = (9077, 7403, 10234);
	level.iz_route[level.iz_route.size] = (8092, 7625, 9797);
	level.iz_route[level.iz_route.size] = (6866, 7816, 9335);
	level.iz_route[level.iz_route.size] = (6217, 7829, 9086);
	level.iz_route[level.iz_route.size] = (5543, 7571, 8838);
	level.iz_route[level.iz_route.size] = (4825, 7285, 8625);
	level.iz_route[level.iz_route.size] = (4403, 7284, 8526);
	level.iz_route[level.iz_route.size] = (3960, 7369, 8448);
	level.iz_route[level.iz_route.size] = (3459, 7683, 8393);
	level.iz_route[level.iz_route.size] = (2860, 7930, 8338);
	level.iz_route[level.iz_route.size] = (2426, 7909, 8289);
	level.iz_route[level.iz_route.size] = (2063, 7722, 8243);
	level.iz_route[level.iz_route.size] = (1440, 7391, 8170);
	level.iz_route[level.iz_route.size] = (761, 7327, 8112);
	level.iz_route[level.iz_route.size] = (-250, 7318, 8029);
	level.iz_route[level.iz_route.size] = (-734, 7215, 7996);
	level.iz_route[level.iz_route.size] = (-1001, 7025, 7979);
	level.iz_route[level.iz_route.size] = (-1158, 6745, 7971);
	level.iz_route[level.iz_route.size] = (-1186, 6066, 7971);
	level.iz_route[level.iz_route.size] = (-1013, 5562, 7970);
	level.iz_route[level.iz_route.size] = (-482, 4762, 7970);
	level.iz_route[level.iz_route.size] = (312, 3688, 8062);
	level.iz_route[level.iz_route.size] = (1063, 2600, 8535);
	level.iz_route[level.iz_route.size] = (3538, -1599, 23429);
	level.iz_route[level.iz_route.size] = (5739, -4517, 22633);
	level.iz_route[level.iz_route.size] = (7313, -6772, 22465);
	level.iz_route[level.iz_route.size] = (8243, -8219, 22474);
	level.iz_route[level.iz_route.size] = (9766, -10417, 22584);
	level.iz_route[level.iz_route.size] = (11361, -12576, 22760);
	level.iz_route[level.iz_route.size] = (12002, -13457, 22839);
	level.iz_route[level.iz_route.size] = (12575, -14215, 23204);
	level.iz_route[level.iz_route.size] = (14128, -15982, 22448);
	level.iz_route[level.iz_route.size] = (15018, -17101, 22360);
	level.iz_route[level.iz_route.size] = (15527, -18012, 22233);
	level.iz_route[level.iz_route.size] = (15651, -18940, 22048);
	level.iz_route[level.iz_route.size] = (15274, -19745, 21833);
	level.iz_route[level.iz_route.size] = (14649, -20096, 21658);
	level.iz_route[level.iz_route.size] = (14195, -19879, 21482);
	level.iz_route[level.iz_route.size] = (13864, -19466, 21343);
	level.iz_route[level.iz_route.size] = (13947, -18908, 21211);
	level.iz_route[level.iz_route.size] = (14444, -18536, 21081);
	level.iz_route[level.iz_route.size] = (14962, -18694, 20934);
	level.iz_route[level.iz_route.size] = (15289, -19068, 20817);
	level.iz_route[level.iz_route.size] = (15164, -19534, 20705);
	level.iz_route[level.iz_route.size] = (14784, -20009, 20605);
	level.iz_route[level.iz_route.size] = (14168, -19965, 20520);
	level.iz_route[level.iz_route.size] = (13541, -19642, 20499);
}
