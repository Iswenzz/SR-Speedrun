main()
{
	maps\mp\_load::main();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");

		thread sr\api\_speedrun::createNormalWays("Normal Way;");
		thread sr\api\_map::createSpawn((528, 0, 60), 180);
		thread sr\api\_speedrun::createEndMap((-2485.92, -0.234748, 540.125), 175, 100);
	
		thread startdoor();
		/*thread phelix();
		thread dropblocks();
		thread lift();
		thread spinners();
		thread circlespin();
		thread knockers();
		thread rectanglerotate();
		thread movepad();
		thread movingsquares();
		thread kniferoom();
		thread sniperoom();
		thread floorforknife();
		thread secret();
		thread secretstage1();
		thread secretstage2();
		thread secretstage3();
		thread respawn1();
		thread respawn2();
		thread respawn3();
		thread old();*/
}

startdoor()
{
	door = getent("start_door", "targetname");
	
	door delete();
}

phelix()
{
	row1 = getent("row_1", "targetname");
	row2 = getent("row_2", "targetname");
	row3 = getent("row_3", "targetname");
	row4 = getent("row_4", "targetname");
	row5 = getent("row_5", "targetname");
	row6 = getent("row_6", "targetname");
	row7 = getent("row_7", "targetname");
	row8 = getent("row_8", "targetname");
	row9 = getent("row_9", "targetname");
	row10 = getent("row_10", "targetname");
	row11 = getent("row_11", "targetname");
	row12 = getent("row_12", "targetname");
	row13 = getent("row_13", "targetname");
	row14 = getent("row_14", "targetname");	
	row15 = getent("row_15", "targetname");	
	row16 = getent("row_16", "targetname");	
	row17 = getent("row_17", "targetname");	
	row18 = getent("row_18", "targetname");	
	row19 = getent("row_19", "targetname");	
	row20 = getent("row_20", "targetname");	
	row21 = getent("row_21", "targetname");	
	row22 = getent("row_22", "targetname");	
	row23 = getent("row_23", "targetname");
	wait (14);
	
	while (1)
	{
		row1 rotateYaw(90,1);
		wait (0.2);
		row2 rotateYaw(90,1);
		wait (0.2);	
		row3 rotateYaw(90,1);
		wait (0.2);	
		row4 rotateYaw(90,1);
		wait (0.2);	
		row5 rotateYaw(90,1);
		wait (0.2);	
		row6 rotateYaw(90,1);
		wait (0.2);	
		row7 rotateYaw(90,1);
		wait (0.2);	
		row8 rotateYaw(90,1);
		wait (0.2);
		row9 rotateYaw(90,1);
		wait (0.2);	
		row10 rotateYaw(90,1);
		wait (0.2);	
		row11 rotateYaw(90,1);
		wait (0.2);	
		row12 rotateYaw(90,1);
		wait (0.2);	
		row13 rotateYaw(90,1);
		wait (0.2);	
		row14 rotateYaw(90,1);
		wait (0.2);	
		row15 rotateYaw(90,1);
		wait (0.2);	
		row16 rotateYaw(90,1);
		wait (0.2);	
		row17 rotateYaw(90,1);
		wait (0.2);
		row18 rotateYaw(90,1);
		wait (0.2);
		row19 rotateYaw(90,1);
		wait (0.2);
		row20 rotateYaw(90,1);
		wait (0.2);
		row21 rotateYaw(90,1);
		wait (0.2);
		row22 rotateYaw(90,1);
		wait (0.2);
		row23 rotateYaw(90,1);
		row23 waittill("movedone");
	}
}
	
dropblocks()
{
	block1 = getent("block_1", "targetname");
	block2 = getent("block_2", "targetname");
	block3 = getent("block_3", "targetname");
	block4 = getent("block_4", "targetname");
	trig = getent("block_trigger", "targetname");
	hurt1 = getent("trigger_hurt1", "targetname");
	hurt2 = getent("trigger_hurt2", "targetname");
	hurt3 = getent("trigger_hurt3", "targetname");
	hurt4 = getent("trigger_hurt4", "targetname");

	hurt1 enableLinkTo();
	hurt1 linkTo(block1);
	hurt2 enableLinkTo();
	hurt2 linkTo(block2);
	hurt3 enableLinkTo();
	hurt3 linkTo(block3);
	hurt4 enableLinkTo();
	hurt4 linkTo(block4); 
	
	trig waittill("trigger", player);
	
	block1 movez(-256,0.8);
	wait (0.2);
	block2 movez(-256,0.8);
	wait (0.2);
	block3 movez(-256,0.8);
	wait (0.2);
	block4 movez(-256,0.8);
	block4 waittill("movedone");
	wait (1);
	block1 movez(256,0.8);
	wait (0.2);
	block2 movez(256,0.8);
	wait (0.2);
	block3 movez(256,0.8);
	wait (0.2);
	block4 movez(256,0.8);
	block4 waittill("movedone");
}

lift()
{
	lift = getent("move_lift", "targetname");
	trig = getent("trigger_lift", "targetname");
	trig waittill("trigger", player);
	wait (1);
	lift movez(448,1.5);
}
Spinners()
{
	rectangle1 = getent("rectangle_1", "targetname");
	rectangle2 = getent("rectangle_2", "targetname");
	trig = getent("rectangle_trigger", "targetname");
	trig waittill("trigger", player);
	
	while (1)
	{
		rectangle1 rotateYaw(360,2.8);
		rectangle2 rotateYaw(360,2.8);
		wait(1);
	}
}

circlespin()
{
	circle = getent("circle_spin", "targetname");
	trig = getent("circle_trig", "targetname");
	trig waittill("trigger", player);
	
	while (1)
	{
		circle rotateYaw(360,1);
		wait (1);
	}
}

knockers()
{
	knocker1 = getent("spinner_1", "targetname");
	knocker2 = getent("spinner_2", "targetname");
	knocker3 = getent("spinner_3", "targetname");
	trig = getent("trigger_rotater", "targetname");
	trig waittill("trigger", player);
	
	while (1)
	{
		knocker1 rotateRoll(360,2.2);
		knocker2 rotateRoll(-36,2.2);
		knocker3 rotateRoll(360,2.2);
		wait (1);
	}
}

movepad()
{
	pad = getent("move_pad", "targetname");
	trig = getent("move_trig", "targetname");
	trig waittill("trigger", player);
	wait (1);
	
	while (1)
	{
		pad movex(1272,6.5);
		pad waittill("movedone");
		wait (1);
		pad movex(-1272,6.5);
		pad waittill("movedone");
		wait (1);
	}
}

rectanglerotate()
{
	rectangle = getent("rectangle_rotate", "targetname");
	trig = getent ("trig_rotate", "targetname");
	trig waittill("trigger", player);
	
	while (1)
	{
		rectangle rotatePitch(360,2);
		wait (1);
	}
}

movingsquares()
{
	pad = getent("pad_1", "targetname");
	pads = getent("pads_1", "targetname");
	
	while (1)
	{
		pad movey(960,3.5);
		pads movey(-960,3.5);
		pads waittill("movedone");
		wait (0.5);
		pad movey(-960,3.5);
		pads movey(960,3.5);
		pads waittill("movedone");
		wait (0.5);
	}
}
		
kniferoom()
{
    level.knife_trig = getEnt( "jumper_trig", "targetname");
    jump = getEnt( "jumper_enter_jumproom", "targetname" );
    acti = getEnt( "activator_enter_jumproom", "targetname" );
    
    while(1)
    {
        level.knife_trig waittill( "trigger", player );
        if( !isDefined( level.knife_trig ) )
            return;
        
        level.snip_trig delete();
	level.old_trig delete();
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
        iPrintlnBold( " ^5" + player.name + " ^3 Has entered ^1knife room!" );     //change to what you want it to be
		ambientPlay("sniper");
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
    }
}

sniperoom()
{
    level.snip_trig = getEnt( "sniper_trig", "targetname");
    jump = getEnt( "jumper_enter_sniperoom", "targetname" );
    acti = getEnt( "activator_enter_sniperoom", "targetname" );
    
    while(1)
    {
        level.snip_trig waittill( "trigger", player );
        if( !isDefined( level.snip_trig ) )
            return;
        
        level.knife_trig delete();
	level.old_trig delete();
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "remington700_mp" ); //jumper weapon        
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "remington700_mp" );        
        wait 0.05;
        player switchToWeapon( "remington700_mp" ); //activator weapon
        level.activ SwitchToWeapon( "remington700_mp" );
        iPrintlnBold( " ^5" + player.name + " ^3 Has entered ^1snipe room!" );     //change to what you want it to be
		ambientPlay("sniper");
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
    }
}

old()
{
	level.old_trig = getent ("wood_trigger", "targetname");
	wood = getent ("wood_move", "targetname");
	level.old_trig waittill("trigger", player);
	wood movez (-180,2);
	level.snip_trig delete();
	level.knife_trig delete();
	level.old_trig delete();
}
	
	

floorforknife()
{
	blocks1 = getent("blocks_1", "targetname");
	blocks2 = getent("blocks_2", "targetname");
	level.knife_trig = getEnt( "jumper_trig", "targetname");
	level.knife_trig waittill("trigger", player);
	wait (0.5);
	
	blocks1 movez(8,0.25);
	blocks2 movez(-8,0.25);
	blocks2 waittill("movedone");
	
	while (1)
	{
		blocks1 movez(-16,0.5);
		blocks2 movez(16,0.5);
		blocks2 waittill("movedone");
		wait (0.5);
		blocks1 movez(16,0.5);
		blocks2 movez(-16,0.5);
		blocks2 waittill("movedone");
		wait (0.5);
	}
}

secret()
{
	trigger1 = getent ("trigger1", "targetname");
	trigger2 = getent ("trigger2", "targetname");
	trigger3 = getent ("trigger3", "targetname");
	trigger4 = getent ("trigger4", "targetname");
	wood1 = getent ("wood1", "targetname");
	wood2 = getent ("wood2", "targetname");
	wood3 = getent ("wood3", "targetname");
	wood4 = getent ("wood4", "targetname");

	jump = getent ("jumptele1", "targetname");

	trigger1 EnableLinkTo();
	trigger1 LinkTo( wood1 );
	trigger2 EnableLinkTo();
	trigger2 LinkTo( wood2 );
	trigger3 EnableLinkTo();
	trigger3 LinkTo( wood3 );
	trigger4 EnableLinkTo();
	trigger4 LinkTo( wood4 );
	

	trigger1 waittill ("trigger", player);
	player iPrintLnBold("^51^7/^53");
	wood2 movey (-80, 1);
	wood2 waittill("movedone");
	trigger2 waittill("trigger", player);
	player iPrintLnBold("^52^7/^53");
	wood3 movey (80, 1);
	wood3 waittill("movedone");
	trigger3 waittill("trigger", player);
	player iPrintLnBold("^53^7/^53");
	iPrintLnBold("^7Something has moved?");
	wood4 movey (18, 1);
	wood4 waittill("movedone");
	while (1)
	{
		trigger4 waittill("trigger", player);
		iPrintLnBold(" ^5" + player.name + " ^3 Has entered ^1secret room!");

		player setPlayerAngles( jump.angles );
		player setOrigin( jump.Origin );
		wait (0.05);
		player iPrintLnBold ("^1Stage 1!");
	}
}

secretstage1()
{
	teleport1 = getent("triggerstage1", "targetname");
	jump = getent("jumptele2", "targetname");

	while (1)
	{
		teleport1 waittill("trigger", player);
		
		player setPlayerAngles( jump.angles );
		player setOrigin( jump.origin );
		wait (0.05);
		player iPrintLnBold("^1Stage 2!");
	}
}

secretstage2()
{
	teleport2 = getent("triggerstage2", "targetname");
	jump = getent("jumptele3", "targetname");

	while (1)
	{
		teleport2 waittill("trigger", player);
		
		player setPlayerAngles( jump.angles );
		player setOrigin( jump.origin );
		wait (0.05);
		player iPrintLnBold("^1Stage 3!");
	}
}

secretstage3()
{
	teleport3 = getent("triggerstage3", "targetname");
	jump = getent("jumptele4", "targetname");

	while (1)
	{
		teleport3 waittill("trigger", player);
		
		player setPlayerAngles( jump.angles );
		player setOrigin( jump.origin );
		wait (0.05);
		iPrintLnBold("^1 " + player.name + " has finished the secret! ^3>> Heres a sniper!");
		player GiveWeapon("remington700_mp");
		player SwitchToWeapon("remington700_mp");
	}
}

respawn1()
{
	trigger = getent("respawn1", "targetname");
	jump = getent("jumptele1", "targetname");

	while (1)
	{
		trigger waittill("trigger", player);
		player SetPlayerAngles ( jump.angles );
		player SetOrigin ( jump.origin );
	}
}

respawn2()
{
	trigger = getent("respawn2", "targetname");
	jump = getent("jumptele2", "targetname");

	while (1)
	{
		trigger waittill("trigger", player);
		player SetPlayerAngles ( jump.angles );
		player SetOrigin ( jump.origin );
	}
}

respawn3()
{
	trigger = getent("respawn3", "targetname");
	jump = getent("jumptele3", "targetname");

	while (1)
	{
		trigger waittill("trigger", player);
		player SetPlayerAngles ( jump.angles );
		player SetOrigin ( jump.origin );
	}
}
	
	
	
	