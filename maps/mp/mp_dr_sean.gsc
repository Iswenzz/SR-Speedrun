/*
   ___________   _  __
  / __/ __/ _ | / |/ /
 _\ \/ _// __ |/    /
/___/___/_/ |_/_/|_/


Map by Sean
*/

main(){
thread sr\api\_map::createSpawnOrigin((-21, -640, 8), 90);
	maps\mp\_load::main();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";


	setdvar("r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setDvar("bg_falldamagemaxheight", 3000000 );
	setDvar("bg_falldamageminheight", 1280000 );

	precacheItem("m40a3_mp");
	precacheItem("remington700_mp");
	precacheItem("deserteagle_mp");
	precacheItem("winchester1200_mp");
	precacheItem("knife_mp");
	preCacheItem("barrett_mp");

	addtriggertolist("trig_trap1");
	addtriggertolist("trig_trap2");
	addtriggertolist("trig_trap3");
	addtriggertolist("trig_trap4");
	addtriggertolist("trig_trap5");
	addtriggertolist("trig_trap6");

    thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createSecretWays("Secret Way");
		thread sr\api\_speedrun::createTeleporter((-340.563, -589.741, 8.125), 75, 100, (-863, -3225, -324), 358, "freeze", "blue", "secret_0");
	thread sr\api\_speedrun::createTeleporter((-19.262, 6342.97, 0.125), 85, 110, (-36, 7733, 60), 90, "freeze");
	//thread msg();
	thread startDoor();
	//thread platform();
	//thread trap1();
	//thread trap2();
	//thread trap3();
	//thread trap4();
	//thread trap5();
	//thread trap6();
	//thread sec_enter();
	thread sec_exit();
	//thread sniper_room();
	//thread knife_room();
	//thread old_room();
}

addTriggerToList(name){
    if(!isDefined(level.trapTriggers))
    level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt(name,"targetname");
}

msg(){
	level waittill("round_started");
	iprintlnBold("^1Welcome to Sean's first map");
}

startDoor(){
	Sean = getent("startdoor","targetname");
	Sean delete();
}

platform(){
	platform = getEnt("seanmove","targetname");
	trig = getEnt("trig_seanmover","targetname");

	trig waittill("trigger", player);
	trig Delete();

	while(true){
	platform MoveY(1152, 3);
	platform waittill("movedone");
	wait 1;
	platform MoveY(-1152, 3);
	platform waittill("movedone");
	wait 1;
}
}

///////////////////////////////////////////
///////////////////////////////////////////

/* - Fox Stuff added below -
	Pretty basic traps but you can always edit */

///////////////////////////////////////////
///////////////////////////////////////////

trap1()
{
	trig = getEnt("trig_trap1", "targetname");
	trap = getEnt("trap1", "targetname");

	trig setHintString("Press [^3use^7] to Activate");

	trig waittill("trigger", player);

	trig delete();
	trap delete();
}

trap2()
{
	trig = getEnt("trig_trap2", "targetname");
	trap = getEnt("trap2", "targetname");

	trig setHintString("Press [^3use^7] to Activate");

	trig waittill("trigger", player);

	trig delete();
	trap rotateRoll(-360,3);
	wait 5;
	trap rotateRoll(360,3);
}

trap3()
{
	trig = getEnt("trig_trap3", "targetname");
	trap = getEnt("trap3", "targetname");

	trig setHintString("Press [^3use^7] to Activate");

	trig waittill("trigger", player);

	trig delete();
	trap moveZ(-200,2);
	wait 5;
	trap moveZ(200,2);
}

trap4()
{
	trig = getEnt("trig_trap4", "targetname");
	trap = getEnt("trap4", "targetname");

	trig setHintString("Press [^3use^7] to Activate");

	trig waittill("trigger", player);

	trig delete();
	trap delete();
}

trap5()
{
	trig = getEnt("trig_trap5", "targetname");
	trap = getEnt("trap5", "targetname");

	trig setHintString("Press [^3use^7] to Activate");

	trig waittill("trigger", player);

	trig delete();
	trap rotatePitch(-360,3);
	wait 5;
	trap rotatePitch(360,3);
}

trap6()
{
	trig = getEnt("trig_trap6", "targetname");
	trap = getEnt("trap6", "targetname");

	trig setHintString("Press [^3use^7] to Activate");

	trig waittill("trigger", player);

	trig delete();
	trap delete();
}

// secret stuff

sec_enter()
{
	trig = getEnt("trig_sec", "targetname");
	tele1 = getEnt("sec_here", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			wait 0.5;
			player freezeControls(0);
		}
}


sec_exit()
{
	trig = getEnt("sec_exit", "targetname");
	tele1 = getEnt("here_1", "targetname");

	trig setHintString("Press [^3use^7] to Finish Secret!");

	for(;;)
		{
			trig waittill("trigger", player);
            player thread sr\api\_speedrun::finishWay("secret_0");
		}
}

// end rooms

knife_room()
{
	while(1)
	{
		level.trigknife = getEnt("trig_knife","targetname");
		acti = getEnt("here_acti","targetname");
		jump = getEnt("here_jumper","targetname");

		level.trigknife setHintString("Knife");

		level.trigknife waittill("trigger", player);

		iPrintLnBold("^3" + player.name + "^7 has entered Knife");

		level.trigold delete();
		level.trigsniper delete();

		player setOrigin (jump.origin);
		player setPlayerAngles (jump.angles);

		level.activ setOrigin (acti.origin);
		level.activ setPlayerAngles (acti.angles);

		player takeAllWeapons();
		level.activ takeAllWeapons();

		player freezeControls(1);
		level.activ freezeControls(1);

		player.maxhealth = 100;
		player.health = player.maxhealth;
		level.activ.maxhealth = 100;
		level.activ.health = level.activ.maxhealth;

		player takeAllWeapons();
		player giveWeapon("knife_mp");
		player switchToWeapon("knife_mp");

		level.activ takeAllWeapons();
		level.activ giveWeapon("knife_mp");
		level.activ switchToWeapon("knife_mp");

		wait 5;
		player iPrintLnBold("^7FIGHT!");
		level.activ iPrintLnBold("^7FIGHT!");

		player freezeControls(0);
		level.activ freezeControls(0);

		while( isAlive( player ) && isDefined( player ) && player.sessionstate == "playing" )
		wait 0.5;

		iPrintLnBold("^3" + player.name + "^7 was killed!");
		wait 1;
		player = undefined;
	}
}


sniper_room()
{
	while(1)
	{
		level.trigsniper = getEnt("trig_sniper","targetname");
		acti = getEnt("here_acti","targetname");
		jump = getEnt("here_jumper","targetname");

		level.trigsniper setHintString("sniper");

		level.trigsniper waittill("trigger", player);

		iPrintLnBold("^3" + player.name + "^7 has entered Sniper");

		level.trigold delete();
		level.trigknife delete();

		player setOrigin (jump.origin);
		player setPlayerAngles (jump.angles);

		level.activ setOrigin (acti.origin);
		level.activ setPlayerAngles (acti.angles);

		player takeAllWeapons();
		level.activ takeAllWeapons();

		player freezeControls(1);
		level.activ freezeControls(1);

		player.maxhealth = 100;
		player.health = player.maxhealth;
		level.activ.maxhealth = 100;
		level.activ.health = level.activ.maxhealth;

		player takeAllWeapons();
		player giveWeapon("remington700_mp");
		player giveMaxAmmo("remington700_mp");
		player giveWeapon("m40a3_mp");
		player giveMaxAmmo("m40a3_mp");
		player switchToWeapon("m40a3_mp");

		level.activ takeAllWeapons();
		level.activ giveWeapon("remington700_mp");
		level.activ giveMaxAmmo("remington700_mp");
		level.activ giveWeapon("m40a3_mp");
		level.activ giveMaxAmmo("m40a3_mp");
		level.activ switchToWeapon("m40a3_mp");

		wait 5;
		player iPrintLnBold("^7FIGHT!");
		level.activ iPrintLnBold("^7FIGHT!");

		player freezeControls(0);
		level.activ freezeControls(0);

		while( isAlive( player ) && isDefined( player ) && player.sessionstate == "playing" )
		wait 0.5;

		iPrintLnBold("^3" + player.name + "^7 was killed!");
		wait 1;
		player = undefined;
	}
}



old_room()
{
	level.trigold = getEnt("trig_old","targetname");
	acti = getEnt("here_acti","targetname");
	door = getEnt("door_old","targetname");

	level.trigold setHintString("Old Way");

	level.trigold waittill("trigger", player);

	ambientStop(1);
	ambientPlay("mp_time_running_out_losing");

	iPrintLnBold("^3" + player.name + "^7 has entered Old");

	level.trigsniper delete();
	level.trigknife delete();

	level.activ setOrigin (acti.origin);
	level.activ setPlayerAngles (acti.angles);

	wait 2;
	iPrintLnBold("Old Door OPEN!");
	door delete();
	level.trigold delete();
}