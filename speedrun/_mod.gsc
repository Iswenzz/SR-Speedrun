main()
{
	precache();

	speedrun\game\_dvar::initDvars();

	maps\mp\gametypes\_hud::init();
	maps\mp\gametypes\_hud_message::init();
	maps\mp\gametypes\_damagefeedback::init();
	maps\mp\gametypes\_clientids::init();
	maps\mp\gametypes\_gameobjects::init();
	maps\mp\gametypes\_spawnlogic::init();
	maps\mp\gametypes\_oldschool::deletePickups();
	maps\mp\gametypes\_hud::init();
	maps\mp\gametypes\_quickmessages::init();
	maps\mp\_weapons::init();

	sr\_mod::main();
	braxi\_mod::main();

	sr\game\_rank::initRank();
	sr\game\_hitmarker::main();
	sr\game\_killcam::main();
	sr\game\minigames\_kz::initKz();
	sr\game\minigames\_race::initRace();
	sr\game\minigames\_bomberman::initBomberman();
	sr\player\customize\_main::initCustomize();
	sr\libs\portal\_main::initPortal();
	sr\commands\_defrag::main();
	sr\commands\_bomberman::main();
	sr\commands\_kz::main();
	sr\commands\_race::main();
	sr\commands\_portal::main();

	speedrun\game\_map::main();
	speedrun\game\_demo::main();
	speedrun\game\_match::main();
	speedrun\game\_menus::main();
	speedrun\game\_scoreboard::main();
	speedrun\game\_leaderboards::initLeaderboards();
	speedrun\game\_pbs::initPBs();
	speedrun\player\run\_main::main();
	speedrun\player\huds\_speedrun::main();
	speedrun\player\huds\_demo::main();
	speedrun\commands\_speedrun::main();
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

	precacheShader("time_hud");
	precacheShader("sr_shop");
	precacheShader("sr_dice");
	precacheShader("sr_vip");
	precacheShader("sr_insert");
	precacheShader("speedrunner_logo");

	precacheModel("german_sheperd_dog");
	precacheModel("collision_sphere");
	precacheModel("mil_frame_charge");
	precacheModel("ch_crate64x64");
}
