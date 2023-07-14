main()
{
trigger = getEnt("finisherzekelo", "targetname");
trigger.targetname = "endmap_trig";

	maps\mp\_load::main();	

	setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_map::createSpawn((106, 79, -13), 360);
	
	thread begin();
	thread trap3door1();
	thread trap3door2();
	thread trap4();
	thread trap6load();
	thread trap7();

}

begin()
{
finisholdt = getent("begin","targetname");
aa = getent("trap8obj", "targetname");

finisholdt delete();
aa delete();


}

trap3door1()
{
trig = getent("trap3do1", "targetname");
aa = getent("trap3door1","targetname");

aa delete();

}
trap3door2()
{
trig = getent("trap3do2", "targetname");
aa = getent("trap3door2","targetname");

aa delete();

}

trap4()
{
trig = getent("trap4akti", "targetname");
aa = getent("trap4_1","targetname");
aaa = getent("trap4_2","targetname");
aaaa = getent("trap4_3","targetname");

aa delete();
aaa delete();
aaaa delete();
}


trap6load()
{
	aa = getent("trap6_2","targetname");
	aa movez (-200, 0.1);
}

trap7()
{
trig = getent("trap7akti", "targetname");
aa = getent("trap7obj","targetname");

aa delete();

}
