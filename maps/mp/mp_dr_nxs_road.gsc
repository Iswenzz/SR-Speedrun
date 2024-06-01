main()
{
    maps\mp\_load::main();
         
    game["allies"] = "sas";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "woodland";
    game["axis_soldiertype"] = "woodland";

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_map::createSpawn((21, -94, -180), 0);


	thread trap1();
	thread trap4();
	thread trap5();
	
}

trap1()
{
	trap1_a_dmg = getent("trap1_a_dmg" ,"targetname");
	trap1_b_dmg = getent("trap1_b_dmg" ,"targetname");

	trap1_a_dmg delete();
	trap1_b_dmg delete();


}

trap4()
{
	trap4_dmg = getent("trap4_dmg", "targetname");
	trap4_a = getent("trap4_a", "targetname");
	trap4_b = getent("trap4_b", "targetname");

	trap4_dmg delete();
	trap4_a delete();
	trap4_b delete();
	
}

trap5()
{
	trap5 = getent("trap5", "targetname");
	trig = getent("trap5_trig", "targetname");

	trap5 delete();
	
}
	