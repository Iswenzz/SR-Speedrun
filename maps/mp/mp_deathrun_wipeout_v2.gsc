main()
{
thread sr\api\_map::createSpawnOrigin((-304, -672, 384), 0);
level.spawn["allies"] = getEntArray("mp_jumper_spawn", "classname");
if (!level.spawn["allies"].size)
	level.spawn["allies"] = getEntArray("mp_dm_spawn", "classname");
trigger = spawn( "trigger_radius", (1687, 3765, 524), 0, 300, 300 );
trigger.targetname = "endmap_trig";
trigger.radius = 300;
	maps\mp\_load::main();
	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	// AmbientPlay("zor");

	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");

thread way_connect();
thread movingfixes();
thread deathtrigger();
thread escalator();

}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;

    sr\api\_speedrun::createNormalWays("Normal Way;");

    for(;;)
    {
        level waittill( "connected", player );

    }
}
////////////////////////////////////////////////////////////////////////////////////////////////

movingfixes()
{
	trap1a = getEnt("trap1a","targetname");
	trap1b = getEnt("trap1b","targetname");
	trap5 = getEnt("trap5_main","targetname");
	shuffle1 = getEnt("shuffle1","targetname");
	shuffle2 = getEnt("shuffle2","targetname");
	shuffle3 = getEnt("shuffle3","targetname");
	shuffle4 = getEnt("shuffle4","targetname");
	shuffle5 = getEnt("shuffle5","targetname");
	shuffle6 = getEnt("shuffle6","targetname");
	shuffle7 = getEnt("shuffle7","targetname");
	shuffle8 = getEnt("shuffle8","targetname");


	trap1a delete();
	trap1b delete();
	trap5 delete();
	shuffle1 delete();
	shuffle2 delete();
	shuffle3 delete();
	shuffle4 delete();
	shuffle5 delete();
	shuffle6 delete();
	shuffle7 delete();
	shuffle8 delete();

}

deathtrigger()
{
trigger=getent("death_trigger","targetname");

	while(1)
	{
	trigger waittill("trigger",player);
	player thread diezor();
	}
}

diezor()
{
	// self PlaySoundToPlayer("die", self );
	self suicide();
}

escalator()
{
end=(-1032,3760,60);
start=(56,3760,435);
escalator1=getent("escalator1","targetname");
escalator2=getent("escalator2","targetname");
escalator3=getent("escalator3","targetname");
escalator4=getent("escalator4","targetname");
escalator1 notsolid();
escalator1 hide();
escalator2 notsolid();
escalator2 hide();
escalator3 notsolid();
escalator3 hide();
escalator4 notsolid();
escalator4 hide();
trigger=getent("act8","targetname");
trigger waittill("trigger", player);
thread escal1(end,start);
thread escal2(end,start);
thread escal3(end,start);
thread escal4(end,start);
}

escal1(end,start)
{
escalator1=getent("escalator1","targetname");
escalator1 moveto(start,1);
while(1)
{
escalator1 solid();
escalator1 show();
escalator1 moveto(end,4);
wait 4;
escalator1 movez(-60,0.5);
wait 0.5;
escalator1 notsolid();
escalator1 hide();
escalator1 moveto(start,0.5);
wait 0.5;
}
}

escal2(end,start)
{
escalator1=getent("escalator2","targetname");
wait 1;
escalator1 moveto(start,1);
while(1)
{
escalator1 solid();
escalator1 show();
escalator1 moveto(end,4);
wait 4;
escalator1 movez(-60,0.5);
wait 0.5;
escalator1 notsolid();
escalator1 hide();
escalator1 moveto(start,0.5);
wait 0.5;
}
}

escal3(end,start)
{
escalator1=getent("escalator3","targetname");
wait 2;
escalator1 moveto(start,1);
while(1)
{
escalator1 solid();
escalator1 show();
escalator1 moveto(end,4);
wait 4;
escalator1 movez(-60,0.5);
wait 0.5;
escalator1 notsolid();
escalator1 hide();
escalator1 moveto(start,0.5);
wait 0.5;
}
}

escal4(end,start)
{
escalator1=getent("escalator4","targetname");
wait 3;
escalator1 moveto(start,1);
while(1)
{
escalator1 solid();
escalator1 show();
escalator1 moveto(end,4);
wait 4;
escalator1 movez(-60,0.5);
wait 0.5;
escalator1 notsolid();
escalator1 hide();
escalator1 moveto(start,0.5);
wait 0.5;
}
}
