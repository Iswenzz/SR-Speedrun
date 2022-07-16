main() 
{ 
	//maps\mp\mp_pizzahut_v2_fx::main();
	//maps\createart\mp_pizzahut_art::main();
	maps\mp\_load::main();	
	
	//maps\mp\_compass::setupMiniMap("compass_map_mp_pizzahut_v2");

	//setExpFog(500, 2200, 0.81, 0.75, 0.63, 0);
	//VisionSetNaked( "mp_pizzahut" );
	//ambientPlay("ambient_backlot_ext");
	precacheItem("rpg_mp");
	
	
	///////SR Stuff`
	thread speedrun\_way_name::create_normal_way("Normal Way;Easy Way;Inter Way;Hard Way");
	thread speedrun\_way_name::create_spawn((26754,2631,2572),360);
	thread speedrun\_way_name::create_tp((26755, 3004, 2572), 60, 80, (26960, -10564, 2330), 359, "freeze", "blue", "ns1");
	thread speedrun\_way_name::create_tp((26663, 2277, 2572), 60, 80, (19795, -1983, -3062), 268, "freeze", "blue", "ns2");
	thread speedrun\_way_name::create_tp((9173, -1170, -6659), 60, 80, (11931, -632, -6797), 359, "freeze", "blue", "ns2");
	thread speedrun\_way_name::create_tp((26846, 2280, 2572), 60, 80, (22301, 4646, -1002), 270, "freeze", "red", "ns3");
	thread speedrun\_way_name::create_endmap((27652.6, -9902.94, -18123.9),70,5, "ns2");
	thread speedrun\_way_name::create_endmap((21086.4, -968.617, -5030.38),115, 5,"ns1");
	thread speedrun\_way_name::create_endmap((20607.9, -6476.54, -3141.88),55, 5,"ns3");
	thread speedrun\_way_name::create_endmap((1569.05, -990.628, -17071.4),655, 5, "ns0");
	
	

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	
	if( getDvarInt( "jump_slowdownEnable" ) > 0 ) 
		setDvar( "jump_slowdownEnable", 0 ); 

	if( getDvarInt( "bg_falldamagemaxheight" ) < 9999 ) 
		setdvar("bg_falldamagemaxheight", 9999);
	
	if( getDvarInt( "bg_fallDamageMinHeight") < 9998 )
		setDvar( "bg_fallDamageMinHeight", "9998" ); 
	
	setdvar( "r_specularcolorscale", "1" );

	setdvar( "r_glowbloomintensity0", ".25" );
	setdvar( "r_glowbloomintensity1", ".25" );
	setdvar( "r_glowskybleedintensity0", ".3" );

	entTransporter = getentarray( "coolteleporter", "targetname" ); 
	if( isdefined( entTransporter ) ) 
	{ 
		for( lp = 0; lp < entTransporter.size; lp = lp + 1 ) 
			entTransporter[lp] thread Transporter(); 
	}
	thread onPlayerConnect();
//	thread MadeBySpam();
//	thread BoemYouAreDead();
//	thread Credits1();
//	thread Credits2();
//	thread Credits3();
//	thread Credits4();
//	thread Text1();
//	thread FinishEasy();
//	thread FinishInter();
	// thread FinishHard();
	thread rpg();
	
}

transporter() 
{ 
	while( true ) 
	{ 
		self waittill( "trigger", other );
		entTarget = getent( self.target, "targetname" ); 
		other setorigin( entTarget.origin ); 
		other setplayerangles( entTarget.angles );
		
	} 
}

rpg()
{
  
   trigger = spawn( "trigger_radius", (24899.8, -1749.86, -3608.88), 0, 155, 5 );
   
   while( true )
   {
    trigger waittill("trigger", other);
    other  giveWeapon("rpg_mp");
    other giveMaxAmmo("rpg_mp");
    other switchToWeapon("rpg_mp");
   }
}





onPlayerConnect()
{
    while( 1 )
    {
		level waittill( "connecting", player ); //needs to be 'connecting' not 'connected'
		
		player.easyfinish = 0;
		player.interfinish = 0;
		player.hardfinish = 0;
		player.kill = 0;
		player.textcredits1 = 0;
		player.textcredits2 = 0;
		player.textcredits3 = 0;
		player.textcredits4 = 0;
    }
}

MadeBySpam()
{
	while( 1 )
	{
		wait 180;
		iPrintLn( "This map is created by: ^1Styx|Dutchnoob" );
	}
}

BoemYouAreDead()
{
	trig = getEntArray( "kill", "targetname" );
	
	for( i = 0; i < trig.size; i++ )
	{
		trig[i] thread BoemYouAreDeadV2();
	}
}

BoemYouAreDeadV2()
{
	for( ;; )
	{
		self waittill( "trigger", player );
		player suicide();
	}
}

//Creditsroom:
Credits1()
{
	trig = getEntArray( "textcredits1", "targetname" );
	if( isDefined( trig ) )
		for( i = 0; i < trig.size; i++ )
			trig[i] thread Credits1_2();
}
	
Credits1_2()
{
	while( 1 )
	{
		self waittill( "trigger", player );
		if( player.textcredits1 == 0 )
		{
			player iPrintLnBold( "^1BIG ^7thanks for testing ^3Easy:" );	
			wait 2;
			player iPrintLnBold( "^3Blueseven, Bynd, Eiachh, BurntToast" );	
			player.textcredits1 = 1;
		}
	}
}

Credits2()
{
	trig = getEntArray( "textcredits2", "targetname" );
	if( isDefined( trig ) )
		for( i = 0; i < trig.size; i++ )
			trig[i] thread Credits2_2();
}
	
Credits2_2()
{
	while( 1 )
	{
		self waittill( "trigger", player );
		if( player.textcredits2 == 0 )
		{
			player iPrintLnBold( "^1BIG ^7thanks for testing ^2Inter:" );	
			wait 2;
			player iPrintLnBold( "^2n1kjs, Bynd, Frisbeesky, Killer007, Zombie, Blueseven, Saint, Deej,d*.*b" );	
			player.textcredits2 = 1;
		}
	}
}

Credits3()
{
	trig = getEntArray( "textcredits3", "targetname" );
	if( isDefined( trig ) )
		for( i = 0; i < trig.size; i++ )
			trig[i] thread Credits3_2();
}
	
Credits3_2()
{
	while( 1 )
	{
		self waittill( "trigger", player );
		if( player.textcredits3 == 0 )
		{
			player iPrintLnBold( "^1BIG ^7thanks for testing ^1Hard:" );	
			wait 2;
			player iPrintLnBold( "^1Skorpiik, Zombie, Skazy, Seven, Siv, Candy, Meister, Saint, Axle" );	
			player.textcredits3 = 1;
		}
	}
}

Credits4()
{
	trig = getEntArray( "textcredits4", "targetname" );
	if( isDefined( trig ) )
		for( i = 0; i < trig.size; i++ )
			trig[i] thread Credits4_2();
}
	
Credits4_2()
{
	while( 1 )
	{
		self waittill( "trigger", player );
		if( player.textcredits4 == 0 )
		{
			player iPrintLnBold( "^1BIG ^7thanks for all the support!" );		
			player.textcredits4 = 1;
		}
	}
}

//Textscripts:
Text1()
{
	level waittill( "connected", player );
	wait 20;	//tijd voordat de player de message krijgt als die joint.
	player iPrintLnBold ( "This map is created by: ^1Dutchnoob" );
	wait 2;		// tijd tussen de teksten
	player iPrintLnBold ( "Thanks to ^all the testers^7 for helping me with mapping & changing the map for the communitty" );
	wait 2;		// tijd tussen de teksten
	player iPrintLnBold ( "Special thanks to ^1n1kjs, Seven, Zombie, Skorpiik, Killer007, Noobaim ^7who helped me with testing" );
	wait 2;		// tijd tussen de teksten
	player iPrintLnBold ( "This is my second map, and I would love feedback from U guys. My xfire: Dutchnoobgamer" );
}


//Finish scripts:
FinishEasy()
{
	trig = getEnt( "easyfinish", "targetname" );		//Radiant trigger naam: Key = targetname Value = easy
	
	while( 1 )
	{
		trig waittill( "trigger", player );
		if( player.easyfinish == 0 )
		{
			iPrintLnBold( "Congrats "  + player.name +  " you've finished ^3Easy Way!" );		//Tekst hier plaatsen, kleuren kan("^1Example")
		//	player iPrintLnBold("tekst hier");	Player ervoor is message aan de player only
			player.easyfinish = 1;
		}
	}
}

FinishInter()
{
	trig = getEnt( "interfinish", "targetname" );		//Radiant trigger naam: Key = targetname Value = inter
	
	while( 1 )
	{
		trig waittill( "trigger", player );
		if( player.interfinish == 0 )
		{
			iPrintLnBold( "Congrats "  + player.name +  " you've finished ^2Inter Way!" );			//Tekst hier plaatsen, kleuren kan("^1Example")
		//	player iPrintLnBold("tekst hier");	Player ervoor is message aan de player only
			player.interfinish = 1;
		}
	}
}

FinishHard()
{
	trig = getEnt( "hardfinish", "targetname" );		//Radiant trigger naam: Key = targetname Value = hard
	
	while( 1 )
	{
		trig waittill( "trigger", player );
		if( player.hardfinish == 0 )
		{
			iPrintLnBold( "Congrats "  + player.name +  " you've finished ^1Hard Way!" );			//Tekst hier plaatsen, kleuren kan("^1Example")
		//	iPrintLnBold("Congrats" + player.name + "You've finsihed blabla");	Player ervoor is message aan de player only			
			player.hardfinish = 1;
		}
	}
}

