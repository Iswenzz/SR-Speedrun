main()
{
maps\mp\_load::main();

game["allies"] = "sas";
game["axis"] = "opfor";
game["attackers"] = "axis";
game["defenders"] = "allies";
game["allies_soldiertype"] = "desert";
game["axis_soldiertype"] = "desert";
	
setdvar( "r_specularcolorscale", "1" );
setdvar("r_glowbloomintensity0",".25");
setdvar("r_glowbloomintensity1",".25");
setdvar("r_glowskybleedintensity0",".3");
setdvar("bg_fallDamageMaxHeight","99999");
setdvar("bg_fallDamageMinHeight","99998");
	
thread sr\api\_speedrun::createNormalWays("Normal Way");
thread sr\api\_speedrun::createSecretWays("Secret Way");
thread sr\api\_map::createSpawn((-3643,2202,-104),180);
thread sr\api\_speedrun::createTeleporter((3548.33, 2604.06, -163.875), 60, 10, (-334, -318, -184), 90, "freeze", "red", "secret_0");
thread sr\api\_speedrun::createEndMap((-354.448, 1112.49, 158.125), 60, 10, "secret_0");

thread stage2_tp();
thread stage3_tp();
thread stage4_tp();
thread moving_pf();
	
}

stage2_tp()
{
trig = getEnt("stage1finish_trig", "targetname");
stage2 = getEnt("stage2_tp", "targetname");
	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin( stage2.origin );
			player setplayerangles( stage2.angles );
		}
}

stage3_tp()
{
trig = getEnt("stage2finish_trig", "targetname");
stage3 = getEnt("stage3_tp", "targetname");
	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin( stage3.origin );
			player setplayerangles( stage3.angles );
		}
}

stage4_tp()
{
trig = getEnt("stage3finish_trig", "targetname");
stage4 = getEnt("stage4_tp", "targetname");
	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin( stage4.origin );
			player setplayerangles( stage4.angles );
		}
}

moving_pf()
{
pf = getEnt("moving_pf", "targetname");

wait 0.1;
pf moveY(236,7);
}