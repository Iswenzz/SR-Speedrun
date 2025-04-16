//rooney made 


main()
{
 maps\mp\_load::main();
 
 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"] = "desert";
  

	setdvar("bg_fallDamageMinHeight" ,"9998");
	
	setdvar( "r_specularcolorscale", "1" );

	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_map::createSpawn((105, 6, 76), 360);

	
	thread startdoor();
	//thread trap1();
	//thread trap2();
	//thread trap3();
	//thread trap4();
	//thread snip();
	//thread knife();
	//thread germans();
	
}


startdoor()
{
door = getent("startdoor","targetname");


door delete();
}


trap1()
{
	platform = getent("trap1","targetname");
	trig = getent("trig_trap1","targetname");
	trig sethintstring("^0[^2F^0] ^7to remove outer plats");
	trig waittill ("trigger",player);
	player braxi\_rank::giveRankXP("", 250);
	platform delete();
	trig delete();
}


trap2()
{
	platform = getent("trap2","targetname");
	trig1 = getent("trig_trap2","targetname");
	trig1 sethintstring("^0[^2F^0] ^7to move two plats");
	trig1 waittill ("trigger",player);
	trig1 delete();
	player braxi\_rank::giveRankXP("", 250);
	for(;;)
	{
	platform moveZ (-128, 1);
	wait 3;
	platform moveZ (128, 1);
	wait 3;
	}
	
	
}


trap3()
{
	platform = getent("trap3","targetname");
	trig = getent("trig_trap3","targetname");
	trig sethintstring("^0[^2F^0] ^7to remove helper");
	trig waittill ("trigger",player);
	player braxi\_rank::giveRankXP("", 250);
	platform delete();
	trig delete();
}


trap4()
{
	platform = getent("trap4","targetname");
	trig = getent("trig_trap4","targetname");
	trig sethintstring("^0[^2F^0] ^7to remove helper");
	trig waittill ("trigger",player);
	player braxi\_rank::giveRankXP("", 250);
	platform delete();
	trig delete();
}

snip()
{
	level.trig_s = getent("trig_s","targetname");
	
	jumporigin = getent("snip_j","targetname");
	actiorigin = getent("snip_a","targetname");
	level.trig_s sethintstring ("^2F");
	
	level.trig_s waittill("trigger", player);
	level.trig_k delete();
	
	 iPrintLnBold("^5 " + player.name + " ^7Entered The ^4Sniper ^7Room^2!");
	  player.health = player.maxhealth;
        level.activ.health = level.activ.maxhealth;

        player takeAllWeapons();
        level.activ takeAllWeapons();

        player giveWeapon("m40a3_mp");
        player giveWeapon("remington700_mp");
        player giveMaxAmmo("remington700_mp");
        player giveMaxAmmo("m40a3_mp");
        level.activ giveWeapon("m40a3_mp");
        level.activ giveWeapon("remington700_mp");
        level.activ giveMaxAmmo("remington700_mp");
        level.activ giveMaxAmmo("m40a3_mp");

        player switchToWeapon("m40a3_mp");
        level.activ switchToWeapon("m40a3_mp");
		player setOrigin(jumporigin.origin);
        player setPlayerAngles(jumporigin.angles);

        level.activ setOrigin(actiorigin.origin);
        level.activ setPlayerAngles(actiorigin.angles);
		

		player waittill( "death" );
	level.PlayerInRoom = false;
}



knife()
{
	level.trig_k = getent ("trig_k", "targetname");
	jumporigin = getent ("knife_jumper","targetname");
	actiorigin = getent ("knife_activator","targetname");
	level.trig_k sethintstring ("^2F");
	level.trig_k waittill ("trigger", player);
	level.trig_s delete();
	
	iprintlnbold("^5 " + player.name + " ^7 Entered The ^4 Sniper ^7 Room^2!");
	player.health = player.maxhealth;
	level.activ.health = level.activ.maxhealth;
	
	player takeAllWeapons();
	level.activ takeAllWeapons();
	player giveweapon ("knife_mp");
	level.activ giveweapon("knife_mp");
	 player setOrigin(jumporigin.origin);
        player setPlayerAngles(jumporigin.angles);

        level.activ setOrigin(actiorigin.origin);
        level.activ setPlayerAngles(actiorigin.angles);
		
		player waittill( "death" );
	level.PlayerInRoom = false;
}

germans()
{
	germanvip = getent("trig_germans","targetname");
	germanvip waittill("trigger", player);
	if (player getGuid() == "32d8c6563fe314cb61567c5acbf9c0bc" || player getGuid() == "ecfeb0e6fda3ac7a2319275038e73922")
    {	player braxi\_rank::giveRankXP("", 50000);
	} else {
	player giveweapon("knife_mp");
	
}
}