/* Map by Radon
Xfire: radionactive

Death Run mod by BraX.
Official Death Run Homepage: www.brax-online.pl */

main()
{
    maps\mp\_load::main();
    //maps\mp\mp_dr_finalshuttle_thetraps::main();

    thread sr\api\_map::createSpawn((2042, 2495, 256), 90);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
    thread sr\api\_speedrun::createEndMap((522.794, 2124.68, 321.31), 50,150, "normal_0");

    thread hurt_trigger();
}

hurt_trigger()
{
	hurt = getEnt("killfield","targetname");

	for(;;)
	{
		hurt waittill("trigger",player);

		player suicide();
	}
}