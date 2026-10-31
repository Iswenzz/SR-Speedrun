main()
{
	visionSetNaked("mp_bhop_p09", 0);

	thread iz_sounds();

	thread iz_triggers();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
}

iz_sounds()
{
	ambientPlay("iz_4_tunnel_wind_loop1", 2);
	iz_emitter("iz_0_fire_med_loop1", (-2880.3198, -6592, -3794), 0, 4.5462);
	iz_emitter("iz_1_citadel_drone_loop3", (256, 512, 672), 0, 15.4181);
	iz_emitter("iz_2_city_beacon_loop1", (1696, -11200, -2624), 0, 3.2218);
	iz_emitter("iz_3_citadel_drone_loop6", (1376, -1696, -816), 0, 6.3273);
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

iz_triggers()
{
	thread iz_trig_0();
	thread iz_trig_1();
	thread iz_trig_2();
	thread iz_trig_3();
	thread iz_trig_4();
	thread iz_trig_5();
	thread iz_trig_6();
	thread iz_trig_7();
	thread iz_trig_8();
	thread iz_trig_9();
	thread iz_trig_10();
	thread iz_trig_11();
	thread iz_trig_12();
	thread iz_trig_13();
	thread iz_trig_14();
	thread iz_trig_15();
	thread iz_trig_16();
	thread iz_trig_17();
	thread iz_trig_18();
}

iz_trig_0()
{
	t = getEnt("iz_trig_0", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, -200, 0);
	t thread iz_trig(0.2000);
}

iz_trig_1()
{
	t = getEnt("iz_trig_1", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, -200, 0);
	t thread iz_trig(0.2000);
}

iz_trig_2()
{
	t = getEnt("iz_trig_2", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (-200, 0, 0);
	t thread iz_trig(0.2000);
}

iz_trig_3()
{
	t = getEnt("iz_trig_3", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (-80, 0, 0);
	t thread iz_trig(0.2000);
}

iz_trig_4()
{
	t = getEnt("iz_trig_4", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (-80, 0, 0);
	t thread iz_trig(0.2000);
}

iz_trig_5()
{
	t = getEnt("iz_trig_5", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, 80, 0);
	t thread iz_trig(0.2000);
}

iz_trig_6()
{
	t = getEnt("iz_trig_6", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, 80, 0);
	t thread iz_trig(0.2000);
}

iz_trig_7()
{
	t = getEnt("iz_trig_7", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, -80, 0);
	t thread iz_trig(0.2000);
}

iz_trig_8()
{
	t = getEnt("iz_trig_8", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, -200, 0);
	t thread iz_trig(0.2000);
}

iz_trig_9()
{
	t = getEnt("iz_trig_9", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (-500, 0, 0);
	t thread iz_trig(0.2000);
}

iz_trig_10()
{
	t = getEnt("iz_trig_10", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, -200, 0);
	t thread iz_trig(0.2000);
}

iz_trig_11()
{
	t = getEnt("iz_trig_11", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, 0, 2100);
	t.iz_filter = "boost";
	t thread iz_trig(0.2000);
}

iz_trig_12()
{
	t = getEnt("iz_trig_12", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, 0, 2000);
	t.iz_filter = "boost";
	t thread iz_trig(0.2000);
}

iz_trig_13()
{
	t = getEnt("iz_trig_13", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, 0, 2000);
	t.iz_filter = "boost";
	t thread iz_trig(0.2000);
}

iz_trig_14()
{
	t = getEnt("iz_trig_14", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, 300, 0);
	t thread iz_trig(0.2000);
}

iz_trig_15()
{
	t = getEnt("iz_trig_15", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_acts[t.iz_acts.size] = iz_act("start", "name", "on", 0);
	t thread iz_trig(1);
}

iz_trig_16()
{
	t = getEnt("iz_trig_16", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_filter = "on";
	t.iz_acts[t.iz_acts.size] = iz_act("start", "boost", (500, 0, 0), 0);
	t.iz_acts[t.iz_acts.size] = iz_act("end", "name", "off", 0);
	t thread iz_trig(1);
}

iz_trig_17()
{
	t = getEnt("iz_trig_17", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, -250, 0);
	t thread iz_trig(0.2000);
}

iz_trig_18()
{
	t = getEnt("iz_trig_18", "targetname");
	if (!isDefined(t))
		return;
	t.iz_acts = [];
	t.iz_push = (0, 200, 0);
	t thread iz_trig(0.2000);
}

iz_act(event, kind, value, delay)
{
	act = [];
	act["event"] = event;
	act["kind"] = kind;
	act["value"] = value;
	act["delay"] = delay;
	return act;
}

iz_trig(every)
{
	self.iz_seen = [];
	self.iz_who = [];
	self.iz_fired = [];
	if (isDefined(self.iz_dest))
		self.iz_dest = iz_trig_dest(self.iz_dest);
	for (i = 0; i < self.iz_acts.size; i++)
		if (self.iz_acts[i]["event"] == "end")
		{
			self thread iz_trig_leaves();
			break;
		}
	for (;;)
	{
		self waittill("trigger", player);
		if (!isPlayer(player) || !isAlive(player) || !player iz_named(self))
			continue;
		n = player getEntityNumber();
		now = getTime();
		first = !isDefined(self.iz_seen[n]) || now - self.iz_seen[n] > 100;
		self.iz_seen[n] = now;
		self.iz_who[n] = player;
		if (first)
			self iz_trig_fire(player, "start");
		if (!isDefined(self.iz_fired[n]) || (every >= 0 && now - self.iz_fired[n] >= every * 1000))
		{
			self.iz_fired[n] = now;
			self iz_trig_fire(player, "trigger");
		}
		if (isDefined(self.iz_hold))
			player iz_hold(self.iz_hold, self.iz_hold_time, now);
		if (isDefined(self.iz_push))
			player iz_push(self.iz_push, isDefined(self.iz_push_once), first);
		if (isDefined(self.iz_dest))
			player iz_teleport(self.iz_dest);
	}
}

iz_trig_leaves()
{
	for (;;)
	{
		wait 0.05;
		now = getTime();
		keys = getArrayKeys(self.iz_seen);
		for (i = 0; i < keys.size; i++)
		{
			n = keys[i];
			player = self.iz_who[n];
			if (isDefined(player) && isAlive(player) && now - self.iz_seen[n] <= 50)
				continue;
			self.iz_seen[n] = undefined;
			self.iz_who[n] = undefined;
			if (isDefined(player))
				self iz_trig_fire(player, "end");
		}
	}
}

iz_trig_fire(player, event)
{
	for (i = 0; i < self.iz_acts.size; i++)
	{
		act = self.iz_acts[i];
		if (act["event"] != event)
			continue;
		if (act["kind"] == "boost")
			player thread iz_boost(act["value"], act["delay"]);
		else if (act["kind"] == "name")
			player thread iz_rename(act["value"], act["delay"]);
	}
}

iz_trig_dest(name)
{
	ents = getEntArray(name, "targetname");
	for (i = 0; i < ents.size; i++)
		if (isDefined(ents[i].origin))
			return ents[i];
}

iz_named(trigger)
{
	if (!isDefined(trigger.iz_filter))
		return true;
	named = isDefined(self.iz_name) && self.iz_name == trigger.iz_filter;
	if (!named && isDefined(self.iz_held) && isDefined(self.iz_held[trigger.iz_filter]))
	{
		held = self.iz_held[trigger.iz_filter];
		named = getTime() - held["seen"] <= 100 && getTime() - held["since"] >= held["time"];
	}
	if (isDefined(trigger.iz_filter_not))
		return !named;
	return named;
}

iz_hold(name, time, now)
{
	if (!isDefined(self.iz_held))
		self.iz_held = [];
	held = self.iz_held[name];
	if (!isDefined(held) || now - held["seen"] > 100)
	{
		held = [];
		held["since"] = now;
	}
	held["seen"] = now;
	held["time"] = time;
	self.iz_held[name] = held;
}

iz_rename(name, delay)
{
	self endon("disconnect");
	if (delay > 0)
		wait delay;
	self.iz_name = name;
}

iz_boost(velocity, delay)
{
	self endon("disconnect");
	self endon("death");
	if (delay > 0)
		wait delay;
	self setVelocity(self getVelocity() + velocity);
}

iz_push(push, once, first)
{
	velocity = self getVelocity();
	if (once)
	{
		if (first)
			self setVelocity(velocity + push);
		return;
	}
	flat = (push[0], push[1], 0);
	if (first)
		velocity += flat;
	speed = length(flat);
	if (speed > 0 && self isOnGround())
	{
		along = vectorDot(velocity, flat) / speed;
		if (along < speed)
			velocity += flat * ((speed - along) / speed);
	}
	self setVelocity(velocity + (0, 0, push[2] * 0.05));
}

iz_teleport(dest)
{
	if (!isDefined(dest))
		return;
	self setOrigin(dest.origin);
	if (isDefined(dest.angles))
		self setPlayerAngles(dest.angles);
	self setVelocity((0, 0, 0));
}
