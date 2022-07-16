main()
{
	thread sr\api\_speedrun::createNormalWays("^2Easy Way;^1Hard Way;");
	auto_spawn = getEntArray("mp_jumper_spawn", "classname");
	if(auto_spawn.size > 0)
		thread sr\api\_map::createSpawnOrigin(auto_spawn[int(auto_spawn.size / 2)].origin, auto_spawn[int(auto_spawn.size / 2)].angles[1]);
maps\mp\_load::main();
setdvar( "r_specularcolorscale", "1" );

thread sr\api\_speedrun::createEndMap((1580, 1059, -364), 100, 150);

	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1200");
	precacheItem("rpg_mp");
PreCacheItem("deserteaglegold_mp");
        PreCacheItem("winchester1200_mp");
        PreCacheItem("skorpion_mp");
        PreCacheItem("remington700_mp");
	/* [AUTO DELETE] ambientPlay("rock"); */
thread first_door();
thread tele1();
thread tele2();
thread tele3();
thread tele4();
thread tele5();
thread tele6();
thread tele7();
//thread move();
//thread trap1();
//thread trap2();
//thread trap3();
//thread trap4();
//thread trap5();
//thread trap6();
//thread trap7();
//thread trap8();
//thread trap9();
//thread trap10();
// thread jackpot();
/* [AUTO DELETE] thread sniper_room(); */
// thread jump_room();
/* [AUTO DELETE] thread knife_room(); */
/* [AUTO DELETE] thread givexp(); */
addTriggerToList( "t1" );
		addTriggerToList( "t2" );
		addTriggerToList( "t3" );
		addTriggerToList( "t4" );
		addTriggerToList( "t5" );
		addTriggerToList( "t6" );
		addTriggerToList( "t7" );
		addTriggerToList( "t8" );
		addTriggerToList( "t9" );
		addTriggerToList( "t10" );
}


addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}


jackpot()
{
trig = getEnt ("dafaq" , "targetname");
trig waittill ("trigger", player);
trig delete();

     /* [AUTO DELETE] iPrintlnBold( "^1OoOOooO ^2ASomeone ^3Just found a jackpot!" ); */   
	 }

	 
trap1()
{
	level endon("trigger");
trig = getEnt ("t1", "targetname");
b = getEnt ("b1", "targetname");
trig waittill ("trigger", player);
trig delete();

b moveZ (500,1);
wait 3;
b moveZ (-500,1);
wait 3;
}


trap2()
{
	level endon("trigger");
trig = getEnt ("t2", "targetname");
b = getEnt ("b2", "targetname");
trig waittill ("trigger", player);
trig delete();

b moveZ (100,1);
wait 3;
b moveZ (-100,1);
wait 3;
b moveZ (100,1);
wait 3;
b moveZ (-100,1);
wait 3;
}



trap3()
{
	level endon("trigger");
trig = getEnt ("t3", "targetname");
b = getEnt ("b3", "targetname");
trig waittill ("trigger", player);
trig delete();
while(1)
{
b moveZ (-300,1);
wait 3;
b moveZ (300,1);
wait 3;
}
}



 trap4()
{
	level endon("trigger");
   trig = getEnt ("t4" , "targetname");
   spikes = getEnt ("b4" ,"targetname" );
   hurt = getEnt ("hurtspike" , "targetname");
   hurt2= getEnt ("hurtspike2" , "targetname");
   trig waittill ("trigger", player);  
   trig delete();  
   
   hurt enablelinkto();
   hurt linkto (spikes);
   hurt2 enablelinkto();
   hurt2 linkto (spikes);
   
        spikes moveZ (20,1); 
        wait 5;
         spikes moveZ (-20,1); 
        wait 5;
    
}



trap5()
{
	level endon("trigger");
trig = getEnt ("t5", "targetname");
b = getEnt ("b5", "targetname");
trig waittill ("trigger", player);
trig delete();

b moveZ (-900,1);
wait 3;
}


trap6()
{
	level endon("trigger");
trig = getEnt ("t6", "targetname");
b = getEnt ("b6a", "targetname");
b2 = getEnt ("b6b", "targetname");
trig waittill ("trigger", player);
trig delete();


b moveZ (-300,1);
b2 moveZ (300,1);
wait 1;
b moveZ (300,1);
b2 moveZ (-300,1);
wait 1;
}



trap7()
{
	level endon("trigger");
trig = getEnt ("t7", "targetname");
b = getEnt ("b7", "targetname");
trig waittill ("trigger", player);
trig delete();

b rotateRoll (-360,1);
wait 1;
}



trap8()
{
	level endon("trigger");
trig = getEnt ("t8", "targetname");
b = getEnt ("b8a", "targetname");
b2 = getEnt ("b8b", "targetname");
trig waittill ("trigger", player);
trig delete();


b moveY (-190,1);
b2 moveY (190,1);
wait 1;
b moveY (190,1);
b2 moveY (-190,1);
wait 1;
}


trap9()
{
	level endon("trigger");
trig = getEnt("t9","targetname");
trap = getEnt("b9","targetname");
trig waittill("trigger");
trig delete();

while(1)
{
trap RotatePitch (360,2);
wait 5;
}
}


 trap10()
{
	level endon("trigger");
   trig = getEnt ("t10" , "targetname");
   spikes = getEnt ("b10" ,"targetname" );
   hurt = getEnt ("hurtlast" , "targetname");
   trig waittill ("trigger", player);  
   trig delete();  
   
   hurt enablelinkto();
   hurt linkto (spikes);
   
        spikes moveZ (240,1); 
        wait 10;
         spikes moveZ (-240,1); 
        wait 10;
    
}



tele1()
{
        entTransporter = getentarray( "easy", "targetname" );
        if(isdefined(entTransporter))
                for( i = 0; i < entTransporter.size; i++ )
                        entTransporter[i] thread transporter1();
}

 
transporter1()
{
        for(;;)
        {
                self waittill( "trigger", player );
                entTarget = getEnt( self.target, "targetname" );
                /* [AUTO DELETE] wait 0.1; */
                player setOrigin( entTarget.origin );
                player setplayerangles( entTarget.angles );

                /* [AUTO DELETE] wait 0.1; */
                player thread sr\api\_speedrun::changeWay("normal_0");
        }
}


tele2()
{
        entTransporter = getentarray( "starttele", "targetname" );
        if(isdefined(entTransporter))
                for( i = 0; i < entTransporter.size; i++ )
                        entTransporter[i] thread transporter2();
}

 
transporter2()
{
        for(;;)
        {
                self waittill( "trigger", player );
                entTarget = getEnt( self.target, "targetname" );
                /* [AUTO DELETE] wait 0.1; */
                player setOrigin( entTarget.origin );
                player setplayerangles( entTarget.angles );
                /* [AUTO DELETE] wait 0.1; */
        }
}


tele3()
{
        entTransporter = getentarray( "wtf", "targetname" );
        if(isdefined(entTransporter))
                for( i = 0; i < entTransporter.size; i++ )
                        entTransporter[i] thread transporter3();
}

 
transporter3()
{
        for(;;)
        {
                self waittill( "trigger", player );
                entTarget = getEnt( self.target, "targetname" );
                /* [AUTO DELETE] wait 0.1; */
                player setOrigin( entTarget.origin );
                player setplayerangles( entTarget.angles );
                /* [AUTO DELETE] wait 0.1; */
                player thread sr\api\_speedrun::changeWay("normal_1");
        }
}


tele4()
{
        entTransporter = getentarray( "lol", "targetname" );
        if(isdefined(entTransporter))
                for( i = 0; i < entTransporter.size; i++ )
                        entTransporter[i] thread transporter4();
}

 
transporter4()
{
        for(;;)
        {
                self waittill( "trigger", player );
                entTarget = getEnt( self.target, "targetname" );
                /* [AUTO DELETE] wait 0.1; */
                player setOrigin( entTarget.origin );
				/* [AUTO DELETE] iPrintlnBold( "^10ooo0 my ^0God" + player.name + " ^3Completed the ^1Hard" ); */ 
                player setplayerangles( entTarget.angles );
                /* [AUTO DELETE] wait 0.1; */
        }
}


tele5()
{
        entTransporter = getentarray( "last", "targetname" );
        if(isdefined(entTransporter))
                for( i = 0; i < entTransporter.size; i++ )
                        entTransporter[i] thread transporter5();
}

 
transporter5()
{
        for(;;)
        {
                self waittill( "trigger", player );
                entTarget = getEnt( self.target, "targetname" );
                /* [AUTO DELETE] wait 0.1; */
                player setOrigin( entTarget.origin );
                player setplayerangles( entTarget.angles );
                /* [AUTO DELETE] wait 0.1; */
        }
}


tele6()
{
        entTransporter = getentarray( "jump3", "targetname" );
        if(isdefined(entTransporter))
                for( i = 0; i < entTransporter.size; i++ )
                        entTransporter[i] thread transporter6();
}

 
transporter6()
{
        for(;;)
        {
                self waittill( "trigger", player );
                entTarget = getEnt( self.target, "targetname" );
                /* [AUTO DELETE] wait 0.1; */
                player setOrigin( entTarget.origin );
                player setplayerangles( entTarget.angles );
                /* [AUTO DELETE] wait 0.1; */
        }
}


tele7()
{
        entTransporter = getentarray( "jump2", "targetname" );
        if(isdefined(entTransporter))
                for( i = 0; i < entTransporter.size; i++ )
                        entTransporter[i] thread transporter7();
}

 
transporter7()
{
        for(;;)
        {
                self waittill( "trigger", player );
                entTarget = getEnt( self.target, "targetname" );
                /* [AUTO DELETE] wait 0.1; */
                player setOrigin( entTarget.origin );
                player setplayerangles( entTarget.angles );
                /* [AUTO DELETE] wait 0.1; */
        }
}



move()
{
brush = getent ("movea", "targetname");
brush2 = getent ("moveb", "targetname");
while(1)
{
brush moveX (432,3);
brush2 moveX (-432,3);
wait 1;
brush moveX (-432,3);
brush2 moveX (432,3);
wait 1;
}
}


first_door()
{

	trig = getEnt("opendoor","targetname");
	brush = getEnt("openbrush","targetname");
	button = getEnt("button_door","targetname");
	
	// trig waittill("trigger", user);
	trig delete();
	
	button moveY(8,2);
	wait 2;
	brush moveZ(-340,2);
	brush waittill("movedone");
	brush delete();
	
}


sniper_room()
{
    level.sniper_trig = getEnt( "sniper_room", "targetname");
        jump = getEnt( "sniper_jump", "targetname" );
        acti = getEnt( "sniper_acti", "targetname");
   
        while(1)
        {
                level.sniper_trig waittill( "trigger", player );
                if( !isDefined( level.sniper_trig ) )
                        return;
               
                level.jump_trig delete();
                level.knife_trig delete();
                                 
                                     
                player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                /* [AUTO DELETE] player TakeAllWeapons(); */
                /* [AUTO DELETE] player GiveWeapon( "remington700_mp" ); */        
                level.activ setPlayerangles( acti.angles );
                level.activ setOrigin( acti.origin );
                /* [AUTO DELETE] level.activ TakeAllWeapons(); */
                /* [AUTO DELETE] level.activ GiveWeapon( "remington700_mp" ); */          
                wait 0.05;
                /* [AUTO DELETE] player switchToWeapon( "remington700_mp" ); */
                /* [AUTO DELETE] level.activ SwitchToWeapon( "remington700_mp" ); */
                /* [AUTO DELETE] iPrintlnBold( " ^6LoL" + player.name + " ^4 has chosen ^1snipe room!" ); */                //change it as you wish
                while( isAlive( player ) && isDefined( player ) )
                        wait 1;
        }
}
              

knife_room()
{
    level.knife_trig = getEnt( "knife_room", "targetname");
        jump = getEnt( "knife_jump", "targetname");
        acti = getEnt( "knife_acti", "targetname");
   
        while(1)
        {
                level.knife_trig waittill( "trigger", player );
                if( !isDefined( level.knife_trig ) )
                        return;
               
                level.sniper_trig delete();
                level.jump_trig delete();
                                 
                                     
                player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                /* [AUTO DELETE] player TakeAllWeapons(); */
                /* [AUTO DELETE] player GiveWeapon( "tomahawk_mp" ); */            
                level.activ setPlayerangles( acti.angles );
                level.activ setOrigin( acti.origin );
                /* [AUTO DELETE] level.activ TakeAllWeapons(); */
                /* [AUTO DELETE] level.activ GiveWeapon( "tomahawk_mp" ); */              
                wait 0.05;
                /* [AUTO DELETE] player switchToWeapon( "tomahawk_mp" ); */
                /* [AUTO DELETE] level.activ SwitchToWeapon( "tomahawk_mp" ); */
                /* [AUTO DELETE] iPrintlnBold( " ^6LoL" + player.name + " ^3has chosen ^1knife room" ); */                //change it as you wish
                while( isAlive( player ) && isDefined( player ) )
                        wait 1;
        }
}


jump_room()
{
    // level.jump_trig = getEnt( "jump_room", "targetname");
    //     jump = getEnt( "jump_jump", "targetname");
    //     acti = getEnt( "jump_acti", "targetname");
   
    //     while(1)
    //     {
    //             level.jump_trig waittill( "trigger", player );
    //             if( !isDefined( level.jump_trig ) )
    //                     return;
               
    //             level.sniper_trig delete();
    //             level.knife_trig delete();
                                 
                                     
    //             player SetPlayerAngles( jump.angles );
    //             player setOrigin( jump.origin );
    //             /* [AUTO DELETE] player TakeAllWeapons(); */
    //             /* [AUTO DELETE] player GiveWeapon( "tomahawk_mp" ); */            
    //             level.activ setPlayerangles( acti.angles );
    //             level.activ setOrigin( acti.origin );
    //             /* [AUTO DELETE] level.activ TakeAllWeapons(); */
    //             /* [AUTO DELETE] level.activ GiveWeapon( "tomahawk_mp" ); */              
    //             /* [AUTO DELETE] wait 0.05; */
    //             /* [AUTO DELETE] player switchToWeapon( "tomahawk_mp" ); */
    //             /* [AUTO DELETE] level.activ SwitchToWeapon( "tomahawk_mp" ); */
    //             /* [AUTO DELETE] iPrintlnBold( " ^6 LoL" + player.name + " ^3has chosen ^1Jump room" ); */                //change it as you wish
    //             while( isAlive( player ) && isDefined( player ) )
    //                     /* [AUTO DELETE] wait 1; */
    //     }
}


givexp()
{
	trig = getent("givexp", "targetname");
	
	while(1)
	{
		trig waittill ( "trigger", player );
		trig delete();
		if(!isDefined(player.gotCherryXP))
		{
			/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 200); */
			 /* [AUTO DELETE] iprintlnbold ( player.name + "^3got^1xp!!!" ); */
			player.gotCherryXP = true;
		}
	}

	}
