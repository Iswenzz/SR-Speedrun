main()//Made by Phill580
{
trigger = spawn( "trigger_radius", (553, -611, 92), 0, 300, 300 );
trigger.targetname = "endmap_trig";
trigger.radius = 300;
          maps\mp\_load::main();

          PreCacheItem("brick_blaster_mp");
         
         // ambientPlay("ambient_wtf");

         thread way_connect();
         
           //thread crush();
          // thread fan();
          // thread squares();
          // thread impossible();
          // thread trap5();
          // thread Tunnel();
          // thread drawbridge_open ();
          // thread trap7();          
         //  thread Gladiator();
         //  thread findphill();

	//thread WatchSniper();
	//thread watchKnife();
	//thread addTestClients();


}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    sr\api\_speedrun::createNormalWays("Normal Way;");
	
    for(;;)
    {
        level waittill( "connected", player );

    }
}
////////////////////////////////////////////////////////////////////////////////////////////////

addTestClients()
{
	setDvar("scr_testclients", "");
	wait 1;
	for(;;)
	{
		if(getdvarInt("scr_testclients") > 0)
			break;
		wait 1;
	}
	testclients = getdvarInt("scr_testclients");
	setDvar( "scr_testclients", 0 );
	for(i=0;i<testclients;i++)
	{
		ent[i] = addtestclient();

		if (!isdefined(ent[i]))
		{
			println("Could not add test client");
			wait 1;
			continue;
		}
		ent[i].pers["isBot"] = true;
		ent[i] thread TestClient("autoassign");
	}
	thread addTestClients();
}

TestClient(team)
{
	self endon( "disconnect" );

	while(!isdefined(self.pers["team"]))
		wait .05;
		
	self notify("menuresponse", game["menu_team"], team);
	wait 0.5;
}

WatchSniper()
{
	level.snip_trig = getEnt( "trigger_sniper", "targetname");
	jump = getEnt( "sniper_jumper", "targetname" );
	acti = getEnt( "sniper_activator", "targetname" );
	
	while( 1 )
	{
		level.snip_trig waittill( "trigger", player );
		if( !isDefined( level.snip_trig ) )
			return;
		
		level.knife_trig delete();
		player SetPlayerAngles( jump.angles );
		player setOrigin( jump.origin );
		player TakeAllWeapons();
		player GiveWEapon( "m40a3_mp" );
		player giveMaxAmmo( "m40a3_mp" );
		level.activ setPlayerangles( acti.angles );
		level.activ setOrigin( acti.origin );
		level.activ TakeAllWeapons();
		level.activ GiveWeapon( "m40a3_mp" );
		level.activ GiveMaxAmmo( "m40a3_mp" );
		wait 0.05;
		player switchToWeapon( "m40a3_mp" );
		level.activ SwitchToWeapon( "m40a3_mp" );
		iPrintlnBold( "^1>> ^2" + player.name + " has chosen sniper room!" );		//change it as you wish
		while( isAlive( player ) && isDefined( player ) )
			wait 1;
	}
}

WatchKnife()
{
	level.knife_trig = getEnt( "trigger_knife", "targetname");
	jump = getEnt( "knife_jumper", "targetname" );
	acti = getEnt( "knife_activator", "targetname" );
	
	while( 1 )
	{
		level.knife_trig waittill( "trigger", player );
		if( !isDefined( level.knife_trig ) )
			return;
		
		level.snip_trig delete();
		player SetPlayerAngles( jump.angles );
		player setOrigin( jump.origin );
		player TakeAllWeapons();
		player GiveWEapon( "knife_mp" );
		player giveMaxAmmo( "knife_mp" );
		level.activ setPlayerangles( acti.angles );
		level.activ setOrigin( acti.origin );
		level.activ TakeAllWeapons();
		level.activ GiveWeapon( "knife_mp" );
		level.activ GiveMaxAmmo( "knife_mp" );
		wait 0.05;
		player switchToWeapon( "knife_mp" );
		level.activ SwitchToWeapon( "knife_mp" );
		iPrintlnBold( "^1>> ^2" + player.name + " has chosen knife room!" );		//change it as you wish no
		while( isAlive( player ) && isDefined( player ) )
			wait 1;
	}
}

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}
crush()
{
           trig = getEnt("trig1","targetname");
           brush1 = getEnt("trap1.1","targetname");
           brush2 = getEnt("trap1.2","targetname");
           hurt1 = getEnt("trap1_hurt","targetname");
           hurt2 = getEnt("trap1_hurt2","targetname");

           hurt1 enablelinkto();
           hurt2 enablelinkto();
           hurt1 linkto(brush1);
           hurt2 linkto(brush2);

           trig waittill("trigger");
           {
              brush1 moveX(240,2);
              brush2 moveX(-240,2);
              wait 2;
              brush1 moveX(-240,2);
              brush2 moveX(240,2);
              wait 2;
            }
             trig waittill("trigger");
             trig delete();
           {
              brush1 moveX(240,2);
              brush2 moveX(-240,2);
              wait 2;
              brush1 moveX(-240,2);
              brush2 moveX(240,2);
              wait 2;
            }
}
fan()
{     
         trig = getEnt("trig2","targetname");
          brush = getEnt("trap2","targetname");
          hurt = getEnt("trap2_hurt","targetname");

          hurt enablelinkto();
          hurt linkto(brush);

          trig waittill("trigger");
          trig delete();

          while(true)
          {
                 brush rotatePitch(360,3);
                 wait 1;
          }
}
squares()
{
                   trig = getEnt( "trig3", "targetname" );
	brushGroup1 = getEntArray( "trap3.1", "targetname" );
	brushGroup2 = getEntArray( "trap3.2", "targetname" );
                   brushGroup3 = getEntArray( "trap3.3", "targetname" );
	brushGroup4 = getEntArray( "trap3.4", "targetname" );

	trig waittill("trigger");
	brushGroup1[randomInt(brushGroup1.size)] delete();

                  trig waittill("trigger");
	brushGroup2[randomInt(brushGroup1.size)] delete();

                  trig waittill("trigger");
	brushGroup3[randomInt(brushGroup1.size)] delete();

                  trig waittill("trigger");
                  trig delete();
	brushGroup4[randomInt(brushGroup1.size)] delete();	
}
impossible()
{
                      trig = GetEnt("trig4","targetname");
                      brush1 = GetEnt("trap4.1","targetname");
                      brush2 = GetEnt("trap4.2","targetname");
                      brush3 = GetEnt("trap4.3","targetname");

                      trig waittill("trigger");
                      trig delete();

                      while(true)
                     {
                              brush1 rotateYaw(360,1);
                              brush2 rotateRoll(-360,3);
                              brush3 rotatePitch(360,3);
                              wait 1;
                     }
}
trap5()
{
            trig = getEnt("trig6","targetname");
            brush = getEnt("trap6","targetname");

            trig waittill("trigger");
            trig delete();
            {
                        brush moveY(144,1);
                        wait 5;
                        brush moveY(-144,1);
            }
}                        
Tunnel()
{
            trig = getEnt("trig5","targetname");
            brush = getEnt("trap5","targetname");
            
            trig waittill("trigger");
            trig delete();

            while(true)
                     {
                              brush rotatePitch(360,4);
                              wait 1;
                     }
}
drawbridge_open() 
{ 
	drawbridge = getent( "drawbridge", "targetname" ); 
	trig = getent( "lower_bridge", "targetname" ); 
 
while(true) 
{ 
	trig waittill ("trigger"); 
	drawbridge rotateto( (-90,0,0),1); 
	drawbridge waittill ("rotatedone"); 
	wait 1; 
	trig waittill ("trigger"); 
	drawbridge rotateto( (0,0,0),1); 
	drawbridge waittill ("rotatedone"); 
	} 
}
trap7()
{
         
          trig = GetEnt("trig7","targetname");
          brush = GetEnt("trap7","targetname");
           hurt = getEnt("hurt_7","targetname");

          hurt enablelinkto();
          hurt linkto(brush);

           trig waittill("trigger",player);
           trig delete();
          
          while(1)
          {
                             brush moveX(-976,3);
                             wait 3;
                             brush moveX(976,3);
                             wait 3;
          }
}
Gladiator()
{
         trig = getEnt("Gladiator","targetname");

         trig waittill("trigger",players);
         trig delete();
          {
           
                  hud_clock = NewHudElem();
	hud_clock.alignX = "center";
	hud_clock.alignY = "middle";
	hud_clock.horzalign = "center";
	hud_clock.vertalign = "middle";
	hud_clock.alpha = 1;
	hud_clock.x = 0;
	hud_clock.y = 0;
	hud_clock.font = "objective";
	hud_clock.fontscale = 3;
	hud_clock.glowalpha = 1;
	hud_clock.glowcolor = (7,5,7);
	hud_clock.label = &"Map Made By Phill580";
                   hud_clock SetPulseFX( 40, 5400, 200 );
                   wait 5;
                   hud_clock = NewHudElem();
	hud_clock.alignX = "center";
	hud_clock.alignY = "middle";
	hud_clock.horzalign = "center";
	hud_clock.vertalign = "middle";
	hud_clock.alpha = 1;
	hud_clock.x = 0;
	hud_clock.y = 0;
	hud_clock.font = "objective";
	hud_clock.fontscale = 3;
	hud_clock.glowalpha = 1;
	hud_clock.glowcolor = (7,5,7);
	hud_clock.label = &"Lossy Helped with Script";
                   hud_clock SetPulseFX( 40, 5400, 200 );
                   wait 5;
                    hud_clock = NewHudElem();
	hud_clock.alignX = "center";
	hud_clock.alignY = "middle";
	hud_clock.horzalign = "center";
	hud_clock.vertalign = "middle";
	hud_clock.alpha = 1;
	hud_clock.x = 0;
	hud_clock.y = 0;
	hud_clock.font = "objective";
	hud_clock.fontscale = 3;
	hud_clock.glowalpha = 1;
	hud_clock.glowcolor = (7,5,7);
	hud_clock.label = &"Phaedrean Helped with Mini Games";
                   hud_clock SetPulseFX( 40, 5400, 200 );
           }
}

findphill()
{
	level waittill( "activator" );
	players = getEntArray( "player", "classname" );
	for(i=0;i<players.size;i++)
	{
		if( GetSubStr( players[i] GetGuid(), 24, 32 ) == "50d109d9" )
		{
			//yay we've found phill! hooray! xD
			players[i] GiveWeapon( "brick_blaster_mp" );
			players[i] iPrintlnBold( "LOL" );
			return;
		}
	}
}
/*
findphill()
{
	wait 10;
	
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
	{
		if( GetSubStr( players[i] GetGuid(), 24, 32 ) == "50d109d9" )
		{
			players[i] iprintLnBold("LOL!");
			players[i] TakeAllWeapons();
			players[i] GiveWeapon("brick_blaster_mp");
			players[i] GiveMaxAmmo("brick_blaster_mp");
			wait 0.05;
			players[i] SwitchToWeapon("brick_blaster_mp");
		}
	}
}*/