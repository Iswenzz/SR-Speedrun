main()
{
//thread laser();
// thread text();
//thread trap0();
//thread trap1();
//thread trap2();
//thread trap3();
//thread trap4();
thread trap5();
thread trap6();
thread trap7();


//level._effect[ "redflash" ] = loadfx( "misc/icbm_post_light_red" );
//level._effect[ "jed" ] = loadfx( "impacts/water_leak" );
//level._effect[ "dym2" ] = loadfx( "smoke/car_damage_whitesmoke" );
//level._effect[ "blesk" ] = loadfx( "misc/blesky2" );
//level._effect[ "laser" ] = loadfx( "misc/laser" );
}


text()
{
while(1)
{
	iprintlnbold ("^3Map by ^1Col!ar ^3& ^1PetX");
	wait 10;
	iprintlnbold ("^3Script by ^1PetX");
	iprintlnbold ("^4Thanks: ^2K4r3l01, R3MIEN");
	wait 10;
	iprintlnbold ("^2www.4gf.cz");
    wait 10;
	iprintlnbold ("^5For Gamers Fusion");
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
t1 = getent ("t1" , "targetname");
kill = getent ("t1_kill" , "targetname");

t1 waittill ("trigger");
t1 delete ();
//fx = PlayLoopedFX(level._effect["redflash"], 1, red.origin );

kill movez ( -100, 1 );
wait 5;
kill movez ( 100, 5 );
}

trap2()
{
rotate = getent( "t2_kill" , "targetname" );
t2 = getent ("t2" , "targetname");
//red = getent ("red5" ,"targetname"); //origin

t2 waittill ("trigger");
t2 delete ();
//fx = PlayLoopedFX( level._effect["redflash"], 1, red.origin );

    while( 1 )
	{
    cas = 7;
	rotate rotateroll( -360, cas );
    wait cas;
	}
}

trap3()
{
part1 = getentarray ("t3_1" ,"targetname");
part2 = getentarray ("t3_2" ,"targetname");

//red = getent ("red7" ,"targetname"); //origin
t3 = getent ("t3" , "targetname");

t3 waittill ("trigger");
t3 delete ();
//fx = PlayLoopedFX(level._effect["redflash"], 1, red.origin );

part1[randomInt(part1.size)] notsolid();
part2[randomInt(part2.size)] notsolid();
}

trap4()
{
part1 = getentarray ("t4_1" ,"targetname");

//red = getent ("red7" ,"targetname"); //origin
t4 = getent ("t4" , "targetname");

t4 waittill ("trigger");
t4 delete ();
//fx = PlayLoopedFX(level._effect["redflash"], 1, red.origin );

part1[randomInt(part1.size)] notsolid();
}

trap5()
{
kill = getent( "t5_kill" , "targetname" );
trig = getent( "t5_trig" , "targetname" );
trig_door = getent( "t5_door_trig" , "targetname" );
m = getent( "t5_mac" , "targetname" );
door = getent( "t5_door" , "targetname" );
t5 = getent ("t5" , "targetname");

door movez ( 84, 1 );
}

trap6()
{
t6 = getent ("t6" , "targetname");
m1 = getent ("t6_m1" ,"targetname");
m2 = getent ("t6_m2" ,"targetname");
kill = getent ("t6_kill" ,"targetname");
trig = getent ("t6_trig" ,"targetname");

}

trap7()
{
gula = getent ("t7_gula" ,"targetname");
trig = getent ("gula_trig" ,"targetname");
origin = getent ("gula_origin" ,"targetname");
door = getent ("t7_door" ,"targetname");
desky = getent ("t7_desky" ,"targetname");
trig_door = getent ("t7_door_trig" ,"targetname");
t7 = getent ("t7" , "targetname");


}

killtrigger()
{
while (1)
{
self waittill ("trigger", player);
player suicide();
}
}


