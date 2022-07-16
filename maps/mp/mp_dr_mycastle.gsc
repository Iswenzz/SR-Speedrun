//////////////////////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//     _______     _____     ___    _______________     ___     ___     ___      ___     ___       ___     \\
//    |     \ \   /     |   |   |  |               |   |   |   |   |   |   \    /   |   \   \    /   /     \\
//	  |      \ \ /      |   |   |  |_____     _____|   |   |___|   |    \   \__/   /     \   \__/   /      \\
//	  |   |\  \_/  /|   |   |   |        |   |         |           |     \        /       \        /       \\
//	  |   | \  	  / |   |   |   |        |   |         |    ___    |      \      /        /   __   \       \\
//	  |   | |\___/  |   |   |   |        |   |         |   |   |   |       |    |        /   /  \   \      \\
//	  |___|/        |___|   |___|        |___|         |___|   |___|       |____|       /___/    \___\     \\
//		                                                                                                   \\
//////////////////////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//     _______     _____                                                             _______     _____     \\
//    |     \ \   /     |                                                           |     \ \   /     |    \\
//    |      \ \ /      |                        Map by MiThyX                      |      \ \ /      |    \\
//    |   |\  \_/  /|   |                      Script by MiThyX                     |   |\  \_/  /|   |    \\
//    |   | \  	  / |   |                                                           |   | \     / |   |    \\
//    |   | |\___/  |   |                        Steam: MiThyX                      |   | |\___/  |   |    \\
//    |___|/        |___|                                                           |___|/        |___|    \\
//                                                                                                         \\
//////////////////////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

main()
{
 maps\mp\_load::main();
 
 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"] = "desert";
 
	level.explosion = LoadFX ( "explosions/tanker_explosion" );
	level.fire = loadFx("fire/firelp_barrel_pm");
	
	level.killfire = 0;
	level.killfire2 = 0;
	level.killfire3 = 0;
	level.killfire4 = 0;
    level.killfiretrap6 = 0;
	
	precachemenu("presentation");
	precacheitem("usp_silencer_mp");
	precacheitem("uzi_silencer_mp");
	precacheItem("m40a3_mp");
	precacheItem("remington700_mp");
	precacheItem("ak74u_mp");
	precacheItem("deserteaglegold_mp");
	precacheItem("rpg_mp");
	precacheItem("g3_mp");
	precacheItem("winchester1200_mp");
	precacheItem("ak47_mp");
	precacheItem("rpd_mp");

	addTriggerToList( "explosion_effect_1_trigger" );
	addTriggerToList( "trap2" );
	addTriggerToList( "trap3" );
	addTriggerToList( "trap4" );
	addTriggerToList( "trap5" );
	addTriggerToList( "trap6" );
	addTriggerToList( "trap7" );

   thread speedrun\_way_name::create_normal_way("Normal Way;");
   thread speedrun\_way_name::create_secret_way("Easy Secret;Hard Secret;");
   thread speedrun\_way_name::create_spawn((6650,-10176,125),90);
   thread speedrun\_way_name::create_endmap((6280.56, -6202.25, 544.125), 120, 75);
   thread speedrun\_way_name::create_tp((6445.33, -9117.16, 65.125), 70, 80, (8592, -6438, -883), 319, "freeze", "blue", "s0");
   thread speedrun\_way_name::create_tp((6659.79, -9123.62, 65.125), 75, 80, (-4812, -1416, 125), 90, "freeze", "red", "s1");
   
	// thread guidchecking();
	// thread messages();
	thread startdoor();
	// thread credits();
	// thread move1();
	// thread move2();
	// thread move3();
	// thread effect_explosion();
	// thread trap2();
	// thread trap3();
	// thread trap4();
	// thread trap4killfire();
	// thread trap4killfire2();
	// thread trap4killfire3();
	// thread trap4killfire4();
	// thread trap5();
   // thread trap6();
   // thread trap6killfire();
   // thread trap6killfire2();
   // thread trap6killfire3();
   // thread trap6killfire4();
   // thread trap6killfire5();
   // thread trap6killfire6();
	// thread trap7();
	// thread endmap();
	thread secretxpjumperrespawn();
	thread secretxpjumperrespawn2();
	// thread portesecret();
	// thread secretxp1();
	// thread secretxp2();
   thread secretxp3();
	thread secretxp4();
	// thread actifail1();
	// thread actifail2();
	// thread actifail3();
	// thread actifail4();
	// thread actifail5();
	// thread actifail6();
	// thread actifail7();
	// thread actifail8();
	// thread actifail9();
	// thread actifail10();
	// thread actifail11();
	// thread actifail12();
	// thread actifail13();
	// thread secretjumpfail();
   // thread roomjumpfail();
	// thread jumproomjumpfail();
	// thread jumproomactifail();
	// thread runroomfail();
	// thread jumpsniper();
	// thread jump();
	// thread old();
	// thread runtp();
	// thread run();
	// thread run2();
	// thread run4();
   // thread snipertp();
	// thread sniper1();
	// thread sniper2();
	// thread sniper3();
	// thread knife();
	// thread partyjump();
	// thread randomspeed();
	// thread weapons();
	// thread musictrig();

	
}

addTriggerToList( name )
{
	if( !isDefined( level.trapTriggers ) )
		level.trapTriggers = [];
	level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );

}

guidchecking()
{
	wait 5.1;
	thread guidcheckgod();
	wait 0.2;
}

guidcheckgod() //CHECK GOD GUID :]
{
god1 = "5b4d3eec";
sanictrig = getent("sanic_check","targetname");
sanictrig setHintString("Map Creator");
for(;;)
	{
		sanictrig waittill ("trigger",user);
		
		}

}

messages()
{
   wait 8;
   iprintlnBold("^4---- ^2MyCastle ^2by ^6M^2i^3T^4h^5y^6X ^4----");
   wait 1;
}

startdoor()
{
start = getent("startdoor","targetname");
{
start moveZ(-500, 10);
iprintlnbold("^4---- ^1G^3o^2o^4d^1L^6u^2c^3k ^4---- ");
}
}

credits()
{
        self endon( "disconnect" );
 
        if( isDefined( self.credits_text ) )
                self.credits_text Destroy();
 
        self.credits_text = newHudElem();
        self.credits_text.y = 10;
        self.credits_text.alignX = "center";
        self.credits_text.alignY = "middle";
        self.credits_text.horzAlign = "center";
 
        self.credits_text.alpha = 0;
        self.credits_text.sort = -3;
        self.credits_text.fontScale = 1.6;
        self.credits_text.archieved = true;

		while(1)
        {
			    wait 5;
				self credit_roll( "Ty to ^2Mewen ^4Sux Lolz ^6Vaki&KecsKe ^8Robin ^7for their script ^^", 5 );
				self credit_roll( "^6Y^2o^3u^4t^5u^6b^2e^7:https://www.youtube.com/channel/UCLPUQ9wxNmnPcNcHxPkblrA", 3 );
				self credit_roll( "^2Steam: MiThyX", 3 );
				self credit_roll( "^4---- ^2Map ^2by ^6M^2i^3T^4h^5y^6X ^4----", 3);
				self credit_roll( "^4---- ^2Ty ^3To ^6All ^8PWDF ^3Testers----", 3);
				wait 50;
        }
}

credit_roll( msg, time )
{
        self endon( "disconnect" );
 
        self.credits_text fadeOverTime(1);
        self.credits_text.alpha = 1;
        self.credits_text setText( msg );
        wait( time );
        self.credits_text fadeOverTime(1);
        self.credits_text.alpha = 0;
        wait 1;
}

move1()
{
   trigger = getEnt ("move1", "targetname");
   block = getent("move1-1","targetname");
   
  trigger waittill ("trigger", player );
   
}

move2()
{
   trigger = getEnt ("move2", "targetname");
   block = getent("move2-1","targetname");
   
  trigger waittill ("trigger", player );
   
}

move3()
{
   trigger = getEnt ("move3", "targetname");
   block = getent("move3-1","targetname");
   
  trigger waittill ("trigger", player );
   
}


effect_explosion() //trap1
{
    trigger = getEnt ("explosion_effect_1_trigger", "targetname");
	target_1 = getEnt ("explosion_effect_1", "targetname");
	target_2 = getEnt ("explosion_effect_2", "targetname");
	disparition = getEnt ("disparition1", "targetname");
	
	trigger waittill ("trigger", player );
}

trap2()
{
block1 = getEnt("trap2-1", "targetname");
block2 = getEnt("trap2-2", "targetname");
block3 = getEnt("trap2-3", "targetname");
block4 = getEnt("trap2-4", "targetname");
trap2 = getEnt("trap2", "targetname");
trap2 setHintString("Press [Use] to activate the trap");
trap2 waittill("trigger", player);
}

trap3()
{
    block1 = getent("trap3-1","targetname");
	trig = getent("trap3","targetname");
    trig setHintString("Press [Use] to activate the trap");
	trig waittill("trigger",player);
}

trap4()
{
    block1 = getent("trap4-6","targetname");
    block2 = getent("trap4-7","targetname");
    block3 = getent("trap4-8","targetname");
    block4 = getent("trap4-9","targetname");
	trig = getent("trap4","targetname");
    trig setHintString("Press [Use] to activate the trap");
   trig waittill("trigger",player);	
}

trap4killfire()
{
	trigdmg = getent("kill1","targetname");
	for(;;)
	{
	trigdmg waittill("trigger",player);
	if (level.killfire == 1)
	{
		player suicide();
	}
	}
	
}

trap4killfire2()
{
	trigdmg2 = getent("kill2","targetname");
	for(;;)
	{
	trigdmg2 waittill("trigger",player);
	if (level.killfire2 == 1)
	{
		player suicide();
	}
	}
	
}

trap4killfire3()
{
	trigdmg3 = getent("kill3","targetname");
	for(;;)
	{
	trigdmg3 waittill("trigger",player);
	if (level.killfire3 == 1)
	{
		player suicide();
	}
	}
	
}

trap4killfire4()
{
	trigdmg4 = getent("kill4","targetname");
	for(;;)
	{
	trigdmg4 waittill("trigger",player);
	if (level.killfire4 == 1)
	{
		player suicide();
	}
	}
	
}

playEffect()
{

	destA = getEnt( "fx_origin_1", "targetname" );
	destB = getEnt( "fx_origin_2", "targetname" );
	destC = getEnt( "fx_origin_3", "targetname" );
	destD = getEnt( "fx_origin_4", "targetname" );
	destE = getEnt( "fx_origin_5", "targetname" );
	destF = getEnt( "fx_origin_6", "targetname" );
	destG = getEnt( "fx_origin_7", "targetname" );
	destH = getEnt( "fx_origin_8", "targetname" );
	destI = getEnt( "fx_origin_9", "targetname" );
	destJ = getEnt( "fx_origin_10", "targetname" );
	destK = getEnt( "fx_origin_11", "targetname" );
	destL = getEnt( "fx_origin_12", "targetname" );
	
	for(;;)
	{
	wait 0.1;
	fxA = spawnFx( level.fire, destA.origin );
	triggerFx(fxA);
	fxB = spawnFx( level.fire, destB.origin );
	triggerFx(fxB);
	fxC = spawnFx( level.fire, destC.origin );
	triggerFx(fxC);
	level.killfire = 1;
	wait 2;
	fxA delete();
	fxB delete();
	fxC delete();
	level.killfire = 0;
	level.killfire2 = 1;
	fxD = spawnFx( level.fire, destD.origin );
	triggerFx(fxD);
	fxE = spawnFx( level.fire, destE.origin );
	triggerFx(fxE);
	fxF = spawnFx( level.fire, destF.origin );
	triggerFx(fxF);
	wait 2;
	fxD delete();
	fxE delete();
	fxF delete();
	level.killfire2 = 0;
	level.killfire3 = 1;
	fxG = spawnFx( level.fire, destG.origin );
	triggerFx(fxG);
	fxH = spawnFx( level.fire, destH.origin );
	triggerFx(fxH);
	fxI = spawnFx( level.fire, destI.origin );
	triggerFx(fxI);
	wait 2;
	fxG delete();
	fxH delete();
	fxI delete();
	level.killfire3 = 0;
	level.killfire4 = 1;
	fxJ = spawnFx( level.fire, destJ.origin );
	triggerFx(fxJ);
	fxK = spawnFx( level.fire, destK.origin );
	triggerFx(fxK);
	fxL = spawnFx( level.fire, destL.origin );
	triggerFx(fxL);
	wait 2;
	fxJ delete();
	fxK delete();
	fxL delete();
	level.killfire4 = 0;
	wait 0.1;
    }
	
}

trap5()
{
    block1 = getent("trap5-1","targetname");
	trig = getent("trap5","targetname");
    trig setHintString("Press [Use] to activate the trap");
	trig waittill("trigger",player);	
}

trap6()
{
    block1 = getent("trap6-1","targetname");
    block2 = getent("trap6-2","targetname");
    block3 = getent("trap6-3","targetname");
	trig = getent("trap6","targetname");
    trig setHintString("Press [Use] to activate the trap");
	trig waittill("trigger",player);
}

trap6killfire()
{
	trigdmg666 = getent("hurt1","targetname");
	for(;;)
	{
	trigdmg666 waittill("trigger",player);
	if (level.killfiretrap6 == 1)
	{
		player suicide();
	}
	}
	
}

trap6killfire2()
{
	trigdmg26 = getent("hurt2","targetname");
	for(;;)
	{
	trigdmg26 waittill("trigger",player);
	if (level.killfiretrap6 == 1)
	{
		player suicide();
	}
	}
	
}

trap6killfire3()
{
	trigdmg36 = getent("hurt3","targetname");
	for(;;)
	{
	trigdmg36 waittill("trigger",player);
	if (level.killfiretrap6 == 1)
	{
		player suicide();
	}
	}
	
}

trap6killfire4()
{
	trigdmg46 = getent("hurt4","targetname");
	for(;;)
	{
	trigdmg46 waittill("trigger",player);
	if (level.killfiretrap6 == 1)
	{
		player suicide();
	}
	}
	
}

trap6killfire5()
{
	trigdmg56 = getent("hurt5","targetname");
	for(;;)
	{
	trigdmg56 waittill("trigger",player);
	if (level.killfiretrap6 == 1)
	{
		player suicide();
	}
	}
	
}

trap6killfire6()
{
	trigdmg66 = getent("hurt6","targetname");
	for(;;)
	{
	trigdmg66 waittill("trigger",player);
	if (level.killfiretrap6 == 1)
	{
		player suicide();
	}
	}
	
}

playEffect2()
{

	destAA = getEnt( "fx_origin_20", "targetname" );
	destBA = getEnt( "fx_origin_21", "targetname" );
	destCA = getEnt( "fx_origin_22", "targetname" );
	destDA = getEnt( "fx_origin_23", "targetname" );
	destEA = getEnt( "fx_origin_24", "targetname" );
	destFA = getEnt( "fx_origin_25", "targetname" );
	destGA = getEnt( "fx_origin_26", "targetname" );
	destHA = getEnt( "fx_origin_27", "targetname" );
	destIA = getEnt( "fx_origin_28", "targetname" );
	destJA = getEnt( "fx_origin_29", "targetname" );
	destKA = getEnt( "fx_origin_30", "targetname" );
	destLA = getEnt( "fx_origin_31", "targetname" );
	
	for(;;)
	{
	wait 0.1;
	level.killfiretrap6 = 1;
	fxAA = spawnFx( level.fire, destAA.origin );
	triggerFx(fxAA);
	fxBA = spawnFx( level.fire, destBA.origin );
	triggerFx(fxBA);
	fxCA = spawnFx( level.fire, destCA.origin );
	triggerFx(fxCA);
	fxDA = spawnFx( level.fire, destDA.origin );
	triggerFx(fxDA);
	fxEA = spawnFx( level.fire, destEA.origin );
	triggerFx(fxEA);
	fxFA = spawnFx( level.fire, destFA.origin );
	triggerFx(fxFA);
	fxGA = spawnFx( level.fire, destGA.origin );
	triggerFx(fxGA);
	fxHA = spawnFx( level.fire, destHA.origin );
	triggerFx(fxHA);
	fxIA = spawnFx( level.fire, destIA.origin );
	triggerFx(fxIA);
	fxJA = spawnFx( level.fire, destJA.origin );
	triggerFx(fxJA);
	fxKA = spawnFx( level.fire, destKA.origin );
	triggerFx(fxKA);
	fxLA = spawnFx( level.fire, destLA.origin );
	triggerFx(fxLA);
    wait 5;
	fxAA delete();
	fxBA delete();
	fxCA delete();
	fxDA delete();
	fxEA delete();
	fxFA delete();
	fxGA delete();
	fxHA delete();
	fxIA delete();
	fxJA delete();
	fxKA delete();
	fxLA delete();
	level.killfiretrap6 = 0;
	wait 5;
	}
}

trap7()
{
    block1 = getent("trap7-1","targetname");
    block2 = getent("trap7-2","targetname");
    block3 = getent("trap7-3","targetname");
    block4 = getent("trap7-4","targetname");
	trig = getent("trap7","targetname");
    trig setHintString("Press [Use] to activate the trap");
	trig waittill("trigger",player);
}

endmap()
{
   endmap = getent("trig_endmap","targetname");
   endmap waittill("trigger",player);
   {
   wait 0.5;
   iprintlnBold(" ^9" + player.name + " ^2 has finished the Map at ^4first^2 place ^1!");
   wait 2;
   }
   endmap delete();
}

//secret

secretxpjumperrespawn()
{
	secretxpjumper = getEnt("secretxp_trigger_respawn", "targetname");
	origin_jumper_secretxp = getEnt("origin_jumper_secretxprespawn", "targetname");
	
	for (;;)
	{
		secretxpjumper waittill("trigger", player);
		player setOrigin(origin_jumper_secretxp.origin);
		player setPlayerAngles(origin_jumper_secretxp.angles);
	}
}

secretxpjumperrespawn2()
{
	secretxpjumper = getEnt("secretxp_trigger_respawn2", "targetname");
	origin_jumper_secretxp = getEnt("origin_jumper_secretxprespawn2", "targetname");
	
	for (;;)
	{
		secretxpjumper waittill("trigger", player);
		player setOrigin(origin_jumper_secretxp.origin);
		player setPlayerAngles(origin_jumper_secretxp.angles);
	}
}

secretxpjumper()
{
	secretxpjumper = getEnt("secretxp_trigger", "targetname");
	origin_jumper_secretxp = getEnt("origin_jumper_secretxp", "targetname");
	
	for (;;)
	{
		secretxpjumper waittill("trigger", player);
		player setOrigin(origin_jumper_secretxp.origin);
		player setPlayerAngles(origin_jumper_secretxp.angles);
	}
}

secretjumpfail()
{
	secretjumper = getEnt("secret_trigger_respawn", "targetname");
	origin_jumper_secret = getEnt("origin_jumper_secret", "targetname");
	
	for (;;)
	{
		secretjumper waittill("trigger", player);
		player setOrigin(origin_jumper_secret.origin);
		player setPlayerAngles(origin_jumper_secret.angles);
		player iprintln("^3>>^1Respawned");
	}
}

portesecret()
{
   block1 = getent("porte1","targetname");
   secret = getent("trig_secret","targetname");
   secret waittill("trigger",player);
   
   {
   wait 2;
   block1 delete();
   wait 10;
   }
}

secretxp1()
{
   secretxp1 = getent("secretacti_xp1","targetname");
   origin_acti_secret = getEnt("actisecret14", "targetname");
   secretxp1 waittill("trigger",player);
   {
   player setOrigin(origin_acti_secret.origin);
   player setPlayerAngles(origin_acti_secret.angles);
   thread portesecret1();
   player braxi\_rank::giveRankXP("", 200);
   }
   
}

secretxp2()
{
   secretxp2 = getent("secretacti_xp2","targetname");
   origin_acti_secret2 = getEnt("secretactifinish", "targetname");
   secretxp2 waittill("trigger",player);
   {
   player setOrigin(origin_acti_secret2.origin);
   player setPlayerAngles(origin_acti_secret2.angles);
   thread portesecret2();
   player braxi\_rank::giveRankXP("", 200);
   }
   
}

secretxp3()
{
   level.endsecret2_trigger = getent("jumperxp1","targetname");
   telejumporigin3 = getEnt("jumperxpfin", "targetname");
   
   while(1)
   {
      level.endsecret2_trigger waittill( "trigger", player );
      if( !isDefined( level.endsecret2_trigger ) )
      return;
      if(level.firstenter==true)

   player SetOrigin( telejumporigin3.origin );
   player setplayerangles( telejumporigin3.angles );
   player thread speedrun\_way_name::finish_way("s1");
      
}
}

secretxp4()
{
   level.endsecret_trigger = getent("trigger_endsecret","targetname");
   telejumporigin2 = getent("jumper_secretend", "targetname");
   
   while(1)
   {
      level.endsecret_trigger waittill( "trigger", player );
      if( !isDefined( level.endsecret_trigger ) )
      return;
      if(level.firstenter==true)
   
   player SetOrigin( telejumporigin2.origin );
   player setplayerangles( telejumporigin2.angles );
   player thread speedrun\_way_name::finish_way("s0");
 
   
}
}

portesecret1()
{
   block1 = getent("porte2","targetname");
   block1 moveZ (112, 1);
}

portesecret2()
{
   block1 = getent("portesecret","targetname");
   block1 moveZ (56, 1);
}

actifail1()
{
	actisecret = getEnt("secretacti_respawn1", "targetname");
	origin_acti_secret = getEnt("actisecret1", "targetname");
	
	for (;;)
	{
		actisecret waittill("trigger", player);
		player setOrigin(origin_acti_secret.origin);
		player setPlayerAngles(origin_acti_secret.angles);
		player iprintln("^3>>^1Respawned");
	}
}

actifail2()
{
	actisecret = getEnt("secretacti_respawn2", "targetname");
	origin_acti_secret = getEnt("actisecret2", "targetname");
	
	for (;;)
	{
		actisecret waittill("trigger", player);
		player setOrigin(origin_acti_secret.origin);
		player setPlayerAngles(origin_acti_secret.angles);
		player iprintln("^3>>^1Respawned");
	}
}

actifail3()
{
	actisecret = getEnt("secretacti_respawn3", "targetname");
	origin_acti_secret = getEnt("actisecret3", "targetname");
	
	for (;;)
	{
		actisecret waittill("trigger", player);
		player setOrigin(origin_acti_secret.origin);
		player setPlayerAngles(origin_acti_secret.angles);
		player iprintln("^3>>^1Respawned");
	}
}

actifail4()
{
	actisecret = getEnt("secretacti_respawn4", "targetname");
	origin_acti_secret = getEnt("actisecret4", "targetname");
	
	for (;;)
	{
		actisecret waittill("trigger", player);
		player setOrigin(origin_acti_secret.origin);
		player setPlayerAngles(origin_acti_secret.angles);
		player iprintln("^3>>^1Respawned");
	}
}

actifail5()
{
	actisecret = getEnt("secretacti_respawn5", "targetname");
	origin_acti_secret = getEnt("actisecret5", "targetname");
	
	for (;;)
	{
		actisecret waittill("trigger", player);
		player setOrigin(origin_acti_secret.origin);
		player setPlayerAngles(origin_acti_secret.angles);
		player iprintln("^3>>^1Respawned");
	}
}

actifail6()
{
	actisecret = getEnt("secretacti_respawn6", "targetname");
	origin_acti_secret = getEnt("actisecret6", "targetname");
	
	for (;;)
	{
		actisecret waittill("trigger", player);
		player setOrigin(origin_acti_secret.origin);
		player setPlayerAngles(origin_acti_secret.angles);
		player iprintln("^3>>^1Respawned");
	}
}

actifail7()
{
	actisecret = getEnt("secretacti_respawn7", "targetname");
	origin_acti_secret = getEnt("actisecret7", "targetname");
	
	for (;;)
	{
		actisecret waittill("trigger", player);
		player setOrigin(origin_acti_secret.origin);
		player setPlayerAngles(origin_acti_secret.angles);
		player iprintln("^3>>^1Respawned");
	}
}

actifail8()
{
	actisecret = getEnt("secretacti_respawn8", "targetname");
	origin_acti_secret = getEnt("actisecret8", "targetname");
	
	for (;;)
	{
		actisecret waittill("trigger", player);
		player setOrigin(origin_acti_secret.origin);
		player setPlayerAngles(origin_acti_secret.angles);
		player iprintln("^3>>^1Respawned");
	}
}

actifail9()
{
	actisecret = getEnt("secretacti_respawn9", "targetname");
	origin_acti_secret = getEnt("actisecret9", "targetname");
	
	for (;;)
	{
		actisecret waittill("trigger", player);
		player setOrigin(origin_acti_secret.origin);
		player setPlayerAngles(origin_acti_secret.angles);
		player iprintln("^3>>^1Respawned");
	}
}

actifail10()
{
	actisecret = getEnt("secretacti_respawn10", "targetname");
	origin_acti_secret = getEnt("actisecret10", "targetname");
	
	for (;;)
	{
		actisecret waittill("trigger", player);
		player setOrigin(origin_acti_secret.origin);
		player setPlayerAngles(origin_acti_secret.angles);
		player iprintln("^3>>^1Respawned");
	}
}

actifail11()
{
	actisecret = getEnt("secretacti_respawn11", "targetname");
	origin_acti_secret = getEnt("actisecret11", "targetname");
	
	for (;;)
	{
		actisecret waittill("trigger", player);
		player setOrigin(origin_acti_secret.origin);
		player setPlayerAngles(origin_acti_secret.angles);
		player iprintln("^3>>^1Respawned");
	}
}

actifail12()
{
	actisecret = getEnt("secretacti_respawn12", "targetname");
	origin_acti_secret = getEnt("actisecret12", "targetname");
	
	for (;;)
	{
		actisecret waittill("trigger", player);
		player setOrigin(origin_acti_secret.origin);
		player setPlayerAngles(origin_acti_secret.angles);
		player iprintln("^3>>^1Respawned");
	}
}

actifail13()
{
	actisecret = getEnt("secretacti_respawn13", "targetname");
	origin_acti_secret = getEnt("actisecret13", "targetname");
	
	for (;;)
	{
		actisecret waittill("trigger", player);
		player setOrigin(origin_acti_secret.origin);
		player setPlayerAngles(origin_acti_secret.angles);
		player iprintln("^3>>^1Respawned");
	}
}

//rooms

roomjumpfail()
{
	secretjumper = getEnt("trigger_failroom", "targetname");
	origin_jumper_secret = getEnt("origin_failroom", "targetname");
	
	for (;;)
	{
		secretjumper waittill("trigger", player);
		player setOrigin(origin_jumper_secret.origin);
		player setPlayerAngles(origin_jumper_secret.angles);
	    player freezeControls(1);
		wait 10;
	    player freezeControls(0);
	}
}

jumproomjumpfail()
{
	jumpjumper = getEnt("jump_jumper_respawn20", "targetname");
	origin_jumper_jumptest = getEnt("origin_jumper_jump2", "targetname");
	
	for (;;)
	{
		jumpjumper waittill("trigger", player);
		player setOrigin(origin_jumper_jumptest.origin);
		player setPlayerAngles(origin_jumper_jumptest.angles);
		player iprintln("^3>>^1Respawned");
	}
}

jumproomactifail()
{
	actijumper = getEnt("trig_jumprespawn", "targetname");
	origin_acti_jumptest = getEnt("origin_acti_jump2", "targetname");
	
	for (;;)
	{
		actijumper waittill("trigger", player);
		player setOrigin(origin_acti_jumptest.origin);
		player setPlayerAngles(origin_acti_jumptest.angles);
		player iprintln("^3>>^1Respawned");
	}
}

runroomfail()
{
	actijumper2 = getEnt("trig_runrespawn", "targetname");
	origin_acti_jumptest2 = getEnt("origin_runrespawn", "targetname");
	
	for (;;)
	{
		actijumper2 waittill("trigger", player);
		player setOrigin(origin_acti_jumptest2.origin);
		player setPlayerAngles(origin_acti_jumptest2.angles);
		player iprintln("^3>>^1Respawned");
	}
}

jumpsniper()
{
   weaponbounce = getent("weaponbounce","targetname");
   
   for(;;)
   {
   weaponbounce waittill("trigger",player );
   player GiveWeapon( "m40a3_mp" );
   player switchToWeapon( "m40a3_mp" );
   player thread ammo();
   }
}

jump()
{
   level.jump_trigger = getent("trig_jump","targetname");
   level.jump_trigger setHintString("Jump");

   while(1)
   {
      level.jump_trigger waittill("trigger",player );

      if( !isDefined(level.jump_trigger ) )
      return;
      if(level.firstenter==true)
   {
   level.old_trigger delete();
   level.sniper_trigger delete();
   level.knife_trigger delete();
   level.weapons_trigger delete();
   level.randomspeed_trigger delete();
   level.run_trigger delete();
   level.race delete();
   level.firstenter=false;
   } 
   wait(0.05);

   player SetOrigin((-7176, -13144, 1144));
   player SetPlayerAngles((0,270,0));
   player TakeAllWeapons();
   wait(0.05);
   level.activ SetOrigin((-7480, -13144, 1128));
   level.activ SetPlayerAngles((0,360,0));
   level.activ TakeAllWeapons();
   wait .05;
   level.activ giveweapon("knife_mp");
   player giveweapon("knife_mp");
   player switchToWeapon( "knife_mp" );
   level.activ SwitchToWeapon( "knife_mp" );
   iPrintlnBold(" ^9" + player.name + " ^4 has entered the Jump room^8!"); 
   wait(0.05);



   player waittill( "death" );
   level.PlayerInRoom = false;

}
}

old()
{
   block1 = getent("old","targetname");
   level.old_trigger = getent("trig_porte1","targetname");
   level.old_trigger waittill("trigger",player);
   level.old_trigger setHintString("Old");
   
   level.sniper_trigger delete();
   level.jump_trigger delete();
   level.knife_trigger delete();
   level.weapons_trigger delete();
   level.randomspeed_trigger delete();
   level.run_trigger delete();
   level.race delete();
   level.firstenter=false;
   {
   wait 2;
   block1 delete();
   iPrintlnBold(" ^9" + player.name + " ^4 has entered the Old room^8!"); 
   wait 2;
   }
   level.old_trigger delete();
}

snipertp()
{
   level.sniper_trigger = getent("trig_sniper","targetname");
   telesniperorigin = getent("jumper_sniper", "targetname");
   level.sniper_trigger setHintString("Sniper");
   
   while(1)
   {
      level.sniper_trigger waittill( "trigger", player );
      if( !isDefined( level.sniper2_trigger ) )
      return;
      if(level.firstenter==true)
	     {
   level.old_trigger delete();
   level.jump_trigger delete();
   level.knife_trigger delete();
   level.weapons_trigger delete();
   level.randomspeed_trigger delete();
   level.run_trigger delete();
   level.race delete();
   level.firstenter=false;
   } 

   wait(0.05);

   player SetOrigin( telesniperorigin.origin );
   player setplayerangles( telesniperorigin.angles );
   wait(0.05);
   player waittill( "death" );
   level.PlayerInRoom = false;
   
}
}

runtp()
{
   level.run_trigger = getent("run","targetname");
   telesniperorigin = getent("origin_runner_room", "targetname");
   level.run_trigger setHintString("Run");
   
   while(1)
   {
      level.run_trigger waittill( "trigger", player );
      if( !isDefined( level.run_trigger ) )
      return;
      if(level.firstenter==true)
	     {
   level.old_trigger delete();
   level.jump_trigger delete();
   level.knife_trigger delete();
   level.weapons_trigger delete();
   level.randomspeed_trigger delete();
   level.sniper_trigger delete();
   level.race delete();
   level.firstenter=false;
   } 

   wait(0.05);

   iPrintlnBold( " ^9" + player.name + " ^4 has entered the Run room^8!" ); 
   player SetOrigin( telesniperorigin.origin );
   player setplayerangles( telesniperorigin.angles );
   wait(0.05);
   level.runmove1 = true;
   player waittill( "death" );
   level.PlayerInRoom = false;
   level.runmove1 = false;
   
}
}

run()
{
   level.run6_trigger = getent("runjumper","targetname");
   level.run6_trigger setHintString("Runner");

   while(1)
   {
   level.run6_trigger waittill( "trigger", player );
   level.runjumper = player;
   level.jumperkilltest = 0;
   player SetOrigin((-17352, -13976, 744));
   player SetPlayerAngles((0,90,0));
   self.health = 300;
   player TakeAllWeapons();
   player GiveWeapon("knife");
   wait .05;
   player SwitchToWeapon("knife"); 
   wait(0.05);
   level.activ SetOrigin((-17352, -10664, 1432));
   level.activ SetPlayerAngles((0,270,0));
   level.activ TakeAllWeapons();
   level.activ GiveWeapon( "m40a3_mp" );
   level.activ GiveMaxAmmo("m40a3_mp");
   wait .05;
   level.activ SwitchToWeapon("m40a3_mp"); 
   player thread ammo();
   level.activ thread ammo();
   wait(0.05);
   thread runmove1();
   }
}

run4()
{
   level.run2_trigger = getent("runacti","targetname");
   level.run2_trigger setHintString("Killer");
   
   while(1)
   {
   level.run2_trigger waittill( "trigger", player );
   level.runjumper = player;
   level.jumperkilltest = 1;
   level.activ SetOrigin((-17352, -13976, 744));
   level.activ SetPlayerAngles((0,90,0));
   level.activ.health = 300;
   level.activ TakeAllWeapons();
   level.activ GiveWeapon("knife");
   wait .05;
   level.activ SwitchToWeapon("knife"); 
   wait(0.05);
   player SetOrigin((-17352, -10664, 1432));
   player SetPlayerAngles((0,270,0));
   player TakeAllWeapons();
   player GiveWeapon( "m40a3_mp" );
   player GiveMaxAmmo("m40a3_mp");
   wait .05;
   player SwitchToWeapon("m40a3_mp"); 
   player thread ammo();
   level.activ thread ammo();
   wait(0.05);
   thread runmove1();
   }
}

run2()
{
   level.run2_trigger = getent("run2","targetname");
   level.run2_trigger waittill( "trigger", player );
   if(level.jumperkilltest == 1)
   {
   level.runjumper suicide();
   level.runmove1 = false;
   }
   if(level.jumperkilltest == 0)
   {
   level.activ suicide();
   level.runmove1 = false;
   }
   
}

runmove1()
{
   block = getent("runroom_move","targetname");
   while(level.runmove1 == true)
   {
   block moveZ (100, 4);
   wait 4;
   block moveZ (-100, 4);
   wait 4;
   }
	
}

sniper1()
{
   level.sniper2_trigger = getent("trig_sniper1","targetname");
   level.teleactorigin = getent("origin_acti_sniper", "targetname");
   telejumporigin = getent("origin_jumper_sniper", "targetname");

   while(1)
   {
      level.sniper2_trigger waittill( "trigger", player );

      if( !isDefined( level.sniper_trigger ) )
      return;
      if(level.firstenter==true)

   wait(0.05);

   player SetOrigin((-7256, -6584, 1144));
   player SetPlayerAngles((0,270,0));
   player TakeAllWeapons();
   player GiveWeapon("m40a3_mp");
   player GiveWeapon( "remington700_mp" ); 
   player GiveMaxAmmo("m40a3_mp");
   player GiveMaxAmmo( "remington700_mp" );
   wait .05;
   player SwitchToWeapon("m40a3_mp"); 
   wait(0.05);
   level.activ SetOrigin((-7272, -8232, 1144));
   level.activ SetPlayerAngles((0,90,0));
   level.activ TakeAllWeapons();
   level.activ GiveWeapon( "m40a3_mp" );
   level.activ GiveWeapon( "remington700_mp" );
   level.activ GiveMaxAmmo("m40a3_mp");
   level.activ GiveMaxAmmo( "remington700_mp" );
   wait .05;
   level.activ SwitchToWeapon("m40a3_mp"); 
   iPrintlnBold( " ^9" + player.name + " ^4 has entered the Sniper room^8!" ); 
   player thread ammo();
   level.activ thread ammo();
   wait(0.05);
   player switchToWeapon( "m40a3_mp" );
   level.activ SwitchToWeapon( "m40a3_mp" );
   player waittill( "death" );
   level.PlayerInRoom = false;
   }
}

sniper2()
{
   level.sniper3_trigger = getent("trig_sniper2","targetname");
   level.teleactorigin2 = getent("origin_acti_sniper2", "targetname");
   telejumporigin2 = getent("origin_jumper_sniper2", "targetname");

   while(1)
   {
      level.sniper3_trigger waittill( "trigger", player );

      if( !isDefined( level.sniper3_trigger ) )
      return;
      if(level.firstenter==true)

   wait(0.05);

   player SetOrigin((-12216, -6200, 776));
   player SetPlayerAngles((0,270,0));
   player TakeAllWeapons();
   player GiveWeapon("m40a3_mp");
   player GiveWeapon( "remington700_mp" ); 
   player GiveMaxAmmo("m40a3_mp");
   player GiveMaxAmmo( "remington700_mp" );
   wait .05;
   player SwitchToWeapon("m40a3_mp"); 
   wait(0.05);
   level.activ SetOrigin((-11624, -7592, 776));
   level.activ SetPlayerAngles((0,90,0));
   level.activ TakeAllWeapons();
   level.activ GiveWeapon( "m40a3_mp" );
   level.activ GiveWeapon( "remington700_mp" );
   level.activ GiveMaxAmmo("m40a3_mp");
   level.activ GiveMaxAmmo( "remington700_mp" );
   wait .05;
   level.activ SwitchToWeapon("m40a3_mp"); 
   iPrintlnBold( " ^9" + player.name + " ^4 has entered the Sniper room^8!" ); 
   player thread ammo();
   level.activ thread ammo();
   wait(0.05);
   player switchToWeapon( "m40a3_mp" );
   level.activ SwitchToWeapon( "m40a3_mp" );
   player waittill( "death" );
   level.PlayerInRoom = false;
   }
}

sniper3()
{
   level.sniper4_trigger = getent("trig_sniper3","targetname");
   level.teleactorigin3 = getent("origin_acti_sniper3", "targetname");
   telejumporigin3 = getent("origin_jumper_sniper3", "targetname");

   while(1)
   {
      level.sniper4_trigger waittill( "trigger", player );

      if( !isDefined( level.sniper4_trigger ) )
      return;
      if(level.firstenter==true)

   wait(0.05);

   player SetOrigin((-11704, -12338, 776));
   player SetPlayerAngles((0,270,0));
   player TakeAllWeapons();
   player GiveWeapon("m40a3_mp");
   player GiveWeapon( "remington700_mp" ); 
   player GiveMaxAmmo("m40a3_mp");
   player GiveMaxAmmo( "remington700_mp" );
   wait .05;
   player SwitchToWeapon("m40a3_mp"); 
   wait(0.05);
   level.activ SetOrigin((-11720, -13864, 776));
   level.activ SetPlayerAngles((0,90,0));
   level.activ TakeAllWeapons();
   level.activ GiveWeapon( "m40a3_mp" );
   level.activ GiveWeapon( "remington700_mp" );
   level.activ GiveMaxAmmo("m40a3_mp");
   level.activ GiveMaxAmmo( "remington700_mp" );
   wait .05;
   level.activ SwitchToWeapon("m40a3_mp"); 
   iPrintlnBold( " ^9" + player.name + " ^4 has entered the Sniper room^8!" ); 
   player thread ammo();
   level.activ thread ammo();
   wait(0.05);
   player switchToWeapon( "m40a3_mp" );
   level.activ SwitchToWeapon( "m40a3_mp" );
   player waittill( "death" );
   level.PlayerInRoom = false;
   }
}

knife()
{
   level.knife_trigger = getent("trig_knife","targetname");
   level.teleactorigin = getent("origin_acti_knife", "targetname");
   telejumporigin = getent("origin_jumper_knife", "targetname");
   level.knife_trigger setHintString("Knife");
   
   while(1)
   {
      level.knife_trigger waittill("trigger",player );

      if( !isDefined(level.knife_trigger ) )
      return;
      if(level.firstenter==true)
   {
   level.old_trigger delete();
   level.sniper_trigger delete();
   level.jump_trigger delete();
   level.weapons_trigger delete();
   level.randomspeed_trigger delete();
   level.run_trigger delete();
   level.race delete();
   level.firstenter=false;
   } 
   wait(0.05);

   player SetOrigin((-7208, -6584, 1144));
   player SetPlayerAngles((0,270,0));
   player TakeAllWeapons();
   wait(0.05);
   level.activ SetOrigin((-7224, -8232, 1144));
   level.activ SetPlayerAngles((0,90,0));
   level.activ TakeAllWeapons();
   wait .05;
   level.activ giveweapon("knife_mp");
   player giveweapon("knife_mp");
   player switchToWeapon( "knife_mp" );
   level.activ SwitchToWeapon( "knife_mp" );
   iPrintlnBold(" ^9" + player.name + " ^4 has entered the Knife room^8!"); 
   wait(0.05);



   player waittill( "death" );
   level.PlayerInRoom = false;

}
}

partyjump() //Script by Mewen ^^
{
    level.race = getent("room_race_trig", "targetname");
	level.race_acti_tp = getent("ss_acti","targetname");
	level.race_jumper_tp = getent("ss_jumper","targetname");


	while(1)
    {
    	level.race setHintString("PartyJump");
        level.race waittill( "trigger", player );

        if(!isDefined(level.race))
            return;
		
		      if(level.firstenter==true)
   {
   level.old_trigger delete();
   level.sniper_trigger delete();
   level.jump_trigger delete();
   level.weapons_trigger delete();
   level.randomspeed_trigger delete();
   level.run_trigger delete();
   level.knife_trigger delete();
   level.firstenter=false;
   } 

        if(!isdefined(level.activKills))
			level.playername = player.name;

		player freezeControls(1);
		level.activ freezeControls(1);
        
        player setOrigin(level.race_jumper_tp.origin);
		player setPlayerangles(level.race_jumper_tp.angles);
		
		player TakeAllWeapons();
		
		level.activ setOrigin( level.race_acti_tp.origin );
		level.activ setPlayerangles( level.race_acti_tp.angles );	
		
		level.activ TakeAllWeapons();
		wait 1;
		player iPrintlnBold(" ^7>>^13^7<<");
		level.activ iPrintlnBold(" ^7>>^13^7<<");
		wait 1;
		player iPrintlnBold(" ^7>>^12^7<<");
		level.activ iPrintlnBold(" ^7>>^12^7<<");
		wait 1;
		player iPrintlnBold(" ^7>>^11^7<<");
		level.activ iPrintlnBold(" ^7>>^11^7<<");
		wait 1;
		player iprintlnbold("^1Good Luck!");
		level.activ iprintlnbold("^1Good Luck!");
		wait 0.5;
		
		player freezeControls(0);
		level.activ freezeControls(0);
		thread ss_game(player);
		thread ss_check(player);
   player waittill( "death" );
			level.ss_on = 0;
   level.PlayerInRoom = false;

    }
}

ss_check(player)
{
	trig = getent("ss_lose", "targetname");
	winner = getent("ss_winner", "targetname");
	loser = getent("ss_loser", "targetname");
	trig waittill("trigger", loser);
	level.ss_on = 0;

	if(loser == player)
	{
		player takeallweapons();
		player freezeControls(1);
		level.activ freezeControls(1);

		player setOrigin(level.race_jumper_tp.origin);
		player setPlayerangles(level.race_jumper_tp.angles);
		level.activ setOrigin( level.race_acti_tp.origin );
		level.activ setPlayerangles( level.race_acti_tp.angles );	

		player iprintlnbold("^1You ^7lost to the ^1Activator");

		level.activ giveWeapon("deserteagle_mp");
		level.activ switchToWeapon("deserteagle_mp");
		level.activ iprintlnbold("^1You Win! ^7now kill the ^1Jumper");
		wait 3.5;
		level.activ freezeControls(0);
	} 
	else
	{
		level.activ takeallweapons();
		level.activ freezeControls(1);
		player freezeControls(1);

		player setOrigin(level.race_jumper_tp.origin);
		player setPlayerangles(level.race_jumper_tp.angles);
		level.activ setOrigin( level.race_acti_tp.origin );
		level.activ setPlayerangles( level.race_acti_tp.angles );	

		level.activ iprintlnbold("^1You ^7lost to the ^1Jumper");

		player giveWeapon("deserteagle_mp");
		player switchToWeapon("deserteagle_mp");
		player iprintlnbold("^1You Win! ^7now kill the ^1Activator");
		wait 3.5;
		player freezeControls(0);
	}
}

ss_game(player)
{
	ss_black = getent("ss_ss_black", "targetname");
	ss_brown = getent("ss_ss_brown", "targetname");
	ss_blue = getent("ss_ss_blue", "targetname");
	ss_blue2 = getent("ss_ss_blue2", "targetname");
	ss_yellow = getent("ss_ss_yellow", "targetname");
	ss_red1 = getent("ss_ss_red", "targetname");
	ss_green1 = getent("ss_ss_green", "targetname");
	ss_purple = getent("ss_ss_purple", "targetname");
	ss_orange = getent("ss_ss_orange", "targetname");

	level.ss_on = 1;
	hide = "";
	time = 0;
	length = 3.5;

	while (level.ss_on == 1)
	{

		colour = randomint(9);
		if (colour == 0)
		{
		level.activ iprintlnbold("Black");
		player iprintlnbold("Black");
			hide = ss_black;
		}
		if (colour == 1)
		{
		level.activ iprintlnbold("Brown");
		player iprintlnbold("Brown");
			hide = ss_brown;
		}
		if (colour == 2)
		{
		level.activ iprintlnbold("Blue");
		player iprintlnbold("Blue");
			hide = ss_blue;
		}
		if (colour == 3)
		{
		level.activ iprintlnbold("White");
		player iprintlnbold("White");
			hide = ss_blue2;
		}
		if (colour == 4)
		{
		level.activ iprintlnbold("Red");
		player iprintlnbold("Red");
			hide = ss_red1;
		}
		if (colour == 5)
		{
		level.activ iprintlnbold("Green");
		player iprintlnbold("Green");
			hide = ss_green1;
		}
		if (colour == 6)
		{
		level.activ iprintlnbold("Yellow");
		player iprintlnbold("Yellow");
			hide = ss_yellow;
		}
		if (colour == 7)
		{
		level.activ iprintlnbold("Purple");
		player iprintlnbold("Purple");
			hide = ss_purple;
		}
		if (colour == 8)
		{
		level.activ iprintlnbold("Orange");
		player iprintlnbold("Orange");
			hide = ss_orange;
		}

		wait(length);

		ss_black hide();
		ss_brown hide();
		ss_blue hide();
		ss_blue2 hide();
		ss_yellow hide();
		ss_red1 hide();
		ss_green1 hide();
		ss_purple hide();
		ss_orange hide();

		ss_black notsolid();
		ss_brown notsolid();
		ss_blue notsolid();
		ss_blue2 notsolid();
		ss_yellow notsolid();
		ss_red1 notsolid();
		ss_green1 notsolid();
		ss_purple notsolid();
		ss_orange notsolid();

		hide show();
		hide solid();

		wait 3;

		ss_black show();
		ss_brown show();
		ss_blue show();
		ss_blue2 show();
		ss_yellow show();
		ss_red1 show();
		ss_green1 show();
		ss_purple show();
		ss_orange show();

		ss_black solid();
		ss_brown solid();
		ss_blue solid();
		ss_blue2 solid();
		ss_yellow solid();
		ss_red1 solid();
		ss_green1 solid();
		ss_purple solid();
		ss_orange solid();

		time += 1;
		length -= 0.25;

		if(time == 14 && isAlive(player))
		{
			player iprintlnbold("^1You've been given a knife as game went on too long");
			level.activ iprintlnbold("^1You've been given a knife as game went on too long");
			player giveWeapon("knife_mp");
			level.activ giveWeapon("knife_mp");
			player switchToWeapon("knife_mp");
			level.activ switchToWeapon("knife_mp");
			level.ss_on = 0;
		}
	}
}

randomspeed()  //il doit avoir plus opti mais flemme
{
   level.randomspeed_trigger = getent("randomspeed","targetname");
   level.teleactorigin = getent("origin_acti_randomspeed", "targetname");
   telejumporigin = getent("origin_jumper_randomspeed", "targetname");
   level.randomspeed_trigger setHintString("RandomSpeed");

   while(1)
   {
      level.randomspeed_trigger waittill( "trigger", player );

      if( !isDefined( level.randomspeed_trigger ) )
      return;
      if(level.firstenter==true)
		  	  {
   level.old_trigger delete();
   level.sniper_trigger delete();
   level.knife_trigger delete();
   level.weapons_trigger delete();
   level.jump_trigger delete();
   level.run_trigger delete();
   level.race delete();
   level.firstenter=false;
	  }

   wait(0.05);

   player freezeControls(1);
   level.activ freezeControls(1);
   player SetOrigin((-15144, -12368, 776));
   player SetPlayerAngles((0,270,0));
   player TakeAllWeapons();
   player GiveWeapon("m40a3_mp");
   player GiveWeapon( "remington700_mp" ); 
   player GiveMaxAmmo("m40a3_mp");
   player GiveMaxAmmo( "remington700_mp" );
   wait .05;
   player SwitchToWeapon("m40a3_mp"); 
   wait(0.05);
   level.activ SetOrigin((-13896, -14048, 776));
   level.activ SetPlayerAngles((0,90,0));
   level.activ TakeAllWeapons();
   level.activ GiveWeapon( "m40a3_mp" );
   level.activ GiveWeapon( "remington700_mp" );
   level.activ GiveMaxAmmo("m40a3_mp");
   level.activ GiveMaxAmmo( "remington700_mp" );
   wait .05;
   level.activ SwitchToWeapon("m40a3_mp"); 
   iPrintlnBold( " ^9" + player.name + " ^4 has entered the RandomSpeed room^8!" ); 
   wait(0.05);
   player switchToWeapon( "m40a3_mp" );
   level.activ SwitchToWeapon( "m40a3_mp" );
   while(1)
   {
   iPrintlnBold( "Chosen a Random Speed ..." ); 
   wait 3;
   random = randomint(7);
   if(random == 0)
{
   player iPrintlnBold( "^1 50" ); 
   level.activ iPrintlnBold( "^1 50" ); 
   wait 0.3;
   player iPrintlnBold( "^2 100" ); 
   level.activ iPrintlnBold( "^2 100" ); 
   wait 0.3;
   player iPrintlnBold( "^3 150" ); 
   level.activ iPrintlnBold( "^3 150" ); 
   wait 0.3;
   player iPrintlnBold( "^4 200" );
   level.activ iPrintlnBold( "^4 200" ); 
   wait 0.3;   
   player iPrintlnBold( "^5 250" ); 
   level.activ iPrintlnBold( "^5 250" ); 
   wait 0.3;
   player iPrintlnBold( "^6 300" ); 
   level.activ iPrintlnBold( "^6 300" ); 
   wait 0.3;
   player iPrintlnBold( "^7 350" ); 
   level.activ iPrintlnBold( "^7 350" ); 
   wait 0.3;
   player iPrintlnBold( "^8 400" ); 
   level.activ iPrintlnBold( "^8 400" );  
   wait 0.3;
   player iPrintlnBold( "^1 50" ); 
   level.activ iPrintlnBold( "^1 50" ); 
   wait 0.3;
   player iPrintlnBold( "^2 100" ); 
   level.activ iPrintlnBold( "^2 100" ); 
   wait 0.3;
   player iPrintlnBold( "^3 150" ); 
   level.activ iPrintlnBold( "^3 150" ); 
   wait 0.3;
   player iPrintlnBold( "^4 200" );
   level.activ iPrintlnBold( "^4 200" ); 
   wait 0.3;   
   player iPrintlnBold( "^5 250" ); 
   level.activ iPrintlnBold( "^5 250" ); 
   wait 0.3;
   player iPrintlnBold( "^6 300" ); 
   level.activ iPrintlnBold( "^6 300" ); 
   wait 0.3;
   player iPrintlnBold( "^7 350" ); 
   level.activ iPrintlnBold( "^7 350" ); 
   wait 0.3;
   player iPrintlnBold( "^8 400" ); 
   level.activ iPrintlnBold( "^8 400" ); 
   wait 0.3;
   player iPrintlnBold( "^1 50" ); 
   level.activ iPrintlnBold( "^1 50" ); 
   wait 0.3;
   player iPrintlnBold( "^2 100" ); 
   level.activ iPrintlnBold( "^2 100" ); 
   wait 0.3;
   player iPrintlnBold( "^3 150" ); 
   level.activ iPrintlnBold( "^3 150" ); 
   iPrintlnBold( "^9 Speed = ^3 150" ); 
   player SetMoveSpeedScale(1);
   level.activ SetMoveSpeedScale(1);
} 
   if(random == 1)
{
   player iPrintlnBold( "^1 50" ); 
   level.activ iPrintlnBold( "^1 50" ); 
   wait 0.3;
   player iPrintlnBold( "^2 100" ); 
   level.activ iPrintlnBold( "^2 100" ); 
   wait 0.3;
   player iPrintlnBold( "^3 150" ); 
   level.activ iPrintlnBold( "^3 150" ); 
   wait 0.3;
   player iPrintlnBold( "^4 200" );
   level.activ iPrintlnBold( "^4 200" ); 
   wait 0.3;   
   player iPrintlnBold( "^5 250" ); 
   level.activ iPrintlnBold( "^5 250" ); 
   wait 0.3;
   player iPrintlnBold( "^6 300" ); 
   level.activ iPrintlnBold( "^6 300" ); 
   wait 0.3;
   player iPrintlnBold( "^7 350" ); 
   level.activ iPrintlnBold( "^7 350" ); 
   wait 0.3;
   player iPrintlnBold( "^8 400" ); 
   level.activ iPrintlnBold( "^8 400" );  
   wait 0.3;
   player iPrintlnBold( "^1 50" ); 
   level.activ iPrintlnBold( "^1 50" ); 
   wait 0.3;
   player iPrintlnBold( "^2 100" ); 
   level.activ iPrintlnBold( "^2 100" ); 
   wait 0.3;
   player iPrintlnBold( "^3 150" ); 
   level.activ iPrintlnBold( "^3 150" ); 
   wait 0.3;
   player iPrintlnBold( "^4 200" );
   level.activ iPrintlnBold( "^4 200" ); 
   wait 0.3;   
   player iPrintlnBold( "^5 250" ); 
   level.activ iPrintlnBold( "^5 250" ); 
   wait 0.3;
   player iPrintlnBold( "^6 300" ); 
   level.activ iPrintlnBold( "^6 300" ); 
   wait 0.3;
   player iPrintlnBold( "^7 350" ); 
   level.activ iPrintlnBold( "^7 350" ); 
   wait 0.3;
   player iPrintlnBold( "^8 400" ); 
   level.activ iPrintlnBold( "^8 400" ); 
   wait 0.3;
   player iPrintlnBold( "^1 50" ); 
   level.activ iPrintlnBold( "^1 50" ); 
   iPrintlnBold( "^9 Speed = ^1 50" ); 
   player SetMoveSpeedScale(0.3);
   level.activ SetMoveSpeedScale(0.3);
} 
	if(random == 2)
{
   player iPrintlnBold( "^1 50" ); 
   level.activ iPrintlnBold( "^1 50" ); 
   wait 0.3;
   player iPrintlnBold( "^2 100" ); 
   level.activ iPrintlnBold( "^2 100" ); 
   wait 0.3;
   player iPrintlnBold( "^3 150" ); 
   level.activ iPrintlnBold( "^3 150" ); 
   wait 0.3;
   player iPrintlnBold( "^4 200" );
   level.activ iPrintlnBold( "^4 200" ); 
   wait 0.3;   
   player iPrintlnBold( "^5 250" ); 
   level.activ iPrintlnBold( "^5 250" ); 
   wait 0.3;
   player iPrintlnBold( "^6 300" ); 
   level.activ iPrintlnBold( "^6 300" ); 
   wait 0.3;
   player iPrintlnBold( "^7 350" ); 
   level.activ iPrintlnBold( "^7 350" ); 
   wait 0.3;
   player iPrintlnBold( "^8 400" ); 
   level.activ iPrintlnBold( "^8 400" );  
   wait 0.3;
   player iPrintlnBold( "^1 50" ); 
   level.activ iPrintlnBold( "^1 50" ); 
   wait 0.3;
   player iPrintlnBold( "^2 100" ); 
   level.activ iPrintlnBold( "^2 100" ); 
   wait 0.3;
   player iPrintlnBold( "^3 150" ); 
   level.activ iPrintlnBold( "^3 150" ); 
   wait 0.3;
   player iPrintlnBold( "^4 200" );
   level.activ iPrintlnBold( "^4 200" ); 
   wait 0.3;   
   player iPrintlnBold( "^5 250" ); 
   level.activ iPrintlnBold( "^5 250" ); 
   wait 0.3;
   player iPrintlnBold( "^6 300" ); 
   level.activ iPrintlnBold( "^6 300" ); 
   wait 0.3;
   player iPrintlnBold( "^7 350" ); 
   level.activ iPrintlnBold( "^7 350" ); 
   wait 0.3;
   player iPrintlnBold( "^8 400" ); 
   level.activ iPrintlnBold( "^8 400" ); 
   wait 0.3;
   player iPrintlnBold( "^1 50" ); 
   level.activ iPrintlnBold( "^1 50" ); 
   wait 0.3;
   player iPrintlnBold( "^2 100" ); 
   level.activ iPrintlnBold( "^2 100" ); 
   iPrintlnBold( "^9 Speed = ^2 100" ); 
   player SetMoveSpeedScale(0.5);
   level.activ SetMoveSpeedScale(0.5);
} 

	if(random == 3)
{
   player iPrintlnBold( "^1 50" ); 
   level.activ iPrintlnBold( "^1 50" ); 
   wait 0.3;
   player iPrintlnBold( "^2 100" ); 
   level.activ iPrintlnBold( "^2 100" ); 
   wait 0.3;
   player iPrintlnBold( "^3 150" ); 
   level.activ iPrintlnBold( "^3 150" ); 
   wait 0.3;
   player iPrintlnBold( "^4 200" );
   level.activ iPrintlnBold( "^4 200" ); 
   wait 0.3;   
   player iPrintlnBold( "^5 250" ); 
   level.activ iPrintlnBold( "^5 250" ); 
   wait 0.3;
   player iPrintlnBold( "^6 300" ); 
   level.activ iPrintlnBold( "^6 300" ); 
   wait 0.3;
   player iPrintlnBold( "^7 350" ); 
   level.activ iPrintlnBold( "^7 350" ); 
   wait 0.3;
   player iPrintlnBold( "^8 400" ); 
   level.activ iPrintlnBold( "^8 400" );  
   wait 0.3;
   player iPrintlnBold( "^1 50" ); 
   level.activ iPrintlnBold( "^1 50" ); 
   wait 0.3;
   player iPrintlnBold( "^2 100" ); 
   level.activ iPrintlnBold( "^2 100" ); 
   wait 0.3;
   player iPrintlnBold( "^3 150" ); 
   level.activ iPrintlnBold( "^3 150" ); 
   wait 0.3;
   player iPrintlnBold( "^4 200" );
   level.activ iPrintlnBold( "^4 200" ); 
   wait 0.3;   
   player iPrintlnBold( "^5 250" ); 
   level.activ iPrintlnBold( "^5 250" ); 
   wait 0.3;
   player iPrintlnBold( "^6 300" ); 
   level.activ iPrintlnBold( "^6 300" ); 
   wait 0.3;
   player iPrintlnBold( "^7 350" ); 
   level.activ iPrintlnBold( "^7 350" ); 
   wait 0.3;
   player iPrintlnBold( "^8 400" ); 
   level.activ iPrintlnBold( "^8 400" ); 
   wait 0.3;
   player iPrintlnBold( "^1 50" ); 
   level.activ iPrintlnBold( "^1 50" ); 
   wait 0.3;
   player iPrintlnBold( "^2 100" ); 
   level.activ iPrintlnBold( "^2 100" ); 
   wait 0.3;
   player iPrintlnBold( "^3 150" ); 
   level.activ iPrintlnBold( "^3 150" ); 
   wait 0.3;
   player iPrintlnBold( "^4 200" );
   level.activ iPrintlnBold( "^4 200" ); 
   iPrintlnBold( "^9 Speed = ^4 200" ); 
   player SetMoveSpeedScale(1.5);
   level.activ SetMoveSpeedScale(1.5);
}

	if(random == 4)
{
   player iPrintlnBold( "^1 50" ); 
   level.activ iPrintlnBold( "^1 50" ); 
   wait 0.3;
   player iPrintlnBold( "^2 100" ); 
   level.activ iPrintlnBold( "^2 100" ); 
   wait 0.3;
   player iPrintlnBold( "^3 150" ); 
   level.activ iPrintlnBold( "^3 150" ); 
   wait 0.3;
   player iPrintlnBold( "^4 200" );
   level.activ iPrintlnBold( "^4 200" ); 
   wait 0.3;   
   player iPrintlnBold( "^5 250" ); 
   level.activ iPrintlnBold( "^5 250" ); 
   wait 0.3;
   player iPrintlnBold( "^6 300" ); 
   level.activ iPrintlnBold( "^6 300" ); 
   wait 0.3;
   player iPrintlnBold( "^7 350" ); 
   level.activ iPrintlnBold( "^7 350" ); 
   wait 0.3;
   player iPrintlnBold( "^8 400" ); 
   level.activ iPrintlnBold( "^8 400" );  
   wait 0.3;
   player iPrintlnBold( "^1 50" ); 
   level.activ iPrintlnBold( "^1 50" ); 
   wait 0.3;
   player iPrintlnBold( "^2 100" ); 
   level.activ iPrintlnBold( "^2 100" ); 
   wait 0.3;
   player iPrintlnBold( "^3 150" ); 
   level.activ iPrintlnBold( "^3 150" ); 
   wait 0.3;
   player iPrintlnBold( "^4 200" );
   level.activ iPrintlnBold( "^4 200" ); 
   wait 0.3;   
   player iPrintlnBold( "^5 250" ); 
   level.activ iPrintlnBold( "^5 250" ); 
   wait 0.3;
   player iPrintlnBold( "^6 300" ); 
   level.activ iPrintlnBold( "^6 300" ); 
   wait 0.3;
   player iPrintlnBold( "^7 350" ); 
   level.activ iPrintlnBold( "^7 350" ); 
   wait 0.3;
   player iPrintlnBold( "^8 400" ); 
   level.activ iPrintlnBold( "^8 400" ); 
   wait 0.3;
   player iPrintlnBold( "^1 50" ); 
   level.activ iPrintlnBold( "^1 50" ); 
   wait 0.3;
   player iPrintlnBold( "^2 100" ); 
   level.activ iPrintlnBold( "^2 100" ); 
   wait 0.3;
   player iPrintlnBold( "^3 150" ); 
   level.activ iPrintlnBold( "^3 150" ); 
   wait 0.3;
   player iPrintlnBold( "^4 200" );
   level.activ iPrintlnBold( "^4 200" ); 
   wait 0.3;   
   player iPrintlnBold( "^5 250" );
   level.activ iPrintlnBold( "^5 250" ); 
   iPrintlnBold( "^9 Speed = ^5 250" ); 
   player SetMoveSpeedScale(2);
   level.activ SetMoveSpeedScale(2);
}

	if(random == 5)
{
   player iPrintlnBold( "^1 50" ); 
   level.activ iPrintlnBold( "^1 50" ); 
   wait 0.3;
   player iPrintlnBold( "^2 100" ); 
   level.activ iPrintlnBold( "^2 100" ); 
   wait 0.3;
   player iPrintlnBold( "^3 150" ); 
   level.activ iPrintlnBold( "^3 150" ); 
   wait 0.3;
   player iPrintlnBold( "^4 200" );
   level.activ iPrintlnBold( "^4 200" ); 
   wait 0.3;   
   player iPrintlnBold( "^5 250" ); 
   level.activ iPrintlnBold( "^5 250" ); 
   wait 0.3;
   player iPrintlnBold( "^6 300" ); 
   level.activ iPrintlnBold( "^6 300" ); 
   wait 0.3;
   player iPrintlnBold( "^7 350" ); 
   level.activ iPrintlnBold( "^7 350" ); 
   wait 0.3;
   player iPrintlnBold( "^8 400" ); 
   level.activ iPrintlnBold( "^8 400" );  
   wait 0.3;
   player iPrintlnBold( "^1 50" ); 
   level.activ iPrintlnBold( "^1 50" ); 
   wait 0.3;
   player iPrintlnBold( "^2 100" ); 
   level.activ iPrintlnBold( "^2 100" ); 
   wait 0.3;
   player iPrintlnBold( "^3 150" ); 
   level.activ iPrintlnBold( "^3 150" ); 
   wait 0.3;
   player iPrintlnBold( "^4 200" );
   level.activ iPrintlnBold( "^4 200" ); 
   wait 0.3;   
   player iPrintlnBold( "^5 250" ); 
   level.activ iPrintlnBold( "^5 250" ); 
   wait 0.3;
   player iPrintlnBold( "^6 300" ); 
   level.activ iPrintlnBold( "^6 300" ); 
   wait 0.3;
   player iPrintlnBold( "^7 350" ); 
   level.activ iPrintlnBold( "^7 350" ); 
   wait 0.3;
   player iPrintlnBold( "^8 400" ); 
   level.activ iPrintlnBold( "^8 400" ); 
   wait 0.3;
   player iPrintlnBold( "^1 50" ); 
   level.activ iPrintlnBold( "^1 50" ); 
   wait 0.3;
   player iPrintlnBold( "^2 100" ); 
   level.activ iPrintlnBold( "^2 100" ); 
   wait 0.3;
   player iPrintlnBold( "^3 150" ); 
   level.activ iPrintlnBold( "^3 150" ); 
   wait 0.3;
   player iPrintlnBold( "^4 200" );
   level.activ iPrintlnBold( "^4 200" ); 
   wait 0.3;   
   player iPrintlnBold( "^5 250" );
   level.activ iPrintlnBold( "^5 250" ); 
   wait 0.3;
   player iPrintlnBold( "^6 300" );
   level.activ iPrintlnBold( "^6 300" ); 
   iPrintlnBold( "^9 Speed = ^6 300" ); 
   player SetMoveSpeedScale(2.5);
   level.activ SetMoveSpeedScale(2.5);
}

	if(random == 6)
{
   player iPrintlnBold( "^1 50" ); 
   level.activ iPrintlnBold( "^1 50" ); 
   wait 0.3;
   player iPrintlnBold( "^2 100" ); 
   level.activ iPrintlnBold( "^2 100" ); 
   wait 0.3;
   player iPrintlnBold( "^3 150" ); 
   level.activ iPrintlnBold( "^3 150" ); 
   wait 0.3;
   player iPrintlnBold( "^4 200" );
   level.activ iPrintlnBold( "^4 200" ); 
   wait 0.3;   
   player iPrintlnBold( "^5 250" ); 
   level.activ iPrintlnBold( "^5 250" ); 
   wait 0.3;
   player iPrintlnBold( "^6 300" ); 
   level.activ iPrintlnBold( "^6 300" ); 
   wait 0.3;
   player iPrintlnBold( "^7 350" ); 
   level.activ iPrintlnBold( "^7 350" ); 
   wait 0.3;
   player iPrintlnBold( "^8 400" ); 
   level.activ iPrintlnBold( "^8 400" );  
   wait 0.3;
   player iPrintlnBold( "^1 50" ); 
   level.activ iPrintlnBold( "^1 50" ); 
   wait 0.3;
   player iPrintlnBold( "^2 100" ); 
   level.activ iPrintlnBold( "^2 100" ); 
   wait 0.3;
   player iPrintlnBold( "^3 150" ); 
   level.activ iPrintlnBold( "^3 150" ); 
   wait 0.3;
   player iPrintlnBold( "^4 200" );
   level.activ iPrintlnBold( "^4 200" ); 
   wait 0.3;   
   player iPrintlnBold( "^5 250" ); 
   level.activ iPrintlnBold( "^5 250" ); 
   wait 0.3;
   player iPrintlnBold( "^6 300" ); 
   level.activ iPrintlnBold( "^6 300" ); 
   wait 0.3;
   player iPrintlnBold( "^7 350" ); 
   level.activ iPrintlnBold( "^7 350" ); 
   wait 0.3;
   player iPrintlnBold( "^8 400" ); 
   level.activ iPrintlnBold( "^8 400" ); 
   wait 0.3;
   player iPrintlnBold( "^1 50" ); 
   level.activ iPrintlnBold( "^1 50" ); 
   wait 0.3;
   player iPrintlnBold( "^2 100" ); 
   level.activ iPrintlnBold( "^2 100" ); 
   wait 0.3;
   player iPrintlnBold( "^3 150" ); 
   level.activ iPrintlnBold( "^3 150" ); 
   wait 0.3;
   player iPrintlnBold( "^4 200" );
   level.activ iPrintlnBold( "^4 200" ); 
   wait 0.3;   
   player iPrintlnBold( "^5 250" );
   level.activ iPrintlnBold( "^5 250" ); 
   wait 0.3;
   player iPrintlnBold( "^6 300" );
   level.activ iPrintlnBold( "^6 300" ); 
   wait 0.3;
   player iPrintlnBold( "^7 350" );
   level.activ iPrintlnBold( "^7 350" ); 
   iPrintlnBold( "^9 Speed = ^7 350" ); 
   player SetMoveSpeedScale(3);
   level.activ SetMoveSpeedScale(3);
}

	if(random == 7)
{
   player iPrintlnBold( "^1 50" ); 
   level.activ iPrintlnBold( "^1 50" ); 
   wait 0.3;
   player iPrintlnBold( "^2 100" ); 
   level.activ iPrintlnBold( "^2 100" ); 
   wait 0.3;
   player iPrintlnBold( "^3 150" ); 
   level.activ iPrintlnBold( "^3 150" ); 
   wait 0.3;
   player iPrintlnBold( "^4 200" );
   level.activ iPrintlnBold( "^4 200" ); 
   wait 0.3;   
   player iPrintlnBold( "^5 250" ); 
   level.activ iPrintlnBold( "^5 250" ); 
   wait 0.3;
   player iPrintlnBold( "^6 300" ); 
   level.activ iPrintlnBold( "^6 300" ); 
   wait 0.3;
   player iPrintlnBold( "^7 350" ); 
   level.activ iPrintlnBold( "^7 350" ); 
   wait 0.3;
   player iPrintlnBold( "^8 400" ); 
   level.activ iPrintlnBold( "^8 400" );  
   wait 0.3;
   player iPrintlnBold( "^1 50" ); 
   level.activ iPrintlnBold( "^1 50" ); 
   wait 0.3;
   player iPrintlnBold( "^2 100" ); 
   level.activ iPrintlnBold( "^2 100" ); 
   wait 0.3;
   player iPrintlnBold( "^3 150" ); 
   level.activ iPrintlnBold( "^3 150" ); 
   wait 0.3;
   player iPrintlnBold( "^4 200" );
   level.activ iPrintlnBold( "^4 200" ); 
   wait 0.3;   
   player iPrintlnBold( "^5 250" ); 
   level.activ iPrintlnBold( "^5 250" ); 
   wait 0.3;
   player iPrintlnBold( "^6 300" ); 
   level.activ iPrintlnBold( "^6 300" ); 
   wait 0.3;
   player iPrintlnBold( "^7 350" ); 
   level.activ iPrintlnBold( "^7 350" ); 
   wait 0.3;
   player iPrintlnBold( "^8 400" ); 
   level.activ iPrintlnBold( "^8 400" ); 
   wait 0.3;
   player iPrintlnBold( "^1 50" ); 
   level.activ iPrintlnBold( "^1 50" ); 
   wait 0.3;
   player iPrintlnBold( "^2 100" ); 
   level.activ iPrintlnBold( "^2 100" ); 
   wait 0.3;
   player iPrintlnBold( "^3 150" ); 
   level.activ iPrintlnBold( "^3 150" ); 
   wait 0.3;
   player iPrintlnBold( "^4 200" );
   level.activ iPrintlnBold( "^4 200" ); 
   wait 0.3;   
   player iPrintlnBold( "^5 250" );
   level.activ iPrintlnBold( "^5 250" ); 
   wait 0.3;
   player iPrintlnBold( "^6 300" );
   level.activ iPrintlnBold( "^6 300" ); 
   wait 0.3;
   player iPrintlnBold( "^7 350" );
   level.activ iPrintlnBold( "^7 350" ); 
   wait 0.3;
   player iPrintlnBold( "^8 400" );
   level.activ iPrintlnBold( "^8 400" );  
   iPrintlnBold( "^9 Speed = ^8 400" ); 
   player SetMoveSpeedScale(3.5);
   level.activ SetMoveSpeedScale(3.5);
}

break;
   }
   player thread ammo();
   level.activ thread ammo();
   player freezeControls(0);
   level.activ freezeControls(0);
   player waittill( "death" );
   level.PlayerInRoom = false;
   }

}

weapons() // Script de la map semtex
{
   level.weapons_trigger = getent("weapon","targetname");
   level.weapons_trigger setHintString("Weapon");
   while(1)
   {
      level.weapons_trigger waittill( "trigger", player );
      if( !isDefined( level.weapons_trigger ) )
      return;
      if(level.firstenter==true)
	     {
   level.old_trigger delete();
   level.jump_trigger delete();
   level.knife_trigger delete();
   level.run_trigger delete();
   level.randomspeed_trigger delete();
   level.sniper_trigger delete();
   level.race delete();
   level.firstenter=false;
   } 
	iPrintlnBold(player.name + " ^1Selected Weapons Way^7!!");
	player freezeControls(1);
    player SetOrigin((-11736, -13864, 776));
    player SetPlayerAngles((0,90,0));
	level.activ freezeControls(1);
    level.activ SetOrigin((-11720, -12328, 776));
    level.activ SetPlayerAngles((0,270,0));
	player takeallweapons();
	level.activ takeallweapons();
	wait 5;
	IPrintLnbold("^2Fight!");
	i = randomintrange(1, 5);
	weapon = "rpg_mp";
	if(i == 1)
	{
		weapon = "rpg_mp";  
	}
	else if(i == 2)
	{
		weapon = "winchester1200_mp"; 
	}
	else if(i == 3)
	{
		weapon = "g3_mp"; 
	}
	else if(i == 4)
	{
		weapon = "ak47_mp"; 
	}
	else if(i == 5)
	{
		weapon = "rpd_mp"; 
	}
	player giveweapon(weapon);
	level.activ giveweapon(weapon);
	level.activ givemaxammo(weapon);
	player givemaxammo(weapon);
	wait .1;
	player switchtoweapon(weapon);
	level.activ switchtoweapon(weapon);
	player thread ammo();
	level.activ thread ammo();
	player freezeControls(0);
	level.activ freezeControls(0);
    player waittill( "death" );
    level.PlayerInRoom = false;
	}
}

ammo()
{
self endon("round_ended");
self endon("death");
self endon("disconected");
wait 1;
for(;;)
{
	weapon = self GetCurrentWeapon();
	ammo = self GetWeaponAmmoStock(weapon);
	if(weapon == "none")
	{
		wait 1;
	}
	if(weapon == "knife_mp")
	{
		wait 1;
	}
	else if(1 >= ammo)
	{
		self IPrintLnbold("^2Max Ammo!");
		self givemaxammo(weapon);
		}
	wait .1;
	}
}

//music

musictrig() //dsl lolz je te l'ai volé mais je ne savais vraiment pas comment faire !
{
    trig = getEnt("musicmenu", "targetname");
	trig setHintString("Press [^5&&1^7] to choose Music");
    trig waittill("trigger", player);
	thread secretxpjumper();
    player openMenu("presentation");
 
    for(;;)
    {
        player waittill("menuresponse", menu, response);

        if(menu == "presentation")
        {
            if(!isDefined(self.musicon))
            {
                self loops(response);
            }
            else if(self.musicon == 1 && response != self.currentmusic) 
            {
                self loops(response);
            }
         }
       
		trig delete();
		break;
    }

}

loops(response)
{	

    switch(response)
    {
        case "music1":
        ambientplay("music1");
		wait 247;
		thread partymusic();
            break;
        case "music2":
        ambientplay("music2");
		wait 235;
		thread partymusic();
            break;
        case "music3":
        ambientplay("music3");
		wait 280;
		thread partymusic();
            break;
        case "music4":
        ambientplay("music4");
		wait 250;
		thread partymusic();
            break;
        case "music5":
        ambientplay("music5");
		wait 192;
		thread partymusic();
            break;
    }
   
}
 
partymusic()
{
x = randomint(5);
if(x == 1)
{
ambientplay("music1");
}
if(x == 2)
{
ambientplay("music2");
}
if(x == 3)
{
ambientplay("music3");
}
if(x == 4)
{
ambientplay("music4");
}
if(x == 5)
{
ambientplay("music5");
}
}

// END \\