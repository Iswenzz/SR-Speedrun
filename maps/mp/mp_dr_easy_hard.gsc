#include braxi\_common;
#include common_scripts\utility;
#include braxi\_rank;

main()
{

maps\mp\_load::main();
 
	game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";
	setdvar("r_specularcolorscale","1");
	setdvar("compassmaxrange","1600");
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setDvar("bg_falldamagemaxheight", 20000000 );
	setDvar("bg_falldamageminheight", 15000000 );
	setDvar("r_filmUseTweaks", "1");

	visionSetNaked("mp_dr_easy_hard",0);

	SetExpFog( 768, 1500, 123/255, 155/255, 175/255, 3 );
	
    thread speedrun\_way_name::create_spawn((-13,-71,76),90);
    thread speedrun\_way_name::create_normal_way("Normal Way;");
    thread speedrun\_way_name::create_secret_way("Secret Way;");
    thread speedrun\_way_name::create_tp((-199.927, 133.188, 16.125), 55, 25, (15248, 11888, 16.125), 180, "freeze", "blue", "s0");
    
    thread startdoor();
    thread secretexit();
    thread tp1();
    thread tp2();
    thread tp3();
    thread tp4();

	
}

startdoor()
{
door =getEnt("startdoor", "targetname");

wait 0.1;
door delete();

}

secretexit()
{
trig = getEnt("trig_secretexit", "targetname");
tele1 = getEnt("o_secretexit", "targetname");

	for(;;)
		{
		trig waittill("trigger", player);

        player thread speedrun\_way_name::finish_way("s0");
		player setOrigin(tele1.origin);
		player setPlayerAngles(tele1.angles);		
        
		}
}

tp1()
{
   trig = getent("trig_tp1", "targetname");
   tele = getent ("o_tp1", "targetname");

   for(;;)
    {   
     trig waittill("trigger", player);
	 player setOrigin(tele.origin);
     player setPlayerAngles(tele.angles);
    }
}

tp2()
{
   trig = getent("trig_area3", "targetname");
   tele = getent ("origin_area3", "targetname");

   for(;;)
    {   
     trig waittill("trigger", player);
	 player setOrigin(tele.origin);
     player setPlayerAngles(tele.angles);
    }
}

tp3()
{
   trig = getent("trig_saver", "targetname");
   tele = getent ("o_saver", "targetname");

   for(;;)
    {   
     trig waittill("trigger", player);
	 player setOrigin(tele.origin);
     player setPlayerAngles(tele.angles);
    }
}

tp4()
{
   trig = getent("trig_cut", "targetname");
   tele = getent ("o_cut", "targetname");

   for(;;)
    {   
     trig waittill("trigger", player);
	 player setOrigin(tele.origin);
     player setPlayerAngles(tele.angles);
    }
}