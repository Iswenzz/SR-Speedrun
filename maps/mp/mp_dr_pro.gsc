main()
{
maps\mp\_load::main();
 
game["allies"] = "marines";
game["axis"] = "opfor";
game["attackers"] = "axis";
game["defenders"] = "allies";
game["allies_soldiertype"] = "desert";
game["axis_soldiertype"] = "desert"; 

setdvar( "r_specularcolorscale", "1" );
setdvar("r_glowbloomintensity0",".1");
setdvar("r_glowbloomintensity1",".1");
setdvar("r_glowskybleedintensity0",".1");
setDvar("bg_falldamagemaxheight", 99999);
setDvar("bg_falldamageminheight", 99998);

thread sr\api\_map::createSpawn((-6,-137,194),270);
thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_speedrun::createSecretWays("Easy Secret;Hard Secret;");
thread sr\api\_speedrun::createEndMap((-38725.4, -6125.01, 31968.1), 920, 50, "secret_0");
thread sr\api\_speedrun::createTeleporter((-192.529, -387.621, 135.005), 60, 10, (-11326, 14942, 48097), 270, "freeze", "cyan", "secret_0");
thread sr\api\_speedrun::createTeleporter((161.13, -384.396, 133.632), 60, 10, (12016, 20931, -4268), 180, "freeze", "yellow", "secret_1");

thread startdoor();
//teleports
thread teleport1();
thread teleport2();
thread teleport3();
thread teleport4();
thread end_trigger();
//ezsecret teleports
thread ezsectele1();
thread ezsectele2();
thread ezsectele3();
thread ezsectele3p1();
thread ezsectele4();
thread ezsectele5();
thread ezsectele5p1();
thread ezsectele6();
thread ezsectele7();
thread ezsectele7p1();
thread ezsectele8();
thread ezsectele9();
// hard secret teleports
thread hardsectele1();
thread hardsectele2();
thread hardsectele3();
thread hardsectele6();
thread hardsectele6();
thread hardsectele7();
thread hardsectele8();
thread hardsectele9();
thread hardsectele10();
thread hardsectele11();
thread hardsectele12();
thread hardsectele13();
thread hardsecend();
}

startdoor()
{
door = getent("startdoor","targetname");

wait 0.1;
door delete();

}	 

///teleports

teleport1()
{
trig=getent("trigger_teleport1","targetname");
tele1=getent("origin_teleport1","targetname");

	for(;;)
	{
	trig waittill ("trigger", player);
	player setorigin (tele1.origin);
	player setPlayerAngles(tele1.angles);
	}
}

teleport2()
{
trig=getent("trigger_teleport2","targetname");
tele1=getent("origin_teleport2","targetname");

	for(;;)
	{
	trig waittill ("trigger", player);
	player setorigin (tele1.origin);
	player setPlayerAngles(tele1.angles);
	}
}

teleport3()
{
trig=getent("trigger_teleport3","targetname");
tele1=getent("origin_teleport3","targetname");

	for(;;)
	{
	trig waittill ("trigger", player);
	player setorigin (tele1.origin);
	player setPlayerAngles(tele1.angles);
	}
}

teleport4()
{
trig=getent("trigger_teleport4","targetname");
tele1=getent("origin_teleport4","targetname");

	for(;;)
	{
	trig waittill ("trigger", player);
	player setorigin (tele1.origin);
	player setPlayerAngles(tele1.angles);
	}
}

end_trigger()
{
trig=getent("endmap_trig","targetname");
  
  for(;;)
	{
	trig waittill ("trigger", player);
	player thread sr\api\_speedrun::finishWay("normal_0");
	}
   
 }  

//ezsecteleports
ezsectele1()
{

        trig=getent("ezsec_tele1","targetname");
	tele4=getent("origin_ezsectele1","targetname");
	


	for(;;)
	{
		
                 
                trig waittill ("trigger", player);

                player setorigin (tele4.origin);

               
		
		
               	        

	}
}

ezsectele2()
{

        trig=getent("ezsec_tele2","targetname");
	tele5=getent("origin_ezsectele2","targetname");
	


	for(;;)
	{
		
                 
                trig waittill ("trigger", player);

                player setorigin (tele5.origin);

               
		
		
               	        

	}
}

ezsectele3()
{

        trig=getent("ezsec_tele3","targetname");
	tele6=getent("origin_ezsectele3","targetname");
	


	for(;;)
	{
		
                 
                trig waittill ("trigger", player);

                player setorigin (tele6.origin);

               
		
		
               	        

	}
}
ezsectele3p1()
{

        trig=getent("ezsec_tele3p1","targetname");
	tele6p1=getent("origin_ezsectele3p1","targetname");
	


	for(;;)
	{
		
                 
                trig waittill ("trigger", player);

                player setorigin (tele6p1.origin);

               
		
		
               	        

	}
}
ezsectele4()
{

        trig=getent("ezsec_tele4","targetname");
	tele7=getent("origin_ezsectele4","targetname");
	


	for(;;)
	{
		
                 
                trig waittill ("trigger", player);

                player setorigin (tele7.origin);

               
		
		
               	        

	}
}

ezsectele5()
{

        trig=getent("ezsec_tele5","targetname");
	tele8=getent("origin_ezsectele5","targetname");
	


	for(;;)
	{
		
                 
                trig waittill ("trigger", player);

                player setorigin (tele8.origin);

               
		
		
               	        

	}
}
ezsectele5p1()
{

        trig=getent("ezsec_tele5p1","targetname");
	tele8p1=getent("origin_ezsectele5p1","targetname");
	


	for(;;)
	{
		
                 
                trig waittill ("trigger", player);

                player setorigin (tele8p1.origin);

               
		
		
               	        

	}
}		

ezsectele6()
{

        trig=getent("ezsec_tele6","targetname");
	tele9=getent("origin_ezsectele6","targetname");
	


	for(;;)
	{
		
                 
                trig waittill ("trigger", player);

                player setorigin (tele9.origin);

               
		
		
               	        

	}
}	

ezsectele7()
{

        trig=getent("ezsec_tele7","targetname");
	tele10=getent("origin_ezsectele7","targetname");
	


	for(;;)
	{
		
                 
                trig waittill ("trigger", player);

                player setorigin (tele10.origin);

               
		
		
               	        

	}
}	
ezsectele7p1()
{

        trig=getent("ezsec_tele7p1","targetname");
	tele10p1=getent("origin_ezsectele7p1","targetname");
	


	for(;;)
	{
		
                 
                trig waittill ("trigger", player);

                player setorigin (tele10p1.origin);

               
		
		
               	        

	}
}	

ezsectele8()
{

        trig=getent("ezsec_tele8","targetname");
	tele11=getent("origin_ezsectele8","targetname");
	


	for(;;)
	{
		
                 
                trig waittill ("trigger", player);

                player setorigin (tele11.origin);

               
		
		
               	        

	}
}	

ezsectele9()
{

        trig=getent("ezsec_tele9","targetname");
	tele12=getent("origin_ezsectele9","targetname");
	


	for(;;)
	{
		
                 
                trig waittill ("trigger", player);

                player setorigin (tele12.origin);

               
		
		
               	        

	}
}	
//hard secret teleports	
hardsectele1()
{

        trig=getent("hardsectele1","targetname");
	tele15=getent("origin_hardsectele1","targetname");
	


	for(;;)
	{
		
                 
                trig waittill ("trigger", player);

                player setorigin (tele15.origin);

               
		
		
               	        

	}
}

hardsectele2()
{

        trig=getent("hardsectele2","targetname");
	tele16=getent("origin_hardsectele2","targetname");
	


	for(;;)
	{
		
                 
                trig waittill ("trigger", player);

                player setorigin (tele16.origin);

               
		
		
               	        

	}
}
hardsectele3()
{

        trig=getent("hardsectele3","targetname");
	tele16=getent("origin_hardsectele3","targetname");
	


	for(;;)
	{
		
                 
                trig waittill ("trigger", player);

                player setorigin (tele16.origin);

               
		
		
               	        

	}
}
hardsectele6()
{

        trig=getent("hardsectele6","targetname");
	tele19=getent("origin_hardsectele6","targetname");
	


	for(;;)
	{
		
                 
                trig waittill ("trigger", player);

                player setorigin (tele19.origin);

               
		
		
               	        

	}
}
hardsectele7()
{

        trig=getent("hardsectele7","targetname");
	tele20=getent("origin_hardsectele7","targetname");
	


	for(;;)
	{
		
                 
                trig waittill ("trigger", player);

                player setorigin (tele20.origin);

               
		
		
               	        

	}
}
hardsectele8()
{

        trig=getent("hardsectele8","targetname");
	tele21=getent("origin_hardsectele8","targetname");
	


	for(;;)
	{
		
                 
                trig waittill ("trigger", player);

                player setorigin (tele21.origin);

               
		
		
               	        

	}
}

hardsectele9()
{

        trig=getent("hardsectele9","targetname");
	tele22=getent("origin_hardsectele9","targetname");
	


	for(;;)
	{
		
                 
                trig waittill ("trigger", player);

                player setorigin (tele22.origin);

               
		
		
               	        

	}
}
hardsectele10()
{

        trig=getent("hardsectele10","targetname");
	tele23=getent("origin_hardsectele10","targetname");
	


	for(;;)
	{
		
                 
                trig waittill ("trigger", player);

                player setorigin (tele23.origin);

               
		
		
               	        

	}
}
hardsectele11()
{

        trig=getent("hardsectele11","targetname");
	tele24=getent("origin_hardsectele11","targetname");
	


	for(;;)
	{
		
                 
                trig waittill ("trigger", player);

                player setorigin (tele24.origin);

               
		
		
               	        

	}
}
hardsectele12()
{

        trig=getent("hardsectele12","targetname");
	tele25=getent("origin_hardsectele12","targetname");
	


	for(;;)
	{
		
                 
                trig waittill ("trigger", player);

                player setorigin (tele25.origin);

               
		
		
               	        

	}
}
hardsectele13()
{

        trig=getent("hardsectele13","targetname");
	hardsectele13=getent("origin_hardsectele13","targetname");
	


	for(;;)
	{
		
                 
                trig waittill ("trigger", player);

                player setorigin (hardsectele13.origin);

               
		
		
               	        

	}
}

hardsecend()
{
trig=getent("hardsecend","targetname");

 for(;;)
	{                
    trig waittill ("trigger", player);
	player thread sr\api\_speedrun::finishWay("secret_1");
	}
}