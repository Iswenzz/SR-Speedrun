#include maps\mp\_utility;
#include common_scripts\utility;

///MAP MADE BY ERYK/LENTAVA
///DISCORD: lentavakalakukko

main()
{
 //   setDvar("scr_fog_disable", 1);
	maps\mp\_load::main();
    maps\mp\mp_dr_crosscode2_fx::main();

	//setdvar("bg_bobmax" , "0");
	setdvar("bg_falldamageminheight" , "99998");
	setdvar("bg_falldamagemaxheight" , "99999");
    level.sparks_fx = LoadFX("bl_sparknparts");
    level.sparks_teleport_fx = LoadFX("bl_sparknparts_teleport");
    precacheShellshock("flashbang");
    precacheitem( "crosscode_cold_mp" );
    precacheitem( "crosscode_heat_mp" );
    precacheitem( "crosscode_shock_mp" );
    precacheitem( "crosscode_wave_mp" );
    
    thread waterfall1();
    thread waterfall2();
    thread waterfalls_anim();

    precacheShader("shizuka_face");
    precacheShader("emilienator_face");
    precacheShader("message_bg");
    precacheShader("message_bg3");
    precacheShader("music_menu");
    precacheShader("music_menu4");

    thread sr\api\_map::createSpawn((128, -5952, 173), 90);
	thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createTeleporter((144, -3889, 123), 80, 70, (0, 704, 20), 90, "freeze", "blue");

    barrier = getEnt("brush_spawn_barrier", "targetname");
    trap1_barrier = getEnt("trap1_barrier", "targetname");
    trap2_barrier = getEnt("trap2_barrier", "targetname");

    barrier delete();
    trap1_barrier delete();
    trap2_barrier delete();

}

//----------------------------------------------------------------WATERFALL LOGIC-------------------------------------------------------------------//

waterfall1()
{
    trig = getent("trigger_waterfall1","targetname");
    orig = getEnt("origin_waterfall1", "targetname");

    PlayFX(level.sparks_fx, orig.origin);
    soundEnt = spawn("script_origin", orig.origin);

    for(;;)
    {
        trig waittill("trigger",player);

        if(player istouching(trig))
        {
            if(distance(player.origin,orig.origin) < 1350)
                player PlaySound("waterfallfar");
            
            if(distance(player.origin,orig.origin) < 850)
                player PlaySound("waterfallmid");

            if(distance(player.origin,orig.origin) < 350)
                player PlaySound("waterfallclose");

            wait 1.5;
        }
        else 
        {
        //    player StopSound("waterfallfar");
        //    player StopSound("waterfallmid");
        //    player StopSound("waterfallclose");
        }
    }
}

waterfall2()
{
    trig = getent("trigger_waterfall2","targetname");
    orig = getEnt("origin_waterfall2", "targetname");

    PlayFX(level.sparks_fx, orig.origin);
    soundEnt = spawn("script_origin", orig.origin);

    for(;;)
    {
        trig waittill("trigger",player);

        if(player istouching(trig))
        {
            if(distance(player.origin,orig.origin) < 1350)
                player PlaySound("waterfallfar");
            
            if(distance(player.origin,orig.origin) < 850)
                player PlaySound("waterfallmid");

            if(distance(player.origin,orig.origin) < 350)
                player PlaySound("waterfallclose");

            wait 1.5;
        }
        else 
        {
        //    player StopSound("waterfallfar");
        //    player StopSound("waterfallmid");
        //    player StopSound("waterfallclose");
        }
    }
}

waterfalls_anim()
{
    brushes1 = getEnt("waterfall1","targetname");
    brushes2 = getEnt("waterfall2","targetname");

    wait 1;
    brushes1 hide();

    while(1)
    {
        wait 0.3;
        brushes1 show();
        brushes2 hide();
        wait 0.3;
        brushes2 show();
        brushes1 hide();
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------//
