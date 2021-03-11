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

	thread trap8();
	// thread star1_t8();
	// thread star2_t8();
	// thread star3_t8();
	// thread star4_t8();
	// thread star5_t8();
	// thread star6_t8();
	// thread star7_t8();
	// thread star8_t8();
	// thread star9_t8();
	// thread star10_t8();
	// thread star11_t8();
	// thread star12_t8();


}


trap8()

{
	cekic1 = getEnt( "cekic1", "targetname" );
	cekic2 = getEnt( "cekic2", "targetname" );

	star_sound_brush = getEnt( "star_sound_brush", "targetname" );
	star_sound_brush PlayLoopSound("sm_star");
	star_sound_brush hide();

	trig_t8 = getEnt( "trap8_trigger", "targetname" );
	brush1t8 = getEnt( "trap8_upitnik", "targetname" );
	brush2t8 = getEnt( "trap8_blok", "targetname" );
	brush3t8 = getEnt( "trap8_uputa", "targetname" );
	fxt8 = getent ( "t8_fx" ,"targetname" ); //origin

	cekic1 rotateRoll( 50, 1 );
	cekic2 rotateRoll( -50, 1 );

	

}


star1_t8()

{

	star1_t8 = getEnt( "star1_t8", "targetname" );
	trig_s1_t8 = getEnt( "trig_s1_t8", "targetname" );

	while( 1 )
	{
	trig_s1_t8 waittill("trigger", other);

	star1_t8 PlaySound("sm_jump");

	trig_s1_t8 movez( -200, 0.1 );

	star1_t8 movey( 8, 0.2 );
	wait 0.2;
	star1_t8 movey( -16, 0.4 );
	wait 0.4;
	star1_t8 movey( 16, 0.4 );
	wait 0.4;
	star1_t8 movey( -16, 0.4 );
	wait 0.4;
	star1_t8 movey( 16, 0.4 );
	wait 0.4;
	star1_t8 movey( -16, 0.4 );
	wait 0.4;
	star1_t8 movey( 8, 0.2 );
	wait 0.2;
	star1_t8 movez( -120, 1 );
	wait 1.1;
	star1_t8 movez( 120, 1 );
	wait 1;
	trig_s1_t8 movez( 200, 0.1 );

	}
}


star2_t8()

{

	star2_t8 = getEnt( "star2_t8", "targetname" );
	trig_s2_t8 = getEnt( "trig_s2_t8", "targetname" );

	while( 1 )
	{
	trig_s2_t8 waittill("trigger", other);

	star2_t8 PlaySound("sm_jump");

	trig_s2_t8 movez( -200, 0.1 );

	star2_t8 movey( 8, 0.2 );
	wait 0.2;
	star2_t8 movey( -16, 0.4 );
	wait 0.4;
	star2_t8 movey( 16, 0.4 );
	wait 0.4;
	star2_t8 movey( -16, 0.4 );
	wait 0.4;
	star2_t8 movey( 16, 0.4 );
	wait 0.4;
	star2_t8 movey( -16, 0.4 );
	wait 0.4;
	star2_t8 movey( 8, 0.2 );
	wait 0.2;
	star2_t8 movez( -120, 1 );
	wait 1.1;
	star2_t8 movez( 120, 1 );
	wait 1;
	trig_s2_t8 movez( 200, 0.1 );

	}
}

star3_t8()

{

	star3_t8 = getEnt( "star3_t8", "targetname" );
	trig_s3_t8 = getEnt( "trig_s3_t8", "targetname" );

	while( 1 )
	{
	trig_s3_t8 waittill("trigger", other);

	star3_t8 PlaySound("sm_jump");

	trig_s3_t8 movez( -200, 0.1 );

	star3_t8 movey( 8, 0.2 );
	wait 0.2;
	star3_t8 movey( -16, 0.4 );
	wait 0.4;
	star3_t8 movey( 16, 0.4 );
	wait 0.4;
	star3_t8 movey( -16, 0.4 );
	wait 0.4;
	star3_t8 movey( 16, 0.4 );
	wait 0.4;
	star3_t8 movey( -16, 0.4 );
	wait 0.4;
	star3_t8 movey( 8, 0.2 );
	wait 0.2;
	star3_t8 movez( -120, 1 );
	wait 1.1;
	star3_t8 movez( 120, 1 );
	wait 1;
	trig_s3_t8 movez( 200, 0.1 );

	}
}

star4_t8()

{

	star4_t8 = getEnt( "star4_t8", "targetname" );
	trig_s4_t8 = getEnt( "trig_s4_t8", "targetname" );


	while( 1 )
	{
	trig_s4_t8 waittill("trigger", other);

	star4_t8 PlaySound("sm_jump");

	trig_s4_t8 movez( -200, 0.1 );

	star4_t8 movey( 8, 0.2 );
	wait 0.2;
	star4_t8 movey( -16, 0.4 );
	wait 0.4;
	star4_t8 movey( 16, 0.4 );
	wait 0.4;
	star4_t8 movey( -16, 0.4 );
	wait 0.4;
	star4_t8 movey( 16, 0.4 );
	wait 0.4;
	star4_t8 movey( -16, 0.4 );
	wait 0.4;
	star4_t8 movey( 8, 0.2 );
	wait 0.2;
	star4_t8 movez( -120, 1 );
	wait 1.1;
	star4_t8 movez( 120, 1 );
	wait 1;
	trig_s4_t8 movez( 200, 0.1 );

	}
}

star5_t8()

{

	star5_t8 = getEnt( "star5_t8", "targetname" );
	trig_s5_t8 = getEnt( "trig_s5_t8", "targetname" );

	while( 1 )
	{
	trig_s5_t8 waittill("trigger", other);

	star5_t8 PlaySound("sm_jump");

	trig_s5_t8 movez( -200, 0.1 );

	star5_t8 movey( 8, 0.2 );
	wait 0.2;
	star5_t8 movey( -16, 0.4 );
	wait 0.4;
	star5_t8 movey( 16, 0.4 );
	wait 0.4;
	star5_t8 movey( -16, 0.4 );
	wait 0.4;
	star5_t8 movey( 16, 0.4 );
	wait 0.4;
	star5_t8 movey( -16, 0.4 );
	wait 0.4;
	star5_t8 movey( 8, 0.2 );
	wait 0.2;
	star5_t8 movez( -120, 1 );
	wait 1.1;
	star5_t8 movez( 120, 1 );
	wait 1;
	trig_s5_t8 movez( 200, 0.1 );

	}
}


star6_t8()

{

	star6_t8 = getEnt( "star6_t8", "targetname" );
	trig_s6_t8 = getEnt( "trig_s6_t8", "targetname" );

	while( 1 )
	{
	trig_s6_t8 waittill("trigger", other);

	star6_t8 PlaySound("sm_jump");

	trig_s6_t8 movez( -200, 0.1 );

	star6_t8 movey( 8, 0.2 );
	wait 0.2;
	star6_t8 movey( -16, 0.4 );
	wait 0.4;
	star6_t8 movey( 16, 0.4 );
	wait 0.4;
	star6_t8 movey( -16, 0.4 );
	wait 0.4;
	star6_t8 movey( 16, 0.4 );
	wait 0.4;
	star6_t8 movey( -16, 0.4 );
	wait 0.4;
	star6_t8 movey( 8, 0.2 );
	wait 0.2;
	star6_t8 movez( -120, 1 );
	wait 1.1;
	star6_t8 movez( 120, 1 );
	wait 1;
	trig_s6_t8 movez( 200, 0.1 );

	}
}

star7_t8()

{

	star7_t8 = getEnt( "star7_t8", "targetname" );
	trig_s7_t8 = getEnt( "trig_s7_t8", "targetname" );

	while( 1 )
	{
	trig_s7_t8 waittill("trigger", other);

	star7_t8 PlaySound("sm_jump");

	trig_s7_t8 movez( -200, 0.1 );

	star7_t8 movey( 8, 0.2 );
	wait 0.2;
	star7_t8 movey( -16, 0.4 );
	wait 0.4;
	star7_t8 movey( 16, 0.4 );
	wait 0.4;
	star7_t8 movey( -16, 0.4 );
	wait 0.4;
	star7_t8 movey( 16, 0.4 );
	wait 0.4;
	star7_t8 movey( -16, 0.4 );
	wait 0.4;
	star7_t8 movey( 8, 0.2 );
	wait 0.2;
	star7_t8 movez( -120, 1 );
	wait 1.1;
	star7_t8 movez( 120, 1 );
	wait 1;
	trig_s7_t8 movez( 200, 0.1 );

	}
}

star8_t8()

{

	star8_t8 = getEnt( "star8_t8", "targetname" );
	trig_s8_t8 = getEnt( "trig_s8_t8", "targetname" );

	while( 1 )
	{
	trig_s8_t8 waittill("trigger", other);

	star8_t8 PlaySound("sm_jump");

	trig_s8_t8 movez( -200, 0.1 );

	star8_t8 movey( 8, 0.2 );
	wait 0.2;
	star8_t8 movey( -16, 0.4 );
	wait 0.4;
	star8_t8 movey( 16, 0.4 );
	wait 0.4;
	star8_t8 movey( -16, 0.4 );
	wait 0.4;
	star8_t8 movey( 16, 0.4 );
	wait 0.4;
	star8_t8 movey( -16, 0.4 );
	wait 0.4;
	star8_t8 movey( 8, 0.2 );
	wait 0.2;
	star8_t8 movez( -120, 1 );
	wait 1.1;
	star8_t8 movez( 120, 1 );
	wait 1;
	trig_s8_t8 movez( 200, 0.1 );

	}
}

star9_t8()

{

	star9_t8 = getEnt( "star9_t8", "targetname" );
	trig_s9_t8 = getEnt( "trig_s9_t8", "targetname" );

	while( 1 )
	{
	trig_s9_t8 waittill("trigger", other);

	star9_t8 PlaySound("sm_jump");

	trig_s9_t8 movez( -200, 0.1 );

	star9_t8 movey( 8, 0.2 );
	wait 0.2;
	star9_t8 movey( -16, 0.4 );
	wait 0.4;
	star9_t8 movey( 16, 0.4 );
	wait 0.4;
	star9_t8 movey( -16, 0.4 );
	wait 0.4;
	star9_t8 movey( 16, 0.4 );
	wait 0.4;
	star9_t8 movey( -16, 0.4 );
	wait 0.4;
	star9_t8 movey( 8, 0.2 );
	wait 0.2;
	star9_t8 movez( -120, 1 );
	wait 1.1;
	star9_t8 movez( 120, 1 );
	wait 1;
	trig_s9_t8 movez( 200, 0.1 );

	}
}

star10_t8()

{

	star10_t8 = getEnt( "star10_t8", "targetname" );
	trig_s10_t8 = getEnt( "trig_s10_t8", "targetname" );

	while( 1 )
	{
	trig_s10_t8 waittill("trigger", other);

	star10_t8 PlaySound("sm_jump");

	trig_s10_t8 movez( -200, 0.1 );

	star10_t8 movey( 8, 0.2 );
	wait 0.2;
	star10_t8 movey( -16, 0.4 );
	wait 0.4;
	star10_t8 movey( 16, 0.4 );
	wait 0.4;
	star10_t8 movey( -16, 0.4 );
	wait 0.4;
	star10_t8 movey( 16, 0.4 );
	wait 0.4;
	star10_t8 movey( -16, 0.4 );
	wait 0.4;
	star10_t8 movey( 8, 0.2 );
	wait 0.2;
	star10_t8 movez( -120, 1 );
	wait 1.1;
	star10_t8 movez( 120, 1 );
	wait 1;
	trig_s10_t8 movez( 200, 0.1 );

	}
}

star11_t8()

{

	star11_t8 = getEnt( "star11_t8", "targetname" );
	trig_s11_t8 = getEnt( "trig_s11_t8", "targetname" );


	while( 1 )
	{
	trig_s11_t8 waittill("trigger", other);

	star11_t8 PlaySound("sm_jump");

	trig_s11_t8 movez( -200, 0.1 );

	star11_t8 movey( 8, 0.2 );
	wait 0.2;
	star11_t8 movey( -16, 0.4 );
	wait 0.4;
	star11_t8 movey( 16, 0.4 );
	wait 0.4;
	star11_t8 movey( -16, 0.4 );
	wait 0.4;
	star11_t8 movey( 16, 0.4 );
	wait 0.4;
	star11_t8 movey( -16, 0.4 );
	wait 0.4;
	star11_t8 movey( 8, 0.2 );
	wait 0.2;
	star11_t8 movez( -120, 1 );
	wait 1.1;
	star11_t8 movez( 120, 1 );
	wait 1;
	trig_s11_t8 movez( 200, 0.1 );

	}
}

star12_t8()

{

	star12_t8 = getEnt( "star12_t8", "targetname" );
	trig_s12_t8 = getEnt( "trig_s12_t8", "targetname" );


	while( 1 )
	{
	trig_s12_t8 waittill("trigger", other);

	star12_t8 PlaySound("sm_jump");

	trig_s12_t8 movez( -200, 0.1 );

	star12_t8 movey( 8, 0.2 );
	wait 0.2;
	star12_t8 movey( -16, 0.4 );
	wait 0.4;
	star12_t8 movey( 16, 0.4 );
	wait 0.4;
	star12_t8 movey( -16, 0.4 );
	wait 0.4;
	star12_t8 movey( 16, 0.4 );
	wait 0.4;
	star12_t8 movey( -16, 0.4 );
	wait 0.4;
	star12_t8 movey( 8, 0.2 );
	wait 0.2;
	star12_t8 movez( -120, 1 );
	wait 1.1;
	star12_t8 movez( 120, 1 );
	wait 1;
	trig_s12_t8 movez( 200, 0.1 );

	}
}