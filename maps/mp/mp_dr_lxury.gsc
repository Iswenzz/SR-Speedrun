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
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Secret Way;");
	thread sr\api\_map::createSpawn((132, -512, 76), 0);
    thread sr\api\_speedrun::createTeleporter((2916.09, 1143.96, 16.125), 130, 100, (710, 1150, -2338), 360, "freeze");
	thread sr\api\_speedrun::createTeleporter((131.924, -359.366, 16.125), 60, 100, (7791, 2472, 1869), 270, "freeze", "yellow", "secret_0");

 
 thread startdoor();
 thread platform1();
 thread platform2();
 thread platform3();
 thread teleport5();
 thread teleportsecretfail();
 thread teleportsecretend();
 thread trap02();
 thread trap04();
 thread trap07();

 
}
	
startdoor()
{
door1 = getent("startdoor1","targetname");
door2 = getent("startdoor2","targetname");
ro1 = getent("einddraai1","targetname");
ro2 = getent("einddraai2","targetname");


door1 delete();
door2 delete();
ro1 delete();
ro2 delete();


}


platform1()
{
plat1 = getent("plat1","targetname");
trig_plat1 = getent("trig_plat1","targetname");

plat1 moveY(-380, 0.1); 

}

platform2()
{
plat2 = getent("plat2","targetname");
trig_plat2 = getent("trig_plat2","targetname");

plat2 moveX(400, 0.1); 

}


platform3()
{
plat3 = getent("plat3","targetname");
trig_plat3 = getent("trig_plat3","targetname");

plat3 delete();

}

teleport5()
{
	trig = getEnt("teleport_5","targetname");
	target = getEnt("tp5","targetname");
	

	for(;;)
	{
		trig waittill("trigger",player);
		player setPlayerAngles(target.angles);
		player setOrigin(target.origin);
		player freezeControls(1);
	    wait 0.1;
	    player freezeControls(0);
	}
}


teleportsecretfail()
{
	trig = getEnt("tpsecretfail","targetname");
	target = getEnt("tpsecret","targetname");
	

	for(;;)
	{
		trig waittill("trigger",player);
		player setPlayerAngles(target.angles);
		player setOrigin(target.origin);
		player freezeControls(1);
	    wait 0.1;
	    player freezeControls(0);
	}
}


teleportsecretend()
{
	trig = getEnt("telepsecretend","targetname");
	target = getEnt("tpsecretend","targetname");
	

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::finishWay("secret_0");
		
	}
}


trap02()
{
trap2spike=getent("trap02a","targetname");
trap2spike2=getent("trap02b","targetname");
trap2spike3=getent("trap02c","targetname");
trap2spike4=getent("trap02d","targetname");
trap2spike5=getent("trap02e","targetname");
trap2spike6=getent("trap02f","targetname");
trap2spike7=getent("trap02g","targetname");
trap2killer=getent("trap02killer","targetname");

trap2killer delete();
trap2spike delete();
trap2spike2 delete();
trap2spike3 delete();
trap2spike4 delete();
trap2spike5 delete();
trap2spike6 delete();
trap2spike7 delete();


}


trap04()
{
trap1 =getent("trap04a","targetname");
trap2 =getent("trap04b","targetname");
trap3 =getent("trap04c","targetname");
killer1 =getent("trap04akiller","targetname");
killer2 =getent("trap04bkiller","targetname");
killer3 =getent("trap04ckiller","targetname");
trig =getent("trig_trap04","targetname");

killer1 delete();
killer2 delete();
killer3 delete();

}


 trap07()
 {
 trap1 =getent("trap07a","targetname");
 trap2 =getent("trap07b","targetname");
 killer1 =getent("killer07a","targetname");
 killer2 =getent("killer07b","targetname");
 trig = getent ("trig_trap07", "targetname");

 killer1 delete();
 killer2 delete();

}
