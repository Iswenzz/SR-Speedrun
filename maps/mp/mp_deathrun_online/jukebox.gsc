main()
{
	thread initMusic();
	thread musictrig();
}


// Blades's Music menu
initMusic()
{
		level.music = [];
 
        i = 0;
		level.music[i]["artist"] = "Dimitri Vegas & Like Mike vs. Sander Van Doorn";
		level.music[i]["title"] = "Project T";
		level.music[i]["alias"] = "ambient1";
		
		i++;
		level.music[i]["artist"] = "Polar Trip";
		level.music[i]["title"] = "Flagship";
		level.music[i]["alias"] = "ambient2";
		
		i++;
		level.music[i]["artist"] = "Submatik";
		level.music[i]["title"] = "Firefly";
		level.music[i]["alias"] = "ambient3";
		
		i++;
		level.music[i]["artist"] = "xKore feat. Zore & Naomi";
		level.music[i]["title"] = "Need You";
		level.music[i]["alias"] = "ambient4";
		
		i++;
		level.music[i]["artist"] = "Martin Garrix";
		level.music[i]["title"] = "Wizard";
		level.music[i]["alias"] = "ambient5";
 
 
        //precacheShader( "bladeuni" ); sind meine eigenen :D
        //precacheShader( "rainbow" );

		precacheShader( "black" );
		precacheShader( "white" );
}

musicMenu()
{
	effect_1 = getEnt ( "jukebox_origin_1", "targetname" );
	effect_2 = getEnt ( "jukebox_origin_2", "targetname" );
	
	self endon( "death" );
 
	self thread onDeath();
	self thread onDisconnect();
 
	self.hud_music = [];
	self.selection = 0;
 
	i = 0;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 160, 200, 0.35, "left", "top", 2 );
	self.hud_music[i].sort = 880;
	self.hud_music[i] setShader( "black", 320, 160 );
	
	i++;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 270, 180, 1, "left", "top", 1.8 );
	self.hud_music[i].sort = 883;
	self.hud_music[i] setText( "^2Blade's Jukebox" );
	
	i++;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 270, 204, 0.93, "left", "top", 1.8 );
	self.hud_music[i].sort = 884;
	self.hud_music[i] setText( "Select a Song" );
 
	i++;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 288, 360, 1, "center", "top", 1.4 );
	self.hud_music[i].sort = 885;
	self.hud_music[i] setText( "Press ^2[^7USE^2]^7: Play Song" );

	i++;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 235, 360, 1, "center", "bottom", 1.4 );
	self.hud_music[i].sort = 886;
	self.hud_music[i] setText( "^2V^7istic ^2C^7lan" );
 
	for( j = 0; j < level.music.size; j++ )
	{
		i++;
		self.hud_music[i] = braxi\_mod::addTextHud( self, 172, 230+(j*16), 0.93, "left", "top", 1.4 );
		self.hud_music[i].sort = 882;
		self.hud_music[i].font = "objective";
 
		entry = level.music[j];
		self.hud_music[i] setText( entry["artist"] + " ^2-^7 " + entry["title"] );
	}
 
	i++;
	self.hud_music[self.hud_music.size] = braxi\_mod::addTextHud( self, 167, 230, 0.4, "left", "top", 1.4 );
	self.hud_music[i].sort = 881;
	indicator = self.hud_music[self.hud_music.size-1];
	indicator setShader( "white", 306, 17 );
 
	while( self.sessionstate == "playing" )
	{
		wait 0.1;
 
		if( self attackButtonPressed() )
		{
			self.hud_music[5+self.selection].alpha = 0.93;
 
			self.selection++;
			if( self.selection >= level.music.size )
				self.selection = 0;
 
			item = self.hud_music[5+self.selection];
			item.alpha = 1;
			indicator.y = item.y;
		}
		else if( self useButtonPressed() )
		{
			iPrintln( "^2Now playing: ^7" + level.music[self.selection]["artist"]+" - ^2" +level.music[self.selection]["title"] );
 
			ambientPlay( level.music[self.selection]["alias"], 3 );
			self freezeControls(0);
			level notify ( "song_picked" );
			self braxi\_rank::giveRankXp( "trap_activation" );
			playFx ( level.jukeeffect, effect_1.origin );
			playFx ( level.jukeeffect, effect_2.origin );
			break;
		}
		else if( self meleeButtonPressed() )
		{
			self freezeControls(0);
			break;
		}
	}
 
	self cleanUp();
}
 
musictrig()
{
	trigger = getEnt ( "jukebox_trigger", "targetname" );
	trigger setHintString( "Press ^2[^7USE^2] ^7to choose Music" );
 
	trigger waittill( "trigger", player );
	trigger delete();
	level endon ( "song_picked" );
	player thread musicMenu();
	player freezeControls(1);
}
 
onDisconnect()
{
	self endon( "music thread terminated" );
	self waittill( "disconnect" );
	self cleanUp();
}
 
onDeath()
{
	self endon( "disconnect" );
	self endon( "music thread terminated" );
	self waittill( "death" );
	self cleanUp();
}
 
 
cleanUp()
{
	if( !isDefined( self ) )
		return;
 
	if( isDefined( self.hud_music ) )
	{
		for( i = 0; i < self.hud_music.size; i++ )
		{
			if( isDefined( self.hud_music[i] ) )
				self.hud_music[i] destroy();
		}
	}
	self notify( "music thread terminated" );
}