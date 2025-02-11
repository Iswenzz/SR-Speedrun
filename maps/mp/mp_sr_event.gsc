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

	thread minigames();

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
		players = getPlayingPlayers();
		color = colors[randomInt(colors.size)];

		if (players.size <= 1)
		{
			if (isDefined(players[0]))
				players[0] suicide();
			level notify("event_round_end");
		}
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

colors_death()
{
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

}

obstacle_start()
{

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

}

mover_start()
{

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

}

speedrun_start()
{

}

minigame_monkeyball()
{
	messages = [];
	messages[messages.size] = "Speedrun through ^5Monkey Ball ^7stages";
	messages[messages.size] = "Navigate by ^5tilting the world ^7with your ^5movement keys";
	messages[messages.size] = "Only the first ^5five ^7players will ^5earn points";

	origin = getEnt("minigame_5", "targetname");
	ambientPlay("minigame5", 0.5);
	startGame("Monkey Ball", origin, messages, ::monkeyball_reset, ::monkeyball_start);
}

monkeyball_reset()
{

}

monkeyball_start()
{

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

onPlayerDeath()
{
	self endon("spawned");
	self endon("disconnect");

	if (!isEventStarted())
		return;

	switch (level.eventGame)
	{
		case 0: self colors_death(); break;
	}
}
