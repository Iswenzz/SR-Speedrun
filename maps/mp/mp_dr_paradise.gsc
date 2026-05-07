main()
{
	maps\mp\_load::main();

	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	setdvar( "r_specularcolorscale", "1" );

	setdvar("compassmaxrange","2000");

	thread sr\api\_map::createSpawn((-4591, 237, 4140), 270);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createEndMap((-2266.23, -4550.5, 4080.12), 90,120, "normal_0");  

	//precacheModel( "Yuusha_1" );
	//precacheModel( "Yuusha_2" );
	//precacheModel( "Tourrette" );
	//precacheModel( "Eo" );
	//recacheModel( "Elysium" );

//precacheItem("g3_mp");
//precacheItem("remington700_mp");
//precacheItem("m40a3_mp");

	//Traps
	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap5();

	//Startdoor1
	thread startdoor();

	//secret
	thread teleport();

/////////////////////////////
	//End rooms start
/////////////////////////////

	//snipe
	//thread snipe();

/////////////////////////////
	//End room end :3
/////////////////////////////

	//Random Shit XD
	//thread Sheox();
	//thread addTestClients();
}

startdoor()
{
	trig = getEnt( "start-trigger", "targetname" );
	brush = getEnt( "startdoor", "targetname" );
	walls = getEnt( "trap3_glass", "targetname" );

	wait 0.1;

    walls delete();
	brush delete();

}

trap1()
{
	trig = getEnt( "trigger1", "targetname" );
	brush = getEnt( "trap1", "targetname" );

	trig waittill( "trigger", who );

}

trap2()
{
	trig = getEnt( "trap2", "targetname" );
	brushGroup1 = getEntArray( "trap11_1", "targetname" );
	brushGroup2 = getEntArray( "trap11_2", "targetname" );

	trig waittill( "trigger", who );

}

trap3()
{
	trigger = getEnt ( "trap3", "targetname" );
	updown = getEnt ( "trap3_updown", "targetname" );
	walls = getEnt ( "trap3_glass", "targetname" );

	trigger waittill ( "trigger" );
	
}

trap4()
{
	brush1 = getEnt( "trap4_right", "targetname" );
	brush2 = getEnt( "trap4_left", "targetname" );

	brush1 delete();
	brush2 delete();
}

trap5()
{
	trig = getEnt( "trap5_rotate", "targetname" );
	brush = getEnt( "trap5_brush", "targetname" );

	trig waittill( "trigger", who );
	
}

teleport(port_allies) //defining both jumpers and activators
{
 entTarget = getEnt( "secret1origin", "targetname" );
 trigger = getEnt( "secret1trigger", "targetname" );

    trigger waittill ("trigger");
    trigger delete();
 
        for(;;)
        {
                trigger waittill( "trigger", player );
                if(player.pers["team"] == "allies") //jumpers
                {
                    player setplayerangles( entTarget.angles, 3 );
                    player setorigin( entTarget.origin, 3 );
                }
        }
}

moddel_teleport()
{
    model_trig = getEnt( "model_trig", "targetname" );
    org = getEnt( "admin_org", "targetname" );

    
    while (1)
    {
        model_trig waittill( "trigger", player );
        tempGuid = player getGUID();
        
        if(player isTouching(model_trig) && player useButtonPressed())
        {
                player SetOrigin( org.origin );
                player iprintlnbold("^1Welcome to the ^2Model ^3Room :3");
        }
        else
        {
            wait 0.5;
        }
    }
}

Sheox()
{
	if( isDefined( self.Sheox ) )
		self.Sheox destroy();

	self.Sheox = newHudElem();
    self.Sheox.foreground = true;
	self.Sheox.alignX = "left";
	self.Sheox.alignY = "top";
	self.Sheox.horzAlign = "left";
    self.Sheox.vertAlign = "top";
    self.Sheox.x = 4;
    self.Sheox.y = 0;
    self.Sheox.sort = 0;
  	self.Sheox.fontScale = 1.5;
	self.Sheox.color = (0.8, 1.0, 0.8);
	self.Sheox.font = "objective";
	self.Sheox.glowColor = (0, 0, 1.0);
	self.Sheox.glowAlpha = 1;
	self.Sheox SetPulseFX( 30, 100000, 700 );//something, decay start, decay duration
 	self.Sheox.hidewheninmenu = true;
	self.Sheox setText( "Map made by Sheox" );

}

/*snipe()
{
 telesniperorigin = getEnt( "sniperjumper", "targetname" );
 level.teleactorigin4 = getEnt( "sniperactivator", "targetname" );
 trig = getEnt( "sniper_trigger", "targetname" );
 
        for(;;)
        {
                trig waittill( "trigger", player );
                if(player.pers["team"] == "axis") //activator(s?)
                {
					level.activ SetOrigin( level.teleactorigin4.origin );
					level.activ setplayerangles( level.teleactorigin4.angles );
					level.activ TakeAllWeapons();
					level.activ SwitchToWeapon( "remington700_mp" );
					level.activ GiveWeapon( "m40a3_mp" );
					level.activ Giveweapon( "remington700_mp" );
                }
                if(player.pers["team"] == "allies") //jumpers
                {
					player SetOrigin( telesniperorigin.origin );
					player setplayerangles( telesniperorigin.angles );
					player TakeAllWeapons();
					player SwitchToWeapon( "remington700_mp" );
					player GiveWeapon( "m40a3_mp" );
					player Giveweapon( "remington700_mp" );
                }
        }
}
*/

snipe()
{
level.teleactorigin4 = getEnt("sniperactivator", "targetname");
telesniperorigin = getEnt("sniperjumper", "targetname");
level.snipertrigger = getEnt("sniper_trigger", "targetname");
for(;;)
{
level.snipertrigger waittill("trigger", player);
level.knifetrigger delete();
wait(0.05);
player SetOrigin( telesniperorigin.origin );
player setplayerangles( telesniperorigin.angles );
player TakeAllWeapons();
player GiveWeapon( "m40a3_mp" ); 
player Giveweapon( "remington700_mp" );
wait(0.05);
level.activ SetOrigin (level.teleactorigin4.origin);
level.activ setplayerangles (level.teleactorigin4.angles);
level.activ TakeAllWeapons();
level.activ GiveWeapon( "m40a3_mp" );
level.activ Giveweapon( "remington700_mp" ); 
wait(0.05);
player switchToWeapon( "m40a3_mp" );
level.activ SwitchToWeapon( "m40a3_mp" );
level.teleorigin delete();
while( isAlive( player ) && isDefined( player ) )
            wait 1;
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
    thread addTestClients();
}

TestClient(team)
{
    self endon( "disconnect" );
 
    while(!isdefined(self.pers["team"]))
        wait .05;
       
    self notify("menuresponse", game["menu_team"], team);
    wait 0.5;
}