main()
{
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
	setdvar("compassmaxrange","1800");
	setDvar("bg_falldamagemaxheight", 20000 );
	setDvar("bg_falldamageminheight", 15000 );

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_map::createSpawn((3824, 2736, 252), 180);

	thread btsdd();
	thread btp1();
	thread btp2();
	thread bth_remove();


}

btsdd()
{
	bt=getent("btsdd","targetname");

	bt delete();
}


btp1()
{
	bt=getent("btp1","targetname");
	btt=getent("btp1t","targetname");
	for(;;)
	{
		bt waittill("trigger",player);
		player freezecontrols(1);
		player setorigin(btt.origin);
		player setplayerangles(btt.angles);
		wait 0.1;
		player freezecontrols(0);
	}
}

btp2()
{
	bt=getent("btp2","targetname");
	btt=getent("btp2t","targetname");
	for(;;)
	{
		bt waittill("trigger",player);
		player freezecontrols(1);
		player setorigin(btt.origin);
		player setplayerangles(btt.angles);
		wait 0.1;
		player freezecontrols(0);
	}
}

bth_remove()
{
	bth1=getent("bt1h","targetname");
	bth2=getent("bt2h","targetname");
	bth3=getent("bt3h","targetname");
	bth4=getent("bt4h","targetname");
	bth5=getent("bt5h","targetname");
	bth7=getent("bt7h","targetname");
	bth8=getent("bt8h","targetname");
	bth9=getent("bt9h","targetname");
	bth10=getent("bt10h","targetname");
	btp3=getent("btp3t","targetname");

	bth1 delete();
	bth2 delete();
	bth3 delete();
	bth4 delete();
	bth5 delete();
	bth7 delete();
	bth8 delete();
	bth9 delete();
	bth10 delete();
	btp3 movex(200,0.1);

}