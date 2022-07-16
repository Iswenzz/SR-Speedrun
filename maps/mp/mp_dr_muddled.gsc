	 
main()
{
trigger = spawn( "trigger_radius", (10297.4, 1450.59, -687.875), 0, 365, 75 );
trigger.targetname = "endmap_trig";
trigger.radius = 365;
	 
	 maps\mp\_load::main();

game["allies"] = "marines";
     game["axis"] = "opfor";
     game["attackers"] = "axis";
     game["defenders"] = "allies";
     game["allies_soldiertype"] = "desert";
     game["axis_soldiertype"] = "desert";
	 
	 setdvar("r_specularcolorscale", "1" );
     setdvar("r_glowbloomintensity0",".25");
     setdvar("r_glowbloomintensity1",".25");

     thread way_connect();
	 
     thread start();
	 thread song();
	 thread credits();
	 thread teleport();
	 thread teleport2();
	 thread teleport3();
	 thread teleport4();
	 thread teleport5();
	 thread teleport6();
	 // thread lift();
	 /*
     thread trap1();
	 thread trap2();
	 thread trap3();
	 thread trap4();
	 thread trap5();
	 thread trap6();
	 thread trap7();
	 thread trap8();*/
	 //thread sniper();
	 //thread knife();
	// thread uzi();
	 
}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    sr\api\_speedrun::createNormalWays("Spicy Way;");
    sr\api\_speedrun::createSecretWays("Weiner Way;");
	
	thread tp_1();
	
    for(;;)
    {
        level waittill( "connected", player );

    }
}
////////////////////////////////////////////////////////////////////////////////////////////////

tp_1()
{
	trigger = spawn( "trigger_radius", (-7170.61, 0.137155, -175.875), 0, 120, 90 );
	ori = spawn( "script_origin", (-7465, 0, 408));
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		player SetOrigin(ori.origin); 
		player SetPlayerAngles( ori.angles ); 
	}
}

start()
{
     level waittill("round_started");
	 wait 0.2;
	 level.xx4 = newHudElem();	
	 level.xx4.x =0;	
	 level.xx4.y = 150;
	 level.xx4.horzAlign = "center";	
	 level.xx4.vertAlign = "middle";
	 level.xx4.alignX = "center";
	 level.xx4.alignY = "middle";
	 level.xx4.sort = 102;	
	 level.xx4.foreground = 1;	
	 level.xx4.archived = true;	
	 level.xx4 fadeOverTime(2);
	 level.xx4.alpha = 1;	
	 level.xx4.fontScale = 4;
	 level.xx4.hidewheninmenu = false;	
	 level.xx4.color = (36,175,255);	//colour, RGB colour 
	 level.xx4.glowColor = (0.2, 0.2, 0.4);
	 level.xx4.glowAlpha = 1;
	 level.xx4.label = &"Map by Spicy Weiner";	
	 wait 3;
	 level.xx4 fadeOverTime(4);
	 level.xx4.alpha = 0;	
	 wait 2;
	 level.xx4 destroy();
}

song()
{
}
	 

credits()
{
     for(;;)
	 {
	 iPrintLn ("^3>>Map By Spicy Weiner");
	 wait 7;
	 iPrintLn ("^3>>Helped by Sheep Wizard");
	 wait 7;
	 iPrintLn ("^3>>FeZe Clan");
     wait 14;
	 }
}

teleport()
{
trig = getEnt ("teleporter1", "targetname"); 
target = getEnt ("teleport1", "targetname"); 

for(;;) 
{ 
trig waittill ("trigger", player);
player sr\api\_speedrun::changeWay("secret_0"); //Speedrun Copy Paste
player SetOrigin(target.origin); 
player SetPlayerAngles( target.angles ); 
	
}
}

teleport2()
{
trig = getEnt ("teleporter2", "targetname"); 
target = getEnt ("teleport2", "targetname"); 

for(;;) 
{ 
trig waittill ("trigger", player); 

player SetOrigin(target.origin); 
player SetPlayerAngles( target.angles ); 

}
}

teleport3()
{
trig = getEnt ("teleporter3", "targetname"); 
target = getEnt ("teleport3", "targetname"); 

for(;;) 
{ 
trig waittill ("trigger", player); 

player SetOrigin(target.origin); 
player SetPlayerAngles( target.angles ); 

}
}

teleport4()
{
trig = getEnt ("teleporter4", "targetname"); 
target = getEnt ("teleport4", "targetname"); 

for(;;) 
{ 
trig waittill ("trigger", player); 

player SetOrigin(target.origin); 
player SetPlayerAngles( target.angles ); 
player thread sr\api\_speedrun::finishWay("secret_0");
}
}

teleport5()
{
trig = getEnt ("teleporter5", "targetname"); 
target = getEnt ("teleport5", "targetname"); 

for(;;) 
{ 
trig waittill ("trigger", player); 

player SetOrigin(target.origin); 
player SetPlayerAngles( target.angles ); 
	
}
}

teleport6()
{
trig = getEnt ("teleporter6", "targetname"); 
target = getEnt ("teleport6", "targetname"); 

for(;;) 
{ 
trig waittill ("trigger", player); 

player SetOrigin(target.origin); 
player SetPlayerAngles( target.angles ); 
	
}
}

lift()
{
lift = getent("lift", "targetname");
for(;;)
{
lift movez (576,1,0.5,0.5);
lift waittill("movedone");
wait 1;
lift movez (-576,1,0.5,0.5);
lift waittill("movedone");
wait 1;
}
}

trap1()
{
trig = getEnt ("trap1_trig", "targetname"); 
brush = getEnt ("brush1", "targetname");
trig waittill ("trigger", player);
trig delete();
brush movex (-1376,2);
brush waittill("movedone");
brush movex (1376,2);
brush waittill("movedone");
}

trap2()
{
trig = getEnt ("trap2_trig", "targetname"); 
brush = getEnt ("bounce1", "targetname");
brush2 = getEnt ("bounce2", "targetname");
brush3 = getEnt ("bounce3", "targetname");
trig waittill ("trigger", player);
trig delete();
for(;;)
{
brush rotatepitch (360,1);
brush waittill("rotatedone");
wait 0.1;
brush2 rotatepitch (360,1);
brush2 waittill("rotatedone");
wait 0.1;
brush3 rotatepitch (360,1);
brush3 waittill("rotatedone");
}
}

trap3()
{
trig = getEnt ("trap3_trig", "targetname"); 
brush = getEnt ("slide1", "targetname");
brush2 = getEnt ("slide2", "targetname");
trig waittill ("trigger", player);
trig delete();
brush rotatepitch (360,1);
brush2 rotatepitch (360,1);
brush2 waittill("rotatedone");
}

trap4()
{
trig = getEnt ("trap4_trig", "targetname"); 
brush1 = getEnt ("platforms1", "targetname");
brush2 = getEnt ("platforms2", "targetname");
trig waittill ("trigger", player);
trig delete();
for (;;)
{
brush1 rotateyaw (360,1);
brush1 waittill("rotatedone");
wait 1;
brush2 rotateyaw (-360,1);
brush2 waittill("rotatedone");
wait 1;
}
}

trap5()
{
trig = getEnt ("trap5_trig", "targetname");
brush1 = getEnt ("moveup", "targetname");
trig waittill ("trigger", player);
trig delete();
brush1 movez (336,0.1);
brush1 waittill("movedone");
wait 1;
brush1 movez (-336,2);
brush1 waittill("movedone");
}

trap6()
{
trig = getEnt ("trap6_trig", "targetname"); 
brush = getEnt ("spinners", "targetname");
trig waittill ("trigger", player);
trig delete();
brush rotateroll (360,1);
}

trap7()
{
trig = getEnt ("trap7_trig", "targetname");
brush = getEnt ("nipples", "targetname");
trig waittill ("trigger", player);
trig delete();
for(;;)
{
brush rotateyaw (360,3);
wait 3;
}
}

trap8()
{
trig = getEnt ("trap8_trig", "targetname"); 
brush = getEnt ("weiner", "targetname");
trig waittill ("trigger", player);
trig delete();
for(;;)
{
brush rotateyaw (360,1.5);
wait 2;
}
}

sniper()// name of the thread
{
     level.sniper_trig = getEnt( "sniper", "targetname"); //the trigger
     sjump = getEnt( "jumps", "targetname" ); //a origin for jumper
     sacti = getEnt( "actis", "targetname" ); // a origin for acti
	 
	 level.sniper_trig waittill( "trigger", player );
        if( !isDefined( level.sniper_trig ) )
         return;
        if(level.firstenter==true)
		{
		 level.knife_trig delete(); 
		 level.uzi_trig delete();
		 level.firstenter=false;
		}
     player SetPlayerAngles( sjump.angles );
	 player setOrigin( sjump.origin );
	 level.activ setPlayerangles( sacti.angles );
	 level.activ setOrigin( sacti.origin );
	 level.activ TakeAllWeapons();
	 player TakeAllWeapons();
	 level.activ giveweapon( "m40a3_mp"); //weapon
	 player giveweapon( "m40a3_mp");
	 player switchToWeapon( "m40a3_mp" );
	 level.activ SwitchToWeapon( "m40a3_mp" );
	 level.activ freezeControls(1);
	 player FreezeControls(1);
	 wait 2;
	 level.activ FreezeControls(0);
	 player FreezeControls(0);
	 player thread onDeath_sniper();  //player thread onDeath_knife();
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
onDeath_sniper()//change this according to player thread onDeath_sniper. so e.g for knife room do^^ and this would be <onDeath_knife()
{
     self endon("disconnect");
     self waittill("death");
     thread sniper();//change this to the name of the thread
}

knife()// name of the thread
{
     level.knife_trig = getEnt( "knife", "targetname"); //the trigger
     kjump = getEnt( "jumpk", "targetname" ); //a origin for jumper
     kacti = getEnt( "actik", "targetname" ); // a origin for acti
	 
	 level.knife_trig waittill( "trigger", player );
        if( !isDefined( level.knife_trig ) )
         return;
        if(level.firstenter==true)
		{
		 level.sniper_trig delete();
		 level.uzi_trig delete();
		 level.firstenter=false;
		}
     player SetPlayerAngles( kjump.angles );
	 player setOrigin( kjump.origin );
	 level.activ setPlayerangles( kacti.angles );
	 level.activ setOrigin( kacti.origin );
	 level.activ TakeAllWeapons();
	 player TakeAllWeapons();
	 level.activ giveweapon( "tomahawk_mp"); //weapon
	 player giveweapon( "tomahawk_mp");
	 player switchToWeapon( "tomahawk_mp" );
	 level.activ SwitchToWeapon( "tomahawk_mp" );
	 level.activ freezeControls(1);
	 player FreezeControls(1);
	 wait 2;
	 level.activ FreezeControls(0);
	 player FreezeControls(0);
	 player thread onDeath_knife();  //player thread onDeath_knife();
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
onDeath_knife()//change this according to player thread onDeath_sniper. so e.g for knife room do^^ and this would be <onDeath_knife()
{
     self endon("disconnect");
     self waittill("death");
     thread knife();//change this to the name of the thread
}

uzi()// name of the thread
{
     level.uzi_trig = getEnt( "uzi", "targetname"); //the trigger
     ujump = getEnt( "jumpu", "targetname" ); //a origin for jumper
     uacti = getEnt( "actiu", "targetname" ); // a origin for acti
	 
	 level.uzi_trig waittill( "trigger", player );
        if( !isDefined( level.uzi_trig ) )
         return;
        if(level.firstenter==true)
		{
		 level.sniper_trig delete();
		 level.knife_trig delete();
		 level.firstenter=false;
		}
     player SetPlayerAngles( ujump.angles );
	 player setOrigin( ujump.origin );
	 level.activ setPlayerangles( uacti.angles );
	 level.activ setOrigin( uacti.origin );
	 level.activ TakeAllWeapons();
	 player TakeAllWeapons();
	 level.activ giveweapon( "deserteagle_mp"); //weapon
	 player giveweapon( "deserteagle_mp");
	 player switchToWeapon( "deserteagle_mp" );
	 level.activ SwitchToWeapon( "deserteagle_mp" );
	 level.activ freezeControls(1);
	 player FreezeControls(1);
	 wait 2;
	 level.activ FreezeControls(0);
	 player FreezeControls(0);
	 player thread onDeath_uzi();  //player thread onDeath_knife();
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
onDeath_uzi()//change this according to player thread onDeath_sniper. so e.g for knife room do^^ and this would be <onDeath_knife()
{
     self endon("disconnect");
     self waittill("death");
     thread uzi();//change this to the name of the thread
}