/*
        	  _____                   _______                   _____                   _______         
	         /\    \                 /::\    \                 /\    \                 /::\    \        
	        /::\    \               /::::\    \               /::\    \               /::::\    \       
 	       /::::\    \             /::::::\    \             /::::\    \             /::::::\    \      
 	      /::::::\    \           /::::::::\    \           /::::::\    \           /::::::::\    \     
	     /:::/\:::\    \         /:::/~~\:::\    \         /:::/\:::\    \         /:::/~~\:::\    \    
	    /:::/  \:::\    \       /:::/    \:::\    \       /:::/__\:::\    \       /:::/    \:::\    \   
	   /:::/    \:::\    \     /:::/    / \:::\    \     /::::\   \:::\    \     /:::/    / \:::\    \  
	  /:::/    / \:::\    \   /:::/____/   \:::\____\   /::::::\   \:::\    \   /:::/____/   \:::\____\ 
	 /:::/    /   \:::\ ___\ |:::|    |     |:::|    | /:::/\:::\   \:::\____\ |:::|    |     |:::|    |
	/:::/____/     \:::|    ||:::|____|     |:::|    |/:::/  \:::\   \:::|    ||:::|____|     |:::|    |
	\:::\    \ /\  /:::|____| \:::\    \   /:::/    / \::/   |::::\  /:::|____| \:::\    \   /:::/    / 
	 \:::\    /::\ \::/    /   \:::\    \ /:::/    /   \/____|:::::\/:::/    /   \:::\    \ /:::/    /  
 	  \:::\   \:::\ \/____/     \:::\    /:::/    /          |:::::::::/    /     \:::\    /:::/    /   
	   \:::\   \:::\____\        \:::\__/:::/    /           |::|\::::/    /       \:::\__/:::/    /    
	    \:::\  /:::/    /         \::::::::/    /            |::| \::/____/         \::::::::/    /     
 	     \:::\/:::/    /           \::::::/    /             |::|  ~|                \::::::/    /      
 	      \::::::/    /             \::::/    /              |::|   |                 \::::/    /       
 	       \::::/    /               \::/____/               \::|   |                  \::/____/        
	        \::/____/                 ~~                      \:|   |                   ~~              
                                                   	           \|___|                                   
*/

main()
{
	maps\mp\_load::main(); 

    game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";
 
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("r_filmTweakEnable", "1");
	setdvar("r_specularcolorscale", "1" );
	setdvar("r_drawDecals", "1");
	setdvar("fx_enable", "0");
	setdvar("r_filmEnable" ,"1");
	setdvar("r_fullbright" ,"1");


	// setdvar("g_speed" ,"190");
	// setdvar("dr_jumpers_speed" ,"1");

	precacheModel( "sonic" );
	precacheItem("winchester1200_mp");
	precacheItem("m4_mp");
	precacheItem("remington700_mp");
	precacheItem("m40a3_mp");
	precacheItem("m4_mp");
	precacheItem("ak47_mp");
	precacheItem("ak74u_mp");
	precacheItem("deserteagle_mp");
	precacheItem("knife_mp");
	precacheItem("m1014_mp");
	
	//////////////threads////////////////
	thread way_connect();
	thread onConnect();
	thread tp();
	thread drink2();
	thread gate();
	// thread trap1();
	// thread trap2();
	// thread trap3();
	// thread trap4();
	// thread trap5();
	// thread trap6();
	// thread trap7();
	// thread trap8();
	// thread trap9();
	// thread trap10();
	// thread trap12();
	// thread trap13();
	// thread trap14();
	// thread credits();
	thread startsteps();
	//thread rpg();
	thread inizio();
	// thread WatchSniper();
	// thread Watchknife();
	// thread Watchaku();
	// thread Watchak();
	// thread Watchbounce();
	// thread pompa();
	// thread mapby();
	thread secretroom();
	// thread music();
	// thread bounce_teleport();
	thread findme();


	// addTriggerToList( "trap1_trig" );
	// addTriggerToList( "trap2_trig" );
	// addTriggerToList( "trap3_trig" );
	// addTriggerToList( "trap4_trig" );
	// addTriggerToList( "trap5_trig" );
	// addTriggerToList( "trap6_trig" );
	// addTriggerToList( "trap7_trig" );
	// addTriggerToList( "trap8_trig" );
	// addTriggerToList( "trap9_trig" );
	// addTriggerToList( "trap10_trig" );
	// addTriggerToList( "trap12_trig" );
	// addTriggerToList( "trap13_trig" );
	// addTriggerToList( "trap14_trig" );

//////////////////////////////////////////////////////////////////////////////////


	level.knockback = getDvarInt("g_knockback");
	bounce   = getEntArray("bounce", "targetname");
	
	for(i = 0;i < bounce.size;i++) 	
	
	bounce[i] thread bounce();

}

tp()
{
	entTransporter = getentarray( "enter", "targetname" );
 
	level waittill("round_started");
 
	if(isdefined(entTransporter))
	{
		for( i = 0; i < entTransporter.size; i++ )
		{
			entTransporter[i] thread transporter(i);
		}
	}
}

transporter(i)
{	
	while(true)
	{
		self waittill( "trigger", player );
		
		if(!isDefined(player.secret_1_endtrig) && self.target == "auto19")
		{
			player.secret_1_endtrig = true;
			
player thread sr\api\_speedrun::finishWay("secret_0");
		}
		if(!isDefined(player.secret_1) && self.target == "auto29")
		{
			player sr\api\_speedrun::changeWay("secret_0"); //Speedrun Copy Paste
			player.secret_1 = true;
			entTarget = getEnt( self.target, "targetname" );
			player setOrigin( entTarget.origin );
			player setplayerangles( entTarget.angles );
		}
		else
		{
			entTarget = getEnt( self.target, "targetname" );
			player setOrigin( entTarget.origin );
			player setplayerangles( entTarget.angles );
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    sr\api\_speedrun::createNormalWays("Normal Way;");
	sr\api\_speedrun::createSecretWays("Secret Way;");
	
    for(;;)
    {
        level waittill( "connected", player );

    }
}
////////////////////////////////////////////////////////////////////////////////////////////////
	

addTriggerToList( name )
{
	if( !isDefined( level.trapTriggers ) )
		level.trapTriggers = [];
	level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );

}
//////////////////////////////////////////////////////////////////////////////////


mapby()

{
	wait 45;
	iprintlnbold("^6>> ^7Map by <3 bre^2.^7");
}


//////////////////////////////////////////////////////////////////////////////////


inizio()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread inizio2();
    }
}

inizio2()
{
    for(;;)
    {
        self waittill("spawned_player");
        self thread playerSpawn();
    }
}

playerSpawn()
{
    self endon("disconnect");
    self endon("killed_player");
    self endon("joined_spectators");
    while (1)
    {
        self setClientDvar("r_fullbright", "1"); 
        self setClientDvar("fx_enable", "0");    
        wait 1;
    }
}


//////////////////////////////////////////////////////////////////////////////////


bounce()
{
	for(;;)
	{
	self waittill("trigger", p);
	
	if(!isDefined(p.bouncing))
	p thread player_bounce(self);
	}
}

player_bounce(trigger)
{
	self.bouncing = true;
	vel = self getVelocity();
	temp0 = (((vel[0] < 350 && vel[0] > 0) || (vel[0] > -350 && vel[0] < 0)));
	temp1 = (((vel[1] < 350 && vel[1] > 0) || (vel[1] > -350 && vel[1] < 0)));

	if((!temp0 && !temp1) || vel[2] > -350)
	{
		wait 1;
		self.bouncing = undefined;
		return;
	}

	health    = self.health;
	maxHealth = self.maxHealth;
	self.health    = 1000000;
	self.maxhealth = 1000000;
	setDvar("g_knockback", (vel[2]*-9)-500);
	self finishPlayerDamage(self, self, 1000, 0, "MOD_UNKNOWN", "bounce", self.origin, (0,0,1) , "none", 0);
	wait 0.05;
	setDvar("g_knockback", level.knockback);
	self.health    = health;
	self.maxhealth = maxHealth;
	while(self isTouching(trigger))
	wait 0.05;
	self.bouncing = undefined;
}


//////////////////////////////////////////////////////////////////////////////////


onConnect()
{
	for(;;)
	{
		level waittill( "connected", player );
		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	for(;;)
	{
		self waittill("spawned_player");
		self.secret_1 = undefined;
		self.secret_1_endtrig = undefined;
	}
}

//////////////////////////////////////////////////////////////////////////////////


drink2()
{
	drink = getent ("drink","targetname");

	while(1)
	{
		drink waittill ("trigger",suca);
		suca iprintlnbold ("Oh you have chosen a coke!");
		wait 2;	
		suca iprintlnbold ("One moment please!");
		wait 2;
		suca iprintlnbold ("Here you are");
		wait 4;
		suca iprintlnbold ("LOL did you really think i give you a drink for free?");
		wait 5;
		suca iprintlnbold ("Now you will die!");
		wait 4;
		suca suicide();
	}
}


//////////////////////////////////////////////////////////////////////////////////


gate()
{

	cancello = getent("gate","targetname");
	cancello delete();
}


//////////////////////////////////////////////////////////////////////////////////


trap1()
{

    trap = getent( "trap1", "targetname" ); 
    trigger = getent( "trap1_trig", "targetname" ); 

	while(1) 
	{ 
		trigger waittill ("trigger",player);
		trigger delete();
        trap moveZ(240, 0.5, 0.1, 0.1); 
        trap waittill("movedone");
        wait 2;
        trap moveZ(-240, 2, 0.3, 0.3); 
        trap waittill("movedone");  
    }
}


//////////////////////////////////////////////////////////////////////////////////


trap2()
{

    trap = getent( "trap2", "targetname" ); 
    trigger = getent( "trap2_trig", "targetname" ); 

	while(1) 
	{ 
		trigger waittill ("trigger",player);
		trigger delete();
		trap moveY(240, 1.5, 0.3, 0.3); 
		trap waittill("movedone");
		wait 2;
		trap moveY(-240, 2, 0.3, 0.3); 
		trap waittill("movedone");
    }
}


//////////////////////////////////////////////////////////////////////////////////


trap3()
{

	trap = getent("trap3","targetname");
	trigger = getent("trap3_trig","targetname");

	while(1)
	{
		trigger waittill ("trigger");
		trigger delete();
		for(;;)
		{
			trap moveZ(-100, 1, 0.2, 0.2); 
			trap waittill("movedone");
			trap moveZ(100, 1, 0.2, 0.2); 
			trap waittill("movedone");
		}
	}
} 


//////////////////////////////////////////////////////////////////////////////////


trap4()
{

	trap = getent("trap4_sx","targetname");
	trap2 = getent("trap4_dx","targetname");
	trap3 = getent("trap4_sx2","targetname");
	trap4 = getent("trap4_sx3","targetname");
	trap5 = getent("trap4_dx2","targetname");
	trigger = getent("trap4_trig","targetname");
	trigger2 = getent("trap4_sx_trig","targetname");
	trigger3 = getent("trap4_dx_trig","targetname");
	trigger4 = getent("trap4_sx_trig2","targetname");
	trigger5 = getent("trap4_sx_trig3","targetname");
	trigger6 = getent("trap4_dx_trig2","targetname");

	
    trigger2 enableLinkTo();
    trigger2 linkTo(trap);
    trigger3 enableLinkTo();
    trigger3 linkTo(trap2);
    trigger4 enableLinkTo();
    trigger4 linkTo(trap3);
    trigger5 enableLinkTo();
    trigger5 linkTo(trap4);
    trigger6 enableLinkTo();
    trigger6 linkTo(trap5);
    trap hide();
    trap2 hide();
    trap3 hide();
    trap4 hide();
    trap5 hide();
    trap notsolid();
    trap2 notsolid();
    trap3 notsolid();
    trap4 notsolid();
    trap5 notsolid();

	while(1)
	{
		trigger waittill ("trigger");
		trigger delete();
		trap show();
		trap2 show();
		trap3 show();
		trap4 show();
		trap5 show();
		for(;;)
		{
			trap moveX(709, 1); 
			trap2 moveX(-709, 1);
			trap3 moveX(709, 1); 
			trap4 moveX(709, 1);
			trap5 moveX(-709, 1);
			trap waittill("movedone");
			trap moveX(-709, 1); 
			trap2 moveX(709, 1);
			trap3 moveX(-709, 1); 
			trap4 moveX(-709, 1);
			trap5 moveX(709, 1);
			trap waittill("movedone");
        }
    }
} 


//////////////////////////////////////////////////////////////////////////////////


trap5()
{
    trap = getent( "trap5", "targetname" ); 
    trigger = getent( "trap5_trig", "targetname" ); 
    trig = getent( "trap5_trig_hurt", "targetname" ); 
    trig enableLinkTo();
    trig linkTo(trap);

	while(1) 
	{ 
		trigger waittill ("trigger",player);
		trigger delete();
		trap moveZ(370, 5.5, 0.3, 0.3); 
        trap waittill("movedone");
        wait 1;
        trap moveZ(-370, 3, 0.3, 0.3); 
        trap waittill("movedone");
    }
}


//////////////////////////////////////////////////////////////////////////////////


trap6()
{
    trap = getent( "trap6", "targetname" ); 
    trigger = getent( "trap6_trig", "targetname" ); 
 
	while(1) 
	{ 
		trigger waittill ("trigger",player);
		trigger delete();
		trap moveY(-300, .75, 0.3, 0.3); 
		trap waittill("movedone");
		wait 1.5;
        trap moveY(300, 1.5, 0.3, 0.3); 
		trap waittill("movedone");
    }
}


//////////////////////////////////////////////////////////////////////////////////


trap7()
{
	pilastro308 = getent( "pilastro308", "targetname" ); 
	pilastro388 = getent( "pilastro388", "targetname" );
	pilastro356 = getent( "pilastro356", "targetname" );
	pilastro324 = getent( "pilastro324", "targetname" );
	pilastro292 = getent( "pilastro292", "targetname" );
	pilastro308_2 = getent( "pilastro308_2", "targetname" );
	pilastro308_3 = getent( "pilastro308_3", "targetname" );
	pilastro372 = getent( "pilastro372", "targetname" );
	pilastro340 = getent( "pilastro340", "targetname" );
	pilastro260 = getent( "pilastro260", "targetname" );
	pilastro260_2 = getent( "pilastro260_2", "targetname" );
	pilastro228 = getent( "pilastro228", "targetname" );
	pilastro224 = getent( "pilastro224", "targetname" );
	pilastro196 = getent( "pilastro196", "targetname" );
    trigger = getent( "trap7_trig", "targetname" ); 

	while(1) 
	{ 
		trigger waittill ("trigger",player);
		trigger delete();
		pilastro308 moveZ(308, 2, 0.3, 0.3);  
		pilastro388 moveZ(388, 2, 0.3, 0.3); 
		pilastro356 moveZ(356, 2, 0.3, 0.3); 
		pilastro324 moveZ(324, 2, 0.3, 0.3); 
		pilastro292 moveZ(292, 2, 0.3, 0.3); 
		pilastro308_2 moveZ(308, 2, 0.3, 0.3); 
		pilastro308_3 moveZ(308, 2, 0.3, 0.3); 
		pilastro372 moveZ(372, 2, 0.3, 0.3); 
		pilastro340 moveZ(340, 2, 0.3, 0.3); 
		pilastro260 moveZ(260, 2, 0.3, 0.3); 
		pilastro260_2 moveZ(260, 2, 0.3, 0.3); 
		pilastro228 moveZ(228, 2, 0.3, 0.3); 
		pilastro224 moveZ(224, 2, 0.3, 0.3); 
		pilastro196 moveZ(196, 2, 0.3, 0.3); 
		pilastro308 waittill("movedone");
		wait 2;
		pilastro308 moveZ(-308, 2, 0.3, 0.3);  
		pilastro388 moveZ(-388, 2, 0.3, 0.3); 
		pilastro356 moveZ(-356, 2, 0.3, 0.3); 
		pilastro324 moveZ(-324, 2, 0.3, 0.3); 
		pilastro292 moveZ(-292, 2, 0.3, 0.3); 
		pilastro308_2 moveZ(-308, 2, 0.3, 0.3); 
		pilastro308_3 moveZ(-308, 2, 0.3, 0.3); 
		pilastro372 moveZ(-372, 2, 0.3, 0.3); 
		pilastro340 moveZ(-340, 2, 0.3, 0.3); 
		pilastro260 moveZ(-260, 2, 0.3, 0.3); 
		pilastro260_2 moveZ(-260, 2, 0.3, 0.3); 
		pilastro228 moveZ(-228, 2, 0.3, 0.3); 
		pilastro224 moveZ(-224, 2, 0.3, 0.3); 
		pilastro196 moveZ(-196, 2, 0.3, 0.3);  
		pilastro308 waittill("movedone");  
    }
}


//////////////////////////////////////////////////////////////////////////////////


trap8()
{
    porta_sx = getent( "porta_sx", "targetname" ); 
    porta_dx = getent( "porta_dx", "targetname" ); 
    trigger = getent( "trap8_trig", "targetname" ); 
 
	while(1) 
	{ 
		trigger waittill ("trigger",player);
		trigger delete();
		porta_sx moveX(144, 1, 0.3, 0.3);
		porta_dx moveX(-144, 1, 0.3, 0.3);
        porta_sx waittill("movedone");
        wait 2;
        porta_sx moveX(-144, 1, 0.3, 0.3); 
		porta_dx moveX(144, 1, 0.3, 0.3);
        porta_sx waittill("movedone");
    }
}


//////////////////////////////////////////////////////////////////////////////////


trap9()
{
    trap = getent( "trap9", "targetname" ); 
	trigger = getent( "trap9_trig", "targetname" ); 
 
	while(1) 
	{ 
		trigger waittill ("trigger",player);
		trigger delete();
		trap hide(); 
		trap notsolid();
		wait 10;
		trap show();
		trap solid();        
    }
}


//////////////////////////////////////////////////////////////////////////////////


trap10()
{
    sx = getent( "trap10_sx", "targetname" ); 
    dx = getent( "trap10_dx", "targetname" ); 
    trigger = getent( "trap10_trig", "targetname" ); 
    cicciaalculo = getent( "cicciaalculo", "targetname" );  
 
	while(1) 
	{ 
		trigger waittill ("trigger",player);
		trigger delete();
		sx moveY(-88, 5);
		dx moveY(88, 5);  
		sx waittill("movedone");
        thread killer("cicciaalculo");
		sx moveY(-16, 5);
		dx moveY(16, 5); 
		sx waittill("movedone");
		cicciaalculo delete();
		sx moveY(104,5);
		dx moveY(-104,5);  
    }
}


//////////////////////////////////////////////////////////////////////////////////


trap12()
{
    trap1 = getent( "trap12_sx", "targetname" );
    trap2 = getent( "trap12_dx", "targetname" );  
    trigger = getent( "trap12_trig", "targetname" ); 
 
	while(1) 
	{ 
		trigger waittill ("trigger",player);
		trigger delete();
		trap1 moveY(-100, 0.5, 0.2, 0.2); 
		trap2 moveY(100, 0.5, 0.2, 0.2);
		trap1 waittill("movedone");
		wait 1.5;
		trap1 moveY(100, 0.5, 0.2, 0.2); 
		trap2 moveY(-100, 0.5, 0.2, 0.2); 
		trap1 waittill("movedone");
    }
}


//////////////////////////////////////////////////////////////////////////////////


trap13()
{
    trapsx = getent( "trap13_sx", "targetname" ); 
    trapdx = getent( "trap13_dx", "targetname" );
    trigger = getent( "trap13_trig", "targetname" ); 

	while(1) 
	{ 
		trigger waittill ("trigger",player);
		trigger delete();
		for(;;)
		{
			trapdx movex(-168, 0.5,0,0); 
			trapsx movex(168, 0.5,0,0); 
			trapdx waittill("movedone");
			trapdx movex(168, 0.5,0,0); 
			trapsx movex(-168, 0.5,0,0); 
			trapdx waittill("movedone");
        }
    }
}


//////////////////////////////////////////////////////////////////////////////////


trap14()
{
    trap = getent( "trap14", "targetname" );     
    trigger = getent( "trap14_trig", "targetname" ); 

	while(1) 
	{ 
		trigger waittill ("trigger",player);
		trigger delete();
		trap movey(676, 2.5,0,0); 
		trap waittill("movedone"); 
		trap movey(-676, 2.5,0,0); 
		trap waittill("movedone");
    }
}


//////////////////////////////////////////////////////////////////////////////////


credits()
{
	if( isDefined( self.logoText ) )
		self.logoText destroy();

	self.logoText = newHudElem();
	self.logoText.y = 10;
	self.logoText.alignX = "center";
	self.logoText.alignY = "middle";
	self.logoText.horzAlign = "center_safearea";

	self.logoText.alpha = 0;
	self.logoText.sort = -3;
	self.logoText.fontScale = 1.6;
	self.logoText.archieved = true;

	for(;;)
	{
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("Map made by bre^2.^7");
		wait 5;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("Scripted by Goro");
		wait 5;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("Special thanks to T3rroR");
		wait 5;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
		
	}
}


////////////////////////RETARD STUFF////////////////


startsteps()
{
	steps = getEntArray("step", "targetname");
	for (i = 0; i < steps.size; i++)
	{
		steps[i] thread step();
		wait .25;
	}
}   


//////////////////////////////////////////////////////////////////////////////////


step()
{
	while(1)
	{
		self moveTo((4000-16, -986, 294), .25);
		wait .25;
		self moveTo((4000-32-16, -986, 294+8), .5);
		wait .5;
		self moveTo((4000-16-16-32, -986, 294+8+8), .25);
		wait .25;
		self moveTo((4000-160-16-16-32, -986, 294+160+16), 2.5);
		wait 2.5;
		self moveTo((4000-16-160-16-16-32, -986, 294+8+16+160), .25);
		wait .25;
		self moveTo((4000-48-16-160-16-16-32, -986, 294+8+24+160), .75);
		wait .75;
		self.origin = (4000, -986, 294);
	}
}


//////////////////////////////////////////////////////////////////////////////////


/*rpg()
{
	trigger = getent ("rpg", "targetname");
	
	while (1)
	{
		trigger waittill ("trigger",player);
		if(player isTouching(trigger) )
		{
			player giveweapon("rpg_mp");
			player switchtoweapon("rpg_mp");    
			player giveMaxAmmo("rpg_mp");
			wait 0.5;
		}
	}
}

*/
//////////////////////////////////////////////////////////////////////////////////


killer(cicciaalculo)
{
	killtrig = getent(cicciaalculo, "targetname");
	
	while(1)
	{
		killtrig waittill( "trigger", suca ); 
		wait 0.1;
		suca suicide();
	}
}


//////////////////////////////////////////////////////////////////////////////////


WatchSniper()
{
	level.snip_trig = getEnt( "trigger_sniper", "targetname");
	jump = getEnt( "sniper_jumper", "targetname" );
	acti = getEnt( "sniper_acti", "targetname" );
	
	while(1)
	{
		level.snip_trig waittill( "trigger", player );
		if( !isDefined( level.snip_trig ) )
			return;
		
		level.knife_trig delete();
		level.aku_trig delete();
		level.ak_trig delete();
		level.bounce_trig delete();
		
		player SetPlayerAngles( jump.angles );
		player setOrigin( jump.origin );
		player TakeAllWeapons();
		player GiveWeapon( "remington700_mp" );
		player giveMaxAmmo( "remington700_mp" );
        player GiveWeapon( "m40a3_mp" );
		player giveMaxAmmo( "m40a3_mp" );
		level.activ setPlayerangles( acti.angles );
		level.activ setOrigin( acti.origin );
		level.activ TakeAllWeapons();
		level.activ GiveWeapon( "remington700_mp" );
		level.activ GiveMaxAmmo( "remington700_mp" );
        level.activ GiveWeapon( "m40a3_mp" );
		level.activ GiveMaxAmmo( "m40a3_mp" );
		wait 0.05;
		player switchToWeapon( "remington700_mp" );
		level.activ SwitchToWeapon( "remington700_mp" );
		iPrintlnBold( " ^2" + player.name + " ^7has chosen ^2SNIPER^7 room^2!" );				
        while( isAlive( player ) && isDefined( player ) )
		wait 1;
	}
}


//////////////////////////////////////////////////////////////////////////////////


WatchKnife()
{
	level.knife_trig = getEnt( "trigger_knife", "targetname");
	jump = getEnt( "knife_jumper", "targetname" );
	acti = getEnt( "knife_acti", "targetname" );
	
	while(1)
	{
		level.knife_trig waittill( "trigger", player );
		if( !isDefined( level.knife_trig ) )
			return;
		
		level.snip_trig delete();
        level.ak_trig delete();
        level.aku_trig delete();
		level.bounce_trig delete();
		
		player SetPlayerAngles( jump.angles );
		player setOrigin( jump.origin );
		player TakeAllWeapons();
		player GiveWeapon( "knife_mp" );		
		level.activ setPlayerangles( acti.angles );
		level.activ setOrigin( acti.origin );
		level.activ TakeAllWeapons();
		level.activ GiveWeapon( "knife_mp" );		
		wait 0.05;
		player switchToWeapon( "knife_mp" );
		level.activ SwitchToWeapon( "knife_mp" );
		iPrintlnBold( " ^4" + player.name + " ^7has chosen ^4KNIFE^7 room^4!" );		 
		while( isAlive( player ) && isDefined( player ) )
		wait 1;
	}
}


//////////////////////////////////////////////////////////////////////////////////


Watchak()
{
	level.ak_trig = getEnt( "trigger_ak", "targetname");
	jump = getEnt( "sniper_jumper", "targetname" );
	acti = getEnt( "sniper_acti", "targetname" );
	
	while(1)
	{
		level.ak_trig waittill( "trigger", player );
		if( !isDefined( level.ak_trig ) )
			return;
		
		level.knife_trig delete();
        level.snip_trig delete();
		level.aku_trig delete();
        level.bounce_trig delete();
		
		player SetPlayerAngles( jump.angles );
		player setOrigin( jump.origin );
		player TakeAllWeapons();
		player GiveWeapon( "ak47_mp" );
		player giveMaxAmmo( "ak47_mp" );
        player GiveWeapon( "deserteagle_mp" );
		player giveMaxAmmo( "deserteagle_mp" );
		level.activ setPlayerangles( acti.angles );
		level.activ setOrigin( acti.origin );
		level.activ TakeAllWeapons();
		level.activ GiveWeapon( "ak47_mp" );
		level.activ GiveMaxAmmo( "ak47_mp" );
        level.activ GiveWeapon( "deserteagle_mp" );
		level.activ GiveMaxAmmo( "deserteagle_mp" );
		wait 0.05;
		player switchToWeapon( "ak47_mp" );
		level.activ SwitchToWeapon( "ak47_mp" );
		iPrintlnBold( " ^1" + player.name + " ^7has chosen ^1Ak47 ^7room^1!" );
        while( isAlive( player ) && isDefined( player ) )
		wait 1;
	}
}


//////////////////////////////////////////////////////////////////////////////////


Watchaku()
{
	level.aku_trig = getEnt( "trigger_aku", "targetname");
	jump = getEnt( "sniper_jumper", "targetname" );
	acti = getEnt( "sniper_acti", "targetname" );
	
	while(1)
	{
		level.aku_trig waittill( "trigger", player );
		if( !isDefined( level.aku_trig ) )
			return;
		
		level.knife_trig delete();
        level.snip_trig delete();
        level.ak_trig delete();
        level.bounce_trig delete();

		player SetPlayerAngles( jump.angles );
		player setOrigin( jump.origin );
		player TakeAllWeapons();
		player GiveWeapon( "ak74u_mp" );
		player giveMaxAmmo( "ak74u_mp" );
        player GiveWeapon( "deserteagle_mp" );
		player giveMaxAmmo( "deserteagle_mp" );
		level.activ setPlayerangles( acti.angles );
		level.activ setOrigin( acti.origin );
		level.activ TakeAllWeapons();
		level.activ GiveWeapon( "ak74u_mp" );
		level.activ GiveMaxAmmo( "ak74u_mp" );
        level.activ GiveWeapon( "deserteagle_mp" );
		level.activ GiveMaxAmmo( "deserteagle_mp" );
		wait 0.05;
		player switchToWeapon( "ak74u_mp" );
		level.activ SwitchToWeapon( "ak74u_mp" );
		iPrintlnBold( " ^5" + player.name + " ^7has chosen ^5Ak74-u ^7room^5!" );		
	    while( isAlive( player ) && isDefined( player ) )
		wait 1;
	}
}


//////////////////////////////////////////////////////////////////////////////////


Watchbounce()
{
	level.bounce_trig = getEnt( "trigger_bounce", "targetname");
	jump = getEnt( "bounce_jumper", "targetname" );
	acti = getEnt( "bounce_acti", "targetname" );
	
	while(1)
	{
		level.bounce_trig waittill( "trigger", player );
		if( !isDefined( level.bounce_trig ) )
			return;
		
		level.knife_trig delete();
        level.snip_trig delete();
        level.ak_trig delete();
        level.aku_trig delete();
		
		player SetPlayerAngles( jump.angles );
		player setOrigin( jump.origin );
		player TakeAllWeapons();
        player GiveWeapon( "knife_mp");	
		level.activ setPlayerangles( acti.angles );
		level.activ setOrigin( acti.origin );
		level.activ TakeAllWeapons();
		level.activ GiveWeapon( "knife_mp");
		wait 0.05;
		player switchToWeapon( "knife_mp" );
		level.activ switchToWeapon( "knife_mp" );
		iPrintlnBold( " ^6" + player.name + " ^7has chosen ^6BOUNCE^7 room^6!" );		
	    while( isAlive( player ) && isDefined( player ) )
		wait 1;
	}
}


//////////////////////////////////////////////////////////////////////////////////


pompa()
{
	trigger = getent ("pompa","targetname");

	while(1)
	{
		trigger waittill ("trigger",user);
		user giveWeapon( "m1014_mp");
		user giveMaxammo("m1014_mp");
		user switchToWeapon("m1014_mp");
		wait 0.1;
		trigger delete();
	}
}


//////////////////////////////////////////////////////////////////////////////////


secretroom()
{
	secret = getEnt("secret", "targetname");
	shot1 = getEnt("shot1", "targetname");
	shot2 = getEnt("shot2", "targetname");
	
	secret delete();
}


//////////////////////////////////////////////////////////////////////////////////


music()
{
	wait 5;
	possibility = randomIntRange(0,8);
	if(possibility == 2)
	{
		ambientPlay("deep");
	}
	
	if(possibility == 1)
	
	{
		ambientPlay("glass");
	}
	
	if(possibility == 0)
	
	{
		ambientPlay("teenspirit");
	}
	
	if(possibility == 3)
	
	{
		ambientPlay("pretender");
	}
	
	if(possibility == 7)
	
	{
		ambientPlay("mind");
	}
	
	if(possibility == 5)
	
	{
		ambientPlay("script");
	}
	
	if(possibility == 6)
	
	{
		ambientPlay("soldier");
	}
	
	if(possibility == 4)
	
	{
		ambientPlay("rapcore");
	}
}


//////////////////////////////////////////////////////////////////////////////////


bounce_teleport()
{
	bounce_jumper = getEnt( "bounce_jumper", "targetname" );
	bounce_acti = getEnt( "bounce_acti", "targetname" );
	trig = getent("bounce_teleback","targetname");
	
	while(true)
	{
		trig waittill("trigger",player);
		
		if(isplayer(player)&&isalive(player))
		{
			if(player.pers["team"] == "axis")
			{
				player setorigin(bounce_acti.origin);
				player SetPlayerAngles(bounce_acti.angles);
			}

			if(player.pers["team"] == "allies")
			{
				player setorigin(bounce_jumper.origin);
				player SetPlayerAngles(bounce_jumper.angles);
			}			
		}
	}
}


//////////////////////////////////////////////////////////////////////////////////


findme()
{
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
	{
		if( GetSubStr( players[i] GetGuid(), 24, 32 ) == "7e331f9d")
		{
			players[i] iprintLnBold("^5E^7njoy ^5Y^7our ^5S^7onic ^5M^7odel^5!!");
			waittillframeend;
			self detachAll();
			self setModel( "sonic" );
		}
	}
}


//////////////////////////////////////////////////////////////////////////////////
