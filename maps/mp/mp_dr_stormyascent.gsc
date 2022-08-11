
main()
{
maps\mp\_load::main();

thread sr\api\_map::createSpawn((-1600,-1406,61),360);
thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_speedrun::createSecretWays("Secret Way;Acti Secret;");
thread sr\api\_speedrun::createTeleporter((385.028, -1094.31, 184.127), 55, 10, (115, -1094, 540), 180, "freeze", "cyan", "normal_0");
thread sr\api\_speedrun::createTeleporter((-902.135, -1089.22, 576.125), 55, 10, (-628, -1084, 932), 360, "freeze", "cyan", "normal_0");
thread sr\api\_speedrun::createTeleporter((449.85, 1082.61, 1344.13), 55, 10, (-1082, 1017, 1404), 270, "freeze", "cyan", "normal_0");
thread sr\api\_speedrun::createTeleporter((1086.94, 246.91, 2200.13), 55, 10, (306, 1126, 2260), 180, "freeze", "cyan", "normal_0");
thread sr\api\_speedrun::createTeleporter((-1357.19, -1617.64, 0.624997), 85, 30, (2892, 1214, 7744), 90, "freeze", "red", "secret_0");
thread sr\api\_speedrun::createTeleporter((-1332.75, -1190.29, 0.625), 75, 30, (-2264, 1709, 7744), 270, "freeze", "red", "secret_1");
thread sr\api\_speedrun::createEndMap((-30.31674, -1026.22, 2752.12),100,20, "normal_0");
thread sr\api\_speedrun::createEndMap((4956.28, 4795.77, 6208.13),175,20, "secret_0");
thread sr\api\_speedrun::createEndMap((-4286.45, -1847.55, 6208.13),185,20, "secret_1");

	 
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	
	thread secret1fail();
	thread actisecret_fail();
	thread startround();
	//thread w12();
	//thread w34();
	thread ro1234();
	thread ro5678();
	thread ro910();

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

ro1234()
{
ro1 = getent("ro1","targetname");
ro2 = getent("ro2","targetname");
ro3 = getent("ro3","targetname");
ro4 = getent("ro4","targetname");

wait 0.1;	
ro1 moveY(90,0.1);
ro2 moveY(-135,0.1);
ro3 moveY(-40,0.1);
ro4 moveY(-690,0.1);
wait 0.5;
ro4 moveZ(127,0.1);
wait 1.2;
ro4 moveX(-200,0.1);

	
}

ro5678()
{
ro5 = getent("ro5","targetname");
ro6 = getent("ro6","targetname");
ro7 = getent("ro7","targetname");
ro8 = getent("ro8","targetname");

ro5 moveZ(314,0.1);
ro6 moveZ(384,0.1);
ro7 moveZ(349,0.1);
ro8 moveZ(419,0.1);
ro8 rotatePitch(325,0.1);
wait 0.5;
ro6 moveY(370,0.1);
wait 1.2;
ro6 moveX(-500,0.1);
ro8 moveX(-50,0.1);
	
}

ro910()
{
ro9 = getent("ro9","targetname");
ro10 = getent("ro10","targetname");

ro9 delete();
ro10 delete();
	
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
