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

setdvar("r_glowbloomintensity0",".25");
setdvar("r_glowbloomintensity1",".25");
setdvar("r_glowskybleedintensity0",".3");
setdvar("compassmaxrange","1800");
setDvar("bg_falldamagemaxheight", 99999);
setDvar("bg_falldamageminheight", 99998);

    thread sr\api\_map::createSpawn((50, 112, 76), 90);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
    thread sr\api\_speedrun::createEndMap((5120.46, 2173.16, -2415.88),165,120, "normal_0");

	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap5();
	thread trap6();
	thread hama();
	thread hamb();
	thread trap7();
	thread trap8();
	thread jumptele1();
	thread jumptele2();
	//thread actitele1();
	//thread actitele2();
	//thread actitele3();
	//thread bouncejumper();
	//thread bounceactivator();
	//thread secret();
	//thread secretout();
	//thread sniper();
	//thread knife();
	//thread jump_tele();
	//thread addTestClients();
	//thread spam();

	addTriggerToList( "trap1_trigger" );
    addTriggerToList( "trap2_trigger" );
    addTriggerToList( "trap3_trigger" );
    addTriggerToList( "trap4_trigger" );
    addTriggerToList( "trap5_trigger" );
    addTriggerToList( "trap6_trigger" );
	addTriggerToList( "trap7_trigger" );
    addTriggerToList( "trap8_trigger" );
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

trap1()
{
	trig = getEnt( "trap1_trigger", "targetname" );
	brush1 = getEnt( "trap1_brush1", "targetname" );
	brush2 = getEnt( "trap1_brush2", "targetname" );
	brush3 = getEnt( "trap1_brush3", "targetname" );
	brush4 = getEnt( "trap1_brush4", "targetname" );
	brush5 = getEnt( "trap1_brush5", "targetname" );
	brush6 = getEnt( "trap1_brush6", "targetname" );
	brush7 = getEnt( "trap1_brush7", "targetname" );
	brush8 = getEnt( "trap1_brush8", "targetname" );
	brush9 = getEnt( "trap1_brush9", "targetname" );
	brush10 = getEnt( "trap1_brush10", "targetname" );
	brush11 = getEnt( "trap1_brush11", "targetname" );
	brush12 = getEnt( "trap1_brush12", "targetname" );
	brush13 = getEnt( "trap1_brush13", "targetname" );
	brush14 = getEnt( "trap1_brush14", "targetname" );
	brush15 = getEnt( "trap1_brush15", "targetname" );
	brush16 = getEnt( "trap1_brush16", "targetname" );
	brush17 = getEnt( "trap1_brush17", "targetname" );
	brush18 = getEnt( "trap1_brush18", "targetname" );

	trig waittill( "trigger" );
	

}

trap2()
{
	trig = getEnt( "trap2_trigger", "targetname" );
	brush1 = getEnt( "trap2_brush1", "targetname" );
	brush2 = getEnt( "trap2_brush2", "targetname" );
	brush3 = getEnt( "trap2_brush3", "targetname" );
	brush4 = getEnt( "trap2_brush4", "targetname" );

	trig waittill( "trigger" );

}

trap3()
{
	trig = getEnt( "trap3_trigger", "targetname" );
	brush1 = getEnt( "trap3_brush1", "targetname" );
	brush2 = getEnt( "trap3_brush2", "targetname" );
	brush3 = getEnt( "trap3_brush3", "targetname" );
	brush4 = getEnt( "trap3_brush4", "targetname" );

	trig waittill( "trigger" );
	

}

trap4()
{
	trig = getEnt( "trap4_trigger", "targetname" );
	brush1 = getEnt( "trap4_brush1", "targetname" );
	
	trig waittill( "trigger" );
	

}

trap5()
{
	trig = getEnt( "trap5_trigger", "targetname" );
	brush1 = getEnt( "trap5_brush1", "targetname" );

	trig waittill( "trigger" );
	

}

trap6()
{
	trig = getEnt( "trap6_trigger", "targetname" );
	brush1 = getEnt( "trap6_brush1", "targetname" );

	trig waittill( "trigger" );
	

}

trap7()
{
	trig = getEnt( "trap7_trigger", "targetname" );
	brush1 = getEnt( "trap7_brush1", "targetname" );

	trig waittill( "trigger" );
	

}

hama()
{
 brush = getEnt( "h1", "targetname" );

 wait 0.1;

 brush rotateyaw(90, 0.1);
 

}

hamb()
{
 brush = getEnt( "h2", "targetname" );

 wait 0.1;

 brush rotateyaw(90, 0.1);
 
	
}

trap8()
{
	trig = getEnt( "trap8_trigger", "targetname" );
	brush1 = getEnt( "trap8_brush1", "targetname" );

	trig waittill( "trigger" );
	

}

jumptele1()
{
	trig = getEnt ("jtele1", "targetname");
	target = getEnt ("jreach1", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles(target.angles);
		player freeze_on_tps(0.1);
	}
}

jumptele2()
{
	trig = getEnt ("jtele2", "targetname");
	target = getEnt ("jreach2", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles(target.angles);
		player freeze_on_tps(0.1);
	}
}

actitele1()
{
	trig = getEnt ("actitele1", "targetname");
	target = getEnt ("actireach1", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player iprintlnbold ("You have been teleported");
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

actitele2()
{
	trig = getEnt ("actitele2", "targetname");
	target = getEnt ("actireach2", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player iprintlnbold ("You have been teleported");
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

actitele3()
{
	trig = getEnt ("actitele3", "targetname");
	target = getEnt ("actireach3", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player iprintlnbold ("You have been teleported");
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

bouncejumper()
{
	trig = getEnt ("bouncejump", "targetname");
	target = getEnt ("telebounce", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player iprintlnbold ("You have been teleported");
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

bounceactivator()
{
	trig = getEnt ("bounceacti", "targetname");
	target = getEnt ("bounceactiback", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player iprintlnbold ("You have been teleported");
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

secret()
{
	trig = getEnt ("secret", "targetname");
	target = getEnt ("secretin", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles(target.angles);
		player freeze_on_tps(0.1);
	}
}

secretout()
{
	trig = getEnt ("secretout", "targetname");
	target = getEnt ("secretout1", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles(target.angles);
		player freeze_on_tps(0.1);
	}
}

sniper()
{
weapontrig = getent ("weapon_trigger", "targetname");
knifetrig = getent ("final_knife_trig", "targetname");
snipertrig = getent ("final_sniper_trig", "targetname");
sniperactitele = getent ("sniper_a", "targetname");
sniperjumpertele = getent ("sniper_j", "targetname");
jumptrig = getent ("jump_trigger", "targetname");

	self endon("death");
	self endon( "disconnect" );	
	self endon( "joined_team" );
	self endon( "joined_spectators" );

snipertrig waittill("trigger", player);
weapontrig delete();
jumptrig delete();
knifetrig delete();
wait(0.05);

player SetOrigin (sniperjumpertele.origin);
player setplayerangles (sniperjumpertele.angles);
player TakeAllWeapons();
player GiveWeapon ("m40a3_mp"); 
player GiveWeapon ("remington700_mp"); 
wait(0.05);

level.activ SetOrigin (sniperactitele.origin);
level.activ setplayerangles (sniperactitele.angles);
level.activ TakeAllWeapons();
level.activ GiveWeapon ("m40a3_mp");
level.activ GiveWeapon ("remington700_mp");
player GiveWeapon ("m40a3_mp"); 
player GiveWeapon ("remington700_mp"); 
wait(0.05);

player switchToWeapon ("m40a3_mp");
level.activ SwitchToWeapon ("m40a3_mp");
iPrintLnBold(player.name+ "^4 has entered the ^1Sniper Room");
wait 0.4;

player thread onDeath_sniper();
wait 0.1;
	
    for(;;)
    {
		wait .1;		
		while(isAlive(player))
		{
			wait 1;
		}
		
    }
}

onDeath_sniper()
{
	self endon("disconnect");
	
	self waittill("death");
	thread sniper();
}

knife()
{
	weapontrig = getent ("weapon_trigger", "targetname");
	jumptrig = getent ("jump_trigger", "targetname");
	snipertrig = getent ("final_sniper_trig", "targetname");
	knifeactitele = getent ("activator_enter_k", "targetname");
	knifejumpertele = getent ("enter_jumper_k", "targetname");
	knifetrig = getent ("final_knife_trig", "targetname");
 
    self endon("death");
    self endon( "disconnect" );    
    self endon( "joined_team" );
    self endon( "joined_spectators" );
 
	knifetrig waittill("trigger", player);
	weapontrig delete();
	snipertrig delete();
	jumptrig delete();
	wait(0.05);
 
	player SetOrigin (knifejumpertele.origin);
	player setplayerangles (knifejumpertele.angles);
	player TakeAllWeapons();
	player GiveWeapon ("knife_mp"); 
	wait(0.05);
 
	level.activ SetOrigin (knifeactitele.origin);
	level.activ setplayerangles (knifeactitele.angles);
	level.activ TakeAllWeapons();
	level.activ GiveWeapon ("knife_mp");
	wait(0.05);
 
	player switchToWeapon ("knife_mp");
	level.activ SwitchToWeapon ("knife_mp");
	iPrintLnBold(player.name+ "^4 has entered the ^1Knife Room");
	iPrintLn("^1Lossy ^4was here.");
	wait 0.4;
 
	player thread onDeath_knife();
	wait 0.1;
 
    for(;;)
    {
        wait .1;        
        while(isAlive(player))
        {
            wait 1;
        }
 
    }
}
 
onDeath_knife()
{
    self endon("disconnect");
 
    self waittill("death");
    thread knife();
}

jump_tele()
{
knifetrig = getent ("final_knife_trig", "targetname");
snipertrig = getent ("final_sniper_trig", "targetname");
jumptrig = getent ("jump_trigger", "targetname");
jumpactitele = getent ("jump_acti_tele", "targetname");
jumpjumpertele = getent ("jump_jumper_tele", "targetname");

self endon("death");
self endon( "disconnect" );	
self endon( "joined_team" );
self endon( "joined_spectators" );

jumptrig waittill("trigger", player);
snipertrig delete();
knifetrig delete();
wait(0.05);

player SetOrigin (jumpjumpertele.origin);
player setplayerangles (jumpjumpertele.angles);
player TakeAllWeapons();
player GiveWeapon ("knife_mp"); 
wait(0.05);

level.activ SetOrigin (jumpactitele.origin);
level.activ setplayerangles (jumpactitele.angles);
level.activ TakeAllWeapons();
level.activ GiveWeapon ("knife_mp");
wait(0.05);

player switchToWeapon ("knife_mp");
level.activ SwitchToWeapon ("knife_mp");
iPrintLnBold(player.name+ "^4 has entered the ^1Jump Room");
wait 0.4;

player thread onDeath_jump();
wait 0.1;

    for(;;)
    {
		wait .1;		
		while(isAlive(player))
		{
			wait 1;
		}
		
    }
}

onDeath_jump()
{
	self endon("disconnect");
	
	self waittill("death");
	thread jump_tele();
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

spam()
{

	for(;;)
	{
	wait 20;
	iprintln ("^3>> ^7Map created by ^5Frosty");
	wait 30;
	iprintln ("^3>> ^7xfire: ^5Frostytheman655");
	wait 30;
	iprintln ("^3>> ^7Credits:^2Darmuh, Lossy, Xenon, Dafuq@WUP");
	wait 30;
	iprintln ("^2<< ^7More maps by Frosty soon^1<3");
	}
}