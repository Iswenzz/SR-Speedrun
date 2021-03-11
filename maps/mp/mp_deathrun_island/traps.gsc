/*
Map made by Sheep Wizard
youtube: http://www.youtube.com/user/paap15
xfire: paap15
*/
main()
{
     thread trap1();
	 thread trap2();
	 thread trap3();
	 thread trap4();
	 thread trap5();
	 thread trap6();
	 thread trap7();
	 thread trap8();
	 thread trap9();
	 thread trap10();
	 thread trap11();
	 
	 addTriggerToList( "trap1_trig" );
	 addTriggerToList( "trap2_trig" );
	 addTriggerToList( "trap3_trig" );
	 addTriggerToList( "trap4_trig" );
	 addTriggerToList( "trap5_trig" );
	 addTriggerToList( "trap6_trig" );
	 addTriggerToList( "trap7_trig" );
	 addTriggerToList( "trap8_trig" );
	 addTriggerToList( "trap9_trig" );
	 addTriggerToList( "trap10_trig" );
	 addTriggerToList( "trap11_trig" );
}

gettrigger(trigname, hint)
{
trig = getent(trigname, "targetname");
trig setHintString( hint );
trig waittill("trigger", player);
trig setHintString("^1Activated!");
}


addTriggerToList( name )
{
   if( !isDefined( level.trapTriggers ) )
      level.trapTriggers = [];
   level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

trap1()
{
brush = getent("brush1", "targetname");
gettrigger("trap1_trig", "^6A^7ctivate Spinning platform");
while(1)
{
brush rotateroll (360,4.5);
wait 4.5;
}
}

trap2()
{
brush = getent("brush2", "targetname");
gettrigger("trap2_trig", "^6A^7ctivate Sinking bounce");
brush movez(-140,4,2,0);
brush waittill("movedone");
wait 2;
brush movez(140,4,0,2);
brush waittill("movedone");
}

trap3()
{
brush = getent("brush3", "targetname");
brush2 = getent("brush4", "targetname");
brush3 = getent("brush5", "targetname");
brush4 = getent("brush6", "targetname");
gettrigger("trap3_trig", "^6A^7ctivate Disappearing poles");
x = randomint(3);
if(x == 0)
{
brush movez(-200,3.5,1,0);
brush3 movez(-200,3.5,1,0);
}
else if(x == 1)
{
brush2 movez(-200,3.5,1,0);
brush4 movez(-200,3.5,1,0);
}
else if(x == 2)
{
brush4 movez(-200,3.5,1,0);
}
}

trap4()
{
brush = getent("brush7", "targetname");
gettrigger("trap4_trig", "^6A^7ctivate Spinning block");
for(;;)
{
brush rotateyaw(1800,3,1,1);
wait 4;
}
}

trap5()
{
brush = getent("brush8", "targetname");
gettrigger("trap5_trig", "^6A^7ctivate Spinning bounce");
for(;;)
{
brush rotateroll(-360,3.4);
wait 3.4;
}
}

trap6()
{
brush = getent("brush9", "targetname");
kill = getent("trap6_kill", "targetname");
gettrigger("trap6_trig", "^6A^7ctivate Spinning bar");
kill enablelinkto();
kill linkto (brush);
for(;;)
{
brush rotatepitch(-360,1.5);
wait 1.5;
}
}

trap7()
{
brush = getent("brush10", "targetname");
brush2 = getent("brush11", "targetname");
brush3 = getent("brush12", "targetname");
gettrigger("trap7_trig", "^6A^7ctivate Rising platforms");
x = randomint(2);
if(x == 0)
{
brush movez (80, 2);
brush3 movez (80, 2);
}
else if(x == 1)
{
brush2 movez (80, 2);
}
}

trap8()
{
brush = getent("brush13", "targetname");
gettrigger("trap8_trig", "^6A^7ctivate Spinner");
for(;;)
{
brush rotateroll (1440,5);
brush waittill("rotatedone");
wait 3;
brush rotateroll (-1440,5);
brush waittill("rotatedone");
wait 3;
}
}

trap9()
{
brush = getent("brush14", "targetname");
brush2 = getent("brush15", "targetname");
brush3 = getent("brush16", "targetname");
gettrigger("trap9_trig", "^6A^7ctivate Sinking rocks");
for(;;)
{
brush movez (-200,3);
wait 3.2;
brush2 movez (-200,3);
brush movez (200,3);
wait 3.2;
brush3 movez (-200,3);
brush2 movez (200,3);
wait 3.2;
brush3 movez (200,3);
}
}

trap10()
{
quake = getent("quake", "targetname");
gettrigger("trap10_trig", "^6A^7ctivate Earthquake");
Earthquake( 1.2, 5, quake.origin, 400 );
}

trap11()
{
gettrigger("trap11_trig", "^6A^7ctivate Spinning crystals");
thread trap11a();
thread trap11b();
}

trap11a()
{
brush = getent("brush17", "targetname");
for(;;)
{
brush rotateyaw(360,2);
wait 2;
}
}

trap11b()
{
brush2 = getent("brush18", "targetname");
for(;;)
{
brush2 rotateyaw(-360,2);
wait 2;
}
}




















	
	