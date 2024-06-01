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
    setDvar("bg_falldamagemaxheight", 20000 );
	setDvar("bg_falldamageminheight", 15000 );

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_map::createSpawn((422, 367, 76), 270);
	thread sr\api\_speedrun::createEndMap((-4110.38, -7309.5, 32.1255), 140, 100);
	
	entTransporter = getentarray( "enter", "targetname" );
	if(isdefined(entTransporter))
	for( i = 0; i < entTransporter.size; i++ )
	entTransporter[i] thread transporter();
	
thread forceFullbright();
thread transporter();
thread move1();
thread move2();
thread trap02b();
thread trap03();
thread trap03b();
thread trap05();
thread trap06();
thread trap06b();
thread trap06c();
thread trap06d();
thread trap08();
thread trap08b();
thread trap09();
thread trap09b();
thread trap10b();
thread trap11();
thread trap12();
thread trap13();
thread trap13bb();
thread trap13b();
thread trap14();
thread trap16();
thread trap17();


}

forcefullbright()
{
    level waittill("round_started");
    while(1)
    {
        players = getEntArray( "player", "classname" );
        for(i = 0; i < players.size; i++){
            players[i] setClientDvar("r_fullbright", 1);
        }
        wait 1;
    }
}

transporter() 
{
	for(;;)
	{
		self waittill( "trigger", player );
		entTarget = getEnt( self.target, "targetname" );
		player setOrigin( entTarget.origin );
		player setplayerangles( entTarget.angles );
		wait 0.1;
	}
}

move1()                   
{                             
move1 = getent("move1","targetname");                                  
                                          

move1 moveY(-100,0.1); 

}

move2()                   
{                             
move2 = getent("move2","targetname");                                  
                                          

move2 moveY(100,0.1); 

}

trap02()                   
{  
hurt = getent("hurt1","targetname");                         
trap02 = getent("trap02","targetname");               
trigger = getent("trigger_trap02","targetname");         

hurt delete();
 

}

trap02b()                   
{  
hurt = getent("hurt2","targetname");                         
trap02b = getent("trap02b","targetname");               
trigger = getent("trigger_trap02","targetname");         

hurt delete();

}

trap03()                   
{  
hurt = getent("hurt3","targetname");                         
trap03 = getent("trap03","targetname");               
trigger = getent("trigger_trap03","targetname");         


hurt delete();                         
}

trap03b()                   
{  
hurt = getent("hurt4","targetname");                         
trap03b = getent("trap03b","targetname");               
trigger = getent("trigger_trap03","targetname");         

hurt delete();                          
}

trap05()                   
{  
hurt = getent("hurt_1","targetname");                         
trap05 = getent("trap05","targetname");               
trigger = getent("trigger_trap05","targetname");         

hurt delete();
}


trap06()                   
{  
hurt = getent("hurt1a","targetname");                         
trap06 = getent("trap06","targetname");               
trigger = getent("trigger_trap06","targetname");         

hurt delete();
}

trap06b()                   
{  
hurt = getent("hurt1b","targetname");                         
trap06b = getent("trap06b","targetname");               
trigger = getent("trigger_trap06","targetname");         

hurt delete();
}

trap06c()                   
{  
hurt = getent("hurt1c","targetname");                         
trap06c = getent("trap06c","targetname");               
trigger = getent("trigger_trap06","targetname");         

hurt delete();
}

trap06d()                   
{  
hurt = getent("hurt1d","targetname");                         
trap06d = getent("trap06d","targetname");               
trigger = getent("trigger_trap06","targetname");         

hurt delete();
}

trap08()                   
{  
hurt = getent("hurtt","targetname");                         
trap08 = getent("trap08","targetname");               
trigger = getent("trigger_trap08","targetname");         

hurt delete();
}

trap08b()                   
{  
hurt = getent("hurtt1","targetname");                         
trap08b = getent("trap08b","targetname");               
trigger = getent("trigger_trap08","targetname");         

hurt delete();
}

trap09()                   
{  
hurt = getent("hurt1234","targetname");                         
trap09 = getent("trap09","targetname");               
trigger = getent("trigger_trap09","targetname");         

hurt delete();                            
}

trap09b()                   
{  
hurt = getent("hurt123","targetname");                         
trap09b = getent("trap09b","targetname");               
trigger = getent("trigger_trap09","targetname");         
hurt delete();                          
}

trap10b()                   
{    
hurt = getent("hurtabc","targetname");                       
trap10b = getent("trap10b","targetname");               
trigger = getent("trigger_trap10","targetname");         

hurt delete();
}

trap11()                   
{  
hurt = getent("hurtop","targetname");                         
trap11 = getent("trap11","targetname");               
trigger = getent("trigger_trap11","targetname");         

hurt delete();
}

trap12()                   
{  
hurt = getent("hurt1aa","targetname");                         
trap12 = getent("trap12","targetname");               
trigger = getent("trigger_trap12","targetname");         

hurt delete();                       
}

trap13()                   
{  
hurt = getent("hurt13a","targetname");                         
trap13 = getent("trap13","targetname");               
trigger = getent("trigger_trap13","targetname");         

hurt delete();
}

trap13bb()                   
{  
hurt = getent("hurt13b","targetname");                         
trap13bb = getent("trap13bb","targetname");               
trigger = getent("trigger_trap13b","targetname");         

hurt delete();
}
trap13b()                   
{  
hurt = getent("hurt13bb","targetname");                         
trap13b = getent("trap13b","targetname");               
trigger = getent("trigger_trap13b","targetname");         

hurt delete();
}

trap14()                   
{  
hurt = getent("hurt144","targetname");                         
trap14 = getent("trap14","targetname");               
trigger = getent("trigger_trap14","targetname");         

hurt delete();
}

trap16()                   
{  
hurt = getent("hurt166","targetname");                         
trap16 = getent("trap16","targetname");               
trigger = getent("trigger_trap16","targetname");         

hurt delete();
}

trap17()                   
{  
hurt = getent("hurt177","targetname");                         
trap17 = getent("trap17","targetname");               
trigger = getent("trigger_trap17","targetname");         

hurt delete();
}
