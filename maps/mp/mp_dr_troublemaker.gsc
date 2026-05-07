//SCRIPT BY FREEK
main()
{
maps\mp\_load::main();

    thread sr\api\_map::createSpawn((-86, 214, 76), 270);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
    thread sr\api\_speedrun::createEndMap((-1885.32, -5867.49, -63.875), 400,120, "normal_0"); 

    thread custom_tp();



thread start_door();
thread last_door();
thread don();
//=================TRAPS==============
thread trap1();
thread trap2();
thread trap3();
thread mp();
thread trap4(); 
thread trap5();
thread trap6();
thread trap7();
thread trap8();
thread trap9();
thread trap10();
thread trap11();
thread trap12();
thread trap13();
thread trap14();
thread trap15();
thread trap16();
thread trap17();
//=========================CLAWS=====================
//thread weapon_mini();
//thread addTestClients();
//thread credit();
thread secondlvl();
//thread hc();
//thread lvllvl();
	
	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	
	/*PreCacheItem("m21_mp");
	PreCacheItem("dragunov_mp");
	PreCacheItem("barrett_mp");
	PreCacheItem("rpg_mp");
	PreCacheItem("c4_mp");
	PreCacheItem("frag_grenade_mp");
	PreCacheItem("m1014_grip_mp");
	PreCacheItem("winchester1200_grip_mp");
	PreCacheItem("mp5_reflex_mp");
	PreCacheItem("smoke_grenade_mp");
	PreCacheItem("rpd_grip_mp");
	PreCacheItem("smoke_grenade_mp");*/

}
custom_tp()
{
	trig = spawn("trigger_radius",(-270.342, -1300.82, -13.875), 0, 60, 120);
	trig.radius = 60;
	
	ori_t = spawn("script_origin",(-61,-2037,28));
	ori_t.angles = (0,270,0);

	thread sr\api\_map::createTriggerFx(trig, "cyan");

	for(;;)
	{
		trig waittill("trigger",player);

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
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
//==============START DOOR================
start_door()
{

door = getEnt ("start_door", "targetname");
trig = getEnt ("start_doortrig", "targetname");

wait 0.1;

door delete();
}
 	

don()
{

door = getEnt ("start_door2a", "targetname");
trig = getEnt ("start_door2", "targetname");

wait 0.1;

door delete();
}
//=================TRAP1==================
trap1()
{

  brush = getEnt ("trap1", "targetname");
  trig  = getEnt ("trig1", "targetname");
  
  trig waittill ("trigger", player);
  

  }
  
trap2()
{

  brush = getEnt ("trap2", "targetname");
  trig  = getEnt ("trig2", "targetname");
  
  trig waittill ("trigger", player);
  

  }
  
 trap3()
 {
 
 brush1 = getEnt ("trap3a", "targetname");
 brush2 = getEnt ("trap3b", "targetname");
 trig  = getEnt ("trig3", "targetname");
 
 trig waittill ("trigger", player);
 

 }
 
 mp()//mp=Moving plates
{
  m1 = getEnt ("mp1", "targetname");
  m2 = getEnt ("mp2", "targetname");
  

}

trap4()
{
  brush = getEnt ("trap4", "targetname");
  trig = getEnt ("trig4", "targetname");
  
  trig waittill ("trigger",player);
  
 
 }


trap5()
{
   b1 = getEnt ("trap5", "targetname");
   b2 = getEnt ("trap5a", "targetname");
   b3 = getEnt ("trap5b", "targetname");
   trig = getEnt ("trig5", "targetname");
   
   trig waittill ("trigger",player);
   
  
	
}

trap6()
{
  brush = getEnt ("trap6", "targetname");
  trig = getEnt ("trig6", "targetname");
  
  trig waittill ("trigger",player);
  
 
  
 }

 trap7()
{
	trig = getEnt ("trig7", "targetname");
	brusha = getEnt ("trap7a", "targetname");
    brushb = getEnt ("trap7b", "targetname");
    hurta = getEnt ("hurt7a", "targetname");
    hurtb = getEnt ("hurt7", "targetname");

    wait 0.1;



	brusha delete();
	brushb delete();
	hurta delete();
	hurtb delete();

}

trap8()
{
  bx1 = getEnt ("trap8", "targetname");
  bx2 = getEnt ("trap8a", "targetname");
  bx3 = getEnt ("trap8b", "targetname");
  bx4 = getEnt ("trap8c", "targetname");
  bx5 = getEnt ("trap8d", "targetname");
  bx6 = getEnt ("trap8e", "targetname");
  bx7 = getEnt ("trap8f", "targetname");
  trig = getEnt ("trig8", "targetname"); 
  
  trig waittill ("trigger", player);

}

trap9()
{
 brush = getEnt ("trap9", "targetname");
 trig = getEnt ("trig9", "targetname");
 
 trig waittill ("trigger", player);

}

trap10()
{
 b1 = getEnt ("trap10a", "targetname");
 b2 = getEnt ("trap10b", "targetname");
 b3 = getEnt ("trap10c", "targetname");
 b4 = getEnt ("trap10d", "targetname");
 b5 = getEnt ("trap10e", "targetname");
 b6 = getEnt ("trap10f", "targetname");
 trig = getent ("trig10", "targetname");
  
 trig waittill ("trigger", player);

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

credit()
{
wait(10);
thread drawInformation( 800, 0.8, 1, "^1Freek the AWesome" );
wait(4);
thread drawInformation( 800, 0.8, 1, "^2Trouble^1Maker" );
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

last_door()
{

door = getEnt ("last", "targetname");
trig = getEnt ("lasttrig", "targetname");

wait 0.1;

door delete();
}

secondlvl()
 {
	entTransporter = getentarray( "there", "targetname" );
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
		player SetOrigin(entTarget.origin);
		player SetPlayerAngles(entTarget.angles);
		player freeze_on_tps(0.1);
	}
}

trap11()
{
 brush = getEnt ("trap11", "targetname");
 trig = getEnt ("trig11", "targetname");
 
 trig waittill ("trigger", player);
 

 } 
 
 hc()
 {
 b1 = getEnt ("hcrw1", "targetname");
 b2 = getEnt ("hcrw2", "targetname");
 b3 = getEnt ("hcrw3", "targetname");
 b4 = getEnt ("hcrw4", "targetname");
 b5 = getEnt ("hcrw5", "targetname");
 b6 = getEnt ("hcrw6", "targetname");
 b7 = getEnt ("hcrw7", "targetname");
 b8 = getEnt ("hcrw8", "targetname");
 b9 = getEnt ("hcrw9", "targetname");
 b10 = getEnt ("hcrw10", "targetname");
 b11 = getEnt ("hcrw11", "targetname");
 b12 = getEnt ("hcrw12", "targetname");
 b13 = getEnt ("hcrw13", "targetname");
 b14 = getEnt ("hcrw14", "targetname");
 b15 = getEnt ("hcrw15", "targetname");
 trig = getEnt ("trighc", "targetname");
 
 trig waittill ("trigger", player);
 

 }
 
 trap12()
 { 
   brush = getEnt ("trap12a", "targetname");
   brush1 = getEnt ("trap12b", "targetname");
   trig = getEnt ("trig12", "targetname");
   
   trig waittill ("trigger", player);
   
 
}

trap13()
{
 brush = getEnt ("trap13", "targetname");
 trig = getEnt ("trig13", "targetname");
  
 trig waittill ("trigger", player);
 

}

trap14()
{
 b1 = getEnt ("trap14", "targetname");
 b2 = getEnt ("trap14b", "targetname");
 trig = getEnt ("trig14", "targetname");
 
 trig waittill ("trigger", player);
 

 }
  
  
  lvllvl()
 {
	entTransporter = getentarray( "yoyo", "targetname" );
	if(isdefined(entTransporter))
		for( i = 0; i < entTransporter.size; i++ )
			entTransporter[i] thread transporter1();
}
 
transporter1()
{
	for(;;)
	{
		self waittill( "trigger", player );
		entTarget = getEnt( self.target, "targetname" );
		player SetOrigin(entTarget.origin);
		player SetPlayerAngles(entTarget.angles);
		player freeze_on_tps(0.1);
	}
}

trap15()
{
 brush = getEnt ("trap15", "targetname");
 trig = getEnt ("trig15", "targetname");
 
 trig waittill ("trigger", player);
 

 }
 
 trap16()
 {
   b1 = getEnt ("trap16a", "targetname");   
   b2 = getEnt ("trap16b", "targetname");
   b3= getEnt ("trap16c", "targetname");
   b4 = getEnt ("trap16d", "targetname");
   trig = getEnt ("trig16", "targetname");
   
   trig waittill ("trigger", player);
   

}

trap17()
{
 b1 = getEnt ("trap17a", "targetname");
 b2 = getEnt ("trap17b", "targetname");
 trig = getEnt ("trig17", "targetname");
 
 trig waittill ("trigger", player);
 

 }