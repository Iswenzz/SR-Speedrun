main()
{
trigger = spawn( "trigger_radius", (-1095.76, -2331.43, 643.575), 0, 96, 48 );
trigger.targetname = "endmap_trig";
trigger.radius = 96;
	maps\mp\_load::main();
	
	
	setExpFog(500, 2200, 0.81, 0.75, 0.63, 0.5);
	
	
	precacheItem("m40a3_mp");
	precacheItem("remington700_mp");
	precacheItem("ak74u_mp");
	precacheItem("deserteaglegold_mp");	
	
	
	//ambientPlay("ambient1");
	
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	
		
	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	
	rotateplanksz = getentarray("rotatestickz","targetname");
	for(i=0;i<rotateplanksz.size;i++)
		rotateplanksz[i] delete();
	
	twisterparts = getentarray("trap_twisters","targetname");
	for(i=0;i<twisterparts.size;i++)
		twisterparts[i] delete();
	
	thread way_connect();
	thread startdoor();
	thread startdoor2();
	// thread trap_4squares();
	// thread trap_pusher();
	// thread platform_pusher();
	// thread trap_spikes_left();
	// thread trap_spikes_right();
	// thread trap_lifter();
	thread secondfloor();
	// thread finaldoors();
	thread startact();
	// thread hardlevel();
	// thread finaldoor();
	// thread teleportsniperroom();
	// thread takeguns();
	// thread trap_floor();
	thread teleportjump();
	thread jumperrespawn();
	thread jumperrespawn_bouncer();
	thread jumproomright();
	thread jumproomleft();
	thread jumproommid();
	thread jump_teleport_fail2();
	thread jump_teleport_fail();
	thread secretroom_unlock();
	thread secretroom_teleport();
	thread secretroom_teleport_back();
	thread secretroom_teleport_fail();
	thread secretroom_teleport_fail3();
	thread secretroom_teleport_fail4();
	thread secretroom_teleport_fail2();
	thread secretroom_teleport_fail5();
	thread secretroom_teleport_fail6();
	thread secretroom_teleport_fail7();
	thread jump_teleport_end();
	thread jumperendclip();
	thread unlock_door();
	thread sr_tp();
	
}

sr_tp()
{
	ori = spawn("script_origin",(634,352,761));
	ori.angles = (0,270,0);
	trig = spawn("trigger_radius",(639,550,24),0,150,100);
	trig.radius = 150;
	wait 1;
	thread sr\api\_map::createTriggerFx(trig, "red");

	for(;;)
	{
		trig waittill("trigger",player);
		player thread safe_tp(ori);
	}
}

safe_tp(ori)
{
	self endon("death");
	self endon("disconnect");

	self setOrigin(ori.origin);
	self setplayerangles(ori.angles);
	self freezecontrols(1);
	wait 0.05;
	self freezecontrols(0);
}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    sr\api\_speedrun::createNormalWays("Normal Way;");
	sr\api\_speedrun::createSecretWays("Secret Way;");
	
    for(;;)
    {
        level waittill( "connected", player );

    }
}
////////////////////////////////////////////////////////////////////////////////////////////////

startact()
{
door=getent("startact","targetname");
door delete();
}

startdoor()
{
door=getent("startdoor","targetname");
door delete();
}

startdoor2()
{
door2=getent("startdoor2","targetname");
door2 delete();
}
	
rotateplanks_always()
{
if (!isdefined(self.speed))
 self.speed = 2;
if (!isdefined(self.script_noteworthy))
 self.script_noteworthy = "y";
while(true)
{
wait(0.05);
 // rotateYaw(float rot, float time, <float acceleration_time>, <float deceleration_time>);
 if (self.script_noteworthy == "z")
  self rotateYaw(360,self.speed);
 else if (self.script_noteworthy == "x")
  self rotateRoll(360,self.speed);
 else if (self.script_noteworthy == "y")
  self rotatePitch(360,self.speed);
 wait ((self.speed)-0.1); // removes the slight hesitation that waittill("rotatedone"); gives.
 // self waittill("rotatedone");
}
}


trap_4squares()
{
}



trap_pusher()
{

}

trap_rollers()
{

}

platform_pusher()
{
platform=getent("movingplatform_pusher","targetname");
while(1)
{
wait(0.05);
platform movey(-540,5,0.5,4.5);
platform waittill ("movedone");
wait (2);
platform movey(540,5,0.5,4.5);
platform waittill ("movedone");
} 
}

trap_spikes_left()
{

}

trap_spikes_right()
{

}



trap_lifter()
{

}

finaldoors()
{
trigger = getEnt("finaldoors", "targetname");
trigger waittill("trigger", player);
// iPrintLnBold(player.name+ "^4 has reached the finaldoors"); //Change the message if you want
}

secondfloor()
{
trigger = getEnt("secondfloor", "targetname");
trigger waittill("trigger", player);
// iPrintLnBold(player.name+ "^2 has reached the second floor"); //Change the message if you want
}

trap_twister()
{

}

teleportsniperroom()
{
}

takeguns()
{
}

trap_floor()
{

}

teleportjump()
{
}

jumperrespawn()
{
}

jumperrespawn_bouncer()
{
}

jumproomleft()
{
}

jumproommid()
{
}

jumproomright()
{
}

unlock_door()
{
}

secretroom_unlock()
{
platform = getEnt("secretroom_teleport_link","targetname");
teleporter = getEnt("secretroom_teleporter", "targetname");
teleporter EnableLinkTo();
teleporter LinkTo(platform);

platform movez(384,1);
platform waittill("movedone");
}

secretroom_teleport()
{
teleporter = getEnt("secretroom_teleporter", "targetname");
secret = getEnt("secretroom_teleporter_origin", "targetname");
for(;;)
{
teleporter waittill("trigger", player);
player SetOrigin( secret.origin );
player setplayerangles( secret.angles );
player sr\api\_speedrun::changeWay("secret_0"); //Speedrun Copy Paste
}
}

secretroom_teleport_back()
{
teleporter = getEnt("secretroom_teleporter_back", "targetname");
secret = getEnt("secretroom_teleporter_back_origin", "targetname");
for(;;)
{
teleporter waittill("trigger", player);
player SetOrigin( secret.origin );
player setplayerangles( secret.angles );
}
}

secretroom_teleport_fail()
{
teleporter = getEnt("secretroom_teleport_fail", "targetname");
secret = getEnt("secretroom_teleporter_origin", "targetname");
for(;;)
{
teleporter waittill("trigger", player);
player SetOrigin( secret.origin );
player setplayerangles( secret.angles );
}
}

secretroom_teleport_fail2()
{
teleporter = getEnt("secretroom_teleport_fail2", "targetname");
secret = getEnt("secretroom_teleporter_origin2", "targetname");
for(;;)
{
teleporter waittill("trigger", player);
player SetOrigin( secret.origin );
player setplayerangles( secret.angles );
}
}

secretroom_teleport_fail3()
{
teleporter = getEnt("secretroom_teleport_fail3", "targetname");
secret = getEnt("secretroom_teleporter_origin3", "targetname");
for(;;)
{
teleporter waittill("trigger", player);
player SetOrigin( secret.origin );
player setplayerangles( secret.angles );
}
}

secretroom_teleport_fail4()
{
teleporter = getEnt("secretroom_teleport_fail4", "targetname");
secret = getEnt("secretroom_teleporter_origin4", "targetname");
for(;;)
{
teleporter waittill("trigger", player);
player SetOrigin( secret.origin );
player setplayerangles( secret.angles );
}
}

secretroom_teleport_fail5()
{
teleporter = getEnt("secretroom_teleport_fail5", "targetname");
secret = getEnt("secretroom_teleporter_origin5", "targetname");
for(;;)
{
teleporter waittill("trigger", player);
player SetOrigin( secret.origin );
player setplayerangles( secret.angles );
}
}

secretroom_teleport_fail6()
{
teleporter = getEnt("secretroom_teleport_fail6", "targetname");
secret = getEnt("secretroom_teleporter_origin6", "targetname");
for(;;)
{
teleporter waittill("trigger", player);
player SetOrigin( secret.origin );
player setplayerangles( secret.angles );
}
}

secretroom_teleport_fail7()
{
teleporter = getEnt("secretroom_teleport_fail7", "targetname");
secret = getEnt("secretroom_teleporter_origin7", "targetname");
for(;;)
{
teleporter waittill("trigger", player);
player SetOrigin( secret.origin );
player setplayerangles( secret.angles );
}
}

jump_teleport_fail()
{
teleporter = getEnt("jumpergame_activator_fail", "targetname");
resp = getEnt("actrespawn", "targetname");
for(;;)
{
teleporter waittill("trigger", player);
player SetOrigin( resp.origin );
player setplayerangles( resp.angles );
}
}

jump_teleport_fail2()
{
teleporter = getEnt("jumpergame_activator_fail2", "targetname");
fail2 = getEnt("jumpergame_activator_fail2_origin", "targetname");
for(;;)
{
teleporter waittill("trigger", player);
player SetOrigin( fail2.origin );
player setplayerangles( fail2.angles );
}
}

jump_teleport_end()
{
teleporter = getEnt("jumpergame_activator_end", "targetname");
secret = getEnt("jumpergame_activator_end_origin", "targetname");
for(;;)
{
teleporter waittill("trigger", player);
player SetOrigin( secret.origin );
player setplayerangles( secret.angles );
}
}


jumperendclip()
{
}





