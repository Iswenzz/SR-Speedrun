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

	// thread text();
	// thread sound_die();
	// thread vaxt();
	// thread pokretno_skriveno_t2();
	// thread mapbyjerkan();
	// thread mapbyjerkan2();
	// thread mapbyjerkan3();
	// thread star1();
	// thread star2();
	// thread oblak_huh();
	// thread oblak_huh2();
	// thread oblak_huh3();
	// thread oblak_huh4();
	// thread oblak_huh5();
	// thread oblak_huh6();
	// thread oblak_huh7();
	// thread biljka1();
	// thread biljka2();
	// thread biljka3();
	// thread vortex1();
	// thread vortex2();
	// thread vortex3();
	// thread vortex4();
	// thread vortex5();
	// thread vortex6();
	// thread vortex7();
	// thread vortex8();
	// thread vortex9();
	// thread vortex10();
	// thread vortex11();
	// thread vortex12();
	// thread vortex13();
	// thread vortex14();
	// thread propeler1();
	// thread propeler2();
	// thread propeler3();
	// thread propeler4();
	// thread kocka1_lijevo();
	// thread kocka1_desno();
	thread ribe();


}

text()
{
while(1)
{
	iprintln ("^3Map by ^1je^7rk^4an");
	wait 15;

	iprintln ("^3www.jerkanmaps.weebly.com");

	wait 15;
}
}

sound_die()
{

	trig_sd = getEnt( "sound_die", "targetname" );

	while( 1 )
	{

	trig_sd waittill("trigger", other);

	other PlaySound ("sm_die");

	fx = PlayFX( level._effect["water_splash_bodydump"], other.origin );

	}
}


vaxt()

{

	brushv1 = getEnt( "vaxt1", "targetname" );
	brushv2 = getEnt( "vaxt2", "targetname" );
	brushv3 = getEnt( "upitnik_vrax", "targetname" );
	fx_v = getent ( "vrax_fx" ,"targetname" ); //origin
	trig_v = getEnt( "vrax_trigger", "targetname" );

	brushv1 movez( -416, 2 );
	brushv2 movez( -512, 2 );

	trig_v waittill("trigger", other);
	trig_v delete();

	fx = PlayFX( level._effect["artillery_flash"], fx_v.origin );
	brushv1 PlaySound("flag");
	brushv3 delete();


	brushv1 movez( 416, 2 );
	brushv2 movez( 512, 2 );


}


pokretno_skriveno_t2()

{
	brushsk1 = getEnt( "sk_lijevo", "targetname" );
	brushsk2 = getEnt( "sk_desno", "targetname" );
	brushsk3 = getEnt( "upitnik_sk", "targetname" );
	fx_sk = getent ( "sk_fx" ,"targetname" ); //origin
	trig_sk = getEnt( "sk_trigger", "targetname" );


	brushsk1 movey( -128, 2 );
	brushsk2 movey( 128, 2 );

	trig_sk waittill("trigger", other);
	trig_sk delete();

	fx = PlayFX( level._effect["artillery_flash"], fx_sk.origin );
	brushsk3 PlaySound("blockhit");
	brushsk3 delete();

	brushsk1 movey( 368, 2 );
	brushsk2 movey( -368, 2 );
	wait 2;

	while( 1 )
	{
	brushsk1 movey( -304, 2 );
	brushsk2 movey( 304, 2 );
	wait 2;

	brushsk1 movey( 304, 2 );
	brushsk2 movey( -304, 2 );
	wait 2;
	}
}


mapbyjerkan()

{

	mbj = getEnt( "map_by_jerkan", "targetname" );

	
	while( 1 )
	{
	mbj hide();
	wait 0.2;
	mbj show();
	wait 1;
	mbj hide();
	wait 0.5;
	mbj show();
	wait 0.5;
	mbj hide();
	wait 1;
	mbj show();
	wait 1;
	mbj hide();
	wait 0.4;
	mbj show();
	wait 2;
	}
}

mapbyjerkan2()

{

	mbj2 = getEnt( "map_by_jerkan2", "targetname" );
	
	while( 1 )
	{ 
	mbj2 hide();
	wait 0.4;
	mbj2 show();
	wait 0.8;
	mbj2 hide();
	wait 0.6;
	mbj2 show();
	wait 0.5;
	mbj2 hide();
	wait 0.6;
	mbj2 show();
	wait 1;
	mbj2 hide();
	wait 0.4;
	mbj2 show();
	wait 2;
	}
}


mapbyjerkan3()

{

	mbj3 = getEnt( "mapbyjerkan3", "targetname" );
	
	while( 1 )
	{ 
	mbj3 rotateYaw( -360, 8 );
	wait 8;
	}
}


star1()
{
	star1 = getEnt( "star1", "targetname" );
	while( 1 )
	{
	star1 rotateYaw( 360, 2 );
	wait 2;
	}
}

star2()
{
	star2 = getEnt( "star2", "targetname" );
	while( 1 )
	{
	star2 rotateYaw( 360, 2 );
	wait 2;
	}
}


oblak_huh()
{
	trig_ob = getEnt( "trig_ob", "targetname" );
	while( 1 )
	{
	trig_ob waittill("trigger", other);
	other PlaySound ("huh");
	wait 3;
	}
}
oblak_huh2()
{
	trig_ob2 = getEnt( "trig_ob2", "targetname" );
	while( 1 )
	{
	trig_ob2 waittill("trigger", other);
	other PlaySound ("huh");
	wait 3;
	}
}
oblak_huh3()
{
	trig_ob3 = getEnt( "trig_ob3", "targetname" );
	while( 1 )
	{
	trig_ob3 waittill("trigger", other);
	other PlaySound ("huh");
	wait 3;
	}
}
oblak_huh4()
{
	trig_ob4 = getEnt( "trig_ob4", "targetname" );
	while( 1 )
	{
	trig_ob4 waittill("trigger", other);
	trig_ob4 PlaySound ("huh");
	wait 3;
	}
}
oblak_huh5()
{
	trig_ob5 = getEnt( "trig_ob5", "targetname" );
	while( 1 )
	{
	trig_ob5 waittill("trigger", other);
	trig_ob5 PlaySound ("huh");
	wait 3;
	}
}
oblak_huh6()
{
	trig_ob6 = getEnt( "trig_ob6", "targetname" );
	while( 1 )
	{
	trig_ob6 waittill("trigger", other);
	trig_ob6 PlaySound ("huh");
	wait 3;
	}
}
oblak_huh7()
{
	trig_ob7 = getEnt( "trig_ob7", "targetname" );
	while( 1 )
	{
	trig_ob7 waittill("trigger", other);
	trig_ob7 PlaySound ("huh");
	wait 3;
	}
}


biljka1()

{

	k1 = getEnt( "k1", "targetname" );
	fx_biljka1 = getEnt( "fx_biljka1", "targetname" );

	fx = PlayLoopedFX( level._effect["pipe_steam"], 1, fx_biljka1.origin );

	while( 1 )
	{
	k1 movez ( 8, 0.2 );
	wait 0.2;
	k1 movez ( -8, 0.2 );
	wait 0.2;
	k1 movez ( 8, 0.2 );
	wait 0.2;
	k1 movez ( -8, 0.2 );
	wait 0.2;
	k1 movez ( 8, 0.2 );
	wait 0.2;
	k1 movez ( -8, 0.2 );
	wait 0.2;
	k1 movez ( 150, 0.5 );
	wait 0.5;
	k1 movez ( -8, 0.2 );
	wait 0.2;
	k1 movez ( 8, 0.2 );
	wait 0.2;
	k1 movez ( -8, 0.2 );
	wait 0.2;
	k1 movez ( 8, 0.2 );
	wait 0.2;
	k1 movez ( -8, 0.2 );
	wait 0.2;
	k1 movez ( 8, 0.2 );
	wait 0.2;
	k1 movez ( -150, 0.5 );
	wait 0.5;
	}
}

biljka2()

{
	biljka2 = getEnt( "biljka2", "targetname" );
	kill = getEnt( "kill-trig_biljka2", "targetname" );

	kill enableLinkTo();
	kill linkTo( biljka2 );

	while( 1 )
	{
	biljka2 movez( -100, 0.5 );
	wait 2;
	biljka2 movez( 100, 0.5 );
	wait 2;
	}
}

biljka3()

{
	biljka3 = getEnt( "biljka3", "targetname" );
	kill = getEnt( "kill-trig_biljka3", "targetname" );

	kill enableLinkTo();
	kill linkTo( biljka3 );

	while( 1 )
	{
	biljka3 movez( -100, 0.5 );
	wait 2;
	biljka3 movez( 100, 0.5 );
	wait 2;
	}
}


vortex1()
{
	vortex1 = getEnt( "vortex1", "targetname" );
	while( 1 )
	{
	vortex1 rotateYaw( 360, 1 );
	wait 1;
	}
}

vortex2()
{
	vortex2 = getEnt( "vortex2", "targetname" );
	while( 1 )
	{
	vortex2 rotateYaw( 360, 1 );
	wait 1;
	}
}

vortex3()
{
	vortex3 = getEnt( "vortex3", "targetname" );
	while( 1 )
	{
	vortex3 rotateYaw( 360, 1 );
	wait 1;
	}
}

vortex4()
{
	vortex4 = getEnt( "vortex4", "targetname" );
	while( 1 )
	{
	vortex4 rotateYaw( 360, 1 );
	wait 1;
	}
}

vortex5()
{
	vortex5 = getEnt( "vortex5", "targetname" );
	while( 1 )
	{
	vortex5 rotateYaw( 360, 1 );
	wait 1;
	}
}

vortex6()
{
	vortex6 = getEnt( "vortex6", "targetname" );
	while( 1 )
	{
	vortex6 rotateYaw( 360, 1 );
	wait 1;
	}
}

vortex7()
{
	vortex7 = getEnt( "vortex7", "targetname" );
	while( 1 )
	{
	vortex7 rotateYaw( 360, 1 );
	wait 1;
	}
}

vortex8()
{
	vortex8 = getEnt( "vortex8", "targetname" );
	while( 1 )
	{
	vortex8 rotateYaw( 360, 1 );
	wait 1;
	}
}

vortex9()
{
	vortex9 = getEnt( "vortex9", "targetname" );
	while( 1 )
	{
	vortex9 rotateYaw( 360, 1 );
	wait 1;
	}
}

vortex10()
{
	vortex10 = getEnt( "vortex10", "targetname" );
	while( 1 )
	{
	vortex10 rotateYaw( 360, 1 );
	wait 1;
	}
}

vortex11()
{
	vortex11 = getEnt( "vortex11", "targetname" );
	while( 1 )
	{
	vortex11 rotateYaw( 360, 1 );
	wait 1;
	}
}

vortex12()
{
	vortex12 = getEnt( "vortex12", "targetname" );
	while( 1 )
	{
	vortex12 rotateYaw( 360, 1 );
	wait 1;
	}
}

vortex13()
{
	vortex13 = getEnt( "vortex13", "targetname" );
	while( 1 )
	{
	vortex13 rotateYaw( 360, 1 );
	wait 1;
	}
}

vortex14()
{
	vortex14 = getEnt( "vortex14", "targetname" );
	while( 1 )
	{
	vortex14 rotateYaw( 360, 1 );
	wait 1;
	}
}

propeler1()
{
	propeler1 = getEnt( "propeler1", "targetname" );
	while( 1 )
	{
	propeler1 rotateYaw( 360, 1 );
	wait 1;
	}
}

propeler2()
{
	propeler2 = getEnt( "propeler2", "targetname" );
	while( 1 )
	{
	propeler2 rotateYaw( 360, 2 );
	wait 1;
	}
}

propeler3()
{
	propeler3 = getEnt( "propeler3", "targetname" );
	while( 1 )
	{
	propeler3 rotateYaw( 360, 2 );
	wait 1;
	}
}

propeler4()
{
	propeler4 = getEnt( "propeler4", "targetname" );
	while( 1 )
	{
	propeler4 rotateYaw( 360, 2 );
	wait 1;
	}
}

kocka1_lijevo()
{
	kocka1 = getEnt( "kocka1", "targetname" );
	pomak_lijevo1 = getEnt( "pomak_lijevo1", "targetname" );


	while( 1 )
	{
	pomak_lijevo1 waittill("trigger", other);

	kocka1 rotatePitch( -2, 0.5 );

	}

}


kocka1_desno()
{
	kocka1 = getEnt( "kocka1", "targetname" );
	pomak_desno1 = getEnt( "pomak_desno1", "targetname" );


	while( 1 )
	{

	pomak_desno1 waittill("trigger", other);

	kocka1 rotatePitch( 2, 0.5 );
	}

}

ribe()

{

	riba1 = getEnt( "riba1", "targetname" );
	riba2 = getEnt( "riba2", "targetname" );
	riba3 = getEnt( "riba3", "targetname" );
	riba4 = getEnt( "riba4", "targetname" );
	riba5 = getEnt( "riba5", "targetname" );
	riba6 = getEnt( "riba6", "targetname" );
	riba7 = getEnt( "riba7", "targetname" );


	riba1 movez ( -128, 0.5 );
	riba2 movez ( -128, 0.5 );
	riba3 movez ( -128, 0.5 );
	riba4 movez ( -128, 0.5 );
	riba5 movez ( -128, 0.5 );
	riba6 movez ( -128, 0.5 );
	riba7 movez ( -128, 0.5 );
	wait 0.5;

	while( 1 )
	{

	riba1 rotateRoll( -360, 2 );
	wait 2.5;
	riba2 rotateRoll( -360, 2 );
	wait 2.5;
	riba3 rotateRoll( -360, 2 );
	wait 2.5;
	riba4 rotateRoll( -360, 2 );
	wait 2.5;
	riba5 rotateRoll( -360, 2 );
	wait 2.5;
	riba6 rotateRoll( -360, 2 );
	wait 2.5;
	riba7 rotateRoll( -360, 2 );
	wait 2.5;
	}
}

