main()
{
	level.callbackStartGameType = ::Callback_StartGameType;

	level.script = toLower(getDvar("mapname"));
	level.gametype = toLower(getDvar("g_gametype"));
}

Callback_StartGameType()
{
	if (!isDefined(game["allies"]))
		game["allies"] = "marines";
	if (!isDefined(game["axis"] ))
		game["axis"] = "opfor";

	speedrun\_main::main();

	allowed[0] = "war";
	maps\mp\gametypes\_gameobjects::main(allowed);
}
