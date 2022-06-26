main()
{
	sr\_mod::main();
	braxi\_mod::main();

	sr\commands\game\_kz::main();
	sr\commands\game\_race::main();
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
	speedrun\game\_run::main();
	speedrun\game\_leaderboards::initLeaderboards();
	speedrun\game\_pbs::initPBs();
	speedrun\player\huds\_cheat::main();
	speedrun\player\huds\_player::main();
	speedrun\player\huds\_spectator::main();
	speedrun\player\huds\_speedrun::main();

	speedrun\_tests::runTests();

	sr\utils\_common::waitMapLoad();
	bots = sr\utils\_common::spawnBots(3);
}
