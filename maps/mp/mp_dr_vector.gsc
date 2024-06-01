main()
{
	maps\mp\_load::main();
 
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".18");
	setdvar( "r_specularcolorscale", "2.4877" );
	setdvar("compassmaxrange","1200");

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_map::createSpawn((-512, -856, 580), 90);
	thread sr\api\_speedrun::createEndMap((-508.719, -2473.45, -2398.88), 245, 100);
    
	thread burn();
	thread burn2();
	thread t1();
	thread t2();
	thread t3();
	thread t4();
    thread t9_1();
	thread t9_2();
	thread t9_3();

}
burn()
{
 	trig = getent ("burn","targetname");

	for(;;)
	{
    trig waittill ("trigger",player);
	 
	player Suicide();
    }   
	 
}

burn2()
{
 	trig = getent ("burn2","targetname");

	for(;;)
	{
    trig waittill ("trigger",player);
	 
	player Suicide();
    }
	 
}


t1()
{
 	b = getent ("las_brush1","targetname");
	t = getent ("las_hurt1","targetname");
	
    b delete();
	t delete();

 }
 t2()
{
 	b = getent ("las_brush2","targetname");
	t = getent ("las_hurt2","targetname");
	
    b delete();
	t delete();
 }
 t3()
{
 	b = getent ("las_brush3","targetname");
	t = getent ("las_hurt3","targetname");
	
	b delete();
	t delete();
 }
 t4()
{
 	b = getent ("las_brush4","targetname");
	t = getent ("las_hurt4","targetname");
	
	b delete();
	t delete();
 }

t9_1()
{
    t1 = getEnt( "t1", "targetname");
	t2 = getEnt( "t2", "targetname");
	t3 = getEnt( "t3", "targetname");
	t4 = getEnt( "t4", "targetname");
	b1 = getEnt( "b1", "targetname");
	b2 = getEnt( "b2", "targetname");
	b3 = getEnt( "b3", "targetname");
	b4 = getEnt( "b4", "targetname");
	l1 = getEnt( "l1", "targetname" );
	l2 = getEnt( "l2", "targetname" );
	l3 = getEnt( "l3", "targetname" );
	l4 = getEnt( "l4", "targetname" );
	
    t1 delete();
	t2 delete();
	t3 delete();
	t4 delete();
	b1 delete();
	b2 delete();
	b3 delete();
	b4 delete();
	l1 delete();
	l2 delete();
	l3 delete();
	l4 delete();
}

t9_2()
{
	t5 = getEnt( "t5", "targetname");
	t6 = getEnt( "t6", "targetname");
	t7 = getEnt( "t7", "targetname");
	t8 = getEnt( "t8", "targetname");
	b5 = getEnt( "b5", "targetname");
	b6 = getEnt( "b6", "targetname");
	b7 = getEnt( "b7", "targetname");
	b8 = getEnt( "b8", "targetname");
	l5 = getEnt( "l5", "targetname" );
	l6 = getEnt( "l6", "targetname" );
	l7 = getEnt( "l7", "targetname" );
	l8 = getEnt( "l8", "targetname" );


	t5 delete();
	t6 delete();
	t7 delete();
	t8 delete();
	b5 delete();
	b6 delete();
	b7 delete();
	b8 delete();
	l5 delete();
	l6 delete();
	l7 delete();
	l8 delete();
}

t9_3()
{
	t9 = getEnt( "t9", "targetname");
	t10 = getEnt( "t10", "targetname");
	t11 = getEnt( "t11", "targetname");
	b9 = getEnt( "b9", "targetname");
	b10 = getEnt( "b10", "targetname");
	b11 = getEnt( "b11", "targetname");
	l9 = getEnt( "l9", "targetname" );
	l10 = getEnt( "l10", "targetname" );
	l11 = getEnt( "l11", "targetname" );


	t9 delete();
	t10 delete();
	t11 delete();
	b9 delete();
	b10 delete();
	b11 delete();
	l9 delete();
	l10 delete();
	l11 delete();
}