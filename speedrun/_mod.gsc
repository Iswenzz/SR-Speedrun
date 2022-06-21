main()
{
	sr\_mod::main();
	braxi\_mod::main();

	sr\commands\game\_kz::main();
	sr\commands\game\_minesweeper::main();
	sr\commands\game\_race::main();
	sr\game\_hitmarker::main();
	sr\game\_killcam::main();
	sr\game\minigames\_kz::initKz();
	sr\game\minigames\_minesweeper::initMinesweeper();
	sr\game\minigames\_race::initRace();
	sr\player\customize\_main::initCustomize();

	speedrun\commands\_speedrun::main();
	sr\game\_match::main();
	speedrun\game\_bot::main();
	speedrun\game\_callbacks::main();
	speedrun\game\_menus::main();
	speedrun\game\_scoreboard::main();
	speedrun\game\_leaderboards::initLeaderboards();
	speedrun\game\_run::main();
	speedrun\game\_pbs::initPBs();
	speedrun\player\huds\_cheat::main();
	speedrun\player\huds\_player::main();
	speedrun\player\huds\_spectator::main();
	speedrun\player\huds\_speedrun::main();
	sr\player\modes\_practise::main();

	speedrun\_tests::runTests();

	// @TODO Remove
	wait 6;
	bots = sr\utils\_common::spawnBots(1);
	for (i = 0; i < bots.size; i++)
		bots[i] sr\sys\_admins::command("killzone");
}
