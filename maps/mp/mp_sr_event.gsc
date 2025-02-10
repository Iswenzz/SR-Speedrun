#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

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
	sr\game\_event::startGame("Colors", origin, messages);
}

minigame_obstacle()
{
	messages = [];
	messages[messages.size] = "Avoid incoming obstacles by ^5jumping, crouching, or going prone";
	messages[messages.size] = "Only the first ^5five ^7players to survive ^5earn points";

	origin = getEnt("minigame_2", "targetname");
	ambientPlay("minigame2", 0.5);
	sr\game\_event::startGame("Obstacle", origin, messages);
}

minigame_mover()
{
	messages = [];
	messages[messages.size] = "Dodge obstacles on the moving platform by ^5jumping or crouching";
	messages[messages.size] = "Only the first ^5five ^7players to survive ^5earn points";

	origin = getEnt("minigame_3", "targetname");
	ambientPlay("minigame3", 0.5);
	sr\game\_event::startGame("Mover", origin, messages);
}

minigame_speedrun()
{
	messages = [];
	messages[messages.size] = "Speedrun to the end as the map ^5builds itself with random sections";
	messages[messages.size] = "Only the first ^5five ^7players will ^5earn points";

	origin = getEnt("minigame_4", "targetname");
	ambientPlay("minigame4", 0.5);
	sr\game\_event::startGame("Speedrun", origin, messages);
}

minigame_monkeyball()
{
	messages = [];
	messages[messages.size] = "Speedrun through ^5Monkey Ball ^7stages";
	messages[messages.size] = "Navigate by ^5tilting the world ^7with your ^5movement keys";
	messages[messages.size] = "Only the first ^5five ^7players will ^5earn points";

	origin = getEnt("minigame_5", "targetname");
	ambientPlay("minigame5", 0.5);
	sr\game\_event::startGame("Monkey Ball", origin, messages);
}
