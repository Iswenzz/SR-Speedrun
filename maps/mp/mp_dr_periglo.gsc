//Map by Speedy Gonzales (AKA Obamini)


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

	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	
	level.boom_fx = LoadFx("explosions/default_explosion");
	
	visionSetNaked("mp_dr_periglo");
	setDvar("r_filmUseTweaks", "1");
	setDvar("r_lightMap", "2");
	setDvar("bg_falldamagemaxheight", 200000 );
	setDvar("bg_falldamageminheight", 100000 );
	precacheMenu("songs");
	precacheShader("loadscreen_mp_dr_periglo");
	
	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap5();
	thread trap6();
	thread trap7();
	thread trap8();
	thread door();
	thread secret();
	thread secretweap();
	thread onPlayerConnect();
	thread onPlayerConnect2();
	thread musics();
	thread startdoor();

	
	addTriggerToList( "trig_trap1" );
	addTriggerToList( "trig_trap2" );
	addTriggerToList( "trig_trap4" );
	addTriggerToList( "trig_trap5" );
	addTriggerToList( "trig_trap6" );
	addTriggerToList( "trig_trap7" );
	addTriggerToList( "trig_trap8" );

	thread sr\api\_map::create_spawn((-213, 981, 220), 270);
	thread sr\api\_map::create_normal_way("Normal Way;");
	// thread sr\api\_map::create_endmap((-1287, 1923, 480), 120, 100);
	
}
	
	addTriggerToList( name )
{
  if( !isDefined( level.trapTriggers ) )
      level.trapTriggers = [];
  level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

startdoor()
{
door = getEnt("startdoor", "targetname");
wait 10;
iprintlnbold("^2Map by Obamini");
wait 3;
iprintln("^3Discord: Obamini#4695");
wait 2;
door moveZ(-1400, 8);
iprintln("^2START OPENED");
wait 2;

}

musics()
{
	trigger = getEnt ( "musictrigger", "targetname" );
	trigger waittill( "trigger", player );
	trigger setHintString( "Press ^2[^7USE^2] ^7to choose Music" );
	trigger delete();
	player endon ( "song_picked" );
	player thread songMenu();
	player freezeControls(1);
}

songMenu()
{
	
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "song_picked" );
 
	self openMenu("songs");
	
	self thread cleanUpOnPick();
	self thread cleanUpOnDeath();
 
	i = 0;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 160, 200, 0.6, "left", "top", 2 );
	self.hud_music[i].sort = 880;
	self.hud_music[i] setShader( "loadscreen_mp_dr_periglo", 360, 200 );
 
	i++;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 288, 358, 1, "center", "top", 1.4 );
	self.hud_music[i].sort = 885;
	self.hud_music[i].font = "objective";
	self.hud_music[i] setText( "\n                 Press ^2[^71^2/^72^2/^73^2/^74^2/^75^^2]^7 To Play The Song." );
	
	j = 0;
	self.hud_music_s[j] = braxi\_mod::addTextHud( self, 172, 230+(0*16), 0.93, "left", "top", 1.4 );
	self.hud_music_s[j].sort = 900;
	self.hud_music_s[j].font = "objective";
	self.hud_music_s[j] setText("^21.^2Bbno$ & Y2k - Lalala (Renzyx Remix)\n^22.^2Panjabi MC - Mundian To Bach Ke\n^23.^2DJ Blyatman - Tsar Bomb\n^24.^2N3UR0 - ERROR-[404]\n^25.^2Noisestorm - Breakout [Monstercat Official Music Video]");
 
	for(;;)
	{
		self waittill("menuresponse", menu, response);
		
		if( menu == "songs")
		{
			songs = getDvar(response);
			
			if(response == "song1")
			{
				ambientPlay("song1");
				iprintln("^2Now Playing: ^2Bbno$ & Y2k - Lalala (Renzyx Remix)");
				self freezeControls(0);
				self setClientDvar("song_picked",songs);
				self notify("song_picked");
				break;
			}
			
			if(response == "song2")
			{
				ambientPlay("song2");
				iprintln("^2Now Playing: ^2Panjabi MC - Mundian To Bach Ke");
				self freezeControls(0);
				self setClientDvar("song_picked",songs);
				self notify("song_picked");
				break;
			}
			
			if(response == "song3")
			{
				ambientPlay("song3");
				iprintln("^2Now Playing: ^2DJ Blyatman - Tsar Bomb");
				self freezeControls(0);
				self setClientDvar("song_picked",songs);
				self notify("song_picked");
				break;
			}
			
			if(response == "song4")
			{
				ambientPlay("song4");
				iprintln("^2Now Playing: ^2N3UR0 - ERROR-[404]");
				self freezeControls(0);
				self setClientDvar("song_picked",songs);
				self notify("song_picked");
				break;
			}
			
			if(response == "song5")
			{
				ambientPlay("song5");
				iprintln("^2Now Playing: ^2Noisestorm - Breakout (feat. Foreign Beggars) [Monstercat Official Music Video]");
				self freezeControls(0);
				self setClientDvar("song_picked",songs);
				self notify("song_picked");
				break;
			}
			
			else
			{
				ambientPlay("song1");
				iprintln("^2Now Playing: ^2Bbno$ & Y2k - Lalala (Renzyx Remix)");
				self freezeControls(0);
				self setClientDvar("song_picked",songs);
				self notify("song_picked");
				break;
			}
		}
	}
}

cleanUpOnDeath()
{
	self waittill("death");
	
	if(isDefined(self.hud_music))
	{
		for(i=0; i<self.hud_music.size; i++)	
			if(isDefined(self.hud_music[i]))
				self.hud_music[i] Destroy();
	}
	
	if(isDefined(self.hud_music_s))
	{
		for(i=0; i<self.hud_music_s.size; i++)	
			if(isDefined(self.hud_music_s[i]))
				self.hud_music_s[i] Destroy();
	}
}

cleanUpOnPick()
{
	self waittill("song_picked");
	
	if(isDefined(self.hud_music))
	{
		for(i=0; i<self.hud_music.size; i++)	
			if(isDefined(self.hud_music[i]))
				self.hud_music[i] Destroy();
	}
	
	if(isDefined(self.hud_music_s))
	{
		for(i=0; i<self.hud_music_s.size; i++)	
			if(isDefined(self.hud_music_s[i]))
				self.hud_music_s[i] Destroy();
	}
}

onPlayerConnect()
{
	level.oa = getEntArray("obamodel", "targetname");

	for(;;)
	{
		level waittill("connecting", player);

		player thread hud_website();
	}
}

onPlayerConnect2()
{
	level endon("game_ended");
	level.oa = getEntArray("obamodel", "targetname");

	for(i = 0; i < level.oa.size; i++)
	{
		level.oa[i] thread modelRotator();
	}
}


modelRotator()
{
	x = randomInt(2);
	if(x == 0)
	{
		while(isDefined(self))
		{
			self rotateYaw(360, .7);
			wait .7;
		}
	}
	else
	{
		while(isDefined(self))
		{
			self rotateYaw(-360, .7);
			wait .7;
		}
	}
}

hud_website()
{
v = "Map";
x = "by";
w = "Obamini";

	self.hud_web = newClientHudElem(self);
	self.hud_web.alignX = "center";
	self.hud_web.alignY = "top";
	self.hud_web.horzAlign = "center";
	self.hud_web.vertAlign = "top";
	self.hud_web.fontScale = 2;
	self.hud_web.sort = 10;
	self.hud_web.alpha = 1;
   	self.hud_web.color = ( 0, .1, .1);
   	self.hud_web.font = "objective";
   	self.hud_web.glowColor = (.1, .0, 1);
   	self.hud_web.glowAlpha = 1;
   	self.hud_web.hideWhenInMenu = true;	
	while(1)
	{
	self.hud_web setText("^2" + v + "^4 " + x + "^3 " + w + " ");
	wait ( 0.1 );
	self.hud_web setText("^4" + v + "^3 " + x + "^2 " + w + " ");
	wait ( 0.1 );
	self.hud_web setText("^3" + v + "^2 " + x + "^1 " + w + " ");
	wait ( 0.1 );
	self.hud_web setText("^2" + v + "^1 " + x + "^9 " + w + " ");
	wait ( 0.1 );
	self.hud_web setText("^1" + v + "^9 " + x + "^8 " + w + " ");
	wait ( 0.1 );
	self.hud_web setText("^9" + v + "^8 " + x + "^7 " + w + " ");
	wait ( 0.1	);
	self.hud_web setText("^8" + v + "^7 " + x + "^6 " + w + " ");
	wait ( 0.1 );
	self.hud_web setText("^7" + v + "^6 " + x + "^2 " + w + " ");
	wait ( 0.1 );
	self.hud_web setText("^6" + v + "^2 " + x + "^4 " + w + " ");
	wait ( 0.1 );
	}
}


trap1()
{
trig = getent("trig_trap1", "targetname");
floor = getent("trap1", "targetname");
trig sethintstring ("^2 Press &&1 to activate!");
trig waittill ("trigger", player);
trig sethintstring ("^2 Activated!");

{
floor moveZ (-288,1);
wait 4;
floor moveZ (288,1);
}


}

trap2()
{
trig = getent("trig_trap2", "targetname");
cylinder = getent("trap2", "targetname");
trig sethintstring ("^2 Press &&1 to activate!");
trig waittill ("trigger", player);
trig sethintstring ("^2 Activated!");

while(1)
{
cylinder rotateroll (360,1);
wait 3;
}

}

trap3()
{
trig = getent("trig_trap3", "targetname");
block1 = getent("trap3", "targetname");
trig sethintstring ("^2 Press &&1 to activate!");
trig waittill ("trigger", player);
trig sethintstring ("^2 Activated!");

{
block1 moveZ (48,1);
wait 4;
block1 moveZ (-48,1);
}

}

trap4()
{
trig = getent("trig_trap4", "targetname");
block2 = getent("trap4", "targetname");
trig sethintstring ("^2 Press &&1 to activate!");
trig waittill ("trigger", player);
trig sethintstring ("^2 Activated!");

{
block2 moveZ (48,1);
wait 4;
block2 moveZ (-48,1);
}

}



trap5()
{
trig = getent("trig_trap5", "targetname");
tupac1 = getent("trap5a", "targetname");
tupac2 = getent("trap5b", "targetname");
tupac3 = getent("trap5c", "targetname");
tupac4 = getent("trap5d", "targetname");
trig sethintstring ("^2 Press &&1 to activate!");
trig waittill ("trigger", player);
trig sethintstring ("^2 Activated!");

while(1)
{
tupac1 rotateYaw (360,1);
tupac2 rotateYaw (360,1);
wait 2;
tupac3 rotateYaw (360,1);
tupac4 rotateYaw (360,1);
wait 2;
}

}

trap6()
{
trig = getent("trig_trap6", "targetname");
gonzales1 = getent("trap6a", "targetname");
gonzales2 = getent("trap6b", "targetname");
gonzales3 = getent("trap6c", "targetname");
gonzales4 = getent("trap6d", "targetname");
gonzales5 = getent("trap6e", "targetname");
gonzales6 = getent("trap6f", "targetname");
gonzales7 = getent("trap6g", "targetname");
gonzales8 = getent("trap6h", "targetname");
gonzales9 = getent("trap6i", "targetname");
gonzales10 = getent("trap6j", "targetname");
trig sethintstring ("^2 Press &&1 to activate!");
trig waittill ("trigger", player);
trig sethintstring ("^2 Activated!");
gonzales1 moveY (672,1);
gonzales2 moveY (672,1);
gonzales3 moveY (672,1);
gonzales4 moveY (672,1);
gonzales5 moveY (672,1);
wait 3;
gonzales6 moveY (672,1);
gonzales7 moveY (672,1);
gonzales8 moveY (672,1);
gonzales9 moveY (672,1);
gonzales10 moveY (672,1);
wait 1;
gonzales1 delete();
gonzales2 delete();
gonzales3 delete();
gonzales4 delete();
gonzales5 delete();
gonzales6 delete();
gonzales7 delete();
gonzales8 delete();
gonzales9 delete();
gonzales10 delete();

}

trap7()
{
trig = getent("trig_trap7", "targetname");
boom1 = getent("trap7a", "targetname");
boom2 = getent("trap7b", "targetname");
boom = getent("origin", "targetname");
trig sethintstring ("^2 Press &&1 to activate!");
trig waittill ("trigger", player);
trig sethintstring ("^2 Activated!");

{
boom1 moveZ (-176,1);
boom2 moveZ (-176,1);
wait 1;
PlayFX( level.boom_fx, boom.origin );
wait 3;
boom1 moveZ (176,1);
boom2 moveZ (176,1);
}

}

trap8()
{
trig = getent("trig_trap8", "targetname");
floor2 = getent("trap8", "targetname");
trig sethintstring ("^2 Press &&1 to activate!");
trig waittill ("trigger", player);
trig sethintstring ("^2 Activated!");

{
floor2 moveZ (-288,1);
wait 4;
floor2 moveZ (288,1);
}

}

door()
{
door = getent ("finaldoor", "targetname");
trig = getent ("finaldoor_trig", "targetname");
trig waittill ("trigger", player);

{
wait 1;
door moveZ (-160,2);
wait 2;
door delete();
}

}

secret()
{
wall = getent ( "namedoor", "targetname" );
trig = getent ( "name_trig", "targetname" );

	while(true)
	{
		trig waittill ("trigger", player);
		
		if ((player.name == "Obamini"))
		{
			wall notsolid();
		}
		else
		{
			wall solid();
		}
	}
}

secretweap()
{
weapon = getent("give", "targetname");
weapon sethintstring ("^2 Press &&1 for weapon!");

while(1)
{
weapon waittill ("trigger", player);
player giveWeapon ("brick_blaster_mp");
player giveMaxAmmo ("brick_blaster_mp");
player switchToWeapon ("brick_blaster_mp");
}

}