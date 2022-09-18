main()
{

    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";

thread sr\api\_map::createSpawn((193,-1,76),360);
thread sr\api\_speedrun::createTeleporter((209.977, 160.844, 16.125), 65, 30, (3509, -2937, 656), 91, "freeze", "red", "secret_0");
thread sr\api\_speedrun::createEndMap((8336.32, 0.0214804, -431.875), 120, 40, "normal_0");
thread sr\api\_speedrun::createEndMap((2038.18, -2338.81, 64.125), 125, 20, "secret_0");
thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_speedrun::createSecretWays("Secret Way;");

thread startdoor();
thread lift();
thread trap6();
thread lasers();

getEnt("hurt1", "targetname") delete();
getEnt("hurt2", "targetname") delete();

}

startdoor()
{
door = getent("door", "targetname");

wait 0.1;
door delete();
}

lift()
{
lift = getent("lift", "targetname");

wait 0.1;
lift rotateYaw(90,0.1);
lift moveX(250,0.1);

}

trap6()
{
trap6a = getent("trap6a", "targetname");
trap6b = getent("trap6b", "targetname");

wait 0.1;
trap6a delete();
trap6b moveZ(-560,0.1);
wait 0.2;
trap6b moveX(1400,0.1);

}

lasers()
{
laser1=getent("laser1","targetname");
laser1_hurt=getent("laser1_hurt","targetname");
laser2=getent("laser2","targetname");
laser2_hurt=getent("laser2_hurt","targetname");
laser3=getent("laser3","targetname");
laser3_hurt=getent("laser3_hurt","targetname");

wait 0.1;

laser1 delete();
laser1_hurt delete();
laser2 delete();
laser2_hurt delete();
laser3 delete();
laser3_hurt delete();

}