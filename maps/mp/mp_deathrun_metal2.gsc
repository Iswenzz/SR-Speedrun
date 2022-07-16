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
      	
    thread speedrun\_way_name::create_spawn((-80,19,76),180);
    thread speedrun\_way_name::create_normal_way("Normal Way;");

	thread start();
	thread trap2();
	thread trap34();
	thread trap7();
	thread trap8();

}

start()
{
door  =getent( "main_door", "targetname" );
door1  =getent( "door1", "targetname" );
door2  =getent( "door2", "targetname" );
door3  =getent( "door3", "targetname" );
door4  =getent( "door4", "targetname" );
door5  =getent( "door5", "targetname" );

wait 0.1;

door delete();
door1 delete();
door2 delete();
door3 delete();
door4 delete();
door5 delete();
	
}

trap2()
{
trap1  =getent("trap2_1","targetname");
trap2  =getent("trap2_2","targetname");
trap3  =getent("trap2_3","targetname");
trap4  =getent("trap2_4","targetname");
trap5  =getent("trap2_5","targetname");
trap6  =getent("trap2_6","targetname");
floor =getent("trap2_floor", "targetname");
dmg1  =getent("trap2_dmg1","targetname");
dmg2  =getent("trap2_dmg2","targetname");
dmg3  =getent("trap2_dmg3","targetname");
dmg4  =getent("trap2_dmg4","targetname");
dmg5  =getent("trap2_dmg5","targetname");
dmg6  =getent("trap2_dmg6","targetname");	

wait 0.1;

floor moveX(-384,0.1);
trap1 delete();
trap2 delete();
trap3 delete();
trap4 delete();
trap5 delete();
trap6 delete();
dmg1 delete();
dmg2 delete();
dmg3 delete();
dmg4 delete();
dmg5 delete();
dmg6 delete();
		
}

trap34()
{
trap  =getent("trap3","targetname");
dmg1 =getent("dmg_trap3","targetname");	
dmg2 =getent("dmg_trap4","targetname");

wait 0.1;

trap delete();
dmg1 delete();
dmg2 delete();
		
}

trap7()
{
trap  =getent("trap7","targetname");
dmg  =getent("trap7_dmg","targetname");
model1  =getent("trap7_model1","targetname");
model2  =getent("trap7_model2","targetname");
model3  =getent("trap7_model3","targetname");
model4  =getent("trap7_model4","targetname");
model5  =getent("trap7_model5","targetname");
model6  =getent("trap7_model6","targetname");

trap delete();
dmg delete();
model1 delete();
model2 delete();
model3 delete();
model4 delete();
model5 delete();
model6 delete();

}

trap8()
{
barrel1 =getent("trap8_1","targetname");
barrel2 =getent("trap8_2","targetname");
barrel3 =getent("trap8_3","targetname");
barrel4 =getent("trap8_4","targetname");
barrel5 =getent("trap8_5","targetname");
barrel6 =getent("trap8_6","targetname");
barrel7 =getent("trap8_7","targetname");
barrel8 =getent("trap8_8","targetname");
barrel9 =getent("trap8_9","targetname");
barrel10 =getent("trap8_10","targetname");
barrel11 =getent("trap8_11","targetname");
barrel12 =getent("trap8_12","targetname");
barrel13 =getent("trap8_13","targetname");
barrel14 =getent("trap8_14","targetname");
barrel15 =getent("trap8_15","targetname");

wait 0.1;

barrel1 delete();
barrel2 delete();
barrel3 delete();
barrel4 delete();
barrel5 delete();
barrel6 delete();
barrel7 delete();
barrel8 delete();
barrel9 delete();
barrel10 delete();
barrel11 delete();
barrel12 delete();
barrel13 delete();
barrel14 delete();
barrel15 delete();
	
}
