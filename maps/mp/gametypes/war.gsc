main()
{
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();

	println("Trying to load correct gametype!");

	setDvar("g_gametype", "deathrun");
	exitLevel(false);
}

Callback_StartGameType()
{
	if (!isDefined(game["allies"]))
		game["allies"] = "marines";
	if (!isDefined(game["axis"]))
		game["axis"] = "opfor";
}
