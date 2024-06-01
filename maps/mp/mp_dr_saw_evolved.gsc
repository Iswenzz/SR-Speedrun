main()
{
	maps\mp\_load::main();	
	

		
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Secret Way;");
    thread sr\api\_map::createSpawn((-765, 252, 188), 1);
    thread sr\api\_speedrun::createTeleporter((-764.801, 438.451, 128.125), 60, 100, (2580, 1373, 5196), 360, "freeze", "yellow", "secret_0");
    thread sr\api\_speedrun::createEndMap((607.147, -1181.79, 3697.13), 130, 100, "secret_0");
	

	thread start1();
	thread start2();
	thread lift();
	thread splatter();
	thread bludspin();
	thread spins();
	thread spins2();
	thread spins3();
	thread laserbounce();
	thread laserbounce2();
	thread hardmode();
	
}	

start1()
{
	door = getent("rise1","targetname");
	killtrigger = getent ("killtrigstart" , "targetname");
	clip = getent ("cliprise" , "targetname");
	spin2 = getent ("spin2" , "targetname");
	spin4 = getent ("spin4" , "targetname");
	spin5 = getent ("spin5" , "targetname");
	object = getent ("laserspin", "targetname");
	object1 = getEnt("laserbounce1", "targetname");
	object2 = getEnt("laserbounce2", "targetname");
	
	door delete();
	killtrigger delete();
	clip delete();
	object delete();
	object1 delete();
	object2 delete();
	spin2 rotateYaw(90,0.1);
	spin4 rotateYaw(90,0.1);
	spin5 rotateYaw(90,0.1);
	
}	

start2()
{
object = getEnt("laserauto1", "targetname");
object2 = getEnt("autolaser2", "targetname");
object3 = getEnt("autolaser3", "targetname");
object4 = getEnt("autolaser4", "targetname");
object5 = getEnt("autolaser5", "targetname");
object6 = getEnt("autolaser6", "targetname");
object7 = getEnt("autolaser7", "targetname");
object8 = getEnt("autolaser8", "targetname");

object delete();
object2 delete();
object3 delete();
object4 delete();
object5 delete();
object6 delete();
object7 delete();
object8 delete();


}

lift()
{
brush = getent("floorshoot", "targetname");
	
brush movez(-405, 0.1);
			
}

splatter()
{
killtrigger = getEnt ("killtrigsplatter" , "targetname");
killtrigger2 = getEnt ("killtrigsplatter2" , "targetname");

killtrigger delete();
killtrigger2 delete();

}


bludspin()
{
killtrigger = getent ("killtrigger10","targetname");
killtrigger2 = getent ("killtrigger11","targetname");
killtrigger3 = getent ("killtrigger12","targetname");
killtrigger4 = getent ("killtrigger13","targetname");
	
killtrigger delete ();
killtrigger2 delete();
killtrigger3 delete();
killtrigger4 delete();
		
}


spins()
{
killtrigger = getEnt ("killtrigspinningsaws" , "targetname");

killtrigger delete();

}

spins2()
{
killtrigger = getEnt ("killtrigspinningsaws2" , "targetname");

killtrigger delete();

}

spins3()
{
killtrigger = getEnt ("bigspin1" , "targetname");
killtrigger2 = getEnt ("bigspin2" , "targetname");
killtrigger3 = getEnt ("bigspin3" , "targetname");
killtrigger4 = getEnt ("bigspin4" , "targetname");
killtrigger5 = getEnt ("bigspin5" , "targetname");
killtrigger6 = getEnt ("bigspin6" , "targetname");


killtrigger delete();
killtrigger2 delete();
killtrigger3 delete();
killtrigger4 delete();
killtrigger5 delete();
killtrigger6 delete();

}

laserbounce()
{
killtrigger = getEnt ("bouncelaser1" , "targetname");
killtrigger2 = getEnt ("bouncelaser2" , "targetname");

killtrigger delete();
killtrigger2 delete();

          
}
			
			
laserbounce2()
{
killtrigger = getEnt ("bouncelaser3" , "targetname");
killtrigger2 = getEnt ("bouncelaser4" , "targetname");

killtrigger delete();
killtrigger2 delete();

}
			
hardmode()
{
killtrigger = getEnt ("killtrig_hardmode1" , "targetname");
killtrigger2 = getEnt ("killtrig_hardmode2" , "targetname");
killtrigger3 = getEnt ("killtrig_hardmode3" , "targetname");
killtrigger4 = getEnt ("killtrig_hardmode4" , "targetname");
killtrigger5 = getEnt ("killtrig_hardmode5" , "targetname");
killtrigger6 = getEnt ("killtrig_hardmode6" , "targetname");
killtrigger7 = getEnt ("killtrig_hardmode7" , "targetname");
killtrigger8 = getEnt ("killtrig_hardmode8" , "targetname");

killtrigger delete ();
killtrigger2 delete ();
killtrigger3 delete ();
killtrigger4 delete ();
killtrigger5 delete ();
killtrigger6 delete ();
killtrigger7 delete ();
killtrigger8 delete ();

}
