//////////////////////////////////////////////////
////////////| mp_deathrun_underworld |////////////
//////////////////////////////////////////////////
//////////////| map made by Icomar |//////////////
//////////////////////////////////////////////////
///////////////| xFire: icomar727 |///////////////
//////////////////////////////////////////////////
///////////////| Thanks to: Blade |///////////////
//////////////////////////////////////////////////



main()
{
    
	thread minigame_bounce_acti();
	thread m4_acti();
	thread m4_acti_2();
	thread minigame_bounce_jumper();
	thread m4_jumper();
	thread m4_jumper_2();
	thread elevator_1 ();
	thread jumper();
	thread banner();
	thread sniper_ammo();

}

minigame_bounce_acti()
{
	trigger = getEnt ("bounce_acti", "targetname");
	target = getEnt ("bounce_acti_origin", "targetname");
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

m4_acti()
{
    target = getEnt ("m4_model_acti", "targetname");
	
	while (1)
	{
	    target rotateYaw (360, 4);
		wait 4;
	}
}

m4_acti_2()
{
    trigger = getEnt ("m4_trigger_acti", "targetname");
	
	trigger waittill ("trigger", player );
	trigger delete();
	
	player giveWeapon( "m4_acog_mp" );
    player giveMaxammo("m4_acog_mp");
    player switchToWeapon("m4_acog_mp");
}

minigame_bounce_jumper()
{
	trigger = getEnt ("bounce_jumper", "targetname");
	target = getEnt ("bounce_jumper_origin", "targetname");
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

m4_jumper()
{
    target = getEnt ("m4_model_jumper", "targetname");
	
	while (1)
	{
	    target rotateYaw (360, 4);
		wait 4;
	}
}

m4_jumper_2()
{
    trigger = getEnt ("m4_trigger_jumper", "targetname");
	
	trigger waittill ("trigger", player );
	trigger delete();
	
	player giveWeapon( "m4_acog_mp" );
    player giveMaxammo("m4_acog_mp");
    player switchToWeapon("m4_acog_mp");
}

elevator_1()
{
    trigger = getEnt ("elevator_trigger_1", "targetname");
	target = getEnt ("elevator_1", "targetname");
	
	while (1)
	{
	    trigger waittill ("trigger", player );
	
	    target moveZ (1095, 5);
		target waittill ("movedone");
		wait 3;
		target moveZ (-1095, 3);
		target waittill ("movedone");
		wait 5;
	}
}

jumper()
{
	jumpx = getEnt ("jump", "targetname");
	air1 = getEnt ("air1", "targetname");
	air2 = getEnt ("air2", "targetname");

	for(;;)
	{
		jumpx waittill ("trigger", user);
		if (user istouching(jumpx))
		{
			//throw = user.origin + (100, 100, 0);
			air = spawn ("script_model",(5,7,1));
			air.origin = user.origin;
			air.angles = user.angles;
			user DisableWeapons();
			wait 0.5;
			user linkto (air);
			air moveto (air1.origin, 1, 0.5, 0.5);
			wait 1;
			air moveto (air2.origin, 4, 4, 0 );
			wait 4;
			user unlink();
			wait 0.2;
			user EnableWeapons();
			wait 0.1;
		}
	}
}

banner() 
{ 
	if( isDefined( self.logoText ) ) 
	self.logoText destroy(); 

	self.logoText = newHudElem(); 
	self.logoText.y = 10; 
	self.logoText.alignX = "center"; 
	self.logoText.alignY = "middle"; 
	self.logoText.horzAlign = "center_safearea"; 

	self.logoText.alpha = 0; 
	self.logoText.sort = -3; 
	self.logoText.fontScale = 1.5; 
	self.logoText.archieved = true; 

	self.logoText fadeOverTime(1); 
	self.logoText.alpha = 1; 
	self.logoText setText("^2<< ^3Deathrun Underworld ^2>>"); 
	wait 9; 
	self.logoText fadeOverTime(1); 
	self.logoText.alpha = 0; 
	wait 1; 
	self.logoText fadeOverTime(1); 
	self.logoText.alpha = 1; 
	self.logoText setText("^2<< ^3Map made by Icomar ^2>>"); 
	wait 5; 
	self.logoText fadeOverTime(1); 
	self.logoText.alpha = 0; 
	wait 1; 
	self.logoText fadeOverTime(1); 
	self.logoText.alpha = 1; 
	self.logoText setText("^2<< ^3Additional help : Blade ^2>>"); 
	wait 9; 
	self.logoText fadeOverTime(1); 
	self.logoText.alpha = 0; 
	wait 1; 
	self.logoText fadeOverTime(1); 
	self.logoText.alpha = 1; 
	self.logoText setText("^2<< ^3Thanks to : Blade, Wingzor, Xenon, Poyser ^2>>"); 
	wait 9; 
	self.logoText fadeOverTime(1); 
	self.logoText.alpha = 0; 
	wait 1; 
	
	while (1)
	{
	    wait 9;
	    iPrintLn("^1>> ^7mp_deathrun_underworld");
		wait 9;
	    iPrintLn("^1>> ^7Map made by Icomar");
		wait 9;
		iPrintLn("^1>> ^7Additional help : Blade");
		wait 9;
		iPrintLn("^1>> ^7Thanks to : Blade, Wingzor, Xenon, Poyser");
		wait 9;
	}
}

sniper_ammo()
{
    trigger = getEnt ("sniper_get_ammo", "targetname");
	
	while(1)
	{
	    trigger waittill ("trigger", player );
		wait 0.5;
        player giveMaxAmmo( "remington700_mp" );
		player giveMaxAmmo( "m40a3_mp" );
		wait 0.5;
		player iPrintLn("^2<< ^7You got ammo");
		wait 3;
	}
}