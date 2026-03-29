main()
{
    maps\mp\_load::main();
	level.effect1 = LoadFX("smoke/hallway_steam_flood");
	level.effect2 = LoadFX("fire/killing_fire" );
	PreCacheShellShock("frag_grenade_mp");
	PreCacheItem("remington700_mp");
	PreCacheItem("m40a3_mp");
	precacheModel("playermodel_baa_joker");
	precacheModel("playermodel_dnf_duke");

    thread sr\api\_map::createSpawn((-141, 162, 63), 90);
	thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createEndMap((3530.97, 1576.99, -141.875), 100, 70, "normal_0");
}