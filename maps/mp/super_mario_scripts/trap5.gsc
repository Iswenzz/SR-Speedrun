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

	thread trap5();

}


trap5()

{

	cvijet = getEnt( "cvijet", "targetname" );


	trig_t5 = getEnt( "trap5_trigger", "targetname" );
	brush1t5 = getEnt( "trap5_upitnik", "targetname" );
	brush2t5 = getEnt( "trap5_blok", "targetname" );
	brush3t5 = getEnt( "trap5_uputa", "targetname" );
	fxt5 = getent ( "t5_fx" ,"targetname" ); //origin
	t5_fx_cvijet = getent ( "t5_fx_cvijet" ,"targetname" ); //origin


	trig_t5 waittill("trigger", other);

	trig_t5 delete();
	brush1t5 delete();
	brush3t5 delete();
	brush2t5 movez( -32, 0.4 );

	fx = PlayFX( level._effect["artillery_flash"], fxt5.origin );
	fxt5 PlaySound("blockhit");
	fx2 = PlayFX( level._effect["artillery_flash"], t5_fx_cvijet.origin );

	while( 1 )
	{

	cvijet PlaySound("sm_inventory");
	cvijet rotateYaw( 90, 0.5 );
	wait 1.5;
	cvijet PlaySound("sm_inventory");
	cvijet rotateYaw( 90, 0.5 );
	wait 1.5;
	cvijet PlaySound("sm_inventory");
	cvijet rotateYaw( 90, 0.5 );
	wait 1.5;
	cvijet PlaySound("sm_inventory");
	cvijet rotateYaw( 90, 0.5 );
	wait 1.5;

	}

}