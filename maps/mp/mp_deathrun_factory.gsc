main()
{
	maps\mp\_load::main();
	maps\mp\_compass::setupMiniMap("compass_map_mp_creek");

	
	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

setDvar("bg_falldamagemaxheight", 99999);
setDvar("bg_falldamageminheight", 99998);

thread sr\api\_map::createSpawn((16,61,123), 360);
thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_speedrun::createEndMap((711.656, -1468.41, 136.125), 100, 60, "normal_0");

thread elevator_port_end();
      jumpPads = getEntArray( "jump_pad1", "targetname" );
    for( i = 0; i < jumpPads.size; i++ )
        jumpPads[i] thread MonitorTrigger();
		

		
		       jumpPads = getEntArray( "jump_pad2", "targetname" );
    for( i = 0; i < jumpPads.size; i++ )
        jumpPads[i] thread MonitorTrigger();

		//Sniper Duel AKA Heaven
		       jumpPads = getEntArray( "jump_pad_bridge", "targetname" );
    for( i = 0; i < jumpPads.size; i++ )
        jumpPads[i] thread MonitorTrigger();
		
		       jumpPads = getEntArray( "jump_pad_small_island", "targetname" );
    for( i = 0; i < jumpPads.size; i++ )
        jumpPads[i] thread MonitorTrigger();
		
}

jump_teleport()
{
	
	precacheShader("white");
	
	waittillframeend;
	
	setdvar( "sv_cheats", 1 );
	setdvar( "bg_falldamagemaxheight", 9999 );
	setdvar( "bg_falldamageminheight", 9998 );
    	setdvar( "sv_cheats", 0 );
	
	for(;;)
	{
	
	waittillframeend;
	
	trigger = getent( "jump_trigger", "targetname" );
	trigger waittill( "trigger", player );
	
	jump_teleport_trigger( player );
	
	}
	
}

 jump_teleport_trigger( player )
{
	
	flash = undefined;
	
	
	flash = newClientHudElem( player );
	flash.x = 0;
	flash.y = 0;
	flash setshader ("white", 640, 480);
	flash.alignX = "left";
	flash.alignY = "top";
	flash.horzAlign = "fullscreen";
	flash.vertAlign = "fullscreen";
	flash.color = ( .16, .38, .5 );
	flash.alpha = .75;
	
	flash fadeOverTime( 0.75 );
	
	wait( 0.10 );
	
	flash.alpha = 0;
	flash fadeOverTime( 0.75 );
	player suicide();
	
}

rotate_prop_jumppad()
{
  rotate_obj = getentarray("jumppad_platform","targetname");
  if(isdefined(rotate_obj))
  {
   for(i=0;i<rotate_obj.size;i++)
   {
    rotate_obj[i] thread ra_rotate_prop_jumppad();
	
   }
  }
}
 
ra_rotate_prop_jumppad()
{
  if (!isdefined(self.speed))
   self.speed = 10;
  if (!isdefined(self.script_noteworthy))
   self.script_noteworthy = "z";
 
  while(true)
  {
  trigger = getent("jumppad_trigger", "targetname");
  trigger waittill ("trigger",user);
  
  // rotateYaw(float rot, float time, <float acceleration_time>, <float deceleration_time>);
   if (self.script_noteworthy == "z")
    self rotateYaw(-80,0.4);
   else if (self.script_noteworthy == "x")
    self rotateRoll(-80,0.4);
   else if (self.script_noteworthy == "y")
    self rotatePitch(-80,0.4);
	self waittill("rotatedone");
	wait 2;
	   if (self.script_noteworthy == "z")
    self rotateYaw(80,self.speed);
   else if (self.script_noteworthy == "x")
    self rotateRoll(80,self.speed);
   else if (self.script_noteworthy == "y")
    self rotatePitch(80,self.speed);
  self waittill("rotatedone");
  }
}

monitorTrigger()
{
    while(1)
    {
        self waittill( "trigger", player );
        if( isPlayer( player ) && isAlive( player ) )
            player thread Boost( Int( self.script_noteworthy ) );
    }
}

Boost( damage )
{
	oldhp = self.health;
	self setClientDvars( "bg_viewKickMax", 0, "bg_viewKickMin", 0, "bg_viewKickRandom", 0, "bg_viewKickScale", 0 );
    eInflictor = self;
    eAttacker = self;
    iDamage = damage;
    iDFlags = 0;
    sMeansOfDeath = "MOD_PROJECTILE";
    sWeapon = "rpg_mp";
    vPoint = ( self.origin + (0,0,-1) );
    vDir = vectornormalize( self.origin - vPoint );
    sHitLoc = "none";
    psOffsetTime = 0;

    self.health += iDamage;
    self finishPlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );
	self setClientDvars( "bg_viewKickMax", 90, "bg_viewKickMin", 5, "bg_viewKickRandom", 0.4, "bg_viewKickScale", 0.2 );
	self.health = oldhp;
	wait 3;
}


elevator_port_end()
{
  end = getent ("port_end", "targetname");
  begin = getent ("port_begin", "targetname");

  end delete();
  begin delete();

}

