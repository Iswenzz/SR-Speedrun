main()
{
maps\mp\_load::main();

game["allies"] = "sas";
game["axis"] = "russian";
game["attackers"] = "axis";
game["defenders"] = "allies";
game["allies_soldiertype"] = "woodland";
game["axis_soldiertype"] = "woodland";
       
setdvar("r_specularcolorscale", "1");
setdvar("r_glowbloomintensity0",".1");
setdvar("r_glowbloomintensity1",".1");
setdvar("r_glowskybleedintensity0",".1");

thread sr\api\_map::createSpawn((-732,823,364),270);
thread sr\api\_speedrun::createNormalWays("Normal Way;");

thread end();
thread normaltp();
thread kkk35_mozgoja();
thread kkk35();
}

end()
{
end = getent ("end","targetname");
end waittill ("trigger",player );

for(;;)
{ 
player thread sr\api\_speedrun::finishWay("normal_0");
}

}

normaltp()
{
   trig = getent("asd_2", "targetname");
   tele1 = getent ("gohere", "targetname");

   for(;;)
    {   
    trig waittill("trigger", player);
	player setOrigin(tele1.origin);
    player setPlayerAngles(tele1.angles);
	player freezeControls (1);
	wait 0.1;
	player freezeControls (0);
    }
    
}

kkk35_mozgoja()

{
kkk35_mozog = getent("kkk35_mozgoja", "targetname");

wait 0.05;
kkk35_mozog movey(-30,3);

}

kkk35()

{
kkk35_jaroka = getEnt ("kkk35", "targetname");

wait 2;
kkk35_jaroka moveX (-150,2);
wait 2;
kkk35_jaroka moveY (80,2);
 
}