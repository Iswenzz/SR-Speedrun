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
    setdvar("compassmaxrange","1800");

	thread sr\api\_map::createSpawn((1627, -743, 60), 270);
     thread sr\api\_speedrun::createNormalWays("Normal Way");
     thread sr\api\_speedrun::createSecretWays("^2Easy Secret;^1Hard Secret");
	 thread custom_tp();
	 thread sr_easy_sec_enter();
	 thread sr_hard_sec_enter();
	
	//precacheModel("pressure_suit");
    //precacheModel("pressure_helmet");
	//precacheModel("fox_alien");
	//PreCacheShellShock( "flash_grenade_mp");
	//precacheItem( "bananagun_mp" );
	
	//level.orbitsecret=loadfx("fire/orbitsecret");
	//level.orbitacti=loadfx("fire/orbitacti");
	//level.orbitpickup=loadfx("misc/orbitpickup");
	//level.orbitbeam=loadfx("misc/orbittrap");
	//level.orbitburn=loadfx("fire/orbitburn");
	//level.orbiteasy=loadfx("fire/orbiteasy");
	//level.orbithard=loadfx("fire/orbithard");
	//level.orbittele=loadfx("fire/orbittele");
	//level.orbitmagic=loadfx("fire/orbitmagic");
	//level.orbitlight=loadfx("misc/orbitlight");

	if(!isdefined(level.music))
		level.music=[];
		
	level.music[0]["song"]	="Pham - Movements";
	level.music[0]["alias"]	="movements";
	level.music[1]["song"]	="Brennan Heart - Follow the Light";
	level.music[1]["alias"]	="bheart2";
	level.music[2]["song"]	="Steve Aoki - ILYSM";
	level.music[2]["alias"]	="ilysm";
	level.music[3]["song"]	="Papa Roach - Born for Greatness";
	level.music[3]["alias"]	="greatness";
	level.music[4]["song"]	="Mac Miller - BDE Bonus";
	level.music[4]["alias"]	="bdeb";
	level.music[5]["song"]	="BROCKHAMPTON - GOLD";
	level.music[5]["alias"]	="youngj";

	
	addTriggerToList("trap1_trig");
	addTriggerToList("trap2_trig");
	addTriggerToList("trap3_trig");
	addTriggerToList("trap4_trig");
	addTriggerToList("trap5_trig");
	addTriggerToList("trap6_trig");
	addTriggerToList("trap66_trig");
	addTriggerToList("trap7_trig");
	addTriggerToList("trap8_trig");



	//thread musictrig();
	
		//setExpFog(3000, 6000, 0, 0.05, 0.2);
		//thread rollerc2();
		//thread lowgrav();
		thread doorsl1();
		thread doorsr1();
		thread doorsl2();
		thread doorsr2();
		
		//thread fakebrushes();
		//thread pressure_suit();
		//thread acti_model();
		thread startdoor();
		//thread spawnd1();
		//thread spawnd2();
		//thread spawnd3();
		//thread spawnd4();
		//thread spawnd5();
		//thread spawnd6();
		//thread spawnd7();
		//thread spawnd8();
		//thread spawnd9();
		//thread spawnd10();
		//thread spawnd11();
		//thread touch();
		//thread teleporno();
		thread h_secret();
		thread e_secret();
		//thread actifail();
		thread map_tele1();
		thread map_tele2();
		//thread map_mover();
		//thread rocker();
		//thread rockerfail();
		//thread rocker_endhard();
		//thread rocker_endeasy();
		//thread actigo1();
		//thread actigo1_spin();
		//thread acti_spinner();
		//thread actistart();
		//thread acti_rise();
		//thread acti_bspawn();
		thread trap1();
		//thread actigo2();
		thread trap2();
		//thread actigo3();
		thread trap3();
		//thread actigo4();
		thread trap4();
		//thread actigo5();
		thread trap5();
		//thread actigo66();
		thread trap66();
		//thread actigo6();
		thread trap6();
		thread actigo7();
		thread trap7();
		//thread actigo8();
		thread trap8();
		//thread onPlayerConnected();
		//thread actigo9();
		thread setup();
		thread harddone();
		thread easydone();
		//thread creators();
		//thread onroundstart();
		//thread sniper_room_battle();
		//thread knife_room_battle();
		//thread banana_room_battle();
		//thread wep_fail();
		//thread knife_fail();
		//thread secretlounge_fail();
}
freeze_on_tps(time) {
	self freezecontrols(true);
	self thread freeze_on_tps_repeat(time);
}
freeze_on_tps_repeat(time) {
	wait time;
	self freezecontrols(false);
}
addTriggerToList(name)
{
    if(!isDefined(level.trapTriggers))
        level.trapTriggers=[];
    level.trapTriggers[level.trapTriggers.size]=getEnt(name,"targetname");
}

custom_tp()
{
	trig = spawn("trigger_radius",(-8257.32, -8320.71, -448.065), 0,145, 120);
	trig.radius = 145;
	
	ori_t = spawn("script_origin",(-10257,-7145,-196));
	ori_t.angles = (0,36,0);

	thread sr\api\_map::createTriggerFx(trig, "cyan");

	for(;;)
	{
		trig waittill("trigger",player);

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
		player freeze_on_tps(0.1);
	}
}
sr_easy_sec_enter()
{
	trig = spawn("trigger_radius",(1476.25, -732.859, 0.00915271), 0, 60, 120);
	trig.radius = 60;
	ori_t = getEnt("e_secretgo","targetname");

	thread sr\api\_map::createTriggerFx(trig, "green");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_0"); 

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
		player freeze_on_tps(0.1);
	}
}

sr_hard_sec_enter()
{
	trig = spawn("trigger_radius",(1768.59, -732.859, 0.00915271), 0, 60, 120);
	trig.radius = 60;
	ori_t = getEnt("h_secretgo","targetname");

	thread sr\api\_map::createTriggerFx(trig, "orange");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_1"); 

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
		player freeze_on_tps(0.1);
	}
}
//*Wingzors script
fakebrushes()
{
fakebrush = getentarray("fake", "targetname");
	for(i = 0; i < fakebrush.size; i++)
	{
                    thread spin(fakebrush[i]);
					thread spots(fakebrush[i]);
	}
}
spin(brush)
{
if (!isdefined(brush.speed))
 brush.speed = 3;
if (!isdefined(brush.script_noteworthy))
 brush.script_noteworthy = "z";

while(true)
{
 // rotateYaw(float rot, float time, <float acceleration_time>, <float deceleration_time>);
 if (brush.script_noteworthy == "z")
  brush rotateYaw(360,brush.speed);
 else if (brush.script_noteworthy == "x")
  brush rotateRoll(360,brush.speed);
 else if (brush.script_noteworthy == "y")
  brush rotatePitch(360,brush.speed);
 wait ((brush.speed)-0.1); // removes the slight hesitation that waittill("rotatedone"); gives.
}
}

spots(brush)
{
brush notsolid();
while(1)
{
randx = RandomIntRange(-4128, -240 );
randz = RandomIntRange(-330, -216 );
spot=(randx,5552,randz);				
brush moveTo(spot,1);
brush waittill("movedone");
randwait = RandomIntRange(1, 10 );
wait(randwait);
brush show();
randsolid = RandomIntRange(1, 14 );
if(randsolid<13)
	brush solid();
else
	brush notsolid();
randmovetime = RandomIntRange(5, 15 );
randx2 = RandomIntRange(-4128, -240 );
randz2 = RandomIntRange(-330, -216 );
endspot=(randx2,-11968,randz2);
brush moveTo(endspot,randmovetime);
brush waittill("movedone");
brush notsolid();
brush hide();
}

}
//*

//* Helmet by Erik and ufo model by Fox
pressure_suit()
{
	trig=getent("testo_trigger","targetname");
	while(1)
	{
		trig waittill("trigger",player);

		if(!isDefined(player.hashelmet))
		{
			player.hashelmet = false;
		}

		if(isDefined(player.hashelmet) && player.hashelmet == true)
		{
			player iPrintln("^5---You can only have one helmet at a time---");
		}

		if(isDefined(player.hashelmet) && player.hashelmet == false)
		{
			player.hashelmet = true;
			player attach( "pressure_helmet" );
			player iPrintln("^5---You picked up a helmet---");
			player thread waitdeath();
			wait 0.1;
		}
	}
}

waitdeath()
{
    self waittill("death");
    self.hashelmet=false;

}

acti_model()
{
    trigger = getEnt ("actistart","targetname");
    while(1)
    {
	trigger waittill ("trigger", player);
    player detachAll();
    wait 0.05;
    player setmodel("fox_alien");
    wait 10;
    }
}
//*

roller_b()
{
	object = getEnt ("roller_base","targetname");
	wait 0.1;
	while(1)
	{
		wait 4;
		object rotatepitch (90,0.2);
		object waittill ("rotatedone");
		wait 4;
		object rotatepitch (90,0.2);
		object waittill ("rotatedone");
	}
}

roller1()
{
	
	object = getEnt ("roller1","targetname");
	roller_s1 = getEnt ("roller_s1","targetname");
	roller_s2 = getEnt ("roller_s2","targetname");
	roller_s3 = getEnt ("roller_s3","targetname");
	clip = getEnt ("rollerc1","targetname");
	clip enablelinkto ();
	clip linkto (object);
	object notSolid();
	wait 0.1;
	while(1)
	{
		wait 1.05;
		roller_s1 playSound("zapety");
		roller_s2 playSound("zapety");
		roller_s3 playSound("zapety");
		wait 2.95;
		object rotatepitch (90,0.2);
		object waittill ("rotatedone");
		wait 1.05;
		roller_s1 playSound("zapety");
		roller_s2 playSound("zapety");
		roller_s3 playSound("zapety");
		wait 2.95;
		object rotatepitch (90,0.2);
		object waittill ("rotatedone");
	}
}
roller_numbers()
{
	n1 = getEnt ("roller_number1","targetname");
	n2 = getEnt ("roller_number2","targetname");
	n3 = getEnt ("roller_number3","targetname");
	n4 = getEnt ("roller_number4","targetname");
	plat = getEnt ("roller_numberplat","targetname");
	n1 hide();
	n2 hide();
	n3 hide();
	wait 0.1;
	while(1)
	{
		wait 1;
		n4 hide();
		n3 show();
		wait 1;
		n3 hide();
		n2 show();
		wait 1;
		n2 hide();
		n1 show();
		wait 1;
		n1 hide();
		plat rotatepitch(180,0.2);
		plat waittill ("rotatedone");
		n4 show();
	}
}

rollerc2()
{
	object = getEnt ("roller1","targetname");
	clip2 = getEnt ("rollerc2","targetname");
	clip2 rotatepitch(-90,0.1);
	clip2 waittill ("rotatedone");
	clip2 enablelinkto ();
	clip2 linkto (object);
	thread rollerc3();
}

rollerc3()
{
	object = getEnt ("roller1","targetname");
	clip3 = getEnt ("rollerc3","targetname");
	clip3 rotatepitch(90,0.1);
	clip3 waittill ("rotatedone");
	clip3 enablelinkto ();
	clip3 linkto (object);
	thread rollerc4();
}

rollerc4()
{
	object = getEnt ("roller1","targetname");
	clip4 = getEnt ("rollerc4","targetname");
	clip4 rotatepitch(180,0.1);
	clip4 waittill ("rotatedone");
	clip4 enablelinkto ();
	clip4 linkto (object);
	thread roller_b();
	thread roller1();
	thread roller_numbers();
}

doorsl1()
{
	object = getEnt ("doorsl1","targetname");
	trig = getEnt ("doors1_trig","targetname");
	
	wait 0.1;
	object delete();
}

doorsr1()
{
	object = getEnt ("doorsr1","targetname");
	trig = getEnt ("doors1_trig","targetname");

	wait 0.1;
	object delete();
}

doorsl2()
{
	object = getEnt ("doorsl2","targetname");
	trig = getEnt ("doors2_trig","targetname");

	wait 0.1;
	object delete();
}

doorsr2()
{
	object = getEnt ("doorsr2","targetname");
	trig = getEnt ("doors2_trig","targetname");

	wait 0.1;
	object delete();
}


startdoor()
{
	object = getEnt ("startdoor","targetname");
	s_end1 = getEnt ("startdoor_end","targetname");
	gsound = getEnt ("garagedoorsound1","targetname");

	wait 0.1;
	object delete();
	s_end1 delete();
}

spawnd1()
{
	object = getEnt ("spawnd1","targetname");
	wait 10;
	object rotateyaw(-180,1);
}

spawnd2()
{
	object = getEnt ("spawnd2","targetname");
	wait 10;
	object rotateyaw(-180,1);
}

spawnd3()
{
	object = getEnt ("spawnd3","targetname");
	wait 10;
	object rotateyaw(-180,1);
}

spawnd4()
{
	object = getEnt ("spawnd4","targetname");
	wait 10;
	object rotateyaw(-180,1);
}

spawnd5()
{
	object = getEnt ("spawnd5","targetname");
	wait 10;
	object rotateyaw(-180,1);
}

spawnd6()
{
	object = getEnt ("spawnd6","targetname");
	wait 10;
	object rotateyaw(-180,1);
}

spawnd7()
{
	object = getEnt ("spawnd7","targetname");
	wait 10;
	object rotateyaw(180,1);
}

spawnd8()
{
	object = getEnt ("spawnd8","targetname");
	wait 10;
	object rotateyaw(180,1);
}

spawnd9()
{
	object = getEnt ("spawnd9","targetname");
	wait 10;
	object rotateyaw(180,1);
}

spawnd10()
{
	object = getEnt ("spawnd10","targetname");
	wait 10;
	object rotateyaw(180,1);
}

spawnd11()
{
	object = getEnt ("spawnd11","targetname");
	wait 10;
	object rotateyaw(180,1);
}

touch()
{
trigger = getEnt ("rocket_shoot","targetname");
object = getEnt ("touch_lad","targetname");
object rotateroll (-80,0.1);
trigger waittill ("trigger",player);
object rotateroll (80,4,3,1);
thread letter_1();
}
letter_1()
{
	trigger = getEnt ("letter_1","targetname");
	trigger waittill ("trigger",player);
	iPrintln("^1-");
	thread letter_2();
}
letter_2()
{
	trigger = getEnt ("letter_2","targetname");
	trigger waittill ("trigger",player);
	iPrintln("^1-");
	thread letter_3();
}
letter_3()
{
	trigger = getEnt ("letter_3","targetname");
	trigger waittill ("trigger",player);
	iPrintln("^1-");
	thread letter_4();
}
letter_4()
{
	trigger = getEnt ("letter_4","targetname");
	trigger waittill ("trigger",player);
	iPrintln("^1-");
	thread letter_5();
}
letter_5()
{
	trigger = getEnt ("letter_5","targetname");
	trigger waittill ("trigger",player);
	iPrintln("^1-");
	thread letter_6();
}
letter_6()
{
	trigger = getEnt ("letter_6","targetname");
	trigger waittill ("trigger",player);
	iPrintln("^1-");
	thread letter_7();
}
letter_7()
{
	trigger = getEnt ("letter_7","targetname");
	trigger waittill ("trigger",player);
	iPrintln("^1-");
	thread letter_8();
}
letter_8()
{
	trigger = getEnt ("letter_8","targetname");
	trigger waittill ("trigger",player);
	iPrintln("^2Access granted.");
	player braxi\_rank::giveRankXP("", 100);
	thread turbo();
	thread ball();
}
turbo()
{
	end = getEnt ("rocket_end","targetname");
	act2 = getEnt ("acti_act2","targetname");
	start = getEnt ("rocket","targetname");
	turbo1 = getEnt ("turbo1","targetname");
	turbo2 = getEnt ("turbo2","targetname");
	turbo1 enablelinkto ();
	turbo1 linkto (start);
	turbo2 enablelinkto ();
	turbo2 linkto (start);
	start rotateyaw(15,2);
	start waittill ("rotatedone");
	start playSound("rocket");
	PlayFXOnTag(level.orbitsecret,turbo1,"tag_origin");
	PlayFXOnTag(level.orbitsecret,turbo2,"tag_origin");
	start moveto(end.origin,8,8);
	start waittill ("movedone");
	playfx(level.orbitmagic,end.origin);
	playfx(level.orbittele,act2.origin);
	thread teleporh();
	thread teleporha();

}
ball()
{
	end = getEnt ("ball_end","targetname");
	clip = getEnt ("ball","targetname");
	model = getEnt ("ball_model","targetname");
	model enablelinkto ();
	model linkto (clip);
	wait 9.7;
	model playSound("collision");
	thread ballrot();
	clip moveto(end.origin,0.3,0.02);
}
ballrot()
{
	clip = getEnt ("ball","targetname");
	clip rotateroll(-60,0.02);
}
teleporno()
{
	trig = getEnt ("choose1", "targetname");
	trig2 = getEnt ("acti_secret", "targetname");
	trig maps\mp\_utility::triggeroff();
	trig2 maps\mp\_utility::triggeroff();
}
teleporh()
{
	trig = getEnt ("choose1", "targetname");
	end = getEnt ("choose1_go", "targetname");
	trig maps\mp\_utility::triggeron();
	trig SetCursorHint("HINT_ACTIVATE");
	while(1)
    {
        trig waittill ("trigger", player);
		player disableweapons();
		wait 0.1;
		player enableweapons();
		player takeallweapons();
		player giveweapon("knife_mp");
		player switchtoweapon ("knife_mp");
		player.insec=true;
		player.health += 50000;
		player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
		player thread actiplayernoknife();
		player thread whended();
	}

}

teleporha()
{
	trig = getEnt ("acti_secret", "targetname");
	end = getEnt ("choose1_go", "targetname");
	trig maps\mp\_utility::triggeron();
	trig SetCursorHint("HINT_ACTIVATE");
	while(1)
    {
        trig waittill ("trigger", player);
		player.insec=true;
		player.health += 50000;
		player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
		player thread actiplayernoknife();
		player thread whended();
	}

}

h_secret()
{
        level.hardenter = getent ("h_secret","targetname");
        level.hardboigo = getent ("h_secretgo","targetname");
        while(1)
        {
                level.hardenter waittill ("trigger",player);
                if( player.pers["team"] == "allies" )
                {      
					player.sc = 0;
					player.insec = true;
					player thread whendead();
					player SetOrigin(level.hardboigo.origin);
					player SetPlayerAngles(level.hardboigo.angles );
					player thread secret_timer_hard();   
                }
                else
                {
                    player SetOrigin(level.hardboigo.origin);
					player SetPlayerAngles(level.hardboigo.angles );
					player.sc = 0;
					player.insec = true;
                }
        }
}
e_secret()
{
        level.easyenter = getent ("e_secret","targetname");
        level.easyboigo = getent ("e_secretgo","targetname");
        while(1)
        {
                level.easyenter waittill ("trigger",player);
                if( player.pers["team"] == "allies" )
                {      
					player SetOrigin(level.easyboigo.origin);
					player SetPlayerAngles(level.easyboigo.angles );
					player thread secret_timer_easy();   
                }
                else
                {
                    player SetOrigin(level.easyboigo.origin);
					player SetPlayerAngles(level.easyboigo.angles );
                }
        }
}
actifail()
{
	trig = getEnt ("actifail", "targetname");
	end = getEnt ("acti_bspawngo", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);          
		player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}

}

map_tele1()
{
	trig = getEnt ("map_tele1", "targetname");
	end = getEnt ("map_tele1go", "targetname");
	for(;;)
    	{
        trig waittill ("trigger", player);   
		player SetOrigin(end.origin);
		player SetPlayerAngles(end.angles);
		player freeze_on_tps(0.1);
	}

}

map_tele2()
{
	trig = getEnt ("map_tele2", "targetname");
	end = getEnt ("map_tele2go", "targetname");
	for(;;)
    	{
        trig waittill ("trigger", player);   
		player SetOrigin(end.origin);
		player SetPlayerAngles(end.angles);
		player freeze_on_tps(0.1);
	}

}

rocker()
{
	trig = getEnt ("rocker", "targetname");
	end = getEnt ("rockergo", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player); 
		player iPrintlnBold ("^1You have 5 tries!");
		player.secretTries=0;
		player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}

}

rockerfail()
{
	trig=getent("rockerfail","targetname");
	targ=getent("rockergo","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		if(player.secretTries<5)
		{
			player.secretTries++;
			player setorigin(targ.origin);
			player setplayerangles(targ.angles);
		}
		else 
		player suicide();
	}
}

rocker_endhard()
{
	trig = getEnt ("rocker_endhard", "targetname");
	end = getEnt ("map_tele2go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
		player braxi\_rank::giveRankXP("", 100);
		player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
		player giveweapon("bananagun_mp");
		player switchtoweapon("bananagun_mp");
	}

}

rocker_endeasy()
{
	trig = getEnt ("rocker_endeasy", "targetname");
	end = getEnt ("rocker_endeasygo", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
		player braxi\_rank::giveRankXP("", 50);
		player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
		player giveweapon("bananagun_mp");
		player switchtoweapon("bananagun_mp");
	}

}

map_mover()
{
	trigger = getEnt ("mover_trig","targetname");
	object = getEnt ("mover","targetname");
	point0 = getEnt ("point0","targetname");
	point1 = getEnt ("point1","targetname");
	point2 = getEnt ("point2","targetname");
	point3 = getEnt ("point3","targetname");
	point4 = getEnt ("point4","targetname");
	point5 = getEnt ("point5","targetname");
	trigger waittill ("trigger", player);
	wait 2;
	if (!isdefined(object.speed))
	object.speed = 1;
	while(true)
	{
	object moveto(point1.origin,1,1);
	wait ((object.speed)-0.1);
	object moveto(point2.origin,1);
	wait ((object.speed)-0.1);
	object moveto(point3.origin,1);
	wait ((object.speed)-0.1);
	object moveto(point4.origin,1);
	wait ((object.speed)-0.1);
	object moveto(point5.origin,1,0,1);
	object waittill ("movedone");
	wait 4;
	object moveto(point4.origin,1,1);
	wait ((object.speed)-0.1);
	object moveto(point3.origin,1);
	wait ((object.speed)-0.1);
	object moveto(point2.origin,1);
	wait ((object.speed)-0.1);
	object moveto(point1.origin,1);
	wait ((object.speed)-0.1);
	object moveto(point0.origin,1,0,1);
	object waittill ("movedone");
	wait 4;
	}
}
	
actigo1()
{
	trigger = getEnt ("actigo1_trig","targetname");
	object = getEnt ("saucer","targetname");
	point = getEnt ("actigo1","targetname");
	super1 = getEnt ("super1","targetname");
	burner = getEnt ("trap66burn","targetname");
	burnerb = getEnt ("trap66back","targetname");
	spinner = getEnt ("acti_spinner","targetname");
	tele = getent ("acti_rise3","targetname");
	tele enablelinkto ();
	tele linkto (object);
	super1 enablelinkto ();
	super1 linkto (object);
	burner enablelinkto ();
	burner linkto (object);
	burnerb enablelinkto ();
	burnerb linkto (object);
	wait 0.1;
	trigger SetCursorHint("HINT_ACTIVATE");
	trigger waittill ("trigger", player);
	player linkto (object);
	object moveto(point.origin,3,1.5,1.5);
	spinner moveto(point.origin,3,1.5,1.5);
	wait 3;
	player unlink();
}

actigo1_spin()
{
	trigger = getEnt ("actigo1_trig","targetname");
	spinner = getEnt ("acti_spinner","targetname");
	wings = getEnt ("saucerwings","targetname");
	object = getEnt ("saucer","targetname");
	spinner movez(-512,0.1);
	spinner waittill ("movedone");
	wings enablelinkto ();
	wings linkto (spinner);
	trigger waittill ("trigger", player);
	//spinner rotateyaw(2160,5,2.5,2.5);
}

acti_spinner()
{
	trigger = getEnt ("spinner_trig","targetname");
	object = getEnt ("saucer","targetname");
	wings = getEnt ("saucerwings","targetname");
	spinner = getEnt ("acti_spinner","targetname");
	spinner hide();
	spinner waittill ("movedone");
	trigger waittill ("trigger", player);
	spinner show();
	wings delete();
}

actistart()
{
	trigger = getEnt ("actistart","targetname");
	point1 = getEnt ("acti_rise1","targetname");
	port1 = getEnt ("tport1","targetname");
	port1_2 = getEnt ("tport1_2","targetname");
	port2 = getEnt ("tport2","targetname");
	port2_2 = getEnt ("tport2_2","targetname");
	super1 = getEnt ("super1","targetname");
	fire1 = getEnt ("rockerfire", "targetname");
	fire2 = getEnt ("hardfire", "targetname");
	fire3 = getEnt ("easyfire", "targetname");
	light1 = getEnt ("sredlight1","targetname");
	light2 = getEnt ("sredlight2","targetname");
	
	trigger waittill ("trigger", player);
	PlayFXOnTag(level.orbitacti,super1,"tag_origin");
	playfx(level.orbitpickup,point1.origin);
	playfx(level.orbittele,port1.origin);
	playfx(level.orbittele,port1_2.origin);
	playfx(level.orbittele,port2.origin);
	playfx(level.orbittele,port2_2.origin);
	playfx(level.orbitmagic,fire1.origin);
	playfx(level.orbithard,fire2.origin);
	playfx(level.orbiteasy,fire3.origin);
	playfx(level.orbitlight,light1.origin);
	playfx(level.orbitlight,light2.origin);
}

	acti_rise()
{
	trigger = getent ("acti_risetrig","targetname");
	point1 = getent ("acti_rise2","targetname");
	point2 = getent ("acti_rise3","targetname");
	for(;;)
	{
		trigger waittill ("trigger",user);
		air = spawn ("script_model",(0,0,0));
		air.origin = user.origin;
		air.angles = user.angles;
		user linkto (air);
		air moveto (point1.origin, 3);
		air waittill ("movedone");
		wait 0.5;
		user unlink();
		user SetOrigin(point2.origin);
        user SetPlayerAngles( point2.angles );
	}
}

acti_bspawn()
{
	trig = getEnt ("acti_bspawn", "targetname");
	end = getEnt ("acti_bspawngo", "targetname");
	object = getEnt ("saucer","targetname");
	trig enablelinkto ();
	trig linkto (object);
	trig SetCursorHint("HINT_ACTIVATE");
	while(1)
    {
        trig waittill ("trigger", player);          
		player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}

}

trap1()
{
	trigger = getent ("trap1_trig","targetname");
	object1 = getent ("trap1_1","targetname");
	object3 = getent ("trap1_3","targetname");
	trigger SetCursorHint("HINT_ACTIVATE");
	trigger waittill ("trigger",player);

	
}
object24()
{
	object2 = getent ("trap1_2","targetname");
	object4 = getent ("trap1_4","targetname");
	while(1)
	{
		object2 movez(-256,1);
		object4 movez(-256,1);
		object4 waittill ("movedone");
		wait 1.5;
		object2 movez(256,1);
		object4 movez(256,1);
		object4 waittill ("movedone");
		wait 1.5;
	}
}
object23()
{
	object2 = getent ("trap1_2","targetname");
	object4 = getent ("trap1_3","targetname");
	while(1)
	{
		object2 rotateyaw(180,1);
		object4 rotateyaw(180,1);
		object4 waittill ("rotatedone");
		wait 1.5;
		object2 rotateyaw(-180,1);
		object4 rotateyaw(-180,1);
		object4 waittill ("rotatedone");
		wait 1.5;
		object2 rotateyaw(-180,1);
		object4 rotateyaw(-180,1);
		object4 waittill ("rotatedone");
		wait 1.5;
		object2 rotateyaw(180,1);
		object4 rotateyaw(180,1);
		object4 waittill ("rotatedone");
		wait 1.5;
	}
}
actigo2()
{
	trigger = getEnt ("actigo2_trig","targetname");
	object = getEnt ("saucer","targetname");
	point1 = getEnt ("actigo2_1","targetname");
	point2 = getEnt ("actigo2_2","targetname");
	point3 = getEnt ("actigo2_3","targetname");
	spinner = getEnt ("acti_spinner","targetname");
	trigger SetCursorHint("HINT_ACTIVATE");
	trigger waittill ("trigger", player);
	player linkto (object);
	object moveto(point1.origin,3,3);
	//spinner rotateyaw(2160,8,4,4);
	spinner moveto(point1.origin,3,3);
	object waittill ("movedone");
	object moveto(point2.origin,2);
	spinner moveto(point2.origin,2);
	object waittill ("movedone");
	object moveto(point3.origin,2,0,2);
	object rotateyaw (-180,3);
	spinner moveto(point3.origin,2,0,2);
	object waittill ("movedone");
	player unlink();
}

trap2()
{
	trigger = getEnt ("trap2_trig","targetname");
	object = getEnt ("trap2","targetname");
	trigger SetCursorHint("HINT_ACTIVATE");
	trigger waittill ("trigger", player);
	
}

actigo3()
{
	trigger = getEnt ("actigo3_trig","targetname");
	object = getEnt ("saucer","targetname");
	point1 = getEnt ("actigo3_1","targetname");
	point2 = getEnt ("actigo3_2","targetname");
	point3 = getEnt ("actigo3_3","targetname");
	spinner = getEnt ("acti_spinner","targetname");
	trigger SetCursorHint("HINT_ACTIVATE");
	trigger waittill ("trigger", player);
    player linkto (object);
	object moveto(point1.origin,2,2);
	//spinner rotateyaw(2160,7,3.5,3.5);
	spinner moveto(point1.origin,2,2);
	object waittill ("movedone");
	object moveto(point2.origin,1.5);
	spinner moveto(point2.origin,1.5);
	object waittill ("movedone");
	object moveto(point3.origin,1.5,0,1.5);
	spinner moveto(point3.origin,1.5,0,1.5);
	object waittill ("movedone");
	player unlink();
}

trap3()
{
	trigger = getEnt ("trap3_trig","targetname");
	object = getEnt ("trap3","targetname");
	trigger SetCursorHint("HINT_ACTIVATE");
	trigger waittill ("trigger", player);
	
}

actigo4()
{
	trigger = getEnt ("actigo4_trig","targetname");
	object = getEnt ("saucer","targetname");
	point1 = getEnt ("actigo4_1","targetname");
	point2 = getEnt ("actigo4_2","targetname");
	point3 = getEnt ("actigo4_3","targetname");
	spinner = getEnt ("acti_spinner","targetname");
	trigger SetCursorHint("HINT_ACTIVATE");
	trigger waittill ("trigger", player);
	player linkto (object);
	object moveto(point1.origin,3,3);
	//spinner rotateyaw(2160,8,4,4);
	spinner moveto(point1.origin,3,3);
	object waittill ("movedone");
	object moveto(point2.origin,2);
	spinner moveto(point2.origin,2);
	object waittill ("movedone");
	object moveto(point3.origin,2,0,2);
	object rotateyaw (-90,2);
	spinner moveto(point3.origin,2,0,2);
	object waittill ("movedone");
	player unlink();
}

trap4()
{
	trigger = getEnt ("trap4_trig","targetname");
	object1 = getEnt ("trap4_1","targetname");
	object2 = getEnt ("trap4_2","targetname");
	trigger SetCursorHint("HINT_ACTIVATE");
	trigger waittill ("trigger", player);
	
}

actigo5()
{
	trigger = getEnt ("actigo5_trig","targetname");
	object = getEnt ("saucer","targetname");
	point1 = getEnt ("actigo5_1","targetname");
	point2 = getEnt ("actigo5_2","targetname");
	point3 = getEnt ("actigo5_3","targetname");
	spinner = getEnt ("acti_spinner","targetname");
	trigger SetCursorHint("HINT_ACTIVATE");
	trigger waittill ("trigger", player);
	player linkto (object);
	object moveto(point1.origin,1.75,1.75);
	//spinner rotateyaw(2160,5,2.5,2.5);
	spinner moveto(point1.origin,1.75,1.75);
	object waittill ("movedone");
	object moveto(point2.origin,1.75);
	spinner moveto(point2.origin,1.75);
	object waittill ("movedone");
	object moveto(point3.origin,1.75,0,1.75);
	spinner moveto(point3.origin,1.75,0,1.75);
	object waittill ("movedone");
	player unlink();
}

trap5()
{
	trigger = getEnt ("trap5_trig","targetname");
	trash5 = getentarray("trappo5", "targetname");
	//trash5 hide();
	trigger SetCursorHint("HINT_ACTIVATE");
	trigger waittill ("trigger", player);
	
}

trap5_starter()
{
trash5 = getentarray("trappo5", "targetname");
	for(i = 0; i < trash5.size; i++)
	{
                    thread spin(trash5[i]);
					thread spots(trash5[i]);
	}
}

actigo66()
{
	trigger = getEnt ("actigo66_trig","targetname");
	object = getEnt ("saucer","targetname");
	point1 = getEnt ("actigo66_1","targetname");
	point2 = getEnt ("actigo66_2","targetname");
	spinner = getEnt ("acti_spinner","targetname");
	trigger SetCursorHint("HINT_ACTIVATE");
	trigger waittill ("trigger", player);
	player linkto (object);
	object moveto(point1.origin,2,2);
	//spinner rotateyaw(2160,6,3,3);
	spinner moveto(point1.origin,2,2);
	object waittill ("movedone");
	object moveto(point2.origin,2,0,2);
	object rotateyaw (-90,4);
	spinner moveto(point2.origin,2,0,2);
	object waittill ("movedone");
	player unlink();
}

trap66()
{
	trigger = getEnt ("trap66_trig","targetname");
	move = getEnt ("actigo6_trig","targetname");
	catch = getEnt ("trap66_catch","targetname");
	super1 = getEnt("super1", "targetname");
	burner = getEnt("trap66burn", "targetname");
	burnerb = getEnt("trap66back", "targetname");
	catch maps\mp\_utility::triggeroff();
	trigger SetCursorHint("HINT_ACTIVATE");
	trigger waittill ("trigger", player);

}
trap66_rise()
{
	trigger = getEnt ("trap66_catch","targetname");
	catch2 = getEnt ("trap66_catchgo","targetname");
	for(;;)
	{
		trigger waittill ("trigger",user);
		air = spawn ("script_model",(0,0,0));
		air.origin = user.origin;
		air.angles = user.angles;
		user linkto (air);
		air moveto (catch2.origin, 3);
		air waittill ("movedone");
		wait 3;
		user finishPlayerDamage(self, self, 500, 0, "MOD_PROJECTILE", "jump_mp", self.origin, AnglesToForward((-90, 0, 0)), "none", 0);
		user unlink();
	}
}
actigo6()
{
	trigger = getEnt ("actigo6_trig","targetname");
	object = getEnt ("saucer","targetname");
	point1 = getEnt ("actigo6_1","targetname");
	point2 = getEnt ("actigo6_2","targetname");
	point3 = getEnt ("actigo6_3","targetname");
	spinner = getEnt ("acti_spinner","targetname");
	trigger SetCursorHint("HINT_ACTIVATE");
	trigger waittill ("trigger", player);
	player linkto (object);
	object moveto(point1.origin,2,2);
	//spinner rotateyaw(2160,6,3,3);
	spinner moveto(point1.origin,2,2);
	object rotateyaw (90,2);
	object waittill ("movedone");
	object moveto(point2.origin,2);
	spinner moveto(point2.origin,2);
	object rotateyaw (90,2);
	object waittill ("movedone");
	object moveto(point3.origin,2,0,2);
	spinner moveto(point3.origin,2,0,2);
	object rotateyaw (90,2);
	object waittill ("movedone");
	player unlink();
}

trap6()
{
	trigger = getEnt ("trap6_trig","targetname");
	spot1 = getEnt("trap6_b1", "targetname");
	spot2 = getEnt("trap6_b2", "targetname");
	spot3 = getEnt("trap6_b3", "targetname");
	spot4 = getEnt("trap6_b4", "targetname");
	trigger SetCursorHint("HINT_ACTIVATE");
	trigger waittill ("trigger", player);

}

trap6_kill1()
{
	trik = getEnt ("trap6_kill1","targetname");
	kill = getEnt ("trap6_o1","targetname");
	trik enablelinkto ();
	trik linkto (kill);
	while(1)
	{
	kill movey(-2496,4);
	kill waittill ("movedone");
	trik notSolid();
	kill movey(2496,0.1);
	kill waittill ("movedone");
	wait 7.9;
	trik Solid();
	}
}

trap6_kill3()
{
	kill = getEnt ("trap6_kill3","targetname");
	object = getEnt ("trap6_o3","targetname");
	kill enablelinkto ();
	kill linkto (object);
	while(1)
	{
	wait 6;
	kill Solid();
	object movey(-2496,4);
	object waittill ("movedone");
	kill notSolid();
	object movey(2496,0.1);
	object waittill ("movedone");
	wait 1.9;
	}
}

trap6_kill2()
{
	kill = getEnt ("trap6_kill2","targetname");
	object = getEnt ("trap6_o2","targetname");
	kill enablelinkto ();
	kill linkto (object);
	while(1)
	{
	wait 3;
	kill Solid();
	object movey(2496,4);
	object waittill ("movedone");
	kill notSolid();
	object movey(-2496,0.1);
	object waittill ("movedone");
	wait 4.9;
	}
}

trap6_kill4()
{
	kill = getEnt ("trap6_kill4","targetname");
	object = getEnt ("trap6_o4","targetname");
	kill enablelinkto ();
	kill linkto (object);
	wait 0.1;
	while(1)
	{
	wait 7.9;
	kill Solid();
	object movey(2496,4);
	object waittill ("movedone");
	kill notSolid();
	object movey(-2496,0.1);
	object waittill ("movedone");
	}
}

actigo7()
{
	trigger = getEnt ("actigo7_trig","targetname");
	object = getEnt ("saucer","targetname");
	point1 = getEnt ("actigo7","targetname");
	spinner = getEnt ("acti_spinner","targetname");
	trigger SetCursorHint("HINT_ACTIVATE");
	trigger waittill ("trigger", player);
	player linkto (object);
	object moveto(point1.origin,4,2,2);
	//spinner rotateyaw(2160,6,3,3);
	spinner moveto(point1.origin,4,2,2);
	object rotateyaw (-90,4);
	object waittill ("movedone");
	player unlink();
}

trap7()
{
	trigger = getEnt ("trap7_trig","targetname");
	object = getEnt ("trap7","targetname");
	trigger SetCursorHint("HINT_ACTIVATE");
	trigger waittill ("trigger", player);

}

actigo8()
{
	trigger = getEnt ("actigo8_trig","targetname");
	object = getEnt ("saucer","targetname");
	point1 = getEnt ("actigo8","targetname");
	spinner = getEnt ("acti_spinner","targetname");
	trigger SetCursorHint("HINT_ACTIVATE");
	trigger waittill ("trigger", player);
	player linkto (object);
	object moveto(point1.origin,5,2.5,2.5);
	//spinner rotateyaw(2160,7,3.5,3.5);
	spinner moveto(point1.origin,5,2.5,2.5);
	object waittill ("movedone");
	player unlink();
}
//* By Phelix and Lolz
onPlayerConnected()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onPlayer();
    }
}
 
onPlayer()
{
    for(;;)
    {
        level waittill("player_spawn",player);
        player.bounced = false;
		player thread Suffocation();
    }
}
 
trap8()
{
    trigger = getEnt ("trap8_trig","targetname");
    trigger SetCursorHint("HINT_ACTIVATE");
    trigger waittill ("trigger", player);
	
}
 
trap8_1()
{
    level.bounceTrigger enableLinkTo();
    level.bounceTrigger linkTo(level.object);
 
    while(1)
    {
        level.bounceTrigger maps\mp\_utility::triggeroff();
        level.object moveZ(-100, 3);
        level.object waittill("movedone");
		level.bounceTrigger maps\mp\_utility::triggeron();
        level.object moveZ(100, 0.2);
        level.object waittill("movedone");
        level.object notify("ObjectAtLocation");
        wait 2;
    }
}
 
bouncePlayerWatch()
{
    for(;;)
    {
        level.bounceTrigger waittill("trigger",p);
        if(isDefined(p.bounced) & !p.bounced)
            p thread bouncePlayer();
    }
}
 
bouncePlayer()
{
    self.bounced = true;
   
    level.object waittill("ObjectAtLocation");
   
    if(self isTouching(level.bounceTrigger))
    {
        for(i=0;i<4;i++)
        {
            self.health += 10000;
            self finishPlayerDamage(self, self, 10000, 0, "MOD_PROJECTILE", "bh_mp", self.origin, AnglesToForward((-90, 0, 0)), "none", 0);
        }
       
        self iprintlnBold ("BOUNCE");
    }
   
    wait 2;
   
    self.bounced = false;
}
//*
actigo9()
{
	trigger = getEnt ("actigo9_trig","targetname");
	object = getEnt ("saucer","targetname");
	point1 = getEnt ("actigo9","targetname");
	spinner = getEnt ("acti_spinner","targetname");
	trigger SetCursorHint("HINT_ACTIVATE");
	trigger waittill ("trigger", player);
	player linkto (object);
	object moveto(point1.origin,6,3,3);
	//spinner rotateyaw(2520,8,4,4);
	spinner moveto(point1.origin,6,3,3);
	object rotateyaw (360,6,3,3);
	object waittill ("movedone");
	player unlink();
}

harddone()
{
        level.hardyas = getent ("harddone","targetname");
        level.jsh = getent ("harddone_goj","targetname");
        level.ash = getent ("acti_bspawngo","targetname");
        while(1)
        {
                level.hardyas waittill ("trigger",player);
                {
						player.sc = 0;
						player.insec = false;
						player notify("secret2_done");
                        player thread sr\api\_speedrun::finishWay("secret_1");
                }
        }
}


easydone()
{
        level.easyyas = getent ("easydone","targetname");
        level.jse = getent ("map_tele2go","targetname");
        level.ase = getent ("acti_bspawngo","targetname");
        while(1)
        {
                level.easyyas waittill ("trigger",player);
                if( player.pers["team"] == "allies" )
                {
						player.sc = 0;
						player.insec = false;
						player notify("secret1_done");
                        player thread sr\api\_speedrun::finishWay("secret_0");
                }
        }
}
//* Scripts by Legend

whendead()
{
	while(self.sessionstat == "playing" && isDefined(self) && isAlive(self) && self.insec == true)
	{
	wait 1;
	}
	if(self.sc != 0)
	{
	self.sc = 0;self iprintlnbold(">>Save counter restarted");
	}
}
setup()
{
	for(i=1;i<=14;i++)
	{
		thread loadtrigger(i);
		thread savetriggers(i);
	}
}

savetriggers(num)
{
	savetrig = getent("saveh_"+num,"targetname");
	for(;;)
	{
		savetrig waittill("trigger",player);
		if(player.sc >= num)
		{
			player.sc = player.sc;
		}
		if(player.sc != num || player.sc < num)
		{
			player.sc = num;
			player iprintln(">> Position: "+player.sc+" Saved");
		}
		wait .1;
	}
}

loadtrigger(num)
{
	spot = getent("loadh_"+num,"targetname");
	trig = getent("hardfail","targetname");
	for(;;)
	{
		trig waittill("trigger",player);
		if(num == player.sc)
		{
			player iprintln(">> Position: "+player.sc+" Loaded");
			player setorigin(spot.origin);
			player setplayerangles(spot.angles);
			wait .1;
		}
	}
}

onroundstart()
{
    level waittill("round_started");
    level.startdooropen = false;
    players = getentarray("player","classname");
    for(i=0;i<players.size;i++)
    {
        players[i].hashelmet = false;
    }
}
Suffocation()
{
   if(level.startdooropen == false)
	{
		wait 17;
	}
	else
	{
		wait 2;
	}
    self.suf = 0;
    while(self.sessionstate == "playing" && self != level.activ && self.hashelmet == false)
    {
        if(self.suf == 4)
        {
            self suicide();
            self.suf = 0;
        }
        for(i=0;i<=32;i++)
        {
            self setclientdvar("r_blur",i);
            wait .005;
        }
		self PlaySoundToPlayer( "breath3", self );
        wait 0.8;
        for(j=32;j>=0;j--)
        {
            self setclientdvar("r_blur",j);
            wait .005;
        }
        wait 0.8;
        self.suf++;
    }
    self.suf = 0;
}

actiplayernoknife()
{
	nest = getent ("acti_bspawngo","targetname");
	datboi = getEnt ("acti_secret", "targetname");
	act2 = getEnt ("acti_act2","targetname");
    self.warn = 0;
    while(self.insec == true && self.sessionstate == "playing")
    {
        if(self.warn == 2)
        {
            if(self != level.activ)
            {
                self suicide();
                self.insec = false;
                self.warn = 0;
				self.sc = 0;
            }
            if(self == level.activ)
            {
				level.activ SetPlayerAngles(nest.angles);
                level.activ SetOrigin(nest.origin);
                level.activ.insec = false;
                level.activ.warn = 0;
				datboi maps\mp\_utility::triggeroff();
				act2 delete();
				level.activ iprintlnBold("You can't enter the secret again this round");
				level.activ.health = 100;
            }
        }
        if(self != level.activ && self MeleeButtonPressed())
        {
            self.warn++;
            self iprintlnbold("dont melee in secret!!\n"+self.warn+"/2");
        }
        if(self == level.activ && level.activ MeleeButtonPressed())
        {
            level.activ.warn++;
            level.activ iprintlnbold("dont melee in secret!!\n"+level.activ.warn+"/2");
        }
        wait 0.5;
    }
    self.warn = 0;
	self.insec = 0;
}

whended()
{
    self waittill("death");
    self.insec=false;
}
//*


creators()
{
	wait 10;
	iPrintlnBold("^4mp_dr_orbit");
	wait 4;
	iPrintlnBold("^5Don't forget to grab helmets!");
	wait 2;
	while(1)
	{
		iprintln("^7Thanks to ^5VC'ERIK ^7and ^5VC'Fox ^7for the models!");
		wait 2;
		iprintln("^7Thanks to ^5VC'Legend^7, ^5VC'Phelix^7, ^5VC'Wingzor ^7and ^5SuX Lolz ^7for helping me with scripts!");
		wait 5;
		iprintln("^7Thanks to ^5Vistic Clan");
		wait 30;
		iprintln("^6steam: TheLixfe");
		wait 5;
		iprintln("^7Map by ^5TheLixfe");
		wait 10;
	}
}
//* By Blade
secret_timer_easy()
{
	self endon("secret1_done");

	if(isdefined(self.secretTimer))
	self.secretTimer destroy();

	self.secretTimer=newclienthudelem(self);
	self.secretTimer.foreground = true;
	self.secretTimer.alignX = "center";
	self.secretTimer.alignY = "bottom";
	self.secretTimer.horzAlign = "center";
        self.secretTimer.vertAlign = "bottom";
        self.secretTimer.x = 0;
        self.secretTimer.y = -7;
        self.secretTimer.sort = 5;
        self.secretTimer.fontScale = 1.6;
        self.secretTimer.font = "default";
        self.secretTimer.glowAlpha = 1;
        self.secretTimer.hidewheninmenu = true;
        self.secretTimer.label = &"Time in left: &&1";
        if(isdefined(level.randomcolor))
	self.secretTimer.glowColor=level.randomcolor;
	else 
	self.secretTimer.glowColor=(1,0,0);

	time=90;
	for(i=0;i<time;i++)
		{
		self.secretTimer setvalue(time-i);
		wait 1;
		}
	self.secretTimer setvalue(0);
	self suicide();

	if(isdefined(self.secretTimer))
	self.secretTimer destroy();
}
 secret_timer_hard()
{
	self endon("secret2_done");

	if(isdefined(self.secretTimer2))
	self.secretTimer2 destroy();

	self.secretTimer2=newclienthudelem(self);
        self.secretTimer2.foreground = true;
	self.secretTimer2.alignX = "center";
	self.secretTimer2.alignY = "bottom";
	self.secretTimer2.horzAlign = "center";
        self.secretTimer2.vertAlign = "bottom";
        self.secretTimer2.x = 0;
        self.secretTimer2.y = -7;
        self.secretTimer2.sort = 5;
        self.secretTimer2.fontScale = 1.6;
	self.secretTimer2.font = "default";
	self.secretTimer2.glowAlpha = 1;
 	self.secretTimer2.hidewheninmenu = true;
 	self.secretTimer2.label = &"Time in left: &&1";
 	if(isdefined(level.randomcolor))
	self.secretTimer2.glowColor=level.randomcolor;
	else 
	self.secretTimer2.glowColor=(1,0,0);

	time=200;
	for(i=0;i<time;i++)
		{
		self.secretTimer2 setvalue(time-i);
		wait 1;
		}
	self.secretTimer2 setvalue(0);

	self suicide();

	if(isdefined(self.secretTimer2))
	self.secretTimer2 destroy();
}

musicMenu()
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "spawned" );
	self endon( "joined_spectators" );
	self endon( "music thread terminated" );
 
	self thread onDeath();
	self thread onDisconnect();
 
	self.hud_music = [];
	self.selection = 0;
 
	// create huds
	i = 0;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 160, 200, 0.6, "left", "top", 2 );
	self.hud_music[i].sort = 880;
	self.hud_music[i] setShader( "black", 320, 160 );
	
	i++;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 210, 204, 0.93, "left", "top", 1.8 );
	self.hud_music[i].sort = 884;
	self.hud_music[i] setText("Welcome to orbit");
	self.hud_music[i].glowalpha=1;
	if(isdefined(level.randomcolor))
		self.hud_music[i].glowcolor=level.randomcolor;
	else 
		self.hud_music[i].glowcolor=(1,0,0);

	i++;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 250, 360, 1, "center", "bottom", 1.4 );
	self.hud_music[i].sort = 886;
	self.hud_music[i] setText("Scroll: ^3[{+attack}] ^7| Select: ^3[{+activate}] ^7| Close: ^3[{+frag}]");
 
	for( j = 0; j < level.music.size; j++ )
	{
		i++;
		self.hud_music[i] = braxi\_mod::addTextHud( self, 172, 230+(j*16), 0.93, "left", "top", 1.4 );
		self.hud_music[i].sort = 882;
		self.hud_music[i].font = "objective";
		self.hud_music[i].glowalpha=1;
		if(isdefined(level.randomcolor))
			self.hud_music[i].glowcolor=level.randomcolor;
		else 
			self.hud_music[i].glowcolor=(1,0,0);
 
		entry = level.music[j];
		self.hud_music[i] setText(entry["song"]);
	}
 
	i++;
	self.hud_music[self.hud_music.size] = braxi\_mod::addTextHud( self, 167, 230, 0.4, "left", "top", 1.4 );
	self.hud_music[i].sort = 881;
	indicator = self.hud_music[self.hud_music.size-1];
	indicator setShader( "white", 306, 17 );
 
	while(self.sessionstate == "playing")
	{
		wait 0.1;
 
		if(self attackButtonPressed())
		{
			self.hud_music[3+self.selection].alpha = 0.93;
 
			self.selection++;
			if( self.selection >= level.music.size )
				self.selection = 0;
 
			item = self.hud_music[3+self.selection];
			item.alpha = 1;
			indicator.y = item.y;
		}
		else if(self useButtonPressed())
		{
 			iprintln("^1>> ^7Now playing: ^1"+level.music[self.selection]["song"]);
			ambientPlay(level.music[self.selection]["alias"]);
			self freezecontrols(0);
			break;
		}
		else if(self fragButtonPressed())
		{
			self freezecontrols(0);
			break;
		}
	}
 
	self cleanUp();
}
 
	musictrig()
{
	trig = getEnt ("musictrig", "targetname");
	trig setHintString("Press [^5&&1^7] to choose Music");
 
	trig waittill("trigger",player);
	player freezecontrols(1);
	trig delete();
	player musicMenu();
}
 
	onDisconnect()
{
	self endon( "music thread terminated" );
	self waittill( "disconnect" );
	self cleanUp();
}
 
	onDeath()
{
	self endon( "disconnect" );
	self endon( "music thread terminated" );
	self waittill( "death" );
	self cleanUp();
}
 
	cleanUp()
{
	if( !isDefined( self ) )
		return;

	
 
	if( isDefined( self.hud_music ) )
	{
		for( i = 0; i < self.hud_music.size; i++ )
		{
			if( isDefined( self.hud_music[i] ) )
				self.hud_music[i] destroy();
		}
	}
	self notify( "music thread terminated" );
}

sniper_room_battle()
{
    level.sniper_trig=getent("sniproom_ent","targetname");
    level.sniper_trig SetHintString("Sniper");
    jump=getent("sniproom_go","targetname");
    acti=getent("sniproom_acti","targetname");
 
    while(1)
    {
       level.sniper_trig waittill("trigger",player);


        if(!isdefined(level.sniper_trig)) return;
 
        if(!isdefined(level.entertext)||!level.entertext)
        {
            level.entertext=true;
           
			level.activ unlink();
 
			level.knife_trig delete();
			level.banana_trig delete();
 
            iprintlnbold("^1"+player.name+" ^7entered Sniper room.");
        }
 
        player createroomport("m40a3_mp","remington700_mp",1,jump,100);
        level.activ createroomport("m40a3_mp","remington700_mp",1,acti,100);
 
        player thread countdown();
        level.activ thread countdown();
 
       	while(isalive(player)&&isdefined(player))
            wait 1;

        iPrintlnBold("^1"+self.name+" ^7died^1!");
    }
}
banana_room_battle()
{
    level.banana_trig=getent("bananaroom_ent","targetname");
	level.banana_trig SetHintString("banana");
    jump=getent("bananaroom_go","targetname");
    acti=getent("bananaroom_acti","targetname");
 
    while(1)
    {
       level.banana_trig waittill("trigger",player);


        if(!isdefined(level.banana_trig)) return;
 
        if(!isdefined(level.entertext)||!level.entertext)
        {
            level.entertext=true;
			
			ambientstop();
            ambientplay("slump");
            level.canPlaySound=false;

            iprintln("^1Now playing:^7 Ski Mask The Slump God ^1-^7 Catch Me Outside");
           
			level.activ unlink();
 
			level.knife_trig delete();
			level.sniper_trig delete();
 
            iprintlnbold("^1"+player.name+" ^7entered Banana room.");
        }
 
        player createroomport("bananagun_mp",undefined,1,jump,100);
        level.activ createroomport("bananagun_mp",undefined,1,acti,100);
 
        player thread countdown();
        level.activ thread countdown();
 
       	while(isalive(player)&&isdefined(player))
            wait 1;

        iPrintlnBold("^1"+self.name+" ^7died^1!");
    }
}

knife_room_battle()
{
    level.knife_trig=getent("kniferoom_ent","targetname");
 
    knife=getent("kniferoom_go","targetname");
    acti=getent("kniferoom_acti","targetname");
 
    while(1)
    {
        level.knife_trig waittill("trigger",player);
        if(!isdefined(level.knife_trig)) return;
 
        if(!isdefined(level.entertext)||!level.entertext)
        {
            level.entertext=true;
           
			level.activ unlink();
 
            level.sniper_trig delete();
			level.banana_trig delete();

 
            iprintlnbold("^1"+player.name+" ^7entered Knife room.");
        }
 
		wait 2;
 
        player createroomport("knife_mp",undefined,1,knife,100);
        level.activ createroomport("knife_mp",undefined,1,acti,100);
 
        player thread countdown();
        level.activ thread countdown();
 
       	while(isalive(player)&&isdefined(player))
            wait 1;

         iPrintlnBold("^1"+self.name+" ^7died^1!");
    }
}

createroomport(weapon,weapon2,freeze,where,health)
{
    self takeallweapons();
    self giveweapon(weapon);
    if(isdefined(weapon2))
    	self giveweapon(weapon2);
    self switchtoweapon(weapon);
 
    self freezecontrols(freeze);
    self setorigin(where.origin);
    self setplayerangles(where.angles);
 
    self.health=health;
}
 
countdown()
{
    self iprintlnbold("^33");
    wait 1;
    self iprintlnbold("^32");
    wait 1;
    self iprintlnbold("^31");
    wait 1;
    self iprintlnbold("^5Fight!");
    wait 1;
    self freezecontrols(0);
}
//*


lowgrav()
{
    trig = GetEnt("lowgrav","targetname");
	end = GetEnt("alternate","targetname");
	obj = GetEnt("alternative","targetname");
	obj hide();
	obj notSolid();
        trig waittill("trigger", player );
		iPrintlnBold (" "+player.name+" activates the alternative end road in 10 seconds");
		player freezecontrols(1);
		player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
		wait 10;
		obj show();
		obj Solid();
		player freezecontrols(0);
		thread alt_ent();
}

wep_fail()
{
	trig = getEnt ("wep_fail", "targetname");
	end = getEnt ("wep_fail_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
		player freezecontrols(1);
		player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
		player playSound("telesound");
		wait 2;
		player freezecontrols(0);
	}

}

knife_fail()
{
        level.knifefail = getent ("knife_fail","targetname");
        level.js = getent ("kniferoom_go","targetname");
        level.as = getent ("kniferoom_acti","targetname");
        while(1)
        {
                level.bouncefail waittill ("trigger",player);
                if( player.pers["team"] == "allies" )
                {
                        player SetPlayerAngles(level.js.angles);
                        player SetOrigin(level.js.origin);
						player freezecontrols(1);
						wait 2;
						player freezecontrols(0);
                }
                else
                {
                        player SetPlayerAngles(level.as.angles);
                        player SetOrigin(level.as.origin);
						player freezecontrols(1);
						wait 2;
						player freezecontrols(0);
						
                }
        }
}

alt_ent()
{
	trig = getEnt ("alt_ent", "targetname");
	end = getEnt ("alt_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);          
		player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}

}

secretlounge_fail()
{
	trig = getEnt ("secretlounge_fail", "targetname");
	end = getEnt ("choose1_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
		player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
		player playSound("telesound");
	}

}
