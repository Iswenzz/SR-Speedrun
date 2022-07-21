/*
______           __  _____  _____
| ___ \         /  ||  _  ||  _  |
| |_/ /_____  __`| || |/' || |_| |
|    // _ \ \/ / | ||  /| |\____ |
| |\ \  __/>  < _| |\ |_/ /.___/ /
\_| \_\___/_/\_\\___/\___/ \____/

Welcome to mp_dr_lazycave script. Feel free to take any piece of code, no need to credit me.

*/

main()
{
thread sr\api\_map::createSpawnOrigin((123, -154, 16), 2);
	maps\mp\_load::main();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	if(!isdefined(level.music))
	level.music=[];
	level.music[0]["song"]    ="Most ft. Ida - Lazy";
	level.music[0]["alias"]    ="radio1";
	level.music[1]["song"]    ="Floppino - Frah Quintale";
	level.music[1]["alias"]    ="radio2";
	level.music[2]["song"]    ="Imagine Dragons - Warriors";
	level.music[2]["alias"]    ="radio3";
	level.music[3]["song"]    ="Inna - Rendez vous";
	level.music[3]["alias"]    ="radio4";

	//DISABLING FALLDAMAGE
	setDvar("bg_falldamagemaxheight", 9999999 );
    setDvar("bg_falldamageminheight", 999999 );

	//SECRET INIT
	level.secret = false;

	//GENERAL THREADS
    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    	// thread musicBox();
	thread opening();
	// thread endingplatform();
	// thread initialize();
	// thread secretpart1();
	// thread secretpart2();

	//ACTIVATOR THREADS
	//TRAPS
	// addTriggerToList("traptrig1");
	// addTriggerToList("traptrig2");
	// addTriggerToList("traptrig3");
	//addTriggerToList("traptrig4");
	// addTriggerToList("traptrig5");
	// addTriggerToList("traptrig6");

	// thread trap1();
	// thread trap2();
	// thread trap3();
	// thread trap4();
	// thread trap5();
	// thread trap6();

	//BATTLE THREADS
	// thread knife();
	// thread gun();
	// thread sniper();

}

/*
   ___                       _
  / __|___ _ _  ___ _ _ __ _| |
 | (_ / -_) ' \/ -_) '_/ _` | |
  \___\___|_||_\___|_| \__,_|_|

*/

musicBox()
{
    trig=getent("musicbox","targetname");
    trig waittill("trigger",p);
    trig delete();

    p freezecontrols(1);
    p musicMenu();
}

musicMenu()
{
    self endon( "disconnect" );
    self endon( "death" );
    self endon( "spawned" );
    self endon( "joined_spectators" );
    self endon( "music thread terminated" );

    self.hud_music = [];
    self.selection = 0;

    // create huds
    i = 0;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 160, 200, 0.6, "left", "top", 2 );
    self.hud_music[i].sort = 879;
    self.hud_music[i] setShader( "black", 320, 160 );
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 167, 204, 0.6, "left", "top", 1.4 );
    self.hud_music[i].sort = 880;
    self.hud_music[i] setShader( "white", 306, 20 );
    self.hud_music[i].color=(1,0,0);

    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 210, 204, 0.93, "left", "top", 1.8 );
    self.hud_music[i].sort = 884;
    self.hud_music[i] setText("LazyCave musicbox");
    self.hud_music[i].glowalpha=1;
    if(isdefined(level.randomcolor))
        self.hud_music[i].glowcolor=level.randomcolor;
    else
        self.hud_music[i].glowcolor=(1,0,0);
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 250, 360, 1, "center", "bottom", 1.4 );
    self.hud_music[i].sort = 886;
    self.hud_music[i] setText("Scroll: ^3[{+attack}] ^7| Select: ^3[{+activate}] ^7| Close: ^3[{+frag}]");

    for( j = 0; j < level.music.size; j++ )
    {
        i++;
        self.hud_music[i] = braxi\_mod::addTextHud( self, 172, 230+(j*16), 0.93, "left", "top", 1.4 );
        self.hud_music[i].sort = 882;
        self.hud_music[i].font = "objective";
        self.hud_music[i].glowalpha=1;
        if(isdefined(level.randomcolor))
            self.hud_music[i].glowcolor=level.randomcolor;
        else
            self.hud_music[i].glowcolor=(1,0,0);

        entry = level.music[j];
        self.hud_music[i] setText(entry["song"]);
    }

    i++;
    self.hud_music[self.hud_music.size] = braxi\_mod::addTextHud( self, 167, 230, 0.4, "left", "top", 1.4 );
    self.hud_music[i].sort = 881;
    indicator = self.hud_music[self.hud_music.size-1];
    indicator setShader( "white", 306, 17 );
    indicator.color=(1,0,0);

    while(self.sessionstate == "playing")
    {
        wait 0.1;

        if(self attackButtonPressed())
        {
            self.hud_music[4+self.selection].alpha = 0.93;

            self.selection++;
            if( self.selection >= level.music.size )
                self.selection = 0;

            item = self.hud_music[4+self.selection];
            item.alpha = 1;
            indicator.y = item.y;
        }
        else if(self useButtonPressed())
        {
             iprintln("^1>> ^7Now playing: ^1"+level.music[self.selection]["song"]);
            ambientPlay(level.music[self.selection]["alias"]);
            self freezecontrols(0);
            break;
        }
        else if(self fragButtonPressed())
        {
            self freezecontrols(0);
            break;
        }
    }

    if(!isdefined(self))
        return;
    if(isdefined(self.hud_music))
    {
        for(i=0;i<self.hud_music.size;i++)
        {
            if(isdefined(self.hud_music[i]))
                self.hud_music[i] destroy();
        }
    }
    self notify( "music thread terminated" );
}

secretpart1()
{
	secretpart1 = getEnt("secretpart1","targetname");
	secretpart1 waittill("trigger",player);
	level.secret = true;
	IprintLnBold ("^1Something is ringing");
	secretpart1 delete();
}

secretpart2()
{
	secretpart2 = getEnt("secretpart2","targetname");
	while(1)
	{
		secretpart2 waittill("trigger",player);
		if (level.secret == false)
		{
			player IprintLnBold ("^1Nobody answered");
		}
		else
		{
			player freezecontrols(1);
			player IprintLnBold ("^1''You are not on the guest list''");
			wait(3);
			player IprintLnBold ("^1''I must get rid of you now...''");
			wait(3);
			player IprintLnBold ("^1''Well... Adios!''");
			wait(3);
			player suicide();
		}
	}
}

initialize()
{
	trap6 = getEnt("trap6","targetname");
	trap6 movez (311,0.1,0,0);

	trap4 = getEnt("trap4","targetname");
	trap4_hurt = getEnt("trap4_hurt","targetname");
	trap4_hurt enablelinkto();
	trap4_hurt linkto(trap4);
	trap4 movez (-228,0.1,0,0);
}

addTriggerToList(name)
{
    if(!isDefined(level.trapTriggers))
    level.trapTriggers=[];
    level.trapTriggers[level.trapTriggers.size]=getEnt(name,"targetname");
}

opening()
{
	door = getEnt("startingdoor","targetname");
	door movez (-481,2,0,0);
	door delete();
}

endingplatform()
{
	plat = getEnt("endingplatform","targetname");
	startplattrig = getEnt("startplattrig","targetname");
	startplattrig waittill("trigger",player);
}

/*
    _      _   _          _
   /_\  __| |_(_)_ ____ _| |_ ___ _ _
  / _ \/ _|  _| \ V / _` |  _/ _ \ '_|
 /_/ \_\__|\__|_|\_/\__,_|\__\___/_|

*/

trap1()
{
	traptrig1 = getEnt("traptrig1","targetname");
	trap1 = getEnt("trap1","targetname");
	traptrig1 waittill("trigger",player);
}

trap2()
{
	traptrig2 = getEnt("traptrig2","targetname");
	trap2 = getEnt("trap2","targetname");
	traptrig2 waittill("trigger",player);
}

trap3()
{
	traptrig3 = getEnt("traptrig3","targetname");
	trap3 = getEnt("trap3","targetname");
	traptrig3 waittill("trigger",player);
}

trap4()
{
	traptrig4 = getEnt("traptrig4","targetname");
	trap4 = getEnt("trap4","targetname");
	traptrig4 waittill("trigger",player);
}

trap5()
{
	traptrig5 = getEnt("traptrig5","targetname");
	trap5_1 = getEnt("trap5_1","targetname");
	trap5_2 = getEnt("trap5_2","targetname");
	traptrig5 waittill("trigger",player);
}

trap6()
{
	traptrig6 = getEnt("traptrig6","targetname");
	trap6 = getEnt("trap6","targetname");
	traptrig6 waittill("trigger",player);
}

/*

  ___       _   _   _
 | _ ) __ _| |_| |_| |___
 | _ \/ _` |  _|  _| / -_)
 |___/\__,_|\__|\__|_\___|

*/

info(msg, submsg)
{
	players = getentarray("player", "classname");
	noti = SpawnStruct();
	noti.titleText = msg;
	noti.notifyText = submsg;
	noti.duration = 5;
	noti.glowcolor = (0,0,1);
	for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
}

knife()
{
		for(;;)
		{
        level.knife_room = getEnt( "knife_trig", "targetname");
        jump = getEnt( "room_spawn_jumper", "targetname" );
        acti = getEnt( "room_spawn_acti", "targetname" );

        while(1)
{
                level.knife_room waittill( "trigger", player );
                if( !isDefined( level.knife_room ) )
                return;

              level.sniper_room delete();
			  level.gun_room delete();

            player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                player TakeAllWeapons();
                player GiveWeapon( "knife_mp" ); //Gives player weapon
                player giveMaxAmmo( "knife_mp" ); //Gives player ammo
            player switchToWeapon( "knife_mp" ); //Makes player switch to weapon.
                player.maxhealth = 100; //Sets players health to normal.


                if( isDefined( level.activ ) && isAlive( level.activ ) )
{

               level.activ setPlayerangles( acti.angles );
                    level.activ setOrigin( acti.origin );
                    level.activ TakeAllWeapons();
                    level.activ GiveWeapon( "knife_mp" );
                    level.activ giveMaxAmmo( "knife_mp" );
               level.activ SwitchToWeapon( "knife_mp" );
                    level.activ.maxhealth = 100;

}

                wait 0.05;

            info("Knife Room", player.name + " ^1VS ^7" + level.activ.name);
            player freezecontrols(true); //Freeze the players when someone enters the room for three seconds.
            level.activ freezecontrols(true);
            wait 1;
            player iPrintlnBold( "^13" );
            level.activ iPrintlnBold( "^13" );
            wait 1;
            player iPrintlnBold( "^32" );
            level.activ iPrintlnBold( "^32" );
            wait 1;
            player iPrintlnBold( "^51" );
            level.activ iPrintlnBold( "^51" );
            wait 1;
            player iPrintlnBold( "^2GO^7!" );
            level.activ iPrintlnBold( "^2GO^7!" );
            player freezecontrols(false); //Disables the freeze.
            level.activ freezecontrols(false);
                while( isAlive( player ) && isDefined( player ) )
                        wait 1;
}
		}
}

gun()
{
		for(;;)
		{
        level.gun_room = getEnt( "gun_trig", "targetname");
        jump = getEnt( "room_spawn_jumper", "targetname" );
        acti = getEnt( "room_spawn_acti", "targetname" );

        while(1)
{
                level.gun_room waittill( "trigger", player );
                if( !isDefined( level.gun_room ) )
                return;

              level.sniper_room delete();
			  level.knife_room delete();

            player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                player TakeAllWeapons();
                player GiveWeapon( "deserteaglegold_mp" ); //Gives player weapon
                player giveMaxAmmo( "deserteaglegold_mp" ); //Gives player ammo
            player switchToWeapon( "deserteaglegold_mp" ); //Makes player switch to weapon.
                player.maxhealth = 100; //Sets players health to normal.


                if( isDefined( level.activ ) && isAlive( level.activ ) )
{

               level.activ setPlayerangles( acti.angles );
                    level.activ setOrigin( acti.origin );
                    level.activ TakeAllWeapons();
                    level.activ GiveWeapon( "deserteaglegold_mp" );
                    level.activ giveMaxAmmo( "deserteaglegold_mp" );
               level.activ SwitchToWeapon( "deserteaglegold_mp" );
                    level.activ.maxhealth = 100;

}

                wait 0.05;

            info("Gun Room", player.name + " ^1VS ^7" + level.activ.name);
            player freezecontrols(true); //Freeze the players when someone enters the room for three seconds.
            level.activ freezecontrols(true);
            wait 1;
            player iPrintlnBold( "^13" );
            level.activ iPrintlnBold( "^13" );
            wait 1;
            player iPrintlnBold( "^32" );
            level.activ iPrintlnBold( "^32" );
            wait 1;
            player iPrintlnBold( "^51" );
            level.activ iPrintlnBold( "^51" );
            wait 1;
            player iPrintlnBold( "^2GO^7!" );
            level.activ iPrintlnBold( "^2GO^7!" );
            player freezecontrols(false); //Disables the freeze.
            level.activ freezecontrols(false);
                while( isAlive( player ) && isDefined( player ) )
                        wait 1;
}
		}
}

sniper()
{
		for(;;)
		{
        level.sniper_room = getEnt( "snip_trig", "targetname");
        jump = getEnt( "room_spawn_jumper", "targetname" );
        acti = getEnt( "room_spawn_acti", "targetname" );

        while(1)
{
                level.sniper_room waittill( "trigger", player );
                if( !isDefined( level.sniper_room ) )
                return;

              level.gun_room delete();
			  level.knife_room delete();

            player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                player TakeAllWeapons();
                player GiveWeapon( "m40a3_mp" ); //Gives player weapon
                player giveMaxAmmo( "m40a3_mp" ); //Gives player ammo
                player GiveWeapon( "remington700_mp" );
                player giveMaxAmmo( "remington700_mp" );
            player switchToWeapon( "m40a3_mp" ); //Makes player switch to weapon.
                player.maxhealth = 100; //Sets players health to normal.


                if( isDefined( level.activ ) && isAlive( level.activ ) )
{

               level.activ setPlayerangles( acti.angles );
                    level.activ setOrigin( acti.origin );
                    level.activ TakeAllWeapons();
                    level.activ GiveWeapon( "m40a3_mp" );
                    level.activ giveMaxAmmo( "m40a3_mp" );
                    level.activ GiveWeapon( "remington700_mp" );
                    level.activ giveMaxAmmo( "remington700_mp" );
               level.activ SwitchToWeapon( "m40a3_mp" );
                    level.activ.maxhealth = 100;

}

                wait 0.05;

            info("Sniper Room", player.name + " ^1VS ^7" + level.activ.name);
            player freezecontrols(true); //Freeze the players when someone enters the room for three seconds.
            level.activ freezecontrols(true);
            wait 1;
            player iPrintlnBold( "^13" );
            level.activ iPrintlnBold( "^13" );
            wait 1;
            player iPrintlnBold( "^32" );
            level.activ iPrintlnBold( "^32" );
            wait 1;
            player iPrintlnBold( "^51" );
            level.activ iPrintlnBold( "^51" );
            wait 1;
            player iPrintlnBold( "^2GO^7!" );
            level.activ iPrintlnBold( "^2GO^7!" );
            player freezecontrols(false); //Disables the freeze.
            level.activ freezecontrols(false);
                while( isAlive( player ) && isDefined( player ) )
                        wait 1;
}
		}
}