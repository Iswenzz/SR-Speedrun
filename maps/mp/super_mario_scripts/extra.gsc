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

	// thread speed();
	// thread life1();
	// thread life2();
	thread mario_skok();
	thread flag();
	// thread ambient_sound2();
	// thread jukebox();
	thread ljestve_2k();
	// thread lava();
	// thread burst();
	// thread secret1();
	// thread upitnikXP1();
	// thread upitnikXP2();
	// thread upitnikXP3();
	// thread upitnikXP4();
	// thread flagXP();
	// thread coinsXP1_rot();
	thread coinsXP1();
	// thread coinsXP2_rot();
	thread coinsXP2();
	// thread coinsXP3_rot();
	thread coinsXP3();
	// thread coinsXP4_rot();
	thread coinsXP4();
	// thread coinsXP5_rot();
	thread coinsXP5();
	// thread coinsXP6_rot();
	thread coinsXP6();
	// thread coinsXP7_rot();
	thread coinsXP7();
	// thread coinsXP8_rot();
	thread coinsXP8();
	// thread coinsXP9_rot();
	thread coinsXP9();
	// thread coinsXP10_rot();
	thread coinsXP10();
	// thread coinsXP11_rot();
	thread coinsXP11();

}


speed()

{

	star_speed = getEnt( "star_speed", "targetname" );
	upitnik_speed = getEnt( "upitnik_speed", "targetname" );
	blok_speed = getEnt( "star_speed", "targetname" );
	fx_speed = getent ( "fx_speed" ,"targetname" ); //origin
	trig_aktiv_speed = getEnt( "trig_aktiv_speed", "targetname" );
	trigg_speed = getEnt( "trigg_speed", "targetname" );

	trigg_speed enableLinkTo();
	trigg_speed linkTo( star_speed );

	star_speed movez( -32, 0.5 );

	blok_speed hide();

	trig_aktiv_speed waittill("trigger", other);
	fx = PlayFX( level._effect["artillery_flash"], fx_speed.origin );
	blok_speed PlaySound("sm_obj");

	blok_speed show();
	trig_aktiv_speed delete();
	upitnik_speed delete();

	wait 0.5;

	star_speed movez( 32, 0.5 );
	wait 0.5;

	trigg_speed waittill("trigger", user);

	user PlaySound("sm_powerup");

	trigg_speed delete();
	star_speed delete();

	user sr\api\_player::setPlayerSpeedScale( 2 );
	user iprintlnbold("^3You have a double speed in the next 60 seconds!");

	wait 0.5;

//	user PlayLoopSound("sm_star");


	wait 60;
//	user StopLoopSound();


	user sr\api\_player::setPlayerSpeedScale( 1 );
	user iprintlnbold("^3Your speed is now normal!");

}



life1()

{

	gljiva_life = getEnt( "gljiva_life1", "targetname" );
	upitnik_life = getEnt( "upitnik_life1", "targetname" );
	blok_life = getEnt( "blok_life1", "targetname" );

	trig_aktiv_life = getEnt( "trig_aktiv_life1", "targetname" );
	trigg_life = getEnt( "trigg_life1", "targetname" );

	trigg_life enableLinkTo();
	trigg_life linkTo( gljiva_life );

	gljiva_life movez( -32, 0.5 );

	blok_life hide();

	trig_aktiv_life waittill("trigger", other);

	blok_life PlaySound("sm_obj");

	blok_life show();
	trig_aktiv_life delete();
	upitnik_life delete();

	wait 0.5;

	gljiva_life movez( 32, 0.5 );
	wait 0.5;

	trigg_life waittill("trigger", player);

	player PlaySound("sm_up");

	trigg_life delete();
	gljiva_life delete();

	player braxi\_mod::giveLife();

}

life2()

{

	gljiva_life = getEnt( "gljiva_life2", "targetname" );
	upitnik_life = getEnt( "upitnik_life2", "targetname" );
	blok_life = getEnt( "blok_life2", "targetname" );

	trig_aktiv_life = getEnt( "trig_aktiv_life2", "targetname" );
	trigg_life = getEnt( "trigg_life2", "targetname" );

	trigg_life enableLinkTo();
	trigg_life linkTo( gljiva_life );

	gljiva_life movez( -32, 0.5 );

	blok_life hide();

	trig_aktiv_life waittill("trigger", other);

	blok_life PlaySound("sm_obj");

	blok_life show();
	trig_aktiv_life delete();
	upitnik_life delete();

	wait 0.5;

	gljiva_life movez( 32, 0.5 );
	wait 0.5;

	trigg_life waittill("trigger", player);

	player PlaySound("sm_up");

	trigg_life delete();
	gljiva_life delete();

	player braxi\_mod::giveLife();

}



mario_skok()

{

	mario = getEnt( "mario", "targetname" );
	oklop_m = getEnt( "oklop_m", "targetname" );
	blok_m = getEnt( "blok_m", "targetname" );
	upitnik_m = getEnt( "upitnik_m", "targetname" );
	biljka_m = getEnt( "biljka_m", "targetname" );
	aktiv_m = getEnt( "aktiv_m", "targetname" );
	fx_m = getent ( "fx_m" ,"targetname" ); //origin


	wait 0.2;

	mario delete();
	oklop_m delete();
	blok_m delete();
	// biljka_m delete();
	aktiv_m delete();
	fx_m delete();
	upitnik_m delete();

}


flag()

{

	zastava = getEnt( "zastava", "targetname" );
	zastava_clip = getEnt( "zastava_clip", "targetname" );
	most1 = getEnt( "most1", "targetname" );
	most_clip = getEnt( "most_clip", "targetname" );
	trigg_flag = getEnt( "trigg_flag", "targetname" );
	zastava_uputa = getEnt( "zastava_uputa", "targetname" );

	most1 rotateRoll( 45, 0.5 );


	level waittill("round_started");
	wait 2;

	trigg_flag delete();
	zastava_uputa delete();
	most_clip delete();
	most1 rotateRoll( -45, 2 );

	// zastava PlaySound("sm_win_flag");
	zastava movez( -224, 1.5 );
	zastava_clip movez( -224, 1.5 );

	// iprintlnbold ("^3=>^1" + player.name + "^3<= ^2has taken down the flag!");

	wait 1.5;
	zastava_clip delete();

}

flagXP()
{
	trigg_flagXP = getEnt( "trigg_flagXP", "targetname" );

	trigg_flagXP waittill("trigger", other);

	other braxi\_rank::giveRankXP( "activator" );
	other iprintlnbold("^6Perfect jump");
	other iprintlnbold("^7You won ^325 ^1XP ^7points");

}


ambient_sound2()

{

	trigg_dvorac = getEnt( "trigg_dvorac", "targetname" );

	trigg_dvorac waittill("trigger", player);

	trigg_dvorac delete();

	AmbientStop(1);
	wait 1;
	ambientPlay("mario_ambient2");

	iprintlnbold ("^3=>^1" + player.name + "^3<= ^2has entered the castle!");

}

jukebox()

{

	trigg_jukebox = getEnt( "trigg_jukebox", "targetname" );

	trigg_jukebox waittill("trigger", player);

	trigg_jukebox delete();

	AmbientStop(1);
	wait 1;
	ambientPlay("mario_ambient1");
	iprintlnbold ("^3=>^1" + player.name + "^3<= ^2has changed the ambient sound!");


}



ljestve_2k()

{

	trigg_2k = getEnt( "trigg_2k", "targetname" );
	oklop_2k = getEnt( "oklop_2k", "targetname" );
	ljestve_2k = getEnt( "ljestve_2k", "targetname" );
	fx_2k = getent ( "fx_2k" ,"targetname" ); //origin

	wait 0.2;

	ljestve_2k movez( -264, 0.5 );

	// trigg_2k waittill("trigger", player);

	oklop_2k PlaySound("smb_stomp");

	trigg_2k delete();

	oklop_2k movex( 208, 1 );

	wait 1;
	fx = PlayFX( level._effect["artillery_flash"], fx_2k.origin );
	ljestve_2k PlaySound("flag");

	ljestve_2k movez( 264, 1.5 );
	oklop_2k delete();

}


lava()

{

	trigg_lava = getEnt( "trigg_lava", "targetname" );

	while( 1 )
	{

	trigg_lava waittill("trigger", player);

	player PlaySound ("scream");

//	fx = PlayFX( level._effect["firelp_med_pm_nodistort"], player.origin );

	fx = PlayLoopedFX( level._effect["firelp_med_pm_nodistort"], 1, player.origin );

	wait 6;
	fx delete();

	}
}


burst()

{

	fx1 = getent ( "fx_b1" ,"targetname" );
	fx2 = getent ( "fx_b2" ,"targetname" );
	fx3 = getent ( "fx_b3" ,"targetname" );
	fx4 = getent ( "fx_b4" ,"targetname" );
	fx5 = getent ( "fx_b5" ,"targetname" );
	fx6 = getent ( "fx_b6" ,"targetname" );
	fx7 = getent ( "fx_b7" ,"targetname" );
	fx8 = getent ( "fx_b8" ,"targetname" );
	fx9 = getent ( "fx_b9" ,"targetname" );
	fx10 = getent ( "fx_b10" ,"targetname" );

	fx11 = getent ( "fx_f1" ,"targetname" );
	fx12 = getent ( "fx_f2" ,"targetname" );
	fx13 = getent ( "fx_f3" ,"targetname" );
	fx14 = getent ( "fx_f4" ,"targetname" );
	fx15 = getent ( "fx_f5" ,"targetname" );
	fx16 = getent ( "fx_f6" ,"targetname" );
	fx17 = getent ( "fx_f7" ,"targetname" );
	fx18 = getent ( "fx_f8" ,"targetname" );
	fx19 = getent ( "fx_f9" ,"targetname" );
	fx20 = getent ( "fx_f10" ,"targetname" );


	fx1 = PlayLoopedFX( level._effect["emb_burst_c"], 1, fx1.origin );
	fx2 = PlayLoopedFX( level._effect["emb_burst_c"], 1, fx2.origin );
	fx3 = PlayLoopedFX( level._effect["emb_burst_c"], 1, fx3.origin );
	fx4 = PlayLoopedFX( level._effect["emb_burst_c"], 1, fx4.origin );
	fx5 = PlayLoopedFX( level._effect["emb_burst_c"], 1, fx5.origin );
	fx6 = PlayLoopedFX( level._effect["emb_burst_c"], 1, fx6.origin );
	fx7 = PlayLoopedFX( level._effect["emb_burst_c"], 1, fx7.origin );
	fx8 = PlayLoopedFX( level._effect["emb_burst_c"], 1, fx8.origin );
	fx9 = PlayLoopedFX( level._effect["emb_burst_c"], 1, fx9.origin );
	fx10 = PlayLoopedFX( level._effect["emb_burst_c"], 1, fx10.origin );

	fx11 = PlayLoopedFX( level._effect["firelp_small_dl_d"], 1, fx11.origin );
	fx12 = PlayLoopedFX( level._effect["firelp_small_dl_d"], 1, fx12.origin );
	fx13 = PlayLoopedFX( level._effect["firelp_small_dl_d"], 1, fx13.origin );
	fx14 = PlayLoopedFX( level._effect["firelp_small_dl_d"], 1, fx14.origin );
	fx15 = PlayLoopedFX( level._effect["firelp_small_dl_d"], 1, fx15.origin );
	fx16 = PlayLoopedFX( level._effect["firelp_small_dl_d"], 1, fx16.origin );
	fx17 = PlayLoopedFX( level._effect["firelp_small_dl_d"], 1, fx17.origin );
	fx18 = PlayLoopedFX( level._effect["firelp_small_dl_d"], 1, fx18.origin );
	fx19 = PlayLoopedFX( level._effect["firelp_small_dl_d"], 1, fx19.origin );
	fx20 = PlayLoopedFX( level._effect["firelp_small_dl_d"], 1, fx20.origin );


}

secret1()
{
	secret1 = getEnt( "secret1", "targetname" );

	secret1 waittill("trigger", other);

	other PlaySound("sm_key");
	other iprintlnbold("^3Welcome to secret room");

}

upitnikXP1()
{

	upitnikXP1 = getEnt( "upitnikXP1", "targetname" );
	blokXP1 = getEnt( "blokXP1", "targetname" );
	triggXP1 = getEnt( "triggXP1", "targetname" );

	blokXP1 hide();

	triggXP1 waittill("trigger", other);
	triggXP1  delete();

	blokXP1 PlaySound("coin_blok");

	other braxi\_rank::giveRankXP( "trap_activation" );
	other iprintlnbold("^7You won ^35 ^1XP ^7points");

	upitnikXP1 movez( 8, 0.3 );
	wait 0.3;
	upitnikXP1 movez( -8, 0.3 );
	wait 0.3;
	upitnikXP1 delete();
	blokXP1 show();

}

upitnikXP2()
{

	upitnikXP2 = getEnt( "upitnikXP2", "targetname" );
	blokXP2 = getEnt( "blokXP2", "targetname" );
	triggXP2 = getEnt( "triggXP2", "targetname" );

	blokXP2 hide();

	triggXP2 waittill("trigger", other);
	triggXP2  delete();

	blokXP2 PlaySound("coin_blok");

	other braxi\_rank::giveRankXP( "trap_activation" );
	other iprintlnbold("^7You won ^35 ^1XP ^7points");

	upitnikXP2 movez( 8, 0.3 );
	wait 0.3;
	upitnikXP2 movez( -8, 0.3 );
	wait 0.3;
	upitnikXP2 delete();
	blokXP2 show();

}

upitnikXP3()
{

	upitnikXP3 = getEnt( "upitnikXP3", "targetname" );
	blokXP3 = getEnt( "blokXP3", "targetname" );
	triggXP3 = getEnt( "triggXP3", "targetname" );

	blokXP3 hide();

	triggXP3 waittill("trigger", other);
	triggXP3  delete();

	blokXP3 PlaySound("coin_blok");

	other braxi\_rank::giveRankXP( "trap_activation" );
	other iprintlnbold("^7You won ^35 ^1XP ^7points");

	upitnikXP3 movez( 8, 0.3 );
	wait 0.3;
	upitnikXP3 movez( -8, 0.3 );
	wait 0.3;
	upitnikXP3 delete();
	blokXP3 show();

}

upitnikXP4()
{

	upitnikXP4 = getEnt( "upitnikXP4", "targetname" );
	blokXP4 = getEnt( "blokXP4", "targetname" );
	triggXP4 = getEnt( "triggXP4", "targetname" );

	blokXP4 hide();

	triggXP4 waittill("trigger", other);
	triggXP4  delete();

	blokXP4 PlaySound("coin_blok");

	other braxi\_rank::giveRankXP( "kill" );
	other iprintlnbold("^7You won ^350 ^1XP ^7points");

	upitnikXP4 movez( 8, 0.3 );
	wait 0.3;
	upitnikXP4 movez( -8, 0.3 );
	wait 0.3;
	upitnikXP4 delete();
	blokXP4 show();

}

coinsXP1_rot()
{
	coinXP = getEnt( "coinXP1", "targetname" );
	while( 1 )
	{
	coinXP rotateYaw( 360, 2 );
	wait 2;
	}
}

coinsXP1()
{

	coinXP = getEnt( "coinXP1", "targetname" );
	trig_coinXP = getEnt( "trig_coinXP1", "targetname" );

	trig_coinXP  delete();
	coinXP  delete();
}

coinsXP2_rot()
{
	coinXP = getEnt( "coinXP2", "targetname" );
	while( 1 )
	{
	coinXP rotateYaw( 360, 2 );
	wait 2;
	}
}

coinsXP2()
{

	coinXP = getEnt( "coinXP2", "targetname" );
	trig_coinXP = getEnt( "trig_coinXP2", "targetname" );

	trig_coinXP  delete();
	coinXP  delete();
}

coinsXP3_rot()
{
	coinXP = getEnt( "coinXP3", "targetname" );
	while( 1 )
	{
	coinXP rotateYaw( 360, 2 );
	wait 2;
	}
}

coinsXP3()
{

	coinXP = getEnt( "coinXP3", "targetname" );
	trig_coinXP = getEnt( "trig_coinXP3", "targetname" );

	trig_coinXP  delete();
	coinXP  delete();
}

coinsXP4_rot()
{
	coinXP = getEnt( "coinXP4", "targetname" );
	while( 1 )
	{
	coinXP rotateYaw( 360, 2 );
	wait 2;
	}
}

coinsXP4()
{

	coinXP = getEnt( "coinXP4", "targetname" );
	trig_coinXP = getEnt( "trig_coinXP4", "targetname" );

	trig_coinXP  delete();
	coinXP  delete();
}

coinsXP5_rot()
{
	coinXP = getEnt( "coinXP5", "targetname" );
	while( 1 )
	{
	coinXP rotateYaw( 360, 2 );
	wait 2;
	}
}

coinsXP5()
{

	coinXP = getEnt( "coinXP5", "targetname" );
	trig_coinXP = getEnt( "trig_coinXP5", "targetname" );

	trig_coinXP  delete();
	coinXP  delete();
}

coinsXP6_rot()
{
	coinXP = getEnt( "coinXP6", "targetname" );
	while( 1 )
	{
	coinXP rotateYaw( 360, 2 );
	wait 2;
	}
}

coinsXP6()
{

	coinXP = getEnt( "coinXP6", "targetname" );
	trig_coinXP = getEnt( "trig_coinXP6", "targetname" );

	trig_coinXP  delete();
	coinXP  delete();
}

coinsXP7_rot()
{
	coinXP = getEnt( "coinXP7", "targetname" );
	while( 1 )
	{
	coinXP rotateYaw( 360, 2 );
	wait 2;
	}
}

coinsXP7()
{

	coinXP = getEnt( "coinXP7", "targetname" );
	trig_coinXP = getEnt( "trig_coinXP7", "targetname" );

	trig_coinXP  delete();
	coinXP  delete();
}

coinsXP8_rot()
{
	coinXP = getEnt( "coinXP8", "targetname" );
	while( 1 )
	{
	coinXP rotateYaw( 360, 2 );
	wait 2;
	}
}

coinsXP8()
{

	coinXP = getEnt( "coinXP8", "targetname" );
	trig_coinXP = getEnt( "trig_coinXP8", "targetname" );

	trig_coinXP  delete();
	coinXP  delete();
}

coinsXP9_rot()
{
	coinXP = getEnt( "coinXP9", "targetname" );
	while( 1 )
	{
	coinXP rotateYaw( 360, 2 );
	wait 2;
	}
}

coinsXP9()
{

	coinXP = getEnt( "coinXP9", "targetname" );
	trig_coinXP = getEnt( "trig_coinXP9", "targetname" );

	trig_coinXP  delete();
	coinXP  delete();
}

coinsXP10_rot()
{
	coinXP = getEnt( "coinXP10", "targetname" );
	while( 1 )
	{
	coinXP rotateYaw( 360, 2 );
	wait 2;
	}
}

coinsXP10()
{

	coinXP = getEnt( "coinXP10", "targetname" );
	trig_coinXP = getEnt( "trig_coinXP10", "targetname" );

	trig_coinXP  delete();
	coinXP  delete();
}

coinsXP11_rot()
{
	coinXP = getEnt( "coinXP11", "targetname" );
	while( 1 )
	{
	coinXP rotateYaw( 360, 2 );
	wait 2;
	}
}

coinsXP11()
{

	coinXP = getEnt( "coinXP11", "targetname" );
	trig_coinXP = getEnt( "trig_coinXP11", "targetname" );

	trig_coinXP  delete();
	coinXP  delete();
}