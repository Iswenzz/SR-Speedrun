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

	thread trap4();

	// thread biljke_uz_mapu();

}


trap4()

{

	plant1 = getEnt( "plant1", "targetname" );
	plant2 = getEnt( "plant2", "targetname" );
	plant3 = getEnt( "plant3", "targetname" );
	plant4 = getEnt( "plant4", "targetname" );
	plant5 = getEnt( "plant5", "targetname" );
	plant6 = getEnt( "plant6", "targetname" );
	plant12 = getEnt( "plant12", "targetname" );
	plant13 = getEnt( "plant13", "targetname" );
	plant14 = getEnt( "plant14", "targetname" );
	plant15 = getEnt( "plant15", "targetname" );
	plant16 = getEnt( "plant16", "targetname" );
	plant17 = getEnt( "plant17", "targetname" );

	trig_t4 = getEnt( "trap4_trigger", "targetname" );
	brush1t4 = getEnt( "trap4_upitnik", "targetname" );
	brush2t4 = getEnt( "trap4_blok", "targetname" );
	brush3t4 = getEnt( "trap4_uputa", "targetname" );
	fxt4 = getent ( "t4_fx" ,"targetname" ); //origin

	killtrigger1_t4 = getEnt( "kill-trig_plant1", "targetname" );
	killtrigger2_t4 = getEnt( "kill-trig_plant2", "targetname" );
	killtrigger3_t4 = getEnt( "kill-trig_plant3", "targetname" );
	killtrigger4_t4 = getEnt( "kill-trig_plant4", "targetname" );
	killtrigger5_t4 = getEnt( "kill-trig_plant5", "targetname" );
	killtrigger6_t4 = getEnt( "kill-trig_plant6", "targetname" );
	killtrigger12_t4 = getEnt( "kill-trig_plant12", "targetname" );
	killtrigger13_t4 = getEnt( "kill-trig_plant13", "targetname" );
	killtrigger14_t4 = getEnt( "kill-trig_plant14", "targetname" );
	killtrigger15_t4 = getEnt( "kill-trig_plant15", "targetname" );
	killtrigger16_t4 = getEnt( "kill-trig_plant16", "targetname" );
	killtrigger17_t4 = getEnt( "kill-trig_plant17", "targetname" );

	killtrigger1_t4 enableLinkTo();
	killtrigger1_t4 linkTo( plant1 );

	killtrigger2_t4 enableLinkTo();
	killtrigger2_t4 linkTo( plant2 );

	killtrigger3_t4 enableLinkTo();
	killtrigger3_t4 linkTo( plant3 );

	killtrigger4_t4 enableLinkTo();
	killtrigger4_t4 linkTo( plant4 );

	killtrigger5_t4 enableLinkTo();
	killtrigger5_t4 linkTo( plant5 );

	killtrigger6_t4 enableLinkTo();
	killtrigger6_t4 linkTo( plant6 );

	killtrigger12_t4 enableLinkTo();
	killtrigger12_t4 linkTo( plant12 );

	killtrigger13_t4 enableLinkTo();
	killtrigger13_t4 linkTo( plant13 );

	killtrigger14_t4 enableLinkTo();
	killtrigger14_t4 linkTo( plant14 );

	killtrigger15_t4 enableLinkTo();
	killtrigger15_t4 linkTo( plant15 );

	killtrigger16_t4 enableLinkTo();
	killtrigger16_t4 linkTo( plant16 );

	killtrigger17_t4 enableLinkTo();
	killtrigger17_t4 linkTo( plant17 );


	plant1 movez( -100, 0.2 );
	plant2 movez( -100, 0.2 );
	plant3 movez( -100, 0.2 );
	plant4 movez( -100, 0.2 );
	plant5 movez( -100, 0.2 );
	plant6 movez( -100, 0.2 );
	plant12 movez( -100, 0.2 );
	plant13 movez( -100, 0.2 );
	plant14 movez( -100, 0.2 );
	plant15 movez( -100, 0.2 );
	plant16 movez( -100, 0.2 );
	plant17 movez( -100, 0.2 );


}



biljke_uz_mapu()


{
	plant7 = getEnt( "plant7", "targetname" );
	plant8 = getEnt( "plant8", "targetname" );
	plant9 = getEnt( "plant9", "targetname" );
	plant10 = getEnt( "plant10", "targetname" );
	plant11 = getEnt( "plant11", "targetname" );

	trig_plant7 = getEnt( "kill-trig_plant7", "targetname" );
	trig_plant8 = getEnt( "kill-trig_plant8", "targetname" );
	trig_plant9 = getEnt( "kill-trig_plant9", "targetname" );
	trig_plant10 = getEnt( "kill-trig_plant10", "targetname" );
	trig_plant11 = getEnt( "kill-trig_plant11", "targetname" );

	trig_plant7 enableLinkTo();
	trig_plant7 linkTo( plant7 );

	trig_plant8 enableLinkTo();
	trig_plant8 linkTo( plant8 );

	trig_plant9 enableLinkTo();
	trig_plant9 linkTo( plant9 );

	trig_plant10 enableLinkTo();
	trig_plant10 linkTo( plant10 );

	trig_plant11 enableLinkTo();
	trig_plant11 linkTo( plant11 );


	plant7 movez( -120, 0.5 );
	plant8 movez( -120, 0.5 );
	plant9 movez( -120, 0.5 );
	plant10 movez( -120, 0.5 );
	plant11 movez( -120, 0.5 );

	wait 2;

	while( 1 )
	{

	plant7 movez( 100, 0.5 );
	plant9 movez( 100, 0.5 );
	plant11 movez( 100, 0.5 );

	wait 2;

	plant7 movez( -100, 0.5 );
	plant9 movez( -100, 0.5 );
	plant11 movez( -100, 0.5 );

	plant8 movez( 100, 0.5 );
	plant10 movez( 100, 0.5 );

	wait 2;

	plant8 movez( -100, 0.5 );
	plant10 movez( -100, 0.5 );

	}

}