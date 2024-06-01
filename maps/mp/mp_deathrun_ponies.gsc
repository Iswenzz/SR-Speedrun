main()
{

/*
MAP CREATED AND SCRIPTED BY CHUBBS317
*/

maps\mp\_load::main();

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
setdvar("compassmaxrange","1800");

 thread sr\api\_speedrun::createNormalWays("Normal Way;");
 thread sr\api\_map::createSpawn((-92, -1, 60), 360);
 thread sr\api\_speedrun::createEndMap((7682.99, -337.483, 352.125), 300, 100);

	thread start_door();
	thread floor_deleter();
	thread teleport();
	thread mover();
}


floor_deleter()
{
floor = getent ("floor", "targetname");

floor movez (-8000, 0.1);
}

teleport()
{
	entTransporter = getentarray( "enter", "targetname" );
	if(isdefined(entTransporter))
		for( i = 0; i < entTransporter.size; i++ )
			entTransporter[i] thread transporter();
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

start_door()
{

door = getent ("start_door", "targetname");
doorb = getent ("door_b", "targetname");
doorc = getent ("door_c", "targetname");
doord = getent ("door_d", "targetname");
doore = getent ("door_e", "targetname");
doorf = getent ("door_f", "targetname");
doorg = getent ("door_g", "targetname");
doorm = getent ("door_m", "targetname");
doorl = getent ("door_l", "targetname");
doorh = getent ("door_h", "targetname");
doorj = getent ("door_j", "targetname");
doork = getent ("door_k", "targetname");


door delete();
doorb delete();
doord delete();
doore delete();
doorf delete();
doorg delete();
doorm delete();
doorl delete();
doorh delete();
doorj delete();
doork delete();

}

mover()
{

doora = getent ("door_o", "targetname");
doorb = getent ("door_p", "targetname");
doorc = getent ("door_c", "targetname");
doori = getent("door_i", "targetname");


doora moveX (-100, 0.1);
doorb moveX (-100, 0.1);
doorc moveX (-600, 0.1);
doori movez( -125, 0.1 );


}