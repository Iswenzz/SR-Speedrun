main()
{
	maps\mp\_load::main();

	thread sr\api\_speedrun::createNormalWays("Normal Way");
		thread sr\api\_speedrun::createTeleporter((2287.25, -1088.39, 32.125), 65, 100, (1453, -1087, 92), 180, "freeze");
	//thread trap1();
	//thread trap3();
	//thread trap4();
	//thread trap5();
	//thread trap6();
	//thread platform();
	//thread trap7();
	//thread trap8a();
	//thread trap8b();
	//thread trap8c();
	//thread quakea();
	//thread quakeb();
	//thread quakec();
	//thread old();
	//thread slide();
	//thread credit();
	//thread credits();
	//thread sound();

	addTriggerToList( "trap1_trig");
	addTriggerToList( "trap3_trig");
	addTriggerToList( "trap4_trig");
	addTriggerToList( "trap5_trig");
	addTriggerToList( "trap6_trig");
	addTriggerToList( "trap7_trig");
	addTriggerToList( "trap8a_trig");
	addTriggerToList( "trap8b_trig");
	addTriggerToList( "trap8c_trig");
}

sound()

{

trig = getent("sound_activate","targetname");

trig waittill ("trigger");

musicplay ("music");

}

credit()
{
	wait 3;
	hud_clock = NewHudElem();
	hud_clock.alignX = "left";
	hud_clock.alignY = "top";
	hud_clock.horzalign = "left";
	hud_clock.vertalign = "top";
	hud_clock.alpha = 1;
	hud_clock.x = 0;
	hud_clock.y = 0;
	hud_clock.font = "objective";
	hud_clock.fontscale = 1.8;
	hud_clock.glowalpha = 1;
	hud_clock.glowcolor = (0,0,1);
	hud_clock.label = &"Welcome to mp_deathrun_airstruck.";
	hud_clock SetPulseFX( 40, 5400, 200 );
	wait 4;
	hud_clock.alignX = "center";
	hud_clock.alignY = "middle";
	hud_clock.horzalign = "center";
	hud_clock.vertalign = "middle";
	hud_clock.alpha = 1;
	hud_clock.x = 0;
	hud_clock.y = 0;
	hud_clock.font = "objective";
	hud_clock.fontscale = 3;
	hud_clock.glowalpha = 1;
	hud_clock.glowcolor = (0,1,0);
	hud_clock.label = &"Map by Sentrex";
	hud_clock SetPulseFX( 40, 5400, 200 );
}

credits()
{
	wait 6;
	iprintln ("Thank you to everyone in the Blur community!<3");
	wait 7;
	iprintln ("Skype: SentrexHD. Contact me for any problems/help!");
}

addTriggerToList( name )
{
	if( !isDefined( level.trapTriggers ) )
	level.trapTriggers = [];
	level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

trap1()
{
	brusha = getEnt ("trap1a", "targetname");
	brushb = getEnt ("trap1b", "targetname");
	brushc = getEnt ("trap1c", "targetname");
	trig = getEnt ("trap1_trig", "targetname");

	trig waittill("trigger", user);
	trig delete();

	while(1)
{
	brushb moveY(62, 0.5);
	brushc moveY(-62, 0.5);
	wait 0.5;
	brusha moveX(128, 1);
	brushb moveX(-128, 1);
	brushc moveX(-128, 1);
	wait 1;
	brushb moveY(-62, 0.5);
	brushc moveY(62, 0.5);
	wait 0.5;
	brushb moveY(62, 0.5);
	brushc moveY(-62, 0.5);
	wait 0.5;
	brusha moveX(-128, 1);
	brushb moveX(128, 1);
	brushc moveX(128, 1);
	wait 1;
	brushb moveY(-62, 0.5);
	brushc moveY(62, 0.5);
	wait 0.5;
}

}

trap2()
{
	brusha = getEnt ("trap2a", "targetname");
	brushb = getEnt ("trap2b", "targetname");
	brushc = getEnt ("trap2c", "targetname");
	brushd = getEnt ("trap2d", "targetname");
	brushe = getEnt ("trap2e", "targetname");
	brushf = getEnt ("trap2f", "targetname");
	trig = getEnt ("trap2_trig", "targetname");

	trig waittill("trigger", user);
	trig delete();

	while(1)
{
	wait 1;
	brusha RotatePitch(180, 2);
	brushc rotatePitch(180, 2);
	brushe rotatePitch(180, 2);
	brushb rotatePitch(-180, 2);
	brushd rotatePitch(-180, 2);
	brushf rotatePitch(-180, 2);
	wait 7;
	brusha rotatePitch(-180, 2);
	brushc rotatePitch(-180, 2);
	brushe rotatePitch(-180, 2);
	brushb rotatePitch(180, 2);
	brushd rotatePitch(180, 2);
	brushf rotatePitch(180, 2);
	wait 7;
}

}

trap3()
{
	brush = getEnt ("trap3", "targetname");
	trig = getEnt ("trap3_trig", "targetname");
	hurt = getEnt ("trap3hurt", "targetname");

	hurt enablelinkto();
	hurt linkto (brush);

	trig waittill("trigger", user);
	trig delete();

	while(1)
{
	brush RotateYaw(360, 4);
	wait 4;
	brush RotateYaw(-360, 4);
	wait 4;
}

}

trap4()
{
	brusha = getEnt ("trap4a", "targetname");
	brushb = getEnt ("trap4b", "targetname");
	brushc = getEnt ("trap4c", "targetname");
	brushd = getEnt ("trap4d", "targetname");
	trig = getEnt ("trap4_trig", "targetname");

	trig waittill("trigger", user);
	trig delete();

	while (1)
{
	brusha RotateRoll(-360, 2);
	wait 3;
	brushb RotateRoll(-360, 2);
	wait 3;
	brushc RotateRoll(-360, 2);
	wait 3;
	brushd RotateRoll(-360, 2);
	wait 3;

	brusha RotateRoll(360, 2);
	wait 3;
	brushb RotateRoll(360, 2);
	wait 3;
	brushc RotateRoll(360, 2);
	wait 3;
	brushd RotateRoll(360, 2);
	wait 3;
}

}

trap5()
{
	brush = getEnt ("trap5", "targetname");
	trig = getEnt ("trap5_trig", "targetname");
	trigtouch = getEnt ("trap5touch", "targetname");

	trig waittill("trigger", user);
	trig delete();

	while (1)
{
	trigtouch waittill("trigger", user);

	brush moveZ(-256, 1);
	wait 1.2;
	brush rotatepitch(90, 1);
	wait 1.2;
	brush rotatepitch(-90, 1);
	wait 1.2;
	brush moveZ(256, 1);
	wait 1.2;
}

}


trap6()
{
	brusha = getEnt ("trap6a", "targetname");
	brushb = getEnt ("trap6b", "targetname");
	brushc = getEnt ("trap6c", "targetname");

	hurta = getEnt ("trap6hurta", "targetname");
	hurtb = getEnt ("trap6hurtb", "targetname");
	hurtc = getEnt ("trap6hurtc", "targetname");

	trig = getEnt ("trap6_trig", "targetname");

	hurta enablelinkto();
	hurta linkto (brusha);
	hurtb enablelinkto();
	hurtb linkto (brushb);
	hurtc enablelinkto();
	hurtc linkto (brushc);

	trig waittill("trigger", user);
	trig delete();

	while(1)
{
	brusha RotateRoll(-360, 1);
	brushb RotateRoll(360, 1);
	brushc RotateRoll(-360, 1);
	wait 1.5;
}

}

platform()
{
	platform = getEnt ("platform", "targetname");
	trig = getEnt ("platform_trig", "targetname");

	trig waittill("trigger", user);
	trig delete();

	while(1)
{
	platform moveX(-608, 7);
	wait 8;
	platform moveX(608, 7);
	wait 8;
}

}

trap7()
{
	brush = getEnt ("trap7", "targetname");
	hurt = getEnt ("trap7hurt", "targetname");
	trig = getEnt ("trap7_trig", "targetname");

	hurt enablelinkto();
	hurt linkto (brush);

	trig waittill("trigger", user);
	trig delete();

	brush moveZ(384, 2);
	wait 2;

	while(1)
{
	brush RotateYaw(360, 4);
	wait 4;
}

}

trap8a()
{
	brush = getEnt ("trap8a", "targetname");
	trig = getEnt ("trap8a_trig", "targetname");
	hurt = getEnt ("trap8hurt", "targetname");

	hurt enablelinkto();
	hurt linkto (brush);

	trig waittill("trigger", user);
	trig delete();

	brush moveY(-6008, 10);
	wait 10;
	brush delete();
}

trap8b()
{
	brush = getEnt ("trap8b", "targetname");
	trig = getEnt ("trap8b_trig", "targetname");

	trig waittill("trigger", user);
	trig delete();

	brush moveY(-6008, 10);
	wait 10;
	brush delete();
}

trap8c()
{
	brush = getEnt ("trap8c", "targetname");
	trig = getEnt ("trap8c_trig", "targetname");

	trig waittill("trigger", user);
	trig delete();

	brush moveY(-6008, 10);
	wait 10;
	brush delete();
}

quakea()
{
	trigger = getent("trap8a_trig","targetname");
	quake = getent("quakea","targetname");
	sound = getent("sounda","targetname");

	trigger waittill("trigger", user);
	trigger delete();

	sound PlaySound( "elm_explosions_med");
	Earthquake( 0.5, 0.5, quake.origin, 1500 );
}

quakeb()
{
	trigger = getent("trap8b_trig","targetname");
	quake = getent("quakeb","targetname");
	sound = getent("soundb","targetname");

	trigger waittill("trigger", user);
	trigger delete();

	sound PlaySound( "elm_explosions_med");
	Earthquake( 0.5, 0.5, quake.origin, 1500 );
}

quakec()
{
	trigger = getent("trap8c_trig","targetname");
	quake = getent("quakec","targetname");
	sound = getent("soundc","targetname");

	trigger waittill("trigger", user);
	trigger delete();

	sound PlaySound( "elm_explosions_med");
	Earthquake( 0.5, 0.5, quake.origin, 1500 );
}

old()
{
	brush = getEnt ("old", "targetname");
	level.old_trig = getEnt ("old_trig", "targetname");

	level.old_trig waittill("trigger", user);
	level.old_trig delete();
	level.slide_trig delete();

	iprintlnbold("" + user.name + " has finished first!");
	brush RotateRoll(90, 2);
}

slide()
{
    level.slide_trig = getEnt( "slide_trig", "targetname"); //Your trigger that you made obviously..
    jump = getEnt( "slide_jumper", "targetname" ); //Jumper Origin
    acti = getEnt( "slide_acti", "targetname" ); //Activator Origin

    while(1)
    {
        level.slide_trig waittill( "trigger", player );
        if( !isDefined( level.slide_trig ) )
            return;

        level.old_trig delete();

        player setPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player takeAllWeapons();
        player giveWeapon( "knife_mp" );
        level.activ setPlayerAngles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ takeAllWeapons();
        level.activ giveWeapon( "knife_mp" );
        wait 0.05;
        player switchToWeapon( "knife_mp" );
        level.activ switchToWeapon( "knife_mp" );
        iPrintlnBold( " " + player.name + " ^3has found the SLIDE room!" );
        while( isAlive( player ) && isDefined( player ) )
        wait 1;
    }
}