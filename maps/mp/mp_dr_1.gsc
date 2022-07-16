main() 
{
maps\mp\_load::main();
 
game["allies"] = "sas";
game["axis"] = "russian";
game["attackers"] = "axis";
game["defenders"] = "allies";
game["allies_soldiertype"] = "woodland";
game["axis_soldiertype"] = "woodland";
 	
    setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	
	precacheItem( "rpg_mp" );
	precacheItem( "winchester1200_grip_mp" );
	precacheItem( "skorpion_silencer_mp" );
	precacheItem( "m4_reflex_mp" );
	precacheItem( "g36c_silencer_mp" );
	precacheItem( "ak47_reflex_mp" );
	precacheItem( "m14_acog_mp" );
	precacheItem( "deserteagle_mp" );
	
thread sr\api\_map::createSpawn((-232,-15,76),360);
thread sr\api\_speedrun::createNormalWays("Easy Way;Hard Way;");
thread sr\api\_speedrun::createSecretWays("Acti Secret;Jumper Secret;");
thread sr\api\_speedrun::createEndMap((22825.1, 393.47, -8607.88), 235, 10, "normal_0");
thread sr\api\_speedrun::createTeleporter((6.28732, -605.196, 16.125), 275, 20, (1506, -553, 76), 270, "freeze", "cyan", "normal_1");
thread sr\api\_speedrun::createTeleporter((24.2553, 67.478, 16.125), 55, 10, (-2548, -17555, -6180), 270, "freeze", "yellow", "secret_0");
thread sr\api\_speedrun::createTeleporter((24.5169, -95.8473, 16.125), 55, 10, (10052, -18389, -6180), 270, "freeze", "blue", "secret_1");

thread startdoors();
thread hardmode();
thread easy_secret_checkpoints();
thread eztptofinish();
thread hardfinish();
thread actisecfinish();
thread jumpersecfinish();
	
}

startdoors() 
{
startdoor_1 = getent("startdoor1", "targetname"); 
startdoor_2 = getent("startdoor2", "targetname"); 
	
wait 0.1;
startdoor_1 moveZ(-400, 5);
startdoor_2 moveZ(-400, 5);
}

hardmode() 
{
lasers = getEnt("hardmode_lasers", "targetname");
hurt = getEnt("hardmode_laser_kill", "targetname");

lasers Solid();
lasers show();
hurt enablelinkto();
hurt linkto (lasers);

level waittill("round_started");

wait 0.1;
lasers delete();
hurt delete();

}

easy_secret_checkpoints() 
{ // Checkpoint system by GenoSen
	start_trigger = getEnt("start_trig", "targetname");
	
	// Pair checkpoint triggers with their teleport location
	thread checkpoint("sec_cp1_trig", "sec_cp1");
	thread checkpoint("sec_cp2_trig", "sec_cp2");
	thread checkpoint("sec_cp3_trig", "sec_cp3");
	thread checkpoint("sec_cp4_trig", "sec_cp4");
	thread checkpoint("sec_cp5_trig", "sec_cp5");
	thread checkpoint("sec_cp6_trig", "sec_cp6");
	
	// Set these triggers to teleport the player to the location of 'player.cp'
	thread tp_triggers("sec_trig");
	thread tp_triggers("sec_trig2");
	thread tp_triggers("sec_trig3");
	thread tp_triggers("sec_trig4");
	thread tp_triggers("sec_trig5");
	thread tp_triggers("sec_trig6");
	
	while(1) {
		// Initialize player.cp
		start_trigger waittill( "trigger", player );
		player.cp = "sec_bounce1";
	}
}

tp_triggers(trigger_name)
{
	tp_trigger = getEnt(trigger_name, "targetname");
	
	while (1){
		tp_trigger waittill( "trigger", player );
		tp = getEnt(player.cp, "targetname");
			
		player SetOrigin ( tp.origin );
		player SetPlayerAngles ( tp.angles );	
	}
}

checkpoint(trig, cp)
{
	cp_trigger = getEnt(trig, "targetname");
	tp = cp;
	
	while (1){
		cp_trigger waittill( "trigger", player );
		player.cp = cp;
	}
}

eztptofinish()
{
   trig = getent("trig_easy_endroom", "targetname");
   tele1 = getent ("endtele_too", "targetname");

   for(;;)
    {   
    trig waittill("trigger", player);
	player setOrigin(tele1.origin);
    player setPlayerAngles(tele1.angles);
    }
    
}

hardfinish()
{ 
   trig = getent("trig_hard_endroom", "targetname");

   for(;;)
    {   
    trig waittill("trigger", player);

    player thread sr\api\_speedrun::finishWay("normal_1");
    }
    
}

actisecfinish()
{
   trig = getent("trig_acti_sec2", "targetname");

   for(;;)
    {   
    trig waittill("trigger", player);

    player thread sr\api\_speedrun::finishWay("secret_0");
    }
    
}

jumpersecfinish()
{  
   trig = getent("endtrig_easy_sec", "targetname");

   for(;;)
    {   
    trig waittill("trigger", player);

    player thread sr\api\_speedrun::finishWay("secret_1");
    }
    
}