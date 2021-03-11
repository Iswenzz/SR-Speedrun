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

	thread trap3();
	thread g1();
	thread g2();
	thread g3();
	thread g4();
	thread g5();
	thread g6();
	thread g7();
	thread g8();
	thread g9();
	thread g10();
	thread g11();
	thread g12();
	thread g13();
	thread g14();
	thread g15();

}


trap3()

{


	ventilator1 = getEnt( "ventilator1", "targetname" );
	ventilator2 = getEnt( "ventilator2", "targetname" );
	ventilator3 = getEnt( "ventilator3", "targetname" );
	ventilator4 = getEnt( "ventilator4", "targetname" );
	ventilator5 = getEnt( "ventilator5", "targetname" );
	ventilator6 = getEnt( "ventilator6", "targetname" );
	ventilator7 = getEnt( "ventilator7", "targetname" );
	ventilator8 = getEnt( "ventilator8", "targetname" );
	kugla1 = getEnt( "kugla1", "targetname" );
	kugla2 = getEnt( "kugla2", "targetname" );
	kugla3 = getEnt( "kugla3", "targetname" );
	kugla4 = getEnt( "kugla4", "targetname" );


	trig_t3 = getEnt( "trap3_trigger", "targetname" );
	brush1t3 = getEnt( "trap3_upitnik", "targetname" );
	brush2t3 = getEnt( "trap3_blok", "targetname" );
	brush3t3 = getEnt( "trap3_uputa", "targetname" );
	fxt3 = getent ( "t3_fx" ,"targetname" ); //origin

	killtrigger1_t3 = getEnt( "kill-trig1_t3", "targetname" );
	killtrigger2_t3 = getEnt( "kill-trig2_t3", "targetname" );
	killtrigger3_t3 = getEnt( "kill-trig3_t3", "targetname" );
	killtrigger4_t3 = getEnt( "kill-trig4_t3", "targetname" );


	trig_t3 waittill("trigger", other);

	trig_t3 delete();
	brush1t3 delete();
	brush3t3 delete();
	brush2t3 movez( -32, 0.4 );

	fx = PlayFX( level._effect["artillery_flash"], fxt3.origin );
	fxt3 PlaySound("blockhit");




	while( 1 )
	{

	killtrigger1_t3 enableLinkTo();
	killtrigger1_t3 linkTo( kugla1 );

	killtrigger2_t3 enableLinkTo();
	killtrigger2_t3 linkTo( kugla2 );

	killtrigger3_t3 enableLinkTo();
	killtrigger3_t3 linkTo( kugla3 );

	killtrigger4_t3 enableLinkTo();
	killtrigger4_t3 linkTo( kugla4 );


	kugla2 PlaySound("flagpole");
	ventilator1 rotateRoll( 720, 1 );
	kugla1 movex( -400, 1 );
	ventilator4 rotateRoll( 720, 1 );
	kugla2 movex( 400, 1 );
	ventilator5 rotateRoll( 720, 1 );
	kugla3 movex( -400, 1 );
	ventilator8 rotateRoll( 720, 1 );
	kugla4 movex( 400, 1 );
	wait 1.5;
	kugla2 PlaySound("flagpole");
	ventilator2 rotateRoll( 720, 1 );
	kugla1 movex( 400, 1 );
	ventilator3 rotateRoll( 720, 1 );
	kugla2 movex( -400, 1 );
	ventilator6 rotateRoll( 720, 1 );
	kugla3 movex( 400, 1 );
	ventilator7 rotateRoll( 720, 1 );
	kugla4 movex( -400, 1 );
	wait 1.5;

	}

}



g1()

{

	g1 = getEnt( "g1", "targetname" );
	trigg_g1 = getEnt( "trigg_g1", "targetname" );


	while( 1 )
	{
	trigg_g1 waittill("trigger", other);

	g1 PlaySound("sm_jump");
	g1 movez( -16, 0.2 );
	wait 0.5;
	g1 movez( 16, 0.2 );
	g1 waittill ("movedone");

	}

}


g2()

{

	g2 = getEnt( "g2", "targetname" );
	trigg_g2 = getEnt( "trigg_g2", "targetname" );


	while( 1 )
	{
	trigg_g2 waittill("trigger", other);

	g2 PlaySound("sm_jump");
	g2 movez( -16, 0.2 );
	wait 0.5;
	g2 movez( 16, 0.2 );
	g2 waittill ("movedone");

	}

}

g3()

{

	g3 = getEnt( "g3", "targetname" );
	trigg_g3 = getEnt( "trigg_g3", "targetname" );


	while( 1 )
	{
	trigg_g3 waittill("trigger", other);

	g3 PlaySound("sm_jump");
	g3 movez( -16, 0.2 );
	wait 0.5;
	g3 movez( 16, 0.2 );
	g3 waittill ("movedone");

	}

}

g4()

{

	g4 = getEnt( "g4", "targetname" );
	trigg_g4 = getEnt( "trigg_g4", "targetname" );


	while( 1 )
	{
	trigg_g4 waittill("trigger", other);

	g4 PlaySound("sm_jump");
	g4 movez( -16, 0.2 );
	wait 0.5;
	g4 movez( 16, 0.2 );
	g4 waittill ("movedone");

	}

}

g5()

{

	g5 = getEnt( "g5", "targetname" );
	trigg_g5 = getEnt( "trigg_g5", "targetname" );


	while( 1 )
	{
	trigg_g5 waittill("trigger", other);

	g5 PlaySound("sm_jump");
	g5 movez( -16, 0.2 );
	wait 0.5;
	g5 movez( 16, 0.2 );
	g5 waittill ("movedone");

	}

}

g6()

{

	g6 = getEnt( "g6", "targetname" );
	trigg_g6 = getEnt( "trigg_g6", "targetname" );


	while( 1 )
	{
	trigg_g6 waittill("trigger", other);

	g6 PlaySound("sm_jump");
	g6 movez( -16, 0.2 );
	wait 0.5;
	g6 movez( 16, 0.2 );
	g6 waittill ("movedone");

	}

}

g7()

{

	g7 = getEnt( "g7", "targetname" );
	trigg_g7 = getEnt( "trigg_g7", "targetname" );


	while( 1 )
	{
	trigg_g7 waittill("trigger", other);

	g7 PlaySound("sm_jump");
	g7 movez( -16, 0.2 );
	wait 0.5;
	g7 movez( 16, 0.2 );
	g7 waittill ("movedone");

	}

}

g8()

{

	g8 = getEnt( "g8", "targetname" );
	trigg_g8 = getEnt( "trigg_g8", "targetname" );


	while( 1 )
	{
	trigg_g8 waittill("trigger", other);

	g8 PlaySound("sm_jump");
	g8 movez( -16, 0.2 );
	wait 0.5;
	g8 movez( 16, 0.2 );
	g8 waittill ("movedone");

	}

}

g9()

{

	g9 = getEnt( "g9", "targetname" );
	trigg_g9 = getEnt( "trigg_g9", "targetname" );


	while( 1 )
	{
	trigg_g9 waittill("trigger", other);

	g9 PlaySound("sm_jump");
	g9 movez( -16, 0.2 );
	wait 0.5;
	g9 movez( 16, 0.2 );
	g9 waittill ("movedone");

	}

}

g10()

{

	g10 = getEnt( "g10", "targetname" );
	trigg_g10 = getEnt( "trigg_g10", "targetname" );


	while( 1 )
	{
	trigg_g10 waittill("trigger", other);

	g10 PlaySound("sm_jump");
	g10 movez( -16, 0.2 );
	wait 0.5;
	g10 movez( 16, 0.2 );
	g10 waittill ("movedone");

	}

}

g11()

{

	g11 = getEnt( "g11", "targetname" );
	trigg_g11 = getEnt( "trigg_g11", "targetname" );


	while( 1 )
	{
	trigg_g11 waittill("trigger", other);

	g11 PlaySound("sm_jump");
	g11 movez( -16, 0.2 );
	wait 0.5;
	g11 movez( 16, 0.2 );
	g11 waittill ("movedone");

	}

}

g12()

{

	g12 = getEnt( "g12", "targetname" );
	trigg_g12 = getEnt( "trigg_g12", "targetname" );


	while( 1 )
	{
	trigg_g12 waittill("trigger", other);

	g12 PlaySound("sm_jump");
	g12 movez( -16, 0.2 );
	wait 0.5;
	g12 movez( 16, 0.2 );
	g12 waittill ("movedone");

	}

}

g13()

{

	g13 = getEnt( "g13", "targetname" );
	trigg_g13 = getEnt( "trigg_g13", "targetname" );


	while( 1 )
	{
	trigg_g13 waittill("trigger", other);

	g13 PlaySound("sm_jump");
	g13 movez( -16, 0.2 );
	wait 0.5;
	g13 movez( 16, 0.2 );
	g13 waittill ("movedone");

	}

}

g14()

{

	g14 = getEnt( "g14", "targetname" );
	trigg_g14 = getEnt( "trigg_g14", "targetname" );


	while( 1 )
	{
	trigg_g14 waittill("trigger", other);

	g14 PlaySound("sm_jump");
	g14 movez( -16, 0.2 );
	wait 0.5;
	g14 movez( 16, 0.2 );
	g14 waittill ("movedone");

	}

}

g15()

{

	g15 = getEnt( "g15", "targetname" );
	trigg_g15 = getEnt( "trigg_g15", "targetname" );


	while( 1 )
	{
	trigg_g15 waittill("trigger", other);

	g15 PlaySound("sm_jump");
	g15 movez( -16, 0.2 );
	wait 0.5;
	g15 movez( 16, 0.2 );
	g15 waittill ("movedone");

	}

}