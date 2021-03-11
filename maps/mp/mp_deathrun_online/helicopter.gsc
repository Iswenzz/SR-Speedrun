main()
{

	thread Helicopter();

}

Helicopter()
{
	trigger = getEnt( "trigger_helicopter", "targetname" );
	
	while(1)
	{
		trigger waittill( "trigger", player );
		player thread StartHelicopter();
		break;
	}
}

StartHelicopter()
{	
	if( !isDefined( self ) || !isAlive( self ) || !isPlayer( self ) )
		return;
	
	path = [];
	orig = getEntArray();
	if( self.pers["team"] == "allies" )
	{
		start = getEnt( "orig_heli_jumper_spawn", "targetname" );
		for(i=0;i<orig.size;i++)
		{
			if( isDefined( orig[i].targetname ) && IsSubStr( orig[i].targetname, "orig_heli_jumper"+path.size ) )
			{
				path[path.size] = orig[i];
				path[path.size-1].waittime = int( strTok( orig[i].targetname, "_" )[3] );
				iPrintln( "acted" );
			}
		}
	}
	else
	{
		wait 1;
	}
	
	start = getEnt( "orig_heli_jumper_spawn", "targetname" );
	chopper = spawn_helicopter( self, start.origin, start.angles, "cobra_mp", "vehicle_blackhawk" );
	wait 0.05;
	chopper.owner = self;
	chopper playLoopSound( "mp_cobra_helicopter" );
	chopper.linker = Spawn( "script_model", chopper GetTagOrigin( "tag_guy4" )-(0,0,20) );
	chopper.linker LinkTo( chopper );
	chopper setDamageStage( 3 );
	chopper setCanDamage( 1 );
	chopper.maxhealth = 5000;
	chopper.health = chopper.maxhealth;
	chopper setSpeed( 20, 15 );
	chopper setYawSpeed( 50, 20, 20 );
	chopper SetMaxPitchRoll( 30, 30 );
	chopper setNearGoalNotifyDist( 96 );
	chopper endon( "crashed" );
	
	pathnum = 0;
	
	self setOrigin( chopper.linker.origin );
	self LinkTo( chopper.linker );
	self.maxhealth = 300;
	self.health = self.maxhealth;
	
	chopper setVehGoalPos( (-2448,-1800,1184), true );
	chopper waittill("goal");
		
	chopper setVehGoalPos( (-1456,-1384,976), true );
	chopper waittill("goal");
	
	chopper setVehGoalPos( (-1104,-280,720), true );
	chopper waittill("goal");
	wait 1;
	
	chopper setVehGoalPos( (656,-1432,656), true );
	chopper waittill("goal");
	wait 5;
	
	chopper setVehGoalPos( (1600,-936,768), true );
	chopper waittill("goal");
	wait 8;
	
	chopper setVehGoalPos( (1264,56,800), true );
	chopper waittill("goal");
	wait 3;
	
	chopper setVehGoalPos( (2448,-56,624), true );
	chopper waittill("goal");
	wait 9;
	
	chopper setVehGoalPos( (3760,1592,832), true );
	chopper waittill("goal");
	wait 7;
	
	chopper setVehGoalPos( (2672,2712,544), true );
	chopper waittill("goal");
	wait 6;
	
	chopper setVehGoalPos( (480,1640,912), true );
	chopper waittill("goal");
	wait 9;
	
	chopper setVehGoalPos( (-1024,2472,512), true );
	chopper waittill("goal");
	
	self Unlink( chopper.linker );
	
	chopper setVehGoalPos( (-896,2200,592), true );
	chopper waittill("goal");

	if( !isDefined( self ) || !isAlive( self ) )
		chopper notify( "damage", 3000, undefined );
}

spawn_helicopter( owner, origin, angles, model, targetname )
{
	chopper = spawnHelicopter( owner, origin, angles, model, targetname );
	return chopper;
}