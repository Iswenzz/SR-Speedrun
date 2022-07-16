main()
{
	    
        thread sr\api\_speedrun::createNormalWays("Normal Way");
        thread sr\api\_map::createSpawn((-498,-394,76),90);
        thread sr\api\_speedrun::createTeleporter((-757.779, 4766.55, 0.124998), 95, 115, (-511, 4861, 790), 270, "freeze");
        thread smrt ();
        //thread teleport();
		thread door_a();
        thread door_b();
        thread door_c();
		//thread text();
        //thread trap0();
        //thread trap1();
        thread trap2();
        thread trap3();
        //thread trap4();
        //thread trap5();
        //thread trap6_1();
        //thread trap6_2();
       // thread trap6_3();
        //thread trap6_b();
        //thread trap7();
        //thread trap8();
       // thread trap9();
       // thread trap10_a();
       // thread trap10_b();
       // thread trap10_c();
       // thread trap11_a();
       // thread trap11_b();
level._effect[ "redflash" ] = loadfx( "misc/icbm_post_light_red" );

        maps\mp\_load::main();

    ambientPlay("dirt");
	
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

        level.trapTriggers = [];
        level.trapTriggers[level.trapTriggers.size] = getEnt( "t1", "targetname" );
        level.trapTriggers[level.trapTriggers.size] = getEnt( "t2", "targetname" );
        level.trapTriggers[level.trapTriggers.size] = getEnt( "t3", "targetname" );
        level.trapTriggers[level.trapTriggers.size] = getEnt( "t4", "targetname" );
        level.trapTriggers[level.trapTriggers.size] = getEnt( "t5", "targetname" );
        level.trapTriggers[level.trapTriggers.size] = getEnt( "t6", "targetname" );
        level.trapTriggers[level.trapTriggers.size] = getEnt( "t7", "targetname" );
        level.trapTriggers[level.trapTriggers.size] = getEnt( "t8", "targetname" );
        level.trapTriggers[level.trapTriggers.size] = getEnt( "t9", "targetname" );
}

smrt()
{
	smrt1 = getentarray("smrt", "targetname");
	if (smrt1.size > 0)
	                 
	for(i = 0; i < smrt1.size; i++)
	{
		smrt1[i] thread smrt_think();
	}	
}

smrt_think()
{
	while (1)
	{
		self waittill ("trigger",other);
		
		if(isPlayer(other))
			other thread smrt_kill(self);
	}
}

smrt_kill(trigger)
{
	if(isDefined(self.smrt))
		return;
		
	self.smrt = true;

	if(isdefined(self) && self istouching(trigger))
	{
		origin = self getorigin();
		range = 300;
		maxdamage = 2000;
		mindamage = 50;

		radiusDamage(origin, range, maxdamage, mindamage);
	}
	
	self.smrt = undefined;
}

teleport()
{
	entTransporter = getentarray( "tele", "targetname" );
 
	if(isdefined(entTransporter))
	{
		for( i = 0; i < entTransporter.size; i++ )
			entTransporter[i] thread transporter();
	}
}
 
transporter()
{
	while(true)
	{
		self waittill( "trigger", player );
		origin1 = getEnt( "origin1", "targetname" );
		wait 0.1;
        player setOrigin( origin1.origin );
		player setplayerangles(origin1.angles);
		wait 0.1;
	}
}

door_a()
{
door_a = getentarray ("door_a" ,"targetname");


door_a[0] delete();
door_a[1] delete();
door_a[2] delete();
door_a[3] delete();

}

door_b()
{
	trig = getent ("door_b_trig" , "targetname");
	trig delete ();
	//ambientPlay("doorb_dirt");
}

door_c()
{
	trig = getent ("door_c_trig" , "targetname");
	door_b = getent ("door_c" ,"targetname" );
	trig delete ();
	//ambientPlay("doorc_dirt");
	door_b delete();
}

text()
	{
	so = getent ("text","targetname");
	so waittill ("trigger",player);
        so delete ();

while(1)
{
	player iprintln ("^3Map by ^1PetX");
	wait 10;
	player iprintln ("^4Thanks:^2mnaauuu, K4r3l01, R3MIEN");
	wait 10;
	player iprintln ("^2www.4gf.cz");
        wait 10;
	player iprintln ("^5For Gamers Fusion");
	wait 60;
}
	}


trap0()
{
start = getent( "start" , "targetname" );
v = getent( "vrtula" , "targetname" );
wait 15;
start movez (-193, 1);
wait 10;

while (1)
  {
  v RotateYaw( 360, 2, 0.5, 0.5 );
  wait 10;
  }
}

trap1()
{
kyvadlo1 = getent( "kyvadlo1" , "targetname" );
kyvadlo2 = getent( "kyvadlo2" , "targetname" );
kyvadlo3 = getent( "kyvadlo3" , "targetname" );
red = getent ("red1" ,"targetname"); //origin
t1 = getent ("t1" , "targetname");

t1 waittill ("trigger");
t1 delete ();
fx = PlayLoopedFX(level._effect["redflash"], 1, red.origin );

wait 0.5;
        while( 1 )
	{
		kyvadlo1 rotatePitch( 360, 3, 0.4, 0.4  );
		kyvadlo2 rotatePitch( -360, 3, 0.4, 0.4  );
		kyvadlo3 rotatePitch( 360, 3, 0.4, 0.4  );
		wait 3;	
	}
}

trap2()
{
kill = getent ("trap2_kill" ,"targetname");
trig = getent ("trap2_trig" ,"targetname");
t2 = getent ("t2" , "targetname");
red = getent ("red2" ,"targetname"); //origin

trig enableLinkTo();
trig linkTo( kill );
kill movez (-113, 1);

t2 waittill ("trigger");
}

trap3()
{
t3 = getent ("t3" , "targetname");
kill = getent ("trap3_kill" ,"targetname");
red = getent ("red3" ,"targetname"); //origin

kill movex (-624,0.05);

t3 waittill ("trigger");
}

trap4()
{
t4 = getent ("t4" , "targetname");
kill = getent ("trap4_kill" ,"targetname");
red = getent ("red4" ,"targetname"); //origin

t4 waittill ("trigger");
}

trap5()
{
r1 = getent( "trap5_rotate1" , "targetname" );
r2 = getent( "trap5_rotate2" , "targetname" );
r3 = getent( "trap5_rotate3" , "targetname" );
t5 = getent ("t5" , "targetname");
red = getent ("red5" ,"targetname"); //origin

t5 waittill ("trigger");
t5 delete ();
fx = PlayLoopedFX( level._effect["redflash"], 1, red.origin );

        while( 1 )
	{
cas = 4;
o = 360;
	    r1 rotateyaw( o, cas, 0.4, 0.4  );
		r2 rotateyaw( 0-o, cas, 0.4, 0.4  );
		r3 rotateyaw( o, cas, 0.4, 0.4  );
        wait cas;
		}

}

trap6_1()
{
r1 = getent( "pad1" , "targetname" );
r2 = getent( "pad2" , "targetname" );
r3 = getent( "pad3" , "targetname" );

    while( 1 )
	{
        cas = 3;
        r1 movez (320, cas);
        wait cas;
        r2 movez (320, cas);
        wait cas;
        r3 movez (320, cas);
        r1 movez (-320, cas);			
        wait 4;
        r2 movez (-320, cas);
        r3 movez (-320, cas);
        wait cas;		
		}
}

trap6_2()
{
r1 = getent( "pad1_2" , "targetname" );
r2 = getent( "pad2_2" , "targetname" );
r3 = getent( "pad3_2" , "targetname" );

        cas = 3;
        r1 movez (160, cas);
        wait cas;
	    r2 movez (160, cas);
        wait cas;	
        r3 movez (160, cas);

    while( 1 )
	{
        cas = 3;
        r1 movez (-320, cas);
        wait cas;
        r2 movez (-320, cas);
        wait cas;
        r3 movez (-320, cas);
        r1 movez (320, cas);			
        wait 4;
        r2 movez (320, cas);
        r3 movez (320, cas);
        wait cas;		
		}
}

trap6_3()
{
r1 = getent( "pad1_3" , "targetname" );
r2 = getent( "pad2_3" , "targetname" );
r3 = getent( "pad3_3" , "targetname" );

    while( 1 )
	{
        cas = 3;
        r1 movez (-320, cas);
        wait cas;
        r2 movez (-320, cas);
        wait cas;
        r3 movez (-320, cas);
        r1 movez (320, cas);			
        wait 4;
        r2 movez (320, cas);
        r3 movez (320, cas);
        wait cas;		
		}
}

trap6_b()
{
t6 = getent ("t6" , "targetname");
red = getent ("red6" ,"targetname"); //origin

t6 waittill ("trigger");
t6 delete ();
fx = PlayLoopedFX( level._effect["redflash"], 1, red.origin );

if ( randomInt(99)%2 == 0 )
thread t6_2();
else
thread t6_1(); 
}

t6_2()
{
kill = getent( "trap6_kill2" , "targetname" );
kill movey (-384, 2);
wait 5;
kill movey (384, 2);
}

t6_1()
{
kill = getent
( "trap6_kill" , "targetname" );
kill movey (-384, 2);
wait 5;
kill movey (384, 2);
}

trap7()
{
t7 = getent ("t7" , "targetname");
kill = getent ("trap7_kill" ,"targetname");
red = getent ("red7" ,"targetname"); //origin

t7 waittill ("trigger");
t7 delete ();

fx = PlayLoopedFX( level._effect["redflash"], 1, red.origin );

kill movez (288,3);
wait 6;
kill movez (-288,3);
}

trap8()
{
part1 = getentarray ("part1" ,"targetname");
part2 = getentarray ("part2" ,"targetname");
part3 = getentarray ("part3" ,"targetname");
part4 = getentarray ("part4" ,"targetname");
red = getent ("red8" ,"targetname"); //origin

t8 = getent ("t8" , "targetname");
t8 waittill ("trigger");
t8 delete ();
fx = PlayLoopedFX(level._effect["redflash"], 1, red.origin );

part1[randomInt(part1.size)] delete();
part2[randomInt(part2.size)] delete();
part3[randomInt(part3.size)] delete();
part4[randomInt(part4.size)] delete();
}

trap9()
{
p1 = getent ("otocka1" ,"targetname");
p2 = getent ("otocka2" ,"targetname");
t9 = getent ("t9" , "targetname");
red = getent ("red9" ,"targetname"); //origin
t9 waittill ("trigger");
t9 delete ();
fx = PlayLoopedFX( level._effect["redflash"], 1, red.origin );

cas = 3;

p1 rotatePitch( 90, cas, 0.1, 0.1  );
p2 rotatePitch( -90, cas, 0.1, 0.1  );
wait 8;
p1 rotatePitch( -90, cas, 0.1, 0.1  );
p2 rotatePitch( 90, cas, 0.1, 0.1  );
}

trap10_a()
{
t10 = getent ("t10" , "targetname");
red = getent ("red10" ,"targetname"); //origin

t10 waittill ("trigger");
t10 delete ();

fx = PlayLoopedFX( level._effect["redflash"], 1, red.origin );

if ( randomInt(99)%2 == 0 )
thread kill2();
else
thread kill1(); 
}

trap10_b()
{
t10 = getent ("t10" , "targetname");
t10 waittill ("trigger");

if ( randomInt(99)%2 == 0 )
thread kill4();
else
thread kill3(); 
}

trap10_c()
{
t10 = getent ("t10" , "targetname");
t10 waittill ("trigger");

if ( randomInt(99)%2 == 0 )
thread kill6();
else
thread kill5(); 
}

kill1()
{
kill = getent ("trap10_kill1" ,"targetname");
trig = getent ("trap10_trig1" ,"targetname");

trig enableLinkTo();
trig linkTo( kill );
kill movez (80, 1);
wait 5;
kill movez (-80, 1);
trig unlink();
trig delete();
}

kill2()
{
kill = getent ("trap10_kill2" ,"targetname");
trig = getent ("trap10_trig2" ,"targetname");

trig enableLinkTo();
trig linkTo( kill );
kill movez (80, 1);
wait 5;
kill movez (-80, 1);
trig unlink();
trig delete();
}

kill3()
{
kill = getent ("trap10_kill3" ,"targetname");
trig = getent ("trap10_trig3" ,"targetname");

trig enableLinkTo();
trig linkTo( kill );
kill movez (80, 1);
wait 5;
kill movez (-80, 1);
trig unlink();
trig delete();
}

kill4()
{
kill = getent ("trap10_kill4" ,"targetname");
trig = getent ("trap10_trig4" ,"targetname");

trig enableLinkTo();
trig linkTo( kill );
kill movez (80, 1);
wait 5;
kill movez (-80, 1);
trig unlink();
trig delete();
}

kill5()
{
kill = getent ("trap10_kill5" ,"targetname");
trig = getent ("trap10_trig5" ,"targetname");

trig enableLinkTo();
trig linkTo( kill );
kill movez (80, 1);
wait 5;
kill movez (-80, 1);
trig unlink();
trig delete();
}

kill6()
{
kill = getent ("trap10_kill6" ,"targetname");
trig = getent ("trap10_trig6" ,"targetname");

trig enableLinkTo();
trig linkTo( kill );
kill movez (80, 1);
wait 5;
kill movez (-80, 1);
trig unlink();
trig delete();
}

trap11_a()
{
part1 = getentarray ("cast1" ,"targetname");
part2 = getentarray ("cast2" ,"targetname");
part3 = getentarray ("cast3" ,"targetname");
part4 = getentarray ("cast4" ,"targetname");
part5 = getentarray ("cast5" ,"targetname");
red = getent ("red11" ,"targetname"); //origin

t11 = getent ("t11" , "targetname");
t11 waittill ("trigger");
t11 delete ();
fx = PlayLoopedFX(level._effect["redflash"], 1, red.origin );

part1[randomInt(part1.size)] NotSolid();
part2[randomInt(part2.size)] NotSolid();
part3[randomInt(part3.size)] NotSolid();
part4[randomInt(part4.size)] NotSolid();
part5[randomInt(part5.size)] NotSolid();
}

trap11_b()
{
p1 = getent ("t11_1" ,"targetname");
p2 = getent ("t11_2" ,"targetname");
p3 = getent ("t11_3" ,"targetname");
p4 = getent ("t11_4" ,"targetname");
p5 = getent ("t11_5" ,"targetname");

p1 rotatePitch( 180, 1, 0.1, 0.1  );
p3 rotatePitch( 180, 1, 0.1, 0.1  );
p5 rotatePitch( 180, 1, 0.1, 0.1  );
p2 rotateroll( 180, 1, 0.1, 0.1  );
p4 rotateroll( 180, 1, 0.1, 0.1  );
}