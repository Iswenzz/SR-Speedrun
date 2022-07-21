main()
{
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

    	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createTeleporter((7523.04, 2030.49, -47.875), 50, 20, (7561, 553, -164), 180, "freeze", "red", "normal_0");

	//thread trap1();
	//thread trap2();
	//thread trap3();
	//thread trap4();
	//thread trap5();
	//thread trap6();
	//thread trap7();
	//thread trap8();
	//thread trap9();
	//thread trap10();
	//thread trap11();
	//thread trap12();
	//thread trap13();
	thread trap13_rotate();
	//thread trap14();
	thread trap15();
	//thread trap16();

}

trap1()
{
	trig=getent("trap1_trig","targetname");
	trapa=getent("trap1a","targetname");
	trapb=getent("trap1b","targetname");

	trig sethintstring("Press ^1&&1^7 to activate the Obstacle");
	trig waittill("trigger");
	trig delete();

	while(1)
	{
		trapa rotateyaw(360,2);
		trapb rotateyaw(-360,2);
		wait 2;
	}
}

trap2()
{
	trig=getent("trap2_trig","targetname");
	trap=getent("trap2","targetname");
	hurt=getent("trap2_hurt","targetname");

	hurt enablelinkto();
	hurt linkto(trap);

	trig sethintstring("Press ^1&&1^7 to activate the Obstacle");
	trig waittill("trigger");
	trig delete();

	while(1)
	{
		trap rotateyaw(360,2);
		wait 2;
		trap rotateyaw(360,4);
		wait 4;
	}
}

trap3()
{
	trig=getent("trap3_trig","targetname");
	trapa=getent("trap3a","targetname");
	trapb=getent("trap3b","targetname");

	trig sethintstring("Press ^1&&1^7 to activate the Obstacle");
	trig waittill("trigger");
	trig delete();

	while(1)
	{
		trapa movey(-80,1);
		wait 2;
		trapa movey(80,1);
		trapb movey(-80,1);
		wait 2;
		trapb movey(80,1);
	}
}

trap4()
{
	trig=getent("trap4_trig","targetname");
	trap=getent("trap4","targetname");

	trig sethintstring("Press ^1&&1^7 to activate the Obstacle");
	trig waittill("trigger");
	trig delete();

	trap movey(128,3);
	wait 3;
	while(1)
	{
		trap movey(-256,3);
		wait 3;
		trap movey(256,3);
		wait 3;
	}
}

trap5()
{
	trig=getent("trap5_trig","targetname");
	trapa=getent("trap5a","targetname");
	trapb=getent("trap5b","targetname");

	trapa hide();
	trapb hide();

	trig sethintstring("Press ^1&&1^7 to activate the Obstacle");
	trig waittill("trigger");
	trig delete();

	vc=randomint(4);
	if(vc!=0||vc!=2)
	{
		trapb delete();
		trapa show();
		trapa movez(70,.5);
		wait .5;
		trapa moveto((3984,2560,-312),4);
		wait 4;
		trapa movez(-70,.5);
		wait .5;
		trapa hide();
		trapa delete();
	}
	else 
	{
		trapa delete();
		trapb show();
		trapb movez(70,.5);
		wait .5;
		trapb moveto((3984,2560,-312),4);
		wait 4;
		trapb movez(-70,.5);
		wait .5;
		trapb hide();
		trapb delete();
	}	
}

trap6()
{
	trig=getent("trap6_trig","targetname");
	trapa=getent("trap6a","targetname");
	trapb=getent("trap6b","targetname");
	trapc=getent("trap6c","targetname");
	trapd=getent("trap6d","targetname");

	trig sethintstring("Press ^1&&1^7 to activate the Obstacle");
	trig waittill("trigger");
	trig delete();

	while(1)
	{
		trapa movez(30,4);
		trapb movez(-30,4);
		trapc movez(45,4);
		trapd movez(-45,4);
		wait 7;
		trapa movez(-30,4);
		trapb movez(30,4);
		trapc movez(-45,4);
		trapd movez(45,4);
		wait 7;
		trapa movez(-30,4);
		trapb movez(30,4);
		trapc movez(-45,4);
		trapd movez(45,4);
		wait 7;
		trapa movez(30,4);
		trapb movez(-30,4);
		trapc movez(45,4);
		trapd movez(-45,4);
		wait 7;
	}
}

trap7()
{
	trig=getent("trap7_trig","targetname");
	trap=getent("trap7","targetname");

	trig sethintstring("Press ^1&&1^7 to activate the Obstacle");
	trig waittill("trigger");
	trig delete();

	while(1)
	{
		trap rotatepitch(-45,4);
		wait 6;
		trap rotatepitch(45,4);
		wait 6;
	}
}

trap8()
{
    trig=getent("trap8_trig","targetname");
   
   	trig sethintstring("Press ^1&&1^7 to activate the Obstacle");
	trig waittill("trigger");
	trig delete();

    if(isdefined(level.ropetim))
        level.ropetim unlink();
}

trap9()
{
	trig=getent("trap9_trig","targetname");
	trap=getent("trap9","targetname");

	trig sethintstring("Press ^1&&1^7 to activate the Obstacle");
	trig waittill("trigger");
	trig delete();

	while(1)
	{
		trap rotateyaw(360,2);
		wait 2;
		trap rotateyaw(360,4);
		wait 4;
	}
}

trap10()
{
	trig=getent("trap10_trig","targetname");
	trap=getent("trap10","targetname");

	trig sethintstring("Press ^1&&1^7 to activate the Obstacle");
	trig waittill("trigger");
	trig delete();

	while(1)
	{
		trap movez(-144,5);
		wait 5;
		trap movez(144,5);
		wait 8;
	}
}

trap11()
{
	trig=getent("trap11_trig","targetname");
	trapa=getent("trap11a","targetname");
	trapb=getent("trap11b","targetname");
	trapc=getent("trap11c","targetname");
	trapd=getent("trap11d","targetname");

	trig sethintstring("Press ^1&&1^7 to activate the Obstacle");
	trig waittill("trigger");
	trig delete();

	trapd movez(-150,4);
	wait 4;
	trapa moveto((5440,-640,-328),4);
	trapb moveto((5440,-1344,-328),4);
	trapc moveto((4672,-1344,-328),4);
	wait 1;
	trapd delete();
}

trap12()
{
	trig=getent("trap12_trig","targetname");
	trapa=getent("trap12a","targetname");
	trapb=getent("trap12b","targetname");
	trapc=getent("trap12c","targetname");
	trapd=getent("trap12d","targetname");

	trig sethintstring("Press ^1&&1^7 to activate the Obstacle");
	trig waittill("trigger");
	trig delete();

	while(1)
	{
		trapa rotatepitch(360,5);
		wait 4;
		trapb rotatepitch(360,5);
		wait 4;
		trapc rotatepitch(360,5);
		wait 4;
		trapd rotatepitch(360,5);
		wait 4;
	}
}

trap13()
{
	trig=getent("trap13_trig","targetname");
	trapa=getent("trap13a","targetname");
	trapb=getent("trap13b","targetname");

	trig sethintstring("Press ^1&&1^7 to activate the Obstacle");
	trig waittill("trigger");
	trig delete();

	trapa movez(-150,4);
	wait 1;
	trapb movez(-150,4);
	wait 5;
	trapa delete();
	trapb delete();
}

trap13_rotate()
{
	targ=getent("trap13_rotate","targetname");
	
	wait 0.1;
	targ delete();
}

trap14()
{
	trig=getent("trap14_trig","targetname");
	trapa=getent("trap14a","targetname");
	trapb=getent("trap14b","targetname");

	trig sethintstring("Press ^1&&1^7 to activate the Obstacle");
	trig waittill("trigger");
	trig delete();

	while(1)
	{
		trapa rotateroll(-70,2);
		trapb rotateroll(70,2);
		wait 2;
		trapa rotateroll(70,2);
		trapb rotateroll(-70,2);
		wait 2;
	}
}

trap15()
{
	trapa=getent("trap15a","targetname");
	trapb=getent("trap15b","targetname");
	trapc=getent("trap15_solid","targetname");
    
	wait 0.1;
	trapa delete();
	trapb delete();
	trapc delete();
	
}

trap16()
{
	trig=getent("trap16_trig","targetname");
	trapa=getent("trap16a","targetname");
	trapb=getent("trap16b","targetname");

	trig sethintstring("Press ^1&&1^7 to activate the Obstacle");
	trig waittill("trigger");
	trig delete();

	vc=randomint(4);
	if(vc!=0||vc!=2)
		trapa delete();
	else
		trapb delete();
}