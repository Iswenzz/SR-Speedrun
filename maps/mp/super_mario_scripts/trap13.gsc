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

	thread trap13();

}


trap13()

{

	t13_b1 = getEnt( "t13_b1", "targetname" );
	t13_b2 = getEnt( "t13_b2", "targetname" );

	trig_t13 = getEnt( "trap13_trigger", "targetname" );
	brush1t13 = getEnt( "trap13_upitnik", "targetname" );
	brush2t13 = getEnt( "trap13_blok", "targetname" );
	brush3t13 = getEnt( "trap13_uputa", "targetname" );
	fxt13 = getent ( "t13_fx" ,"targetname" ); //origin


	trig_t13 waittill("trigger", other);

	trig_t13 delete();
	brush1t13 delete();
	brush3t13 delete();
	brush2t13 movez( -32, 0.4 );

	fx = PlayFX( level._effect["artillery_flash"], fxt13.origin );
	fxt13 PlaySound("blockhit");

	while( 1 )
	{
	
	t13_b1 rotateYaw( 360, 1 );
	t13_b2 rotateYaw( -360, 1 );
	wait 4;
	}


}