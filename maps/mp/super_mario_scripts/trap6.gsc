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

	thread trap6();

}


trap6()

{
	ljuljacka = getEnt( "ljuljacka", "targetname" );
	t6_daske = getEnt( "t6_daske", "targetname" );


	trig_t6 = getEnt( "trap6_trigger", "targetname" );
	brush1t6 = getEnt( "trap6_upitnik", "targetname" );
	brush2t6 = getEnt( "trap6_blok", "targetname" );
	brush3t6 = getEnt( "trap6_uputa", "targetname" );
	fxt6 = getent ( "t6_fx" ,"targetname" ); //origin

	fxt6_d_l = getent ( "t6_fx_daska_lijevo" ,"targetname" ); //origin
	fxt6_d_d = getent ( "t6_fx_daska_desno" ,"targetname" ); //origin


	trig_t6 waittill("trigger", other);

	trig_t6 delete();
	brush1t6 delete();
	brush3t6 delete();
	t6_daske delete();
	brush2t6 movez( -32, 0.4 );

	fx = PlayFX( level._effect["artillery_flash"], fxt6.origin );
	fxt6 PlaySound("blockhit");
	fx2 = PlayFX( level._effect["artillery_flash"], fxt6_d_l.origin );
	fx3 = PlayFX( level._effect["artillery_flash"], fxt6_d_d.origin );


	ljuljacka rotatePitch( 25, 1 );
	wait 1;

	while( 1 )
	{

	ljuljacka rotatePitch( -50, 2 );
	wait 2;
	ljuljacka rotatePitch( 50, 2 );
	wait 2;
	}

}