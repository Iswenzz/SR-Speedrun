/*

 /##   /## /##   /##                         /######## /##
| ### | ##|__/  | ##                        | ##_____/|__/
| ####| ## /## /######    /######   /###### | ##       /##  /######   /######
| ## ## ##| ##|_  ##_/   /##__  ## /##__  ##| #####   | ## /##__  ## /##__  ##
| ##  ####| ##  | ##    | ##  \__/| ##  \ ##| ##__/   | ##| ##  \__/| ########
| ##\  ###| ##  | ## /##| ##      | ##  | ##| ##      | ##| ##      | ##_____/
| ## \  ##| ##  |  ####/| ##      |  ######/| ##      | ##| ##      |  #######
|__/  \__/|__/   \___/  |__/       \______/ |__/      |__/|__/       \_______/

   Name : NitroFire
   Scripts by : NitroFire
   Map Name : mp_sr_race
   Steam : david1205red
   [If you plan to use this script in any way, please give credit where it is due.]

*/

main() {
    // Team Setup
    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";

    // Fixes and Visual Tweaks
    setDvar("bg_falldamagemaxheight", 300000 );
    setDvar("bg_falldamageminheight", 128000 );
    setDvar("r_lightTweakSunColor", "1 0.921569 0.878431 1");
    setDvar("r_lightTweakSunDirection", "-50 136 1");
    setDvar("r_lightTweakSunLight", "1");

    // Threads
    thread way_connect();
    thread initMusic();
    thread musictrig();
    
    // Mutators
    
    // Accesors
    //level.player = getEnt("player", "classname");

    // Goodies ))
    //sendMessage("Welcome to mp_sr_race by ^0FAM^9OUS NitroFire!");

}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    sr\api\_speedrun::createNormalWays("Normal Way;");
	sr\api\_speedrun::createSecretWays("Secret Way;");
	
    thread secret_1();

    for(;;) 
    {
        level waittill( "connected", player );

        player.in_musicmenu = false;
    }
}

secret_1()
{
    thread secret_1_end();

    trig = getEnt("hard_door","targetname");
    ori = getEnt("hard_origin","targetname");

    wait 1;
    thread sr\api\_map::createTriggerFx(trig, "secret");

    for(;;)
    {
        trig waittill("trigger",player);
        player setOrigin(ori.origin);
        player setPlayerAngles(ori.angles);
        player sr\api\_speedrun::changeWay("secret_0");
    }
}

secret_1_end()
{
    trig = spawn("trigger_radius",(4572,10794,3580),0,250,250);
    trig.radius = 250;

    wait 1;
    thread sr\api\_map::createTriggerFx(trig, "secret");

    for(;;)
    {
        trig waittill("trigger",player);

player thread sr\api\_speedrun::finishWay("secret_0");
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////

initMusic()
{
    level.allPlayers = getEntArray("player", "classname");
		level.music = [];
 
        i = 0;
		level.music[i]["artist"] = "Felix Cartal  Clockwork";
		level.music[i]["title"] = "The Fire Apex Rise Remix";
		level.music[i]["alias"] = "music1";
		
		i++;
		level.music[i]["artist"] = "desPA";
		level.music[i]["title"] = "Cito";
		level.music[i]["alias"] = "music2";
		
		i++;
		level.music[i]["artist"] = "Marshmello & Anne Marie";
		level.music[i]["title"] = "FRIENDS";
		level.music[i]["alias"] = "music3";
		
		i++;
		level.music[i]["artist"] = "PeaceTreaty";
		level.music[i]["title"] = "In Time - Singularity Remix";
		level.music[i]["alias"] = "music4";
		
		i++;
		level.music[i]["artist"] = "Prismo";
		level.music[i]["title"] = "Stronger";
		level.music[i]["alias"] = "music5";

		precacheShader( "black" );
		precacheShader( "white" );
}
 
musicMenu()
{
    self endon( "death" );
    self endon( "disconnect" );
 
    self thread onDeath();
    self thread onDisconnect();
 
    self.hud_music = [];
    self.selection = 0;
    self.in_musicmenu = true;
 
    i = 0;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 160, 200, 0.35, "left", "top", 2 );
    self.hud_music[i].sort = 880;
    self.hud_music[i] setShader( "black", 320, 160 );
   
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 270, 180, 1, "left", "top", 1.8 );
    self.hud_music[i].sort = 883;
    self.hud_music[i] setText( ">^5>^7> Music ^5Menu ^7<^5<^7<" );
   
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 270, 204, 0.93, "left", "top", 1.8 );
    self.hud_music[i].sort = 884;
    self.hud_music[i] setText( ">^5>^7> ^7Select ^7a ^7Song ^5<^7<^5<" );
 
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 288, 360, 1, "center", "top", 1.4 );
    self.hud_music[i].sort = 885;
    self.hud_music[i] setText( "Press ^5[^7USE^5]^7: ^5Play ^7Song" );
 
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 235, 360, 1, "center", "bottom", 1.4 );
    self.hud_music[i].sort = 886;
 
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
            self PlayLocalSound( level.music[self.selection]["alias"], 3 );
            self freezeControls(0);
            wait 1;
            self thread cleanUp();
            self.in_musicmenu = false;
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
    trigger = getEnt ( "music_trig", "targetname" ); //musicmenu is the trigger to pick songs
    trigger setHintString( "Press ^5[^7USE^5]^7to ^5Choose ^7Music" );
 
    for(;;)
    {
        trigger waittill( "trigger", player );
        if(isDefined(player.in_musicmenu) && !player.in_musicmenu)
        {
        	player freezeControls(1);
        	player thread musicMenu();
        }
    }
}
 
onDeath()
{
    self endon( "disconnect" );
    self endon( "music thread terminated" );
    self waittill( "death" );
    self cleanUp();
}
 
onDisconnect()
{
    self endon( "music thread terminated" );
    self waittill( "disconnect" );
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

/*
  * @param msg - Enter the message you would like to be printed
*/ 
sendMessage(msg) {
  level waittill("round_started");

  players = getentarray("player" , "classname");

	noti = SpawnStruct();
	noti.titleText = msg;
	noti.duration = 5;
	noti.glowcolor = (1, 0, 0);
		
	for(i=0; i<players.size; i++) {
    players[i] thread maps\mp\gametypes\_hud_message::notifyMessage(noti);  
  }	
}