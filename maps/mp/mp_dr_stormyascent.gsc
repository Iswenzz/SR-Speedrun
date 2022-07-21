
main()
{
thread sr\api\_map::createSpawn((-1600, -1406, 1), 360);
	maps\mp\_load::main();

		thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Secret Way;Acti Secret;");
	thread sr\api\_speedrun::createTeleporter((-1357.19, -1617.64, 0.624997), 85, 20, (2892, 1214, 7744), 90, "freeze", "red", "secret_0");
	thread sr\api\_speedrun::createTeleporter((-1332.75, -1190.29, 0.625), 75, 20, (-2264, 1709, 7744), 270, "freeze", "blue", "secret_1");
	thread sr\api\_speedrun::createEndMap((4928.89, -4792.35, 6208.13),170,15,"secret_0");
	thread sr\api\_speedrun::createEndMap((-4286.45, -1847.55, 6208.13),185,20,"secret_1");
	thread sr\api\_speedrun::createEndMap((-30.31674, -1026.22, 2752.12),100,20, "normal_0");

	level.speed1 = 1;
	level.speed2 = 0.125;
	level.speed3 = 0.15;
	level.speed4 = 0.15;
	 
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	
	addTriggerToList("trap1_trig");
	addTriggerToList("trap2_trig");
	addTriggerToList("trap3_trig");
	addTriggerToList("trap4_trig");
	addTriggerToList("trap6_trig");
	addTriggerToList("trap7_trig");	
	

	thread secret1fail();
	thread actisecret_fail();
	thread startround();
	thread w12();
	thread w34();
	thread ro1234();
	thread ro5678();
	thread ro910();
	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();	
	thread trap6();
	thread trap7();

}
actisecret_fail()
{
	trig = getent("actisecret_fail","targetname");	
	while(1)
	{		
		trig waittill("trigger",player);
		player suicide();	
	}
}
secret1fail(){
	trig = getent("secret1_fail","targetname");	
	while(1)
	{		
		trig waittill("trigger",player);
		player suicide();
	}
}
addTriggerToList(name)
{
    if(!isDefined(level.trapTriggers))
        level.trapTriggers=[];
    level.trapTriggers[level.trapTriggers.size]=getEnt(name,"targetname");
}

trap1()
{
	level endon("triggera");
	trig = getent("trap1_trig","targetname");
	trig waittill("triggera",player);
	trig delete();
	
	trap1 = getent("trap1_1","targetname");
	trap3 = getent("trap1_3","targetname");
	trap2 = getent("trap1_2","targetname");
	
	while(1){
		trap2 rotateroll(720,0.5);
		wait 1;
		trap3 rotateroll(720,0.5);
		wait 1;
		trap1 rotateroll(720,0.5);
		wait 1;
	}
}

trap2()
{
	level endon("triggerb");
	trig = getent("trap2_trig","targetname");
	trig waittill("triggerb",player);
	trig delete();
	trap = getentarray("trap2","targetname");
	
	while(1){
		for(i = 0; i < trap.size; i++){
			trap[i] rotatepitch(720,2);
			wait 6;
		}
	}
}

trap3(){
	level endon("triggerc");
	trig = getent("trap3_trig","targetname");
	trig waittill("triggerc",player);
	trig delete();
	trap = getent("trap3","targetname");	
	trap movey(-136,1);
}

trap4()
{
	level endon("triggerazfz");
	trig = getent("trap4_trig","targetname");
	trig waittill("triggerazfz",player);
	trig delete();
	level.speed1 = 0.5;
}

trap6()
{
	level endon("triggeradafafaf");
	trig = getent("trap6_trig","targetname");
	trig waittill("triggeradafafaf",player);
	trig delete();
	level.speed2 = 0.08;
}

trap7()
{
	level endon("triggerawxv");
	trig = getent("trap7_trig","targetname");
	trig waittill("triggerawxv",player);
	trig delete();
	trap1 = getent("trap71","targetname");	
	trap2 = getent("trap72","targetname");
	trap3 = getent("trap73","targetname");
	trap4 = getent("trap74","targetname");
	trap5 = getent("trap75","targetname");
	trap6 = getent("trap76","targetname");
	trap7 = getent("trap77","targetname");

	traph1 = getent("traph71","targetname");
	traph2 = getent("traph72","targetname");
	traph3 = getent("traph73","targetname");
	traph4 = getent("traph74","targetname");
	traph5 = getent("traph75","targetname");
	traph6 = getent("traph76","targetname");
	traph7 = getent("traph77","targetname");
	
	trapp1 = getent("trapp71","targetname");	
	trapp2 = getent("trapp72","targetname");
	trapp3 = getent("trapp73","targetname");
	trapp4 = getent("trapp74","targetname");
	trapp5 = getent("trapp75","targetname");
	trapp6 = getent("trapp76","targetname");
	trapp7 = getent("trapp77","targetname");
	
	traph1 enablelinkto();
	traph1 linkto(trapp1);
	traph2 enablelinkto();
	traph2 linkto(trapp2);
	traph3 enablelinkto();
	traph3 linkto(trapp3);
	traph4 enablelinkto();
	traph4 linkto(trapp4);
	traph5 enablelinkto();
	traph5 linkto(trapp5);
	traph6 enablelinkto();
	traph6 linkto(trapp6);
	traph7 enablelinkto();
	traph7 linkto(trapp7);
	
	while(1){
		trap1 movez(-168,0.1);
		trapp1 movez(-168,0.1);
		wait 0.25;
		trap2 movez(-168,0.1);
		trapp2 movez(-168,0.1);
		wait 0.25;
		trap3 movez(-168,0.1);
		trapp3 movez(-168,0.1);
		wait 0.25;
		trap4 movez(-168,0.1);
		trapp4 movez(-168,0.1);
		wait 0.25;
		trap5 movez(-168,0.1);
		trapp5 movez(-168,0.1);
		wait 0.25;
		trap6 movez(-168,0.1);
		trapp6 movez(-168,0.1);
		wait 0.25;
		trap7 movez(-168,0.1);
		trapp7 movez(-168,0.1);
		wait 1.5;
		trap1 movez(168,3);
		trapp1 movez(168,3);
		trap2 movez(168,3);
		trapp2 movez(168,3);
		trap3 movez(168,3);
		trapp3 movez(168,3);
		trap4 movez(168,3);
		trapp4 movez(168,3);
		trap5 movez(168,3);
		trapp5 movez(168,3);
		trap6 movez(168,3);
		trapp6 movez(168,3);
		trap7 movez(168,3);
		trapp7 movez(168,3);
		wait 3.15;
		
		
		
	}
		
		
}
startround()
{
	door1 = getent("door1","targetname");
	door2 = getent("door2","targetname");
	
	door1 delete();
	door2 delete();
}

w12(){
	w1 = getentarray("w1","targetname");
	w2 = getentarray("w2","targetname");
	while(1){
		for(i = 0; i < w1.size; i++){
			w1[i] movez(264,level.speed1);
		}
		for(i = 0; i < w2.size; i++){
			w2[i] movey(128,level.speed1);
		}		
		wait level.speed1 * 2;
		for(i = 0; i < w2.size; i++){
			w2[i] movey(-128,level.speed1);
		}
		wait level.speed1 * 2;		
		for(i = 0; i < w1.size; i++){
			w1[i] movez(-264,level.speed1);
		}
		for(i = 0; i < w2.size; i++){
			w2[i] movey(128,level.speed1);
		}
		wait level.speed1 * 2;
		for(i = 0; i < w2.size; i++){
			w2[i] movey(-128,level.speed1);
		}
		wait level.speed1 * 2;
	}
}

ro1234(){
	ro1 = getent("ro1","targetname");
	ro2 = getent("ro2","targetname");
	ro3 = getent("ro3","targetname");
	ro4 = getent("ro4","targetname");

	radius = 320;	
	cy1 = -384;
	cz1 = 928;
	cy2 = 576;
	cz2 = 928;
	
	while(1){
		for(i = 0; i < 360; i+=5){			
			y1 = cy1 + radius * (cos(i));
			z1 = cz1 + radius * (sin(i));
			y2 = cy1 + radius * (cos(i+180));
			z2 = cz1 + radius * (sin(i+180));
			y3 = cy2 + radius * (cos(360 - i + 45));
			z3 = cz2 + radius * (sin(360 - i + 45));
			y4 = cy2 + radius * (cos(360 - i + 180 + 45));
			z4 = cz2 + radius * (sin(360 - i + 180 + 45));
			
			
			ro1 moveto((1088,y1,z1),level.speed2);	
			ro2 moveto((1088,y2,z2),level.speed2);
			ro3 moveto((1088,y3,z3),level.speed2);
			ro4 moveto((1088,y4,z4),level.speed2);				
			
			wait level.speed2;
		}
	}
}

ro5678(){
	ro5 = getent("ro5","targetname");
	ro6 = getent("ro6","targetname");
	ro7 = getent("ro7","targetname");
	ro8 = getent("ro8","targetname");

	radius = 512;
	radius2 = 256;
	cx = 256;
	cz = 1664;
	
	
	while(1){
		for(i = 0; i < 360; i+=5){			
			x5 = cx + radius * (cos(i));
			z5 = cz + radius * (sin(i));
			x6 = cx + radius * (cos(i +180));
			z6 = cz + radius * (sin(i +180));
			x7 = cx + radius2 * (cos(360 - i + 45));
			z7 = cz + radius2 * (sin(360 - i + 45));
			x8 = cx + radius2 * (cos(360 - i + 180 + 45));
			z8 = cz + radius2 * (sin(360 - i + 180 + 45));
			
			
			ro5 moveto((x5,-1088,z5),level.speed3);	
			ro6 moveto((x6,-1088,z6),level.speed3);
			ro7 moveto((x7,-1088,z7),level.speed3);
			ro8 moveto((x8,-1088,z8),level.speed3);				
			
			wait level.speed3;
		}
	}
}

ro910(){
	ro9 = getent("ro9","targetname");
	ro10 = getent("ro10","targetname");
	radius = 512;
	cx = 1024;
	cy = 1024;
	
	while(1){
		for(i = 0; i < 360; i+=5){
			x9 = cx + radius * (cos(i));
			y9 = cy + radius * (sin(i));
			x10 = cx + radius * (cos(i+180));
			y10 = cy + radius * (sin(i+180));
			
			ro9 moveto((x9,y9,2188),level.speed4);
			ro10 moveto((x10,y10,2188),level.speed4);
			
			
			wait level.speed4;
		}
	}
}

w34(){
	w3 = getent("w3","targetname");
	w4 = getent("w4","targetname");
	
	while(1){
		w3 movex(-640,1.5);
		w4 movex(640,1.5);
		wait 2;
		w3 movex(640,1.5);
		w4 movex(-640,1.5);
		wait 2;
	}
}
