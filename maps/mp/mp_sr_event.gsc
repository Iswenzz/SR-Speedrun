#include sr\sys\_events;
#include sr\game\_event;
#include sr\utils\_common;

main()
{
	maps\mp\_load::main();
	maps\mp\_compass::setupMiniMap("compass_mp_sr_event");

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setDvar("compassmaxrange", "1600");
	setDvar("r_glowbloomintensity0", "0.1");
	setDvar("r_glowbloomintensity1", "0.1");
	setDvar("r_glowskybleedintensity0", "0.1");
	setDvar("bg_falldamagemaxheight", 20000000);
	setDvar("bg_falldamageminheight", 15000000);

	registerEventMap();

	thread minigames();
	thread teleporters();

	event("death", ::onPlayerDeath);
}

minigames()
{
	while (true)
	{
		level waittill("event_start");

		minigame_colors();
		minigame_obstacle();
		minigame_mover();
		minigame_speedrun();
		minigame_monkeyball();

		ambientStop(1);
	}
}

teleporters()
{
	tps = getEntArray("tp", "targetname");
	for (i = 0; i < tps.size; i++)
		tps[i] thread teleporter_trig();
}

teleporter_trig()
{
	entity = getEnt(self.target, "targetname");

	while (true)
	{
		self waittill("trigger", player);

		player setOrigin(entity.origin);
		player setPlayerAngles(entity.angles);
	}
}

minigame_colors()
{
	messages = [];
	messages[messages.size] = "Jump on the platform that ^5matches the displayed color";
	messages[messages.size] = "Only the first ^5five ^7players to survive ^5earn points";

	origin = getEnt("minigame_1", "targetname");
	ambientPlay("minigame1", 0.5);
	startGame("Colors", origin, messages, ::colors_reset, ::colors_start);
}

colors_reset()
{
	colors_show("cyan");
	colors_show_plat("all");

	spin = getEnt("spin", "targetname");
	spin.angles = (0, 0, 0);
}

colors_start()
{
	level endon("event_round_end");

	colors_show("cyan");
	colors_show_plat("cyan");
	thread colors_spin();

	colors = [];
	colors[colors.size] = "black";
	colors[colors.size] = "cyan";
	colors[colors.size] = "red";
	colors[colors.size] = "orange";
	colors[colors.size] = "green";
	colors[colors.size] = "purple";

	wait 1;

	count = 0;
	time = 5;
	while (true)
	{
		watchPlayerCount();
		color = colors[randomInt(colors.size)];

		wait time;
		colors_show(color);
		colors_show_plat("all");
		wait time;
		colors_show_plat(color);

		count++;
		if (count == 2)
		{
			wave(2);
			time = 3;
		}
		if (count == 6)
		{
			wave(3);
			time = 2;
		}
		if (count == 12)
		{
			wave(4);
			time = 1.5;
		}
		if (count == 20)
		{
			wave(5);
			time = 1;
		}
	}
}

colors_spin()
{
	level endon("event_round_end");
	spin = getEnt("spin", "targetname");

	if (!isDefined(spin.hurt))
	{
		spin.hurt = getEnt("spin_hurt", "targetname");
		spin.hurt enableLinkTo();
		spin.hurt linkTo(spin);
	}
	while (true)
	{
		time = 3;
		spin rotateYaw(Ternary(level.eventWave % 2, 360, -360), time);
		wait time;
	}
}

colors_show(color)
{
	colors = [];
	colors["black"] = getEntArray("color_black", "targetname");
	colors["cyan"] = getEntArray("color_cyan", "targetname");
	colors["red"] = getEntArray("color_red", "targetname");
	colors["orange"] = getEntArray("color_orange", "targetname");
	colors["green"] = getEntArray("color_green", "targetname");
	colors["purple"] = getEntArray("color_purple", "targetname");

	for (i = 0; i < colors["black"].size; i++)
	{
		colors["black"][i] hideEntity();
		colors["cyan"][i] hideEntity();
		colors["red"][i] hideEntity();
		colors["orange"][i] hideEntity();
		colors["green"][i] hideEntity();
		colors["purple"][i] hideEntity();
	}
	for (i = 0; i < colors["black"].size; i++)
		colors[color][i] showEntity();
}

colors_show_plat(color)
{
	colors = [];
	colors["black"] = getEntArray("plat_black", "targetname");
	colors["cyan"] = getEntArray("plat_cyan", "targetname");
	colors["red"] = getEntArray("plat_red", "targetname");
	colors["orange"] = getEntArray("plat_orange", "targetname");
	colors["green"] = getEntArray("plat_green", "targetname");
	colors["purple"] = getEntArray("plat_purple", "targetname");

	if (color == "all")
	{
		for (i = 0; i < colors["black"].size; i++)
		{
			colors["black"][i] showEntity();
			colors["cyan"][i] showEntity();
			colors["red"][i] showEntity();
			colors["orange"][i] showEntity();
			colors["green"][i] showEntity();
			colors["purple"][i] showEntity();
		}
		return;
	}
	for (i = 0; i < colors["black"].size; i++)
	{
		colors["black"][i] hideEntity();
		colors["cyan"][i] hideEntity();
		colors["red"][i] hideEntity();
		colors["orange"][i] hideEntity();
		colors["green"][i] hideEntity();
		colors["purple"][i] hideEntity();
	}
	for (i = 0; i < colors["black"].size; i++)
		colors[color][i] showEntity();
}

minigame_obstacle()
{
	messages = [];
	messages[messages.size] = "Avoid incoming obstacles by ^5jumping, crouching, or going prone";
	messages[messages.size] = "Only the first ^5five ^7players to survive ^5earn points";

	origin = getEnt("minigame_2", "targetname");
	ambientPlay("minigame2", 0.5);
	startGame("Obstacle", origin, messages, ::obstacle_reset, ::obstacle_start);
}

obstacle_reset()
{
	push = getEntArray("push", "targetname");
	defaultOrigin = push[5].origin;

	for (i = 0; i < 9; i++)
	{
		push[i] hideEntity();
		if (!isDefined(push[i].defaultOrigin))
			push[i].defaultOrigin = defaultOrigin;
		push[i].origin = push[i].defaultOrigin;
	}
}

obstacle_start()
{
	level endon("event_round_end");
	push = getEntArray("push", "targetname");

	count = 0;
	time = 3;

	while (true)
	{
		mover = push[randomInt(push.size)];
		watchPlayerCount();

		mover showEntity();
		mover moveY(1500, time);
		wait time;

		obstacle_reset();

		count++;
		if (count == 2)
		{
			wave(2);
			time = 2.5;
		}
		if (count == 6)
		{
			wave(3);
			time = 2;
		}
		if (count == 12)
		{
			wave(4);
			time = 1.5;
		}
		if (count == 20)
		{
			wave(5);
			time = 1;
		}
	}
}

minigame_mover()
{
	messages = [];
	messages[messages.size] = "Dodge obstacles on the moving platform by ^5jumping or crouching";
	messages[messages.size] = "Only the first ^5five ^7players to survive ^5earn points";

	origin = getEnt("minigame_3", "targetname");
	ambientPlay("minigame3", 0.5);
	startGame("Mover", origin, messages, ::mover_reset, ::mover_start);
}

mover_reset()
{
	mover = getEnt("mover", "targetname");
	mover_grid = getEnt("mover_grid", "targetname");

	if (!isDefined(mover.defaultOrigin))
		mover.defaultOrigin = mover.origin;
	if (!isDefined(mover_grid.defaultOrigin))
		mover_grid.defaultOrigin = mover_grid.origin;

	mover.origin = mover.defaultOrigin;
	mover_grid.origin = mover_grid.defaultOrigin;
}

mover_start()
{
	level endon("event_round_end");

	entity = getEnt("minigame_3", "targetname");
	mover = getEnt("mover", "targetname");
	mover_grid = getEnt("mover_grid", "targetname");

	count = 0;
	time = 20;

	mover_grid moveZ(-400, 5);
	wait 5;

	while (true)
	{
		watchPlayerCount();

		mover moveY(-15500, time);
		wait time;
		mover.origin = mover.defaultOrigin;

		players = getPlayingPlayers();
		for (i = 0; i < players.size; i++)
			players[i] setOrigin(entity.origin);

		count++;
		if (count == 1)
		{
			wave(2);
			time = 17;
		}
		if (count == 2)
		{
			wave(3);
			time = 14;
		}
		if (count == 3)
		{
			wave(4);
			time = 12;
		}
		if (count == 4)
		{
			wave(5);
			time = 10;
		}
		if (count == 5)
		{
			wave(6);
			time = 8;
		}
	}
}

minigame_speedrun()
{
	messages = [];
	messages[messages.size] = "Speedrun to the end as the map ^5builds itself with random sections";
	messages[messages.size] = "Only the first ^5five ^7players will ^5earn points";

	origin = getEnt("minigame_4", "targetname");
	ambientPlay("minigame4", 0.5);
	startGame("Speedrun", origin, messages, ::speedrun_reset, ::speedrun_start);
}

speedrun_reset()
{
	run = getEntArray("run", "targetname");
	run_door = getEnt("run_door", "targetname");

	if (!isDefined(run_door.defaultOrigin))
		run_door.defaultOrigin = run_door.origin;
	run_door.origin = run_door.defaultOrigin;

	for (i = 0; i < run.size; i++)
	{
		if (!isDefined(run[i].defaultOrigin))
			run[i].defaultOrigin = run[i].origin;
		run[i].origin = run[i].defaultOrigin;
	}
}

speedrun_start()
{
	level endon("event_round_end");

	entity = getEnt("minigame_4", "targetname");
	run = getEntArray("run", "targetname");
	run_door = getEnt("run_door", "targetname");

	sections = [];
	section_1 = (10624, 4152, 228);
	section_2 = (10624, 2488, 228);
	section_3 = (10624, 824, 228);

	level.speedrunPlayers = 5;
	level.speedrunPlayersFinished = [];

	while (sections.size < 3)
	{
		section = run[randomInt(run.size)];
		if (!Contains(sections, section))
			sections[sections.size] = section;
	}
	run_door moveZ(-800, 4);
	wait 2;

	sections[0].origin = section_1;
	sections[1].origin = section_2;
	sections[2].origin = section_3;
	thread speedrun_trigger();

	while (true)
	{
		watchPlayerCount();

		players = getPlayingPlayers();
		if (players.size < level.speedrunPlayers)
			level.speedrunPlayers = players.size;

		if (level.speedrunPlayersFinished.size < level.speedrunPlayers)
		{
			wait 1;
			continue;
		}
		for (i = 0; i < players.size; i++)
		{
			if (Contains(level.speedrunPlayersFinished, players[i]))
				continue;

			players[i] suicide();
		}
		wait 5;
		watchPlayerCount();
		speedrun_reset();

		for (i = 0; i < level.speedrunPlayersFinished.size; i++)
		{
			level.speedrunPlayersFinished[i] setOrigin(entity.origin);
			level.speedrunPlayersFinished[i] setPlayerAngles(entity.angles);
		}
		level.speedrunPlayersFinished = [];

		sections = [];
		while (sections.size < 3)
		{
			section = run[randomInt(run.size)];
			if (!Contains(sections, section))
				sections[sections.size] = section;
		}
		run_door moveZ(-800, 4);
		wait 2;

		sections[0].origin = section_1;
		sections[1].origin = section_2;
		sections[2].origin = section_3;

		level.speedrunPlayers--;
	}
}

speedrun_trigger()
{
	level endon("event_round_end");
	trigger = getEnt("tp_origin_7", "target");

	while (true)
	{
		trigger waittill("trigger", player);
		level.speedrunPlayersFinished = player registerPlayerFinish(level.speedrunPlayersFinished, level.speedrunPlayers, 1);
	}
}

minigame_monkeyball()
{
	messages = [];
	messages[messages.size] = "Speedrun through ^5Monkey Ball ^7stages";
	messages[messages.size] = "Only the first ^5five ^7players will ^5earn points";

	thread monkeyball_bounces();

	origin = getEnt("minigame_5", "targetname");
	ambientPlay("minigame5", 0.5);
	startGame("Monkey Ball", origin, messages, ::monkeyball_reset, ::monkeyball_start);
}

monkeyball_reset()
{
	start = getEnt("monkey_door", "targetname");

	if (!isDefined(start.defaultOrigin))
		start.defaultOrigin = start.origin;
	start.origin = start.defaultOrigin;
}

monkeyball_start()
{
	level endon("event_round_end");

	level.monkeyPlayers = 5;
	level.monkeyPlayersFinished = [];

	players = getAllPlayers();
	for (i = 0; i < players.size; i++)
	{
		players[i] allowJump(false);
		players[i] allowSprint(false);
		players[i] setMoveSpeed(600);
	}
	start = getEnt("monkey_door", "targetname");
	start moveZ(-700, 3);
	wait 3;

	thread monkeyball_trigger();

	while (true)
	{
		watchPlayerCount();

		players = getPlayingPlayers();
		if (players.size < level.monkeyPlayers)
			level.monkeyPlayers = players.size;

		if (level.monkeyPlayersFinished.size >= level.monkeyPlayers)
		{
			for (i = 0; i < players.size; i++)
				players[i] suicide();
		}
		wait 1;
	}
}

monkeyball_trigger()
{
	level endon("event_round_end");
	trigger = getEnt("monkey_end", "targetname");

	while (true)
	{
		trigger waittill("trigger", player);
		level.monkeyPlayersFinished = player registerPlayerFinish(level.monkeyPlayersFinished, level.monkeyPlayers);
		player suicide();
	}
}

monkeyball_bounces()
{
	if (isDefined(level.monkeyBounces))
		return;
	level.monkeyBounces = true;

	plats = getEntArray("monkey_bounce", "targetname");
	trigs = getEntArray("monkey_bounce_trig", "targetname");

	for (i = 0; i < trigs.size; i++)
	{
		trigs[i] triggerOff();
		trigs[i] thread monkeyball_bounces_trig(i);
	}
	while (true)
	{
		for (i = 0; i < plats.size; i++)
			plats[i] moveZ(64, 0.2);

		for (i = 0; i < trigs.size; i++)
			trigs[i] triggerOn();

		wait 0.4;

		for (i = 0; i < plats.size; i++)
			plats[i] moveZ(-64, 0.2);

		for (i = 0; i < trigs.size; i++)
			trigs[i] triggerOff();

		wait 4;
	}
}

monkeyball_bounces_trig(i)
{
	power = 10;
	switch (i)
	{
		case 9: power = 15; break;
		case 10: power = 15; break;
		case 11: power = 15; break;
		case 12: power = 15; break;
	}
	while (true)
	{
		self waittill("trigger", player);
		player thread monkeyball_bounce_player(power);
	}
}

monkeyball_bounce_player(power)
{
	self endon("death");
	self endon("disconnect");

	if (isDefined(self.monkeyBounce))
		return;

	self.monkeyBounce = true;
	self bounce(self.origin, vectorNormalize((0, 0, 20)), 1000, power);
	wait 1;
	self.monkeyBounce = undefined;
}

showEntity()
{
	self solid();
	self show();
}

hideEntity()
{
	self notSolid();
	self hide();
}

wave(number)
{
	level.eventWave = number;
	iPrintLnBold("^1WAVE " + number);
}

watchPlayerCount()
{
	players = getPlayingPlayers();
	if (players.size <= 1)
	{
		if (isDefined(players[0]))
			players[0] suicide();
		level notify("event_round_end");
	}
}

registerPlayerFinish(array, max, maxPoint)
{
	if (Contains(array, self) || array.size >= max)
		return array;

	point = 1;
	switch (array.size)
	{
		case 4:
			iPrintLnBold(fmt("%s ^7finished in 5th place", self.name));
			point = 1;
			break;
		case 3:
			iPrintLnBold(fmt("%s ^7finished in 4th place", self.name));
			point = 2;
			break;
		case 2:
			iPrintLnBold(fmt("%s ^7finished in ^93rd place", self.name));
			point = 3;
			break;
		case 1:
			iPrintLnBold(fmt("%s ^7finished in ^82nd place", self.name));
			point = 4;
			break;
		case 0:
			iPrintLnBold(fmt("%s ^7finished in ^31st place", self.name));
			point = 5;
			break;
	}
	if (isDefined(maxPoint) && point > maxPoint)
		point = maxPoint;

	self playerAddPoints(point);
	array[array.size] = self;
	return array;
}

onPlayerDeath()
{
	self endon("spawned");
	self endon("disconnect");

	if (!isEventGame(0) && !isEventGame(1) && !isEventGame(2))
		return;

	players = getPlayingPlayers();

	switch (players.size)
	{
		case 4:
			iPrintLnBold(fmt("%s ^7finished in 5th place", self.name));
			self playerAddPoints(1);
			break;
		case 3:
			iPrintLnBold(fmt("%s ^7finished in 4th place", self.name));
			self playerAddPoints(2);
			break;
		case 2:
			iPrintLnBold(fmt("%s ^7finished in ^93rd place", self.name));
			self playerAddPoints(3);
			break;
		case 1:
			iPrintLnBold(fmt("%s ^7finished in ^82nd place", self.name));
			self playerAddPoints(4);
			break;
		case 0:
			iPrintLnBold(fmt("%s ^7finished in ^31st place", self.name));
			self playerAddPoints(5);
			break;
	}
}
