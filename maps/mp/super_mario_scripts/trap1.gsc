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

	thread trap1();


}


trap1()

{
	trig_t1 = getEnt( "trap1_trigger", "targetname" );
	brushGroup1 = getEntArray( "trap1_brush1", "targetname" );
	brushGroup2 = getEntArray( "trap1_brush2", "targetname" );
	brush3t1 = getEnt( "trap1_upitnik", "targetname" );
	brush4t1 = getEnt( "trap1_blok", "targetname" );
	brush5t1 = getEnt( "trap1_uputa", "targetname" );
	brush6t1 = getEnt( "upitnik_t1", "targetname" );
	fxt1 = getent ( "t1_fx" ,"targetname" ); //origin
	fxt1_2 = getent ( "t1_fx2" ,"targetname" ); //origin
	fxt1_3 = getent ( "t1_fx3" ,"targetname" ); //origin
	fxt1_4 = getent ( "t1_fx4" ,"targetname" ); //origin
	fxt1_5 = getent ( "t1_fx5" ,"targetname" ); //origin
	
	brush6t1 hide();




}