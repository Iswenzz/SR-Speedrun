main()
{
	maps\mp\_load::main();

	setExpFog(0, 75000, 0.15, 0.15, 0.15, 0);
	
	//////Game//////
	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";
	
	//////Dvars//////
	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_map::createSpawn((112, -715, 32), 360);

	thread teleporter_thread();
	thread start_door();
	thread start_brush();
	thread door_one();

}

teleporter_thread()
{

	entTransporter= getentarray("teleport","targetname");
	if(isdefined(entTransporter))
 
		{
			for(lp=0; lp<entTransporter.size;lp=lp+1)
			entTransporter [lp] thread teleporter();
		}
}

teleporter()
{
  for(;;)
  {
    self waittill("trigger",other);
    entTarget = getent(self.target, "targetname");

    other setorigin(entTarget.origin);
    other setplayerangles(entTarget.angles);
    wait(0.10);

   }
}

start_door()
{
trig = getEnt("start_door_trigger","targetname");
brush = getEnt("start_door_brush","targetname");
efx1 = getEnt("start_door_origin1","targetname");
efx2 = getEnt("start_door_origin2","targetname");

brush delete();

}

start_brush()
{
trig = getEnt("start_bursh_trigger","targetname");
brush = getEnt("start_bursh_block","targetname");
model = getEnt("start_bursh_model","targetname");
orgy = getEnt("start_bursh_origin","targetname");


model delete();
brush delete();
	
}

door_one()
{
trig=getent("build_door_trigger","targetname");	
brush=getent("build_door_brush","targetname");	
	

brush delete();

}