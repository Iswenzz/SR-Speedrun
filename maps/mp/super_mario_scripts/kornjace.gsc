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

	thread kornjaca();
	thread kornjaca2();
	thread kornjaca3();
	thread kornjaca4();
	thread kornjaca5();
	thread kornjaca6();
	thread kornjaca7();
	thread kornjaca8();
	// thread kornjaca_kill();
	// thread kornjaca_kill2();
	// thread kornjaca_kill3();
	// thread kornjaca_kill4();
	// thread kornjaca_kill5();
	// thread kornjaca_kill6();
	// thread kornjaca_kill7();
	// thread kornjaca_kill8();

}


kornjaca()

{

	brush1 = getEnt( "kornjaca", "targetname" );
	killtrigger = getEnt( "kill-trig_kornjaca", "targetname" );

//	brush1 PlayLoopSound("mario_walk");

	brush1 delete();
	killtrigger delete();
}

kornjaca_kill()

{


	brush1 = getEnt( "kornjaca", "targetname" );
	kill_kornjacu = getEnt( "kill_kornjacu", "targetname" );
	fx_k1 = getent ("fx_kill" ,"targetname"); //origin
	killtrigger = getEnt( "kill-trig_kornjaca", "targetname" );

	kill_kornjacu enableLinkTo();
	kill_kornjacu linkTo( brush1 );

//	fx_k1 enableLinkTo();
	fx_k1 linkTo( kill_kornjacu );

	kill_kornjacu waittill("trigger", other);
	{
	fx = PlayFX( level._effect["artillery_flash"], fx_k1.origin );

	brush1 PlaySound("sm_turtledie");

	wait 0.2;

	brush1 delete();
	kill_kornjacu delete();
	killtrigger delete();
	fx_k1 delete();

	other braxi\_rank::giveRankXP( "jumper_died" );
	other iprintlnbold("^7You killed the turtle!");
	other iprintlnbold("^7You won ^310 ^1XP ^7points");

	}

}


kornjaca2()

{

	brush2 = getEnt( "kornjaca2", "targetname" );
	killtrigger = getEnt( "kill-trig_kornjaca2", "targetname" );

brush2 delete();
	killtrigger delete();
}

kornjaca_kill2()

{


	brush2 = getEnt( "kornjaca2", "targetname" );
	killtrigger = getEnt( "kill-trig_kornjaca2", "targetname" );
	kill_kornjacu2 = getEnt( "kill_kornjacu2", "targetname" );
	fx_k2 = getent ("fx_kill_2" ,"targetname"); //origin


	kill_kornjacu2 enableLinkTo();
	kill_kornjacu2 linkTo( brush2 );

	fx_k2 linkTo( kill_kornjacu2 );

	kill_kornjacu2 waittill("trigger", other);
	{
	fx = PlayFX( level._effect["artillery_flash"], fx_k2.origin );


	brush2 PlaySound("sm_turtledie");
	wait 0.2;
	brush2 delete();
	kill_kornjacu2 delete();
	killtrigger delete();
	fx_k2 delete();

	other braxi\_rank::giveRankXP( "jumper_died" );
	other iprintlnbold("^7You killed the turtle!");
	other iprintlnbold("^7You won ^310 ^1XP ^7points");


	}

}




kornjaca3()

{

	brush3 = getEnt( "kornjaca3", "targetname" );
	killtrigger = getEnt( "kill-trig_kornjaca3", "targetname" );

brush3 delete();
	killtrigger delete();
}

kornjaca_kill3()

{


	brush3 = getEnt( "kornjaca3", "targetname" );
	killtrigger = getEnt( "kill-trig_kornjaca3", "targetname" );
	kill_kornjacu3 = getEnt( "kill_kornjacu3", "targetname" );
	fx_k3 = getent ("fx_kill_3" ,"targetname"); //origin


	kill_kornjacu3 enableLinkTo();
	kill_kornjacu3 linkTo( brush3 );

	fx_k3 linkTo( kill_kornjacu3 );

	kill_kornjacu3 waittill("trigger", other);
	{
	fx = PlayFX( level._effect["artillery_flash"], fx_k3.origin );


	brush3 PlaySound("sm_turtledie");
	wait 0.2;
	brush3 delete();
	kill_kornjacu3 delete();
	killtrigger delete();
	fx_k3 delete();

	other braxi\_rank::giveRankXP( "jumper_died" );
	other iprintlnbold("^7You killed the turtle!");
	other iprintlnbold("^7You won ^310 ^1XP ^7points");


	}

}



kornjaca4()

{

	brush4 = getEnt( "kornjaca4", "targetname" );
	killtrigger = getEnt( "kill-trig_kornjaca4", "targetname" );

brush4 delete();
	killtrigger delete();
}

kornjaca_kill4()

{


	brush4 = getEnt( "kornjaca4", "targetname" );
	killtrigger = getEnt( "kill-trig_kornjaca4", "targetname" );
	kill_kornjacu4 = getEnt( "kill_kornjacu4", "targetname" );
	fx_k4 = getent ("fx_kill_4" ,"targetname"); //origin


	kill_kornjacu4 enableLinkTo();
	kill_kornjacu4 linkTo( brush4 );

	fx_k4 linkTo( kill_kornjacu4 );

	kill_kornjacu4 waittill("trigger", other);
	{
	fx = PlayFX( level._effect["artillery_flash"], fx_k4.origin );


	brush4 PlaySound("sm_turtledie");
	wait 0.2;
	brush4 delete();
	kill_kornjacu4 delete();
	killtrigger delete();
	fx_k4 delete();

	other braxi\_rank::giveRankXP( "jumper_died" );
	other iprintlnbold("^7You killed the turtle!");
	other iprintlnbold("^7You won ^310 ^1XP ^7points");


	}

}



kornjaca5()

{

	brush5 = getEnt( "kornjaca5", "targetname" );
	killtrigger = getEnt( "kill-trig_kornjaca5", "targetname" );

brush5 delete();
	killtrigger delete();
}

kornjaca_kill5()

{


	brush5 = getEnt( "kornjaca5", "targetname" );
	killtrigger = getEnt( "kill-trig_kornjaca5", "targetname" );
	kill_kornjacu5 = getEnt( "kill_kornjacu5", "targetname" );
	fx_k5 = getent ("fx_kill_5" ,"targetname"); //origin


	kill_kornjacu5 enableLinkTo();
	kill_kornjacu5 linkTo( brush5 );

	fx_k5 linkTo( kill_kornjacu5 );

	kill_kornjacu5 waittill("trigger", other);
	{
	fx = PlayFX( level._effect["artillery_flash"], fx_k5.origin );


	brush5 PlaySound("sm_turtledie");
	wait 0.2;
	brush5 delete();
	kill_kornjacu5 delete();
	killtrigger delete();
	fx_k5 delete();

	other braxi\_rank::giveRankXP( "jumper_died" );
	other iprintlnbold("^7You killed the turtle!");
	other iprintlnbold("^7You won ^310 ^1XP ^7points");


	}

}



kornjaca6()

{

	brush6 = getEnt( "kornjaca6", "targetname" );
	killtrigger = getEnt( "kill-trig_kornjaca6", "targetname" );

brush6 delete();
	killtrigger delete();
}


kornjaca_kill6()

{


	brush6 = getEnt( "kornjaca6", "targetname" );
	killtrigger = getEnt( "kill-trig_kornjaca6", "targetname" );
	kill_kornjacu6 = getEnt( "kill_kornjacu6", "targetname" );
	fx_k6 = getent ("fx_kill_6" ,"targetname"); //origin


	kill_kornjacu6 enableLinkTo();
	kill_kornjacu6 linkTo( brush6 );

	fx_k6 linkTo( kill_kornjacu6 );

	kill_kornjacu6 waittill("trigger", other);
	{
	fx = PlayFX( level._effect["artillery_flash"], fx_k6.origin );


	brush6 PlaySound("sm_turtledie");
	wait 0.2;
	brush6 delete();
	kill_kornjacu6 delete();
	killtrigger delete();
	fx_k6 delete();

	other braxi\_rank::giveRankXP( "jumper_died" );
	other iprintlnbold("^7You killed the turtle!");
	other iprintlnbold("^7You won ^310 ^1XP ^7points");


	}

}

kornjaca7()

{

	brush7 = getEnt( "kornjaca7", "targetname" );
	killtrigger = getEnt( "kill-trig_kornjaca7", "targetname" );


brush7 delete();
	killtrigger delete();
}


kornjaca_kill7()

{


	brush7 = getEnt( "kornjaca7", "targetname" );
	killtrigger = getEnt( "kill-trig_kornjaca7", "targetname" );
	kill_kornjacu7 = getEnt( "kill_kornjacu7", "targetname" );
	fx_k7 = getent ("fx_kill_7" ,"targetname"); //origin


	kill_kornjacu7 enableLinkTo();
	kill_kornjacu7 linkTo( brush7 );

	fx_k7 linkTo( kill_kornjacu7 );

	kill_kornjacu7 waittill("trigger", other);
	{
	fx = PlayFX( level._effect["artillery_flash"], fx_k7.origin );


	brush7 PlaySound("sm_turtledie");
	wait 0.2;
	brush7 delete();
	kill_kornjacu7 delete();
	killtrigger delete();
	fx_k7 delete();

	other braxi\_rank::giveRankXP( "jumper_died" );
	other iprintlnbold("^7You killed the turtle!");
	other iprintlnbold("^7You won ^310 ^1XP ^7points");


	}

}


kornjaca8()

{

	brush8 = getEnt( "kornjaca8", "targetname" );
	killtrigger = getEnt( "kill-trig_kornjaca8", "targetname" );


brush8 delete();
	killtrigger delete();
}


kornjaca_kill8()

{


	brush8 = getEnt( "kornjaca8", "targetname" );
	killtrigger = getEnt( "kill-trig_kornjaca8", "targetname" );
	kill_kornjacu8 = getEnt( "kill_kornjacu8", "targetname" );
	fx_k8 = getent ("fx_kill_8" ,"targetname"); //origin


	kill_kornjacu8 enableLinkTo();
	kill_kornjacu8 linkTo( brush8 );

	fx_k8 linkTo( kill_kornjacu8 );

	kill_kornjacu8 waittill("trigger", other);
	{
	fx = PlayFX( level._effect["artillery_flash"], fx_k8.origin );


	brush8 PlaySound("sm_turtledie");
	wait 0.2;
	brush8 delete();
	kill_kornjacu8 delete();
	killtrigger delete();
	fx_k8 delete();

	other braxi\_rank::giveRankXP( "jumper_died" );
	other iprintlnbold("^7You killed the turtle!");
	other iprintlnbold("^7You won ^310 ^1XP ^7points");


	}

}										