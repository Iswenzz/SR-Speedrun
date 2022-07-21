main()
{
thread sr\api\_map::createSpawn((-35, 127, 0), 270);   
    level.amber = loadFX("deathrun/amber"); 
    level.fire2 = loadFX("deathrun/fire2"); 	
    maps\mp\_load::main();

	entTransporter = getentarray( "enter", "targetname" );
	if(isdefined(entTransporter))
	for( i = 0; i < entTransporter.size; i++ )
	entTransporter[i] 

thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_speedrun::createSecretWays("Short Way;Secret Way;");
thread sr\api\_speedrun::createTeleporter((113.205, 43.3896, 0.124999), 50, 35, (580, 7968, -852), 270, "freeze", "yellow", "secret_0");
thread sr\api\_speedrun::createTeleporter((-189.235, 45.48, 0.125), 50, 35, (1042, 325, -514), 270, "freeze", "darkred", "secret_1");
thread sr\api\_speedrun::createEndMap((-3169.31, 11666.3, -411.875), 100, 25, "normal_0");
thread sr\api\_speedrun::createEndMap((604.504, 1967.92, -1163.88), 70, 40, "secret_0");
thread sr\api\_speedrun::createEndMap((2384.8, 258.146, -1647.88), 35, 15, "secret_1");

thread tp1();
thread tp2();

//thread transporter();
//thread trap01();
//thread trap03();
//thread trap04();
//thread trap06();
//thread trap061();
//thread trap07();
//thread trap08();
//thread trap09();
//thread trap091();
//thread trap092();
//thread trap10();
//thread trap11();
thread lift1();
//thread trap12();
//thread trap121();
//thread trap13();
//thread trap131();
//thread trap132();
//thread trap133();
//thread trap134();
//thread trap135();
//thread trap136();
//thread trap14();
//thread trap141();
//thread trap15();
//thread trap16();
//thread trap161();
//thread trap17();
//thread trap18();
//thread trap19();
//thread trap0();
//thread trap222();
//thread trap20();
//thread rotate();
//thread trap22();
//thread trap221();
//thread stop0();
//thread stop2();
//thread stop3();
//thread stop4();
//thread stop00();
//thread lol1();
//thread lol2();
//thread secret00();
//thread secret();
//thread snip();
//thread bounce();
//thread knife();
//thread credits();
//thread hunter();
//thread ninja();
//thread trap031();
//thread extra();
//thread done();
//thread old();
//thread old1();
//thread deagle();
//thread air1();
//thread air();
//thread fall();
//thread look();
//thread games();
//thread openfx();
//thread fire2();
//thread music();
//thread trap111();
//thread trapb();
//thread butt1();
//thread butt2();
//thread xxx();
//thread butt4();
//thread butt5();
//thread butt6();
//thread butt7();
//thread butt8();
//thread butt9();
//thread butt10();
//thread butt11();
//thread butt12();
//thread butt13();
//thread butt14();
//thread butt15();
//thread butt16();
//thread butt17();
//thread butt18();
//thread butt19();
//thread trap051();

addTriggerToList("trigger_trap01");
addTriggerToList("trigger_trap02");
addTriggerToList("trigger_trap03");
addTriggerToList("trigger_trap04");
addTriggerToList("trigger_trap05");
addTriggerToList("trigger_trap06");
addTriggerToList("trigger_trap07");
addTriggerToList("trigger_trap08");
addTriggerToList("trigger_trap09");
addTriggerToList("trigger_trap10");
addTriggerToList("trigger_trap11");
addTriggerToList("trigger_trap12");
addTriggerToList("trigger_trap13");
addTriggerToList("trigger_trap14");
addTriggerToList("trigger_trap15");
addTriggerToList("trigger_trap16");
addTriggerToList("trigger_trap17");
addTriggerToList("trigger_trap18");
addTriggerToList("trigger_trap19");		
			
}

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}
	
tp1()
{
	trig = spawn("trigger_radius",(-1517.71, -40.2321, 0.125), 0, 70, 40);
	trig.radius = 70;
	ori_t = getEnt("gohere","targetname");

	wait 1;
	thread sr\api\_map::createTriggerFx(trig, "blue");

	for(;;)
	{
		trig waittill("trigger",player);

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
	}
}

tp2()
{
	trig = spawn("trigger_radius",(2168.09, 234.79, -1647.88), 0, 130, 30);
	trig.radius = 130;
	ori_t = getEnt("gohere36","targetname");

	wait 1;
	thread sr\api\_map::createTriggerFx(trig, "blue");

	for(;;)
	{
		trig waittill("trigger",player);

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
	}
}

transporter()
{
	for(;;)
	{
		self waittill( "trigger", player );
		entTarget = getEnt( self.target, "targetname" );
		wait 0.1;
		player setOrigin( entTarget.origin );
		player setplayerangles( entTarget.angles );
		wait 0.1;
	}
}

trap01()                   
{                          
trap01 = getent("trap01","targetname");               
trigger = getent("trigger_trap01","targetname");         

trigger waittill("trigger", user);       
trigger delete();
                      
trap01 moveZ(-90,1.5);      
wait 5;                   
trap01 moveZ(90,1.5); 
}

trap03()                   
{                          
trap03 = getent("trap03","targetname");               
trigger = getent("trigger_trap03","targetname");         

trigger waittill("trigger", user);       
trigger delete();
                      
trap03 moveX(95,0.5); 
}


trap04()                   
{                          
trap04 = getent("trap04","targetname");               
trigger = getent("trigger_trap04","targetname");         

trigger waittill("trigger", user);       
trigger delete();                        
while(1)
{
trap04 moveX(169,1.5);      
wait 1.5;                   
trap04 moveX(-169,1.5);  
wait 1.5;   
}
}

trap06()                   
{                          
trap06 = getent("trap06","targetname");               
trigger = getent("trigger_trap06","targetname");         

trigger waittill("trigger", user);       
trigger delete();
while(1)
{                    
trap06 moveZ(-115,1.5);      
wait 1;                   
trap06 moveZ(115,1.5); 
wait 1;  
}
}

trap061()                   
{                          
trap061 = getent("trap061","targetname");               
trigger = getent("trigger_trap06","targetname");         

trigger waittill("trigger", user);       
trigger delete();
while(1)
{                   
trap061 moveZ(115,2);      
wait 1;                   
trap061 moveZ(-115,2);
wait 1;   
}
}

trap07()                   
{                          
trap07 = getent("trap07","targetname");               
trigger = getent("trigger_trap07","targetname");         

trigger waittill("trigger", user);       
trigger delete();
while(1)
{                    
trap07 moveZ(-175,2);      
wait 1;                   
trap07 moveZ(175,2); 
wait 1;   
}
}

trap08()                   
{                          
trap08 = getent("trap08","targetname");               
trigger = getent("trigger_trap08","targetname");         

trigger waittill("trigger", user);       
trigger delete();
                      
trap08 moveZ(-900,0.5);      
}

trap09()                   
{                          
trap09 = getent("trap09","targetname");               
trigger = getent("trigger_trap09","targetname");         

trigger waittill("trigger", user);       
trigger delete();
while(1)
{                    
trap09 moveZ(-150,2.5);      
wait 2;                   
trap09 moveZ(150,2.5); 
wait 2;   
}
}

trap091()                   
{                          
trap091 = getent("trap091","targetname");               
trigger = getent("trigger_trap09","targetname");         

trigger waittill("trigger", user);       
trigger delete();
while(1)
{                     
trap091 moveZ(-160,2.5);      
wait 3;                   
trap091 moveZ(160,2.5); 
wait 3;  
}
}

trap092()                   
{                          
trap092 = getent("trap092","targetname");               
trigger = getent("trigger_trap09","targetname");         

trigger waittill("trigger", user);       
trigger delete();
while(1)
{                    
trap092 moveZ(-165,2.5);      
wait 3.5;                   
trap092 moveZ(165,2.5); 
wait 3.5;   
}
}

trap10()                   
{                          
trap10 = getent("trap10","targetname");               
trigger = getent("trigger_trap10","targetname");         

trigger waittill("trigger", user);       
trigger delete();
                      
trap10 moveZ(195,1);      
wait 4;
trap10 moveY(-247,1);
wait 3;
trap10 moveY(247,1); 
wait 4; 
trap10 moveZ(-195,1);                     
}

trap11()                   
{                          
trap11 = getent("trap11","targetname");               
trigger = getent("trigger_trap11","targetname");         

trigger waittill("trigger", user);       
trigger delete();
while(1)
{                     
trap11 moveZ(-100,1.5);      
wait 1.5;                   
trap11 moveZ(100,1.5); 
wait 1.5;  
}
}

lift1()                   
{ 

lift1 = getent("lift1","targetname");   
                                        
lift1 rotateyaw(90, 0.1);      
wait 0.1;                   
lift1 movey(350, 0.1);     

}

trap12()                   
{                          
trap12 = getent("trap12","targetname");               
trigger = getent("trigger_trap12","targetname");         

trigger waittill("trigger", user);       
trigger delete();
while(1)
{                      
trap12 moveZ(-120,1);      
wait 1;                   
trap12 moveZ(120,1); 
wait 1; 
}
}

trap121()                   
{                          
trap121 = getent("trap121","targetname");               
trigger = getent("trigger_trap12","targetname");         

trigger waittill("trigger", user);       
trigger delete();
while(1)
{                   
trap121 moveZ(-120,2);      
wait 2;                 
trap121 moveZ(120,2); 
wait 2; 
}
}

trap13()                   
{                          
trap13 = getent("trap13","targetname");               
trigger = getent("trigger_trap13","targetname");         

trigger waittill("trigger", user);       
trigger delete();
while(1)
{                      
trap13 moveZ(-305,1);      
wait 1.5;                   
trap13 moveZ(305,1); 
wait 1.5; 
}
}

trap131()                   
{                          
trap131 = getent("trap131","targetname");               
trigger = getent("trigger_trap13","targetname");         

trigger waittill("trigger", user);       
trigger delete();
while(1)
{                      
trap131 moveZ(-225,1);      
wait 1.5;                   
trap131 moveZ(225,1); 
wait 1.5; 
}
}

trap132()                   
{                          
trap132 = getent("trap132","targetname");               
trigger = getent("trigger_trap13","targetname");         

trigger waittill("trigger", user);       
trigger delete();
while(1)
{                      
trap132 moveZ(-160,1);      
wait 1.5;                   
trap132 moveZ(160,1); 
wait 1.5; 
}
}

trap133()                   
{                          
trap133 = getent("trap133","targetname");               
trigger = getent("trigger_trap13","targetname");         

trigger waittill("trigger", user);       
trigger delete();
while(1)
{                   
trap133 moveZ(-95,1);      
wait 1.5;                   
trap133 moveZ(95,1); 
wait 1.5; 
}
}

trap134()                   
{                          
trap134 = getent("trap134","targetname");               
trigger = getent("trigger_trap13","targetname");         

trigger waittill("trigger", user);       
trigger delete();
while(1)
{                      
trap134 moveZ(-190,1);      
wait 1.5;                   
trap134 moveZ(190,1); 
wait 1.5; 
}
}

trap135()                   
{                          
trap135 = getent("trap135","targetname");               
trigger = getent("trigger_trap13","targetname");         

trigger waittill("trigger", user);       
trigger delete();
while(1)
{                    
trap135 moveZ(-315,1);      
wait 1.5;                   
trap135 moveZ(315,1); 
wait 1.5; 
}
}

trap136()                   
{                          
trap136 = getent("trap136","targetname");               
trigger = getent("trigger_trap13","targetname");         

trigger waittill("trigger", user);       
trigger delete();
while(1)
{                   
trap136 moveZ(-390,1);      
wait 1.5;                   
trap136 moveZ(390,1); 
wait 1.5; 
}
}

trap14()                   
{                          
trap14 = getent("trap14","targetname");               
trigger = getent("trigger_trap14","targetname");         

trigger waittill("trigger", user);       
trigger delete();
while(1)
{                       
trap14 moveZ(-90,1.5);      
wait 1;                   
trap14 moveZ(90,1.5); 
wait 1;
}
}

trap141()                   
{                          
trap141 = getent("trap141","targetname");               
trigger = getent("trigger_trap14","targetname");         

trigger waittill("trigger", user);       
trigger delete();
while(1)
{                     
trap141 moveZ(-95,1.5);      
wait 1.5;                   
trap141 moveZ(95,1.5); 
wait 1.5;  
}
}

trap15()                   
{                          
trap15 = getent("trap15","targetname");               
trigger = getent("trigger_trap15","targetname");         

trigger waittill("trigger", user);       
trigger delete();
while(1)
{                      
trap15 moveZ(90,1.5);      
wait 1;                   
trap15 moveZ(-90,1.5); 
wait 1; 
}
}

trap16()                   
{                          
trap16 = getent("trap16","targetname");               
trigger = getent("trigger_trap16","targetname");         

trigger waittill("trigger", user);       
trigger delete();
while(1)
{                      
trap16 moveZ(120,1);      
wait 1;                   
trap16 moveZ(-120,1); 
wait 1; 
}
}

trap161()                   
{                          
trap161 = getent("trap161","targetname");               
trigger = getent("trigger_trap16","targetname");         

trigger waittill("trigger", user);       
trigger delete();
while(1)
{                      
trap161 moveZ(120,1);      
wait 1;                   
trap161 moveZ(-120,1); 
wait 1; 
}
}

trap17()                   
{                          
trap17 = getent("trap17","targetname");               
trigger = getent("trigger_trap17","targetname");         

trigger waittill("trigger", user);       
trigger delete();
                      
trap17 moveZ(-190,1);                       
}

trap18()                   
{                          
trap18 = getent("trap18","targetname");               
trigger = getent("trigger_trap18","targetname");         

trigger waittill("trigger", user);       
trigger delete();
                      
trap18 moveZ(-190,1);                       
}

trap19()                   
{                          
trap19 = getent("trap19","targetname");               
trigger = getent("trigger_trap19","targetname");         

trigger waittill("trigger", user);       
trigger delete();
                      
trap19 moveZ(-265,1);                       
}

trap0()                   
{                          
trap0 = getent("trap0","targetname");               
trigger = getent("trigger_trap0","targetname");         

trigger waittill("trigger", user);       
                    
trap0 moveZ(150,0.1); 
wait 0.1;                       
trap0 moveZ(-150,0.1); 
}

trap222()                   
{                          
trap222 = getent("trap222","targetname");                      

while(1)
{
wait 1;                       
trap222 moveZ(100,1);      
wait 1;                   
trap222 moveZ(-100,1); 
}
}

trap20()                   
{                          
trap20 = getent("trap20","targetname");               
trigger = getent("trigger_trap20","targetname");         

trigger waittill("trigger", user);       
trigger delete();                        

trap20 moveX(365,1);      
wait 6;                   
trap20 moveX(-365,1);     
}

rotate()
{
trig = getEnt("trigger_rotate","targetname");             
brush = getEnt("rotate","targetname");                    

trig waittill("trigger", player);                         
trig delete();                                            

while(1) 
{                                                 
wait 0.01;                                            
brush rotatePitch (-360,2); 
wait 2.50;                         
}
}

trap22()                   
{                          
trap22 = getent("trap22","targetname");               
trigger = getent("trigger_trap16","targetname");         

trigger waittill("trigger", user);       
trigger delete();                        
while(1)
{
wait 1;
trap22 moveX(200,1);      
wait 1;                   
trap22 moveX(-200,1);     
}
}

trap221()                   
{                          
trap221 = getent("trap221","targetname");               
trigger = getent("trigger_trap16","targetname");         

trigger waittill("trigger", user);       
trigger delete();                        
while(1)
{
wait 2;
trap221 moveX(200,1);      
wait 2;                   
trap221 moveX(-200,1);     
}
}

stop0()                   
{                          
stop0 = getent("stop0","targetname");               
trigger = getent("sniper","targetname");         

trigger waittill("trigger", user);       
trigger delete();
                      
stop0 moveZ(-195,0.5);      

}

stop2()                   
{                          
stop2 = getent("stop2","targetname");               
trigger = getent("sniper1","targetname");         

trigger waittill("trigger", user);       
trigger delete();
                      
stop2 moveZ(-195,0.5);      

}

stop3()                   
{                          
stop3 = getent("stop3","targetname");               
trigger = getent("sniper2","targetname");         

trigger waittill("trigger", user);       
trigger delete();
                      
stop3 moveZ(-195,0.5);      

}

stop4()                   
{                          
stop4 = getent("stop4","targetname");               
trigger = getent("enter1","targetname");         

trigger waittill("trigger", user);       
trigger delete();
                      
stop4 moveZ(-195,0.5);      

}

stop00()                   
{                          
stop00 = getent("stop00","targetname");               
trigger = getent("sniper","targetname");         

trigger waittill("trigger", user);       
trigger delete();
                      
stop00 moveZ(-195,0.5);      
}

lol1()                   
{                          
lol1 = getent("lol1","targetname");               
trigger = getent("trigger_lol1","targetname");         

trigger waittill("trigger", user);       
trigger delete();
                    
lol1 NotSolid(); 
}

lol2()                   
{                          
lol2 = getent("lol2","targetname");               
trigger = getent("trigger_lol1","targetname");         
    
trigger delete();          
lol2 delete();
}

secret()                   
{                          
secret = getent("secret","targetname");               
trigger = getent("trigger_secret","targetname");         

trigger waittill("trigger", user);       
trigger delete();
                      
secret moveZ(300,1);      
}

secret00()                   
{                          
secret00 = getent("secret00","targetname");               
trigger = getent("trigger_secret00","targetname");         

wait 0.1;
trigger delete();                        
secret00 moveX(55,0.1); 

}

snip()
{
     	level.snip_trig = getEnt( "sniper", "targetname");
     	jump = getEnt( "snip_jump", "targetname" );
     	acti = getEnt( "snip_acti", "targetname" );
     
     	while(1)
     	{
         	level.snip_trig waittill( "trigger", player );
         	if( !isDefined( level.snip_trig ) )
         	return;		

         	player SetPlayerAngles( jump.angles );
         	player setOrigin( jump.origin );
         	player TakeAllWeapons();
         	player GiveWeapon( "mp44_mp" );
	 	player givemaxammo( "mp44_mp" );
         	player GiveWeapon( "sniper_mp" );
	 	player givemaxammo( "sniper_mp" );       
         	level.activ setPlayerangles( acti.angles );
         	level.activ setOrigin( acti.origin );
         	level.activ TakeAllWeapons();
         	level.activ GiveWeapon( "mp44_mp" );
	 	level.activ givemaxammo( "mp44_mp" );
         	level.activ GiveWeapon( "sniper_mp" );
	 	level.activ givemaxammo( "sniper_mp" );
		iPrintlnBold( " ^2" + player.name + " ^5 has entered the Sniper  room^1!" );         		
		wait .5;
         	player switchToWeapon( "mp44_mp" );
         	level.activ SwitchToWeapon( "mp44_mp" );
		player freezecontrols(true); 
		level.activ freezecontrols(true);
		wait 1;
		player iPrintlnBold( "^53" );
		level.activ iPrintlnBold( "^53" );
		wait 1;
		player iPrintlnBold( "^52" );
		level.activ iPrintlnBold( "^52" );
		wait 1;
		player iPrintlnBold( "^51" );
		level.activ iPrintlnBold( "^51" );
		wait 1;
		player iPrintlnBold( "^5Fight^1!" );
		level.activ iPrintlnBold( "^5Fight^1!" );
		player freezecontrols(false); 
		level.activ freezecontrols(false); 
     	}
}
  
bounce()
{
     	level.bounce_trig = getEnt( "assault", "targetname");
     	jump = getEnt( "bounce_tele_jump", "targetname" );
     	acti = getEnt( "bounce_tele_acti", "targetname" );
     
     	while(1)
     	{
         	level.bounce_trig waittill( "trigger", player );
         	if( !isDefined( level.bounce_trig ) )
         	return;
			
         	player SetPlayerAngles( jump.angles );
         	player setOrigin( jump.origin );
         	player TakeAllWeapons();
		player giveweapon( "tomahawk_mp" );     
         	level.activ setPlayerangles( acti.angles );
         	level.activ setOrigin( acti.origin );
         	level.activ TakeAllWeapons();
		level.activ giveweapon( "tomahawk_mp" ); 
		iPrintlnBold( " ^2" + player.name + " ^5 has entered the Bounce  room^1!" );         
         	wait 0.05;
		level.activ switchtoweapon( "tomahawk_mp" );
		player switchtoweapon( "tomahawk_mp" );
		player freezecontrols(true); 
		level.activ freezecontrols(true);
		wait 1;
		player iPrintlnBold( "^53" );
		level.activ iPrintlnBold( "^53" );
		wait 1;
		player iPrintlnBold( "^52" );
		level.activ iPrintlnBold( "^52" );
		wait 1;
		player iPrintlnBold( "^51" );
		level.activ iPrintlnBold( "^51" );
		wait 1;
		player iPrintlnBold( "^5Bounce^1!" );
		level.activ iPrintlnBold( "^5Bounce^1!" );
		player freezecontrols(false); 
		level.activ freezecontrols(false); 
     	}
}
              
knife()
{
     	level.knife_trig = getEnt( "knife", "targetname");
     	jump = getEnt( "knife_jump", "targetname" );
     	acti = getEnt( "knife_acti", "targetname" );
     
     	while(1)
     	{
         	level.knife_trig waittill( "trigger", player );
         	if( !isDefined( level.knife_trig ) )
         	return;
			
         	player SetPlayerAngles( jump.angles );
         	player setOrigin( jump.origin );
         	player TakeAllWeapons();
         	player GiveWeapon( "tomahawk_mp" );      
         	level.activ setPlayerangles( acti.angles );
         	level.activ setOrigin( acti.origin );
         	level.activ TakeAllWeapons();
         	level.activ GiveWeapon( "tomahawk_mp" ); 
		iPrintlnBold( " ^2" + player.name + " ^5 has entered the Knife  room^1!" );               
         	wait 0.05;
         	player switchToWeapon( "tomahawk_mp" );
         	level.activ SwitchToWeapon( "tomahawk_mp" );
		player freezecontrols(true); 
		level.activ freezecontrols(true);
		wait 1;
		player iPrintlnBold( "^53" );
		level.activ iPrintlnBold( "^53" );
		wait 1;
		player iPrintlnBold( "^52" );
		level.activ iPrintlnBold( "^52" );
		wait 1;
		player iPrintlnBold( "^51" );
		level.activ iPrintlnBold( "^51" );
		wait 1;
		player iPrintlnBold( "^5Fight^1!" );
		level.activ iPrintlnBold( "^5Fight^1!" );
		player freezecontrols(false); 
		level.activ freezecontrols(false);  
     	}
}

credits()
{
trigger = getent("credits","targetname");         

trigger waittill("trigger", user);       
trigger delete();

iPrintlnBold( "^5map made by" );
wait 1;
iPrintlnBold( "^5Atally" );
wait 1;
iPrintlnBold( "^5othere help :D" );
wait 1;
iPrintlnBold( "^5Jynx,kill3r,Simox,Darmuh," );
wait 2.5;
iPrintlnBold( "^1pls do not cheat" );
wait 1;
iPrintlnBold( "^1And if u find any bugs report to me xD" );
wait 2.5;
wait 1;
iPrintlnBold( "^3Thank ^1Kill3r ^3snd ^5Semi ^3 for the weapons " );
wait 2.5;
iPrintlnBold( "^4HAVE FUN" );
wait 1;
iPrintlnBold( "^4:D" );
}

hunter()                   
{                          
hunter = getent("hunter","targetname");               
                    
hunter NotSolid(); 
}

ninja()
{
trigger = getent("ninja","targetname");         

trigger waittill("trigger", user);       
trigger delete();

iPrintlnBold( "^5This Is A Shout OUT" );
wait 1;
iPrintlnBold( "^5FOR" );
wait 1;
iPrintlnBold( "^1[pulse]ninja" );
wait 1;
iPrintlnBold( "^5that is all xD" );
}

trap031()                   
{                          
trap031 = getent("trap031","targetname");               
trigger = getent("trigger_trap03","targetname");         

trigger waittill("trigger", user);       
trigger delete();
                      
trap031 moveZ(-900,0.5);      
}

extra()                   
{                          
extra = getent("extra","targetname");               
trigger = getent("trigger_trap10","targetname");         

trigger waittill("trigger", user);       
trigger delete();
                      
extra moveZ(195,1,5);      
wait 8;
extra moveZ(-195,1.5);                     
}

done()
{
trigger = getent("done","targetname");         

trigger waittill("trigger", user);       
trigger delete();

iPrintlnBold( "^4THE MAP HAS BEEN FINISHED ^1D:" );
}

old()                   
{                          
old = getent("old","targetname");               
trigger = getent("trigger_old","targetname");         

trigger waittill("trigger", user);       
trigger delete();

iPrintlnBold( "^4old room is open ^5Acti get ready" );
wait 1;                   
old moveZ(-195,2);                         
}

old1()                   
{                          
old1 = getent("old1","targetname");               
trigger = getent("trigger_old","targetname");         

trigger waittill("trigger", user);       
trigger delete();
              
old1 moveX(200,2);
wait 1;
old1 moveZ(-60,2);                       
}

deagle()
{
     	level.deagle_trig = getEnt( "deagle", "targetname");
     	jump = getEnt( "air_drop_jump", "targetname" );
     	acti = getEnt( "air_drop_acti", "targetname" );
     
     	while(1)
     	{
         	level.deagle_trig waittill( "trigger", player );
         	if( !isDefined( level.deagle_trig ) )
         	return;
			
         	player SetPlayerAngles( jump.angles );
         	player setOrigin( jump.origin );
         	player TakeAllWeapons();
		player giveweapon( "ray_gun_mp" );  
        player givemaxammo( "ray_gun_mp" ); 		
         	level.activ setPlayerangles( acti.angles );
         	level.activ setOrigin( acti.origin );
         	level.activ TakeAllWeapons();
		level.activ giveweapon( "ray_gun_mp" );
        level.activ GiveWeapon( "ray_gun_mp" );	
		iPrintlnBold( " ^2" + player.name + " ^5 has entered the air drop room^1!" );         
         	wait 0.05;
		level.activ switchtoweapon( "ray_gun_mp" );
		player switchtoweapon( "ray_gun_mp" );
		player freezecontrols(true); 
		level.activ freezecontrols(true);
		wait 1;
		player iPrintlnBold( "^53" );
		level.activ iPrintlnBold( "^53" );
		wait 1;
		player iPrintlnBold( "^52" );
		level.activ iPrintlnBold( "^52" );
		wait 1;
		player iPrintlnBold( "^51" );
		level.activ iPrintlnBold( "^51" );
		wait 1;
		player iPrintlnBold( "^5GET READY^1!" );
		level.activ iPrintlnBold( "^5GET READY^1!" );
		player freezecontrols(false); 
		level.activ freezecontrols(false);
     	}
}

air1()                   
{                          
air1 = getent("air1","targetname");               
trigger = getent("trigger_air","targetname");         

trigger waittill("trigger", user);       
trigger delete(); 

level.player AllowJump(false);
wait 4;                     
air1 NotSolid();        
}

air()                   
{                          
air = getent("air","targetname");               
trigger = getent("trigger_air","targetname");         

trigger waittill("trigger", user);       
trigger delete(); 
 
level.player AllowJump(false);                     
wait 4;
air NotSolid();       
}

fall()
{
     	level.fall_trig = getEnt( "fall", "targetname");
     	jump = getEnt( "fall_jump", "targetname" );
     	acti = getEnt( "fall_acti", "targetname" );
     
     	while(1)
     	{
         	level.fall_trig waittill( "trigger", player );
         	if( !isDefined( level.deagle_trig ) )
         	return;

         	player SetPlayerAngles( jump.angles );
         	player setOrigin( jump.origin );
         	player TakeAllWeapons();
		player giveweapon( "usp_mp" );  
        player givemaxammo( "usp_mp" ); 		
         	level.activ setPlayerangles( acti.angles );
         	level.activ setOrigin( acti.origin );
         	level.activ TakeAllWeapons();
		level.activ giveweapon( "usp_mp" );
        level.activ GiveWeapon( "usp_mp" );	
		iPrintlnBold( " ^2" + player.name + " ^5 has entered the Pistol room^1!" );         
         	wait 0.05;
		level.activ switchtoweapon( "usp_mp" );
		player switchtoweapon( "usp_mp" );
		player freezecontrols(true); 
		level.activ freezecontrols(true);
		wait 1;
		player iPrintlnBold( "^53" );
		level.activ iPrintlnBold( "^53" );
		wait 1;
		player iPrintlnBold( "^52" );
		level.activ iPrintlnBold( "^52" );
		wait 1;
		player iPrintlnBold( "^51" );
		level.activ iPrintlnBold( "^51" );
		wait 1;
		player iPrintlnBold( "^5GET READY^1!" );
		level.activ iPrintlnBold( "^5GET READY^1!" );
		player freezecontrols(false); 
		level.activ freezecontrols(false);
     	}
}

look()                   
{                          
look = getent("look","targetname");               
trigger = getent("trigger_trap03","targetname");         

trigger waittill("trigger", user);       
trigger delete();
                        
look Hide(); 
}

games() 
{ 
level.games_trig = getEnt( "minigames", "targetname"); 
games = getEnt( "minigames_ori", "targetname" ); 

while(1) 
{ 
level.games_trig waittill( "trigger", player ); 
if( !isDefined( level.games_trig ) ) 
return; 

level.old_trig delete(); 

player SetPlayerAngles( games.angles ); 
player setOrigin( games.origin ); 
iPrintlnBold( " ^5" + player.name + " ^7 has ^5entered the ^7games section^5!" ); 
player TakeAllWeapons(); 	
player died(); 


while( isAlive( player ) && isDefined( player ) ) 
if( isDefined( level.activ ) && isAlive( level.activ ) ) 
wait 1; 
} 
} 
died() 
{ 
self endon("disconnect"); 

self waittill("death"); 
iPrintlnBold("^5"+self.name+" ^7has ^5died^7!"); 
iPrintlnBold("^5T^7he ^5M^7inigames ^5S^7ection ^5i^7s ^5n^7ow ^5O^7PEN^5."); 
}

openfx()                   
{                          
openfx = getent("openfx","targetname");               
trigger = getent("trigger_openfx","targetname");         

trigger waittill("trigger", user);       
trigger delete();
                      
openfx moveZ(-500,1.5);      
}

fire2()                   
{                                       
trigger = getent("fire2","targetname");         

trigger waittill("trigger", user);       
trigger delete();
                      
playLoopedFX(level.fire2, 0.05, (-1664.0,-32.0,55.0));  
wait 1;
playLoopedFX(level.fire2, 0.05, (-1344.0,-16.0,55.0));  
}

music()
{
	song = [];
	song[song.size] = "pulse";
	song[song.size] = "inferno";
	song[song.size] = "monster";
    song[song.size] = "sixteen";
	song[song.size] = "turn_down";
	song[song.size] = "razor";
	
	rz = randomint(song.size);
	play = song[rz];

	ambientPlay(play);
}

trap111()                   
{                          
trap111 = getent("trap111","targetname");               
trigger = getent("trigger_trap11","targetname");         

trigger waittill("trigger", user);       
trigger delete();
while(1)
{
wait 2;                       
trap111 moveZ(-100,1.5);      
wait 2;                   
trap111 moveZ(100,1.5); 
}
}

trapb()                   
{                          
trapb = getent("trapb","targetname");               
trigger = getent("trigger_trap15","targetname");         

trigger waittill("trigger", user);       
trigger delete();                        
while(1)
{
trapb moveX(290,1.5);      
wait 2.5;                   
trapb moveX(-290,1.5); 
wait 2.5;     
}
}

butt1()                   
{                          
butt1 = getent("butt1","targetname");               
trigger = getent("trigger_trap01","targetname");         

trigger waittill("trigger", user);       
trigger delete();
                    
butt1 moveZ(-95,2.5);       
}


butt2()                   
{                          
butt2 = getent("butt2","targetname");               
trigger = getent("trigger_rotate","targetname");         

trigger waittill("trigger", user);       
trigger delete();
                    
butt2 moveZ(-95,2.5);       
}

xxx()                   
{                          
xxx = getent("xxx","targetname");               
trigger = getent("trigger_trap03","targetname");         

trigger waittill("trigger", user);       
trigger delete();
                    
xxx moveZ(-95,2.5);       
}

butt4()                   
{                          
butt4 = getent("butt4","targetname");               
trigger = getent("trigger_trap04","targetname");         

trigger waittill("trigger", user);       
trigger delete();
                    
butt4 moveZ(-95,2.5);       
}

butt5()                   
{                          
butt5 = getent("butt5","targetname");               
trigger = getent("trigger_trap05","targetname");         

trigger waittill("trigger", user);       
trigger delete();
                    
butt5 moveZ(-95,2.5);       
}

butt6()                   
{                          
butt6 = getent("butt6","targetname");               
trigger = getent("trigger_trap06","targetname");         

trigger waittill("trigger", user);       
trigger delete();
                    
butt6 moveZ(-95,2.5);       
}

butt7()                   
{                          
butt7 = getent("butt7","targetname");               
trigger = getent("trigger_trap07","targetname");         

trigger waittill("trigger", user);       
trigger delete();
                    
butt7 moveZ(-95,2.5);       
}

butt8()                   
{                          
butt8 = getent("butt8","targetname");               
trigger = getent("trigger_trap20","targetname");         

trigger waittill("trigger", user);       
trigger delete();
                    
butt8 moveZ(-95,2.5);       
}

butt9()                   
{                          
butt9 = getent("butt9","targetname");               
trigger = getent("trigger_trap08","targetname");         

trigger waittill("trigger", user);       
trigger delete();
                    
butt9 moveZ(-95,2.5);       
}

butt10()                   
{                          
butt10 = getent("butt10","targetname");               
trigger = getent("trigger_trap09","targetname");         

trigger waittill("trigger", user);       
trigger delete();
                    
butt10 moveZ(-95,2.5);       
}

butt11()                   
{                          
butt11 = getent("butt11","targetname");               
trigger = getent("trigger_trap10","targetname");         

trigger waittill("trigger", user);       
trigger delete();
                    
butt11 moveZ(-95,2.5);       
}

butt12()                   
{                          
butt12 = getent("butt12","targetname");               
trigger = getent("trigger_trap12","targetname");         

trigger waittill("trigger", user);       
trigger delete();
                    
butt12 moveZ(-95,2.5);       
}

butt13()                   
{                          
butt13 = getent("butt13","targetname");               
trigger = getent("trigger_trap13","targetname");         

trigger waittill("trigger", user);       
trigger delete();
                    
butt13 moveZ(-95,2.5);       
}

butt14()                   
{                          
butt14 = getent("butt14","targetname");               
trigger = getent("trigger_trap14","targetname");         

trigger waittill("trigger", user);       
trigger delete();
                    
butt14 moveZ(-95,2.5);       
}

butt15()                   
{                          
butt15 = getent("butt15","targetname");               
trigger = getent("trigger_trap15","targetname");         

trigger waittill("trigger", user);       
trigger delete();
                    
butt15 moveZ(-95,2.5);       
}

butt16()                   
{                          
butt16 = getent("butt16","targetname");               
trigger = getent("trigger_trap16","targetname");         

trigger waittill("trigger", user);       
trigger delete();
                    
butt16 moveZ(-95,2.5);       
}

butt17()                   
{                          
butt17 = getent("butt17","targetname");               
trigger = getent("trigger_trap17","targetname");         

trigger waittill("trigger", user);       
trigger delete();
                    
butt17 moveZ(-95,2.5);       
}

butt18()                   
{                          
butt18 = getent("butt18","targetname");               
trigger = getent("trigger_trap18","targetname");         

trigger waittill("trigger", user);       
trigger delete();
                    
butt18 moveZ(-95,2.5);       
}

butt19()                   
{                          
butt19 = getent("butt19","targetname");               
trigger = getent("trigger_trap19","targetname");         

trigger waittill("trigger", user);       
trigger delete();
                    
butt19 moveZ(-95,2.5);       
}

trap051()                   
{                          
trap051 = getent("trap051","targetname");               
trigger = getent("trigger_trap05","targetname");         

trigger waittill("trigger", user);       
trigger delete();                        

trap051 moveZ(150,1.5);      
wait 1;
trap051 moveZ(-115,1.5); 
wait 1;  
trap051 moveZ(115,1.5); 
wait 1; 
trap051 moveZ(-115,1.5); 
wait 1;
trap051 moveZ(115,1.5); 
wait 1;                
trap051 moveZ(-150,1.5);     
}


























