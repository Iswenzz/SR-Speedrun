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
    thread sr\api\_map::createSpawn((11936, -2629, 371), 270);


    thread move1();
}


move1()//Move to next area acti
{
   trig = getent("trigger_move1", "targetname");
   tele1 = getent ("origin_move1", "targetname");

   for (;;)
    {
     trig waittill ("trigger", player);
	   player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
    }
}