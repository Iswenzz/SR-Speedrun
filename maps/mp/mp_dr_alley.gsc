///////////////////////////////////////////////////////////////////////////
//  ______  __              __                      ___                 //
// /\__  _\/\ \            /\ \       __          /'___\               //
// \/_/\ \/\ \ \___      __\ \ \     /\_\   __  _/\ \__/   __         //
//    \ \ \ \ \  _ `\  /'__`\ \ \  __\/\ \ /\ \/'\ \ ,__\/'__`\      //
//     \ \ \ \ \ \ \ \/\  __/\ \ \L\ \\ \ \\/>  </\ \ \_/\  __/     //
//      \ \_\ \ \_\ \_\ \____\\ \____/ \ \_\/\_/\_\\ \_\\ \____\   //
//       \/_/  \/_/\/_/\/____/ \/___/   \/_/\//\/_/ \/_/ \/____/  //
//                                                               //
//////////////////////////////////////////////////////////////////                                                        


//!ATTENTION!// THIS MAP WAS MADE IN 12 HOURS //

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

	addTriggerToList("trig_rotaters");
	addTriggerToList("trig_nsolid");
	addTriggerToList("trig_reip");
	addTriggerToList("trig_pusher");
	addTriggerToList("trig_bounce");
	addTriggerToList("trig_stairs");
	addTriggerToList("trig_pop");
	addTriggerToList("trig_stairs2");
	addTriggerToList("trig_spinner");
	addTriggerToList("trig_spikes");


    thread speedrun\_way_name::create_normal_way("Normal Way");
    thread speedrun\_way_name::create_endmap((-815.254, 4860.54, 305.192), 0, 275, 10 );
    thread speedrun\_way_name::create_spawn((-53,-244,60),88);
	thread start_door();
	thread map_mover();
	thread garage();
	thread trap_stairs();
	thread trap_pusher();
	thread trap_bounce();
	thread trap_pop();
	thread trap_stairs2();
	thread trap_spinner();
	thread trap_spikes();
	thread trap_rotaters();
	thread trap_nsolid();
	thread trap_reip();
	thread rooms();
}
addTriggerToList(name)
{
    if(!isDefined(level.trapTriggers))
    level.trapTriggers=[];
    level.trapTriggers[level.trapTriggers.size]=getEnt(name,"targetname");
}
start_door()
{
	object = getent("start_door","targetname");
	i = randomint(2);
	if(i == 0)
	{
		// ambientPlay("laszlo");
		wait 10;
		object movez(-120,2);
	}
	else if(i == 1)
	{
		// ambientPlay("aero");
		wait 10;
		object movez(-120,2);
	}
}
map_mover()
{
	object = getEnt ("map_mover","targetname");
	wait 7;
}
garage()
{
	trigger = getEnt ("trig_garage","targetname");
	object = getEnt ("garage_door","targetname");
	object rotateroll (-90, 3);
}
trap_stairs()
{
	trigger = getEnt ("trig_stairs","targetname");
	object = getEnt ("trap_stairs","targetname");
	trigger waittill ("trigger", player );
}
trap_pusher()
{
	trigger = getEnt ("trig_pusher","targetname");
	object = getEnt ("trap_pusher","targetname");
	kill = getEnt ("kill_pusher","targetname");
	kill enablelinkto ();
	kill linkto (object);
	trigger waittill ("trigger", player );
}
trap_bounce()
{
	trigger = getEnt ("trig_bounce","targetname");
	object = getEnt ("trap_bounce","targetname");
	trigger waittill ("trigger", player );
}
trap_pop()
{
	trigger = getEnt ("trig_pop","targetname");
	object = getEnt ("trap_pop","targetname");
	object hide();
	object notSolid();
	trigger waittill ("trigger", player );
}
trap_stairs2()
{
	trigger = getEnt ("trig_stairs2","targetname");
	object1 = getEnt ("trap_stairs2_1","targetname");
	object2 = getEnt ("trap_stairs2_2","targetname");
	trigger waittill ("trigger", player );
}
trap_spinner()
{
	trigger = getEnt ("trig_spinner","targetname");
	object = getEnt ("trap_spinner","targetname");
	trigger waittill ("trigger", player );
}
trap_spikes()
{
	
	trigger = getEnt ("trig_spikes","targetname");
	trigger waittill ("trigger", player );
	thread spikes1();
	thread spikes2();
	thread spikes3();
	thread spikes4();
	thread spikes5();
	thread spikes6();
}
spikes1()
{
	object = getEnt ("spikes1","targetname");
	kill = getEnt ("kill_spikes1","targetname");
	kill enablelinkto ();
	kill linkto (object);
	object movez(48,0.5);
	object waittill ("movedone");
}
spikes2()
{
	object = getEnt ("spikes2","targetname");
	kill = getEnt ("kill_spikes2","targetname");
	kill enablelinkto ();
	kill linkto (object);
	object movez(48,0.5);
	object waittill ("movedone");
}
spikes3()
{
	object = getEnt ("spikes3","targetname");
	kill = getEnt ("kill_spikes3","targetname");
	kill enablelinkto ();
	kill linkto (object);
	object movez(48,0.5);
	object waittill ("movedone");
}
spikes4()
{
	object = getEnt ("spikes4","targetname");
	kill = getEnt ("kill_spikes4","targetname");
	kill enablelinkto ();
	kill linkto (object);
	object movez(48,0.5);
	object waittill ("movedone");
}
spikes5()
{
	object = getEnt ("spikes5","targetname");
	kill = getEnt ("kill_spikes5","targetname");
	kill enablelinkto ();
	kill linkto (object);
	object movez(48,0.5);
	object waittill ("movedone");
	object movez(-48,0.5);
}
spikes6()
{
	object = getEnt ("spikes6","targetname");
	kill = getEnt ("kill_spikes6","targetname");
	kill enablelinkto ();
	kill linkto (object);
	object movez(48,0.5);
	object waittill ("movedone");
}
trap_rotaters()
{
	trigger = getEnt ("trig_rotaters","targetname");
	object1 = getEnt ("rotaters1","targetname");
	object2 = getEnt ("rotaters2","targetname");
	trigger waittill ("trigger", player );
}
trap_nsolid()
{
	trigger = getEnt ("trig_nsolid","targetname");
	object1 = getEnt ("trap_nsolid1","targetname");
	object2 = getEnt ("trap_nsolid2","targetname");
	object3 = getEnt ("trap_nsolid3","targetname");
	object4 = getEnt ("trap_nsolid4","targetname");
	object5 = getEnt ("trap_nsolid5","targetname");
	clip1 = getEnt ("clip_nsolid1","targetname");
	clip1 notSolid();
	trigger waittill ("trigger", player );
}
trap_reip()
{
	trigger = getEnt ("trig_reip","targetname");
	object1 = getEnt ("trap_reip1","targetname");
	object2 = getEnt ("trap_reip2","targetname");
	trigger waittill ("trigger", player );
}
rooms()
{
	// thread rpg_room();
	// thread knife_room();
	// thread sniper_room();
}
rpg_room()
{
	level.rpg=getent("rpgroom_ent","targetname");
	jump=getent("room_teleport","targetname");
	acti=getent("acti_teleport","targetname");

	while(1)
	{
		level.rpg waittill("trigger",player);
		if(!isdefined(level.rpg)) return;

		if(!isdefined(level.entertext)||!level.entertext)
		{
			level.entertext=true;

			ambientstop();
			 // ambientplay("freefall");
			level.canplaysound=false;

			level.knife delete();
			level.sniper delete();

			iprintlnbold("^1"+player.name+"^7 entered RPG Room");
			iprintln("^1Now playing: ^7Audioscribe^5- ^7Free fall");
		}

		if(!isdefined(level.activ))
		{
			player iprintlnbold("^1Activator^7 is required for Endfight");
			return;
		}

		player createroomport("rpg_mp",undefined,1,jump,100);
        level.activ createroomport("rpg_mp",undefined,1,acti,100);
 
        player thread countdown();
        level.activ thread countdown();

        player thread refreshAmmo();
        level.activ thread refreshAmmo();
 
       	while(isalive(player)&&isdefined(player))
            wait 1;

        iPrintlnBold("^1"+self.name+" ^7died^1!");
	}
}
refreshAmmo()
{
	while(isalive(self)&&isdefined(self))
	{
		self givemaxammo("rpg_mp");
		wait 4;
	}
}

sniper_room()
{
	level.sniper=getent("sniproom_ent","targetname");
	jump=getent("room_teleport","targetname");
	acti=getent("acti_teleport","targetname");

	while(1)
	{
		level.sniper waittill("trigger",player);
		if(!isdefined(level.sniper)) return;

		if(!isdefined(level.entertext)||!level.entertext)
		{
			level.entertext=true;

			ambientstop();
			 // ambientplay("freefall");
			level.canplaysound=false;


			level.rpg delete();
			level.knife delete();

			iprintlnbold("^1"+player.name+"^7 entered Sniper Room");
			iprintln("^1Now playing: ^7Audioscribe^5- ^7Free fall");
		}

		if(!isdefined(level.activ))
		{
			player iprintlnbold("^1Activator^7 is required for Endfight");
			return;
		}

		player createroomport("remington700_mp","m40a3_mp",1,jump,100);
        level.activ createroomport("remington700_mp","m40a3_mp",1,acti,100);
 
        player thread countdown();
        level.activ thread countdown();

 
       	while(isalive(player)&&isdefined(player))
            wait 1;

        iPrintlnBold("^1"+self.name+" ^7died^1!");
	}
}
knife_room()
{
	level.knife=getent("kniferoom_ent","targetname");
	jump=getent("room_teleport","targetname");
	acti=getent("acti_teleport","targetname");

	while(1)
	{
		level.knife waittill("trigger",player);
		if(!isdefined(level.knife)) return;

		if(!isdefined(level.entertext)||!level.entertext)
		{
			level.entertext=true;

			ambientstop();
			// ambientplay("freefall");
			level.canplaysound=false;

			level.rpg delete();
			level.sniper delete();

			iprintlnbold("^1"+player.name+"^7 entered Knife Room");
			iprintln("^1Now playing: ^7Audioscribe^5- ^7Free fall");
		}

		if(!isdefined(level.activ))
		{
			player iprintlnbold("^1Activator^7 is required for Endfight");
			return;
		}

		player createroomport("knife_mp",undefined,1,jump,100);
        level.activ createroomport("knife_mp",undefined,1,acti,100);
 
        player thread countdown();
        level.activ thread countdown();
 
       	while(isalive(player)&&isdefined(player))
            wait 1;

        iPrintlnBold("^1"+self.name+" ^7died^1!");
	}
}

createroomport(weapon,weapon2,freeze,where,health)
{
    self takeallweapons();
    self giveweapon(weapon);
    if(isdefined(weapon2))
    	self giveweapon(weapon2);
    self switchtoweapon(weapon);
 
    self freezecontrols(freeze);
    self setorigin(where.origin);
    self setplayerangles(where.angles);
 
    self.health=health;
}
countdown()
{
    self iprintlnbold("^33");
    wait 1;
    self iprintlnbold("^32");
    wait 1;
    self iprintlnbold("^31");
    wait 1;
    self iprintlnbold("^5Fight!");
    self freezecontrols(0);
}
creators()
{
	wait 9;
	iPrintlnBold("^7Map by ^5TheLixfe");
	wait 2;
	iprintln("^7This map was made in 12hours!");
	wait 4;
	iprintln("^7Thanks to ^5Vistic Clan");
	wait 5;
	iprintln("^6steam: TheLixfe");
	wait 5;
	iprintln("^7Map by ^5TheLixfe");
}