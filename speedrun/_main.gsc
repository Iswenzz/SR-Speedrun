main()
{
	thread sr\_main::main();
	thread braxi\_mod::main();

	thread speedrun\commands\_speedrun::main();

	thread speedrun\game\_match::main();
	thread speedrun\game\_bot::main();
	thread speedrun\game\_callbacks::main();
	thread speedrun\game\_menus::main();
	thread speedrun\game\_scoreboard::main();
	// thread speedrun\game\_speedrun::main();

	thread sr\player\customize\_main::initCustomize();
	thread speedrun\player\huds\_cheat::main();
	// thread speedrun\player\huds\_spectator::main();
	// thread speedrun\player\huds\_speedrun::main();
}
