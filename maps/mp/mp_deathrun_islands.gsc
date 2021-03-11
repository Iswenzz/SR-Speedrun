/*
Map made by Sheep Wizard
youtube: http://www.youtube.com/user/paap15
xfire: paap15
*/
main()
{
     maps\mp\_load::main();
	 maps\mp\mp_deathrun_island\teleport::main();
	 //maps\mp\mp_deathrun_island\traps::main();
	 maps\mp\mp_deathrun_island\endrooms::main();
	 level._effect["islandfire"] = loadFX("deathrun/islandfire");
	 level.greenspark = LoadFX("deathrun/greenspark");
	 
	 game["allies"] = "marines";
     game["axis"] = "opfor";
     game["attackers"] = "axis";
     game["defenders"] = "allies";
     game["allies_soldiertype"] = "desert";
     game["axis_soldiertype"] = "desert";

	 PrecacheShellShock("frag_grenade_mp");
	 precacheModel("playermodel_baa_joker");
	 precacheItem( "ak47_mp" );
	 precacheItem( "m14_silencer_mp" );
	 precacheItem( "brick_blaster_mp" );
	 
	 
	// thread platform();
	// thread music();
	 thread sheep();
	 thread trap();
	 //thread ak();
	 thread secret2();
	 //thread specmap();
	// thread deagle();
	 thread vip();
	 thread bounceweap();
	 //thread addTestClients();
	 thread start();
	// thread credits();
	 //thread beta();
	 thread fx();
	 thread jaja();
     thread way_connect();
     checktele();
	 
	 //setExpFog(3000, 4000, 0.4, 0.425, 0.44, 0.0);
}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    sr\api\_map::createWay("normal", "Island Way", "1");
	sr\api\_map::createWay("secret", "Secret Way", "1");
	
    for(;;)
    {
        level waittill( "connected", player );
        player thread sr\api\_map::way_name();

    }
}
////////////////////////////////////////////////////////////////////////////////////////////////

checktele()
{
	end = getent("secorg", "targetname");
	while(1)
	{
		players = getentarray("player", "classname");
		for(i = 0; i<players.size; i++)
		{
			if(  players[i].origin[1] < -10986  && players[i].origin[0] > 3475)
			{
				players[i] setorigin( ((3408, -2240, -1005)) , 3 );
			}

		}
		wait 0.05;
	}
}

platform()
{
brush = getent("platform", "targetname");
start = getent("pstart", "targetname");
end = getent("pend", "targetname");
for(;;)
{
brush moveto (end.origin, 7,3,3);
brush rotateto (end.angles, 7);
wait 10;
brush moveto (start.origin, 7,3,3);
brush rotateto (start.angles, 7);
wait 10;
}
}

music()
{
     wait 15;
     ambientPlay("islandmusic");
	 level.xx5 = newHudElem();	
	 level.xx5.x = 0;	
	 level.xx5.y = 150;
	 level.xx5.horzAlign = "center";	
	 level.xx5.vertAlign = "middle";
	 level.xx5.alignX = "center";
	 level.xx5.alignY = "middle";
	 level.xx5.sort = 102;	
	 level.xx5.foreground = 1;	
	 level.xx5.archived = true;	
	 level.xx5 fadeOverTime(2);
	 level.xx5.alpha = 1;	
	 level.xx5.fontScale = 4.6;
	 level.xx5.hidewheninmenu = false;	
	 level.xx5.color = (236,0,139);	
	 level.xx5.glowColor = (0.3, 0.0, 0.3);
	 level.xx5.glowAlpha = 1;
	 level.xx5.label = &"MitiS - Born";	
	 wait 4;
	 level.xx5 fadeOverTime(4);
	 level.xx5.alpha = 0;	
	 wait 10;
	 level.xx5 destroy();
}

sheep()
{
brush = getent("sheep", "targetname");
brush3 = getent("wizard", "targetname");
start = getent("sheepstart", "targetname");
end = getent("sheepend", "targetname");
start2 = getent("wizardstart", "targetname");
end2 = getent("wizardend", "targetname");
trig = getent("sheeptrig", "targetname"); 
brush2 = getent("leaver", "targetname"); 
brush moveto (end.origin, 0.1);
brush rotateto (end.angles, 0.1);
brush3 moveto (end2.origin, 0.1);
brush3 rotateto (end2.angles, 0.1);
for(;;)
{
trig waittill("trigger", player);
brush2 rotatepitch (-90,2);
brush moveto (start.origin, 7,3,3);
brush rotateto (start.angles, 7);
brush3 moveto (start2.origin, 7,3,3);
brush3 rotateto (start2.angles, 7);
wait 8;
trig waittill("trigger");
brush2 rotatepitch (90,2);
brush moveto (end.origin, 7,3,3);
brush rotateto (end.angles, 7);
brush3 moveto (end2.origin, 7,3,3);
brush3 rotateto (end2.angles, 7);
wait 8;
}
}

trap()
{
brush = getent("trap", "targetname");
trig = getent("trap_trig", "targetname");
trig delete();
brush delete();
}

ak()
{
trig = getent("ak", "targetname");
curse = getent("curse", "targetname");
for(;;)
{
trig waittill("trigger", player);
player giveweapon( "ak47_mp");
player switchToWeapon( "ak47_mp" );
player setWeaponAmmoClip( "ak47_mp", 10 );
player setweaponammostock( "ak47_mp", 0 );
player iprintlnbold("^1HOW DARE YOU TAKE ^2TIM'S ^1WEAPON!!");
wait 0.8;
player iprintlnbold("^1YOU WILL BE CURSED!!");
wait 1;
player ShellShock("frag_grenade_mp", 5 );
wait 1;
player SetPlayerAngles( curse.angles );
}
}

secret2()
{
trig = getent("cave", "targetname");
for(;;)
{
trig waittill("trigger", player);
player setClientDvar( "r_specularMap", 2 );
}
}

specmap()
{
while(1)
{
level waittill( "player_spawn", player );
player setClientDvar( "r_specularMap", 1);
}
}

deagle()
{
trig = getent("deagle", "targetname");
trig waittill("trigger", player);	
player FreezeControls(1);
player iprintlnbold("^1Creating life...");
wait 1;
player.health = 80;
wait 1;
player.health = 60;
wait 1;
player.health = 40;
wait 1;
player.health = 30;
wait 1;
player braxi\_mod::giveLife();
player FreezeControls(0);
}
/*
BUY VIP FOR ALL MY MAPS FOR CHEAP CHEAP PRICES $$$$
£1 = Joker skin in game + special welcome message
£3 = Joker skin in game + special welcome message + a colt45_mp silenced <wow>
£5 = Luxy package = Joker skin in game + special welcome message + a weapon of you choice + 10% faster run speed
MESSAGE ME ON XFIRE WHILE THE PRICES ARE LOW!!!!!
ᵗʰᶦˢ ᶦˢ ᵃ ʲᵒᵏᵉ
*/
vip()
{	
	level.accepted1 = "11b05456"; //Sheep

	while (1)
	{
		level waittill( "player_spawn", player );
		
		friend = getSubStr(player getGuid(), 24, 32);
		
		if((friend == level.accepted1))
		{	
		    wait 1;
			player detachAll();
			player setModel("playermodel_baa_joker");
			player iprintln("Hey Sheep");
			iprintln("^2Sheep Wizard ^1is online!");
		}
		if((friend == level.accepted1) && level.freerun == false && player.pers["team"] == "allies")
		{
		 player giveweapon( "brick_blaster_mp" );
		}
	}
}

bounceweap()
{
trig = getent("bounceweap", "targetname");
trig waittill("trigger", player);
trig delete();
player giveweapon( "m14_silencer_mp");
player switchToWeapon( "m14_silencer_mp" );
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
//scr_testclients 4
}

start()
{
    brush = getent("laser", "targetname");
    brush2 = getent("laserkill", "targetname");
    brush2 delete();
    brush delete();
}

credits()
{
for(;;)
	 {
	 iPrintLn ("^1>>^3Map By Sheep Wizard");
	 wait 7;
	 iPrintLn ("^1>>^3Youtube: paap15");
	 wait 7;
	 iPrintLn ("^1>>^3Xfire: paap15");
	 wait 7;
	 iPrintLn ("^1>>^3Thanks to Darmuh + Blade");
	 wait 7;
	 iPrintLn ("^1>>^3Thanks to FeZe Dench (Rickster) for helping test map");
	 wait 7;
	 iPrintLn ("^1>>^3Thanks for playing ^2mp_deathrun_islands, ^3Hope you enjoy!");
	 wait 7;
	 iPrintLn ("^1>>^3Thanks to FeZe Dench (Rickster) for helping test map");
	 wait 7;
	 }
}

beta() 
{
     level.xxx2 = newHudElem();	//hud visible for all, to make it only visible for one replace level. with self. and change newHudElem() to newClientHudElem(self)
	 level.xxx2.x = 10;	//position on the x-axis
	 level.xxx2.y = -200;	//position on the <-axis
	 level.xxx2.horzAlign = "left";	
	 level.xxx2.vertAlign = "middle";
	 level.xxx2.alignX = "left";
	 level.xxx2.alignY = "middle";
	 level.xxx2.sort = 102;	//if there are lots of huds you can tell them which is infront of which
	 level.xxx2.foreground = 1;	//to do with the one above, if it's in front a lower sorted hud
	 level.xxx2.archived = true;	//visible in killcam
	 level.xxx2.alpha = 1;	//transparency	0 = invicible, 1 = visible
	 level.xxx2.fontScale = 1.4;	//textsize
	 level.xxx2.hidewheninmenu = false;	//will it be visble when a player is in a menu
	 level.xxx2.color = (0,191,255);	//RGB color code
	 level.xxx2.label = &"Test version of map!";
}

fx() //Thank you blade for this
{ 
	{ 
		islandfire = getentarray("fire1", "targetname"); 
		for(i=0;i<islandfire.size;i++) 
		{ 
			spawn_islandfire[i] = maps\mp\_utility::createOneshotEffect( "islandfire" ); 
			spawn_islandfire[i].v[ "origin" ] = islandfire[i].origin; 
			spawn_islandfire[i].v[ "angles" ] = ( 270, 0, 0 ); 
			spawn_islandfire[i].v[ "fxid" ] = "islandfire"; 
			spawn_islandfire[i].v[ "delay" ] = -13; 
			spawn_islandfire[i].v[ "soundalias" ] = "fire_metal_large"; 
		} 
	} 
}

jaja()
{
trig = getent("playereffect", "targetname");
trig waittill("trigger", player);
for(;;)
{
PlayFXOnTag( level.greenspark, player, "j_head" );
wait 3;
}
}















