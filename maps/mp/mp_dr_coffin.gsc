#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_hud_message;
#include common_scripts\utility;
main()
{
 maps\mp\_load::main();


 game["allies"] = "sas";
 game["axis"] = "russian";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "woodland";
 game["axis_soldiertype"] = "woodland";
       
///DVARS       
	setdvar( "r_specularcolorscale", "1" );
    setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);

thread speedrun\_way_name::create_spawn((-100,-183,60),270);
thread speedrun\_way_name::create_tp((243.684, -205.458, 0.125002), 55, 10, (4216, -160, 60), 360, "freeze", "yellow", "s1");
thread speedrun\_way_name::create_normal_way("Normal Way;");
thread speedrun\_way_name::create_secret_way("Jumper Secret;Acti Secret;");

///DOORS AND MOVING PLATFORM
   thread startdoor();
   thread doorexplode();
///STUCKFIX   
   thread glitchfix();
///JUMPER SECRET   
   thread secret_step();
   thread sectp();
   thread save_load_logic();
///ACTIVATOR SECRET   
   thread actisecfinish();
///TRAPS
   thread trap6();
   thread trap7();

}

startdoor()
{
door = getent("startdoor","targetname");
plat = getent("trap13c", "targetname");

wait 0.1;
door delete();
plat delete();

}

doorexplode()
{
plat = getent("rockdoor", "targetname");

wait 0.1;

plat delete();

}

glitchfix()
{
   trig = getent("trig_fixglitch", "targetname");
   tele = getent ("orig_fixglitch", "targetname");

   for(;;)
    {   
     trig waittill("trigger", player);
	 player setOrigin(tele.origin);
     player setPlayerAngles(tele.angles);
     player iprintlnBOld ("^1Don't try to glitch^0!");
    }
}

///SECRET ROOM
secret_step()
{
brush = getEnt("secopena","targetname");
brush2 = getEnt("secopenb","targetname");

wait 0.1;
brush delete();
brush2 delete();
  
}

sectp()
{
   trig = getent("trig_sectp", "targetname");
   tele1 = getent ("orig_sectp", "targetname");

   for(;;)
    {   
     trig waittill("trigger", player);
     player thread speedrun\_way_name::change_way("s0");
	 player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
     player.sc_pos = 0;
     player.insec = true;

     player thread secfinish();
    }
}

secfinish()
{
    self endon( "spawned_player" );
    self endon( "joined_spectators" );
    self endon( "death" );
    
   trig = getent("trig_secfinish", "targetname");
   tele1 = getent ("orig_secfinish", "targetname");

   for(;;)
    {   
     trig waittill("trigger", player);

     if(player != self)
        continue;
    player thread speedrun\_way_name::finish_way("s0");
    player notify("secret_done");
	player setOrigin(tele1.origin);
    player setPlayerAngles(tele1.angles);
    player.sc_pos = 0;
    player.insec = false;

    break;
    }
    
}

save_load_logic()
{
    fail_trigger = getent("trig_fail","targetname");
    save_triggers = GetEntArray("save_triggers","targetname");
    
    for(i=0;i<save_triggers.size;i++)
        thread save_pos(save_triggers[i],i);

    while(1)
    {
        fail_trigger waittill("trigger",player);
        player SetOrigin( save_triggers[player.sc_pos].origin+(0,0,50) );
    }
}

save_pos(trig,pos)
{
    while(1)
    {
        trig waittill("trigger",player);
        
        if(!IsDefined(player.sc_pos))
            player.sc_pos = pos;

        else if(IsDefined(player.sc_pos) && player.sc_pos < pos)
        {
            player.sc_pos = pos;
            //IPrintLnBold(pos+" save");
        }

        wait 0.1;
    }
}

actisecfinish()
{
trig = getent("trig_actisecfinish", "targetname");

   for(;;)
    {   
    trig waittill("trigger", player);

    player thread speedrun\_way_name::finish_way("s1");

    }
    
}

trap6()
{
plata = getent ("trap6a", "targetname");
platb = getent ("trap6b", "targetname");

wait 0.1;

plata delete();
platb delete();

}

trap7()
{
plata = getent ("trap7a", "targetname");
platb = getent ("trap7b", "targetname");

wait 0.1;

plata delete();
platb delete();
  
}

