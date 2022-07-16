main()
{
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

    thread speedrun\_way_name::create_spawn((4411,1,-2034),360);
    thread speedrun\_way_name::create_normal_way("Normal Way;");
    thread speedrun\_way_name::create_secret_way("Secret Way;");
	thread speedrun\_way_name::create_tp((16382.5, -3.26039, -4794.3), 65, 10, (17253, 4, -2011), 360, "freeze", "yellow", "ns0");
	thread speedrun\_way_name::create_tp((4414.27, 405.18, -2093.88), 65, 10, (-991, -1848, -1545), 90, "freeze", "blue", "s0");
	thread speedrun\_way_name::create_endmap((22306.4, 6668.72, -2815.38), 100, 10, "ns0");
	thread speedrun\_way_name::create_endmap((16041.3, 156.583, -7749.87), 265, 10, "s0");

	thread start_button();

	thread lawnmover1();
	thread lawnmover2();
	thread lawnmover3();
	thread lawnmover4();
	thread lawnmover5();
	thread lawnmover6();

	thread high_mover();

	thread banana();
	
	thread s_fail1();
	thread s_fail2();
	thread s_fail3();
	thread s_fail4();
	thread s_fail5();
	thread s_fail6();
}

start_button()
{
wall = getent("start_wall","targetname");
object1 = getent("start_flipper1","targetname");
object2 = getent("start_flipper2","targetname");
  
wait 0.1;
wall delete();
object1 delete();
object2 delete();  
}

lawnmover1()
{
object1 = getent("lawnmover1","targetname");
killtrig1 = getent ("killtrig1" , "targetname");
killtrig1 enablelinkto ();
killtrig1 linkto (object1);

wait 0.1;
object1 delete();
killtrig1 delete();
}

lawnmover2()
{
object1 = getent("lawnmover2","targetname");
killtrig1 = getent ("killtrig2" , "targetname");
killtrig1 enablelinkto ();
killtrig1 linkto (object1);

wait 0.1;
object1 delete();
killtrig1 delete();
}

lawnmover3()
{
object1 = getent("lawnmover3","targetname");
killtrig1 = getent ("killtrig3" , "targetname");
killtrig1 enablelinkto ();
killtrig1 linkto (object1);

wait 0.1;
object1 delete();
killtrig1 delete();
}

lawnmover4()
{
object1 = getent("lawnmover4","targetname");
killtrig1 = getent ("killtrig4" , "targetname");
killtrig1 enablelinkto ();
killtrig1 linkto (object1);

wait 0.1;
object1 delete();
killtrig1 delete();
}

lawnmover5()
{
object1 = getent("lawnmover5","targetname");
killtrig1 = getent ("killtrig5" , "targetname");
killtrig1 enablelinkto ();
killtrig1 linkto (object1);

wait 0.1;
object1 delete();
killtrig1 delete();
}

lawnmover6()
{
object1 = getent("lawnmover6","targetname");
killtrig1 = getent ("killtrig6" , "targetname");
killtrig1 enablelinkto ();
killtrig1 linkto (object1);

wait 0.1;
object1 delete();
killtrig1 delete();
}

high_mover()
{
mover = getent ("high_mover","targetname");

wait 0.1;
mover delete();

}

banana()
{
banana = getEnt ("banana","targetname");

wait 0.1;
banana delete();
}


s_fail1()
{
	trig = getEnt ("s_fail1", "targetname");
	end = getEnt ("s_fail1_go", "targetname");
	while(1)
    {
    trig waittill ("trigger", player);          
	player SetOrigin(end.origin);
    player SetPlayerAngles( end.angles );
	}
}

s_fail2()
{
	trig = getEnt ("s_fail2", "targetname");
	end = getEnt ("s_fail2_go", "targetname");
	while(1)
    {
    trig waittill ("trigger", player);          
	player SetOrigin(end.origin);
    player SetPlayerAngles( end.angles );
	}
}

s_fail3()
{
	trig = getEnt ("s_fail3", "targetname");
	end = getEnt ("s_fail3_go", "targetname");
	while(1)
    {
    trig waittill ("trigger", player);          
	player SetOrigin(end.origin);
    player SetPlayerAngles( end.angles );
	}
}

s_fail4()
{
	trig = getEnt ("s_fail4", "targetname");
	end = getEnt ("s_fail4_go", "targetname");
	while(1)
    {
    trig waittill ("trigger", player);          
	player SetOrigin(end.origin);
    player SetPlayerAngles( end.angles );
	}
}

s_fail5()
{
	trig = getEnt ("s_fail5", "targetname");
	end = getEnt ("s_fail5_go", "targetname");
	while(1)
    {
    trig waittill ("trigger", player);          
	player SetOrigin(end.origin);
    player SetPlayerAngles( end.angles );
	}
}

s_fail6()
{
	trig = getEnt ("s_fail6", "targetname");
	end = getEnt ("s_fail6_go", "targetname");
	while(1)
    {
    trig waittill ("trigger", player);          
	player SetOrigin(end.origin);
    player SetPlayerAngles( end.angles );
	}
}