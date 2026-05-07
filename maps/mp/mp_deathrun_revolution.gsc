main()
{

	maps\mp\_load::main();
 
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	
	//ambientPlay( "song1" );
	
	setdvar( "r_specularcolorscale", "1" );
	
	//precacheItem("ak47_mp");

  thread sr\api\_map::createSpawn((-72, -13, 64), 0);
  thread sr\api\_speedrun::createNormalWays("Normal Way");
  thread sr\api\_speedrun::createSecretWays("Secret Way");
  thread sr\api\_speedrun::createEndMap((200.303, -1107.77, 20.125), 70,215, "normal_0");  

  thread secret_enter();
  thread secret_end();
	
	//thread trap1(); 
	//thread trap2(); 
	//thread trap3(); 
	//thread trap4(); 
	thread autobrush(); 
	//thread trap6();
	//thread trap7();
	//thread trap8();
	//thread nonsolidtext();
	//thread trap9();
	//thread sniper();
	//thread bounce();
	//thread knife();
	//thread old();
	//thread secrethole();
	thread secrettele1();
	thread secrettele2();
	thread secrettele3();
	thread secrettele4();
	thread secrettele5();
	thread secrettele6();
	//thread endsecret();
	//thread bounceroomweap();
	//thread credits();
	//thread startsecret();
	//thread jumper();
	//thread bouncerespawn();
	
	addTriggerToList("trap1_trig");
	addTriggerToList("trap2_trig");
	addTriggerToList("trap3_trig");
	addTriggerToList("trap4_trig");
	addTriggerToList("trap6_trig");
	addTriggerToList("trap7_trig");
	addTriggerToList("trap8_trig");
	addTriggerToList("trap9_trig");
	addTriggerToList("endsecret");
}
secret_enter()
{
	trig = spawn("trigger_radius",(-72.0083, -164.209, 4.125), 0, 60, 120);
	trig.radius = 60;
	
	ori_t = spawn("script_origin",(-80,1162,-1163));
	ori_t.angles = (0,360,0);

	thread sr\api\_map::createTriggerFx(trig, "green");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_0"); 

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
		player freeze_on_tps(0.1);
	}
}

freeze_on_tps(time) {
	self freezecontrols(true);
	self thread freeze_on_tps_repeat(time);
}
freeze_on_tps_repeat(time) {
	wait time;
	self freezecontrols(false);
}
secret_end()//secret end
{
   trig = getent("jump", "targetname");
   
   for (;;)
    {   
     trig waittill ("trigger", player);
	player thread sr\api\_speedrun::finishWay("secret_0");
    }
}
addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

trap1() //Works
{
	brush = getent("trap1_brush","targetname");
	trigger = getent("trap1_trig","targetname");
	trigger waittill("trigger");
	trigger setHintString("^2ACTIVATED!");
	
	while(1)
	{
		brush moveY(128,.5);
		brush waittill("movedone");
		wait 1;
		brush moveY(-256,.5);
		brush waittill("movedone");
		wait 1;
		brush moveY(128,.5);
		brush waittill("movedone");
		wait 1;
	}
	
	trigger delete();
}

trap2() //Works
{
	brush = getent("trap2_brush","targetname");
	trigger = getent("trap2_trig","targetname");
	trigger waittill("trigger", player );
	trigger setHintString("^2ACTIVATED!");
	
	while(1)
	{
		brush rotateRoll(360,3);
		brush waittill("movedone");
		wait 3;
		brush rotateRoll(360,3);
		brush waittill("movedone");
		wait 3;
	}
	
	trigger delete();
}
	
trap3() // Works
{
	brush = getent("trap3_brush","targetname");
	trigger = getent("trap3_trig","targetname");
	trigger waittill("trigger");
	trigger setHintString("^2ACTIVATED!");
	
	brush NotSolid();
	trigger delete();
}

trap4() // Works
{
	brush = getent("trap4_brush","targetname");
	trigger = getent("trap4_trig","targetname");
	trigger waittill("trigger");
	trigger setHintString("^2ACTIVATED!");
	
	while(1)
	{
		brush rotatePitch(360,3);
		wait 1;
		brush rotatePitch(360,3);
		wait 1;
	}
	
	trigger delete();
}

autobrush() // Works
{
	brush = getent("i","targetname");

  wait 0.1;
	

		brush moveX(352,0.1);
		wait 0.1;
    brush rotateYaw(90,0.1);
	

}

trap6() //Works
{

	brush1 = getent("lol1","targetname");
	brush2 = getent("lol2","targetname");
	brush3 = getent("lol3","targetname");
	brush4 = getent("lol4","targetname");
	brush5 = getent("lol5","targetname");
	brush6 = getent("lol6","targetname");
	trigger = getent("trap6_trig","targetname");
	trigger waittill("trigger", player );
	trigger setHintString("^2ACTIVATED!");
	
	while(1)
	{
		brush1 rotateYaw(360,4);
		brush2 rotateYaw(360,3);
		brush3 rotateYaw(360,6);
		brush4 rotateYaw(360,7);
		brush5 rotateYaw(360,3);
		brush6 rotateYaw(360,1);
		wait 1;
		brush1 rotateYaw(360,4);
		brush2 rotateYaw(360,3);
		brush3 rotateYaw(360,6);
		brush4 rotateYaw(360,7);
		brush5 rotateYaw(360,3);
		brush6 rotateYaw(360,1);
		wait 1;
	}

	trigger delete();
		
}

trap7() // Works
{
	brush = getent("ryanispro","targetname");
	hurt = getent("hahalol","targetname");
	trigger = getent("trap7_trig","targetname");
	
	hurt enablelinkto();
	hurt linkto (brush);
	
	trigger waittill("trigger");
	trigger setHintString("^2ACTIVATED!");
	
	while(1)
	{
		brush rotateYaw(360,3);
		wait 1;
		brush rotateYaw(360,3);
		wait 1;
	}
	
	trigger delete();
}

trap8() // Works
{
	trigger = getent("trap8_trig","targetname");
	brush = getent("huehue","targetname");
	trigger waittill("trigger");
	trigger setHintString("^2ACTIVATED!");
	
	brush NotSolid();
	
	trigger delete();
	
}

nonsolidtext() // Doesn't Work
{
	trigger = getent("traptext","targetname");
	trigger waittill("trigger" , player );
	
	player iPrintLnBold("^1Welcome to ^3#FNRP#Ryan's ^1TORTURE CHAMBER! ^2ENJOY! ^7MWAHAHAHA");
	
	trigger delete();
}

trap9() // Works
{
	brush = getent("trap9_brush","targetname");
	trigger = getent("trap9_trig","targetname");
	trigger waittill("trigger");
	trigger setHintString("^2ACTIVATED!");
	
	brush NotSolid();
	trigger delete();
}


sniper()
{
        level.sniper_trig = getEnt( "sniper1", "targetname");
        jump = getEnt( "sniper2", "targetname" );
        acti = getEnt( "sniper3", "targetname" );
 
 
        while(1)
        {
                level.sniper_trig waittill( "trigger", player );
                if( !isDefined( level.sniper_trig ) )
                        return;
 
                level.bounce_trig delete();
                level.old_trig delete();
                level.knife_trig delete();
 
                player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                player TakeAllWeapons();
                player GiveWeapon( "m40a3_mp" ); //jumper weapon  
                player switchToWeapon( "m40a3_mp" );
                if(isDefined(level.activ) && isAlive(level.activ))
                {
                        level.activ setPlayerangles( acti.angles );
                        level.activ setOrigin( acti.origin );
                        level.activ TakeAllWeapons();
                        level.activ GiveWeapon( "m40a3_mp" );
                        level.activ SwitchToWeapon( "m40a3_mp" );
                        wait 0.05;
                       
                }
                wait 0.05;
               
                iPrintlnBold( " ^1" + player.name + " ^3 Has Chosen sniper room!" );     //change to what you want it to be
                        while( isAlive( player ) && isDefined( player ) )
                        wait 1;
   }
}


bounce()
{
        level.bounce_trig = getEnt( "bounce1", "targetname");
        jump = getEnt( "bounce2", "targetname" );
        acti = getEnt( "bounce3", "targetname" );
 
 
        while(1)
        {
                level.bounce_trig waittill( "trigger", player );
                if( !isDefined( level.bounce_trig ) )
                        return;
 
                level.sniper_trig delete();
                level.old_trig delete();
                level.knife_trig delete();
 
                player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                player TakeAllWeapons();
                player GiveWeapon( "knife_mp" ); //jumper weapon  
                player switchToWeapon( "knife_mp" );
                if(isDefined(level.activ) && isAlive(level.activ))
                {
                        level.activ setPlayerangles( acti.angles );
                        level.activ setOrigin( acti.origin );
                        level.activ TakeAllWeapons();
                        level.activ GiveWeapon( "knife" );
                        level.activ SwitchToWeapon( "knife_mp" );
                        wait 0.05;
                       
                }
                wait 0.05;
               
                iPrintlnBold( " ^1" + player.name + " ^3 Has Chosen bounce room!" );     //change to what you want it to be
                        while( isAlive( player ) && isDefined( player ) )
                        wait 1;
   }
}

 knife()
{
        level.knife_trig = getEnt( "knife1", "targetname");
        jump = getEnt( "knife2", "targetname" );
        acti = getEnt( "knife3", "targetname" );
 
 
        while(1)
        {
                level.knife_trig waittill( "trigger", player );
                if( !isDefined( level.knife_trig ) )
                        return;
 
                level.sniper_trig delete();
                level.old_trig delete();
                level.bounce_trig delete();
 
                player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                player TakeAllWeapons();
                player GiveWeapon( "knife_mp" ); //jumper weapon  
                player switchToWeapon( "knife_mp" );
                if(isDefined(level.activ) && isAlive(level.activ))
                {
                        level.activ setPlayerangles( acti.angles );
                        level.activ setOrigin( acti.origin );
                        level.activ TakeAllWeapons();
                        level.activ GiveWeapon( "knife_mp" );
                        level.activ SwitchToWeapon( "knife_mp" );
                        wait 0.05;
                       
                }
                wait 0.05;
               
                iPrintlnBold( " ^1" + player.name + " ^3 Has Chosen knife room!" );     //change to what you want it to be
                        while( isAlive( player ) && isDefined( player ) )
                        wait 1;
   }
}

 old()
{
        level.old_trig = getEnt( "old1", "targetname");
        jump = getEnt( "old2", "targetname" );
 
 
        while(1)
        {
                level.old_trig waittill( "trigger", player );
                if( !isDefined( level.old_trig ) )
                        return;
 
                level.bounce_trig delete();
                level.sniper_trig delete();
                level.knife_trig delete();
 
                player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                wait 0.05;
               
                iPrintlnBold( " ^1" + player.name + " ^3 Has Chosen old room!" );     //change to what you want it to be
                        while( isAlive( player ) && isDefined( player ) )
                        wait 1;
   }
}

secrettele1()
{

entTransporter = getentarray("secrettele1","targetname");
  if(isdefined(entTransporter))
  {
    for(lp=0;lp<entTransporter.size;lp=lp+1)
      entTransporter[lp] thread Transporter();
  }


}

transporter()
{
  while(true)
  {
   self waittill("trigger",other);
   entTarget = getent(self.target, "targetname");
   wait(0.10);
   other setorigin(entTarget.origin);
   other setplayerangles(entTarget.angles);
   //other iprintlnbold ("^1Try again!");
   wait(0.10);
  }
}

secrettele2()
{

entTransporter = getentarray("secrettele2","targetname");
  if(isdefined(entTransporter))
  {
    for(lp=0;lp<entTransporter.size;lp=lp+1)
      entTransporter[lp] thread Transporter2();
  }


}

transporter2()
{
  while(true)
  {
   self waittill("trigger",other);
   entTarget = getent(self.target, "targetname");
   wait(0.10);
   other setorigin(entTarget.origin);
   other setplayerangles(entTarget.angles);
   //other iprintlnbold ("^1Try again!");
   wait(0.10);
  }
}

secrettele3()
{

entTransporter = getentarray("secrettele3","targetname");
  if(isdefined(entTransporter))
  {
    for(lp=0;lp<entTransporter.size;lp=lp+1)
      entTransporter[lp] thread Transporter3();
  }


}

transporter3()
{
  while(true)
  {
   self waittill("trigger",other);
   entTarget = getent(self.target, "targetname");
   wait(0.10);
   other setorigin(entTarget.origin);
   other setplayerangles(entTarget.angles);
   //other iprintlnbold ("^1Try Again!");
   wait(0.10);
  }
}

secrettele4()
{

entTransporter = getentarray("secrettele4","targetname");
  if(isdefined(entTransporter))
  {
    for(lp=0;lp<entTransporter.size;lp=lp+1)
      entTransporter[lp] thread Transporter4();
  }


}

transporter4()
{
  while(true)
  {
   self waittill("trigger",other);
   entTarget = getent(self.target, "targetname");
   wait(0.10);
   other setorigin(entTarget.origin);
   other setplayerangles(entTarget.angles);
   //other iprintlnbold ("^1Try Again!");
   wait(0.10);
  }
}

secrettele5()
{

entTransporter = getentarray("secrettele5","targetname");
  if(isdefined(entTransporter))
  {
    for(lp=0;lp<entTransporter.size;lp=lp+1)
      entTransporter[lp] thread Transporter5();
  }


}

transporter5()
{
  while(true)
  {
   self waittill("trigger",other);
   entTarget = getent(self.target, "targetname");
   wait(0.10);
   other setorigin(entTarget.origin);
   other setplayerangles(entTarget.angles);
   //other iprintlnbold ("^1Try Again!");
   wait(0.10);
  }
}

secrettele6()
{

entTransporter = getentarray("secrettele6","targetname");
  if(isdefined(entTransporter))
  {
    for(lp=0;lp<entTransporter.size;lp=lp+1)
      entTransporter[lp] thread Transporter6();
  }


}

transporter6()
{
  while(true)
  {
   self waittill("trigger",other);
   entTarget = getent(self.target, "targetname");
   wait(0.10);
   other setorigin(entTarget.origin);
   other setplayerangles(entTarget.angles);
   //other iprintlnbold ("^1Try Again!");
   wait(0.10);
  }
}

endsecret()
{

entTransporter = getentarray("endsecret","targetname");
  if(isdefined(entTransporter))
  {
    for(lp=0;lp<entTransporter.size;lp=lp+1)
      entTransporter[lp] thread TransporterES();
  }
	
}

transporterES()
{
  while(true)
  {
   self waittill("trigger",player);
   entTarget = getent(self.target, "targetname");
   wait(0.10);
   player setorigin(entTarget.origin);
   player setplayerangles(entTarget.angles);
   iprintlnbold ("^1" + player.name + "^2 is a boss!");
   wait(0.10);
  }
  
	self GiveWeapon( "ak47_mp" );
	self GiveMaxAmmo( "ak47_mp" );
	self switchToWeapon( "ak47_mp" );
  
}

bounceroomweap()
{
	trigger = getent("ak47","targetname");
	trigger waittill("trigger" , player );
	
	player GiveWeapon( "ak47_mp" );
	player GiveMaxAmmo( "ak47_mp" );
	player switchToWeapon( "ak47_mp" );
}

secrethole()
{

	trigger = getent("secrethole","targetname");
	trigger waittill("trigger", player );

	player iPrintLnBold("^3Through the hole!");

}

credits()
{
	trigger = getent("creditslol","targetname");
	trigger waittill("trigger" , player );
	
	iPrintLnBold("^2Welcome to: ^5Revolution!"); 
	wait 3;
	iPrintLnBold("^2Map Created By: ^5#FNRP#Ryan & #FNRP#Ghost"); 
	wait 3;
	iPrintLnBold("^2Map Scripted By: ^5Pixel");  
	wait 3;
}

startsecret()
{

entTransporter = getentarray("startsecret","targetname");
  if(isdefined(entTransporter))
  {
    for(lp=0;lp<entTransporter.size;lp=lp+1)
      entTransporter[lp] thread TransporterSS();
  }


}

transporterSS()
{
  while(true)
  {
   self waittill("trigger",player);
   entTarget = getent(self.target, "targetname");
   wait(0.10);
   player setorigin(entTarget.origin);
   player setplayerangles(entTarget.angles);
   self playsound("mp_enemy_obj_captured");
   iprintlnbold ("^1" + player.name + " ^3ENTERED THE SECRET ROOM!");
   wait(0.10);
  }
}

jumper()
{
	jumpx = getent ("jump","targetname");
	air1 = getent ("air1","targetname");
	air2 = getent ("air2","targetname");
	air3 = getent ("air3","targetname");
	air4 = getent ("air4","targetname");
	air5 = getent ("air5","targetname");
	air6 = getent ("air6","targetname");

	time = 1;
	for(;;)
	{
		jumpx waittill ("trigger",user);
		if (user istouching(jumpx))
		{
			//throw = user.origin + (100, 100, 0);
			air = spawn ("script_model",(0,0,0));
			air.origin = user.origin;
			air.angles = user.angles;
			user linkto (air);
			air moveto (air1.origin, time);
			wait 1;
			air moveto (air2.origin, time);
			wait .5;
			air moveto (air3.origin, time);
			wait .5;
			air moveto (air4.origin, time);
			wait 1;
			air moveto (air5.origin, time);
			wait 1;
			air moveto (air6.origin, time);
			wait 1;
			user unlink();
			wait 1;
		}
	}
}

bouncerespawn() {
    trigger = getEnt ("bounce_respawn_trigger", "targetname"); //your trigger
    jumper = getEnt ("bounce_jumper_respawn", "targetname"); // respawn origin for the jumper
    activator = getEnt ("bounce_activator_respawn", "targetname"); // respawn origin for the activator
    
    for(;;)
    {
        trigger waittill ("trigger", player);
        if(player.pers["team"] == "allies")
        {
            player SetOrigin(jumper.origin);
            player SetPlayerAngles( jumper.angles );
        }
        else if(player.pers["team"] == "axis")    
        {
            player SetOrigin(activator.origin);
            player SetPlayerAngles( activator.angles );            
        }
    }
}