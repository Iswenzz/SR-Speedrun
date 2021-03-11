main()
{
thread trap8();
thread trap9();
thread trap10();
thread trap11();
//thread trap12();
thread trap12_b();
thread trap13();
thread trap14();
thread trap15();
}

trap8()
{
t8 = getent ("t8" , "targetname");
kill = getent ("t8_kill" ,"targetname");
trig = getent ("t8_trig" ,"targetname");

t8 waittill ("trigger");
t8 delete ();

trig enableLinkTo();
trig linkTo( kill );
kill movez (-256, 2);

wait 8;

kill movez (256, 4);
trig unLink();
trig delete();
}

trap8_b()
{
move = getent ("t8_move" ,"targetname");

while (1) 
{
move movey (-832, 4, 1, 1);
wait 4;
move movey (832, 4, 1, 1);
wait 4;
}
}

trap9()
{
kyvadlo1 = getent( "kyvadlo1" , "targetname" );
kyvadlo2 = getent( "kyvadlo2" , "targetname" );
t9 = getent ("t9" , "targetname");

t9 waittill ("trigger");
t9 delete ();

        while( 1 )
	{
		kyvadlo1 rotatePitch( 360, 2 );
		kyvadlo2 rotatePitch( -360, 2 );
		wait 2;	
	}
}

trap10()
{
vrtula = getent( "t10_vrtula" , "targetname" );
t10 = getent ("t10" , "targetname");
kill1 = getent ("t10_kill1" , "targetname");
kill2 = getent ("t10_kill2" , "targetname");
kill3 = getent ("t10_kill3" , "targetname");
kill4 = getent ("t10_kill4" , "targetname");
kill5 = getent ("t10_kill5" , "targetname");
kill6 = getent ("t10_kill6" , "targetname");

t10 waittill ("trigger");
t10 delete ();

vrtula rotateroll (360, 1);
kill1 movex ( -568, 0.4 );
wait 0.501;
kill2 movex ( -568, 0.4 );
wait 0.5;
vrtula rotateroll (360, 1);
kill3 movex ( -568, 0.4 );
wait 0.501;
kill4 movex ( -568, 0.4 );
wait 0.5;
vrtula rotateroll (360, 1);
kill5 movex ( -568, 0.4 );
wait 0.501;
kill6 movex ( -568, 0.4 );
wait 0.5;
kill1 delete();
kill2 delete();
kill3 delete();
kill4 delete();
kill5 delete();
kill6 delete();
}

trap11()
{
t11 = getent ("t11" , "targetname");
kill1 = getent ("t11_kill1" , "targetname");
kill2 = getent ("t11_kill2" , "targetname");
kill3 = getent ("t11_kill3" , "targetname");

t11 waittill ("trigger");
t11 delete ();

kill1 thread rotate1();
kill2 thread rotate2();
kill3 thread rotate3();
}

rotate1()
{
cas = 2;

while (1)
{
self rotateyaw (360, cas);
wait cas;
}
}

rotate2()
{
cas = 1.5;

while (1)
{
self rotateyaw (360, cas);
wait cas;
}
}

rotate3()
{
cas = 1;

while (1)
{
self rotateyaw (360, cas);
wait cas;
}
}

trap12_b()
{
t12 = getent ("t12" , "targetname");
kill = getent ("t12_b_kill" , "targetname");

t12 waittill ("trigger");
t12 delete ();

c = 2;
v = 3;

kill rotateroll (360, v);
wait v;
kill rotateroll (-360, c);
wait c;
kill rotateroll (360, v);
wait v;
kill rotateroll (-360, c);
wait c;
}

trap13()
{
kyvadlo1 = getent( "t13_kill1" , "targetname" );
kyvadlo2 = getent( "t13_kill2" , "targetname" );
kyvadlo3 = getent( "t13_kill3" , "targetname" );
t13 = getent ("t13" , "targetname");

t13 waittill ("trigger");
t13 delete ();


kyvadlo1 rotatePitch( -20, 0.6, 0.2, 0.2);
kyvadlo2 rotatePitch( 20, 0.6, 0.2, 0.2);
kyvadlo3 rotatePitch( -20, 0.6, 0.2, 0.2);
wait 0.6;
        while( 1 )
	{
		kyvadlo1 rotatePitch( 40, 1.2, 0.4, 0.4  );
		kyvadlo2 rotatePitch( -40, 1.2, 0.4, 0.4  );
		kyvadlo3 rotatePitch( 40, 1.2, 0.4, 0.4  );
		wait 1.2;
		kyvadlo1 rotatePitch( -40, 1.2, 0.4, 0.4 );
		kyvadlo2 rotatePitch( 40, 1.2, 0.4, 0.4  );
		kyvadlo3 rotatePitch( -40, 1.2, 0.4, 0.4  );		
        wait 1.2;
	}

}

trap14()
{
kill = getent( "t14_kill" , "targetname" );
t14 = getent ("t14" , "targetname");

t14 waittill ("trigger");
t14 delete ();

    while( 1 )
	{
    kill rotateyaw( -180, 2, 0.4, 0.4  );
	wait 5;
	kill rotateyaw( 180, 2, 0.4, 0.4 );
    wait 5;
	}

}

trap15()
{
t15 = getent ("t15" , "targetname");
kill1 = getent ("t15_kill1" ,"targetname");
kill2 = getent ("t15_kill2" ,"targetname");
trig1 = getent ("t15_trig1" ,"targetname");
trig2 = getent ("t15_trig2" ,"targetname");

t15 waittill ("trigger");
t15 delete ();

trig1 enableLinkTo();
trig1 linkTo( kill1 );
trig2 enableLinkTo();
trig2 linkTo( kill2 );

while (1)
{
kill1 movex (360, 4);
wait 3;
kill2 movez (-184, 2);
wait 1;
kill1 movex (-360, 4);
wait 3;
kill2 movez (184, 2);
wait 1;
}
}