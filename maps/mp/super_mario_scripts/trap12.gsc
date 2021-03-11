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

	thread trap12();

}


trap12()

{

	t12_bat1 = getEnt( "t12_bat1", "targetname" );
	t12_bat2 = getEnt( "t12_bat2", "targetname" );

	trig_t12 = getEnt( "trap12_trigger", "targetname" );
	brush1t12 = getEnt( "trap12_upitnik", "targetname" );
	brush2t12 = getEnt( "trap12_blok", "targetname" );
	brush3t12 = getEnt( "trap12_uputa", "targetname" );
	fxt12 = getent ( "t12_fx" ,"targetname" ); //origin


//	t12_bat1 movex( 1104, 0.5 );
//	t12_bat2 movex( 1104, 0.5 );

	trig_t12 waittill("trigger", other);

	trig_t12 delete();
	brush1t12 delete();
	brush3t12 delete();
	brush2t12 movez( -32, 0.4 );

	fx = PlayFX( level._effect["artillery_flash"], fxt12.origin );
	fxt12 PlaySound("blockhit");

	while( 1 )
	{
	
//	t12_bat1 rotatePitch( -360, 3 );
//	t12_bat2 rotatePitch( 360, 3 );


	t12_bat1 rotatePitch( -90, 1 );
	t12_bat2 rotatePitch( 90, 1 );
	t12_bat2 playsound("sm_door");
	wait 2;
	t12_bat1 rotatePitch( -90, 1 );
	t12_bat2 rotatePitch( 90, 1 );
	t12_bat2 playsound("sm_door");
	wait 2;
	t12_bat1 rotatePitch( -90, 1 );
	t12_bat2 rotatePitch( 90, 1 );
	t12_bat2 playsound("sm_door");
	wait 2;
	t12_bat1 rotatePitch( -90, 1 );
	t12_bat2 rotatePitch( 90, 1 );
	t12_bat2 playsound("sm_door");
	wait 2;


//	wait 3;
	}


}