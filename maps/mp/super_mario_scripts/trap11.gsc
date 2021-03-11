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

	thread trap11();

}


trap11()

{

	t11_blok1 = getEnt( "t11_blok1", "targetname" );
	t11_blok2 = getEnt( "t11_blok2", "targetname" );

	trig_t11 = getEnt( "trap11_trigger", "targetname" );
	brush1t11 = getEnt( "trap11_upitnik", "targetname" );
	brush2t11 = getEnt( "trap11_blok", "targetname" );
	brush3t11 = getEnt( "trap11_uputa", "targetname" );
	fxt11 = getent ( "t11_fx" ,"targetname" ); //origin

	//origin_t11 = getent ( "origin_t11" ,"targetname" ); //origin

	trig_t11 waittill("trigger", other);

	trig_t11 delete();
	brush1t11 delete();
	brush3t11 delete();
	brush2t11 movez( -32, 0.4 );

	fx = PlayFX( level._effect["artillery_flash"], fxt11.origin );
	fxt11 PlaySound("blockhit");

	while( 1 )
	{
	t11_blok1 movex( 128, 2 );
	t11_blok1 movex( -128, 2 );
	t11_blok2 movex( -128, 2 );
	t11_blok2 movex( 128, 2 );

	wait 2;

	t11_blok1 movex( -128, 2 );
	t11_blok1 movex( 128, 2 );
	t11_blok2 movex( 128, 2 );
	t11_blok2 movex( -128, 2 );
	wait 2;

	t11_blok1 movex( -128, 2 );
	t11_blok1 movex( 128, 2 );
	t11_blok2 movex( 128, 2 );
	t11_blok2 movex( -128, 2 );
	wait 2;

	t11_blok1 movex( 128, 2 );
	t11_blok1 movex( -128, 2 );
	t11_blok2 movex( -128, 2 );
	t11_blok2 movex( 128, 2 );
	wait 2;
	}

}