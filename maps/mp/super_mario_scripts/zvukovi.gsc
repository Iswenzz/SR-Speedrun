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

	thread me_mario();
	thread im_luigi();
	thread cestitam();
}


me_mario()

{

	me_mario = getent ( "me_mario" ,"targetname" ); //origin
	trigg_me_mario = getent ( "trigg_me_mario" ,"targetname" ); 

	trigg_me_mario waittill("trigger", other);

	me_mario PlaySound("me_mario");

	trigg_me_mario delete();
}

im_luigi()

{

	im_luigi = getent ( "im_luigi" ,"targetname" ); //origin
	trigg_im_luigi = getent ( "trigg_im_luigi" ,"targetname" ); 

	while( 1 )
	{
	trigg_im_luigi waittill("trigger", other);

	im_luigi PlaySound("im_luigi");
	wait 10;

//	trigg_im_luigi delete();
	}
}

cestitam()

{

	bravo_mario = getent ( "bravo_mario" ,"targetname" ); //origin
	trigg_bravo_mario = getent ( "trigg_bravo_mario" ,"targetname" ); 

	trigg_bravo_mario waittill("trigger", other);

	bravo_mario PlaySound("sm_cestitam");

	trigg_bravo_mario delete();
}