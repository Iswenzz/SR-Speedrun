main()
{
	maps\mp\_load::main();
	
	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_map::createSpawn((1285, 1380, 188), 360);
	thread sr\api\_speedrun::createEndMap((10623.5, -338.977, -391.875), 120, 100);
	
	thread disableHurt();
	thread door_slider();
	thread mine();
	thread teleporter0();
	thread teleporter();
	thread teleporter2();
	thread teleporter3();
	
	
}

disableHurt()
{
    triggers = getEntArray("trigger_hurt", "classname");
    for (i = 0; i < triggers.size; i++)
        triggers[i] delete();
}

door_slider() 
{ 
	door = getent( "rollerdoor", "targetname" ); 
	brush1 = getEnt( "door123", "targetname" );
	radi1 = getEnt( "radi1", "targetname" );
	radi2 = getEnt( "radi2", "targetname" );
 
	
	door delete();
	brush1 delete();
	radi1 delete();
	radi2 delete();
	
}

mine()
{
	mine = getEntArray( "minefield", "targetname" );

    mine[0] delete();
	mine[1] delete();
	mine[2] delete();
	mine[3] delete();
	mine[4] delete();
	mine[5] delete();
	mine[6] delete();
	mine[7] delete();
	mine[8] delete();
	mine[9] delete();


}

teleporter0()
{
	entTransporter = getentarray( "enter", "targetname" );
 
	if(isdefined(entTransporter))
	{
		for( i = 0; i < entTransporter.size; i++ )
			entTransporter[i] thread transporter0();
	}
}
 
transporter0()
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

teleporter()
{
	entTransporter = getentarray( "enter4", "targetname" );
 
	if(isdefined(entTransporter))
	{
		for( i = 0; i < entTransporter.size; i++ )
			entTransporter[i] thread transporter();
	}
}
 
transporter()
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

teleporter2()
{
	entTransporter = getentarray( "enter6", "targetname" );
 
	if(isdefined(entTransporter))
	{
		for( i = 0; i < entTransporter.size; i++ )
			entTransporter[i] thread transporter2();
	}
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

teleporter3()
{
	entTransporter = getentarray( "rain112", "targetname" );
 
	if(isdefined(entTransporter))
	{
		for( i = 0; i < entTransporter.size; i++ )
			entTransporter[i] thread transporter3();
	}
}
 
transporter3()
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
