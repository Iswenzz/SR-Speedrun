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
    setdvar( "r_glowbloomintensity0", ".25" );
    setdvar( "r_glowbloomintensity1", ".25" );
    setdvar( "r_glowskybleedintensity0", ".3" );
	
    setdvar( "compassmaxrange", "1800" );
	
	setDvar("bg_falldamagemaxheight", 15000 );
	setDvar("bg_falldamageminheight", 10000 );

thread sr\api\_map::createSpawn((-130,155,-132),180);
thread sr\api\_speedrun::createNormalWays("Normal Way;");
	
thread startdoor();
thread trap2();
thread o_moving_platforms();
thread trap4();
thread teleport();
thread death_trigger();
	
}

startdoor()
{
door = getEnt("startdoor", "targetname");

door delete();

}	

trap2()
{
spikes_1 = getEnt("trap2_spikes1", "targetname");
spikes_2 = getEnt("trap2_spikes2", "targetname");
hurt_1 = getEnt("trap2_spikes1_hurt", "targetname");
hurt_2 = getEnt("trap2_spikes2_hurt", "targetname");
	
spikes_1 delete();
spikes_2 delete();
hurt_1 delete();
hurt_2 delete();
	
}

o_moving_platforms()
{
platform_1 = getEnt("moving_platform_1", "targetname");
platform_2 = getEnt("moving_platform_2", "targetname");
	
platform_1 moveY(700,0.1);
platform_2 moveX(-200,0.1);
wait 0.2;
platform_1 rotateYaw(90,0.1);
platform_2 rotateYaw(90,0.1);
wait 0.2;
platform_1 moveX(200,0.1);
	
}

trap4()
{
object = getEnt("trap4_object", "targetname");
	
object rotateYaw(90,0.1);
		
}

teleport()
{
   trig = getent("trigger_teleport", "targetname");
   tele = getent ("teleport_end", "targetname");

   for(;;)
    {   
     trig waittill("trigger", player);
	 player setOrigin(tele.origin);
	 player freezeControls (1);
	 wait 0.05;
	 player freezeControls (0);
    }
}

death_trigger()
{
hurt = getent("trigger_death","targetname");

for(;;)
{

hurt waittill("trigger",player);
player Suicide();

}
}