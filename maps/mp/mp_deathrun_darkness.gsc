/*
	I know that this script sux and is horribly shitty
	but i was in hurry so thats why its all big mess.
	Script written in 20 minutes, LOL.

	BraX.
	Xfire: maciusiak
*/

main()
{
	thread sr\api\_defrag::weapons("");
thread sr\api\_map::createSpawnOrigin((-4, -197, 0), 90);
level.spawn["allies"] = getEntArray("mp_jumper_spawn", "classname");
if (!level.spawn["allies"].size)
	level.spawn["allies"] = getEntArray("mp_dm_spawn", "classname");
trigger = spawn( "trigger_radius", (985.723, -587.125, 16.125), 0, 96, 48 );
trigger.targetname = "endmap_trig";
trigger.radius = 96;
	maps\mp\_load::main();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	level.trap1 = getEnt( "trap1", "targetname" );
	level.trap1_trig = getEnt( "t1", "targetname" );

	level.mover1 = getEnt( "mover1", "targetname" );
	level.pusher = getEnt( "pusher", "targetname" );
	level.pusher_trig = getEnt( "t2", "targetname" );
	level.c1 = getEnt( "cylinder1", "targetname" );
	level.c2 = getEnt( "cylinder2", "targetname" );
	level.c3 = getEnt( "cylinder3", "targetname" );
	level.c1_trig = getEnt( "t5", "targetname" );
	level.c2_trig = getEnt( "t6", "targetname" );
	level.c3_trig = getEnt( "t7", "targetname" );
	level.ft_trig = getEntArray( "t3", "targetname" )[0];
	level.ft1 = getEntArray( "fallTrap1", "targetname" );
	level.ft2 = getEntArray( "fallTrap2", "targetname" );
	level.pusher = getEnt( "pusher", "targetname" );
	level.pusher_trig = getEnt( "t2", "targetname" );
	level.pusher2 = getEnt( "mover2", "targetname" );
	level.pusher2_trig = getEnt( "t4", "targetname" );
	level.door = getEnt( "door", "targetname" );
	level.door_trig = getEnt( "openDoor", "targetname" );

	thread way_connect();

	//thread firstTrap();
	//thread rotateCylinder1();
	//thread rotateCylinder2();
	//thread rotateCylinder3();
	thread goMover();
	//thread goPusher();
	//thread fallTrap();
	//thread goSecondMover();
	//thread openDoor();
}

way_connect()
{
    wait 0.05;

    sr\api\_speedrun::createNormalWays("Normal Way;");

    for(;;)
    {
        level waittill( "connected", player );

    }
}


openDoor()
{
	level.door_trig waittill( "trigger" );
	level.door_trig delete();
	brush = level.door;
	brush moveZ( 120, 7 );
}

goSecondMover()
{
	level.pusher2_trig waittill( "trigger" );

}

fallTrap()
{
	level.ft_trig waittill( "trigger" );
}

firstTrap()
{
	level.trap1_trig waittill( "trigger" );

}

goPusher()
{
	level.pusher_trig waittill( "trigger" );

}

goMover()
{
	brush = level.mover1;
	points = [];
	points[points.size] = getEnt( brush.target, "targetname" ).origin;
	points[points.size] = brush.origin;
	wait .05;
	while(1)
	{
		brush moveTo( points[0], 2 );
		wait 3;
		brush moveTo( points[1], 2 );
		wait 3;
	}
}

rotateCylinder1()
{
	level.c1_trig waittill( "trigger" );

}
rotateCylinder2()
{
	level.c2_trig waittill( "trigger" );

}

rotateCylinder3()
{
	level.c3_trig waittill( "trigger" );

}