//////////////////////////////////////////////////
////////////| mp_deathrun_underworld |////////////
//////////////////////////////////////////////////
//////////////| map made by Icomar |//////////////
//////////////////////////////////////////////////
///////////////| xFire: icomar727 |///////////////
//////////////////////////////////////////////////
///////////////| Thanks to: Blade |///////////////
//////////////////////////////////////////////////



main()
{

	thread trap_1();
	thread trap_2();
	thread trap_3();
	thread trap_4();
	thread trap_5();
	thread trap_6();
	thread trap_7();
	thread trap_8();
	thread trap_9();
	thread trap_10();
	thread trap_11();

}

trap_1()
{
    trigger = getEnt ("trap_1_trigger", "targetname");
	trap_1 = getEnt ("trap_1_1", "targetname");
	trap_2 = getEnt ("trap_1_2", "targetname");
	trap_3 = getEnt ("trap_1_3", "targetname");
	trap_4 = getEnt ("trap_1_4", "targetname");
	trap_5 = getEnt ("trap_1_5", "targetname");
	
	trigger waittill ("trigger", player );
	trigger delete();
	
	while (1)
	{
	    trap_1 rotatePitch (360, 1.5);
		wait 1;
		trap_2 rotatePitch (360, 1.5);
		wait 1;
		trap_3 rotatePitch (360, 1.5);
		wait 1;
		trap_4 rotatePitch (360, 1.5);
		wait 1;
		trap_5 rotatePitch (360, 1.5);
		wait 1;
	}
}

trap_2()
{
    trigger = getEnt ("trap_2_trigger", "targetname");
	trap_1 = getEnt ("trap_2_1", "targetname");
	trap_2 = getEnt ("trap_2_2", "targetname");
	
	trigger waittill ("trigger", player );
	trigger delete();
	
	while (1)
	{
	    trap_1 moveZ (-80, 3);
		trap_2 moveZ (30, 3);
		wait 3;
		trap_1 moveZ (110, 6);
		trap_2 moveZ (-110, 6);
		wait 6;
		trap_1 moveZ (-30, 3);
		trap_2 moveZ (80, 3);
		wait 3;
	}
}

trap_3()
{
    trigger = getEnt ("trap_3_trigger", "targetname");
	trap = getEnt ("trap_3", "targetname");
	
	trigger waittill ("trigger", player );
	trigger delete();
	
	while (1)
	{
	    trap moveY (-192, 2);
		wait 3;
		trap moveY (192, 2);
		wait 3;
		trap moveY (-192, 2);
		wait 3;
		trap moveY (192, 2);
		wait 8;
	}
}

trap_4()
{
    trigger = getEnt ("trap_4_trigger", "targetname");
	trap = getEnt ("trap_4", "targetname");
	
	trigger waittill ("trigger", player );
	trigger delete();
	
	wait 1;
	trap delete();
}

trap_5()
{
    trigger = getEnt ("trap_5_trigger", "targetname");
	trap_1 = getEnt ("trap_5_1", "targetname");
	trap_2 = getEnt ("trap_5_2", "targetname");
	
	trigger waittill ("trigger", player );
	trigger delete();
	
	while (1)
	{
	    trap_1 moveY (56, 2);
		trap_2 moveY (-56, 2);
		wait 2;
		trap_1 moveY (-56, 2);
		trap_2 moveY (56, 2);
		wait 2;
	}
}

trap_6()
{
    trigger = getEnt ("trap_6_trigger", "targetname");
	trap_1 = getEnt ("trap_6_1", "targetname");
	trap_2 = getEnt ("trap_6_2", "targetname");
	
	trigger waittill ("trigger", player );
	trigger delete();
	
	while (1)
	{
	    trap_1 moveX (-112, 1);
		trap_2 moveX (92, 1);
		wait 1;
		trap_1 moveX (112, 1);
		trap_2 moveX (-92, 1);
		wait 1;
	}
}

trap_7()
{
    trigger = getEnt ("trap_7_trigger", "targetname");
	trap_1 = getEnt ("trap_7_1", "targetname");
	trap_2 = getEnt ("trap_7_2", "targetname");
	trap_3 = getEnt ("trap_7_3", "targetname");
	trap_4 = getEnt ("trap_7_4", "targetname");
	trap_5 = getEnt ("trap_7_5", "targetname");
	trap_6 = getEnt ("trap_7_6", "targetname");
	
	trigger waittill ("trigger", player );
	trigger delete();
	
	while (1)
	{
	    trap_1 rotateYaw (360, 2);
		trap_2 rotateYaw (-360, 2);
		trap_3 rotateYaw (360, 2);
		trap_4 rotateYaw (-360, 2);
		trap_5 rotateYaw (360, 2);
		trap_6 rotateYaw (-360, 2);
		wait 2;
	}
}

trap_8()
{
    trigger = getEnt ("trap_8_trigger", "targetname");
	target = getEnt ("trap_8", "targetname");
	
	trigger waittill ("trigger", player );
	trigger delete();
	
	while (1)
	{
	    target rotateRoll (360, 3);
		wait 3;
	}
}

trap_9()
{
    trigger = getEnt ("trap_9_trigger", "targetname");
	target_1 = getEnt ("trap_9_1", "targetname");
	target_2 = getEnt ("trap_9_2", "targetname");
	target_3 = getEnt ("trap_9_3", "targetname");
	target_4 = getEnt ("trap_9_4", "targetname");
	target_5 = getEnt ("trap_9_5", "targetname");
	target_6 = getEnt ("trap_9_6", "targetname");
	
	trigger waittill ("trigger", player );
	trigger delete();
	
	while (1)
	{
	    target_1 moveZ (-256, 3);
		target_4 moveZ (-256, 3);
		wait 4;
		target_1 moveZ (256, 3);
		target_4 moveZ (256, 3);
		wait 3;
		target_2 moveZ (-256, 3);
		target_4 moveZ (-256, 3);
		target_6 moveZ (-256, 3);
		wait 4;
		target_2 moveZ (256, 3);
		target_4 moveZ (256, 3);
		target_6 moveZ (256, 3);
		target_5 moveZ (-256, 3);
		target_3 moveZ (-256, 3);
		wait 4;
		target_5 moveZ (256, 3);
		target_3 moveZ (256, 3);
		target_1 moveZ (-256, 3);
		target_2 moveZ (-256, 3);
		target_6 moveZ (-256, 3);
		wait 4;
		target_1 moveZ (256, 3);
		target_2 moveZ (256, 3);
		target_6 moveZ (256, 3);
		wait 4;
		target_1 moveZ (-256, 3);
		target_3 moveZ (-256, 3);
		target_5 moveZ (-256, 3);
		wait 4;
		target_1 moveZ (256, 3);
		target_3 moveZ (256, 3);
		target_5 moveZ (256, 3);
		target_2 moveZ (-256, 3);
		target_4 moveZ (-256, 3);
		target_6 moveZ (-256, 3);
		wait 4;
		target_2 moveZ (256, 3);
		target_4 moveZ (256, 3);
		target_6 moveZ (256, 3);
		wait 4;
	}
}

trap_10()
{
    trigger = getEnt ("trap_10_trigger", "targetname");
	target_1 = getEnt ("trap_10_target_1", "targetname");
	target_2 = getEnt ("trap_10_target_2", "targetname");
	
	trigger waittill ("trigger", player );
	trigger delete();
	
	target_1 moveY (-128, 3);
	
	while (1)
	{
	    target_2 rotateYaw (360, 3);
		wait 7;
	}
}

trap_11()
{
    trigger = getEnt ("trap_11_trigger", "targetname");
	barrel = getEnt ("trap_11_target", "targetname");
	clip = getEnt ("trap_11_clip", "targetname");
	target = getEnt ("trap_11", "targetname");
	c4 = getEnt ("c4", "targetname");
	
	trigger waittill ("trigger", player );
	trigger delete();
	wait 0.1;
	clip delete();
	wait 1;
	
	playFx ( level.explosion_barrel, target.origin );
	wait 0.1;
	barrel delete();
	c4 delete();
	playFx ( level.mine, target.origin );
	wait 0.1;
	playFx ( level.explosion, target.origin );
	wait 0.1;
	earthquake ( 1, 1, target.origin, 500 );
	wait 0.1;
	
	players = getEntArray( "player", "classname" );	
    for(k=0;k<players.size;k++)
    {
	    dist = Distance2D(players[k].origin, target.origin);
	    if(dist < 190)
	    {
		    players[k] suicide();
	    }
	    else if(dist < 240)
	    {
		    RadiusDamage( players[k].origin, 10, 60, 40);
	    }
	    else if(dist < 320)
	    {
		    RadiusDamage( players[k].origin, 10, 30, 10);
		}
	}
}