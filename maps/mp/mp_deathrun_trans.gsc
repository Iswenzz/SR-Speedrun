main()
{
maps\mp\_load::main();

	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";
	
	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");
	setDvar("bg_falldamagemaxheight", 20000 );
	setDvar("bg_falldamageminheight", 15000 );

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_map::createSpawn((57, -5,-132), 0);
	thread sr\api\_speedrun::createEndMap((2685.57, -7023.23, -383.8755), 220, 100);
	

	thread start();
	thread tele2();
	thread tele3();
	thread tele4();
	thread doors();
	thread tele7();
	thread auto();
	thread auto2();
}

start()
{
	d = getEnt("start_door", "targetname");

	
	d delete();
}

auto()
{
b = getEnt( "auto_mover", "targetname" );


 b moveX(-200,0.1);
 b waittill("movedone");
 b rotateYaw(90,0.1);
 
 }

tele2()
{
	entTransporter = getentarray( "enter2", "targetname" );
	if(isdefined(entTransporter))
		for( i = 0; i < entTransporter.size; i++ )
			entTransporter[i] thread transporter2();
}
 
transporter2()
{
	for(;;)
	{
		self waittill( "trigger", player );
		entTarget = getEnt( self.target, "targetname" );
		
		player setOrigin( entTarget.origin );
		player setplayerangles( entTarget.angles );
        player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
		
	}
}

tele3()
{
	entTransporter = getentarray( "enter3", "targetname" );
	if(isdefined(entTransporter))
		for( i = 0; i < entTransporter.size; i++ )
			entTransporter[i] thread transporter3();
}
 
transporter3()
{
	for(;;)
	{
		self waittill( "trigger", player );
		entTarget = getEnt( self.target, "targetname" );
	
		
		player setOrigin( entTarget.origin );

		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);

	}
}

tele4()
{
	entTransporter = getentarray( "enter4", "targetname" );
	if(isdefined(entTransporter))
		for( i = 0; i < entTransporter.size; i++ )
			entTransporter[i] thread transporter4();
}
 
transporter4()
{
  num=0;
	for(;;)
	{
		self waittill( "trigger", player );
		entTarget = getEnt( self.target, "targetname" );
		
		player setOrigin( entTarget.origin );
		player setplayerangles( entTarget.angles );  
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);        
	}			

}


doors()
{
	entTransporter = getentarray( "tel", "targetname" );
	if(isdefined(entTransporter))
		for( i = 0; i < entTransporter.size; i++ )
			entTransporter[i] thread transporter6();
}
 
transporter6()
{
	for(;;)
	{
		self waittill( "trigger", player );
		entTarget = getEnt( self.target, "targetname" );
	
		player setOrigin( entTarget.origin );
		player setplayerangles( entTarget.angles );
	    player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}

tele7()
{
	entTransporter = getentarray( "tele5", "targetname" );
	if(isdefined(entTransporter))
		for( i = 0; i < entTransporter.size; i++ )
			entTransporter[i] thread transporter7();
}
 
transporter7()
{
	for(;;)
	{
		self waittill( "trigger", player );
		entTarget = getEnt( self.target, "targetname" );
		
		player setOrigin( entTarget.origin );
		player setplayerangles( entTarget.angles );
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
		
	
      

	}
}

auto2()
{
    b1 = getEnt( "auto2", "targetname" );
	b2 = getEnt( "auto4", "targetname" );
	b = getEnt( "auto3", "targetname" );

 b1 movey(1216,0.1);
 b moveY(600,0.1);

 }