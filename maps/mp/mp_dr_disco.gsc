//wut, why are you looking into my script?
//hmpf, nvm. Just gimme credits if you use parts of it^^
//(C)+(r) DeltaBoss
//Special thx to Wingzor, PetX, Braxi. (and Lossy)

main()
{
thread sr\api\_map::createSpawnOrigin((16.125, 64, 16.125), 270);
	maps\mp\_load::main();
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	//setdvar( "r_specularcolorscale", "1" );

	PreCacheItem("m21_mp");
	PreCacheItem("dragunov_mp");
	PreCacheItem("barrett_mp");
	PreCacheItem("rpg_mp");
	PreCacheItem("c4_mp");
	PreCacheItem("frag_grenade_mp");
	PreCacheItem("m1014_grip_mp");
	PreCacheItem("winchester1200_grip_mp");
	PreCacheItem("mp5_reflex_mp");
	PreCacheItem("smoke_grenade_mp");
	PreCacheItem("rpd_grip_mp");
	PreCacheItem("smoke_grenade_mp");

	thread starting_block();
	thread enter_floor2();
	thread enter_floor3();
	thread killzone1();
	thread killzone2();
	thread killzone3();
	thread killzonefloor2();
	thread killzonefloor3();
	thread killzonefun1();
	// thread fun1a();
	// thread fun1b();
	// thread fun1c();
	// thread fun2();
	// thread fun3();
	// thread fun4();
	thread trap1a();
	thread trap1b();
	thread trap1c();
	thread trap1d();
	thread trap1e();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap4killzone();
	thread trap5();
	thread trap6();
	thread trap7();
	// thread trap7platform();
	thread trap8();
	thread trap9();
	thread end();
	// thread end_doors();-
	thread end_spin_killzone();
	rain1 = getEnt("rain1","targetname");
	rain2 = getEnt("rain2","targetname");

//	thread addTestClients();

	addTriggerToList("trig_trap1");
	addTriggerToList("trig_trap2");
	addTriggerToList("trig_trap3");
	addTriggerToList("trig_trap4");
	addTriggerToList("trig_trap5");
	addTriggerToList("trig_trap6");
	addTriggerToList("trig_trap7");
	addTriggerToList("trig_trap8");
	addTriggerToList("trig_trap9");
	addTriggerToList("trig_fun1c");
	addTriggerToList("fun3_trig");
	addTriggerToList("fun4_trig1");

//	braxi\_common::mapAuthor("DeltaBoss","62e7143c"); Why doesnt this work? D:

	level._effect["regen"] = loadfx("weather/rain_heavy");
	maps\mp\_fx::loopfx("regen",(rain1.origin),3,(rain1.origin)+(0,0,90));
	maps\mp\_fx::loopfx("regen",(rain2.origin),3,(rain2.origin)+(0,0,90));
}

addTriggerToList(name)
{
	if( !isDefined( level.trapTriggers ) )
	{
		level.trapTriggers = [];
	}
	level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

starting_block()
{
	sblock = getent ("startblock", "targetname");
	trig = getent ("startblock_trig", "targetname");
	quake = getent("begin_quake","targetname");

	// trig waittill ("trigger",player);
	trig delete ();
	/* [AUTO DELETE] iPrintLn("Map by DeltaBoss"); */
	earthquake(0.5,3,quake.origin,1000);
	/* [AUTO DELETE] ambientPlay("floor1",0); */
	/* [AUTO DELETE] iPrintLnBold("^1READY"); */
	wait 2;
	/* [AUTO DELETE] iPrintLnBold("^3SET"); */
	wait 2;
	/* [AUTO DELETE] iPrintLnBold("^2DANCE^7!"); */
	sblock movez (272, 5, 0, 0);
	sblock waittill ("movedone");
}


enter_floor2()
{
	trig = getent ("trig_floor2", "targetname");

	trig waittill ("trigger", player);
	trig delete();
	ambientStop(0);
	/* [AUTO DELETE] ambientPlay("floor2"); */
	/* [AUTO DELETE] iPrintLnBold("^1"+ player.name + " " + "^3" + "reached the 2nd floor!"); */
}


enter_floor3()
{
	trig = getent ("trig_floor3", "targetname");

	trig waittill ("trigger", player);
	trig delete();
	ambientStop(0);
	/* [AUTO DELETE] ambientPlay("floor3"); */
	/* [AUTO DELETE] iPrintLnBold("^6"+ player.name + " " + "^2" + "reached the 3rd floor!"); */
}


killzone1()
{
	trig = getent("kill_trig1","targetname");
	while (true)
	{
		trig waittill ("trigger", player);
		player suicide();
	}
}

killzone2()
{
	trig = getent("kill_trig2","targetname");
	while (true)
	{
		trig waittill ("trigger", player);
		player suicide();
	}
}

killzone3()
{
	trig = getent("kill_trig3","targetname");
	while (true)
	{
		trig waittill ("trigger", player);
		player suicide();
	}
}

killzonefun1()
{
	trig = getent("kill_trigfun1","targetname");
	while (true)
	{
		trig waittill ("trigger", player);
		/* [AUTO DELETE] player SayAll("I'm such an idiot!"); */
		player suicide();
	}
}

killzonefloor2()
{
	trig = getent("kill_trigfloor2","targetname");
	while (true)
	{
		trig waittill ("trigger", player);
		player suicide();
	}
}

killzonefloor3()
{
	trig = getent("trig_killzone_3f","targetname");
	while (true)
	{
		trig waittill ("trigger", player);
		player suicide();
	}
}

fun1a()
{

    block = getent("fun1", "targetname");
    trig = getent("trig_fun1a", "targetname");

	while (true)
	{
		trig waittill ("trigger");
		block rotateroll(90, 0.2);
		wait 2;
		block rotateroll(90,0.2);
	}
}


fun1b()
{
	trig = getent("trig_fun1b","targetname");


	trig waittill ("trigger", player);
	/* [AUTO DELETE] iPrintLnBold (player.name + " got the mp5??!!!?!?!?!!111one"); */
	trig delete();
}


fun1c()
{
	trig = getent("trig_fun1c","targetname");
	braxi = getent("fun1c","targetname");

	trig waittill("trigger");
	trig delete();
	/* [AUTO DELETE] iprintln("Something moved!"); */
	braxi movey(200,1);
}


fun2()
{
	trig = getent("fun2_trig","targetname");
	while(true)
	{
		trig waittill("trigger",player);
		/* [AUTO DELETE] player SayAll("LOL, I have no idea what I'm doing here!"); */
		trig delete();
	}
}


fun3()
{
	trig = getent("fun3_trig","targetname");
	trigcreds = getent("fun3_weap","targetname");
	block = getent("fun3_block","targetname");

	trig waittill("trigger");
	trig delete();
	/* [AUTO DELETE] iprintln("^2Something happend!"); */
	block notSolid();

	trigcreds waittill("trigger");
	trigcreds delete();
	/* [AUTO DELETE] iprintlnbold("^2DeltaBoss greets 'ya all!"); */
	/* [AUTO DELETE] iprintln("^2 Greetings to my clan SWAT|"); */
	/* [AUTO DELETE] iprintln("^3 Greetings to Tremolo4"); */
	/* [AUTO DELETE] iprintln("^4 Greetings to Universal Alliance!"); */
	/* [AUTO DELETE] iprintln("^5 Greetings to all my other friends!"); */
	wait 5;
	/* [AUTO DELETE] iprintln("Didn't read?"); */
	wait 2;
	/* [AUTO DELETE] iprintln("No problem!"); */
	wait 2;
	/* [AUTO DELETE] iprintln("Here they go again:"); */
	wait 1;
	/* [AUTO DELETE] iprintln("^2 Greetings to my clan SWAT|"); */
	wait 1;
	/* [AUTO DELETE] iprintln("^3 Greetings to Tremolo4"); */
	wait 1;
	/* [AUTO DELETE] iprintln("^4 Greetings to Universal Alliance!"); */
	wait 1;
	/* [AUTO DELETE] iprintln("^5 Greetings to all my other friends!"); */
}


fun4()
{
	trig1 = getent("fun4_trig1","targetname");
	trig2 = getent("fun4_trig2","targetname");
	trig3 = getent("fun4_trig3","targetname");
	block1 = getent("fun4_block1","targetname");
	block2 = getent("fun4_block2","targetname");

	trig1 waittill("trigger");
	trig1 delete();
	block1 notSolid();
	/* [AUTO DELETE] iprintln("^3Did something just happen?"); */
	trig2 waittill("trigger");
	trig2 delete();
	block2 notSolid();
	/* [AUTO DELETE] iprintln("^2I'm pretty sure something just happend!"); */
	trig3 waittill("trigger",player);
	trig3 delete();
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("",50); */
	/* [AUTO DELETE] iPrintLnBold(player.name+" ^2is a pretty cool guy!"); */
}


trap1a()
{
	level endon("trigger");
	za1 = getent("trap1_a1","targetname");
	zb1 = getent("trap1_b1","targetname");
	zc1 = getent("trap1_c1","targetname");
	za3 = getent("trap1_a3","targetname");
	zb3 = getent("trap1_b3","targetname");
	zc3 = getent("trap1_c3","targetname");
	trig = getent("trig_trap1","targetname");

	r1 = randomIntRange(5,10)/10;
	r2 = r1/2;

	trig waittill("trigger");

	za3 rotateyaw(360,r2);
	zb3 rotateyaw(360,r2);
	zc3 rotateyaw(360,r2);
	za1 rotateyaw(360,r1);
	zb1 rotateyaw(360,r1);
	zc1 rotateyaw(360,r1);

	while (true)
	{
		wait r2;
		za3 rotateyaw(360,r2);
		zb3 rotateyaw(360,r2);
		zc3 rotateyaw(360,r2);
		wait r2;
		za1 rotateyaw(360,r1);
		zb1 rotateyaw(360,r1);
		zc1 rotateyaw(360,r1);
		za3 rotateyaw(360,r2);
		zb3 rotateyaw(360,r2);
		zc3 rotateyaw(360,r2);
	}
}


trap1b()
{
	level endon("trigger");
	za2 = getent("trap1_a2","targetname");
	zb2 = getent("trap1_b2","targetname");
	zc2 = getent("trap1_c2","targetname");
	trig = getent("trig_trap1","targetname");

	r3 = randomIntRange(15,30)/10;

	trig waittill("trigger");

	while(true)
	{
		za2 rotateyaw(-360,r3);
		zb2 rotateyaw(-360,r3);
		zc2 rotateyaw(-360,r3);
		wait r3;
	}
}


trap1c()
{
	level endon("trigger");
	za4 = getent("trap1_a4","targetname");
	zb4 = getent("trap1_b4","targetname");
	zc4 = getent("trap1_c4","targetname");
	za5 = getent("trap1_a5","targetname");
	zb5 = getent("trap1_b5","targetname");
	zc5 = getent("trap1_c5","targetname");
	trig = getent("trig_trap1","targetname");

	r4 = randomIntRange(10,20)/10;
	r5 = r4*2;

	trig waittill("trigger");

	za5 rotateyaw(-360,r5);
	zb5 rotateyaw(-360,r5);
	zc5 rotateyaw(-360,r5);
	za4 rotateyaw(-360,r4);
	zb4 rotateyaw(-360,r4);
	zc4 rotateyaw(-360,r4);

	while (true)
	{
		wait r4;
		za4 rotateyaw(-360,r4);
		zb4 rotateyaw(-360,r4);
		zc4 rotateyaw(-360,r4);
		wait r4;
		za5 rotateyaw(-360,r5);
		zb5 rotateyaw(-360,r5);
		zc5 rotateyaw(-360,r5);
		za4 rotateyaw(-360,r4);
		zb4 rotateyaw(-360,r4);
		zc4 rotateyaw(-360,r4);
	}
}

trap1d()
{
	level endon("trigger");
	za6 = getent("trap1_a6","targetname");
	zb6 = getent("trap1_b6","targetname");
	zc6 = getent("trap1_c6","targetname");
	trig = getent("trig_trap1","targetname");

	r6 = randomIntRange(15,20)/10;

	trig waittill("trigger");

	while (true)
	{
		za6 rotateyaw(360,r6);
		zb6 rotateyaw(360,r6);
		zc6 rotateyaw(360,r6);
		wait r6;
	}
}

trap1e()
{
	level endon("trigger");
	za7 = getent("trap1_a7","targetname");
	zb7 = getent("trap1_b7","targetname");
	zc7 = getent("trap1_c7","targetname");
	trig = getent("trig_trap1","targetname");

	r7 = randomIntRange(20,30)/10;

	trig waittill("trigger");
	trig delete();

	while (true)
	{
		za7 rotateyaw(-360,r7);
		zb7 rotateyaw(-360,r7);
		zc7 rotateyaw(-360,r7);
		wait r7;
	}
}


trap2()
{
	level endon("trigger");
	p1 = getent("trap2_1","targetname");
//	p2 = getent("trap2_2","targetname");
//	p3 = getent("trap2_3","targetname");
	p4 = getent("trap2_4","targetname");
	p5 = getent("trap2_5","targetname");
	p6 = getent("trap2_6","targetname");
	p7 = getent("trap2_7","targetname");
	p8 = getent("trap2_8","targetname");
	p9 = getent("trap2_9","targetname");
	p10 = getent("trap2_10","targetname");
	p11 = getent("trap2_11","targetname");
	p12 = getent("trap2_12","targetname");
	p13 = getent("trap2_13","targetname");
	p14 = getent("trap2_14","targetname");
	p15 = getent("trap2_15","targetname");
	p16 = getent("trap2_16","targetname");
	p17 = getent("trap2_17","targetname");
	p18 = getent("trap2_18","targetname");
	p19 = getent("trap2_19","targetname");
	p20 = getent("trap2_20","targetname");
	p21 = getent("trap2_21","targetname");
	p22 = getent("trap2_22","targetname");
	p23 = getent("trap2_23","targetname");
	p24 = getent("trap2_24","targetname");
	p25 = getent("trap2_25","targetname");
	p26 = getent("trap2_26","targetname");
	p27 = getent("trap2_27","targetname");
	p28 = getent("trap2_28","targetname");
	trig = getent("trig_trap2","targetname");

	trig waittill("trigger");
	trig delete();
	while (true)
	{
		p1 movez(128,2);
		p4 movey(128,2);
		p5 rotatepitch(360,2);
		p6 movez(-128,2);
		p7 movex(128,2);
		p8 rotateroll(90,2);
		p9 rotatepitch(-30,2);
		p10 movex(-192,2);
		p11 movez(64,2);
		p12 rotateyaw(180,2);
		p13 movex(-192,2);
		p14 rotateyaw(-90,2);
		p15 movey(-64,2);
		p16 rotateroll(-45,2);
		p17 rotateyaw(720,2);
		p18 movey(64,2);
		p19 movez(128,2);
		p20 rotatepitch(75,2);
		p21 movey(-64,2);
		p22 rotatepitch(-15,2);
		p23 movex(-64,2);
		p24 rotateroll(60,2);
		p25 movez(-64,2);
		p26 rotateyaw(90,2);
		p27 rotateroll(-60,2);
		p28 movey(128,2);

		p1 waittill("movedone");

		p1 movez(-128,2);
		p4 movey(-128,2);
		p5 rotatepitch(360,2);
		p6 movez(128,2);
		p7 movex(-128,2);
		p8 rotateroll(90,2);
		p9 rotatepitch(-30,2);
		p10 movex(192,2);
		p11 movez(-64,2);
		p12 rotateyaw(180,2);
		p13 movex(192,2);
		p14 rotateyaw(-90,2);
		p15 movey(64,2);
		p16 rotateroll(-45,2);
		p17 rotateyaw(720,2);
		p18 movey(-64,2);
		p19 movez(-128,2);
		p20 rotatepitch(75,2);
		p21 movey(64,2);
		p22 rotatepitch(-15,2);
		p23 movex(64,2);
		p24 rotateroll(60,2);
		p25 movez(64,2);
		p26 rotateyaw(90,2);
		p27 rotateroll(-60,2);
		p28 movey(-128,2);


		p1 waittill("movedone");
	}
}


trap3()
{
	level endon("trigger");
	bka = getent("trap3_a","targetname");
	bkb = getent("trap3_b","targetname");
	bkc = getent("trap3_c","targetname");
	trig = getent("trig_trap3","targetname");

	trig waittill("trigger");
	trig delete();
	while(true)
	{
		bka rotateyaw (360,1);
		bka movex (352,1);
		bkb rotatepitch (360,1);
		bkb movex (-400,1);
		bkc rotateroll (360,1);
		bkc movex (352,1);
		wait 2;
		bka rotateroll (-360,1);
		bka movex (-352,1);
		bkb rotateyaw (-360,1);
		bkb movex (400,1);
		bkc rotatepitch (-360,1);
		bkc movex (-352,1);
		wait 2;
	}
}


trap4()
{
	level endon("trigger");
	trig = getent("trig_trap4","targetname");
	floor = getEntArray("trap4","targetname");

	trig waittill("trigger");
	trig delete();

	while(true)
	{
		i = 0;
		while (i<floor.size)
		{
			floor[i] movez(-10,0.1);
			i = i+2;
		}
		wait 2;
		i = 0;
		while (i<floor.size)
		{
			floor[i] movez(10,0.1);
			i = i+2;
		}
		wait 1;
		i = 1;
		while (i<floor.size)
		{
			floor[i] movez(-10,0.1);
			i = i+2;
		}
		wait 2;
		i = 1;
		while (i<floor.size)
		{
			floor[i] movez(10,0.1);
			i = i+2;
		}
		wait 1;
	}

}

trap4killzone()
{
	level endon("trigger");
	trig = getent("killtrig_trap4","targetname");

	while (true)
	{
		trig waittill("trigger", player);
		player suicide();
	}
}


trap5()
{
	level endon("trigger");
	trig = getent("trig_trap5","targetname");
	row1 = getEntArray("trap5_1","targetname");
	row2 = getEntArray("trap5_2","targetname");
	row3 = getEntArray("trap5_3","targetname");
	row4 = getEntArray("trap5_4","targetname");
	row5 = getEntArray("trap5_5","targetname");
	row6 = getEntArray("trap5_6","targetname");

	trig waittill("trigger");
	trig delete();

	row1[randomIntRange(0,2)] notSolid();
	row2[randomIntRange(0,2)] notSolid();
	row3[randomIntRange(0,2)] notSolid();
	row4[randomIntRange(0,2)] notSolid();
	row5[randomIntRange(0,2)] notSolid();
	row6[randomIntRange(0,2)] notSolid();

}


trap6()
{
	level endon("trigger");
	trig = getent("trig_trap6","targetname");
	block1 = getent("trap6_1","targetname");
	block2 = getent("trap6_2","targetname");
	block3 = getent("trap6_3","targetname");
	block4 = getent("trap6_4","targetname");
	block5 = getent("trap6_5","targetname");
	block6 = getent("trap6_6","targetname");
	block7 = getent("trap6_7","targetname");
	block8 = getent("trap6_8","targetname");
	block9 = getent("trap6_9","targetname");

	trig waittill("trigger");


	block1 movex(-750,1);
	block2 movex(-750,1);
	block4 movex(-750,1);
	block5 movex(-750,1);
	block7 movex(-750,1);
	wait 1;
	block3 movex(-750,1);
	block6 movex(-750,1);
	block8 movex(-750,1);
	block9 movex(-750,1);

	trig waittill("trigger");
	trig delete();

	block1 movex(750,1);
	block2 movex(750,1);
	block4 movex(750,1);
	block5 movex(750,1);
	block7 movex(750,1);
	wait 1;
	block3 movex(750,1);
	block6 movex(750,1);
	block8 movex(750,1);
	block9 movex(750,1);

	wait 1;

	while (true)
	{
		block1 rotateroll(360,5);
		block3 rotateroll(-360,5);
		block5 rotateroll(360,5);
		block7 rotateroll(-360,5);
		block9 rotateroll(360,5);
		wait 5;
	}

}

trap7platform()
{
	block = getEnt("trap7","targetname");
	while(true)
	{
		block movey(-560,2,0.5,0.5);
		wait 3;
		block movey(560,2,0.5,0.5);
		wait 3;
	}
}

trap7()
{
	level endon("trigger");
	trig = getEnt("trig_trap7","targetname");
	block1 = getEnt("trap7a","targetname");
	block2 = getEnt("trap7b","targetname");
	block3 = getEnt("trap7c","targetname");
	block4 = getEnt("trap7d","targetname");

	trig waittill("trigger");
	trig delete();

	block1 movex(272,1.5);
	block2 movex(-272,1.5);
	block3 movex(272,1.5);
	block4 movex(-272,1.5);
	while(true)
	{
		block1 waittill("movedone");
		block1 movex(-544,3);
		block2 movex(544,3);
		block3 movex(-544,3);
		block4 movex(544,3);
		block1 waittill("movedone");
		block1 movex(544,3);
		block2 movex(-544,3);
		block3 movex(544,3);
		block4 movex(-544,3);

	}
}

trap8()
{
	level endon("trigger");
	trig = getEnt("trig_trap8","targetname");
	block1 = getEnt("trap8a","targetname");
	block2 = getEnt("trap8b","targetname");
	block3 = getEnt("trap8c","targetname");
	block4 = getEnt("trap8d","targetname");

	rand = randomInt(2);
	trig waittill("trigger");
	trig delete();
	if(rand==0)
	{
		block1 delete();
		block3 delete();
	}
	else
	{
		block2 delete();
		block4 delete();
	}
}

trap9()
{
	level endon("trigger");
	trig = getEnt("trig_trap9","targetname");
	roll1 = getEnt("trap9a","targetname");
	roll2 = getEnt("trap9b","targetname");

	trig waittill("trigger");
	trig delete();
	while(true)
	{
		roll1 rotatepitch(1440,4);
		roll2 rotatepitch(-1440,4);
		wait 8;
		roll1 rotatepitch(-1440,4);
		roll2 rotatepitch(1440,4);
		wait 8;
	}
}


end()
{
	trig = getEnt("endmap_trig","targetname");
	trig waittill("trigger",player);
	/* [AUTO DELETE] iPrintLnBold("^5"+player.name+" "+"^6"+"reached the end!"); */
	//trig delete();
	ambientStop(1);
	/* [AUTO DELETE] iPrintLn("Map by DeltaBoss"); */
}

end_doors()
{
	end_bush = getEnt("trig_end_bush","targetname");
	end_marine = getEnt("trig_end_marine","targetname");
	end_sniper = getEnt("trig_end_sniper","targetname");
	end_spin = getEnt("trig_end_ice","targetname");
	end_heavy = getEnt("trig_end_heavy","targetname");
	end_flash = getEnt("trig_end_flash","targetname");
	end_quake = getEnt("trig_end_earthquake","targetname");
	end_prone = getEnt("trig_end_fall","targetname");
	end_old = getEnt("trig_end_old","targetname");

	end_old thread end_old(end_bush,end_marine,end_sniper,end_spin,end_heavy,end_flash,end_quake,end_prone);
	end_bush thread end_bush(end_old,end_marine,end_sniper,end_spin,end_heavy,end_flash,end_quake,end_prone);
	end_marine thread end_marine(end_bush,end_old,end_sniper,end_spin,end_heavy,end_flash,end_quake,end_prone);
	end_sniper thread end_sniper(end_bush,end_marine,end_old,end_spin,end_heavy,end_flash,end_quake,end_prone);
	end_spin thread end_spin(end_bush,end_marine,end_sniper,end_old,end_heavy,end_flash,end_quake,end_prone);
	end_heavy thread end_heavy(end_bush,end_marine,end_sniper,end_spin,end_old,end_flash,end_quake,end_prone);
	end_flash thread end_flash(end_bush,end_marine,end_sniper,end_spin,end_heavy,end_old,end_quake,end_prone);
	end_quake thread end_earthquake(end_bush,end_marine,end_sniper,end_spin,end_heavy,end_flash,end_old,end_prone);
	end_prone thread end_fall(end_bush,end_marine,end_sniper,end_spin,end_heavy,end_flash,end_quake,end_old);
}


end_spin_killzone()
{
	trig = getent("end_spin_killzone","targetname");
	while (true)
	{
		trig waittill ("trigger", player);
		player suicide();
	}
}


finalRoom(tp,weap,health) //braxis
{
	self SetPlayerAngles( tp.angles );
	self SetOrigin( tp.origin );
	/* [AUTO DELETE] self TakeAllWeapons(); */
	/* [AUTO DELETE] self GiveWeapon( weap ); */
	/* [AUTO DELETE] self GiveMaxAmmo( weap ); */
	/* [AUTO DELETE] self SwitchToWeapon( weap ); */
	self.health = health;
}


waiter(end)
{
	self endon("disconnect");
	self endon("death");
	if (end==0)
	{
		while(true)
		{
			wait 4;
		}
	}
	else if(end==1)
	{
		while(1)
		{
			SetExpFog(1,150,1,0,0,0);
			wait 0.25;
			SetExpFog(1,150,0,1,0,0);
			wait 0.25;
			SetExpFog(1,150,0,0,1,0);
			wait 0.25;
			SetExpFog(1,150,1,1,0,0);
			wait 0.25;
			SetExpFog(1,150,1,0,1,0);
			wait 0.25;
			SetExpFog(1,150,0,1,1,0);
			wait 0.25;
		}
	}
	else if(end==2)
	{
		epicenter = getent("end_earthquake_epicenter","targetname");
		while(1)
		{
			earthquake(2,8,epicenter.origin,1000);
			wait 8;
		}
	}
	else if(end==3)
	{
		block = getEnt("end_spin_block","targetname");
		while(1)
		{
			wait 0.2;
			block rotateyaw(400,5);
			wait 5;
			block rotateyaw(-300,3);
			wait 3;
			block rotateyaw(500,4);
			wait 4;
			block rotateyaw(-400,5);
			wait 5;
			block rotateyaw(300,3);
			wait 3;
			block rotateyaw(-500,4);
			wait 4;
		}
	}
	else if(end==4)
	{
		while(1)
		{
			VisionSetNaked("_Whiteness",0);
			wait 0.15;
			VisionSetNaked("mp_dr_disco",0);
			wait 0.15;
			VisionSetNaked("_Whiteness",0);
			wait 0.15;
			VisionSetNaked("mp_dr_disco",0);
			wait 0.15;
			VisionSetNaked("_Whiteness",0);
			wait 0.15;
			VisionSetNaked("mp_dr_disco",0);
			wait 0.15;
			VisionSetNaked("_Whiteness",0);
			wait 0.15;
			VisionSetNaked("mp_dr_disco",0);
			wait 0.15;
//			level.activ NightVisionForceOff(); //BRAXI FIX PLOX :D
//			level.jumper NightVisionForceOff();
		}
	}
	else if(end==5)
	{
		men = getEntArray("end_sniper_men","targetname");
		i = 0;
		while(1)
		{
			u = i+5;
			v = i+10;
			w = i+15;
			x = i+20;
			y = i+25;
			z = i+30;
			out = i+35;
			of = i+40;
			var = i+45;
			ii = men[i].origin;
			men[i] movez(-2000,2,1);
			wait 0.5;
			uu = men[u].origin;
			men[u] movez(-2000,2,1);
			wait 0.5;
			vv = men[v].origin;
			men[v] movez(-2000,2,1);
			wait 0.5;
			ww = men[w].origin;
			men[w] movez(-2000,2,1);
			wait 0.5;
			xx = men[x].origin;
			men[x] movez(-2000,2,1);
			wait 0.5;
			yy = men[y].origin;
			men[y] movez(-2000,2,1);
			wait 0.5;
			zz = men[z].origin;
			men[z] movez(-2000,2,1);
			wait 0.5;
			tuo = men[out].origin;
			men[out] movez(-2000,2,1);
			wait 0.5;
			fo = men[of].origin;
			men[of] movez(-2000,2,1);
			wait 0.5;
			rav = men[var].origin;
			men[var] movez(-2000,2,1);
			wait 0.5;
			thread soldier_tele(i,ii,u,uu,v,vv,w,ww,x,xx,y,yy,z,zz,out,tuo,of,fo,var,rav);
			i = i+1;
		}
	}
}

end_old(fn1,fn2,fn3,fn4,fn5,fn6,fn7,fn8) //old
{
	block = getEnt("end_old_block","targetname");

	self waittill( "trigger", player );
	/* [AUTO DELETE] ambientPlay("end_old"); */
	fn1 delete();
	fn2 delete();
	fn3 delete();
	fn4 delete();
	fn5 delete();
	fn6 delete();
	fn7 delete();
	fn8 delete();
	self delete();
	block delete();
	/* [AUTO DELETE] iPrintlnBold(" ^1" + player.name + " ^7 prefers oldschool!" ); */
}

end_earthquake(fn1,fn2,fn3,fn4,fn5,fn6,fn7,fn8) //quake
{
	jump = getEnt( "end_earthquake_jumper", "targetname" );
	acti = getEnt( "end_earthquake_acti", "targetname" );
	self waittill( "trigger", player );
	/* [AUTO DELETE] ambientPlay("end_earthquake"); */
	fn1 delete();
	fn2 delete();
	fn3 delete();
	fn4 delete();
	fn5 delete();
	fn6 delete();
	fn7 delete();
	fn8 delete();
    while(1)
    {
		finalJumper = player;

		finalJumper finalRoom(jump,"knife_mp",100);
		level.activ finalRoom(acti,"knife_mp",100);

		finalJumper FreezeControls(1);
		level.activ FreezeControls(1);
		/* [AUTO DELETE] iPrintlnBold( " ^1" + player.name + " ^1 makes the ground shake!" ); */
		wait 0.5;
		/* [AUTO DELETE] iPrintlnBold("^1 GET READY!"); */
		wait 0.8;
		/* [AUTO DELETE] iPrintlnBold("^1 3"); */
		wait 0.8;
		/* [AUTO DELETE] iPrintlnBold("^1 2"); */
		wait 0.8;
		/* [AUTO DELETE] iPrintlnBold("^1 1"); */
		wait 0.8;
		/* [AUTO DELETE] iPrintlnBold("^1 GO!!!"); */
		finalJumper FreezeControls(0);
		level.activ FreezeControls(0);

		finalJumper waiter(2);
		self waittill("trigger",player);
    }
}



end_marine(fn1,fn2,fn3,fn4,fn5,fn6,fn7,fn8) //marine
{
	jump = getEnt( "end_marine_jumper", "targetname" );
	acti = getEnt( "end_marine_acti", "targetname" );
	self waittill( "trigger", player );
	/* [AUTO DELETE] AmbientPlay("end_marine"); */
	fn1 delete();
	fn2 delete();
	fn3 delete();
	fn4 delete();
	fn5 delete();
	fn6 delete();
	fn7 delete();
	fn8 delete();

	while(1)
	{
		finalJumper = player;
		rand = RandomInt(5);
		if (rand == 0)
		{
			weap = "rpg_mp";
		}
		else if (rand == 1)
		{
			weap = "rpd_grip_mp";
		}
		else if (rand == 2)
		{
			weap = "frag_grenade_mp";
		}
		else if (rand == 3)
		{
			weap = "m1014_grip_mp";
		}
		else
		{
			weap = "winchester1200_grip_mp";
		}

		finalJumper finalRoom(jump,weap,100);
		level.activ finalRoom(acti,weap,100);

		finalJumper FreezeControls(1);
		level.activ FreezeControls(1);
		/* [AUTO DELETE] iPrintlnBold( " ^1" + player.name + " ^7 is on the move!" ); */
		wait 3;
		/* [AUTO DELETE] iPrintlnBold("^1 GET READY!"); */
		wait 0.5;
		/* [AUTO DELETE] iPrintlnBold("^1 3"); */
		wait 0.5;
		/* [AUTO DELETE] iPrintlnBold("^1 2"); */
		wait 0.5;
		/* [AUTO DELETE] iPrintlnBold("^1 1"); */
		wait 0.5;
		/* [AUTO DELETE] iPrintlnBold("^1 GO!!!"); */
		finalJumper FreezeControls(0);
		level.activ FreezeControls(0);

		finalJumper waiter(0);
		self waittill( "trigger", player );
	}
}


end_flash(fn1,fn2,fn3,fn4,fn5,fn6,fn7,fn8)
{
	jump = getEnt( "end_flash_jumper", "targetname" );
	acti = getEnt( "end_flash_acti", "targetname" );
	self waittill( "trigger", player );
	/* [AUTO DELETE] ambientPlay("end_flash"); */
	fn1 delete();
	fn2 delete();
	fn3 delete();
	fn4 delete();
	fn5 delete();
	fn6 delete();
	fn7 delete();
	fn8 delete();

    while(1)
    {
		finalJumper = player;

		finalJumper finalRoom(jump,"knife_mp",100);
		level.activ finalRoom(acti,"knife_mp",100);

		finalJumper FreezeControls(1);
		level.activ FreezeControls(1);
		wait 0.05;
		/* [AUTO DELETE] iPrintlnBold( " ^6" + player.name + " ^5 is partying hard all night!" ); */
		wait 3;
		/* [AUTO DELETE] iPrintlnBold("^1 GET READY!"); */
		wait 1;
		/* [AUTO DELETE] iPrintlnBold("^1 3"); */
		wait 1;
		/* [AUTO DELETE] iPrintlnBold("^1 2"); */
		wait 1;
		/* [AUTO DELETE] iPrintlnBold("^1 1"); */
		wait 1;
		/* [AUTO DELETE] iPrintlnBold("^1 PARTY!!!"); */
		finalJumper FreezeControls(0);
		level.activ FreezeControls(0);

		finalJumper waiter(1);
		self waittill( "trigger", player );
    }
}


end_fall(fn1,fn2,fn3,fn4,fn5,fn6,fn7,fn8) //speed prone
{
	jump = getEnt( "end_fall_jumper", "targetname" );
	acti = getEnt( "end_fall_acti", "targetname" );
	self waittill( "trigger", player );
	/* [AUTO DELETE] ambientPlay("end_fall"); */
	fn1 delete();
	fn2 delete();
	fn3 delete();
	fn4 delete();
	fn5 delete();
	fn6 delete();
	fn7 delete();
	fn8 delete();

    while(1)
    {
		finalJumper = player;

		finalJumper finalRoom(jump,"knife_mp",100);
		level.activ finalRoom(acti,"knife_mp",100);
		/* [AUTO DELETE] iPrintlnBold( " ^1" + player.name + " ^5 chose speed-proning!" ); */
		/* [AUTO DELETE] iPrintlnBold("^1 5 seconds until speed-boost, go prone now!"); */
		wait 2;
		/* [AUTO DELETE] iPrintlnBold("^1 3"); */
		wait 1;
		/* [AUTO DELETE] iPrintlnBold("^1 2"); */
		wait 1;
		/* [AUTO DELETE] iPrintlnBold("^1 1"); */
		wait 1;
		/* [AUTO DELETE] iPrintlnBold("^1 SPEED!!!"); */
		/* [AUTO DELETE] finalJumper sr\api\_player::setPlayerSpeedScale(10); */
		/* [AUTO DELETE] level.activ sr\api\_player::setPlayerSpeedScale(10); */

		finalJumper waiter(0);
		/* [AUTO DELETE] level.activ sr\api\_player::setPlayerSpeedScale(0.1); */
		/* [AUTO DELETE] finalJumper sr\api\_player::setPlayerSpeedScale(0.1); */
		self waittill( "trigger", player );
    }
}


end_spin(fn1,fn2,fn3,fn4,fn5,fn6,fn7,fn8) //spin
{
	jump = getEnt( "end_spin_jumper", "targetname" );
	acti = getEnt( "end_spin_acti", "targetname" );
	self waittill( "trigger", player );
	/* [AUTO DELETE] ambientPlay("end_spin"); */
	fn1 delete();
	fn2 delete();
	fn3 delete();
	fn4 delete();
	fn5 delete();
	fn6 delete();
	fn7 delete();
	fn8 delete();

    while(1)
    {
		finalJumper = player;

		finalJumper finalRoom(jump,"knife_mp",100);
		level.activ finalRoom(acti,"knife_mp",100);

		finalJumper FreezeControls(1);
		level.activ FreezeControls(1);
		wait 0.05;
		/* [AUTO DELETE] iPrintlnBold( " ^1" + player.name + " ^5 spins my head right round!" ); */
		wait 3;
		/* [AUTO DELETE] iPrintlnBold("^1 GET READY!"); */
		wait 1;
		/* [AUTO DELETE] iPrintlnBold("^1 3"); */
		wait 1;
		/* [AUTO DELETE] iPrintlnBold("^1 2"); */
		wait 1;
		/* [AUTO DELETE] iPrintlnBold("^1 1"); */
		wait 1;
		/* [AUTO DELETE] iPrintlnBold("^1 SPIN AROUND!!!"); */
		finalJumper FreezeControls(0);
		level.activ FreezeControls(0);

		finalJumper waiter(3);
		wait 18;
		self waittill("trigger",player);
    }
}

end_heavy(fn1,fn2,fn3,fn4,fn5,fn6,fn7,fn8) //heavy
{
	jump = getEnt( "end_heavy_jumper", "targetname" );
	acti = getEnt( "end_heavy_acti", "targetname" );
	self waittill("trigger",player);
	/* [AUTO DELETE] ambientPlay("end_heavy"); */
	fn1 delete();
	fn2 delete();
	fn3 delete();
	fn4 delete();
	fn5 delete();
	fn6 delete();
	fn7 delete();
	fn8 delete();
	while(1)
	{
		finalJumper = player;
		level.jumper = player;

		finalJumper finalRoom(jump,"knife_mp",100);
		level.activ finalRoom(acti,"knife_mp",100);


		finalJumper FreezeControls(1);
		level.activ FreezeControls(1);
		wait 0.05;
		/* [AUTO DELETE] iPrintlnBold( " ^0" + player.name + " ^1 is banging HARD all night!" ); */
		wait 3;
		/* [AUTO DELETE] iPrintlnBold("^1 GET READY!"); */
		wait 1;
		/* [AUTO DELETE] iPrintlnBold("^1 3"); */
		wait 1;
		/* [AUTO DELETE] iPrintlnBold("^1 2"); */
		wait 1;
		/* [AUTO DELETE] iPrintlnBold("^1 1"); */
		wait 1;
		/* [AUTO DELETE] iPrintlnBold("^1 BANG!!!"); */
		finalJumper FreezeControls(0);
		level.activ FreezeControls(0);

		finalJumper waiter(4);
		self waittill("trigger",player);
    }
}

soldier_tele(a,aa,b,bb,c,cc,d,dd,e,ee,f,ff,g,gg,h,hh,j,jj,k,kk)
{
	men = getEntArray("end_sniper_men","targetname");
	men[a].origin = aa;
	wait 0.4;
	men[b].origin = bb;
	wait 0.4;
	men[c].origin = cc;
	wait 0.4;
	men[d].origin = dd;
	wait 0.4;
	men[e].origin = ee;
	wait 0.4;
	men[f].origin = ff;
	wait 0.4;
	men[g].origin = gg;
	wait 0.4;
	men[h].origin = hh;
	wait 0.4;
	men[j].origin = jj;
	wait 0.4;
	men[k].origin = kk;
}

end_sniper(fn1,fn2,fn3,fn4,fn5,fn6,fn7,fn8) //sniper
{
	jump = getEnt( "end_sniper_jumper", "targetname" );
	acti = getEnt( "end_sniper_acti", "targetname" );
	self waittill( "trigger", player );
	/* [AUTO DELETE] ambientPlay("end_sniper"); */
	fn1 delete();
	fn2 delete();
	fn3 delete();
	fn4 delete();
	fn5 delete();
	fn6 delete();
	fn7 delete();
	fn8 delete();

	while(1)
	{
		finalJumper = player;

		rand = RandomInt(5);
		if (rand == 0)
		{
			weap = "m40a3_mp";
		}
		else if (rand == 1)
		{
			weap = "m21_mp";
		}
		else if (rand == 2)
		{
			weap = "dragunov_mp";
		}
		else if (rand == 3)
		{
			weap = "remington700_mp";
		}
		else
		{
			weap = "barrett_mp";
		}

		finalJumper finalRoom(jump,weap,100);
		level.activ finalRoom(acti,weap,100);

		finalJumper FreezeControls(1);
		level.activ FreezeControls(1);
		wait 0.05;
		/* [AUTO DELETE] iPrintlnBold( " ^5" + player.name + " ^4 should watch the weatherforecast!" ); */
		wait 3;
		/* [AUTO DELETE] iPrintlnBold("^1 GET READY!"); */
		wait 1;
		/* [AUTO DELETE] iPrintlnBold("^1 3"); */
		wait 1;
		/* [AUTO DELETE] iPrintlnBold("^1 2"); */
		wait 1;
		/* [AUTO DELETE] iPrintlnBold("^1 1"); */
		wait 1;
		/* [AUTO DELETE] iPrintlnBold("^1 LOOK!!!"); */
		finalJumper FreezeControls(0);
		level.activ FreezeControls(0);

		finalJumper waiter(5);
		self waittill("trigger",player);
    }
}


end_bush(fn1,fn2,fn3,fn4,fn5,fn6,fn7,fn8) //bush
{
	jump = getEnt( "end_bush_jumper", "targetname" );
	acti = getEnt( "end_bush_acti", "targetname" );
	self waittill( "trigger", player );
	fn1 delete();
	fn2 delete();
	fn3 delete();
	fn4 delete();
	fn5 delete();
	fn6 delete();
	fn7 delete();
	fn8 delete();

	/* [AUTO DELETE] ambientPlay("end_bush"); */
	finalJumper = player;
	finalJumper finalRoom(jump,"tomahawk_mp",100);
	level.activ finalRoom(acti,"tomahawk_mp",100);
	/* [AUTO DELETE] iPrintlnBold( " ^1" + player.name + " ^2 is hunting down the activator!" ); */
	while(1)
	{
		self waittill( "trigger", player );
		finalJumper = player;
		wait 0.1;
		finalJumper finalRoom(jump,"tomahawk_mp",100);
		/* [AUTO DELETE] iPrintlnBold( " ^1" + player.name + " ^2 has joined the hunt!" ); */
	}
}


addTestClients()
{
    // setDvar("scr_testclients", "");
    // wait 1;
    // for(;;)
    // {
    //     if(getdvarInt("scr_testclients") > 0)
    //         break;
    //     wait 1;
    // }
    // testclients = getdvarInt("scr_testclients");
    // setDvar( "scr_testclients", 0 );
    // for(i=0;i<testclients;i++)
    // {
    //     ent[i] = addtestclient();

    //     if (!isdefined(ent[i]))
    //     {
    //         /* [AUTO DELETE] println("Could not add test client");
    //         wait 1;
    //         continue;
    //     }
    //     ent[i].pers["isBot"] = true;
    //     ent[i] thread TestClient("autoassign");
    // }
    // thread addTestClients();
}


TestClient(team)
{
    self endon( "disconnect" );

    while(!isdefined(self.pers["team"]))
        wait .05;

    self notify("menuresponse", game["menu_team"], team);
    wait 0.5;
}
