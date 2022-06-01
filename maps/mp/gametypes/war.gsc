main()
{
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	setDvar("g_gametype", "deathrun");
	exitLevel(false);
}
