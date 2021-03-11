main()
{

thread text();
// thread trap0();
// thread trap1();
// thread trap2();
// thread trap3();
// thread trap3_a();
// thread trap3_b();
// thread trap3_c();
// thread trap3_d();
// thread trap3_e();
// thread trap3_f();
// thread trap4_a();
// thread trap4_b();
// thread trap5_a();
// thread trap5_b();
// thread trap6();
// thread trap7();
// thread trap8();
// thread trap9_a();
// thread trap9_b();

level._effect[ "redflash" ] = loadfx( "misc/icbm_post_light_red" );
}


text()
	{
	so = getent ("write","targetname");
	so waittill ("trigger",player);
        so delete ();

while(1)
{
	/* [AUTO DELETE] player iprintln ("^3Map by ^1PetX"); */
	wait 10;
	/* [AUTO DELETE] player iprintln ("^4Thanks: ^2mnaauuu, K4r3l01, R3MIEN"); */
	wait 10;
	/* [AUTO DELETE] player iprintln ("^2www.4gf.cz"); */
        wait 10;
	/* [AUTO DELETE] player iprintln ("^5For Gamers Fusion"); */
	wait 60;
}
	}



trap0()
{
start = getent( "start" , "targetname" );
v = getent( "vrtula" , "targetname" );

}


trap1()
{
	level endon("trigger");
part1 = getentarray ("part_1" ,"targetname");
part2 = getentarray ("part_2" ,"targetname");
part3 = getentarray ("part_3" ,"targetname");
part4 = getentarray ("part_4" ,"targetname");
red = getent ("red3" ,"targetname"); //origin

t1 = getent ("t1" , "targetname");
t1 waittill ("trigger");
t1 delete ();
fx = PlayLoopedFX(level._effect["redflash"], 1, red.origin );

part1[randomInt(part1.size)] NotSolid();
part2[randomInt(part2.size)] NotSolid();
part3[randomInt(part3.size)] NotSolid();
part4[randomInt(part4.size)] NotSolid();
}


trap2()
{
	level endon("trigger");
k1 = getent ("koleso1" ,"targetname");
k2 = getent ("koleso2" ,"targetname");
t2 = getent ("t2" , "targetname");
red = getent ("red2" ,"targetname"); //origin

t2 waittill ("trigger");
t2 delete ();
fx = PlayLoopedFX( level._effect["redflash"], 1, red.origin );

while (1)
{
o = RandomIntRange(60,360);
k1 rotatePitch( o, o/100, 0.1, 0.1  );
k2 rotatePitch( o, o/100, 0.1, 0.1  );
wait 3.6;
b = RandomIntRange(60,360);
k1 rotatePitch( 0-b, b/100, 0.1, 0.1  );
k2 rotatePitch( 0-b, b/100, 0.1, 0.1  );
wait 10 ;
}
}


trap3()
{
	level endon("trigger");
t3 = getent ("t3" , "targetname");
red = getent ("red1" ,"targetname"); //origin

t3 waittill ("trigger");
t3 delete ();

fx = PlayLoopedFX( level._effect["redflash"], 1, red.origin );

if ( randomInt(99)%2 == 0 )
thread prepadliste2();
else
thread prepadliste1(); 
}


trap3_a()
{
	level endon("trigger");
t3 = getent ("t3" , "targetname");
t3 waittill ("trigger");

if ( randomInt(99)%2 == 0 )
thread prepadliste3();
else
thread prepadliste4(); 
}


trap3_b()
{
	level endon("trigger");
t3 = getent ("t3" , "targetname");
t3 waittill ("trigger");

if ( randomInt(99)%2 == 0 )
thread prepadliste5();
else
thread prepadliste6(); 
}



trap3_c()
{
	level endon("trigger");
t3 = getent ("t3" , "targetname");
t3 waittill ("trigger");

if ( randomInt(99)%2 == 0 )
thread prepadliste7();
else
thread prepadliste8(); 
}


trap3_d()
{
	level endon("trigger");
t3 = getent ("t3" , "targetname");
t3 waittill ("trigger");

if ( randomInt(99)%2 == 0 )
thread prepadliste9();
else
thread prepadliste10(); 
}


trap3_e()
{
	level endon("trigger");
t3 = getent ("t3" , "targetname");
t3 waittill ("trigger");

if ( randomInt(99)%2 == 0 )
thread prepadliste11();
else
thread prepadliste12(); 
}


trap3_f()
{
	level endon("trigger");
t3 = getent ("t3" , "targetname");
t3 waittill ("trigger");

if ( randomInt(99)%2 == 0 )
thread prepadliste13();
else
thread prepadliste14(); 
}


prepadliste14()
{
prepadliste14 = getent( "prepadliste14" , "targetname" );
prepadliste_trig14 = getent( "prepadliste_trig14" , "targetname" );

prepadliste_trig14 waittill ("trigger");
prepadliste14 delete ();
}


prepadliste13()
{
prepadliste13 = getent( "prepadliste13" , "targetname" );
prepadliste_trig13 = getent( "prepadliste_trig13" , "targetname" );

prepadliste_trig13 waittill ("trigger");
prepadliste13 delete ();
}


prepadliste12()
{
prepadliste12 = getent( "prepadliste12" , "targetname" );
prepadliste_trig12 = getent( "prepadliste_trig12" , "targetname" );

prepadliste_trig12 waittill ("trigger");
prepadliste12 delete ();
}


prepadliste11()
{
prepadliste11 = getent( "prepadliste11" , "targetname" );
prepadliste_trig11 = getent( "prepadliste_trig11" , "targetname" );

prepadliste_trig11 waittill ("trigger");
prepadliste11 delete ();
}


prepadliste10()
{
prepadliste10 = getent( "prepadliste10" , "targetname" );
prepadliste_trig10 = getent( "prepadliste_trig10" , "targetname" );

prepadliste_trig10 waittill ("trigger");
prepadliste10 delete ();
}


prepadliste9()
{
prepadliste9 = getent( "prepadliste9" , "targetname" );
prepadliste_trig9 = getent( "prepadliste_trig9" , "targetname" );

prepadliste_trig9 waittill ("trigger");
prepadliste9 delete ();
}


prepadliste8()
{
prepadliste8 = getent( "prepadliste8" , "targetname" );
prepadliste_trig8 = getent( "prepadliste_trig8" , "targetname" );

prepadliste_trig8 waittill ("trigger");
prepadliste8 delete ();
}


prepadliste7()
{
prepadliste7 = getent( "prepadliste7" , "targetname" );
prepadliste_trig7 = getent( "prepadliste_trig7" , "targetname" );

prepadliste_trig7 waittill ("trigger");
prepadliste7 delete ();
}


prepadliste6()
{
prepadliste6 = getent( "prepadliste6" , "targetname" );
prepadliste_trig6 = getent( "prepadliste_trig6" , "targetname" );

prepadliste_trig6 waittill ("trigger");
prepadliste6 delete ();
}


prepadliste5()
{
prepadliste5 = getent( "prepadliste5" , "targetname" );
prepadliste_trig5 = getent( "prepadliste_trig5" , "targetname" );

prepadliste_trig5 waittill ("trigger");
prepadliste5 delete ();
}


prepadliste4()
{
prepadliste4 = getent( "prepadliste4" , "targetname" );
prepadliste_trig4 = getent( "prepadliste_trig4" , "targetname" );

prepadliste_trig4 waittill ("trigger");
prepadliste4 delete ();
}


prepadliste3()
{
prepadliste3 = getent( "prepadliste3" , "targetname" );
prepadliste_trig3 = getent( "prepadliste_trig3" , "targetname" );

prepadliste_trig3 waittill ("trigger");
prepadliste3 delete ();
}


prepadliste2()
{
prepadliste2 = getent( "prepadliste2" , "targetname" );
prepadliste_trig2 = getent( "prepadliste_trig2" , "targetname" );

prepadliste_trig2 waittill ("trigger");
prepadliste2 delete ();
}


prepadliste1()
{
prepadliste1 = getent( "prepadliste1" , "targetname" );
prepadliste_trig1 = getent( "prepadliste_trig1" , "targetname" );

prepadliste_trig1 waittill ("trigger");
prepadliste1 delete ();
}


trap4_a()
{
move = getent ("trap4_move" ,"targetname");

// while (1) 
// {
// move movey (-560, 4.5);
// wait 4.5;
// move movey (560, 4.5);
// wait 4.5;
// }
}


trap4_b()
{
	level endon("trigger");
kill = getent ("trap4_kill" ,"targetname");
trig = getent ("t4_trig" ,"targetname");
t4 = getent ("t4" , "targetname");
red = getent ("red4" ,"targetname"); //origin

t4 waittill ("trigger");
t4 delete ();
fx = PlayLoopedFX( level._effect["redflash"], 1, red.origin );

trig enableLinkTo();
trig linkTo( kill );
kill movez (-528, 5);

wait 8;

kill movez (528, 5);
trig unLink();
trig delete();
}


trap5_a()
{
kyvadlo1 = getent( "kyvadlo1" , "targetname" );
kyvadlo2 = getent( "kyvadlo2" , "targetname" );
kyvadlo3 = getent( "kyvadlo3" , "targetname" );

kyvadlo1 delete();
kyvadlo2 delete();
kyvadlo3 delete();

}


trap5_b()
{
	level endon("trigger");
part1 = getentarray ("kyv_1" ,"targetname");
part2 = getentarray ("kyv_2" ,"targetname");
t5 = getent ("t5" , "targetname");
red = getent ("red5" ,"targetname"); //origin

t5 waittill ("trigger");
t5 delete ();
fx = PlayLoopedFX( level._effect["redflash"], 1, red.origin );

part1[randomInt(part1.size)] delete();
part2[randomInt(part2.size)] delete();
}


trap6()
{
	level endon("trigger");
m1 = getent ("mackac_1" ,"targetname");
m2 = getent ("mackac_2" ,"targetname");
kill = getent ("t6_kill" ,"targetname");
trig = getent ("t6_trig" ,"targetname");
red = getent ("red6" ,"targetname"); //origin

m1 movex (-560, 0.5);
m2 movex (560, 0.5);

t6 = getent ("t6" , "targetname");
t6 waittill ("trigger");
t6 delete ();
fx = PlayLoopedFX( level._effect["redflash"], 1, red.origin );

m1 movex (576, 3);
m2 movex (-576, 3);
wait 2.8;

trig enableLinkTo();
trig linkTo( kill );
kill movez (192, 0.05);

wait 0.2;

trig unLink();
trig delete();
kill delete();
}


trap7()
{
	level endon("trigger");
kill = getent ("trap7_kill" ,"targetname");
red = getent ("red7" ,"targetname"); //origin

t7 = getent ("t7" , "targetname");
t7 waittill ("trigger");
t7 delete ();
fx = PlayLoopedFX( level._effect["redflash"], 1, red.origin );

kill movex (-1152, 2);
wait 3;
kill movex (1152, 4);
wait 4;
}


trap8()
{
	level endon("trigger");
p1 = getent ("otocka1" ,"targetname");
p2 = getent ("otocka2" ,"targetname");
t8 = getent ("t8" , "targetname");
red = getent ("red8" ,"targetname"); //origin
t8 waittill ("trigger");
t8 delete ();
fx = PlayLoopedFX( level._effect["redflash"], 1, red.origin );

cas = 5;
t = 10;

p1 rotateroll( -90, cas, 0.1, 0.1  );
p2 rotateroll( 90, cas, 0.1, 0.1  );
wait t;

while (1)
{
p1 rotateroll( 180, cas, 0.1, 0.1  );
p2 rotateroll( -180, cas, 0.1, 0.1  );
wait t;
p1 rotateroll( -180, cas, 0.1, 0.1  );
p2 rotateroll( 180, cas, 0.1, 0.1  );
wait t;
}
}


trap9_a()
{
move1 = getent ("trap9_move1" ,"targetname");
move2 = getent ("trap9_move2" ,"targetname");



}


trap9_b()
{
	level endon("trigger");
z = getent ("zhadzovac" ,"targetname");
red = getent ("red9" ,"targetname"); //origin

t9 = getent ("t9" , "targetname");
t9 waittill ("trigger");
t9 delete ();
fx = PlayLoopedFX( level._effect["redflash"], 1, red.origin );

while (1)
{
z rotateyaw( 360, 5, 0.1, 0.1  );
wait 5;

}
}
