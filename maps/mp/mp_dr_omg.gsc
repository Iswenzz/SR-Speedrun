main()
{
    maps\mp\_load::main();
    thread sr\api\_map::createSpawn((-43, 1261, -5412), 90);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
    thread sr\api\_speedrun::createEndMap((-31.9794, 950.231, -5223.88),150,120, "normal_0");

//thread mover();
//thread mover2();
thread trap1();
//thread actitele();
thread trap3();
//thread credit();
thread trap2();
thread trap5();
thread trap6();
thread trap7();
thread trap8();
thread mover3();
thread trap9();
thread trap10();
thread trap11();
thread trap12();
//maps\mp\_teleport7::main(); 
//maps\mp\_teleport8::main(); 
//maps\mp\_load::main();
//ambientPlay("bullseye");
//thread weapon_mini();
//PreCacheItem("winchester1200_mp");
	///PreCacheItem("skorpion_mp");
	//PreCacheItem("m4_mp");
	//PreCacheItem("g3_mp");
	//PreCacheItem("ak47_mp");
	//PreCacheItem("rpd_mp");
}

mover()
{
  m1 = getEnt ("move_trap3a", "targetname");
  m2 = getEnt ("move_trap3b", "targetname");
  
  while(1)
    {
	  m1 moveZ (608,1);
	  wait 1;
	  m2 moveZ (-576,1);
	  wait 0.5;
	  m1 moveZ (-608,1);
	  wait 1;
	  m2 moveZ (576,1);
	  wait 0.5;
	}
}


mover2()
{
  m1 = getEnt ("move1", "targetname");
  
  
  while(1)
    {
	  m1 moveX (608,1);
	  wait 0.1;
	  m1 moveX (-608,1);
	  wait 0.1;
	  
	}
}

trap1()
{
          trap = getEnt ("trap1", "targetname");
		  trig = getEnt ("trap1_trig", "targetname");  
		  
		  
  if (!isdefined(trap.speed))
 trap.speed = 4;
if (!isdefined(trap.script_noteworthy))
 trap.script_noteworthy = "x";
 trig waittill ("trigger", player);

	
}

actitele()
{
	entTransporter = getentarray( "down", "targetname" );
	if(isdefined(entTransporter))
		for( i = 0; i < entTransporter.size; i++ )
			entTransporter[i] thread transporter();
}
 
transporter()
{
	for(;;)
	{
		self waittill( "trigger", player );
		entTarget = getEnt( self.target, "targetname" );
		iPrintlnBold( " ^6" + player.name + " ^2Got Teleported xD Get ready for nxt ^1Trap!" );  
		wait 0.1;
		player setOrigin( entTarget.origin );
		player setplayerangles( entTarget.angles );
		wait 0.1;
	}
}


trap3()
{
   trigger = getEnt ("trap1_spiketrig" , "targetname");
   spikes = getEnt ("trap1_spike" ,"targetname" );
   hurt = getEnt ("trap1_spikeshurt" , "targetname");
   trigger waittill ("trigger",player);  

}

credit()
{
wait(10);
thread drawInformation( 800, 0.8, 1, "^1Freek the AWesome" );
wait(4);
thread drawInformation( 800, 0.8, 1, "^2Omg" );
wait(4);
thread drawInformation( 800, 0.8, 1, "^1MW3||Freek " );
wait(4);
thread drawInformation( 800, 0.8, 1, "^1xfire:^2freek80" );
wait(4);
}

drawInformation( start_offset, movetime, mult, text )
{
	start_offset *= mult;
	hud = new_ending_hud( "center", 0.1, start_offset, 60 );
	hud setText( text );
	hud moveOverTime( movetime );
	hud.x = 0;
	wait( movetime );
	wait( 3 );
	hud moveOverTime( movetime );
	hud.x = start_offset * -1;

	wait movetime;
	hud destroy();
}

new_ending_hud( align, fade_in_time, x_off, y_off )
{
	hud = newHudElem();
    hud.foreground = true;
	hud.x = x_off;
	hud.y = y_off;
	hud.alignX = align;
	hud.alignY = "middle";
	hud.horzAlign = align;
	hud.vertAlign = "middle";

 	hud.fontScale = 3;

	hud.color = (0.8, 1.0, 0.8);
	hud.font = "objective";
	hud.glowColor = (0.3, 0.6, 0.3);
	hud.glowAlpha = 1;

	hud.alpha = 0;
	hud fadeovertime( fade_in_time );
	hud.alpha = 1;
	hud.hidewheninmenu = true;
	hud.sort = 10;
	return hud;
}


trap2()
{
                   trig = getEnt("trig4","targetname");
                   brush1 = getEnt("trap4","targetname");
                   brush2 = getEnt("trap4.1","targetname");

                   trig waittill("trigger");
                  
}



trap5()
{
   trigger = getEnt ("trap2_spiketrig" , "targetname");
   spikes = getEnt ("spike3" ,"targetname" );
   hurt = getEnt ("spike_shurt3" , "targetname");
   trigger waittill ("trigger",player);  

}

trap6()
{

brush = getEnt ("trap6_brush", "targetname");
trig = getEnt ("trig6", "targetname");

trig waittill ("trigger", player); 


}

mover3()
{
  m1 = getEnt ("move4", "targetname");

  wait 0.1;
  

	m1 moveZ (100,0.1);

}


trap7()
{
                   trig = getEnt("trig7","targetname");
                   brush = getEnt("trap7","targetname");

                   trig waittill("trigger");
                  
}


trap8()
{
                   trig = getEnt("trig8","targetname");
                   brush = getEnt("trap8","targetname");

                   trig waittill("trigger");
                  
}


	
	trap10()
{

brush = getEnt ("trap10", "targetname");
trig = getEnt ("trig10", "targetname");

trig waittill ("trigger", player); 


}


trap9()
{
          trap = getEnt ("trap9", "targetname");
		  trig = getEnt ("trig9", "targetname");  
		  
		  
  if (!isdefined(trap.speed))
 trap.speed = 4;
if (!isdefined(trap.script_noteworthy))
 trap.script_noteworthy = "x";
 trig waittill ("trigger", player);

	
}

trap11()
{

  trig  = getEnt ("trig11", "targetname");
  push1 = getEnt ("trap11_push1", "targetname");
  push2 = getEnt ("trap11_push2", "targetname");
  push3 = getEnt ("trap11_push3", "targetname");
  
  trig waittill ("trigger", player);


}

trap12()
{
                   trig = getEnt("trig12","targetname");
                   brush = getEnt("spikes4","targetname");
                   hurt = getEnt("spikeshurt11","targetname");

                   hurt enablelinkto();
                   hurt linkto(brush);

                   trig waittill("trigger");
              
}

weapon_mini()

{
    level.weapon_trig = getEnt( "final_trigger", "targetname");
	jumpspawn = getEnt( "final_jumper_teleport", "targetname" );
	actispawn = getEnt( "final_activator_teleport", "targetname");
    
    for(;;)
    {
        level.weapon_trig waittill( "trigger", player );
        if( !isDefined( level.weapon_trig )  || !isDefined(level.activ))
            return;
			
		if(isDefined(level.knife1_trig))
			level.knife1_trig delete();
		if(isDefined(level.knife_trig))	
			level.knife_trig delete();
			if(isDefined(level.old_trig))	
			level.old_trig delete();
		ShowNotifyMessage("^11 ^7VS ^11","^1"+level.activ.name+"^7 against ^1"+player.name);
		level.activ SetPlayerAngles( actispawn.angles );
		level.activ setOrigin( actispawn.origin );
		player SetPlayerAngles( jumpspawn.angles );
		player setOrigin( jumpspawn.origin );
		wep = GetRandomWeapon(1+randomint(3));
		level.activ thread GiveWep(wep);
		player thread GiveWep(wep);
		while(isdefined(player) && player.sessionstate == "playing" && isdefined(level.activ) && level.activ.sessionstate == "playing" )
			wait .1;
	}
}

GiveWep(wep)
{
	self endon("disconnect");
	self TakeAllWeapons();
	wait .05;
	self GiveWeapon(wep);
    wait 0.1;
    self SwitchToWeapon(wep);
}

ShowNotifyMessage(title,text)
{
	if(isDefined(title) && isDefined(text))
	{	
		noti = SpawnStruct();
		noti.titleText = title;
		noti.notifyText = text;
		noti.duration = 6;
		noti.glowcolor = (1,0,0);
		players = getentarray("player", "classname");
		for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
	}
}

GetRandomWeapon( num )
{
    if( num == 2 )
        return "knife_mp";
    else
    {
        x = RandomInt( 51 );
        if( x < 10 )
            return "winchester1200_mp";
        if( x > 9 && x < 20 )
            return "skorpion_mp";
        if( x > 20 && x < 30 )
            return "m4_mp";
        if( x > 30 && x < 40 )
            return "g3_mp";
        if( x > 40 && x < 50 )
            return "ak47_mp";
        return "rpd_mp";
    }
}



