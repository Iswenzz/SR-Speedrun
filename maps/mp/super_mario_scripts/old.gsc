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

	thread old();
	thread key();
	thread pokretna_vrata3();


}


old()

{
	mreza_old = getEnt( "mreza_old", "targetname" );
	mreza_w = getEnt( "mreza_w", "targetname" );
	mreza_s = getEnt( "mreza_s", "targetname" );
	trigg_old = getEnt( "trigg_old", "targetname" );
	old_fx = getent ( "old_fx" ,"targetname" ); //origin
	gohere3 = getent ( "gohere3" ,"targetname" ); //origin


	trigg_old waittill("trigger", player);
	trigg_old delete();
	fx = PlayFX( level._effect["artillery_flash"], old_fx.origin );
	gohere3 PlaySound("course_clear");

	mreza_w Solid();
	mreza_s Solid();
	mreza_w show();
	mreza_s show();

}

key()

{

	key = getEnt( "key", "targetname" );
	upitnik_key = getEnt( "upitnik_key", "targetname" );
	blok_key = getEnt( "blok_key", "targetname" );
	fx_key = getent ( "fx_key" ,"targetname" ); //origin
	trig_aktiv_key = getEnt( "trig_aktiv_key", "targetname" );
	trigg_key = getEnt( "trigg_key", "targetname" );
	trigg_final_door = getEnt( "trigg_final_door", "targetname" );
	final_door_uputa = getEnt( "final_door_uputa", "targetname" );

	trigg_key enableLinkTo();
	trigg_key linkTo( key );

	key movez( -32, 0.5 );

	blok_key hide();

	trig_aktiv_key waittill("trigger", other);
	fx = PlayFX( level._effect["artillery_flash"], fx_key.origin );
	blok_key PlaySound("sm_obj");

	blok_key show();
	trig_aktiv_key delete();
	upitnik_key delete();

	wait 0.5;

	key movez( 32, 0.5 );
	wait 0.5;

	trigg_key waittill("trigger", player);
	player PlaySound("sm_key");
	trigg_key delete();
	key delete();

	iprintlnbold ("^3=>^1" + player.name + "^3<= ^2has picked the key");

	final_door_uputa delete();
	wait 0.1;

	thread final_door();
}


final_door()

{
	trigg_final_door = getEnt( "trigg_final_door", "targetname" );
	final_door_l = getEnt( "final_door_l", "targetname" );
	final_door_r = getEnt( "final_door_r", "targetname" );
	trigger_vrata3 = getEnt( "trigger_vrata3", "targetname" );
	uputa_old_vrata3 = getEnt( "uputa_old_vrata3", "targetname" );
	vrata_l3 = getEnt( "vrata_l3", "targetname" );
	vrata_r3 = getEnt( "vrata_r3", "targetname" );

	wepclip_old = getEnt( "wepclip_old", "targetname" );

	trigg_final_door waittill("trigger", player);
	trigg_final_door delete();

	final_door_l rotateYaw( 80, 1 );
	final_door_r rotateYaw( -80, 1 );
	final_door_l playsound("sm_door");

	uputa_old_vrata3 delete();

	trigger_vrata3 delete();
	wepclip_old delete();

	vrata_l3 movey(-42, 0.5 );
	vrata_r3 movey(42, 0.5 );
	vrata_r3 playsound("sm_door");


	thread teleportiranje_aktivatora_old();


	AmbientStop(0.5);
	wait 0.5;
	vrata_l3 delete();
	vrata_r3 delete();
	ambientPlay("mario_ambient3");
	iprintlnbold ("^3=>^1" + player.name + "^3<= ^2finished Super Mario map 1st.");
	wait 0.5;
	iprintlnbold ("^3=>^1" + player.name + "^3<= ^2opened the FINAL door!");

}

pokretna_vrata3()
{
	doortrig = getEnt( "trigger_vrata3", "targetname" );
	doortrig.doorclosed = true;

	while (1)
	{
		doortrig waittill("trigger", other);
		if(doortrig.doorclosed)
		{
			doortrig thread move(other);
		}
	}

}

move(other)
{

	vrata1 = getEnt( "vrata_l3", "targetname" );
	vrata2 = getEnt( "vrata_r3", "targetname" );

	self notify("doortrig_finish");
	self.doorclosed = false;
	vrata1 playsound("sm_door");
	vrata1 movey(-34, 2, 0.5, 0.5);
	vrata2 playsound("sm_door");
	vrata2 movey(34, 2, 0.5, 0.5);
	vrata1 waittill ("movedone");

	if(isDefined(other) && other isTouching(self))
	{
		while(isDefined(other) && other isTouching(self))
		{
			wait 2; // Wait until 'other' is no longer touching the trigger
		}
	}

	vrata1 playsound("elevator");
	vrata1 movey(34, 2, 0.5, 0.5);
	vrata2 playsound("sm_door");
	vrata2 movey(-34, 2, 0.5, 0.5);
	vrata1 waittill ("movedone");
	self.doorclosed = true;
}



teleportiranje_aktivatora_old()
{
	players = getEntArray("player", "classname");
	for(i=0;i<players.size;i++)
	{
		if( IsAlive(players[i]))
		{
			if( players[i].pers["team"] == "axis" )
			{
				players[i] thread aktivator_old();


			}
		}
	}
}

aktivator_old()
{

aktivator_enter_old = getent ("aktivator_enter_old" , "targetname");


self setorigin (aktivator_enter_old.origin);
self setplayerangles (aktivator_enter_old.angles);


}

