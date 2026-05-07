main()
{
 
    maps\mp\_load::main();

	thread sr\api\_map::createSpawn((3, 4, 76), 180);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createSecretWays("Secret Way");
    thread sr\api\_speedrun::createEndMap((1189.4, 654.003, -487.875),115,120, "normal_0"); 
	thread secret_enter();
   
    thread sec_end();
	thread startdoor();
	thread trapa();
	//thread secret();
	thread trap2();
	//thread credit();
	//thread credit2();
	//thread teleportknife();
	//thread teleportsniper();
	thread trap3();
	//thread teleportend();
	thread teleportsecretfail();
	//thread teleportbounce1();
	//thread teleportbounce2();
}
 secret_enter()
{
	trig = spawn("trigger_radius",(0.897164, 176.239, 16.1255), 0, 60, 120);
	trig.radius = 60;
	
	ori_t = spawn("script_origin",(721,-284,-284));
	ori_t.angles = (0,360,0);

	thread sr\api\_map::createTriggerFx(trig, "green");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_0"); 

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
		player freeze_on_tps(0.1);
	}
}

freeze_on_tps(time) {
	self freezecontrols(true);
	self thread freeze_on_tps_repeat(time);
}
freeze_on_tps_repeat(time) {
	wait time;
	self freezecontrols(false);
}
sec_end()
{
    trig = getEnt( "teleport_trigger", "targetname" );
    org = getEnt( "teleport_target", "targetname" );
	for(;;)
	{
		trig waittill( "trigger", player );
		player thread sr\api\_speedrun::finishWay("secret_0");
	}
}
startdoor()
{
door=getent("door","targetname");

door delete();

}
secret()
{
door=getent("secret","targetname");
wait(25);
iPrintLnBold("^6SomeThing Has Moved?");
door movez(-325,10,1,9);
door waittill ("movedone");
}

trapa()
{
trig = getEnt( "trapa", "targetname" );

     trig waittill( "trigger", who );

}

trap2()
{
	trig = getent("trap2_trig", "targetname");
	trap = getent("trap2", "targetname");
	gold = getent("trap4gold","targetname");
	trig waittill("trigger", who ); 

}

credit()
{
door=getent("credit","targetname");
wait(15);
iPrintLnBold("^6THANK YOU XENON <3!!!!!");
door movez(-325,10,1,9);
door waittill ("movedone");
}

credit2()
{
door=getent("credit","targetname");
wait(22);
iPrintLnBold("^9For TwS Deathrun ^6IP: ^485.17.88.231:29100");
door movez(-325,10,1,9);
door waittill ("movedone");
}

trap3()
{
	trig = getent ("trap3_trig" , "targetname");
	brush = getent ("trap3_brush" , "targetname");
	
	trig waittill ("trigger", player);
	
	
}

teleportknife()
{
level.teleactorigin3 = getEnt("knifeact", "targetname");
teleknifeorigin = getEnt("teleknife", "targetname");
level.knifetrigger = getEnt("teleportkniferoom", "targetname");
for(;;)
{
level.knifetrigger waittill("trigger", player);
level.jumpertrigger delete();
level.bouncetrigger delete();
level.snipertrigger delete();
level.oldtrigger delete();
level.oldtrigger2 delete();
wait(0.05);
player SetOrigin( teleknifeorigin.origin );
player setplayerangles( teleknifeorigin.angles );
player TakeAllWeapons();
player GiveWeapon( "knife_mp" ); 
wait(0.05);
level.activ SetOrigin (level.teleactorigin3.origin);
level.activ setplayerangles (level.teleactorigin3.angles);
level.activ TakeAllWeapons();
level.activ GiveWeapon( "knife_mp" ); 
wait(0.05);
player switchToWeapon( "knife_mp" );
level.activ SwitchToWeapon( "knife_mp" );
level.teleknifeorigin delete();
iPrintLnBold(player.name+ "^4 has entered the ^1Knife/Bounce Room"); //Change the message if you want
while( isAlive( player ) && isDefined( player ) )
            wait 1;
}
}

teleportsniper()
{
level.teleactorigin4 = getEnt("sniperact", "targetname");
telesniperorigin = getEnt("telesniper", "targetname");
level.snipertrigger = getEnt("teleportsniperroom", "targetname");
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
iPrintLnBold(player.name+ "^4 has entered the ^1Sniper Room"); //Change the message if you want
AmbientStop( 2 );
		ambientplay( "sniper" );
while( isAlive( player ) && isDefined( player ) )
            wait 1;
}
}

teleportbounce()
{
level.teleactorigin2 = getEnt("teleportact", "targetname");
telebounceorigin = getEnt("telebounce", "targetname");
level.bouncetrigger = getEnt("teleportbounceroom", "targetname");
for(;;)
{
level.bouncetrigger waittill("trigger", player);
level.knifetrigger delete();
level.snipertrigger delete();
wait(0.05);
player SetOrigin( telebounceorigin.origin );
player setplayerangles( telebounceorigin.angles );
player TakeAllWeapons();
player GiveWeapon( "knife_mp" ); 
wait(0.05);
level.activ SetOrigin (level.teleactorigin2.origin);
level.activ setplayerangles (level.teleactorigin2.angles);
level.activ TakeAllWeapons();
level.activ GiveWeapon( "knife_mp" ); 
wait(0.05);
player switchToWeapon( "knife_mp" );
level.activ SwitchToWeapon( "knife_mp" );
level.telebounceorigin delete();
iPrintLnBold(player.name+ "^4 has entered the ^1Bounce Room"); //Change the message if you want
AmbientStop( 2 );
		ambientplay( "bounce" );
while( isAlive( player ) && isDefined( player ) )
            wait 1;
}
}

teleportend()
{
    trig = getEnt( "teleport_triggerend", "targetname" );
    org = getEnt( "teleport_targetend", "targetname" );
	for(;;)
	{
		trig waittill( "trigger", player );
		player SetOrigin(org.origin);
		iPrintlnbold( player.name + "^6 Is ^9At ^3 The ^8End" );
		
	}
}

teleportsecretfail()
{
    trig = getEnt( "teleport_fail", "targetname" );
    org = getEnt( "teleport_faill", "targetname" );
	for(;;)
	{
		trig waittill( "trigger", player );
		player SetOrigin(org.origin);
		player SetPlayerAngles(org.angles);
		player freeze_on_tps(0.1);
	}

}

teleportbounce1()
{
    trig = getEnt( "teleportbounce1_trig", "targetname" );
    org = getEnt( "teleport_bounce1", "targetname" );
	for(;;)
	{
		trig waittill( "trigger", player );
		player SetOrigin(org.origin);
		player SetPlayerAngles(org.angles);
		player freeze_on_tps(0.1);
	}
}

teleportbounce2()
{
    trig = getEnt( "teleportbounce2_trig", "targetname" );
    org = getEnt( "teleport_bounce2", "targetname" );
	for(;;)
	{
		trig waittill( "trigger", player );
		player SetOrigin(org.origin);
		player SetPlayerAngles(org.angles);
		player freeze_on_tps(0.1);
	}
}