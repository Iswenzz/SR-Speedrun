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

	thread trap2();

}


trap2()

{


	brush1t2 = getEnt( "trap2_valjak1", "targetname" );
	brush2t2 = getEnt( "trap2_valjak2", "targetname" );
	brush3t2 = getEnt( "trap2_valjak3", "targetname" );

	trig_t2 = getEnt( "trap2_trigger", "targetname" );
	brush4t2 = getEnt( "trap2_upitnik", "targetname" );
	brush5t2 = getEnt( "trap2_blok", "targetname" );
	brush6t2 = getEnt( "trap2_uputa", "targetname" );
	brush7t2 = getEnt( "trap2_valjak4", "targetname" );
	
	fxt2 = getent ( "t2_fx" ,"targetname" ); //origin

	brush1t2 movez( -240, 0.2 );
	brush2t2 movez( -240, 0.2 );
	brush3t2 movez( -240, 0.2 );
	brush7t2 movez( -240, 0.2 );
	

	

}