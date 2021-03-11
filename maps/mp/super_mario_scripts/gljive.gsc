//////////////////////////////////////////////////////////////
//////////////////////map by jerkan///////////////////////////
//////////////////////////////////////////////////////////////
/////////////////////XFire: jerkan18//////////////////////////
//////////////////////////////////////////////////////////////
///////////////////e-mail: jerkan@net.hr//////////////////////
//////////////////////////////////////////////////////////////
////////////////www.jerkanmaps.weebly.com/////////////////////
//////////////////////////////////////////////////////////////

main()
{

	thread gljiva1();
	thread gljiva2();
	thread gljiva3();
	thread gljiva4();


}


gljiva1()

{

	gljiva1 = getEnt( "gljiva1", "targetname" );
	trig_g1 = getEnt( "trigg_gljiva1", "targetname" );

	while( 1 )
	{
	trig_g1 waittill("trigger", other);

	gljiva1 PlaySound("sm_turtledie");
	gljiva1 movez( -16, 0.2 );
	wait 0.5;
	gljiva1 movez( 16, 0.2 );
	gljiva1 waittill ("movedone");

	}

}

gljiva2()

{

	gljiva2 = getEnt( "gljiva2", "targetname" );
	trig_g2 = getEnt( "trigg_gljiva2", "targetname" );

	while( 1 )
	{
	trig_g2 waittill("trigger", other);

	gljiva2 PlaySound("sm_turtledie");
	gljiva2 movez( -16, 0.2 );
	wait 0.5;
	gljiva2 movez( 16, 0.2 );
	gljiva2 waittill ("movedone");

	}

}


gljiva3()

{

	gljiva3 = getEnt( "gljiva3", "targetname" );
	trig_g3 = getEnt( "trigg_gljiva3", "targetname" );

	while( 1 )
	{
	trig_g3 waittill("trigger", other);

	gljiva3 PlaySound("sm_jump");
	gljiva3 movez( -16, 0.2 );
	wait 0.5;
	gljiva3 movez( 16, 0.2 );
	gljiva3 waittill ("movedone");

	}

}


gljiva4()

{

	gljiva4 = getEnt( "gljiva4", "targetname" );
	trig_g4 = getEnt( "trigg_gljiva4", "targetname" );

	while( 1 )
	{
	trig_g4 waittill("trigger", other);

	gljiva4 PlaySound("sm_jump");
	gljiva4 movez( -16, 0.2 );
	wait 0.5;
	gljiva4 movez( 16, 0.2 );
	gljiva4 waittill ("movedone");

	}

}
