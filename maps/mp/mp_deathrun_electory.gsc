main()
{
thread sr\api\_map::createSpawn((-731, 534, -136), 360);
maps\mp\_load::main();
 
game["allies"] = "marines";
game["axis"] = "opfor";
game["attackers"] = "axis";
game["defenders"] = "allies";
game["allies_soldiertype"] = "desert";
game["axis_soldiertype"] = "desert";
	
thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_speedrun::createSecretWays("Secret Way;");
thread sr\api\_speedrun::createTeleporter((962.114, 512.29, -58.875), 55, 10, (-682, -168, -612), 1, "freeze", "blue", "normal_0");
thread sr\api\_speedrun::createTeleporter((952.644, -170.768, -671.875), 65, 10, (1033, -156, -356), 360, "freeze", "blue", "normal_0");
thread sr\api\_speedrun::createTeleporter((1970.48, -160.444, -415.875), 55, 10, (4576, -167, -282), 1, "freeze", "blue", "normal_0");
thread sr\api\_speedrun::createTeleporter((6090.38, -163.3, -369.875), 55, 10, (6185, -174, -309), 1, "freeze", "blue", "normal_0");
thread sr\api\_speedrun::createTeleporter((-284.331, 755.019, 16.125), 60, 10, (15383, 1091, 2496), 270, "freeze", "red", "secret_0");
thread sr\api\_speedrun::createEndMap((11840, -169.779, -463.875), 100, 10, "normal_0");
thread sr\api\_speedrun::createEndMap((15369.4, -725.747, 2821.13), 85, 10, "secret_1");
thread autofunc();	
thread autoplatform();
thread autoplatform2();
}

autofunc()
{
	lasers = getent("lasers","targetname");
	squashlasers = getent("squashlasers","targetname");
	damage = getent("squashlasersdamage","targetname");
	secret = getent("secret","targetname");
	secretbrush = getent("secretbruh","targetname");
	rollerlaser = getent("rollerlaser","targetname");
	rlh = getent("rlhurt","targetname");
	lazor1 = getent("lazor1","targetname");
	lazor1hurt = getent("lazor1hurt","targetname");
	lazor2 = getent("lazor2","targetname");
	lazor2hurt = getent("lazor2hurt","targetname");
	rollerdamage = getent("roller_hurt1","targetname");
	lthurt = getent("lthurt","targetname");
	ltlaser = getent("ltlaser","targetname");
	lt1hurt = getent("lasertrap1_hurt","targetname");
	lt1brush = getent("lasertrap1_brush","targetname");
	lt2hurt = getent("lasertrap2_hurt","targetname");
	lt2brush = getent("lasertrap2_brush","targetname");
	tth1 = getent("trap1_hurt","targetname");
	brushgunga = getent("gungabeast","targetname");
	hurtlaz = getent("error","targetname");
	l1trap1 = getent("t1laser","targetname");
	lazah = getent("lazah2","targetname");
	lazahhurt = getent("lazahhurt","targetname");

	lasers hide();
	lasers notSolid();
	rlh maps\mp\_utility::triggerOff();
	damage maps\mp\_utility::triggerOff();
	squashlasers hide();
	squashlasers notSolid();
	rollerlaser hide();
	rollerlaser notSolid();
	lazor1 hide();
	lazor1 notsolid();
	lazor1hurt maps\mp\_utility::triggerOff();
	lazor2 hide();
	lazor2 notsolid();
	lazor2hurt maps\mp\_utility::triggerOff();
	rollerdamage maps\mp\_utility::triggerOff();
	lthurt maps\mp\_utility::triggerOff();
	lt1hurt maps\mp\_utility::triggerOff();
	ltlaser hide();
	ltlaser notsolid();
	lt1brush hide();
	lt2brush notSolid();
	lt1brush notSolid();
	lt2brush hide();
	lt2hurt maps\mp\_utility::triggerOff();
	brushgunga hide();
	hurtlaz maps\mp\_utility::triggerOff();
	l1trap1 hide();
	lazah hide();
	lazahhurt maps\mp\_utility::triggerOff();
	tth1 maps\mp\_utility::triggerOff();
	secret maps\mp\_utility::triggerOff();
	secretbrush hide();
	secretbrush notSolid();

}

autoplatform()
{

	trigger = getent("autoplatform1_trigger","targetname");
	brush = getent("autoplatform1","targetname");

	wait 0.1;
	brush moveX(244,5);
}

autoplatform2()
{
	trigger = getent("autoplatform2_trig","targetname");
	brush = getent ("autoplatform2","targetname");

	wait 0.1;
	brush moveX(168,5);
		
}