main()
{
thread sr\api\_map::createSpawn((-3289, -1565, 16), 90);
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
	setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);
	
thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_speedrun::createSecretWays("Jumper Secret;Acti Secret;");
thread sr\api\_speedrun::createEndMap((11768.5, -1717.77, 120.125), 110, 10, "normal_0");
thread sr\api\_speedrun::createTeleporter((9399.18, 2076.33, -527.875), 75, 10, (10508, 2080, -4), 360, "unfreeze", "blue", "normal_0");
thread sr\api\_speedrun::createTeleporter((-3536.88, -1470.06, 16.125), 55, 10, (3561, -9381, 1715), 180, "freeze", "yellow", "secret_0");
thread sr\api\_speedrun::createTeleporter((-3026.35, -1526.19, 16.125), 55, 10, (10617, 7095, 1899), 1, "freeze", "cyan", "secret_1");

thread startdoor();
thread ploop();
thread endmover();
thread tpsecret();
thread secretend();
thread endactisecret();
thread actisecretr();
}

startdoor()
{
door = getEnt("startdoor", "targetname");

wait 0.1;
door delete();

}	

ploop()
{
brush1 = getEnt("pl1","targetname");
brush2 = getEnt("pl2","targetname");
brush3 = getEnt("pl3","targetname");
brush4 = getEnt("pl4","targetname");
brush5 = getEnt("pl5","targetname");

wait 0.1;
    brush1 hide();
    brush1 notSolid();
	brush2 hide();
    brush2 notSolid();
	brush3 hide();
    brush3 notSolid();
	brush4 hide();
    brush4 notSolid();
	brush5 hide();
    brush5 notSolid();
}

endmover()
{
block = getEnt ("endmover", "targetname"); 
left = getEnt ("bel", "targetname");
right = getEnt ("ber", "targetname");
up = getEnt ("beu", "targetname");
down = getEnt ("bed", "targetname");

wait 0.1;
block moveY (-250, 0.1);
left moveX (424, 0.1);
right moveX (-416, 0.1);
up moveZ (488, 0.1);
down moveZ (-504, 0.1);

}

tpsecret()
{
	trig = getEnt("tpsecret", "targetname");
	arrivo = getEnt("o_tpsecret", "targetname");
  for (;;) 
  {	
	trig waittill("trigger", player);
	player setOrigin(arrivo.origin);
	player SetPlayerAngles(arrivo.angles);
  }
}

secretend()
{
	trig = getEnt("trig_secretend", "targetname");
  for (;;) 
  {	
	trig waittill("trigger", player);
	player thread sr\api\_speedrun::finishWay("secret_0");
  }
} 

endactisecret()
{
	trig = getEnt("trig_endactisecret", "targetname");
  for (;;) 
  {	
	trig waittill("trigger", player);
	player thread sr\api\_speedrun::finishWay("secret_1");
  }
}
 
actisecretr()
{
	trig = getEnt("trig_actisecretr", "targetname");
	arrivo = getEnt("o_actisecretr", "targetname");
  for (;;) 
  {	
	trig waittill("trigger", player);
	player setOrigin(arrivo.origin);
	player SetPlayerAngles(arrivo.angles);
  }
}