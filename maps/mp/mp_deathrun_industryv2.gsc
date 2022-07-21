main()
{
thread sr\api\_map::createSpawnOrigin((-82, 253, 16), 180);
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
setdvar("bg_fallDamageMaxHeight","99999");
setdvar("bg_fallDamageMinHeight","99998");

thread sr\api\_speedrun::createNormalWays("Normal Way");
thread sr\api\_speedrun::createTeleporter((-2310.06, -823.969, 0.125), 55, 10, (-1815, -832, 60), 360, "freeze", "blue", "normal_0");
thread sr\api\_speedrun::createTeleporter((-923.696, -2242.2, 0.125001), 55, 10, (-969, -1890, 268), 90, "freeze", "blue", "normal_0");
thread sr\api\_speedrun::createTeleporter((-1376.04, -1506.5, 208.125), 55, 10, (-2111, -1731, 268), 180, "freeze", "blue", "normal_0");

thread startdoors();
thread stage2doors();
thread trap4();
}

startdoors()
{
	door1 = getent("sdoor1","targetname");
	door2 = getent("sdoor2","targetname");
	door1 delete();
	door2 delete();
}

stage2doors()
{
door1 = getent("stagedoor1","targetname");
door2 = getent("stagedoor2","targetname");

while(1)
{
wait 0.1;
door1 hide();
door1 notsolid();
door2 hide();
door2 notsolid();
}

}

trap4()
{
	trig = getent("trap4trig","targetname");
	level.trap4actied = false;

	for(k=1;k<=3;k++)
	{
		thread trap4killtrigger(k);
	}

	trig waittill("trigger",player);
	{
		repeat = randomint(5)+1;
		for(i=1;i<=repeat;i++)
		{
			level.trap4time = randomint(10)+1;
			level.trap4actied = true;
			for(t=1;t<=24;t++)
			{
				thread spawnfxorigin(t);
			}
			wait level.trap4time;
			level.trap4actied = false;
			wait randomint(5)+2;
		}
	}
}

spawnfxorigin(num)
{
	static_origin = getent("static_origin_"+num,"targetname");
	dinamic_origin = spawn("script_model", static_origin.origin);
	dinamic_origin setmodel("tag_origin");
	dinamic_origin.angles = (270, 163.327, -163.327);
	wait .1;
	wait level.trap4time;
	dinamic_origin delete();
}

trap4killtrigger(num)
{
	killtrigger = getent("trap4killtrigger_"+num,"targetname");
	killtrigger maps\mp\_utility::triggerOff();
	for(;;)
	{
		if(level.trap4actied == true)
			killtrigger maps\mp\_utility::triggerOn();
		else
			killtrigger maps\mp\_utility::triggerOff();
		wait .1;
	}
}