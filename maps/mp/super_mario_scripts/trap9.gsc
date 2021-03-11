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

	thread trap9();



}


trap9()

{
	cube1 = getEnt( "cube1", "targetname" );
	cube2 = getEnt( "cube2", "targetname" );


	trig_t9 = getEnt( "trap9_trigger", "targetname" );
	brush1t9 = getEnt( "trap9_upitnik", "targetname" );
	brush2t9 = getEnt( "trap9_blok", "targetname" );
	brush3t9 = getEnt( "trap9_uputa", "targetname" );
	fxt9 = getent ( "t9_fx" ,"targetname" ); //origin


	trig_t9 waittill("trigger", other);

	trig_t9 delete();
	brush1t9 delete();
	brush3t9 delete();
	brush2t9 movez( -32, 0.4 );

	fx = PlayFX( level._effect["artillery_flash"], fxt9.origin );
	fxt9 PlaySound("blockhit");


	while( 1 )

	{

	cube1 rotatePitch( 10, 0.5 );
	cube1 PlaySound("sm_inventory");
	wait 0.5;
	cube2 rotatePitch( -10, 0.5 );
	cube2 PlaySound("sm_inventory");
	wait 0.5;
	cube1 rotatePitch( -10, 0.5 );
	cube1 PlaySound("sm_inventory");
	wait 0.5;
	cube2 rotatePitch( 10, 0.5 );
	cube2 PlaySound("sm_inventory");
	wait 0.5;
	cube1 rotatePitch( -10, 0.5 );
	cube1 PlaySound("sm_inventory");
	wait 0.5;
	cube2 rotatePitch( 10, 0.5 );
	cube2 PlaySound("sm_inventory");
	wait 0.5;
	cube1 rotatePitch( 10, 0.5 );
	cube1 PlaySound("sm_inventory");
	wait 0.5;
	cube2 rotatePitch( -10, 0.5 );
	cube2 PlaySound("sm_inventory");
	wait 0.5;


	}
}