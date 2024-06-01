#include braxi\_common;
main()
{
    maps\mp\_load::main();

    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";
	
	setDvar( "bg_fallDamageMaxHeight", 99999 );
	setDvar( "bg_fallDamageMinHeight", 99998 );

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_map::createSpawn((19780, -30228, -20178), 90);
	
	thread startDoor();
    thread teddy();
	thread slenderman();
	thread gateopen();
	thread trap7();
	thread trap8();
	thread hangman();
	thread door1();
	thread door2();
	thread inside();

}

startDoor() 
{
	door = getEnt( "startdoor", "targetname" );
	
	
	door delete();
}


slenderman()
{
	trap3_slender = getEntArray("trap3_slender","targetname");
	trap3_hurt = getent("trap3_hurt","targetname");

    trap3_hurt delete();
  
}


teddy()
{
	car = getent("pickup_truck","targetname");
	car_hurt = getent("car_hurt","targetname");

	car_hurt delete();


}

gateopen()
{
	rightdoor = getEntarray("rightdoor","targetname");
	leftdoor = getEntarray("leftdoor","targetname");
	trig = getent("gate_open","targetname");

	leftdoor[0] delete();
    rightdoor[0] delete();
	leftdoor[1] delete();
	rightdoor[1] delete();
	leftdoor[2] delete();
	rightdoor[2] delete();
}

trap7()
{
	trap7 = getent("trap7","targetname");
	sound = getent("sound","targetname");
	trig = getent("trap7_trig","targetname");
	trap7_hurt = getent("trap7_hurt","targetname");

    trap7_hurt delete();

}

trap8()
{
	hurt1 = getEntArray("hurt1","targetname");
	fire = getEntArray("fire","targetname");
	trig = getent("trap8_trig","targetname");

    for( i=0; i < hurt1.size; i++ ) 
	{
		hurt1[i] delete();
	}
	

}

hangman()
{
	trig =  getEnt( "hangman_trig", "targetname" );
	o_caught = getEnt( "o_witchVictim", "targetname" );
	creepy_chica = getEnt( "woman", "targetname" );
	nosight_creepy_chica = getEnt( "trig_woman", "targetname" );
	soldier = getEnt( "hanged_soldier", "targetname" );
	

	nosight_creepy_chica delete();
	
}

door1()
{
	door1 = getent("door1","targetname");
	doorpass = getent("doorpass","targetname");
   

	for(;;)
	{
		door1 setHintString( "^2Press F to continue" );
		door1 waittill ("trigger", player);

		player SetPlayerAngles( doorpass.angles );
		player setOrigin( doorpass.origin );
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
	

}

door2()
{
	door2 = getent("door2","targetname");
	doorpass = getent("doorpass","targetname");
   

	for(;;)
	{   
		door2 setHintString( "^2Press F to continue" );
		door2 waittill ("trigger", player);

		player SetPlayerAngles( doorpass.angles );
		player setOrigin( doorpass.origin );
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
	

}


inside()
{
	enterdoor = getEnt( "enterdoor","targetname" );
	inside = getEnt( "inside","targetname" );
	
	
    for(;;)
	{
		enterdoor setHintString( "^2Press F to continue" );
		enterdoor waittill ( "trigger", player );
		
		player setPlayerAngles( inside.angles );
		player setOrigin( inside.origin );
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}