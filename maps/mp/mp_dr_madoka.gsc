main()
{
	maps\mp\_load::main();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_map::createSpawn((-5223, -1283, 2236), 360);
	
    thread disableHurt();
    thread sr_tp();
	thread trap3();


}

disableHurt()
{
    triggers = getEntArray("trigger_hurt", "classname");
    for (i = 0; i < triggers.size; i++)
        triggers[i] delete();
}

sr_tp()
{
	trig = spawn("trigger_radius",(9619.96, -18275.9, 16.125), 0, 1815, 1700);
	trig.radius = 1815;

    ori = spawn("script_origin",(-5223, -1283, 2236));
	ori.angles = (0,360,0);

	thread sr\api\_map::createTriggerFx(trig, "blue");

	for(;;)
	{
		trig waittill("trigger",player);

		player SetOrigin(ori.origin);
		player SetPlayerAngles(ori.angles);
        player FreezeControls(1);
        player IprintLnBold( "^1Hahaha,you wanted to cut didn't you? :P" );
        wait 5;
        player Suicide();
	}
}

trap3()
{
	trappact3 = getEnt("trapact3","targetname");

	trappact3 rotateYaw (90,0.1);
	
}
