main()
{
level.masterSpawn = spawn("script_origin", (-321,295,-87));
level.masterSpawn.angles = level.spawn["allies"][2].angles;
trigger = spawn("trigger_radius", (1007, 2044.27, -86.875), 0, 100, 90);
trigger.targetname = "endmap_trig";
trigger.radius = 100;

	//***************************//
	thread way_connect();
    maps\mp\_load::main();

	//***** script ******//
	maps\mp\mp_dr_jurapark\traps::main();
	maps\mp\mp_dr_jurapark\visual::main();
	//maps\mp\mp_dr_jurapark\mp_dr_jurapark::main();

	maps\mp\_compass::setupMiniMap("compass_map_mp_jurapark");	
	setdvar("compassmaxrange","1750");

	// AmbientPlay( "song1" );
	
	//***************************//

        game["allies"] = "sas";
        game["axis"] = "opfor";
        game["attackers"] = "axis";
        game["defenders"] = "allies";
        game["allies_soldiertype"] = "woodland";
        game["axis_soldiertype"] = "woodland";

	//setdvar( "r_specularcolorscale", "1" );
	
	//setdvar("r_glowbloomintensity0",".25");
	//setdvar("r_glowbloomintensity1",".25");
	//setdvar("r_glowskybleedintensity0",".3");
	//setdvar("compassmaxrange","1800");
        thread bricky_fix();
}

bricky_fix()
{
	del_weapon("knife_mp");
	del_weapon("m16_gl_mp");
	del_weapon("ak74u_reflex_mp");
	del_weapon("ak74u_acog_mp");
	del_weapon("ak74u_silencer_mp");
	del_weapon("dog_mp");
	del_weapon("shovel_mp");
}

del_weapon(name)
{
	array = getEntArray("weapon_" + name, "classname");
	if (!isDefined(array) || isDefined(array) && !isDefined(array.size))
		return;

	for (i = 0; i < array.size ;i++)
		array[i] delete();
}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    sr\api\_map::createWay("normal", "Normal Way", "1");
	
    for(;;) 
    {
        level waittill( "connected", player );
        player thread sr\api\_map::way_name();
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////
