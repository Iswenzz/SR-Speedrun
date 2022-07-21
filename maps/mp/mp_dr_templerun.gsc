#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_hud_message;
#include common_scripts\utility;

main()
{
thread sr\api\_map::createSpawnOrigin((20, 0, 16), 1);
 maps\mp\_load::main();

 game["allies"] = "sas";
 game["axis"] = "russian";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "woodland";
 game["axis_soldiertype"] = "woodland";

///DVARS
	setdvar("r_specularcolorscale", "1");
    setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);

        thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("Secret Way;");
    thread sr\api\_speedrun::createTeleporter((3322.63, -509.911, 256.125), 65, 20, (3335, 676, 28), 90, "freeze", "blue", "normal_0");

    thread fan();
    thread fire();
    thread laser1();
    thread laser2();
    thread stage2door();
    thread stage2tp();
    thread end_wall();
    thread sectp();
    thread secend();
    thread save_load_logic();
    thread coins();

}

fan()
{
    hurt = getEntArray("trig_hurt_fan1", "targetname");

    hurt[0] delete();
    hurt[1] delete();
    hurt[2] delete();
    hurt[3] delete();

}

fire()
{
    hurta = getent("trig_hurt_fire1", "targetname");
    hurtb = getent("trig_hurt_fire2", "targetname");

    hurta delete();
	hurtb delete();

}

laser1()
{
   laser1 = getent("laser1", "targetname");
   hurta = getent("trig_hurt_laser1", "targetname");

   hurta delete();
   laser1 delete();

}

laser2()
{
   laser2 = getent("laser2", "targetname");
   hurtb = getent("trig_hurt_laser2", "targetname");

   hurtb delete();
   laser2 delete();

}

stage2door()
{
   doora = getent("stage2doora", "targetname");
   doorb = getent("stage2doorb", "targetname");

   doora delete();
   doorb delete();

}

stage2tp()
{
   trig = getent("trig_stage2tp", "targetname");
   tele = getent ("orig_stage2tp", "targetname");

   for(;;)
    {
     trig waittill("trigger", player);
	 player setOrigin(tele.origin);
     player setPlayerAngles(tele.angles);
    }
}

end_wall()
{
   plat = getent("end_wall", "targetname");

   plat delete();

}

sectp()
{
   trig = getent("trig_sectp", "targetname");
   tele = getent ("orig_sectp", "targetname");

   for(;;)
    {
     trig waittill("trigger", player);

     player thread sr\api\_speedrun::changeWay("secret_0");
	 player setOrigin(tele.origin);
     player setPlayerAngles(tele.angles);
     player.sc_pos = 0;
     player.insec = true;

     player thread secend();
    }
}

secend()
{
    self endon( "spawned_player" );
    self endon( "joined_spectators" );
    self endon( "death" );


   trig = getent("trig_secend", "targetname");
   tele = getent ("orig_secend", "targetname");

   for(;;)
    {
     trig waittill("trigger", player);

      if(player != self)
        continue;

     player thread sr\api\_speedrun::finishWay("secret_0");
     player notify("secret_done");
	 player setOrigin(tele.origin);
     player setPlayerAngles(tele.angles);
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
        player SetOrigin( save_triggers[player.sc_pos].origin+(0,0,1) );
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
            player IPrintLn("^3" + " Checkpoint " + "^7" + pos);
        }

        wait 0.1;
    }
}

coins()
{
   coina = getent("coin1", "targetname");
   coinb = getent("coin2", "targetname");
   coinc = getent("coin3", "targetname");
   coind = getent("coin4", "targetname");
   coine = getent("coin5", "targetname");
   coinf = getent("coin6", "targetname");
   coing = getent("coin7", "targetname");
   coinra = getent("coinred1", "targetname");
   coinrb = getent("coinred2", "targetname");
   coinrc = getent("coinred3", "targetname");
   coinba = getent("coinblue1", "targetname");
   coinbb = getent("coinblue2", "targetname");


   coina delete();
   coinb delete();
   coinc delete();
   coind delete();
   coine delete();
   coinf delete();
   coing delete();
   coinra delete();
   coinrb delete();
   coinrc delete();
   coinba delete();
   coinbb delete();

}