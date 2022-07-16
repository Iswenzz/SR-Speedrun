main()
{
	// ambientPlay("ambient_mp_dr_rainbow");

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setdvar( "r_specularcolorscale", "1" );
	setdvar( "r_specular", "0" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");
	setDvar("bg_falldamagemaxheight", 9999999999 );
	setDvar("bg_falldamageminheight", 999999999 );
	
	thread sr\api\_speedrun::createNormalWays("^2Easy Way;^2Easy+ Way;^3Inter Way;^3Inter+ Way;^1Hard Way;");
	thread sr\api\_speedrun::createSecretWays("^2Easy Secret;^2Easy+ Secret;^3Inter Secret;^3Inter+ Secret;^1Hard Secret;");
	thread sr\api\_speedrun::createTeleporter((-2500.17, 4086.94, -159.875), 110, 15, (-4834, 4309, -356), 180, "freeze", "blue", "normal_1");
	thread sr\api\_speedrun::createTeleporter((441.615, 10977, 496.125), 80, 15, (-2439, 10707, 556), 270, "freeze", "blue", "normal_2");
	thread sr\api\_speedrun::createTeleporter((-4217.04, 9539.11, -751.875), 110, 15, (-4147, 11090, 396), 180, "freeze", "blue", "normal_2");

	thread message();
	thread Br11();
	thread Br12();
	thread Br21();
	thread Br22();
	thread Rpb1();
	thread Rpb21();
	thread Rpb22();
	// 	thread Rpb23();
	// 	thread Rpb24();
	// 	thread Rpb25();
	// 	thread Rpb26();
	// 	thread Rpb27();
	thread Rpb4();
	thread rpdb();
	thread rpdv();
		// thread adB();
		// thread adV();
		// thread adJ();
		// thread adO();
		
		
		
	// thread tb1();
	// thread tb2();
	// thread tb3();
	// thread tb4();
	// thread string();
	
	// thread tv1();
	thread tv2();
	// thread tv3();
	// thread rpv1s();
	// thread rpv2s();
	thread rpv3s();
	// thread rpj1();
	thread rpj2();
	// thread tj1();
	// thread tj2();
	// thread to1();
	// thread to2();
	
	
	
	// thread First();
	// thread games();
	// thread Death();
	// thread sniper();
	// thread surf_end_2();
	// thread old();
	// thread surf();
	// thread surf_end_1();
	// thread knife();
	// thread bounce();
	// thread knife_bouncer();
	// thread be1();
	// thread be2();
	// thread be12();
	// thread be22();
	// thread bounce_sniper();
	
	thread secret_ez();
	thread secret_ezz();
	thread secret_hard();
	thread secret_i();
	thread secret_ii();
	thread secret_ez2();
	thread secret_ezz2();
	thread secret_hard2();
	thread secret_i2();
	thread secret_ii2();
	
	// thread secret_a();
	// thread secret_a2();
	
	
	
		// addTriggerToList("tb1pt");
		// addTriggerToList("tb2pt");
		// addTriggerToList("tb3pt");
		// addTriggerToList("tb4pt");
		// addTriggerToList("tv1pt");
		// addTriggerToList("tv2pt");
		// addTriggerToList("tv3pt");
		// addTriggerToList("tj1pt");
		// addTriggerToList("tj2pt");
		// addTriggerToList("to1t");
		// addTriggerToList("to2t");
		
	// thread musictrig();
	// thread message2();
	
	// if(!isdefined(level.music))
	// 	level.music=[];

	// level.music[0]["song"]	="Nero - Promises (Skrillex Remix) [QUIX FLIP]";
	// level.music[0]["alias"]	="song1";
	// level.music[1]["song"]	="Kygo x Romy Wave - Raging (SGNFCNTS Remix)";
	// level.music[1]["alias"]	="song2";
	// level.music[2]["song"]	="Eljay - No Pressure";
	// level.music[2]["alias"]	="song3";

	entTransporter = getentarray( "enter", "targetname" );

	if(isdefined(entTransporter))
		for( i = 0; i < entTransporter.size; i++ )
			entTransporter[i] thread transporter();

}

transporter()
{
	for(;;)
	{
		self waittill( "trigger", player );

		if(self.target == "Vo1")
			player thread sr\api\_speedrun::changeWay("normal_1");

		if(self.target == "Jo1")
			player thread sr\api\_speedrun::changeWay("normal_2");

		if(self.target == "Oo1")
			player thread sr\api\_speedrun::changeWay("normal_3");

		if(self.target == "Ro1")
			player thread sr\api\_speedrun::changeWay("normal_4");

		entTarget = getEnt( self.target, "targetname" );
		player setOrigin( entTarget.origin );
		player setplayerangles( entTarget.angles );
	}
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
	self.hud_music[i] setText("Rainbow");
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
	trig setHintString("^7Press ^3[USE] ^7to choose Music");
 
	trig waittill("trigger",player);
	player freezecontrols(1);
	trig delete();
	player musicMenu();
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

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

message()
{
door=getent("door", "targetname");
door delete();

}

message2()
{
	while(1)
	{
		iprintln( "^1Map by ^43xP' UnNamed" );
		wait 5;
		iprintln( "^7Textures and script by ^43xP' UnNamed" );
		wait 10;
		iprintln( "^5Taste ^2The ^3Ra^1in^9bo^7w !" );
		wait 10;
		iprintln( "^5THX TO TESTERS: ^4Agex, yoyo :> and Dopeh ! ^9<3" );
		wait 10;
	}
}

Br11()
{
	o2=getent("o2","targetname");
	p2=getent("p2","targetname");
	
    level waittill("round_started");
	o2 RotatePitch(15, 0.1);
	p2 RotatePitch(15, 0.1);	
	
}

Br12()
{
	ao2=getent("ao2","targetname");
	ap2=getent("ap2","targetname");
	
	level waittill("round_started");
	ao2 RotatePitch(15, 0.1);
	ap2 RotatePitch(15, 0.1);
		
}

Br21()
{
	r3p1=getent("r3p1","targetname");
	r3o1=getent("r3o1","targetname");
	
	level waittill("round_started");

    r3p1 MoveX(-1000,0.1);
	r3o1 MoveX(-1000,0.1);
	wait 0.2;
	r3p1 RotateYaw(270,0.1);
	r3o1 RotateYaw(270,0.1);
	
}

Br22()
{
	r3p2=getent("r3p2","targetname");
	r3o2=getent("r3o2","targetname");
	
    level waittill("round_started");

	r3p2 RotatePitch(15,0.1);
	r3o2 RotatePitch(15,0.1);
	
	
}

Rpb1()
{
	rpp11=getent("rpp11","targetname");
	rpp12=getent("rpp12","targetname");
	rpp13=getent("rpp13","targetname");
	rpp14=getent("rpp14","targetname");
	rpp15=getent("rpp15","targetname");
	rpp16=getent("rpp16","targetname");
	rpp17=getent("rpp17","targetname");
	rpp18=getent("rpp18","targetname");
	rpp21=getent("rpp21","targetname");
	rpp22=getent("rpp22","targetname");
	rpp23=getent("rpp23","targetname");
	rpp24=getent("rpp24","targetname");
	rpp25=getent("rpp25","targetname");
	rpp26=getent("rpp26","targetname");
	rpp27=getent("rpp27","targetname");
	rpp28=getent("rpp28","targetname");

		rpp11 MoveY(-192, .5);
		 wait 0.05;
		rpp12 MoveY(-192, .5);
		 wait 0.05;
		rpp13 MoveY(-192, .5);
		 wait 0.05;
		rpp14 MoveY(-192, .5);
		 wait 0.05;
		rpp15 MoveY(-192, .5);
		 wait 0.05;
		rpp16 MoveY(-192, .5);
		 wait 0.05;
		rpp17 MoveY(-192, .5);
		 wait 0.05;
		rpp18 MoveY(-192, .5);
		 wait 0.05;
        rpp21 MoveY(192, .5);
		 wait 0.05;
		rpp22 MoveY(192, .5);
		 wait 0.05;
		rpp23 MoveY(192, .5);
		 wait 0.05;
		rpp24 MoveY(192, .5);
		 wait 0.05;
		rpp25 MoveY(192, .5);
		 wait 0.05;
		rpp26 MoveY(192, .5);
		 wait 0.05;
		rpp27 MoveY(192, .5);
		 wait 0.05;
		rpp28 MoveY(192, .5);

}

Rpb21()
{
	rpb2o1=getent("rpb2o1","targetname");
	rpb2o2=getent("rpb2o2","targetname");
	rpb2p1=getent("rpb2p1","targetname");
	rpb2p2=getent("rpb2p2","targetname");

	level waittill("round_started");

    rpb2o1 moveZ(900,0.1);
	rpb2o2 moveZ(850,0.1);
	rpb2p1 moveZ(900,0.1);
	rpb2p2 moveZ(850,0.1);
	wait 0.3;
	rpb2o2 moveX(-600,0.1);
	rpb2p2 moveX(-600,0.1);
}

Rpb22()
{
	rpb2p3=getent("rpb2p3","targetname");
	rpb2p4=getent("rpb2p4","targetname");
	rpb2p5=getent("rpb2p5","targetname");
	rpb2p6=getent("rpb2p6","targetname");

    level waittill("round_started");

	rpb2p3 moveZ(810,0.1);
	rpb2p4 moveZ(810,0.1);
	rpb2p5 moveZ(810,0.1);
	rpb2p6 moveZ(810,0.1);
	wait 0.4;
	rpb2p3 moveY(-1000,0.1);
	rpb2p4 moveY(-1000,0.1);
	rpb2p5 moveY(-1000,0.1);
	rpb2p6 moveY(-1000,0.1);
	wait 0.4;
	rpb2p3 moveX(3500,0.1);
	rpb2p4 moveX(4050,0.1);
	rpb2p5 moveX(5500,0.1);
	rpb2p6 moveX(6050,0.1);
	
}

Rpb23()
{
	rpb2o1=getent("rpb2o1","targetname");
	rpb2o2=getent("rpb2o2","targetname");
	rpb2p3=getent("rpb2p3","targetname");

	wait 4;
	while (1)
	{
		
		rpb2p3 show();
		rpb2p3 MoveTo(rpb2o2.origin, 10);
		wait 12;
		rpb2p3 hide();
		rpb2p3 MoveTo(rpb2o1.origin, .1);
		wait 2;
	}
	
	
	
}


Rpb24()
{
	rpb2o1=getent("rpb2o1","targetname");
	rpb2o2=getent("rpb2o2","targetname");
	rpb2p4=getent("rpb2p4","targetname");

	wait 6;
	while (1)
	{
		
		rpb2p4 show();
		rpb2p4 MoveTo(rpb2o2.origin, 10);
		wait 12;
		rpb2p4 hide();
		rpb2p4 MoveTo(rpb2o1.origin, .1);
		wait 2;
	}
	
	
	
}


Rpb25()
{
	rpb2o1=getent("rpb2o1","targetname");
	rpb2o2=getent("rpb2o2","targetname");
	rpb2p5=getent("rpb2p5","targetname");

	wait 8;
	while (1)
	{
		
		rpb2p5 show();
		rpb2p5 MoveTo(rpb2o2.origin, 10);
		wait 12;
		rpb2p5 hide();
		rpb2p5 MoveTo(rpb2o1.origin, .1);
		wait 2;
	}
	
	
	
}

Rpb26()
{
	rpb2o1=getent("rpb2o1","targetname");
	rpb2o2=getent("rpb2o2","targetname");
	rpb2p6=getent("rpb2p6","targetname");

	wait 10;
	while (1)
	{
		
		rpb2p6 show();
		rpb2p6 MoveTo(rpb2o2.origin, 10);
		wait 12;
		rpb2p6 hide();
		rpb2p6 MoveTo(rpb2o1.origin, .1);
		wait 2;
	}
	
	
	
}

Rpb27()
{
	rpb2o1=getent("rpb2o1","targetname");
	rpb2o2=getent("rpb2o2","targetname");
	rpb2p7=getent("rpb2p7","targetname");

	wait 12;
	while (1)
	{
		
		rpb2p7 show();
		rpb2p7 MoveTo(rpb2o2.origin, 10);
		wait 12;
		rpb2p7 hide();
		rpb2p7 MoveTo(rpb2o1.origin, .1);
		wait 2;
	}
	
	
	
}

Rpb4()
{
	rpb4p1=getent("rpb4p1","targetname");
	rpb4p2=getent("rpb4p2","targetname");
		
}

rpdb()
{
	
	rpdb1t=getent("rpdb1t","targetname");
	rpdb2t=getent("rpdb2t","targetname");
	rpdb3t=getent("rpdb3t","targetname");
	rpdb1=getent("rpdb1","targetname");
	rpdb2=getent("rpdb2","targetname");
	rpdb3=getent("rpdb3","targetname");
	
    level waittill ("round_started");

	rpdb1t delete();
	rpdb2t delete();
	rpdb3t delete();
	rpdb1 delete();
	rpdb2 delete();
	rpdb3 delete();

}


rpdv()
{
	
	rpdv1t=getent("rpdv1t","targetname");
	rpdv2t=getent("rpdv2t","targetname");
	rpdv3t=getent("rpdv3t","targetname");
	rpdv1=getent("rpdv1","targetname");
	rpdv2=getent("rpdv2","targetname");
	rpdv3=getent("rpdv3","targetname");
	
	level waittill ("round_started");

	rpdv1t delete();
	rpdv2t delete();
	rpdv3t delete();
	rpdv1 delete();
	rpdv2 delete();
	rpdv3 delete();

}

adB()
{
	adb=getent("adb","targetname");
	adbt=getent("adbt","targetname");
	
	adbt SetHintString("^3[USE]");
	adbt waittill("trigger");
		adb RotateYaw(90, 3, 0, 1);
		adbt delete();
}

adV()
{
	adv=getent("adv","targetname");
	advt=getent("advt","targetname");
	
	advt SetHintString("^3[USE]");
	advt waittill("trigger");
		adv RotateYaw(90, 3, 0, 1);
		advt delete();
}

adJ()
{
	adj=getent("adj","targetname");
	adjt=getent("adjt","targetname");
	
	adjt SetHintString("^3[USE]");
	adjt waittill("trigger");
		adj RotateYaw(90, 3, 0, 1);
		adjt delete();
}

adO()
{
	ado=getent("ado","targetname");
	adot=getent("adot","targetname");
	
	adot SetHintString("^3[USE]");
	adot waittill("trigger");
		ado RotateYaw(90, 3, 0, 1);
		adot delete();
}


tb1()
{
	tb1p=getent("tb1p","targetname");
	tb1pt=getent("tb1pt","targetname");
	tb1pt SetHintString("^3[USE]");
	tb1pt waittill("trigger");
	tb1pt delete();
	tb1p MoveY(-832, 2);
	wait 6;
	tb1p MoveY(832, 4, 2, 0);
	wait 4;
}

tb2()
{
	tb2p=getent("tb2p","targetname");
	tb2pt=getent("tb2pt","targetname");
	tb2pt SetHintString("^3[USE]");
	tb2pt waittill("trigger");
	tb2pt delete();
	tb2p MoveY(-832, 2);
	wait 6;
	tb2p MoveY(832, 4, 2, 0);
	wait 4;
}

tb3()
{
	tb3p=getent("tb3p","targetname");
	tb3pt=getent("tb3pt","targetname");
	tb3h=getent("tb3h","targetname");
	tb3h enablelinkto();
	tb3h linkTo(tb3p);
	
	tb3pt SetHintString("^3[USE]");
	tb3pt waittill("trigger");
	tb3pt delete();
	
	tb3p MoveZ(160, 2, 0, 1);
	wait 4;
	tb3p MoveZ(-160, 3, 2, 0);
	wait 3;
}

tb4()
{
	tb4p=getent("tb4p","targetname");
	tb4pt=getent("tb4pt","targetname");
	
	tb4pt SetHintString("^3[USE]");
	tb4pt waittill("trigger");
	tb4pt delete();
	
	tb4p RotatePitch(60, 3, 0, 2.5);
	wait 6;
	tb4p RotatePitch(-60, 4, 0, 2);
}


tv1()
{
	tv1p=getent("tv1p","targetname");
	tv1p2=getent("tv1p2","targetname");
	tv1pt=getent("tv1pt","targetname");
	
	tv1pt SetHintString("^3[USE]");
	tv1pt waittill("trigger");
	tv1pt delete();
	
	while(1)
	{
		tv1p movey(-448, 4, 2, 2);
		tv1p2 movey(448, 4, 2, 2);
		wait 4;
		tv1p movey(448, 4, 2, 2);
		tv1p2 movey(-448, 4, 2, 2);
		wait 4;
		
	}
	
}


tv2()
{
	tv2p2=getent("tv2p2","targetname");
	
	level waittill("round_started");

	tv2p2 RotatePitch(390,0.1);
	wait 0.1;
	tv2p2 moveZ(-150,0.1);
	
	
}

tv3()
{
	tv3p1=getent("tv3p1","targetname");
	tv3p2=getent("tv3p2","targetname");
	tv3pt=getent("tv3pt","targetname");
	
	tv3pt SetHintString("^3[USE]");
	tv3pt waittill("trigger");
	tv3pt delete();
	
	while(1)
	{
	tv3p1 moveZ(-256, 2, 0, 1);
	tv3p2 moveZ(-192, 2, 0, 1);
	wait 4;
	tv3p1 moveZ(256, 2, 0, 1);
	tv3p2 moveZ(192, 2, 0, 1);
	wait 6;
	}
	
}

string()
{
	actistring=getent("actistring","targetname");
	actistring SetHintString("^7There are one door per ^5W^2A^3Y^1!^1!");
	jstring=getent("jstring","targetname");
	jstring SetHintString("There are 5 ^5W^2A^3Y^1S^1!^7, from the ^5easiest ^7to the ^1hardest");
}




rpv1s()
{
	rpv1=getent("rpv1", "targetname");
	rpv1p=getent("rpv1p", "targetname");
	rpv1 waittill("trigger");
	rpv1 delete();
	
	while(1)
	{
	rpv1p movez(256, 3, 1, 1);	
	wait 3;
	rpv1p movez(-256, 3, 1, 1);
	wait 3;
	}
}

rpv2s()
{
	rpv2=getent("rpv2", "targetname");
	rpv2p=getent("rpv2p", "targetname");
	rpv2 waittill("trigger");
	rpv2 delete();
	
	while(1)
	{
	rpv2p moveX(-2048, 8, 2, 2);	
	wait 8;
	rpv2p moveX(2048, 8, 2, 2);	
	wait 8;
	}
}

rpv3s()
{
	rpv3p=getent("rpv3p", "targetname");
	
	level waittill("round_started");

	rpv3p RotatePitch(390,0.1);
	rpv3p moveZ(200,0.1);
}

rpj1()
{
	rpj1p=getent("rpj1p", "targetname");
	rpj1t=getent("rpj1t", "targetname");
	rpj1t waittill("trigger");
	rpj1t delete();
	
	while(1)
	{
	rpj1p movex(-2880, 7, 1, 1);	
	wait 9;
	rpj1p movex(2880, 7, 1, 1);
	wait 14;
	}
}

rpj2()
{
	rpj2p=getent("rpj2p", "targetname");
	rpj2o2=getent("rpj2o2", "targetname");
	
	level waittill("round_started");

	rpj2p moveto(rpj2o2.origin,0.1);

}


tj2()
{
	tj2p1=getent("tj2p1", "targetname");
	tj2p2=getent("tj2p2", "targetname");
	tj2p3=getent("tj2p3", "targetname");
	tj2pt=getent("tj2pt", "targetname");
	tj2pt SetHintString("^3[USE]");
	tj2pt waittill("trigger");
	tj2pt delete();
	
	while(1)
	{
	tj2p1 MoveZ(-460, 2, .5, .5);
	wait 3;
	tj2p1 MoveZ(460, 2, .5, .5);
	tj2p2 MoveZ(-460, 2, .5, .5);
	wait 3;
	tj2p3 MoveZ(-460, 2, .5, .5);
	tj2p2 MoveZ(460, 2, .5, .5);
	wait 3;
	tj2p3 MoveZ(460, 2, .5, .5);
	wait 3;
	}
}


tj1()
{
	tj1p=getent("tj1p", "targetname");
	tj1pt=getent("tj1pt", "targetname");
	tj1pt SetHintString("^3[USE]");
	tj1pt waittill("trigger");
	tj1pt delete();
	
	while(1)
	{
	tj1p RotateYaw(360, 5, 1, 1);
	wait 7;
	tj1p RotateYaw(-360, 5, 1, 1);
	wait 7;
	}
}


to1()
{
	to1p=getent("to1p", "targetname");
	to1t=getent("to1t", "targetname");
	to1t SetHintString("^3[USE]");
	to1t waittill("trigger");
	to1t delete();
	
	while(1)
	{
	to1p RotateYaw(360, 5, 1, 1);
	wait 6;
	}
}

to2()
{
	to2p=getent("to2p", "targetname");
	to2t=getent("to2t", "targetname");
	to2t SetHintString("^3[USE]");
	to2t waittill("trigger");
	to2t delete();
	

	to2p MoveY(912, 2, .5, .5);
	wait 6;
	to2p MoveY(-912, 5, 1, 1);
	
	
}

GetActivator()
{
	players = getentarray( "player", "classname" );
	
	for(i = 0;i < players.size;i++)
	{
		player = players[i];
		
		if( isdefined( player ) && isplayer( player ) && isalive( player ) && player.pers["team"] == "axis"	)
			return player;
	}
	
	return "Noactivator";
}

First()
{
	trig = getEnt ("end", "targetname");
	trig waittill("trigger", player);
	iPrintlnBold("^4" + player.name + " ^7Has Finished ^4First");
	player braxi\_rank::giveRankXP("", 100);
	trig delete();
}

games()
{
	trig = getEnt("games", "targetname");
	ori = getEnt ("games_ori", "targetname");
	while (1)
	{
		trig waittill("trigger", player);
		iPrintlnBold("^4" + player.name + " ^7selects the room");
		player SetOrigin(ori.origin);
		player SetPlayerAngles(ori.angles);
		player Death();
		wait 0.1;
	}
}

Death()
{
        self endon("disconnect");
        self waittill("death");
		iprintlnbold("^4" + self.name + "^7 diededed");
}

sniper()
{
        trig = getEnt( "sniper_trig", "targetname"); 
		old_trig = getEnt( "old_trig", "targetname");
		
        jumper = getEnt( "sniper1", "targetname" );
        acti = getEnt( "sniper2", "targetname" ); 
	
	while(1)
	{
		trig waittill("trigger",player);
		ambientPlay("songs");
		old_trig delete();
		iprintlnbold("^4" + player.name + "^7 entered the sniper room");
		player SetOrigin(jumper.origin);
		player SetPlayerAngles(jumper.angles);
		player TakeAllWeapons(); 
		player GiveWeapon("remington700_mp");
		player GiveMaxAmmo("remington700_mp");
		player GiveWeapon("m40a3_mp");
		player GiveMaxAmmo("m40a3_mp");
		player SwitchToWeapon("m40a3_mp");
		activator = GetActivator();
		
	
			activator setPlayerangles( acti.angles );
			activator setOrigin( acti.origin ); 
			activator TakeAllWeapons(); 
			activator GiveWeapon( "m40a3_mp" ); 
			activator giveMaxAmmo( "m40a3_mp" ); 
			activator GiveWeapon( "remington700_mp" );
			activator giveMaxAmmo( "remington700_mp" );
            activator SwitchToWeapon( "m40a3_mp" );
         
		}
	}


old()
{
        sniper_trig = getEnt( "sniper_trig", "targetname");
		trig = getEnt( "old_trig", "targetname");
		bounce_trig = getEnt( "bounce_trig", "targetname");
		surf_trig = getEnt( "surf_trig", "targetname");
		knife_trig = getEnt( "knife_trig", "targetname");
		
        jumper = getEnt( "old1", "targetname" );
        acti = getEnt( "old2", "targetname" ); 
	
	while(1)
	{
		trig waittill("trigger",player);
		sniper_trig delete();
		bounce_trig delete();
		surf_trig delete();
		knife_trig delete();
		iprintlnbold("^4" + player.name + "^7 entered the old room");
		player SetOrigin(jumper.origin);
		player SetPlayerAngles(jumper.angles);
		
		
		activator = GetActivator();
	
			activator setPlayerangles( acti.angles );
			activator setOrigin( acti.origin ); 
			
         
		}
	}


surf()
{
        trig = getEnt( "surf_trig", "targetname"); 
		old_trig = getEnt( "old_trig", "targetname");
		
        jumper = getEnt( "surf1", "targetname" );
        acti = getEnt( "surf2", "targetname" ); 
	
	while(1)
	{
		trig waittill("trigger",player);
		ambientPlay("songsu");
		old_trig delete();
		iprintlnbold("^4" + player.name + "^7 entered the surf room");
		player SetOrigin(jumper.origin);
		player SetPlayerAngles(jumper.angles);
		
		
		activator = GetActivator();
	
			activator setPlayerangles( acti.angles );
			activator setOrigin( acti.origin ); 
			
         
		}
	}


surf_end_1()
{
	trig=getent("surf_end_trigger1", "targetname");
	ori=getent("surf_end1", "targetname");
	while(1)
	{
		trig waittill("trigger", player);
		player setOrigin(ori.origin);
		player setPlayerangles(ori.origin);
		player TakeAllWeapons(); 
		player GiveWeapon("remington700_mp");
		player GiveMaxAmmo("remington700_mp");
		player GiveWeapon("m40a3_mp");
		player GiveMaxAmmo("m40a3_mp");
		player SwitchToWeapon("m40a3_mp");
		wait .1;
	}
	
}

surf_end_2()
{
	trig=getent("surf_end_trigger2", "targetname");
	ori=getent("surf_end1", "targetname");
	while(1)
	{
		trig waittill("trigger", player);
		player setOrigin(ori.origin);
		player setPlayerangles(ori.origin);
		player TakeAllWeapons(); 
		player GiveWeapon("remington700_mp");
		player GiveMaxAmmo("remington700_mp");
		player GiveWeapon("m40a3_mp");
		player GiveMaxAmmo("m40a3_mp");
		player SwitchToWeapon("m40a3_mp");
		wait .1;
	}
	
}


bounce()
{
        trig = getEnt( "bounce_trig", "targetname"); 
		old_trig = getEnt( "old_trig", "targetname");
		
        jumper = getEnt( "bounce1", "targetname" );
        acti = getEnt( "bounce2", "targetname" ); 
	
	while(1)
	{
		trig waittill("trigger",player);
		ambientPlay("songb");
		old_trig delete();
		iprintlnbold("^4" + player.name + "^7 entered the bounce room");
		player SetOrigin(jumper.origin);
		player SetPlayerAngles(jumper.angles);
		player TakeAllWeapons(); 
        player GiveWeapon( "knife_mp" ); 
        player GiveWeapon( "deserteagle_mp" );
		player SetWeaponAmmoClip("deserteagle_mp", 0);
        player SetWeaponAmmoStock("deserteagle_mp", 0);
        player switchToWeapon( "deserteagle_mp" ); 
		
		activator = GetActivator();
	
			activator setPlayerangles( acti.angles );
			activator setOrigin( acti.origin ); 
			activator TakeAllWeapons(); 
		    activator GiveWeapon( "knife_mp" ); 
			activator GiveWeapon( "deserteagle_mp" );
			activator SetWeaponAmmoClip("deserteagle_mp", 0);
			activator SetWeaponAmmoStock("deserteagle_mp", 0);
			activator switchToWeapon( "deserteagle_mp" ); 
         
		}
	}


knife()
{
        trig = getEnt( "knife_trig", "targetname"); 
		old_trig = getEnt( "old_trig", "targetname");
		
        jumper = getEnt( "knife1", "targetname" );
        acti = getEnt( "knife2", "targetname" ); 
	
	while(1)
	{
		trig waittill("trigger",player);
		ambientPlay("songk");
		old_trig delete();
		iprintlnbold("^4" + player.name + "^7 entered the knife room");
		player SetOrigin(jumper.origin);
		player SetPlayerAngles(jumper.angles);
		player TakeAllWeapons(); 
        player GiveWeapon( "knife_mp" ); 
        player GiveWeapon( "deserteagle_mp" );
		player SetWeaponAmmoClip("deserteagle_mp", 0);
        player SetWeaponAmmoStock("deserteagle_mp", 0);
        player switchToWeapon( "deserteagle_mp" ); 
		
		activator = GetActivator();
	
			activator setPlayerangles( acti.angles );
			activator setOrigin( acti.origin ); 
			activator TakeAllWeapons(); 
		    activator GiveWeapon( "knife_mp" ); 
			activator GiveWeapon( "deserteagle_mp" );
			activator SetWeaponAmmoClip("deserteagle_mp", 0);
			activator SetWeaponAmmoStock("deserteagle_mp", 0);
			activator switchToWeapon( "deserteagle_mp" ); 
         
		}
	}


knife_bouncer()
{
	bouncer = getent("knife_bounce", "targetname");
    power = 160;
        while(1)
		{
                bouncer waittill("trigger", player);
					for(i = 0; i < 3; i++)
                        
                        player.health = player.health + 160;
                        eInflictor = player;
                        eAttacker = player;
                        iDamage = power;
                        iDFlags = 0;
                        sMeansOfDeath = "MOD_PROJECTILE";
                        sWeapon = "panzershreck_mp";
                        vPoint = ( player.origin );
                        vDir = AnglesToForward((-90,0,0));
                        sHitLoc = "none";
                        psOffsetTime = 0;
 
                        player finishPlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );
               
        }
}

be1()
{
be1m=getent("be1m","targetname");
be1t=getent("be1t","targetname");
while(1)
{
be1t waittill("trigger");
be1m moveZ(-272,1,0.2,0.2);
wait 2;
be1m moveZ(272,1,0.2,0.2);
wait 1;
}
}

be2()
{
be21m=getent("be21m","targetname");
be22m=getent("be22m","targetname");
be2t=getent("be2t","targetname");
while(1)
{
be2t waittill("trigger");
be21m moveZ(-560,2,0.2,0.2);
wait 0.5;
be22m moveZ(-280,1,0.2,0.2);
wait 3;
be21m moveZ(560,1,0.2,0.2);
wait 0.25;
be22m moveZ(280,0.5,0.2,0.2);
wait 1;
}
}

be12()
{
be1m2=getent("be1m2","targetname");
be1t2=getent("be1t2","targetname");
while(1)
{
be1t2 waittill("trigger");
be1m2 moveZ(-272,1,0.2,0.2);
wait 2;
be1m2 moveZ(272,1,0.2,0.2);
wait 1;
}
}

be22()
{
be21m2=getent("be21m2","targetname");
be22m2=getent("be22m2","targetname");
be2t2=getent("be2t2","targetname");
while(1)
{
be2t2 waittill("trigger");
be21m2 moveZ(-560,2,0.2,0.2);
wait 0.5;
be22m2 moveZ(-280,1,0.2,0.2);
wait 3;
be21m2 moveZ(560,1,0.2,0.2);
wait 0.25;
be22m2 moveZ(280,0.5,0.2,0.2);
wait 1;
}
}


bounce_sniper()
{
	trig=getent("bounce_end","targetname");
	
	while(1)
	{
		trig waittill("trigger", player);
		player TakeAllWeapons(); 
		player GiveWeapon("remington700_mp");
		player GiveMaxAmmo("remington700_mp");
		player GiveWeapon("m40a3_mp");
		player GiveMaxAmmo("m40a3_mp");
		player SwitchToWeapon("m40a3_mp");
		wait 5;
	}
	
}


secret_hard()
{
	trig=getent("h_secret_end", "targetname");
	ori=getent("Oend", "targetname");
	while(1)
	{
	trig waittill("trigger", player);
	player thread sr\api\_speedrun::finishWay("secret_4");
		// iPrintlnBold("^4" + player.name + " ^7Has finished hard secret");
		// player braxi\_rank::giveRankXP("", 1500);
		// player setOrigin(ori.origin);
		// player setPlayerangles(ori.angles);
		// wait .1;
}
}

secret_ez()
{
	trig=getent("ez_secret_end", "targetname");
	ori=getent("Bo3", "targetname");
	door=getent("ez_secret_p", "targetname");
	while(1)
	{
	trig waittill("trigger", player);
	player thread sr\api\_speedrun::finishWay("secret_0");
		// iPrintlnBold("^4" + player.name + " ^7Has finished easy secret");
		// door delete();
		// // player braxi\_rank::giveRankXP("", 200);
		// player setOrigin(ori.origin);
		// player setPlayerangles(ori.angles);
		// wait .1;
}
}

secret_ezz()
{
	trig=getent("ezz_secret_end", "targetname");
	ori=getent("Vo3", "targetname");
	door=getent("ezz_secret_p", "targetname");
	while(1)
	{
	trig waittill("trigger", player);
	player thread sr\api\_speedrun::finishWay("secret_1");
		// iPrintlnBold("^4" + player.name + " ^7Has finished easy + secret");
		// door delete();
		// player braxi\_rank::giveRankXP("", 400);
		// player setOrigin(ori.origin);
		// player setPlayerangles(ori.angles);
		// wait .1;
}
}

secret_i()
{
	trig=getent("i_secret_end", "targetname");
	ori=getent("i_secret_ori", "targetname");
	while(1)
	{
	trig waittill("trigger", player);
	player thread sr\api\_speedrun::finishWay("secret_2");
		// iPrintlnBold("^4" + player.name + " ^7Has finished inter secret");
		// player braxi\_rank::giveRankXP("", 750);
		// player setOrigin(ori.origin);
		// player setPlayerangles(ori.angles);
		// wait .1;
}
}

secret_ii()
{
	trig=getent("ii_secret_end", "targetname");
	ori=getent("ii_secret_ori", "targetname");
	while(1)
	{
	trig waittill("trigger", player);
	player thread sr\api\_speedrun::finishWay("secret_3");
		// iPrintlnBold("^4" + player.name + " ^7Has finished inter + secret");
		// player braxi\_rank::giveRankXP("", 1000);
		// player setOrigin(ori.origin);
		// player setPlayerangles(ori.angles);
		// wait .1;
}
}

secret_hard2()
{
	trig=getent("h_secret_enter", "targetname");
	
	while(1)
	{
	trig waittill("trigger", player);
	player thread sr\api\_speedrun::changeWay("secret_4");
		// player iPrintlnBold("You entered hard secret");
		// wait 1;
}
}
secret_ez2()
{
	trig=getent("ez_secret_enter", "targetname");
	
	while(1)
	{
	trig waittill("trigger", player);
	player thread sr\api\_speedrun::changeWay("secret_0");
		// player iPrintlnBold("You entered easy secret");
		// wait 1;
}
}

secret_ezz2()
{
	trig=getent("ezz_secret_enter", "targetname");
	
	while(1)
	{
	trig waittill("trigger", player);
	player thread sr\api\_speedrun::changeWay("secret_1");
		// player iPrintlnBold("You entered easy + secret");
		// wait 1;
}
}
secret_i2()
{
	trig=getent("i_secret_enter", "targetname");
	
	while(1)
	{
	trig waittill("trigger", player);
	player thread sr\api\_speedrun::changeWay("secret_2");
		// player iPrintlnBold("You entered inter secret");
		// wait 1;
}
}

secret_ii2()
{
	trig=getent("ii_secret_enter", "targetname");
	
	while(1)
	{
	trig waittill("trigger", player);
	player thread sr\api\_speedrun::changeWay("secret_3");
		// player iPrintlnBold("You entered inter + secret");
		// wait 1;
}
}