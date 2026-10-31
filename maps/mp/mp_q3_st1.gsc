main()
{
	thread iz_trains();

	thread iz_anims();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
}

iz_trains()
{
	trains = getEntArray("iz_train", "targetname");
	riders = getEntArray("iz_rider", "targetname");
	for (i = 0; i < riders.size; i++)
		for (j = 0; j < trains.size; j++)
			if (isDefined(riders[i].target) && isDefined(trains[j].script_noteworthy) && riders[i].target == trains[j].script_noteworthy)
				riders[i] linkTo(trains[j]);
	for (i = 0; i < trains.size; i++)
		trains[i] thread iz_train();
}

iz_node(name)
{
	nodes = getEntArray(name, "targetname");
	if (nodes.size)
		return nodes[0];
	return undefined;
}

iz_train()
{
	if (!isDefined(self.target))
		return;
	if (isDefined(self.script_label) && self.script_label == "park")
	{
		node = iz_node(self.target);
		if (isDefined(node))
			self moveTo(node.origin, 0.05);
		return;
	}
	nodes = [];
	loop = false;
	node = iz_node(self.target);
	while (isDefined(node) && nodes.size < 64)
	{
		nodes[nodes.size] = node;
		if (!isDefined(node.target))
			break;
		node = iz_node(node.target);
		if (isDefined(node) && node == nodes[0])
		{
			loop = true;
			break;
		}
	}
	if (nodes.size < 2)
		return;
	speed = 100;
	if (isDefined(self.speed) && self.speed > 0)
		speed = self.speed;
	wait 1;
	i = 0;
	step = 1;
	for (;;)
	{
		next = i + step;
		if (next < 0 || next >= nodes.size)
		{
			if (loop)
				next = 0;
			else
			{
				step = 0 - step;
				next = i + step;
				wait 3;
			}
		}
		time = distance(self.origin, nodes[next].origin) / speed;
		if (time > 0.05)
		{
			self moveTo(nodes[next].origin, time);
			self waittill("movedone");
		}
		i = next;
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

iz_anims()
{
	thread iz_q3_mover0();
	thread iz_q3_mover1();
}

iz_q3_mover0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-3728, -208, 248);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-3728, -208, 248);
	angles[1] = (0, 0, 0);
	at[1] = 1;
	points[2] = (-3728, 88, 248);
	angles[2] = (0, 0, 0);
	at[2] = 3.9600;
	points[3] = (-3728, 88, 248);
	angles[3] = (0, 0, 0);
	at[3] = 4.9600;
	points[4] = (-3728, -208, 248);
	angles[4] = (0, 0, 0);
	at[4] = 7.9200;
	mover = getEnt("iz_q3_mover0", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_q3_mover1()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (3328, -264, 128);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (3328, 144, 128);
	angles[1] = (0, 0, 0);
	at[1] = 8.1600;
	points[2] = (3328, -264, 128);
	angles[2] = (0, 0, 0);
	at[2] = 16.3200;
	mover = getEnt("iz_q3_mover1", "targetname");
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
