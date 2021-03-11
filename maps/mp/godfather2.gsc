main()
{
	//thread traps();
	thread duduk();
	//thread bouncetp();
	//thread mozog();
	thread teleports();
	thread door1();
    changeBrush();
	//thread addTestClients();
    pipe1 = getent("pipe1", "targetname");
	pipe2 = getent("pipe2", "targetname");
	pipe3 = getent("pipe3", "targetname");
    pipe1 notsolid();
	pipe2 notsolid();
	pipe3 notsolid();
}

///////////////////////////////////////////////////////////////////////

changeBrush(){
    getent("trap7brush","targetname") rotateYaw(90,0.05);
    getent("trap7brush","targetname") moveto((2136,589,341), 0.05);
}

traps()
{
	thread trap1();
	thread trap1pont5();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap5();
	thread trap6();
	thread trap7();
	thread trap8();
	thread trap9();
	thread trap10();
	thread trappuzser();
	thread randomplatform();
	thread sniptele();
}


////////////////////////////////////////////////////////////////////////
//Thank you Ratzee | Xfire:seress | Nice script for explosion         //
////////////////////////////////////////////////////////////////////////

trap1()
{
	trigacti = getent("trap1", "targetname");
	trigacti sethintstring("^3[^7Haszn�l^2-^7Use^3]^7 to Activate the trap 2X");
	trigacti SetCursorHint("HINT_ACTIVATE");
	gold = getent("trap1gold","targetname");
	car1 = getent ("car1", "targetname");
	car2 = getent ("car2", "targetname");
	car3 = getent ("car3", "targetname");
	car4 = getent ("car4", "targetname");
	car5 = getent ("car5", "targetname");
	asd1 = getent ("car1multiple", "targetname");
	asd2 = getent ("car2multiple", "targetname");
	asd3 = getent ("car3multiple", "targetname");
	asd4 = getent ("car4multiple", "targetname");
	asd5 = getent ("car5multiple", "targetname");
	car1_clip = getent ("car1_clip", "targetname");
	car2_clip = getent ("car2_clip", "targetname");
	car3_clip = getent ("car3_clip", "targetname");
	car4_clip = getent ("car4_clip", "targetname");
	car5_clip = getent ("car5_clip", "targetname");
	trigacti waittill( "trigger", who ); 
	wait 0.1;

	x = RandomInt(100);
		if( x < 50 )
		{
		PlayFX( level.exp_fx, car1.origin );
		thread killer("car1multiple");
		Earthquake( 2, 1, car1.origin, 250);
		car1 delete();
		car1_clip delete();
		wait 0.5;
		asd1 delete();
		}
		if( x > 49  )
		{
		PlayFX( level.exp_fx, car2.origin );
		thread killer("car2multiple");
		Earthquake( 2, 1, car2.origin, 250);
		car2 delete();
		car2_clip delete();
		wait 0.5;
		asd2 delete();
		}
		car3_clip PlaySound("sound1");
	trigacti sethintstring("^3[^7Haszn�l^2-^7Use^3]^7 to Activate the trap 1X");
	trigacti waittill( "trigger", who ); 

	x = RandomInt(100);
		if( x < 50 )
		{
		PlayFX( level.exp_fx, car3.origin );
		thread killer("car3multiple");
		Earthquake( 2, 1, car3.origin, 250);
		car3 delete();
		car3_clip delete();
		wait 0.5;
		asd3 delete();
		}
		if( x > 49  )
		{
		PlayFX( level.exp_fx, car4.origin );
		thread killer("car4multiple");
		thread killer("car5multiple");
		Earthquake( 2, 1, car4.origin, 250);
		car4 delete();
		car5 delete();
		car4_clip delete();
		car5_clip delete();
		wait 0.5;
		asd4 delete();
		asd5 delete();
		}
		gold PlaySound("sound1");
	trigacti delete();
	gold delete();
}

trap1pont5()
{
	trig = getent("trap1.5", "targetname");
	tank = getent("tank", "targetname");
	tanktrig = getent("tanktrig", "targetname");
	tanktrig enablelinkto();
	tanktrig linkto(tank);
	trig sethintstring("^3[^7Haszn�l^2-^7Use^3]^7 to Activate the trap");
	trig SetCursorHint("HINT_ACTIVATE");
	trig waittill( "trigger", who );
	wait 0.1;
	tank movey(1390, 4);
	trig delete();
}

trap2()
{
	trig = getent("trap2", "targetname");
	trap2 = getent("trap2down", "targetname");
	trig sethintstring("^3[^7Haszn�l^2-^7Use^3]^7 to Activate the trap");
	trig SetCursorHint("HINT_ACTIVATE");
	gold = getent("trap2gold","targetname");
	trig waittill( "trigger", who ); 
	wait 0.1;
	trig delete();
	gold delete();
	trap2 movez(-250, 1);
	wait 1.5;
	trap2 movez(250, 1);
	
}

trap3()
{
	part1 = getentarray ("trap3_1" ,"targetname");
	part2 = getentarray ("trap3_2" ,"targetname");
	part3 = getentarray ("trap3_3" ,"targetname");
	part4 = getentarray ("trap3_4" ,"targetname");
	trig = getent ("trap3" , "targetname");
	gold = getent("trap3gold","targetname");
	trig sethintstring("^3[^7Haszn�l^2-^7Use^3]^7 to Activate the trap");
	trig SetCursorHint("HINT_ACTIVATE");

 	trig waittill( "trigger", who ); 
	trig delete ();
	gold delete();
	random = randomint(2);

	switch(random)
	{
		case 0:
				part1[randomInt(part1.size)] notsolid();
				part4[randomInt(part4.size)] notsolid();
				break;
				
		case 1:	
				part2[randomInt(part2.size)] notsolid();
				part3[randomInt(part3.size)] notsolid();		
				
		default: return;
	}
}

trap4()
{
	trig = getent("trap4", "targetname");
	trap = getent("trap4brush", "targetname");
	trig sethintstring("^3[^7Haszn�l^2-^7Use^3]^7 to Activate the trap");
	trig SetCursorHint("HINT_ACTIVATE");
	gold = getent("trap4gold","targetname");
	trig waittill( "trigger", who ); 
	wait 0.1;
	trig delete();
	gold delete();
	while(1)
	{
		trap rotatePitch (360 , 2 );
		trap waittill("rotatedone");
		wait 0.5;
	}

}

trap5()
{
	trig = getent("trap5", "targetname");
	trap = getent("trap5_1", "targetname");
	trap1 = getent("trap5_2", "targetname");
	trig sethintstring("^3[^7Haszn�l^2-^7Use^3]^7 to Activate the trap");
	trig SetCursorHint("HINT_ACTIVATE");
	gold = getent("trap5gold","targetname");
	trap linkto(trap1);
	trig waittill( "trigger", who ); 
	wait 0.1;
	trig delete();
	gold delete();
	while(1)
	{
		wait .1;
		trap1 rotateYaw(720,2);
		trap1 movex(330, 1);
		trap1 waittill("movedone");
		trap1 movex(-330, 1);
		trap1 waittill("movedone");
		wait 1;
	}
}

trap6()
{
	trig = getent("trap6", "targetname");
	trap = getent("trap6tolo", "targetname");
	tolotrig = getent("tolotrig", "targetname");
	tolotrig enablelinkto();
	tolotrig linkto(trap);
	trig sethintstring("^3[^7Haszn�l^2-^7Use^3]^7 to Activate the trap");
	trig SetCursorHint("HINT_ACTIVATE");
	gold = getent("trap6gold","targetname");
	trig waittill( "trigger", who ); 
	wait 0.1;
	trig delete();
	gold delete();
	trap movey(410, 1);
	wait 3;
	trap movey(-410, 1);

}

trap7()
{
	trig = getent("trap7", "targetname");
	trap = getent("trap7bounce", "targetname");
	trig sethintstring("^3[^7Haszn�l^2-^7Use^3]^7 to Activate the trap");
	trig SetCursorHint("HINT_ACTIVATE");
	gold = getent("trap7gold","targetname");
	trig waittill( "trigger", who ); 
	wait 0.1;
	trig delete();
	gold delete();
	trap hide();
	wait 1;
	trap show();
}

trap8()
{
	trig = getent("trap8", "targetname");
	door1 = getent("door4", "targetname");
	door2 = getent("door5", "targetname");
	killtrig = getent("killtrig", "targetname");
	rpd = getent("rpdspawn", "targetname");
	rpd1 = getent("rpdspawn_1", "targetname");
	rpd2 = getent("rpdspawn_2", "targetname");
	rpd3 = getent("rpdspawn_3", "targetname");
	rpd4 = getent("rpdspawn_4", "targetname");
	trig sethintstring("^3[^7Haszn�l^2-^7Use^3]^7 to Activate the trap");
	trig SetCursorHint("HINT_ACTIVATE");
	gold = getent("trap8gold","targetname");
	trig waittill( "trigger", who ); 
	wait 0.1;
	trig delete();
	gold delete();
	door1 movex(67, 1);
	door2 movex(67, 1);
	wait 1;
	PlayFX( level.rpd_fx, rpd.origin );
	PlayFX( level.rpd_fx, rpd1.origin );
	PlayFX( level.rpd_fx, rpd2.origin );
	PlayFX( level.rpd_fx, rpd3.origin );
	PlayFX( level.rpd_fx, rpd4.origin );
	rpd PlaySound("sound2");
	thread killer("killtrig");
	PlayFX( level.rpd_fx, rpd.origin );
	PlayFX( level.rpd_fx, rpd1.origin );
	PlayFX( level.rpd_fx, rpd2.origin );
	PlayFX( level.rpd_fx, rpd3.origin );
	PlayFX( level.rpd_fx, rpd4.origin );
	rpd PlaySound("sound2");
	wait 1;
	PlayFX( level.rpd_fx, rpd.origin );
	PlayFX( level.rpd_fx, rpd1.origin );
	PlayFX( level.rpd_fx, rpd2.origin );
	PlayFX( level.rpd_fx, rpd3.origin );
	PlayFX( level.rpd_fx, rpd4.origin );
	rpd PlaySound("sound2");
	wait 4;
	killtrig delete();
	door1 movex(-67, 1);
	door2 movex(-67, 1);
	wait 5;
	door1 delete();
	door2 delete();
}

trap9()
{
	trig = getent("trap9", "targetname");
	heli = getent("helicopter", "targetname");
	lap = getent("helilap", "targetname");
	hurt = getent("helicopter_trig", "targetname");
	hurt enablelinkto();
	hurt linkto(heli);
	trig sethintstring("^3[^7Haszn�l^2-^7Use^3]^7 to Activate the trap");
	trig SetCursorHint("HINT_ACTIVATE");
	trig waittill( "trigger", who ); 
	trig delete();
	lap movez(420,1);
	heli movex(-650,3);
	wait 3;
	PlayFX( level.heli_fx, heli.origin );
	heli rotatePitch (70 , .1 );
	heli PlaySound("sound3");
	wait .1;
	heli rotateYaw(720,3);
	heli movez(-1310,2);
	wait 2;
	PlayFX( level.exp_fx, heli.origin );
	heli delete();
	wait 2;
	hurt delete();
	lap delete();
}

trap10()
{
	trig = getent("trap10", "targetname");
	pipe1 = getent("pipe1", "targetname");
	pipe2 = getent("pipe2", "targetname");
	pipe3 = getent("pipe3", "targetname");
	pipetrig1 = getent("pipetrig1", "targetname");
	pipetrig2 = getent("pipetrig2", "targetname");
	pipetrig3 = getent("pipetrig3", "targetname");
	pipe1 notsolid();
	pipe2 notsolid();
	pipe3 notsolid();
	trig sethintstring("^3[^7Haszn�l^2-^7Use^3]^7 to Activate the trap");
	trig SetCursorHint("HINT_ACTIVATE");
	trig waittill( "trigger", who ); 
	trig delete();
	x = RandomInt(3);
	switch( int(x) )
	{
		case 0:
	pipe1 solid();
	thread killer("pipetrig1");
		break;
		case 1:
	pipe2 solid();
	thread killer("pipetrig2");
		break;
		case 2:
	pipe3 solid();
	thread killer("pipetrig3");
		break;

		default:
			break;
	}
}

trappuzser()
{
	trig = getent("trappuzser", "targetname");
	trap = getent("trappuzser_1", "targetname");
	waterup = getent("waterup", "targetname");
	killwater = getent("puzserkill", "targetname");
	killwater enablelinkto();
	killwater linkto(waterup);
	trig sethintstring("^3[^7Haszn�l^2-^7Use^3]^7 to Activate ^3P�zs�r ^7trap");
	trig SetCursorHint("HINT_ACTIVATE");
	trig waittill( "trigger", who ); 
	wait 0.1;
	trig delete();
	trap movez(105, 1);
	waterup movez(360, 4);
	wait 5;
	trap movez(-105, 1);
	waterup delete();
	killwater delete();

}

killer(threadelni)
{
killtrig = getent(threadelni, "targetname");
while(1)
	{
	killtrig waittill( "trigger", who ); 
	wait .1;
	who suicide();
	}
}

randomplatform()
{
	trig = getent("randomplatform", "targetname");
	p1 = getent("p1", "targetname");
	p2 = getent("p2", "targetname");
	p3 = getent("p3", "targetname");
	p4 = getent("p4", "targetname");
	p5 = getent("p5", "targetname");
	p6 = getent("p6", "targetname");
	trig sethintstring("^3[^7Haszn�l^2-^7Use^3]^7 to Activate the ^7trap");
	trig SetCursorHint("HINT_ACTIVATE");
	trig waittill( "trigger", who );
	trig delete();
	x = RandomInt(2);
	switch( int(x) )
	{
		case 0:
		p1 delete();
		p4 notsolid();
		p5 hide();
		p2 delete();
		break;
		case 1:
		p2 delete();
		p3 delete();
		p5 notsolid();
		p6 hide();
		break;

		default:
			break;
	}

}

///////////////////////////////////////////////////////////////////////

duduk()
{
thread pista();
	obj1 = getent("dudu1","targetname");
	obj2 = getent("dudu2","targetname");
	obj3 = getent("dudu3","targetname");
	obj4 = getent("dudu4","targetname");
	pistaba = getent("pistabacsi","targetname");

	while(1)
	{
	wait .1;
	obj1 movex(800,2);
	obj1 waittill("movedone");
	obj2 movex(800,2);
	pistaba movex(-700,2);
	obj1 rotateYaw(180,.1);
	obj1 movex(-800,2);
	obj3 movex(800,2);
	pistaba rotateYaw(180,.1);
	obj1 waittill("movedone");
	obj2 movex(-800,2);
	obj4 movex(800,2);
	obj3 movex(-800,2);
	pistaba movex(700,2);
	obj3 waittill("movedone");
	obj4 movex(-800,2);
	pistaba rotateYaw(180,.1);
	}
}

pista()
{
	pistaba = getent("pistabacsi","targetname");
	pistatrig = getent("pistatrig","targetname");
	pistatrig enablelinkto();
	pistatrig linkto(pistaba);
	while(1)
	{
	pistatrig waittill( "trigger", who ); 
	who dropItem( who getCurrentWeapon() );
	who iprintlnBold("You hitted a ^2Civilian ^7...");
	}
}


sniptele()
{
	snippos1 = getent("snippos1", "targetname");
	snippos2 = getent("snippos2", "targetname");
	snippos3 = getent("snippos3", "targetname");
	snippos1 SetCursorHint("HINT_ACTIVATE");
	snippos2 SetCursorHint("HINT_ACTIVATE");
	snippos3 SetCursorHint("HINT_ACTIVATE");
	wait 0.1;
thread gotopos("snippos1","snippos2");
thread gotopos("snippos2","snippos3");
thread gotopos("snippos3","snippos1");
	
}

///////////////////////////////////////////////////////////////////////

bouncetp()
{
	trig = getent("bouncetp","targetname");
	tp_jumper = getent("jumper_bounce","targetname");
	tp_acti = getent("jumper_acti","targetname");
	while(1)
	{
	wait .1;
	trig waittill("trigger", player);
	wait 0.2;
	if(player.pers["team"] == "allies")
	{
	player setOrigin(tp_jumper.origin);
	}
	if(player.pers["team"] == "axis")
	{
	player setOrigin(tp_acti.origin);
	}
	}
}

///////////////////////////////////////////////////////////////////////

mozog()
{
	obj = getent("trap7brush","targetname");
	wait 1;
	while(1)
	{
	wait 1;
	obj movex(-500, 1);
	obj waittill("movedone");
	obj movex(500, 1);
	wait 1;
	}
}

///////////////////////////////////////////////////////////////////////

teleports()
{
	thread gotopos("tp1","tp1_out");
	thread gotopos("tp2","tp2_out");
	thread gotopos("tp3","tp3_out");

}

gotopos(in,out)
{
trig = getent(in,"targetname");
out = getent(out,"targetname");
while(1)
	{
	wait .1;
	trig waittill("trigger", player);
	wait 0.2;
	player setOrigin(out.origin);
	wait .1;
	}
}

door1()
{
	trig = getent("door1trig", "targetname");
	trig2 = getent("door2trig", "targetname");
	obj = getent("door1","targetname");
	obj2 = getent("door2","targetname");
	obj3 = getent("door3","targetname");
	obj delete();
	obj3 delete();
	obj2 delete();
    trig delete();
    trig2 delete();
	
}

addTestClients()
{
	setDvar("scr_testclients", "");
	wait 1;
	for(;;)
	{
		if(getdvarInt("scr_testclients") > 0)
			break;
		wait 1;
	}
	testclients = getdvarInt("scr_testclients");
	setDvar( "scr_testclients", 0 );
	for(i=0;i<testclients;i++)
	{
		ent[i] = addtestclient();

		if (!isdefined(ent[i]))
		{
			println("Could not add test client");
			wait 1;
			continue;
		}
		ent[i].pers["isBot"] = true;
		ent[i] thread TestClient("autoassign");
	}
	thread addTestClients();
}

TestClient(team)
{
	self endon( "disconnect" );

	while(!isdefined(self.pers["team"]))
		wait .05;
		
	self notify("menuresponse", game["menu_team"], team);
	wait 0.5;
}