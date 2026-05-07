main()
{

	maps\mp\_load::main();
	
	thread startdoor();
	//thread move();
	//thread troll();
	thread secrettele();
	//thread spin();
	//thread block();
	//thread balk();
	thread secretback();
	//thread teleportacti();
	//thread teleportacti2();
	//thread fnrplogopusher();
	//thread round();
	//thread spike();
	//thread teleportacti3();
	//thread straferoll();
	//thread destroyer();
	//thread teleportacti4();
	//thread end();
	//thread knife();
	//thread sniper();
	//thread old();
	//thread jump();
	//thread lol();

	thread sr\api\_map::createSpawn((170,537,2908), 0);
	thread sr\api\_speedrun::createNormalWays("Normal Way");
    thread sr\api\_speedrun::createSecretWays("^3Secret Way");
	
	addTriggerToList("trig_troll");
	addTriggerToList("trig_spin");
	addTriggerToList("trig_block");
	addTriggerToList("trig_balk");
	addTriggerToList("trig_fnrp");
	addTriggerToList("trig_straferoll");
	addTriggerToList("trig_destroyer");
	addTriggerToList("trig_spike");
	addTriggerToList("trig_round");

}

startdoor()
{

    trig = getEnt( "startdoor", "targetname" );
    brush = getEnt( "door", "targetname" );

	brush delete();

}

move()
{
    trig = getEnt( "trig_move", "targetname" );
	activatorbutton1 = getEnt( "activatorbutton1", "targetname" );
    brush1 = getEnt( "move1", "targetname" );
	brush2 = getEnt( "move2", "targetname" );
	brush3 = getEnt( "move3", "targetname" );
	brush4 = getEnt( "move4", "targetname" );
	brush5 = getEnt( "move5", "targetname" );
	
    trig waittill( "trigger");
	activatorbutton1 moveZ(-48,5);
	trig setHintstring("^5T^7rap ^5A^7ctivated.");
	
	{
	
	brush1 moveY(-992,5);
	brush4 moveY(-992,7);
	wait 2;
	brush3 moveY(-992,9);
	brush5 moveY(-992,4);
	wait 2;
	brush2 moveY(-992,6);
	wait 4;
	
	brush1 delete();
	brush2 delete();
	brush3 delete();
	brush4 delete();
	brush5 delete();
	//iprinln("^5M^7ove ^5d^7one.");
	}

}

troll() // No idea what name is possible with this trap lol.
{
	
	trig = getEnt( "trig_troll", "targetname" );
	activatorbutton2 = getEnt( "activatorbutton2", "targetname" );
    brush1 = getEnt( "troll1", "targetname" );
	brush2 = getEnt( "troll2", "targetname" );
	brush3 = getEnt( "troll3", "targetname" );
	brush4 = getEnt( "troll4", "targetname" );
	brush5 = getEnt( "troll5", "targetname" );
	
    trig waittill( "trigger");
	activatorbutton2 moveZ(-48,5);
	trig setHintstring("^5T^7rap ^5A^7ctivated.");
	
	{
	brush5 moveZ(230,3);
	wait 1;
	brush4 rotatePitch(720,5);
	wait 2;
	brush1 delete();
	brush3 delete();
	wait 1;
	//iprinln("^5M^7ove ^5d^7one.");
	}
	
}
secrettele()
{
	trig = getent("secrettele", "targetname");
	spawn = getent("secretspot", "targetname");
	

	for(;;)
	{
		trig waittill("trigger", player);
		player thread sr\api\_speedrun::changeWay("secret_0"); 

		player SetOrigin(spawn.origin);
		player SetPlayerAngles(spawn.angles);
		player freeze_on_tps(0.1);
	}
}

freeze_on_tps(time) {
	self freezecontrols(true);
	self thread freeze_on_tps_repeat(time);
}
freeze_on_tps_repeat(time) {
	wait time;
	self freezecontrols(false);
}

spin()
{
	
	trig = getEnt( "trig_spin", "targetname" );
	activatorbutton3 = getEnt( "activatorbutton3", "targetname" );
    brush1 = getEnt( "spin", "targetname" );
	brush2 = getEnt( "spin2", "targetname" );

	
    trig waittill( "trigger");
	activatorbutton3 moveZ(-48,5);
	trig setHintstring("^5T^7rap ^5A^7ctivated.");
	
	{
brush1 rotateRoll(360,4);
wait 1;
brush2 rotateRoll(360,2);
wait 5;
brush1 rotateRoll(720,2);
wait 1;
brush2 rotateRoll(720,4);
//iprinln("^5M^7ove ^5d^7one.");
	}
	
}
block()
{
    trig = getEnt( "trig_block", "targetname" );
	activatorbutton4 = getEnt( "activatorbutton4", "targetname" );
    brush1 = getEnt( "block1", "targetname" );
	brush2 = getEnt( "block2", "targetname" );
	brush3 = getEnt( "block3", "targetname" );
	brush4 = getEnt( "block4", "targetname" );
	brush5 = getEnt( "block5", "targetname" );
	
    trig waittill( "trigger");
	activatorbutton4 moveZ(-48,5);
	trig setHintstring("^5T^7rap ^5A^7ctivated.");
	
	{
	
	//brush1 notSolid();
	brush4 delete();
	wait 0.5;
	brush3 moveZ(200,6);
	wait 5; 
	brush3 delete();
	brush5 notSolid();
	wait 2;
	brush2 delete();
	wait 1;
	//iprinln("^5M^7ove ^5d^7one.");
	
	}

}
balk()
{
    trig = getEnt( "trig_balk", "targetname" );
	activatorbutton5 = getEnt( "activatorbutton5", "targetname" );
    brush1 = getEnt( "balk", "targetname" );
	
    trig waittill( "trigger");
	activatorbutton5 moveZ(-48,5);
	trig setHintstring("^5T^7rap ^5A^7ctivated.");
	{
	brush1 rotateRoll(360,1);
	wait 5;
	brush1 rotateRoll(720,7);
	wait 1;
	//iprinln("^5M^7ove ^5d^7one.");
	}
	
}
secretback()
{
	trig = getent("secretback", "targetname");
	spawn = getent("spotback", "targetname");
	

	for(;;)
	{
		trig waittill("trigger", player);
		player thread sr\api\_speedrun::finishWay("secret_0");
	}
}
teleportacti()
{
	trig = getent("acti1", "targetname");
	spawn = getent("spot1", "targetname");
	

	while (1)
	{
		trig waittill("trigger", player);
		player SetPlayerAngles ( spawn.angles );
		player SetOrigin ( spawn.origin );
		wait (0.05);
		player iPrintLnBold("^5T^7eleported.");
	}
}
teleportacti2()
{
	trig = getent("acti2", "targetname");
	spawn = getent("spot2", "targetname");
	

	while (1)
	{
		trig waittill("trigger", player);
		player SetPlayerAngles ( spawn.angles );
		player SetOrigin ( spawn.origin );
		wait (0.05);
		player iPrintLnBold("^5T^7eleported.");
	}
}
fnrplogopusher()
{
    trig = getEnt( "trig_fnrp", "targetname" );
	activatorbutton6 = getEnt( "activatorbutton6", "targetname" );
    brush1 = getEnt( "fnrp", "targetname" );
	brush2 = getEnt( "fnrp2", "targetname" );
	
    trig waittill( "trigger");
	activatorbutton6 moveZ(-48,5);
	trig setHintstring("^5T^7rap ^5A^7ctivated.");
	{
	
	brush1 moveY(-320,4);
	wait 0.5;
	brush2 moveY(320,1);
	wait 2;
	brush1 moveY(320,2);
	brush2 moveY(-320,5);
	wait 10;
	brush1 moveY(-320,3);
	brush2 moveY(320,3);
	// Move done.
	}
}
round()
{
    trig = getEnt( "trig_round", "targetname" );
	activatorbutton7 = getEnt( "activatorbutton7", "targetname" );
    brush = getEnt( "round", "targetname" );
	
    trig waittill( "trigger");
	activatorbutton7 moveZ(-48,5);
	trig setHintstring("^5T^7rap ^5A^7ctivated.");
	while(1)
	{
	
	brush rotateYaw(360,2);
	wait 2;
	brush rotateYaw(720,6);
	// Move Done.
	}
}
spike()

{

    trig = getEnt( "trig_spike", "targetname" );
    brush = getEnt( "spike", "targetname" );
	activatorbutton8 = getEnt( "activatorbutton8", "targetname" );
	hurt = getEnt ("spike_hurt", "targetname");

	hurt enablelinkto(); 
	hurt linkto (brush); 
	
    trig waittill( "trigger");
	activatorbutton8 moveZ(-48,5);
	trig setHintstring("^5T^7rap ^5A^7ctivated.");
	iPrintLnBold("FNRP ^5FTW");

	{ 
	brush moveZ (-408,4);	
	wait 5;
	brush moveZ (408,4);
	}
}
teleportacti3()
{
	trig = getent("acti3", "targetname");
	spawn = getent("spot3", "targetname");
	

	while (1)
	{
		trig waittill("trigger", player);
		player SetPlayerAngles ( spawn.angles );
		player SetOrigin ( spawn.origin );
		wait (0.05);
		player iPrintLnBold("^5T^7eleported.");
	}
}
straferoll()
{
    trig = getEnt( "trig_straferoll", "targetname" );
	activatorbutton9 = getEnt( "activatorbutton9", "targetname" );
    brush = getEnt( "straferoll", "targetname" );
	
    trig waittill( "trigger");
	activatorbutton9 moveZ(-48,5);
	trig setHintstring("^5T^7rap ^5A^7ctivated.");
	{
	brush rotatePitch(360,5);
	// Move Done.
	}
}
destroyer()
{
    trig = getEnt( "trig_destroyer", "targetname" );
	activatorbutton10 = getEnt( "activatorbutton10", "targetname" );
    brush = getEnt( "destroyer", "targetname" );
	
    trig waittill( "trigger");
	activatorbutton10 moveZ(-48,5);
	trig setHintstring("^5T^7rap ^5A^7ctivated.");
	{
	brush moveZ(-232,4);
	wait 3;
	brush moveZ(232,4);
	// Move Done.
	}
}
teleportacti4()
{
	trig = getent("acti4", "targetname");
	spawn = getent("spot4", "targetname");
	

	while (1)
	{
		trig waittill("trigger", player);
		player SetPlayerAngles ( spawn.angles );
		player SetOrigin ( spawn.origin );
		wait (0.05);
		player iPrintLnBold("^5T^7eleported.");
	}
}
end()
{
    trig = getent ("end", "targetname");
    trig waittill ("trigger", player);
    trig delete();
	{
    iPrintLnBold("^1"+ player.name + " " + "^3" + "has reached the end ^5first");
	iPrintLnBold("^5fnrp-servers.com ^3<--- JOIN NOW");
	}
}
knife() // Bugs in first free round.
{
    level.knife_trig = getEnt( "knife_trig", "targetname");
    jump = getEnt( "jumper_knife", "targetname" );
    acti = getEnt( "acti_knife", "targetname" );
    
    while(1)
    {
        level.knife_trig waittill( "trigger", player );
        if( !isDefined( level.knife_trig ) )
            return;
        
        level.sniper_trig delete();
        level.old_trig delete();
		level.jump_trig delete();
		
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "tomahawk_mp" ); //jumper weapon        
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "tomahawk_mp" );        
        wait 0.05;
        player switchToWeapon( "tomahawk_mp" ); //activator weapon
        level.activ SwitchToWeapon( "tomahawk_mp" );
        iPrintlnBold( " ^6" + player.name + " ^5 HAS CHOSEN ^7KNIFE^1!" );     //change to what you want it to be
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
    }
}
old()
{
    level.old_trig = getEnt( "oldtele", "targetname");
    jump = getEnt( "jumper_old", "targetname" );
    acti = getEnt( "acti_old", "targetname" );
    
    while(1)
    {
        level.old_trig waittill( "trigger", player );
        if( !isDefined( level.old_trig ) )
            return;
        
        level.sniper_trig delete();
		level.jump_trig delete();

        level.knife_trig delete();
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );   
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        wait 0.05;
        iPrintlnBold( " ^6" + player.name + " ^5 HAS CHOSEN THE OLD WAY^1!" );     //change to what you want it to be
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
    }
}
sniper()
{
    level.sniper_trig = getEnt( "sniper_trig", "targetname");
    jump = getEnt( "jumper_sniper", "targetname" );
    acti = getEnt( "acti_sniper", "targetname" );
    
    while(1)
    {
        level.sniper_trig waittill( "trigger", player );
        if( !isDefined( level.sniper_trig ) )
            return;
        
        level.old_trig delete();
        level.jump_trig delete();

        level.knife_trig delete();
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "m40a3_mp" ); //jumper weapon 		
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "m40a3_mp" );        
        wait 0.05;
        player switchToWeapon( "m40a3_mp" ); //activator weapon
        level.activ SwitchToWeapon( "m40a3_mp" );
        iPrintlnBold( " ^6" + player.name + " ^5 HAS CHOSEN SNIPAH^1!" );     //change to what you want it to be
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
    }
}
jump()
{
    level.jump_trig = getEnt( "jump_trig", "targetname");
    jump = getEnt( "jumper_jump", "targetname" );
    acti = getEnt( "acti_jump", "targetname" );
    
    while(1)
    {
        level.jump_trig waittill( "trigger", player );
        if( !isDefined( level.jump_trig ) )
            return;
        
        level.old_trig delete();
		level.sniper_trig delete();

        level.knife_trig delete();
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "tomahawk_mp" ); //jumper weapon 		
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "tomahawk_mp" );        
        wait 0.05;
        player switchToWeapon( "tomahawk_mp" ); //activator weapon
        level.activ SwitchToWeapon( "tomahawk_mp" );
        iPrintlnBold( " ^6" + player.name + " ^5 HAS CHOSEN JUMPZOR^1!" );     //change to what you want it to be
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
    }
}
addTriggerToList(name)
{
	if(!isDefined(level.trapTriggers))
		level.trapTriggers = [];
		
	level.trapTriggers[level.trapTriggers.size] = getEnt(name,"targetname");
}
lol()
{
	trig = getEnt("lol","targetname");
    trig waittill( "trigger", player);
	trig setHintstring("Trigger already used... ");
	{
	player braxi\_rank::giveRankXP("", 5);
	player iPrintLnBold("Nice! Good jobbbb");
    iPrintlnBold( "LOL! ^5" + player.name + " ^3 FOUND THE SECRET BUTTON!" );
	}
}
