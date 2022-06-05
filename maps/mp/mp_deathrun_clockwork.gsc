main()
{
trigger = spawn("trigger_radius", (16593.9, -0.335908, 16.125), 0, 160, 135);
trigger.targetname = "endmap_trig";
trigger.radius = 160;
	maps\mp\_load::main();
//AUTO 	ambientPlay("tacos");
	
	level.bjump1 = getEnt( "jb1", "targetname" );
	level.bacti1 = getEnt( "ab1", "targetname" );
	
	auto_spawn = getEntArray("mp_jumper_spawn", "classname");
	if(auto_spawn.size > 0)
	thread sr\api\_map::create_normal_way("Normal Way;");
		thread sr\api\_map::create_spawn_auto(auto_spawn[0].origin, auto_spawn[0].angles[1]);
	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap5();
	thread trap6();
	thread trap7();
	thread trap8();
	thread trap9();
	thread trap10();
//AUTO 	thread Sniper();
//AUTO 	thread Knife();
//AUTO 	thread Bounce();
	thread Clock();
	jumpreset1();
	
}

trap1()
{
	act1 = getEnt ("trap1_acti", "targetname");
	rotate1 = getEnt ("trap1_trap", "targetname");
	
/* AUTO 	act1 waittill ("trigger");
	act1 delete();
	
	while (1) //makes it always rotate
		{
			rotate1 rotatepitch (360, 5); //rotateroll rotateyaw rotatepitch
			wait 2; //same speed brush rotates
		}
*/}

trap2()
{
	act1 = getEnt ("trap2_acti", "targetname");
	rotate1 = getEnt ("trap2_trap", "targetname");
	
/* AUTO 	act1 waittill ("trigger");
	act1 delete();
	
	while (1) //makes it always rotate
		{
			rotate1 rotateroll (360, 2); //rotateroll rotateyaw rotatepitch
			wait 2; //same speed brush rotates
		}
*/}

trap3()
{
    trig = getEnt ("trap3_acti", "targetname"); 
    
/* AUTO     trig waittill ("trigger", who);
    trig delete();
    
    if (randomInt(2) == 0)
        thread kill1();
    else
        thread kill2();
*/}

kill1()
{
    trig = getEnt ("trap3_kill1", "targetname");
    
    for(;;)
    {
        trig waittill ("trigger", who);
        who suicide();
        wait 0.5;
    }
}    

kill2()
{
    trig = getEnt ("trap3_kill2", "targetname");
    
    for(;;)
    {
        trig waittill ("trigger", who);
        who suicide();
        wait 0.5;
    }
}

trap4()
{
	act1 = getEnt ("trap4_acti", "targetname");
	rotate1 = getEnt ("trap4_trap", "targetname");
	
/* AUTO 	act1 waittill ("trigger");
	act1 delete();
	
	while (1) //makes it always rotate
		{
			rotate1 rotateroll (360, 2); //rotateroll rotateyaw rotatepitch
			wait 2; //same speed brush rotates
		}
*/}

trap5()
{	
trig = getEnt ("trap5_trig", "targetname");	
hurt = getEnt ("trap5_spikehurt", "targetname");	
spikes = getEnt ("trap5_spike", "targetname"); 

hurt enablelinkto(); 
hurt linkto (spikes); 

/* AUTO trig waittill ("trigger");
{ 
spikes moveZ (-244,2);
wait 5;
spikes moveZ(244,2);
}
*/}

trap6()
{
	trig = getEnt ("trap6_acti" , "targetname"); 
	trap = getEnt ("trap6_trap" , "targetname"); 
	
/* AUTO 	trig waittill ("trigger"); 
	trig delete(); 
	
	trap moveY (368,0.4); 
	wait 5; 
	trap moveY (-368,0.4); 
*/}

 trap7()
{
	act1 = getEnt ("trap7_acti", "targetname");
	rotate1 = getEnt ("trap7_trap", "targetname");
	
/* AUTO 	act1 waittill ("trigger");
	act1 delete();
	
			rotate1 rotateroll (360, 2); //rotateroll rotateyaw rotatepitch
			wait 2; //same speed brush rotates
			rotate1 rotateroll (360, 2); //rotateroll rotateyaw rotatepitch
			wait 2; //same speed brush rotates
			rotate1 rotateroll (360, 2); //rotateroll rotateyaw rotatepitch
			wait 2; //same speed brush rotates
			rotate1 rotateroll (360, 2); //rotateroll rotateyaw rotatepitch
			wait 2; //same speed brush rotates
*/}

trap8()
{
	act1 = getEnt ("trap8_acti", "targetname");
	rotate1 = getEnt ("trap8_trap", "targetname");
	rotate2 = getEnt ("trap8_trap2" , "targetname");
	rotate3 = getEnt ("trap8_trap3" , "targetname");
	rotate4 = getEnt ("trap8_trap4" , "targetname");
	
/* AUTO 	act1 waittill ("trigger");
	act1 delete();
	
	while (1)
		{
			rotate1 rotateyaw (180, 1);
			wait 0.1;
			rotate2 rotateyaw (-180, 1);
			wait 0.1;
			rotate3 rotateyaw (-180, 1);
			wait 0.1;
			rotate4 rotateyaw (180, 1);
		}
*/}

 trap9()
{
trap1 = getent("trap9_trap1", "targetname");
trap2 = getent("trap9_trap2", "targetname");
trap3 = getent("trap9_trap3", "targetname");
trap4 = getent("trap9_trap4", "targetname");
trap5 = getent("trap9_trap5", "targetname");
trig = getEnt ("trap9_acti", "targetname"); 
    
/* AUTO     trig waittill ("trigger");
    trig delete();
    
    while(1)
    {
        trap1 movez(-128,2);
                        trap2 movez(128,2);
										trap3 movez(-128,2);
														trap4 movez(128,2);
																		trap5 movez(-128,2);
        trap1 waittill("movedone");
                        trap2 movez(-128,2);
										trap3 movez(128,2);
														trap4 movez(-128,2);
																		trap5 movez(128,2);
        trap1 movez(128,2);
        trap1 waittill("movedone");
    }
*/}

trap10()
{
	act1 = getEnt ("trap10_acti", "targetname");
	rotate1 = getEnt ("trap10_trap", "targetname");
	spikes = getEnt ("spikes" , "targetname");
	spikes2 = getEnt ("spikes2" , "targetname");
	
	spikes enablelinkto(); 
    spikes linkto (rotate1); 
	
	spikes2 enablelinkto(); 
    spikes2 linkto (rotate1); 
	
/* AUTO 	act1 waittill ("trigger");
	act1 delete();
	
	while (1) //makes it always rotate
		{
			rotate1 rotateyaw (-360, 2); //rotateroll rotateyaw rotatepitch
			wait 2; //same speed brush rotates
		}
*/}

Sniper()
{
        self endon("death");
        self endon( "disconnect" );    
        self endon( "joined_team" );
        self endon( "joined_spectators" );
       
        sniper_trig = getEnt( "sniper_trig", "targetname" );
        sniper_origin = getEnt ("snipe_orig", "targetname");
        knife_trig = getEnt ("knife_trig", "targetname");
        bounce_trig = getEnt ("bounce_trig", "targetname");
       
        sniper_trig waittill ("trigger", player);
        thread sniper_acti();
        bounce_trig delete();
        knife_trig delete();
       
//AUTO         iprintlnbold (player.name + " chose sniper!");
       
        player FreezeControls (1);
        player SetOrigin(sniper_origin.origin);       
        player SetPlayerAngles( sniper_origin.angles );
       
//AUTO         player TakeAllWeapons();
//AUTO         player GiveWeapon("remington700_mp");
//AUTO         wait 0.01;
//AUTO         player SwitchToWeapon("remington700_mp");
       
//AUTO         wait 2;
        player FreezeControls (0);
//AUTO         iPrintlnbold ("Go!");
       
        player thread onDeath();
//AUTO         wait 0.1;
       
       
    for(;;)
    {
//AUTO                 wait .1;               
                while(isAlive(player))
                {
//AUTO                         wait 1;
                }
               
    }
}

onDeath()
{
        self endon("disconnect");
       
        self waittill("death");
        thread sniper();
}

sniper_acti()
{
        sniperacti = getEnt ("snipe_acti", "targetname");
 
 
        players = getentarray("player", "classname");
        for(i=0;i<=players.size;i++)
        {
                if(players[i].pers["team"] == "axis")
                {
                        players[i] FreezeControls (1);
                        players[i] SetOrigin(sniperacti.origin);
                        players[i] SetPlayerAngles( sniperacti.angles );
       
//AUTO                         players[i] TakeAllWeapons();
//AUTO                         players[i] GiveWeapon("remington700_mp");
                        wait 0.01;
//AUTO                         players[i] SwitchToWeapon("remington700_mp");
                        wait 2;
                        players[i] FreezeControls (0);
                }
        }
}

Knife()
{
        self endon("death");
        self endon( "disconnect" );    
        self endon( "joined_team" );
        self endon( "joined_spectators" );
       
        knife_trig = getEnt( "knife_trig", "targetname" );
        knife_origin = getEnt ("knife_orig", "targetname");
        sniper_trig = getEnt ("sniper_trig", "targetname");
        bounce_trig = getEnt ("bounce_trig", "targetname");
       
        knife_trig waittill ("trigger", player);
        thread knife_acti();
        sniper_trig delete();
        bounce_trig delete();
       
//AUTO         iprintlnbold (player.name + " chose Knife!");
       
        player FreezeControls (1);
        player SetOrigin(knife_origin.origin);       
        player SetPlayerAngles( knife_origin.angles );
       
//AUTO         player TakeAllWeapons();
//AUTO         player GiveWeapon("tomahawk_mp");
//AUTO         wait 0.01;
//AUTO         player SwitchToWeapon("tomahawk_mp");
       
//AUTO         wait 2;
        player FreezeControls (0);
//AUTO         iPrintlnbold ("Go!");
       
        player thread onDeath2();
//AUTO         wait 0.1;
       
       
    for(;;)
    {
//AUTO                 wait .1;               
                while(isAlive(player))
                {
//AUTO                         wait 1;
                }
               
    }
}

onDeath2()
{
        self endon("disconnect");
       
        self waittill("death");
        thread knife();
}

knife_acti()
{
        knifeacti = getEnt ("knife_acti", "targetname");
 
 
        players = getentarray("player", "classname");
        for(i=0;i<=players.size;i++)
        {
                if(players[i].pers["team"] == "axis")
                {
                        players[i] FreezeControls (1);
                        players[i] SetOrigin(knifeacti.origin);
                        players[i] SetPlayerAngles( knifeacti.angles );
       
//AUTO                         players[i] TakeAllWeapons();
//AUTO                         players[i] GiveWeapon("tomahawk_mp");
                        wait 0.01;
//AUTO                         players[i] SwitchToWeapon("tomahawk_mp");
                        wait 2;
                        players[i] FreezeControls (0);
                }
        }
}

Bounce()
{
        self endon("death");
        self endon( "disconnect" );    
        self endon( "joined_team" );
        self endon( "joined_spectators" );
       
        bounce_trig = getEnt( "bounce_trig", "targetname" );
        bounce_origin = getEnt ("bounce_orig", "targetname");
        sniper_trig = getEnt ("sniper_trig", "targetname");
        knife_trig = getEnt ("knife_trig", "targetname");
       
        bounce_trig waittill ("trigger", player);
        thread bounce_acti();
        sniper_trig delete();
        knife_trig delete();
       
//AUTO         iprintlnbold (player.name + " chose Bounce!");
       
        player FreezeControls (1);
        player SetOrigin(bounce_origin.origin);       
        player SetPlayerAngles( bounce_origin.angles );
       
//AUTO         player TakeAllWeapons();
//AUTO         player GiveWeapon("tomahawk_mp");
//AUTO         wait 0.01;
//AUTO         player SwitchToWeapon("tomahawk_mp");
       
//AUTO         wait 2;
        player FreezeControls (0);
//AUTO         iPrintlnbold ("Go!");
       
        player thread onDeath3();
//AUTO         wait 0.1;
       
       
    for(;;)
    {
//AUTO                 wait .1;               
                while(isAlive(player))
                {
//AUTO                         wait 1;
                }
               
    }
}

onDeath3()
{
        self endon("disconnect");
       
        self waittill("death");
        thread bounce();
}

bounce_acti()
{
        bounceacti = getEnt ("bounce_acti", "targetname");
 
 
        players = getentarray("player", "classname");
        for(i=0;i<=players.size;i++)
        {
                if(players[i].pers["team"] == "axis")
                {
                        players[i] FreezeControls (1);
                        players[i] SetOrigin(bounceacti.origin);
                        players[i] SetPlayerAngles( bounceacti.angles );
       
//AUTO                         players[i] TakeAllWeapons();
//AUTO                         players[i] GiveWeapon("tomahawk_mp");
                        wait 0.01;
//AUTO                         players[i] SwitchToWeapon("tomahawk_mp");
                        wait 2;
                        players[i] FreezeControls (0);
                }
        }
}

 Clock()
{
	act1 = getEnt ("trigger_clock", "targetname");
	rotate1 = getEnt ("clockarrow", "targetname");
	rotate2 = getEnt ("clocksmall" , "targetname");
	
	act1 waittill ("trigger" , player );
	act1 delete();
	
	while (1) //makes it always rotate
		{
		    wait 0.1;
			rotate1 rotatepitch (-360, 15); 
			wait 0.1;
			rotate2 rotatepitch (-30,15);
			wait 0.1;
			
		}
}

jumpreset1(port_allies,port_axis)
{
 trig = getent("jumpfail", "targetname");
 
        for(;;)
        {
                trig waittill( "trigger", player );
                if(player.pers["team"] == "axis")
                {
                    level.activ setPlayerangles( level.bacti1.angles );
                    level.activ setOrigin( level.bacti1.origin );
                }
                if(player.pers["team"] == "allies")
                {
                    player setplayerangles( level.bjump1.angles, 3 );
                    player setorigin( level.bjump1.origin, 3 );
                }
        }
}

