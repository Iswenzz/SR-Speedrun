main()
{
	precache();

	speedrun\game\_dvar::initDvars();

	sr\_mod::main();
	braxi\_mod::main();

	sr\commands\_defrag::main();
	sr\commands\_bomberman::main();
	sr\commands\_kz::main();
	sr\commands\_race::main();
	sr\commands\_portal::main();
	sr\game\_match::main();
	sr\game\_hitmarker::main();
	sr\game\_killcam::main();
	sr\game\minigames\_kz::initKz();
	sr\game\minigames\_race::initRace();
	sr\game\minigames\_bomberman::initBomberman();
	sr\player\customize\_main::initCustomize();
	sr\libs\portal\_main::initPortal();

	speedrun\commands\_speedrun::main();
	speedrun\game\_bot::main();
	speedrun\game\_demo::main();
	speedrun\game\_menus::main();
	speedrun\game\_scoreboard::main();
	speedrun\game\_leaderboards::initLeaderboards();
	speedrun\game\_pbs::initPBs();
	speedrun\player\run\_main::main();
	speedrun\player\huds\_speedrun::main();
	speedrun\player\huds\_demo::main();
}

precache()
{
	precacheItem("shop_mp");
	precacheItem("vip_mp");
	precacheItem("knife_mp");
	precacheItem("dog_mp");
	precacheItem("shovel_mp");
	precacheItem("rtd_mp");
	precacheItem("tomahawk_mp");
	precacheItem("fortnite_mp");
}
