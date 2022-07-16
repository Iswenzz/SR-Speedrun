main()
{
//////////////////////////////thready////////////
  		// ambientPlay("indipyramid");
	
	  thread way_connect();
      thread door_a();
	  thread door_b();
      // thread jump_teleport();
      thread secret_teleport();	
	  thread onConnect();

precacheItem( "remington700_mp" );
precacheItem( "knife_mp" );
precacheItem( "tomahawk_mp" );
precacheItem( "winchester1200_mp" );
precacheItem( "skorpion_mp" );
precacheItem( "m4_mp" );
precacheItem( "g3_mp" );
precacheItem( "ak47_mp" );
precacheItem( "rpd_mp" );

// thread old(); //64
// thread jump(); //64
// thread snip();  //304
thread secret2();
thread jump_room_gun();
	  
        maps\mp\_load::main();
	
	maps\mp\mp_dr_indipyramid_script1::main();
	maps\mp\mp_dr_indipyramid_script2::main();
	maps\mp\mp_dr_indipyramid_obrazy::main();
	
	
//////////////////////////////////global////////////////////////////

	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";
	
	setdvar( "r_specularcolorscale", "1" );
	
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");

//////////////////////////////////////////deathrun/////////////////////
		
}

onConnect()
{
	for(;;)
	{
		level waittill( "connected", player );
		player thread onPlayerSpawned();
	}
}

/////////////////////////////////////SPEEDRUN MOD/////////////////////////////////////
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
/////////////////////////////////////SPEEDRUN MOD/////////////////////////////////////

onPlayerSpawned()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("spawned_player");
		self.secret2 = undefined;
	}
}

door_a()
{
door_a = getent ("door_start" ,"targetname");
door_a delete();
}

door_b()
{
	trig = getent ("door_final" , "targetname");
	trig delete ();
}

old()
{

}

jump()
{

}

snip()
{

}

jumper_snip()
{

}

death()
{
self endon("disconnect");

self waittill ("death");
}

jumper_port()
{


}

aktiv_teleport_jump()
{

}

atj_1()
{

}

aktiv_teleport_snip()
{

}

ats_1()
{

}

jumper_jump()
{

}

jump_teleport()
{

}

secret_teleport()
{
enter = getent ("secret_enter" , "targetname");
go = getent ("secret_go" , "targetname");
player5 = getent ("secret_player" , "targetname");
trig1 = getent ("secret_player_trig1" , "targetname");
trig2 = getent ("secret_player_trig2" , "targetname");
text = getent ("secret_text" , "targetname");

player5 delete();

	for(;;)
	{
	enter waittill ("trigger", player);
	player SetPlayerAngles(go.angles);
	player SetOrigin(go.origin);
	}
}


secret_text()
{

}

secret2()
{
open = getent ("secret2_use1" , "targetname");
level.enter = getent ("secret2_enter" , "targetname");
level.go = getent ("secret2_go" , "targetname");
level.enter2 = getent ("secret2_enter2" , "targetname");
level.go2 = getent ("secret2_go2" , "targetname");
level.enter3 = getent ("secret2_enter3" , "targetname");
model_t = getent ("tomahawk_model" , "targetname");
trig_t = getent ("tomahawk_trig" , "targetname");

	thread secret2_port();
	thread secret2_port2();
	thread secret2_port3();

	for(;;)
	{
	open waittill("trigger",p);
	p.secret2 = true;
	}
}

secret2_port()
{
	while(1)
	{
    level.enter waittill ("trigger", player);
		if(isDefined(player.secret2) && player.secret2)
		{
		player SetPlayerAngles(level.go.angles);
		player SetOrigin(level.go.origin);
		player sr\api\_speedrun::changeWay("secret_0"); //Speedrun Copy Paste
		}
	}
}

secret2_port2()
{
  while(1)
  {
    level.enter2 waittill ("trigger", player);
		if(isDefined(player.secret2) && player.secret2)
		{
		player thread braxi\_mod::endTimer();
		}
  }
}

secret2_port3()
{
  while(1)
  {
    level.enter3 waittill ("trigger", player);
		if(isDefined(player.secret2) && player.secret2)
		{
		player SetPlayerAngles(level.go.angles);
		player SetOrigin(level.go.origin);
		}
  }
}

jump_room_gun()
{

}

GetRandomWeapon( num )
{

}