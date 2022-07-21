//Map Made and Scripted by Darmuh.
//Created for Braxi's Deathrun mod for CoD4
//novacrew.eu, afterlifegaming.net, and braxi.org (braxi.boo.pl)
//If you have decompiled this, dascoolbro. :>
//________                                ______
//___  __ \_____ ______________ _______  ____  /_
//__  / / /  __ `/_  ___/_  __ `__ \  / / /_  __ \
//_  /_/ // /_/ /_  /   _  / / / / / /_/ /_  / / /
///_____/ \__,_/ /_/    /_/ /_/ /_/\__,_/ /_/ /_/


main()
{
thread sr\api\_map::createSpawn((-443.875, 556, 64.125), 270);
 maps\mp\_load::main();

 /*
 precacheItem("knife_mp");
 precacheItem("cherry_bo_L96_mp");
 precacheItem("cherry_sword_mp");
 precacheItem("cherry_minigun_mp");
 precacheModel( "playermodel_terminator" );
 precacheModel( "playermodel_aot_rosco_00_light" );
 */

 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"] = "desert";

 setdvar( "r_specularcolorscale", "1" );
 setdvar("r_glowbloomintensity0",".25");
 setdvar("r_glowbloomintensity1",".25");
 setdvar("r_glowskybleedintensity0",".3");
 setdvar("compassmaxrange","1800");


 level.darmuh = "Darmuh"; //It's quite pointless to take my name but if you really want to use it you'll get a gold deagle rather than a normal deagle.
 level.irroy8 = "irRoy8";
 level.bjump1 = getEnt( "jb1", "targetname" );
 level.bacti1 = getEnt( "ab1", "targetname" );
 level.bjump2 = getEnt( "jb2", "targetname" );
 level.bacti2 = getEnt( "ab2", "targetname" );
 level.bjump3 = getEnt( "jb3", "targetname" );
 level.bacti3 = getEnt( "ab3", "targetname" );
 level._spraysion[ "Sprode" ] = loadfx( "explosions/aerial_explosion_large" );
 level.firstenter=true;

/*
addTriggerToList( "t1use" );
addTriggerToList( "t2use" );
addTriggerToList( "t3use" );
addTriggerToList( "t4use" );
addTriggerToList( "t5use" );
addTriggerToList( "t6use" );
addTriggerToList( "t7use" );
addTriggerToList( "t8use" );
addTriggerToList( "t9use" );
addTriggerToList( "t10use" );
addTriggerToList( "t11use" );
addTriggerToList( "t12use" );
addTriggerToList( "t13use" );
*/
thread way_connect();
/*
thread trap1();
thread mtrap2();
thread trap2();
thread trap3();
thread trap4();
thread trap5();
thread trap6();
thread trap7();
thread trap8();
thread trap9();
thread trap10();
thread trap11();
thread trap12();
thread trap13();
*/
thread movefirst();
thread gmove1();
thread gmove2();
thread gmove3();
thread gmove4();
thread elevator();
thread platform1();
thread platform2();
thread platform3();
thread rblocks();
//thread OldRoom();
// thread stahp();
// thread wutru();
// thread doing();
//thread sniperoom();
//thread snipevator();
thread snipehover();
thread ammo();
//thread knifewwroom();
//thread kniferoom();
thread srct();
thread srctfail();
// thread secsee();
//thread jumproom();
thread jumpreset1();
thread jumpreset2();
thread jumpreset3();
//thread sprayroom();
thread startbutton();
thread startdoor();
thread signs();
//thread spam();
//thread dynamic_wep_dmg(); Moved to inside spray room thread (Scripted by Duffman)
//thread deagle();
//thread dogroom();
//thread yayufinished();

 brush = getEnt( "t1rotate", "targetname" );
 brush delete();

 brush2 = getEnt( "t5r2", "targetname" );
 brush2 RotateYaw(45,0.1);

 brush3 = getEnt( "t5r1", "targetname" );
 brush3 RotateYaw(90,0.1);
brush3.origin = (-400,-2269,760);

 brush4 = getEnt( "lasthole", "targetname" );
 brush4 delete();

object = getent("olddoor", "targetname");
object delete();
thread checktele();

}


////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;

    sr\api\_speedrun::createNormalWays("Cherry Way;");
	sr\api\_speedrun::createSecretWays("Secret Way;");

    for(;;)
    {
        level waittill( "connected", player );


    }
}
////////////////////////////////////////////////////////////////////////////////////////////////

checktele()
{
	end = getent("secorg", "targetname");
	while(1)
	{
		players = getentarray("player", "classname");
		for(i = 0; i<players.size; i++)
		{
			if( players[i].origin[0] > -1009 && players[i].origin[0] < -870  && players[i].origin[1] < -1979 && players[i].origin[1] > -2593 && players[i].origin[2] > 0 && players[i].origin[2] < 130 )
			{
				players[i] thread checktele_do();
			}

		}
		wait 0.05;
	}
}

checktele_do()
{
	self endon("disconnect");

	end = getent("secorg", "targetname");

	self freezecontrols(1);
	self setplayerangles( end.angles, 3 );
	self setorigin( end.origin , 3 );
	wait 0.05;
	self freezecontrols(0);
}

dynamic_wep_dmg() //(c)Duffman
{
	for(i=5;i<20;i++)//15 diffent steps
	{
		setDvar("dr_damageMod_cherry_minigun_mp", i / 5);
		wait 30 * 3;	//changed as I was getting an error saying "undefined is not an array string or vector" using wait level.dvar["time_limit"] * 3; I tried other dvars without success.
	}
}


srct()
{
 trig = getent("secfin", "targetname");
 end = getent("secorg", "targetname");

	for(;;)
	{
		trig waittill ( "trigger", player );
		player sr\api\_speedrun::changeWay("secret_0"); //Speedrun Copy Paste
		player thread end_wait();
		// player setplayerangles( end.angles, 3 );
		// player setorigin( end.origin , 3 );
	}
}

end_wait()
{
	wait 0.05;
self thread sr\api\_speedrun::finishWay("secret_0");
}

secsee()
{
    trig = getent("secfin", "targetname");

    for(;;)
    {
	trig waittill ("trigger", player);
    }
}

srctfail()
{
 trig = getent("reset", "targetname");
 end = getent("secforg", "targetname");

	for(;;)
	{
		trig waittill ( "trigger", player );
		player setplayerangles( end.angles, 3 );
		player setorigin( end.origin, 3 );
	}
}

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

ambient()
{

}

signs()
{
 brusha = getent( "sign1", "targetname" );
 brushb = getent( "sign2", "targetname" );
 brushc = getent( "sign3", "targetname" );

	for(;;)
	{
	    brusha show();
	    brushc hide();
	    brushc notsolid();
	    brushb hide();
	    brushb notsolid();
	    wait 4;
	    brusha hide();
	    brusha notsolid();
	    brushc hide();
	    brushc notsolid();
	    brushb show();
	    brushb solid();
	    wait 4;
	    brushb hide();
	    brushb notsolid();
	    brushb hide();
	    brushb notsolid();
	    brushc show();
	    brushc solid();
	    wait 4;
	}
}

startbutton()
{
 trig = getent("startbutton", "targetname");
 level.dermuh = "ffbb9d529c5fbeb275d1fcf8aedc2203";
 brush = getent("button", "targetname");

}

startdoor()
{
  brush = getent("startdoor", "targetname");
	brush delete();
}
hover()
{
 acti = getent("acticherry", "targetname");

    for(;;)
    {
	acti movez ( -20, 1 );
	acti waittill ("movedone");
	acti movez ( 20, 1 );
	acti waittill ("movedone");
    }
}

gmove1()
{
 brush = getent("t5m1", "targetname");
 brush delete();
}

gmove2()
{
 brush = getent("t5m2", "targetname");

brush delete();
}

gmove4()
{
 brush = getent("t5m4", "targetname");
 brush delete();
}

gmove3()
{
 brush = getent("t5m3", "targetname");

   brush delete();
}

rblocks()
{
 brush = getent( "t1r2", "targetname" );
 /*
	for(;;)
	{
	    brush rotateyaw( 360,25);
	    wait 10;
	}
	*/
}

trap1()
{
 trig = getEnt( "t1use", "targetname" );
 brush = getEnt( "t1rotate", "targetname" );
 ent = getEnt( "trap1_sound", "targetname" );

     trig waittill( "trigger", who );
     trig delete();
     who playsound ( "bttn" );

	for(;;)
	{
	    brush rotateyaw( -360, 5);
	    ent playsound ( "fan" );
	    wait 1.1;
	}
}

mtrap2()
{
 acti = getent("acticherry", "targetname");
 orgn = getent("t2m", "targetname");
 trig = getent("t1mt", "targetname");


	trig waittill( "trigger", who );
	trig delete();
	who playsound ( "bttn" );
	wait 2;
		acti moveto (orgn.origin, 2);
		acti rotateto (orgn.angles, 2);
		acti waittill ("movedone");
		thread mtrap3();


}

trap2()
{
 trig = getEnt( "t2use", "targetname" );
 brush = getEnt( "t2rtate", "targetname" );
 solid = getent( "tss1", "targetname");

     trig waittill( "trigger", who );
     trig delete();
     solid notsolid();
     solid hide();
     who playsound ( "bttn" );

	for(;;)
	{
	    brush rotatepitch( -360, 4);
	    wait 4;
	}
}

mtrap3()
{
 acti = getent("acticherry", "targetname");
 orgn = getent("t3m", "targetname");
 trig = getent("t2mt", "targetname");


	trig waittill( "trigger", who );
	trig delete();
	who playsound ( "bttn" );
	wait 2;
		acti moveto (orgn.origin, 2);
		acti rotateto (orgn.angles, 2);
		acti waittill ("movedone");
		thread mtrap4();


}

trap3()
{
 trig = getEnt( "t3use", "targetname" );

     trig waittill( "trigger", who );
     trig delete();
     who playsound ( "bttn" );

		for(;;) //I tried RandomInts. I just suck with em. I might try em again in my next map.
		{
			thread trap3a();
			wait 1.1;
			thread trap3b();
			wait 1.1;
			thread trap3c();
			wait 1.1;
			thread trap3b();
			wait 1.1;
			thread trap3a();
			wait 1.1;
			thread trap3c();
			wait 1.1;
			thread trap3c();
			wait 1.1;
			thread trap3b();
			wait 1.1;
			thread trap3a();
			wait 1.1;
		}
}

trap3a()
{
 brush = getent( "t3rtate", "targetname" );

	 brush movez(-400, 0.25);
	 wait 0.5;
	 brush movez(400, 0.25);
	 wait 0.5;
}

trap3b()
{
 brush = getent( "t3rtate2", "targetname" );

	 brush movez(-400, 0.25);
	 wait 0.5;
	 brush movez(400, 0.25);
	 wait 0.5;
}
trap3c()
{
 brush = getent( "t3rtate3", "targetname" );

	 brush movez(-400, 0.25);
	 wait 0.5;
	 brush movez(400, 0.25);
	 wait 0.5;
}

mtrap4()
{
 acti = getent("acticherry", "targetname");
 orgn = getent("t4m", "targetname");
 trig = getent("t3mt", "targetname");


	trig waittill( "trigger", who );
	trig delete();
	who playsound ( "bttn" );
	wait 2;
		acti moveto (orgn.origin, 2);
		acti rotateto (orgn.angles, 2);
		acti waittill ("movedone");
		thread mtrap5();


}

trap4()
{
 trig = getEnt( "t4use", "targetname" );

     trig waittill( "trigger", who );
     trig delete();
     who playsound ( "bttn" );

	thread trap4a();
	thread trap4b();
	thread trap4c();
	thread trap4d();
	thread trap4e();
	thread trap4f();
	thread trap4g();
}

trap4a()
{
 brush = getEnt( "t4r1", "targetname" );

	for(;;)
	{
	    brush rotateyaw( 360, 3);
	    wait 3;
	}
}

trap4b()
{
 brush = getEnt( "t4r2", "targetname" );

	for(;;)
	{
	    brush rotateyaw( 360, 3);
	    wait 3;
	}
}

trap4c()
{
 brush = getEnt( "t4r3", "targetname" );

	for(;;)
	{
	    brush rotateyaw( 360, 3);
	    wait 3;
	}
}

trap4d()
{
 brush = getEnt( "t4r4", "targetname" );

	for(;;)
	{
	    brush rotateyaw( -360, 4);
	    wait 4;
	}
}

trap4e()
{
 brush = getEnt( "t4r5", "targetname" );

	for(;;)
	{
	    brush rotateyaw( -360, 4);
	    wait 4;
	}
}
trap4f()
{
 brush = getEnt( "t4r6", "targetname" );

	for(;;)
	{
	    brush rotateyaw( -360, 4);
	    wait 4;
	}
}

trap4g()
{
 brush = getEnt( "t4ud", "targetname" );

	for(;;)
	{
	    brush movez( 50, 2 );
	    wait 2;
	    brush movez( -50, 2 );
	    wait 2;
	}
}

mtrap5()
{
 acti = getent("acticherry", "targetname");
 orgn = getent("t5m", "targetname");
 trig = getent("t4mt", "targetname");


	trig waittill( "trigger", who );
	trig delete();
	who playsound ( "bttn" );
	wait 2;
		acti moveto (orgn.origin, 2);
		acti rotateto (orgn.angles, 2);
		acti waittill ("movedone");
		thread mtrap6();

}

trap5()
{
 trig = getEnt( "t5use", "targetname" );

     trig waittill( "trigger", who );
     trig delete();
     who playsound ( "bttn" );

	thread trap5a();
	thread trap5b();
	thread trap5c();
}

trap5a()
{
 brush = getEnt( "t5r1", "targetname" );
 sound = getent( "trap5_sound1", "targetname" );

	sound thread machinesound();

	for(;;)
	{
	    brush rotateroll( 360, 4 );
	    brush waittill ("rotatedone");
	}
}

trap5b()
{
 brush = getEnt( "t5r2", "targetname" );
 sound = getent( "trap5_sound2", "targetname" );

	sound thread machinesound();

	for(;;)
	{
	    brush rotateroll( -360, 3 );
	    brush waittill ("rotatedone");
	}
}

trap5c()
{
 brush = getEnt( "t5r3", "targetname" );
 sound = getent( "trap5_sound3", "targetname" );

	sound thread machinesound();

	for(;;)
	{
	    brush rotateroll( 360, 4 );
	    brush waittill ("rotatedone");
	}
}

machinesound()
{
    for(;;)
    {
	self playsound ( "machine" );
	wait .8;
    }
}
mtrap6()
{
 acti = getent("acticherry", "targetname");
 one = getent("t6mp1", "targetname");
 two = getent("t6mp2", "targetname");
 twe = getent("t6m", "targetname");
 trig = getent("t5mt", "targetname");

	trig waittill( "trigger", who );
	trig delete();
	who playsound ( "bttn" );
	wait 2;
		acti moveto (one.origin, 2);
		acti rotateto (one.angles, 2);
		acti waittill ("movedone");
		acti moveto (two.origin, 2);
		acti rotateto (two.angles, 2);
		acti waittill ("movedone");
		acti moveto (twe.origin, 2);
		acti rotateto (twe.angles, 2);
		acti waittill ("movedone");
		thread mtrap7();
		acti movez ( -20, 900 );
}

trap6()
{
 trig = getent( "t6use" , "targetname");
 brush = getEnt( "t6r1", "targetname" );
 solid = getent( "flohide", "targetname");

     trig waittill( "trigger", who );
     trig delete();
     who playsound ( "bttn" );
     solid notsolid();
     solid hide();

	for(;;)
	{
	    brush rotatepitch( -360, 3);
	    wait 3;
	}
}

mtrap7()
{
 acti = getent("acticherry", "targetname");
 orgn = getent("t7m", "targetname");
 trig = getent("t6mt", "targetname");


	trig waittill( "trigger", who );
	trig delete();
	who playsound ( "bttn" );
	wait 2;
		acti moveto (orgn.origin, 2);
		acti rotateto (orgn.angles, 2);
		acti waittill ("movedone");
		thread mtrap8();


}

trap7()
{
 trig = getEnt( "t7use", "targetname" );
 brush = getEnt( "t7r1", "targetname" );

     trig waittill( "trigger", who );
     trig delete();
     who playsound ( "bttn" );

	for(;;)
	{
	    brush rotateroll( 360, 3);
	    wait 3;
	}
}

mtrap8()
{
 acti = getent("acticherry", "targetname");
 orgn = getent("t8m", "targetname");
 trig = getent("t7mt", "targetname");


	trig waittill( "trigger", who );
	trig delete();
	who playsound ( "bttn" );
	wait 2;
		acti moveto (orgn.origin, 2);
		acti rotateto (orgn.angles, 2);
		acti waittill ("movedone");
		thread mtrap9();


}

trap8()
{
 trig = getEnt( "t8use", "targetname" );
 brush = getEnt( "t8m1", "targetname" );

     trig waittill( "trigger", who );
     trig delete();
     who playsound ( "bttn" );

	    brush movez( -500, 1 );
	    wait 5;
	    brush movez( 500, 8 );


}

mtrap9()
{
 acti = getent("acticherry", "targetname");
 orgn = getent("t9m", "targetname");
 trig = getent("t8mt", "targetname");


	trig waittill( "trigger", who );
	trig delete();
	who playsound ( "bttn" );
	wait 2;
		acti moveto (orgn.origin, 2);
		acti rotateto (orgn.angles, 2);
		acti waittill ("movedone");
		thread mtrap10();


}

trap9()
{
 trig = getEnt( "t9use", "targetname" );
 brush = getEnt( "t9rollers", "targetname" );
 ent = getent( "rollersound1", "targetname" );
 org = getent( "rollersound2", "targetname" );

	trig waittill( "trigger", who );
	trig delete();
	who playsound ( "bttn" );

	    for( i = 0; i < 8; i++ )
	    {
		brush rotateroll( 720, 4);
		ent thread mr12();
		org thread mr12();
		wait 10;
	    }
}

mr12()
{
    count = 5;
    while(count > 0)
    {
	self playsound ( "mrl2" );
	wait .8;
	count--;
    }
}

mtrap10()
{
 acti = getent("acticherry", "targetname");
 orgn = getent("t10m", "targetname");
 trig = getent("t9mt", "targetname");


		trig waittill( "trigger", who );
		trig delete();
		who playsound ( "bttn" );
		wait 2;
		acti moveto (orgn.origin, 2);
		acti rotateto (orgn.angles, 2);
		acti waittill ("movedone");
		thread mtrap11();


}

trap10()
{
	trig = getent ("t10use", "targetname");
	objecta = getent ("t10m1", "targetname");
	objectb = getent ("t10m2", "targetname");
	ent = getent ("launchsound1", "targetname");
	org = getent ("launchsound2", "targetname");

		trig waittill( "trigger", who );
		trig delete();
		who playsound ( "bttn" );
		wait (0.2);
		ent playsound ( "launch" );
		org playsound ( "launch" );
		objecta movez (20,0.1);
		objectb movez (600, 1);
		objectb waittill ("movedone");
		objectb notsolid();
		objecta movez (-20,2);
}

mtrap11()
{
 acti = getent("acticherry", "targetname");
 orgn = getent("t11m", "targetname");
 trig = getent("t10mt", "targetname");
 prgn = getent("p10m", "targetname");

	trig waittill( "trigger", player );
	trig delete();
	player playsound ( "bttn" );
	wait 2;
		acti moveto (orgn.origin, 0.1);
		acti rotateto (orgn.angles, 0.1);
		acti waittill ("movedone");
		thread mtrap12();

}

trap11()
{
 trig = getent ("t11use", "targetname");
 objecta = getent ("low", "targetname");

	trig waittill( "trigger", who );
	trig delete();
	who playsound ( "bttn" );

	for(;;)
	{
		objecta movey (600,1);
		objecta playsound ( "zip" );
		wait 1;
		wait 3;
		objecta movey (-600,1);
		objecta playsound ( "zip" );
		wait 1;
		wait 3;
	}
}

mtrap12()
{
 acti = getent("acticherry", "targetname");
 orgn = getent("t12m", "targetname");
 trig = getent("t11mt", "targetname");


		trig waittill( "trigger", who );
		trig delete();
		who playsound ( "bttn" );
		wait 2;
		acti moveto (orgn.origin, 2);
		acti rotateto (orgn.angles, 2);
		acti waittill ("movedone");
		thread mtrap13();


}

trap12()
{
 trig = getent ("t12use", "targetname");

	trig waittill( "trigger", who );
	trig delete();
	who playsound ( "bttn" );

	thread trap12a();
	thread trap12b();
	thread trap12c();
}

trap12a()
{
 spin = getent ("spin1", "targetname");

	for(;;)
	{
	spin rotateyaw (360,6);
	wait 6;
	}
}

trap12b()
{
 spin = getent ("spin2", "targetname");

	for(;;)
	{
	spin rotateyaw (-360,3);
	wait 3;
	}
}

trap12c()
{
 spin = getent ("t12r1", "targetname");

	for(;;)
	{
	spin rotateroll (360,4.5);
	wait 4.5;
	}
}

mtrap13()
{
 acti = getent("acticherry", "targetname");
 orgn = getent("t13m", "targetname");
 trig = getent("t12mt", "targetname");


		trig waittill( "trigger", who );
		trig delete();
		who playsound ( "bttn" );
		wait 2;
		acti moveto (orgn.origin, 2);
		acti rotateto (orgn.angles, 2);
		acti waittill ("movedone");
		thread mtrap14();


}

trap13()
{
 trig = getEnt( "t13use", "targetname" );
 brush = getEnt( "trap13", "targetname" );

	trig waittill( "trigger", who );
	trig delete();
	who playsound ( "bttn" );

	    for( ;; )
	    {
		brush rotateroll( 180, 2);
		wait 3;
		brush rotateroll( -180, 2);
		wait 3;
		wait 5;
	    }
}

mtrap14()
{
 acti = getent("t14m", "targetname");
 cherry = getent("acticherry", "targetname");
 orgn = getent("t14m", "targetname");
 trig = getent("t13mt", "targetname");

	trig waittill( "trigger", who );
	trig delete();
	who playsound ( "bttn" );
	wait 2;
		cherry rotateto (orgn.angles, 2);
		cherry waittill ("movedone");

}


movefirst()
{
 acti = getent("acticherry", "targetname");
 orgn = getent("t1m", "targetname");
 trig = getent("cherrystart", "targetname");

	trig waittill( "trigger", who );
	trig delete();
	orgn playsound ( "bttn" );
	acti moveto (orgn.origin, 2);
	acti rotateto (orgn.angles, 2);
	acti waittill ("movedone");
	wait 0.5;
	thread hover();
    thread iminyoserver();
}

kniferoom()
{
 level.knife_trig = getEnt( "knife", "targetname");
 kjump = getEnt( "jumpk", "targetname" );
 kacti = getEnt( "actik", "targetname" );
 expl = getEnt( "meleesion", "targetname" );

        level.knife_trig waittill( "trigger", player );
        if( !isDefined( level.knife_trig ) )
            return;
        if(level.firstenter==true)
		{
		level.snipe_trig delete();
		level.spray_trig delete();
		level.jump_trig delete();
		level.old_trig delete();
		level.sword_trig delete();
		level.dog_trig delete();
		level.firstenter=false;
		}
	AmbientStop( 2 );
	AmbientPlay( "luvkick" );
	player SetPlayerAngles( kjump.angles );
	player setOrigin( kjump.origin );
	player freezeControls(true);
	level.activ freezeControls(true);
	player TakeAllWeapons();
	player giveweapon( "deserteagle_mp");
	player SetWeaponAmmoClip( "deserteagle_mp", 0 );
	player SetWeaponAmmoStock( "deserteagle_mp", 0 );
	level.activ setPlayerangles( kacti.angles );
	level.activ setOrigin( kacti.origin );
	level.activ TakeAllWeapons();
	level.activ giveweapon( "deserteagle_mp");
	level.activ SetWeaponAmmoClip( "deserteagle_mp", 0 );
	level.activ SetWeaponAmmoStock( "deserteagle_mp", 0 );
	player switchToWeapon( "deserteagle_mp" );
	level.activ SwitchToWeapon( "deserteagle_mp" );
	wait 1.9;
	playFx( level._spraysion[ "Sprode" ], expl.origin );
	player freezeControls(false);
	level.activ freezeControls(false);
	iPrintlnBold( " ^5" + player.name + " ^3 picked ^1knife^7!" );
        player thread onDeath_knife();
        wait 0.1;

    for(;;)
    {
                wait .1;
                while(isAlive(player))
                {
                        wait 1;
                }

    }
}

onDeath_knife()
{
        self endon("disconnect");

        self waittill("death");
        thread kniferoom();
}

kickstarts()
{
	wait 10;
	iPrintln( "^7Now Playing: ^3Example - Kickstarts (Bar 9 Remix)" );
}

knifewwroom()
{
 level.sword_trig = getEnt( "knifeww", "targetname");
 kjump = getEnt( "jumpk", "targetname" );
 kacti = getEnt( "actik", "targetname" );
 expl = getEnt( "meleesion", "targetname" );

        level.sword_trig waittill( "trigger", player );
        if( !isDefined( level.sword_trig ) )
            return;
        if(level.firstenter==true)
		{
		level.snipe_trig delete();
		level.spray_trig delete();
		level.jump_trig delete();
		level.old_trig delete();
		level.knife_trig delete();
		level.dog_trig delete();
		level.firstenter=false;
		}
	AmbientStop( 2 );
	AmbientPlay( "luvkick" );
	player SetPlayerAngles( kjump.angles );
	player setOrigin( kjump.origin );
	player freezeControls(true);
	level.activ freezeControls(true);
	wait 1.9;
	playFx( level._spraysion[ "Sprode" ], expl.origin );
	player freezeControls(false);
	level.activ freezeControls(false);
	iPrintlnBold( " ^5" + player.name + " ^3 picked ^1sword^7!" );
	thread kickstarts();
        player thread onDeath_knifeww();
        wait 0.1;

    for(;;)
    {
                wait .1;
                while(isAlive(player))
                {
                        wait 1;
                }

    }
}

onDeath_knifeww()
{
        self endon("disconnect");

        self waittill("death");
        thread knifewwroom();
}

jumproom()
{
 level.jump_trig = getEnt( "bounce", "targetname");
 expl = getEnt( "jumpsion", "targetname" );

    {
        level.jump_trig waittill( "trigger", player );
        if( !isDefined( level.jump_trig ) )
            return;
        if(level.firstenter==true)
		{
		level.snipe_trig delete();
		level.old_trig delete();
		level.sword_trig delete();
		level.knife_trig delete();
		level.spray_trig delete();
		level.dog_trig delete();
		level.firstenter=false;
		}

	AmbientStop( 2 );
	AmbientPlay( "skyfall" );
	player SetPlayerAngles( level.bjump2.angles );
	player setOrigin( level.bjump2.origin );
	player freezeControls(true);
	level.activ freezeControls(true);
	player TakeAllWeapons();

	wait 5.7;
	playFx( level._spraysion[ "Sprode" ], expl.origin );
	player freezeControls(false);
	level.activ freezeControls(false);
	iPrintlnBold( " ^5" + player.name + " ^3 picked ^1Jump^7!" );
	thread intimept();
	thread jumproom2();
    }
}

jumproom2()
{
 level.jump_trig = getEnt( "bounce", "targetname");

 while(1)
    {
        level.jump_trig waittill( "trigger", player );
        if( !isDefined( level.jump_trig ) )
            return;
	player SetPlayerAngles( level.bjump2.angles );
	iPrintlnBold( " ^5" + player.name + " ^3 joined ^1Jump Room^7!" );
    }
}

intimept()
{
	wait 10;
	iPrintln( "^7Now Playing: ^3Skyfall (Clark Kent & Oscar Daniel Remix) " );
}

jumpreset()
{
 trig = getent("broomf", "targetname");

	for(;;)
	{
		trig waittill( "trigger", player );
		if (level.freerun==true)
		{
		    player setplayerangles( level.bjump.angles, 3 );
		    player setorigin( level.bjump.origin, 3 );
		}
		if(player == level.activ)
		{
		    level.activ setPlayerangles( level.bacti.angles );
		    level.activ setOrigin( level.bacti.origin );
		}
		else
		{
		    player setplayerangles( level.bjump.angles, 3 );
		    player setorigin( level.bjump.origin, 3 );
		}
	}
}

jumpreset1(port_allies,port_axis)
{
 trig = getent("broomf", "targetname");

	for(;;)
	{
		trig waittill( "trigger", player );
		if(player.pers["team"] == "axis")
		{
		    level.activ setPlayerangles( level.bacti1.angles );
		    level.activ setOrigin( level.bacti1.origin );
		}
		if(player.pers["team"] == "allies")
		{
		    player setplayerangles( level.bjump1.angles, 3 );
		    player setorigin( level.bjump1.origin, 3 );
		}
	}
}

jumpreset2(port_allies,port_axis)
{
 trig = getent("broomf", "targetname");

	for(;;)
	{
		trig waittill( "trigger", player );
		if(player.pers["team"] == "axis")
		{
		    level.activ setPlayerangles( level.bacti2.angles );
		    level.activ setOrigin( level.bacti2.origin );
		}
		if(player.pers["team"] == "allies")
		{
		    player setplayerangles( level.bjump2.angles, 3 );
		    player setorigin( level.bjump2.origin, 3 );
		}
	}
}

jumpreset3(port_allies,port_axis)
{
 trig = getent("broomf", "targetname");

	for(;;)
	{
		trig waittill( "trigger", player );
		if(player.pers["team"] == "axis")
		{
		    level.activ setPlayerangles( level.bacti3.angles );
		    level.activ setOrigin( level.bacti3.origin );
		}
		if(player.pers["team"] == "allies")
		{
		    player setplayerangles( level.bjump3.angles, 3 );
		    player setorigin( level.bjump3.origin, 3 );
		}
	}
}

platform1()
{
 object = getent("plat1", "targetname");
 end = getent("plat1o", "targetname");
 start = getent("plat1strt", "targetname");
object delete();
}

platform2()
{
 object = getent("plat2", "targetname");
 end = getent("plat2o", "targetname");
 start = getent("plat2strt", "targetname");
object delete();
}

platform3()
{
 object = getent("plat3", "targetname");
 end = getent("plat3o", "targetname");
 start = getent("plat3strt", "targetname");
object delete();
}


elevator()
{
 brush = getent("elevator", "targetname");

     brush delete();
}

OldRoom()
{
 level.old_trig = getEnt( "classic", "targetname");
 object = getent("olddoor", "targetname");
object delete();
}

sniperoom()
{
 level.snipe_trig = getent( "snipe", "targetname");
 level.jsnipe = getEnt( "jsnipe1", "targetname" );
 level.jsnipe = getEnt( "jsnipe2", "targetname" );
 level.asnipe = getEnt( "asnipe1", "targetname" );
 level.asnipe = getent( "asnipe2", "targetname");
 expl = getEnt( "snipesion", "targetname" );




        level.snipe_trig waittill( "trigger", player );
        if( !isDefined( level.snipe_trig ) )
            return;

		if(level.firstenter==true)
		{
		level.spray_trig delete();
		level.knife_trig delete();
		level.sword_trig delete();
		level.jump_trig delete();
		level.old_trig delete();
		level.dog_trig delete();
		level.firstenter=false;
		}
		AmbientStop( 2 );
		AmbientPlay( "skyfall" );
        iPrintlnBold( " ^5" + player.name + " ^3 picked ^1SHNIPAH WAR^7!" );
        player SetPlayerAngles( level.jsnipe.angles );
        player setOrigin( level.jsnipe.origin );
        level.activ setPlayerangles( level.asnipe.angles );
        level.activ setOrigin( level.asnipe.origin );
		player freezeControls(true);
	level.activ freezeControls(true);

	wait 5.7;
	playFx( level._spraysion[ "Sprode" ], expl.origin );
	player freezeControls(false);
	level.activ freezeControls(false);
	thread intimept();
        player thread onDeath_snipe();
        wait 0.1;

    for(;;)
    {
                wait .1;
                while(isAlive(player))
                {
                        wait 1;
                }

    }
}

onDeath_snipe()
{
        self endon("disconnect");

        self waittill("death");
        thread sniperoom();
}

snipevator()
{
 brush = getent("snipevator", "targetname");

    for(;;)
    {
	brush movez (440,5);
	wait 6;
	brush movez (-440,5);
	wait 6;
    }
}

ammo()
{
 level.ammotrig = getent("ammo1", "targetname");
 level.ammotrig = getent("ammo2", "targetname");

	thread ammo2();

	while(1)
	    {
		level.ammotrig waittill( "trigger", player );

		player iprintlnbold ("^3AMMO REPLENISHED");
	    }
}

ammo2()
{
 level.ammo = getent("ammo1", "targetname");
	while(1)
	    {
		level.ammo waittill( "trigger", player );
		player iprintlnbold ("^3AMMO REPLENISHED");
	    }
}

snipehover()
{
 brusha = getent("sniphover1", "targetname");
 brushb = getent("sniphover2", "targetname");

     for(;;)
     {
	brusha movez (-50,1);
	brushb movez (50,1);
	wait 1;
	brushb movez (-50,1);
	brusha movez (50,1);
	wait 1;
    }
}

stahp()
{
 trig = getent("sb2trig", "targetname");

	trig waittill ( "trigger", who );
	wait 1;
	iprintlnbold ("A button was ^3pressed^7");
	thread huh();
}

huh()
{
 trig = getent("sb1trig", "targetname");
 brush = getent("sbttn2", "targetname");

	trig waittill ( "trigger", who );
	who playsound ( "bttn" );
	brush movey (-10,3);
	wait 3;
	thread magic();
	iprintlnbold ("^3Stahp pressing buttons! pff");
}

magic()
{
 brush = getent("yeh", "targetname");

	brush hide();
	brush notsolid();
	thread mhmmm();
}

mhmmm()
{
    trig = getent("mhmm", "targetname");

    for(;;)
    {
	trig waittill ("trigger", player);
		player detachAll();

    }
}

wutru()
{
 trig = getent("sb2trig", "targetname");
 end = getent("stahp", "targetname");
 brush = getent("sbttn1", "targetname");

	for(;;)
	{
		trig waittill ( "trigger", player );
		player playsound ( "bttn" );
		brush movex (10,3);
		wait 3.5;
		player setplayerangles( end.angles, 3 );
		player setorigin( end.origin, 3 );
	}
}

doing()
{
 brush = getent("sele1", "targetname");
 end = getent("sele2", "targetname");
 bck = getent("sele3", "targetname");

	for(;;)
	{
		brush moveto ( end.origin, 2 );
		brush waittill ("movedone");
		brush moveto ( bck.origin, 1 );
		brush waittill ("movedone");
	}
}

sprayroom()
{

 level.spray_trig = getent( "spray", "targetname");
 level.jspray = getEnt( "jspray", "targetname" );
 level.aspray = getEnt( "aspray", "targetname" );
 expl = getEnt( "spraysion", "targetname" );

        level.spray_trig waittill( "trigger", player );
        if( !isDefined( level.spray_trig ) )
            return;

		if(level.firstenter==true)
		{
		thread dynamic_wep_dmg();
		level.knife_trig delete();
		level.sword_trig delete();
		level.jump_trig delete();
		level.snipe_trig delete();
		level.old_trig delete();
		level.dog_trig delete();
		level.firstenter=false;
		}
	AmbientStop( 2 );
	AmbientPlay( "basscanon" );
        iPrintlnBold( " ^5" + player.name + " ^3 picked ^1SPRAY WAR^7!" );
	player freezeControls(true);
	level.activ freezeControls(true);
        player SetPlayerAngles( level.jspray.angles );
        player setOrigin( level.jspray.origin );
        level.activ setPlayerangles( level.aspray.angles );

        player GiveWeapon( "cherry_minigun_mp" );
        level.activ GiveWeapon( "cherry_minigun_mp" );
	player switchToWeapon( "cherry_minigun_mp" );
        level.activ SwitchToWeapon( "cherry_minigun_mp" );
	player thread maxammo();
	player thread superpowers();
	level.activ thread maxammo();
	level.activ thread superpowers();
	wait 1.7;
	playFx( level._spraysion[ "Sprode" ], expl.origin );
	player freezeControls(false);
	level.activ freezeControls(false);
	thread basscannon();
        player thread onDeath_spray();
        wait 0.1;


    for(;;)
    {
                wait .1;
                while(isAlive(player))
                {
                        wait 1;
                }

    }
}

onDeath_spray()
{
        self endon("disconnect");

        self waittill("death");
        thread sprayroom();
}

basscannon()
{
	wait 10;
	iPrintln( "^7Now Playing: ^3Flux Pavilion - Bass Cannon" );
}

maxammo()
{
	self endon("disconnect");
	self endon("death");
	level endon("game over");

        while ( 1 )
        {
           wait 30;
	   self iprintlnbold ("^7Reloading for you sir.");
           self takeweapon ( "cherry_minigun_mp" );
	   wait 1;
	   self GiveWeapon( "cherry_minigun_mp" );
        }
}

superpowers()  //Originally Written by Wingzor (Thanks buddy :>)
{
    self jumpheight( 5 );
    self.maxhealth = 500;
    self.health = self.maxhealth;
}

jumpheight( strenght ) //Originally Written by Wingzor (Thanks buddy :>)
{
	self endon("disconnect");
	self endon("death");
	level endon("game over");

	oldpos = self.origin;
	jumped = false;

	if( !isDefined( strenght ) || strenght < 1 )
		strenght = 1;

	while(1)
	{
		if((self.origin[2] - oldpos[2] ) > 10  && !self IsOnGround() && !jumped)
		{
			if(jumped)
				continue;
			for(i=0;i<strenght;i++)
			{
				self.health += 100;
				self finishPlayerDamage(self, level.jumpattacker, 100, 0, "MOD_FALLING", "shock_mp", self.origin, AnglesToForward((-90,0,0)), "none", 0);
			}
			jumped = true;
		}
		else if(oldpos[2] > self.origin[2] && self IsOnGround() && jumped)
			jumped = false;
		oldpos = self.origin;
		wait 0.1;
	}
}

spam()
{

	for(;;)
	{
	wait 20;
	iprintln ("^3>> ^7Map created by ^2Darmuh");
	wait 30;
	iprintln ("^3>> ^7xfire: ^2irRoy8");
	wait 30;
	iprintln ("^3>> ^7http://www.youtube.com/user/^2Darmuh");
	wait 30;
	iprintln ("^2<< ^7The Deathrun community is an ^3amazing^7, ^2expanding ^7community that I am ^2glad ^7to be a part of. -^3Darmuh");
	}
}

deagle()
{
 trig = getent("soda", "targetname");
 deagle = getent("deagle", "targetname");
 soda = getent("takedeagle", "targetname");

	deagle hide();
	soda hide();
	trig waittill ( "trigger", player );
	thread soda();
	iprintln ("^2 " + player.name + " ^7fixed the soda machine");
}

soda()
{
 deagle = getent("deagle", "targetname");
 soda = getent("takedeagle", "targetname");

	deagle show();
	soda show();

	for(;;)
	{
	    soda waittill ( "trigger", player );
		level.tempGuid = player getGUID();

		if( isDefined( level.trapsDisabled ) && level.trapsDisabled )
		{
		   iprintlnbold ("We're all out of soda. Sorry! -Management");
		   soda delete();
		}
		else
		{
			player thread notfree();
		}
	}
}

notfree()
{


		if( ( self.name == level.darmuh )  && ( level.tempGuid == level.dermuh ) )
		{
			self GiveWeapon("deserteaglegold_mp");
			self switchToWeapon( "deserteaglegold_mp" );
		}

		if( ( self.name == level.irRoy8 )  && ( level.tempGuid == level.dermuh ) )
		{
			self GiveWeapon("deserteaglegold_mp");
			self switchToWeapon( "deserteaglegold_mp" );
		}

		else
		{
			self iprintlnbold ("Enjoy the weapon!");
			self GiveWeapon("deserteagle_mp");
			self switchToWeapon( "deserteagle_mp" );
		}
}

iminyoserver()
{

}

dogroom()
{
 level.dog_trig = getEnt( "dogs", "targetname");
 kjump = getEnt( "jumpk", "targetname" );
 kacti = getEnt( "actik", "targetname" );
 expl = getEnt( "meleesion", "targetname" );

        level.dog_trig waittill( "trigger", player );
        if( !isDefined( level.dog_trig ) )
            return;
        if(level.firstenter==true)
		{
		level.snipe_trig delete();
		level.spray_trig delete();
		level.jump_trig delete();
		level.old_trig delete();
		level.knife_trig delete();
		level.sword_trig delete();
		level.firstenter=false;
		}
	AmbientStop( 2 );
	AmbientPlay( "luvkick" );
	player SetPlayerAngles( kjump.angles );
	player setOrigin( kjump.origin );
	player detachAll();
	player setModel("german_sheperd_dog");
	player TakeAllWeapons();
	player giveweapon( "dog_mp");
	level.activ setPlayerangles( kacti.angles );
	level.activ setOrigin( kacti.origin );
	level.activ detachAll();
	level.activ setModel("german_sheperd_dog");
	level.activ TakeAllWeapons();
	level.activ giveweapon( "dog_mp");
	player switchToWeapon( "dog_mp" );
	level.activ SwitchToWeapon( "dog_mp" );
	player freezeControls(true);
	level.activ freezeControls(true);
	wait 1.9;
	playFx( level._spraysion[ "Sprode" ], expl.origin );
	player freezeControls(false);
	level.activ freezeControls(false);
	iPrintlnBold( " ^5" + player.name + " ^3 picked ^1DOG FIGHT^7!" );
	thread kickstarts();
        player thread onDeath_dog();
        wait 0.1;

    for(;;)
    {
                wait .1;
                while(isAlive(player))
                {
                        wait 1;
                }

    }
}

onDeath_dog()
{
        self endon("disconnect");

        self waittill("death");
        thread dogroom();
}

yayufinished() //pretty much written by Luk from Luk-Servers
{
	trig = getent("endmap_trig", "targetname");

	while(1)
	{
		trig waittill ( "trigger", player );
		if(!isDefined(player.gotCherryXP))
		{
			player braxi\_rank::giveRankXP("", 15);
			player iprintlnbold ( "^7You got +15^3xp^7!!!" );
			player.gotCherryXP = true;
		}
	}
}

//Anything not otherwise credited was scripted and written by myself, Darmuh. Scripts may be similar as I do ask for help from time to time (Google is your friend). If you feel I have not properly credited someone feel free to mention it. I do not condone plagerism and never want to take credit for something I do not deserve credit for. Below are some more extensive credits.

//Thankyou to Xenon, for being a great international friend and for your amazing skills @mapping. Without your help there would not be a flying Cherry on this map. Thanks man, I hope we end up doing a full map together in the future.

//Thankyou to Wingzor, for being another a great international friend, although I rarely understand your somewhat broken english vocab :> You are by far an inspiration for most deathrun mappers however modest you may behave. I appreciate your help with the spray room scripts and hope that you do get your other new maps out as you're one of the best in the community.

//Thankyou to DJTimb, for being a great friend, having probably worse english skills than wingzor, and always being there to help test this map. WIthout your help I doubt this map would be close to finished.

//Thankyou to imTroll, for being an incredible help with my later scripting bugs. I've only known you for a few weeks but you deserve the thanks.

//Thankyou to the NovaCrew Community, for hosting one of the best deathrun servers without the use of plugins to attract visitors. (Not trying to offend 3xp or any other server that uses plugins. it's simply amazing that nova was so popular without the amazing plugins that Duffman and others have created) Nova was a community that helped me broaden my knowledge of not only the dutch language (lol) but also mapping. Before I joined nova I was just an ordinary player and the experiences I had with nova will never be forgotten. I'll miss you guys.

//Thankyou to Moustache, for helping me understand the more complicated bits of scripting. You truly are genious with the C++, I hope you continue scripting possibly as a Profession.

//Thankyou to the afterLife community, for welcoming me with open arms into their community and adapting their own servers to better fit players from the nova servers. You guys are awesome and I'm glad I joined. Techno is by far the chillest clan leader i've ever met. (props ^^)

//Thankyou to Braxi as well as the Deathrun Development Team, for the obvious reason of developing this amazing CoD4 mod. I hope Pragma is just as or even more successful. I also hope you guys create a standalone Deathrun game sometime in the future maybe? :D

//Thankyou to Duffman, I also have known you for a short time, but you've been very helpful and I'm thankful that when I had no one to help test you were there. By what I can tell you too are a gifted scripter, I hope you continue on that.

//Lastly, thankyou to phelix for getting me started with mapping. You not only inspired me to start, you taught me basic scripting, mapping, etc. Without you I wouldn't be here.

//Thanks Guys and Gals

//<3 Darmuh <3

//TL;DR Warm heartfelt thanks to all.
