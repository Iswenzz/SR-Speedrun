main()
{
	sr\api\_q3::setWeapons("rl");
	sr\api\_q3::setAmmo(4995);

	thread iz_sounds();

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
	iz_emitter("iz_0_birds", (3320, 824, 584), 0, 9.2997);
	iz_emitter("iz_1_train", (22496, 20288, 384), 60, 1.9056);
	iz_emitter("iz_2_carhorn2", (20704, 18752, 448), 60, 0.6304);
	iz_emitter("iz_3_airplane", (1088, 19904, 800), 60, 4.5568);
	iz_emitter("iz_4_squawk", (1088, 5248, 896), 60, 0.3889);
	iz_emitter("iz_5_bell", (20512.0020, 20288, 128), 60, 1.8748);
	iz_emitter("iz_6_bellring", (672, 8000, 896), 60, 2.4921);
	iz_emitter("iz_7_lava_amb_01_quiet", (20800, 4032, 448), 60, 2.9398);
	iz_emitter("iz_8_dog", (20960, 5256, 104), 60, 3.7820);
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
}

iz_q3_mover0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (1920, 8064.0161, 72);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (1920, 8070.6694, 72);
	angles[1] = (0, 0, 0);
	at[1] = 1.2500;
	points[2] = (1920, 8071.8501, 72);
	angles[2] = (0, 0, 0);
	at[2] = 1.7500;
	points[3] = (1920, 8071.8501, 72);
	angles[3] = (0, 0, 0);
	at[3] = 2.2500;
	points[4] = (1920, 8069.0947, 72);
	angles[4] = (0, 0, 0);
	at[4] = 3.1250;
	points[5] = (1920, 8058.3467, 72);
	angles[5] = (0, 0, 0);
	at[5] = 5;
	points[6] = (1920, 8056.6143, 72);
	angles[6] = (0, 0, 0);
	at[6] = 5.5000;
	points[7] = (1920, 8055.9839, 72);
	angles[7] = (0, 0, 0);
	at[7] = 6;
	points[8] = (1920, 8057.8350, 72);
	angles[8] = (0, 0, 0);
	at[8] = 6.8750;
	points[9] = (1920, 8064.0161, 72);
	angles[9] = (0, 0, 0);
	at[9] = 8;
	mover = getEnt("iz_q3_mover0", "targetname");
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
