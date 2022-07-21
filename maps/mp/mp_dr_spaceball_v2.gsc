main()
{
thread sr\api\_map::createSpawnOrigin((511, 299, 1792), 270);
	maps\mp\_load::main();

	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	setdvar( "r_specularcolorscale", "1" );

	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");
	setdvar("bg_fallDamageMaxHeight","999999");
	setdvar("bg_fallDamageMinHeight","99999");

        thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createTeleporter((-5954.7, -9727.3, 1344.13), 65, 30, (-9662, -7393, 1357), 90, "freeze", "blue");

	thread trap();
	thread curv_pusher();
	thread jumperdie();

}

trap()
{
trap1 = getent("trap2","targetname");
trap2 = getent("trap12","targetname");

wait 0.1;
trap1 delete();
trap2 delete();
}

curv_pusher(who)
{
	trigger = getEnt ( "curv_pusher", "targetname" );

	while(1)
	{
    	trigger waittill ( "trigger", who );

	    oldpos = who.origin;
	    strenght = 10;
	    for(i=0;i<strenght;i++)
	    {
	        who.health += 160;
            who finishPlayerDamage(who, level.jumpattacker, 160, 0, "MOD_FALLING", "jump_mp", who.origin, AnglesToForward((-90,-45,0)), "none", 0);
	    }
	}
}

jumperdie()
{
target = getEnt( "safezone", "targetname");
{
self waittill("death");
level.activ SetOrigin(target.origin);
level.activ SetPlayerAngles( target.angles );
}
}