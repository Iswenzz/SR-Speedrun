main()
{
	level.iz_cue = [];
	level.iz_cue["iz_cue_chicken_ambient"] = true;
	level.iz_cue["iz_cue_chicken_death"] = true;
	level.iz_cue["iz_cue_chicken_hurt"] = true;
	level.iz_cue["iz_cue_cow_ambient"] = true;
	level.iz_cue["iz_cue_cow_death"] = true;
	level.iz_cue["iz_cue_cow_hurt"] = true;
	level.iz_cue["iz_cue_creeper_death"] = true;
	level.iz_cue["iz_cue_creeper_hurt"] = true;
	level.iz_cue["iz_cue_creeper_primed"] = true;
	level.iz_cue["iz_cue_explode"] = true;
	level.iz_cue["iz_cue_pig_ambient"] = true;
	level.iz_cue["iz_cue_pig_death"] = true;
	level.iz_cue["iz_cue_pig_hurt"] = true;
	level.iz_cue["iz_cue_sheep_ambient"] = true;
	level.iz_cue["iz_cue_sheep_death"] = true;
	level.iz_cue["iz_cue_sheep_hurt"] = true;
	level.iz_cue["iz_cue_skeleton_ambient"] = true;
	level.iz_cue["iz_cue_skeleton_death"] = true;
	level.iz_cue["iz_cue_skeleton_hurt"] = true;
	level.iz_cue["iz_cue_skeleton_shoot"] = true;
	level.iz_cue["iz_cue_spider_ambient"] = true;
	level.iz_cue["iz_cue_spider_death"] = true;
	level.iz_cue["iz_cue_spider_hurt"] = true;
	level.iz_cue["iz_cue_zombie_ambient"] = true;
	level.iz_cue["iz_cue_zombie_death"] = true;
	level.iz_cue["iz_cue_zombie_hurt"] = true;
	thread iz_sounds();

	thread iz_mobs();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
}

iz_sounds()
{
	ambientPlay("iz_0_key", 2);
}

iz_mobs()
{
	level.iz_mobs = [];
	level.iz_boom = loadfx("explosions/grenadeexp_default");
	spawners = getEntArray("iz_spawner", "targetname");
	for (i = 0; i < spawners.size; i++)
		precacheModel(spawners[i].model);
	mobs = getEntArray("iz_mob", "targetname");
	for (i = 0; i < mobs.size; i++)
		mobs[i] thread iz_mob(mobs[i].script_noteworthy);
	for (i = 0; i < spawners.size; i++)
		spawners[i] thread iz_spawner();
	level thread iz_mob_players();
}

iz_scale(v, s)
{
	return (v[0] * s, v[1] * s, v[2] * s);
}

iz_cue(name)
{
	alias = "iz_cue_" + name;
	if (isDefined(level.iz_cue) && isDefined(level.iz_cue[alias]))
		self playSound(alias);
}

iz_cue_at(name, origin)
{
	ent = spawn("script_origin", origin);
	ent iz_cue(name);
	wait 4;
	ent delete();
}

iz_mob_stats(kind)
{
	s = spawnStruct();
	s.health = 100;
	s.speed = 90;
	s.damage = 15;
	s.fight = "melee";
	s.radius = 18;
	s.height = 72;
	switch (kind)
	{
	case "skeleton":
	case "stray":
		s.fight = "bow";
		s.damage = 12;
		s.speed = 100;
		break;
	case "creeper":
		s.fight = "explode";
		s.damage = 90;
		s.height = 64;
		break;
	case "spider":
		s.health = 80;
		s.speed = 120;
		s.damage = 10;
		s.radius = 28;
		s.height = 36;
		break;
	case "cave_spider":
		s.health = 60;
		s.speed = 120;
		s.damage = 10;
		s.radius = 20;
		s.height = 26;
		break;
	case "pig":
		s.health = 50;
		s.speed = 70;
		s.fight = "none";
		s.radius = 20;
		s.height = 36;
		break;
	case "cow":
		s.health = 50;
		s.speed = 60;
		s.fight = "none";
		s.radius = 24;
		s.height = 54;
		break;
	case "sheep":
		s.health = 40;
		s.speed = 70;
		s.fight = "none";
		s.radius = 22;
		s.height = 50;
		break;
	case "chicken":
		s.health = 20;
		s.speed = 70;
		s.fight = "none";
		s.radius = 12;
		s.height = 28;
		break;
	}
	return s;
}

iz_mob_register(mob)
{
	live = [];
	for (i = 0; i < level.iz_mobs.size; i++)
		if (isDefined(level.iz_mobs[i]) && level.iz_mobs[i].izHealth > 0)
			live[live.size] = level.iz_mobs[i];
	live[live.size] = mob;
	level.iz_mobs = live;
}

iz_mob(kind)
{
	self.kind = kind;
	self.stats = iz_mob_stats(kind);
	self.izHealth = self.stats.health;
	self.izNext = 0;
	self.izPanic = 0;
	iz_mob_register(self);
	self thread iz_mob_voice();
	wait(randomFloat(0.5));
	for (;;)
	{
		if (!isDefined(self) || self.izHealth <= 0)
			return;
		target = undefined;
		if (self.stats.fight != "none")
		{
			range = 520;
			if (self.stats.fight == "bow")
				range = 640;
			target = self iz_mob_target(range);
		}
		if (isDefined(target))
			self iz_mob_fight(target);
		else
			self iz_mob_wander();
	}
}

iz_mob_voice()
{
	for (;;)
	{
		wait(randomFloatRange(6, 16));
		if (!isDefined(self) || self.izHealth <= 0)
			return;
		self iz_cue(self.kind + "_ambient");
	}
}

iz_mob_target(range)
{
	best = undefined;
	nearest = range;
	eye = self.origin + (0, 0, self.stats.height * 0.8);
	players = getEntArray("player", "classname");
	for (i = 0; i < players.size; i++)
	{
		player = players[i];
		if (!isAlive(player) || player.sessionstate != "playing")
			continue;
		d = distance(player.origin, self.origin);
		if (d < nearest && sightTracePassed(eye, player getEye(), false, self))
		{
			best = player;
			nearest = d;
		}
	}
	return best;
}

iz_mob_face(origin)
{
	dir = origin - self.origin;
	self rotateTo((0, vectorToAngles((dir[0], dir[1], 0))[1], 0), 0.2);
}

// A fifth of a second's walk toward goal, over steps of up to a block and
// never off a drop of more than two; false where the way is shut.
iz_mob_step(goal, speed)
{
	dir = goal - self.origin;
	dir = (dir[0], dir[1], 0);
	if (length(dir) < 4)
	{
		wait 0.2;
		return false;
	}
	dir = vectorNormalize(dir);
	next = self.origin + iz_scale(dir, speed * 0.2);
	trace = bulletTrace(next + (0, 0, 48), next - (0, 0, 80), false, self);
	if (trace["fraction"] >= 1 || trace["position"][2] - self.origin[2] > 44
		|| !sightTracePassed(self.origin + (0, 0, 48), trace["position"] + (0, 0, 30), false, self))
	{
		wait 0.2;
		return false;
	}
	self rotateTo((0, vectorToAngles(dir)[1], 0), 0.2);
	self moveTo(trace["position"], 0.2);
	wait 0.2;
	return true;
}

iz_mob_wander()
{
	if (getTime() < self.izPanic && isDefined(self.izAttacker))
	{
		away = self.origin - self.izAttacker.origin;
		self iz_mob_step(self.origin + iz_scale(vectorNormalize((away[0], away[1], 0)), 200), self.stats.speed * 1.6);
		return;
	}
	if (randomInt(100) < 40)
	{
		wait(randomFloatRange(1, 3));
		return;
	}
	dir = anglesToForward((0, randomFloat(360), 0));
	steps = randomIntRange(4, 12);
	for (i = 0; i < steps; i++)
	{
		if (!self iz_mob_step(self.origin + iz_scale(dir, 100), self.stats.speed * 0.6))
			return;
		if (self.izHealth <= 0 || getTime() < self.izPanic)
			return;
		if (i % 3 == 2 && self.stats.fight != "none" && isDefined(self iz_mob_target(520)))
			return;
	}
}

iz_mob_fight(target)
{
	d = distance(target.origin, self.origin);
	if (self.stats.fight == "bow" && d < 400)
	{
		self iz_mob_face(target.origin);
		if (getTime() >= self.izNext)
		{
			self.izNext = getTime() + 2000;
			self iz_cue("skeleton_shoot");
			target iz_mob_hurt(self, self.stats.damage, "MOD_PROJECTILE");
		}
		wait 0.2;
		return;
	}
	if (self.stats.fight == "explode" && d < 110)
	{
		self iz_mob_fuse(target);
		return;
	}
	if (d < 56 + self.stats.radius)
	{
		self iz_mob_face(target.origin);
		if (getTime() >= self.izNext)
		{
			self.izNext = getTime() + 1000;
			target iz_mob_hurt(self, self.stats.damage, "MOD_MELEE");
		}
		wait 0.2;
		return;
	}
	self iz_mob_step(target.origin, self.stats.speed);
}

// A creeper's fuse: a second and a half, out if its target gets away.
iz_mob_fuse(target)
{
	self iz_cue("creeper_primed");
	for (i = 0; i < 6; i++)
	{
		wait 0.25;
		if (self.izHealth <= 0)
			return;
		if (!isDefined(target) || !isAlive(target) || distance(target.origin, self.origin) > 180)
			return;
	}
	origin = self.origin;
	self.izHealth = 0;
	playFx(level.iz_boom, origin + (0, 0, 24));
	level thread iz_cue_at("explode", origin);
	self radiusDamage(origin + (0, 0, 30), 160, self.stats.damage, 20);
	self hide();
	self thread iz_mob_remove(1);
}

iz_mob_hurt(mob, damage, means)
{
	if (!isAlive(self))
		return;
	dir = vectorNormalize(self.origin - mob.origin);
	self maps\mp\gametypes\_callbacksetup::CodeCallback_PlayerDamage(mob, mob, damage, 0, means, "none", mob.origin, dir, "none", 0);
}

iz_mob_damage(damage, attacker)
{
	if (self.izHealth <= 0)
		return;
	self.izHealth -= damage;
	self.izAttacker = attacker;
	if (self.izHealth > 0)
	{
		self iz_cue(self.kind + "_hurt");
		if (self.stats.fight == "none")
			self.izPanic = getTime() + 3000;
		return;
	}
	self iz_cue(self.kind + "_death");
	self rotateRoll(90, 0.4);
	self thread iz_mob_remove(1.5);
}

iz_mob_remove(delay)
{
	wait delay;
	if (isDefined(self))
		self delete();
}

iz_spawner()
{
	self hide();
	self notSolid();
	kind = self.script_noteworthy;
	natural = isDefined(self.script_label) && self.script_label == "natural";
	cap = 4;
	reach = 630;
	if (natural)
	{
		cap = 1;
		reach = 1600;
	}
	alive = [];
	for (;;)
	{
		if (natural)
			wait(randomFloatRange(20, 40));
		else
			wait(randomFloatRange(10, 30));
		live = [];
		for (i = 0; i < alive.size; i++)
			if (isDefined(alive[i]) && alive[i].izHealth > 0)
				live[live.size] = alive[i];
		alive = live;
		if (alive.size >= cap)
			continue;
		near = false;
		players = getEntArray("player", "classname");
		for (i = 0; i < players.size; i++)
		{
			d = distance(players[i].origin, self.origin);
			if (isAlive(players[i]) && d < reach && (!natural || d > 300))
				near = true;
		}
		if (!near)
			continue;
		count = 1;
		if (!natural)
			count = randomIntRange(1, 3);
		for (n = 0; n < count && alive.size < cap; n++)
		{
			spot = self.origin;
			if (!natural)
				spot = spot + (randomFloatRange(-160, 160), randomFloatRange(-160, 160), 0);
			trace = bulletTrace(spot + (0, 0, 60), spot - (0, 0, 120), false, self);
			if (trace["fraction"] >= 1)
				continue;
			mob = spawn("script_model", trace["position"]);
			mob setModel(self.model);
			mob.angles = (0, randomFloat(360), 0);
			mob thread iz_mob(kind);
			alive[alive.size] = mob;
		}
	}
}

iz_mob_players()
{
	for (;;)
	{
		level waittill("connected", player);
		player thread iz_mob_shots();
		player thread iz_mob_melee();
	}
}

iz_mob_shots()
{
	self endon("disconnect");
	for (;;)
	{
		self waittill("weapon_fired");
		self iz_mob_strike(4000, 34, 6);
	}
}

iz_mob_melee()
{
	self endon("disconnect");
	for (;;)
	{
		wait 0.05;
		if (!self meleeButtonPressed())
			continue;
		self iz_mob_strike(80, 50, 24);
		while (self meleeButtonPressed())
			wait 0.05;
	}
}

// The nearest living mob along the player's aim within range, its body a
// cylinder widened by slack.
iz_mob_strike(range, damage, slack)
{
	eye = self getEye();
	forward = anglesToForward(self getPlayerAngles());
	best = undefined;
	nearest = range;
	for (i = 0; i < level.iz_mobs.size; i++)
	{
		mob = level.iz_mobs[i];
		if (!isDefined(mob) || mob.izHealth <= 0)
			continue;
		centre = mob.origin + (0, 0, mob.stats.height * 0.5);
		v = centre - eye;
		t = vectorDot(v, forward);
		if (t < 0 || t > nearest)
			continue;
		off = v - iz_scale(forward, t);
		if (length((off[0], off[1], 0)) > mob.stats.radius + slack || abs(off[2]) > mob.stats.height * 0.5 + slack)
			continue;
		if (!sightTracePassed(eye, centre, false, mob))
			continue;
		best = mob;
		nearest = t;
	}
	if (isDefined(best))
		best iz_mob_damage(damage, self);
}
