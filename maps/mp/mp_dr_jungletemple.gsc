#include common_scripts\utility;
#include maps\mp\_utility;
main()
{
thread sr\api\_map::createSpawnOrigin((64.125, -56, 16.125), 0);
maps\mp\_load::main();

////Ambience////
VisionSetNaked( "mp_dr_jungletemple");

////game////
game["allies"] = "sas";
game["axis"] = "spetnaz";
game["attackers"] = "axis";
game["defenders"] = "allies";
game["allies_soldiertype"] = "desert";
game["axis_soldiertype"] = "desert";

////SetDvar////
setdvar( "r_specularcolorscale", "1" );
setdvar("r_glowbloomintensity0","1");
setdvar("r_glowbloomintensity1","1");
setdvar("r_glowskybleedintensity0","1");
setDvar("bg_fallDamageMinHeight", "128000");
setDvar("bg_fallDamageMaxHeight", "368000");

preCacheItem("rpg_mp");

////RunCourseThreads////
thread way_connect();
thread secret_enter();
thread secret_finish();
thread rpg();
thread trap1();
thread trap4();
thread trap5();
thread trap9();

}

way_connect()
{
    wait 0.05;

    thread sr_tp();
    thread sr_tp2();

    sr\api\_speedrun::createNormalWays("Normal Way;");
	sr\api\_speedrun::createSecretWays("Secret Way;");

    for(;;)
    {
        level waittill( "connected", player );

    }
}

sr_tp()
{
	ori = spawn("script_origin",(2756,-2211,-52));
	ori.angles = (0,180,0);
	trig = spawn("trigger_radius",(2814,-127,76),0,150,150);
	trig.radius = 150;
	wait 1;
	thread sr\api\_map::createTriggerFx(trig, "red");

	for(;;)
	{
		trig waittill("trigger",player);
		player thread sr_tp_safe(ori);
	}
}

sr_tp2()
{
	ori = spawn("script_origin",(2766,-5381,-164));
	ori.angles = (0,180,0);
	trig = spawn("trigger_radius",(2762,-3347,-52),0,150,150);
	trig.radius = 150;
	wait 1;
	thread sr\api\_map::createTriggerFx(trig, "red");

	for(;;)
	{
		trig waittill("trigger",player);
		player thread sr_tp_safe(ori);
	}
}

sr_tp_safe(ori)
{
	self endon("death");
	self endon("disconnect");

	self setOrigin(ori.origin);
	self setPlayerangles(ori.angles);
	self freezeControls(1);
	wait 0.05;
	self freezeControls(0);
}

secret_enter()
{
	trig_heen = getent("secret_trig", "targetname");
	orig_heen = getent("secret_begin", "targetname");

	while(true)
	{
		trig_heen waittill ("trigger", who);
		who SetPlayerAngles( orig_heen.angles );
		who setOrigin( orig_heen.origin ); //teleports the jumper
		who sr\api\_speedrun::changeWay("secret_0"); //Speedrun Copy Paste
	}
}

secret_finish()
{
	trig_terug = getent("secret_endtrig", "targetname");
	orig_terug = getent("secret_end", "targetname");

	while(true)
	{
		trig_terug waittill ("trigger", who);
		who SetPlayerAngles( orig_terug.angles );
		who setOrigin( orig_terug.origin ); //teleports the jumper
		who thread braxi\_mod::endTimer();
	}
}

rpg()
{
	rpg_trig = getent("rpg_trig","targetname");

	for(;;)
	{
	rpg_trig waittill("trigger", who);
	who giveWeapon("rpg_mp");
	who switchToWeapon("rpg_mp");
	who giveMaxAmmo("rpg_mp");
	wait 1;
	}
}


trap1()
{
	trap1_trigger = getent("trap1_trigger","targetname");
	hurt_trigger_trap1a = getent("trap1_hurt1","targetname");
	hurt_trigger_trap1b = getent("trap1_hurt2","targetname");

	hurt_trigger_trap1a thread maps\mp\_utility::triggerOff();
	hurt_trigger_trap1b thread maps\mp\_utility::triggerOff();

}

trap4()
{
	trap4_trigger = getent("trap4_trigger","targetname"); //acti trigger
	level.trap4 = getent("trap4","targetname");
	level.trap41_hurt = getent("trap41_hurt","targetname");

	level.trap41_hurt thread maps\mp\_utility::triggerOff();


}

trap5()
{
	trap5_trigger = getent("trap5_trigger","targetname");
	trap5_lava = getent("lava_pourhurt","targetname");

	trap5_lava thread maps\mp\_utility::triggerOff();


}

trap9()
{
	trap9_trigger = getent("trap10_trigger","targetname"); //acti trigger
	level.plane_start = getent("plane_start","targetname");
	level.plane_end = getent("plane_end","targetname");
	level.strikecoord = getent("strike_coord","targetname");
	level.trap9_kill = getent("trap9_kill","targetname");

	level.trap9_kill thread maps\mp\_utility::triggerOff();


}