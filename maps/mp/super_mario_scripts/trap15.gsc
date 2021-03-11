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

	thread trap15();

}


trap15()

{

	t15_rupa1 = getEnt( "t15_rupa1", "targetname" );
	t15_rupa2 = getEnt( "t15_rupa2", "targetname" );
	t15_rupa3 = getEnt( "t15_rupa3", "targetname" );
	t15_rupa4 = getEnt( "t15_rupa4", "targetname" );


	burst1 = getEnt( "t15_fx1", "targetname" );
	burst2 = getEnt( "t15_fx2", "targetname" );
	burst3 = getEnt( "t15_fx3", "targetname" );
	burst4 = getEnt( "t15_fx4", "targetname" );


	exp_1 = getEnt( "exp_1", "targetname" );
	exp_2 = getEnt( "exp_2", "targetname" );
	exp_3 = getEnt( "exp_3", "targetname" );
	exp_4 = getEnt( "exp_4", "targetname" );


	trig_t15 = getEnt( "trap15_trigger", "targetname" );
	brush1t15 = getEnt( "trap15_upitnik", "targetname" );
	brush2t15 = getEnt( "trap15_blok", "targetname" );
	brush3t15 = getEnt( "trap15_uputa", "targetname" );
	fxt15 = getent ( "t15_fx" ,"targetname" ); //origin


	trig_t15 waittill("trigger", other);

	trig_t15 delete();
	brush1t15 delete();
	brush3t15 delete();
	brush2t15 movez( -32, 0.4 );

	fx = PlayFX( level._effect["artillery_flash"], fxt15.origin );
	fxt15 PlaySound("blockhit");


	wait 0.5;

	t15_rupa1 delete();
	fx1 = PlayFX( level._effect["exp_wall_cinderblock_96"], exp_1.origin );
	fx2 = PlayLoopedFX( level._effect["emb_burst_c"], 1, burst1.origin );
	fx2 PlaySound("explosion");

	wait 1;

	t15_rupa2 delete();
	fx3 = PlayFX( level._effect["exp_wall_cinderblock_96"], exp_2.origin );
	fx4 = PlayLoopedFX( level._effect["emb_burst_c"], 1, burst2.origin );
	fx4 PlaySound("explosion");

	wait 1;

	t15_rupa3 delete();
	fx5 = PlayFX( level._effect["exp_wall_cinderblock_96"], exp_3.origin );
	fx6 = PlayLoopedFX( level._effect["emb_burst_c"], 1, burst3.origin );
	fx6 PlaySound("explosion");

	wait 1;

	t15_rupa4 delete();
	fx7 = PlayFX( level._effect["exp_wall_cinderblock_96"], exp_4.origin );
	fx8 = PlayLoopedFX( level._effect["emb_burst_c"], 1, burst4.origin );
	fx8 PlaySound("explosion");

}