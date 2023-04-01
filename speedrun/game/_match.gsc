#include sr\sys\_events;
#include sr\utils\_common;
#include sr\utils\_hud;

main()
{
	level.allowSpawn = true;
	level.huds["match"] = [];
	level.time = level.dvar["time"];

	game["roundsplayed"] = IfUndef(game["roundsplayed"], 0) + 1;
	game["roundStarted"] = false;
	game["state"] = "playing";

	event("map", ::huds);
	event("map", ::start);
}

start()
{
	level endon("endround");
	level endon("game over");
	level notify("kill logic");
	wait 0.05;
	level endon("kill logic");

	canStartGame();
	roundStartTimer();
	canStartGame();

	level notify("round_started", game["roundsplayed"]);
	level notify("game started");
	game["state"] = "playing";
	game["roundStarted"] = true;

	matchStartPlayers();
	timer();
	thread speedrun\game\_map::end();
}

canStartGame()
{
	count = 0;
	players = getAllPlayers();

	while (level.dvar["event"])
		wait 0.05;

	for (i = 0; i < players.size; i++)
	{
		if (players[i] isPlaying())
			count++;
	}
	if (count >= level.dvar["match_need_players"])
		return;

	waitForMorePlayers();
	thread start();
}

waitForMorePlayers()
{
	visionSetNaked("mpIntro", 0);
	if (isDefined(level.huds["match"]["text"]))
		level.huds["match"]["text"] destroy();

	level.huds["match"]["text"] = addHud(level, 0, -20, 1, "center", "middle", 1.5, 1001);
	level.huds["match"]["text"] setText(level.texts["waiting_for_players"]);
	level.huds["match"]["text"].font = "objective";

	wait 1;
}

matchStartPlayers()
{
	visionSetNaked(toLower(level.map), 2.0);

	players = getAllPlayers();
	for (i = 0; i < players.size; i++)
	{
		if (players[i] isPlaying())
		{
			players[i] freezeControls(false);
			players[i] unLink();
			players[i] enableWeapons();
		}
	}
}

roundStartTimer()
{
	if (!level.dvar["spawn_time"])
		return;

	if (isDefined(level.huds["match"]["text"]))
		level.huds["match"]["text"] destroy();
	if (isDefined(level.huds["match"]["timer"]))
		level.huds["match"]["timer"] destroy();

	level.huds["match"]["text"] = addHud(level, 0, -20, 1, "center", "middle", 1.5, 1001);
	level.huds["match"]["text"] setText(level.texts["round_begins_in"]);
	level.huds["match"]["text"].font = "objective";

	level.huds["match"]["timer"] = addHud(level, 0, 0, 1, "center", "middle", 1.4, 1001);
	level.huds["match"]["timer"] setTimer(level.dvar["spawn_time"]);
	level.huds["match"]["timer"].font = "objective";

	wait level.dvar["spawn_time"];

	level.huds["match"]["text"] destroy();
	level.huds["match"]["timer"] destroy();
}

timer()
{
	level thread timerDelete();

	level.huds["time"].label = &"^7&&1";
	level.huds["time"] setTimer(level.time - 1);

	clock = spawn("script_origin", (0, 0, 0));

	while (level.time > 0)
	{
		wait 1;
		level.time--;

		if (level.time == 180)
			level sr\sys\_notifications::show("^1Map will end in 3 minutes!");
		else if (level.time <= 60 && level.time > 10 && level.time % 2 == 0)
		{
			clock playSound("ui_mp_timer_countdown");
			level.huds["time"].color = (1, 0.55, 0);
		}
		else if (level.time <= 10)
		{
			clock playSound("ui_mp_timer_countdown");
			level.huds["time"].color = (1, 0, 0);
		}
		else if (level.time >= 60)
			level.huds["time"].color = (1, 1, 1);
	}
	clock delete();
	if (isDefined(level.huds["time"]))
		level.huds["time"] destroy();
}

timerDelete()
{
	level waittill("game over");

	if (isDefined(level.huds["time"]))
		level.huds["time"] destroy();
}

huds()
{
	level.huds["time"] = newHudElem();
	level.huds["time"].foreground = true;
	level.huds["time"].alignX = "right";
	level.huds["time"].alignY = "bottom";
	level.huds["time"].horzAlign = "right";
	level.huds["time"].vertAlign = "bottom";
	level.huds["time"].x = -5;
	level.huds["time"].y = 0;
	level.huds["time"].sort = 100;
	level.huds["time"].fontScale = 1.4;
	level.huds["time"].color = (1, 1, 1);
	level.huds["time"].font = "objective";
	level.huds["time"].hidewheninmenu = true;
	level.huds["time"].label = &"^7&&1";
	level.huds["time"].alpha = 1;
	level.huds["time"].archived = false;
	level.huds["time"] setText(fmt("%d:00", int(level.time / 60)));
}
