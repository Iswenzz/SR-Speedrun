main()
{
        game["allies"] = "sas";
        game["axis"] = "russian";
        game["attackers"] = "axis";
        game["defenders"] = "allies";
        game["allies_soldiertype"] = "woodland";
        game["axis_soldiertype"] = "woodland";

        thread sr\api\_map::createSpawn((-55, 188, 76), 90);
        thread sr\api\_speedrun::createNormalWays("Normal Way");
        thread sr\api\_speedrun::createEndMap((-1566.34, 32.4706, -407.875), 165,120, "normal_0");
        thread weap_rpg_onfloor_remove();
       
        //setdvar( "r_specularcolorscale", "1" );
       
        maps\mp\_load::main();
        //maps\mp\mp_dr_naruto_fx::main();
        //thread deagle_trigger();
        //thread open_guns();
        thread tele();
        thread tele2();
        thread tele3();
        thread tele4();
        thread tele5();
        thread tele6();
        thread tele7();
        //thread bounce_room();
        //thread sniper_room();
        thread tele8();
        thread tele9();
        //thread addTestClients();
	//thread wepsniper();
        //thread wall_room();
        thread startmove();
       // ambientPlay("maya");
        thread trap1();
		thread trap2();
		thread trap3();
		thread trap4();
		thread trap5();
		thread trap6();
		thread trap7();
		thread trap8();
		thread trap9();
		//thread msgs();
		addTriggerToList( "trig1" );
		addTriggerToList( "t2" );
		addTriggerToList( "t3" );
		addTriggerToList( "t4" );
		addTriggerToList( "t5" );
		addTriggerToList( "t6" );
		addTriggerToList( "t7" );
		addTriggerToList( "t8" );
		addTriggerToList( "t9" );
        //PreCacheItem("deserteaglegold_mp");
        //PreCacheItem("winchester1200_mp");
        //PreCacheItem("skorpion_mp");
        //PreCacheItem("remington700_mp");
        //PreCacheItem("m4_mp");
        //PreCacheItem("g3_mp");
        //PreCacheItem("ak47_mp");
        //PreCacheItem("rpd_mp");
}
freeze_on_tps(time) {
	self freezecontrols(true);
	self thread freeze_on_tps_repeat(time);
}
freeze_on_tps_repeat(time) {
	wait time;
	self freezecontrols(false);
}
addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}
weap_rpg_onfloor_remove()
{
weapon = getEntArray("weapon_rpg_mp", "classname");
for(i=0; i<weapon.size; i++)
{ weapon[i] delete();
}
}

msgs()
{

	for(;;)
	{
	wait 20;
	iprintln ("^3>> ^7Map created by ^2Freek");
	wait 30;
	iprintln ("^3>> ^7xfire: ^2shitiz80");
	wait 30;
	iprintln ("^3>> ^7For more details visit Braxi.org");
	wait 30;
	iprintln ("^2<< ^7Deathrun Just rocks,i think my map too :>");
	}
}
 
startmove()
{
        trig = getEnt ("trigstart", "targetname");
        brush = getEnt ("startmove", "targetname");
        brush2 = getEnt ("exploder", "targetname");
        brush3 = getEnt ("expwall", "targetname");
       
        
        brush delete();
        brush2 delete();
        brush3 delete();
}
 
trap1()
{
        brush = getent ("trap1", "targetname");
        trig = getEnt ("trig1", "targetname");
        trig waittill ("trigger", player);
       
}
 
trap2()
{
brush = getEnt ("b1", "targetname");
trig = getEnt ("t2", "targetname");
trig waittill ("trigger", player);

}
 
deagle_trigger()
{
        trigger = getEnt("trigger_deagle", "targetname");
        precacheItem("deserteaglegold_mp");    
        while(1)
        {
                trigger waittill("trigger", player);
                player takeallweapons();
                player GiveWeapon("deserteaglegold_mp");
                player SwitchToWeapon( "deserteaglegold_mp" );
        }
}

wepsniper()
{
        trigger = getEnt("wepsniper", "targetname");
        precacheItem("remington700_mp");    
        while(1)
        {
                trigger waittill("trigger", player);
                player takeallweapons();
                player GiveWeapon("remington700_mp");
                player SwitchToWeapon( "remington700_mp" );
        }
}
 
 trap3()
{
   trig = getEnt ("t3" , "targetname");
   spikes = getEnt ("spike" ,"targetname" );
   hurt = getEnt ("trigspike" , "targetname");
   trig waittill ("trigger", player);  

   hurt delete();
   
    
}

 trap4()
{
   trig = getEnt ("t4" , "targetname");
   brush = getEnt ("b4trap" ,"targetname" );
   hurt = getEnt ("b4hurt" , "targetname");
   
   hurt delete();
}

trap5()
{
brush = getEnt ("b5", "targetname");
trig = getEnt ("t5", "targetname");
trig waittill ("trigger", player);



 }

trap6()
{
brush1 = getEnt ("b6a", "targetname");
brush2 = getEnt ("b6b", "targetname");
trig = getEnt ("t6", "targetname");
trig waittill ("trigger", player);

 }
 
trap7()
{
        brush = getent ("b7", "targetname");
        trig = getEnt ("t7", "targetname");
        trig waittill ("trigger", player);
      
                
}

 trap8()
{
   trig = getEnt ("t8" , "targetname");
   brush = getEnt ("tank" ,"targetname" );
   hurt = getEnt ("tankhurt" , "targetname");

   hurt delete();
   
}

trap9()
	{
	part1 = getentarray ("p1" ,"targetname");
	part2 = getentarray ("p2" ,"targetname");
	trig_2 = getent ("t9" , "targetname");
	trig_2 waittill ("trigger" , player );
	
	}
 
open_guns()
{
        door = getEnt("door_guns", "targetname");
        trigger = getEnt("open_guns", "targetname");
        trigger waittill("trigger", player);
        if( isDefined( level.trapsDisabled ) && level.trapsDisabled )
        {
                iPrintLnBold(player.name + " ^3LooL! ^5Go get some Muscles !"); //Change the message if you want
        }
        else
        {
                trigger delete();
                door moveZ( -200, 6);
                iPrintLnBold(player.name + " ^3Opened ^2his ass to take out weapons!"); //Change the message if you want
        }
}
 
tele()
{
        entTransporter = getentarray( "gohere", "targetname" );
        if(isdefined(entTransporter))
                for( i = 0; i < entTransporter.size; i++ )
                        entTransporter[i] thread transporter();
}
 
transporter()
{
        for(;;)
        {
                self waittill( "trigger", player );
                entTarget = getEnt( self.target, "targetname" );
                player SetOrigin(entTarget.origin);
		player SetPlayerAngles(entTarget.angles);
		player freeze_on_tps(0.1);
        }
}
 
        tele2()
{
        entTransporter = getentarray( "s1", "targetname" );
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
                player SetOrigin(entTarget.origin);
		player SetPlayerAngles(entTarget.angles);
		player freeze_on_tps(0.1);
        }
}
       
        tele3()
{
        entTransporter = getentarray( "over", "targetname" );
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
                player SetOrigin(entTarget.origin);
		player SetPlayerAngles(entTarget.angles);
		player freeze_on_tps(0.1);
        }
}
 
        tele4()
{
        entTransporter = getentarray( "teleport", "targetname" );
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
                player SetOrigin(entTarget.origin);
		player SetPlayerAngles(entTarget.angles);
		player freeze_on_tps(0.1);
        }
}
 
        tele5()
{
        entTransporter = getentarray( "teleport2", "targetname" );
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
                player SetOrigin(entTarget.origin);
		player SetPlayerAngles(entTarget.angles);
		player freeze_on_tps(0.1);
        }
}
 
        tele6()
{
        entTransporter = getentarray( "ht", "targetname" );
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
                player SetOrigin(entTarget.origin);
		player SetPlayerAngles(entTarget.angles);
		player freeze_on_tps(0.1);
        }
}
 
tele7()
{
        entTransporter = getentarray( "back", "targetname" );
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
                player SetOrigin(entTarget.origin);
		player SetPlayerAngles(entTarget.angles);
		player freeze_on_tps(0.1);
        }
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
               
                level.wall_trig delete();
                level.bounce_trig delete();
                                 
                                     
                player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                player TakeAllWeapons();
                player GiveWeapon( "remington700_mp" );        
                level.activ setPlayerangles( acti.angles );
                level.activ setOrigin( acti.origin );
                level.activ TakeAllWeapons();
                level.activ GiveWeapon( "remington700_mp" );          
                wait 0.05;
                player switchToWeapon( "remington700_mp" );
                level.activ SwitchToWeapon( "remington700_mp" );
                iPrintlnBold( " ^6" + player.name + " has chosen snipe room!" );                //change it as you wish
                while( isAlive( player ) && isDefined( player ) )
                        wait 1;
        }
}              
 
wall_room()
{
    level.wall_trig = getEnt( "wall_room", "targetname");
        jump = getEnt( "wall_jump", "targetname" );
        acti = getEnt( "wall_acti", "targetname");
   
        while(1)
        {
                level.wall_trig waittill( "trigger", player );
                if( !isDefined( level.wall_trig ) )
                        return;
               
                level.sniper_trig delete();
                level.bounce_trig delete();
                                 
                                     
                player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                player TakeAllWeapons();
                player GiveWeapon( "remington700_mp" );        
                level.activ setPlayerangles( acti.angles );
                level.activ setOrigin( acti.origin );
                level.activ TakeAllWeapons();
                level.activ GiveWeapon( "remington700_mp" );          
                wait 0.05;
                player switchToWeapon( "remington700_mp" );
                level.activ SwitchToWeapon( "remington700_mp" );
                iPrintlnBold( " ^6" + player.name + " has chosen wall room!" );         //change it as you wish
                while( isAlive( player ) && isDefined( player ) )
                        wait 1;
        }
}
 
bounce_room()
{
    level.bounce_trig = getEnt( "broom", "targetname");
        jump = getEnt( "bounce_jump", "targetname");
        acti = getEnt( "bounce_acti", "targetname");
   
        while(1)
        {
                level.bounce_trig waittill( "trigger", player );
                if( !isDefined( level.bounce_trig ) )
                        return;
               
                level.sniper_trig delete();
                level.wall_trig delete();
                                 
                                     
                player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                player TakeAllWeapons();
                player GiveWeapon( "tomahawk_mp" );            
                level.activ setPlayerangles( acti.angles );
                level.activ setOrigin( acti.origin );
                level.activ TakeAllWeapons();
                level.activ GiveWeapon( "tomahawk_mp" );              
                wait 0.05;
                player switchToWeapon( "tomahawk_mp" );
                level.activ SwitchToWeapon( "tomahawk_mp" );
                iPrintlnBold( " ^6" + player.name + " has chosen bounce room" );                //change it as you wish
                while( isAlive( player ) && isDefined( player ) )
                        wait 1;
        }
}
 
tele8()
{
        entTransporter = getentarray( "bounce1tele", "targetname" );
        if(isdefined(entTransporter))
                for( i = 0; i < entTransporter.size; i++ )
                        entTransporter[i] thread transporter8();
                       
}
 
transporter8()
{
        for(;;)
        {
                self waittill( "trigger", player );
                entTarget = getEnt( self.target, "targetname" );
                player SetOrigin(entTarget.origin);
		player SetPlayerAngles(entTarget.angles);
		player freeze_on_tps(0.1);
        }
}              
 
tele9()
{
        entTransporter = getentarray( "finish", "targetname" );
        if(isdefined(entTransporter))
                for( i = 0; i < entTransporter.size; i++ )
                        entTransporter[i] thread transporter9();
                       
}
 
transporter9()
{
        for(;;)
        {
                self waittill( "trigger", player );
                entTarget = getEnt( self.target, "targetname" );
                player SetOrigin(entTarget.origin);
		player SetPlayerAngles(entTarget.angles);
		player freeze_on_tps(0.1);
        }
}
        addTestClients()
{
    setDvar("scr_testclients", "");
    wait 1;
    for(;;)
    {
        if(getdvarInt("scr_testclients") > 0)
            break;
        wait 1;
    }
    testclients = getdvarInt("scr_testclients");
    setDvar( "scr_testclients", 0 );
    for(i=0;i<testclients;i++)
    {
        ent[i] = addtestclient();
 
        if (!isdefined(ent[i]))
        {
            println("Could not add test client");
            wait 1;
            continue;
        }
        ent[i].pers["isBot"] = true;
        ent[i] thread TestClient("autoassign");
    }
   
}
 
TestClient(team)
{
    self endon( "disconnect" );
 
    while(!isdefined(self.pers["team"]))
        wait .05;
       
    self notify("menuresponse", game["menu_team"], team);
    wait 0.5;
}    //end