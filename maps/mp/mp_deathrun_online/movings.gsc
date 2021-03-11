main()
{

	thread crate_1();
	thread crate_1_move();
	thread crate_2();
	thread crate_2_move();
	thread crate_3();
	thread crate_3_move();
	thread raft();
	thread circle();
	thread elevator();
	thread bouncer();
	thread secret_move();
}

secret_move()
{
	target = getEnt ( "secret_move", "targetname" );
	
	while(1)
	{
		target moveZ ( 96, 3, 2, 1);
		wait 4;
		target moveZ ( -96, 3, 2, 1);
		wait 4;
	}
}

crate_1()
{
	target = getEnt ( "crate_1", "targetname" );
	
	while(1)
	{
		target moveZ ( -7, 4);
		wait 4;
		target moveZ ( 7, 4);
		wait 4;
	}
}
crate_1_move()
{
	target = getEnt ( "crate_1", "targetname" );
	
	while(1)
	{
		target rotateYaw ( 4, 7);
		wait 7.3;
		target rotateYaw ( -4, 7);
		wait 7.3;
	}
}

crate_2()
{
	target = getEnt ( "crate_2", "targetname" );
	
	while(1)
	{
		target moveZ ( -8, 5);
		wait 5;
		target moveZ ( 8, 5);
		wait 5;
	}
}

crate_2_move()
{
	target = getEnt ( "crate_2", "targetname" );
	
	while(1)
	{
		target rotateYaw ( -3, 7);
		wait 7;
		target rotateYaw ( 3, 7);
		wait 7;
	}
}

crate_3()
{
	target = getEnt ( "crate_3", "targetname" );
	
	while(1)
	{
		target moveZ ( -6, 3);
		wait 3;
		target moveZ ( 6, 3);
		wait 3;
	}
}

crate_3_move()
{
	target = getEnt ( "crate_3", "targetname" );
	
	while(1)
	{
		target rotateYaw ( -4, 8);
		wait 8.1;
		target rotateYaw ( 4, 7);
		wait 8.1;
	}
}

raft()
{
	target = getEnt ( "trap_2_target", "targetname" );
	
	while(1)
	{
		target rotateYaw ( -5, 8);
		wait 8.1;
		target rotateYaw ( 5, 8);
		wait 8.1;
	}
}
	
circle()
{
	target = getEnt ( "circle", "targetname" );
	
	target delete();
}

elevator()
{
	target = getEnt ( "elevator_1", "targetname" );
	trigger = getEnt ( "elevator_1_trigger", "targetname" );
	shit = getEnt ( "elevator_1_shit", "targetname" );
	
	trigger waittill ( "trigger", player );
	trigger delete();
	
	shit LinkTo ( target );
	wait 1;
	
	while(1)
	{
		target moveTo (( 2904, 2440, -250 ), 6, 3, 1);
		thread elevator_rotate();
		wait 8;
		target moveTo (( 3272, 1880, -224 ), 6, 3, 1);
		wait 8;
	}
}

elevator_rotate()
{
	target = getEnt ( "elevator_1", "targetname" );
	
	while(1)
	{
		target rotateYaw ( -90, 6, 3, 1);
		wait 8;
		target rotateYaw ( 90, 6, 3, 1);
		wait 8;
	}
}

bouncer(who)
{
	trigger = getEnt ( "bouncer", "targetname" );
	
	while(1)
	{
    	trigger waittill ( "trigger", who );
	
	    oldpos = who.origin;
		playFx ( level.bounce, who.origin );
	    strenght = 3;
	    for(i=0;i<strenght;i++)
	    {
	        who.health += 160;
            who finishPlayerDamage(who, level.jumpattacker, 160, 0, "MOD_FALLING", "jump_mp", who.origin, AnglesToForward((-90,0,0)), "none", 0);
	    }
	}
}