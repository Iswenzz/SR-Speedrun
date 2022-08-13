main()
{
	sr\_mod::main();
	braxi\_mod::main();

	sr\commands\_defrag::main();
	sr\commands\_kz::main();
	sr\commands\_race::main();
	sr\commands\_portal::main();
	sr\game\_match::main();
	sr\game\_hitmarker::main();
	sr\game\_killcam::main();
	sr\game\minigames\_kz::initKz();
	sr\game\minigames\_race::initRace();
	sr\player\customize\_main::initCustomize();
	sr\player\modes\_practise::main();

	speedrun\commands\_speedrun::main();
	speedrun\game\_bot::main();
	speedrun\game\_callbacks::main();
	speedrun\game\_menus::main();
	speedrun\game\_scoreboard::main();
	speedrun\game\_leaderboards::initLeaderboards();
	speedrun\game\_pbs::initPBs();
	speedrun\player\run\_main::main();
	speedrun\player\huds\_cheat::main();
	speedrun\player\huds\_speedrun::main();

	speedrun\_tests::runTests();
}
