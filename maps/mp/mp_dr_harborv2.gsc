main()
{
 maps\mp\_load::main();


 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"] = "desert";

	setDvar("bg_fallDamageMinHeight", "9997");
	setDvar("bg_fallDamageMaxHeight", "9999");


	setdvar( "r_specularcolorscale", "1" );

	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");

	thread sr\api\_map::createSpawn((31, 143, 76), 90);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createEndMap((29.3373, 5226.22, 17.125), 170,120, "normal_0");

	level.secret_music_active = 0;


	//thread messages();
	thread startdoor();
    thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap5();
	//thread old();
	//thread sniper();
 	//thread secret_music();
}

secret_music()
{
	secret_music_trigger = getent("secret_trig","targetname");

	secret_music_trigger waittill("trigger", player);
	level.secret_music_active = 1;
	AmbientStop();
	wait 0.1;
	ambientPlay("secret_music");
}

music_random()
{
	if(level.secret_music_active == 1)
		return;

	iprintln( " ^2Random music by Speedex" );

	switch(randomint(4))
	{
		case 0:
			ambientPlay("song1");
			wait 2;
			iprintln( " ^3Star Driver - Eyes on you" );
			break;
		case 1:
			ambientPlay("song5");
			wait 2;
			iprintln( " ^3Ian van Dahl - Reasons" );
			break;
		case 2:
			ambientPlay("song3");
			wait 2;
			iprintln( " ^3Shawn Mendes - Stitches (SeeB Remix)" );
			break;
		case 3:
			ambientPlay("song4");
			wait 2;
			iprintln( " ^2Armin van Buuren - Waiting for the Night" );
			break;
		case 4:
			ambientPlay("song3");
			wait 2;
			iprintln( " ^2Dynoro & Gigi D’Agostino - In My Mind" );
			break;
	}
}

messages()
{
	wait 10;
	iprintlnBold("^1Welcome to the harbor");
	wait 1;
}

startdoor()
{
	lootje = getent("startdoor","targetname");

	lootje delete();
}



trap1()
{
      platform = getent("trap1", "targetname");
	  trig = getent("trig_trap1", "targetname");
	  trig SetHintString("^1Remove platforms");
	  trig waittill("trigger");


}



trap2()
{
      platform = getent("trap2", "targetname");
	  trig = getent("trig_trap2", "targetname");
	  trig SetHintString("^2Cut the floor");
	  trig waittill("trigger");

}



trap3()
{
      platform = getent("trap3", "targetname");
	  trig = getent("trig_trap3", "targetname");
	  trig SetHintString("^3Make blocks fall");
	  trig waittill("trigger");

}



trap4()
{
      platform = getent("trap4", "targetname");
	  trig = getent("trig_trap4", "targetname");
	  trig SetHintString("^4Remove platforms v2 :D");
	  trig waittill("trigger");


}



trap5()
{
      platform = getent("trap5", "targetname");
	  trig = getent("trig_trap5", "targetname");
	  trig SetHintString("^5Make em  go da hard way ");
	  trig waittill("trigger");


}

old()
{
          level.old_trigger = getent ( "oldroom", "targetname" );
		  level.sniper_trigger = getEnt("trig_sniper", "targetname");
		  door = getent ( "actidoor", "targetname" );
		  level.old_trigger waittill ( "trigger", player );
		  {
			  level.old_trigger delete();
			  level.sniper_trigger delete();

			  iprintlnbold( "^8" + player.name + "^3 Kill the acti." );
			  door moveZ (-200, 2);
			  wait 1;
		  }
}



sniper()
{
     level.sniper_trigger = getEnt("trig_sniper","targetname");
     level.old_trigger = getEnt("oldroom","targetname");
     level.teleactorigin = getEnt("sniper_activator", "targetname");
     telejumporigin = getEnt("sniper_jumper", "targetname");

     while(1)
     {
	     level.sniper_trigger waittill( "trigger", player );

	     if( !isDefined( level.sniper_trigger ) )
	     return;
	     if(level.firstenter==true)
	     {
	     level.old_trigger delete();
	     level.firstenter=false;
	     }
	     wait 0;

	     player SetOrigin(telejumporigin.origin);
	     player setplayerangles(telejumporigin.angles);
	     player TakeAllWeapons();
	     player GiveWeapon("m40a3_mp");
	     player GiveWeapon( "remington700_mp" );
	     player GiveMaxAmmo("m40a3_mp");
	     player GiveMaxAmmo( "remington700_mp" );
	     wait 0;
	     player SwitchToWeapon("m40a3_mp");
	     wait 0;
	     level.activ SetOrigin (level.teleactorigin.origin);
	     level.activ setplayerangles (level.teleactorigin.angles);
	     level.activ TakeAllWeapons();
	     level.activ GiveWeapon( "m40a3_mp" );
	     level.activ GiveWeapon( "remington700_mp" );
	     level.activ GiveMaxAmmo("m40a3_mp");
	     level.activ GiveMaxAmmo( "remington700_mp" );
	     wait 0;
	     level.activ SwitchToWeapon("m40a3_mp");
	     iprintlnbold( "^8" + player.name + "^4 has entered the Sniper room^8!" );
	     wait 0;
	     player switchToWeapon( "m40a3_mp" );
	     level.activ SwitchToWeapon( "m40a3_mp" );


	     player waittill( "death" );
	     level.PlayerInRoom = false;
    }
}

