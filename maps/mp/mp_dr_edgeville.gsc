main() {
thread sr\api\_map::createSpawnOrigin((-1047, 57, 15), 0);
	maps\mp\_load::main();

	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	level.brasskey = false;
    level.secret = true;
	level.gas = loadfx("mp_dr_edgeville_dungeon/poison_gas");
	gas1 = getent("trap7_hurt", "targetname");
	gas1 thread maps\mp\_utility::triggerOff();
	gas2 = getEnt("trap8_hurt", "targetname");
	gas2 thread maps\mp\_utility::triggerOff();

    setDvar("bg_falldamagemaxheight", 9999999);
    setDvar("bg_falldamageminheight", 999999);

	if(!isdefined(level.music))
    level.music=[];
    level.music[0]["song"] ="RuneScape Main Theme";
    level.music[0]["alias"] ="track1";
    level.music[1]["song"] ="Gregorovic";
    level.music[1]["alias"] ="track2";
    level.music[2]["song"] ="Anima";
    level.music[2]["alias"] ="track3";
    level.music[3]["song"] ="Attack II";
    level.music[3]["alias"] ="track4";
    level.music[4]["song"] ="Mausoleum";
    level.music[4]["alias"] ="track5";
    level.music[5]["song"] ="Baroque";
    level.music[5]["alias"] ="track6";
	level.music[6]["song"] ="Warriors' Guild";
    level.music[6]["alias"] ="track7";
	level.music[7]["song"] ="Temple Desecrated";
    level.music[7]["alias"] ="track8";
	level.music[8]["song"] ="Army of Darkness";
    level.music[8]["alias"] ="track9";
	level.music[9]["song"] ="Guthix's Hunter";
    level.music[9]["alias"] ="track10";
    level.music[10]["song"] ="Wilderness III";
    level.music[10]["alias"] ="track11";
    level.music[11]["song"] ="Scape Dark";
    level.music[11]["alias"] ="track12";

    thread sr\api\_speedrun::createNormalWays("Normal Way");
    thread sr\api\_speedrun::createSecretWays("Secret Way");
        thread startdoor();
	thread secretdoor();
    thread secretkey();
    thread secret();
    thread secretfail();
    thread secretteleport();
    thread chest();
	thread credits();
	thread brasskey();
	thread spikelighting();
	thread musicBox();
	thread secretsong1();
    thread secretsong2();
	//thread trap1();
	//thread trap2();
	//thread trap3();
	//thread trap4();
	//thread trap5();
	//thread trap6();
	//thread trap7();
	//thread trap8();
	//thread trap9();
    //thread knife();
    //thread sniper();
    //thread shotgun();
    //thread weapon();
    //thread deagle();
    //thread purestart();
    thread yobamossong();
    thread bangzorsong();
    thread niggaballs();
    thread fuckyou();
    thread gnome();

    precacheItem("deserteagle_mp");
    precacheItem("winchester1200_mp");
    precacheItem("ak74u_mp");
    precacheItem("scimitar_mp");
}

gnome() {

    trig = getent ("gnome","targetname");
    trig sethintstring("just a shampoo bottle don't press F");
    trig waittill ("trigger", player);
    ambientplay("gnome");
    trig delete();
    iprintlnbold("get gnomed mf");
}

deagle() {

    level.deagle = getEnt("deagle_trig", "targetname");
    jump = getEnt("jump_origin", "targetname");
    acti = getEnt("acti_origin", "targetname");

    while(1) {

        level.inRoom = false;
        level.deagle setHintString("^3Deagle");
        level.deagle waittill("trigger", player);

            if(!level.inRoom) {

            if(isDefined(level.deagle))
            level.inRoom = true;
            level.inDeagle = true;

                level.sniper delete();
                level.strafe delete();
                level.shotgun delete();
                level.knife delete();
                level.weapon delete();

                wait 0.05;
		        deagle_hud = SpawnStruct();
	    	    deagle_hud.titleText = "Deagle Room";
	    	    deagle_hud.notifyText = player.name + " [^8VS^7] " + level.activ.name;
	    	    deagle_hud.glowcolor = (.1725, .7373, .8);
	    	    deagle_hud.duration = 5;
	    	    players = getEntArray("player", "classname");
	    	    for (i = 0; i < players.size; i++) {
	    	        players[i] thread maps\mp\gametypes\_hud_message::notifyMessage(deagle_hud);
	    	    }

                player SetPlayerAngles(jump.angles);
                player setOrigin(jump.origin);
                player TakeAllWeapons();
                player GiveWeapon("deserteagle_mp");
                player switchToWeapon("deserteagle_mp");
                player.maxhealth = 100;

                if(isDefined(level.activ) && isAlive(level.activ)) {

                    level.activ setPlayerangles(acti.angles);
                    level.activ setOrigin(acti.origin);
                    level.activ TakeAllWeapons();
                    level.activ GiveWeapon("deserteagle_mp");
                    level.activ switchToWeapon("deserteagle_mp");
                    level.activ.maxhealth = 100;
                }

                level.activ freezeControls(true);
                player freezeControls(true);
                wait 3;
                player freezeControls(false);
                level.activ freezeControls(false);

	    	    player waittill("death");
	    	    level.inRoom = false;
        }
    }
}

weapon() {

    level.weapon = getEnt("weapon_trig", "targetname");
    jump = getEnt("jump_origin", "targetname");
    acti = getEnt("acti_origin", "targetname");

    while(1) {

        level.inRoom = false;
        level.weapon setHintString("^3Weapon");
        level.weapon waittill("trigger", player);

            if(!level.inRoom) {

            if(isDefined(level.weapon))
            level.inRoom = true;
            level.inWeapon = true;

                level.sniper delete();
                level.strafe delete();
                level.shotgun delete();
                level.knife delete();
                level.deagle delete();

                wait 0.05;
		        weapon_hud = SpawnStruct();
	    	    weapon_hud.titleText = "Weapon Room";
	    	    weapon_hud.notifyText = player.name + " [^8VS^7] " + level.activ.name;
	    	    weapon_hud.glowcolor = (.1725, .7373, .8);
	    	    weapon_hud.duration = 5;
	    	    players = getEntArray("player", "classname");
	    	    for (i = 0; i < players.size; i++) {
	    	        players[i] thread maps\mp\gametypes\_hud_message::notifyMessage(weapon_hud);
	    	    }

                player SetPlayerAngles(jump.angles);
                player setOrigin(jump.origin);
                player TakeAllWeapons();
                player GiveWeapon("ak74u_mp");
                player switchToWeapon("ak74u_mp");
                player.maxhealth = 100;

                if(isDefined(level.activ) && isAlive(level.activ)) {

                    level.activ setPlayerangles(acti.angles);
                    level.activ setOrigin(acti.origin);
                    level.activ TakeAllWeapons();
                    level.activ GiveWeapon("ak74u_mp");
                    level.activ switchToWeapon("ak74u_mp");
                    level.activ.maxhealth = 100;
                }

                level.activ freezeControls(true);
                player freezeControls(true);
                wait 3;
                player freezeControls(false);
                level.activ freezeControls(false);

	    	    player waittill("death");
	    	    level.inRoom = false;
        }
    }
}

shotgun() {

    level.shotgun = getEnt("shotgun_trig", "targetname");
    jump = getEnt("jump_origin", "targetname");
    acti = getEnt("acti_origin", "targetname");

    while(1) {

        level.inRoom = false;
        level.shotgun setHintString("^3Shotgun");
        level.shotgun waittill("trigger", player);

            if(!level.inRoom) {

            if(isDefined(level.shotgun))
            level.inRoom = true;
            level.inShotgun = true;

                level.sniper delete();
                level.strafe delete();
                level.weapon delete();
                level.knife delete();
                level.deagle delete();

                wait 0.05;
		        shotgun_hud = SpawnStruct();
	    	    shotgun_hud.titleText = "Shotgun Room";
	    	    shotgun_hud.notifyText = player.name + " [^8VS^7] " + level.activ.name;
	    	    shotgun_hud.glowcolor = (.1725, .7373, .8);
	    	    shotgun_hud.duration = 5;
	    	    players = getEntArray("player", "classname");
	    	    for (i = 0; i < players.size; i++) {
	    	        players[i] thread maps\mp\gametypes\_hud_message::notifyMessage(shotgun_hud);
	    	    }

                player SetPlayerAngles(jump.angles);
                player setOrigin(jump.origin);
                player TakeAllWeapons();
                player GiveWeapon("winchester1200_mp");
                player switchToWeapon("winchester1200_mp");
                player.maxhealth = 100;

                if(isDefined(level.activ) && isAlive(level.activ)) {

                    level.activ setPlayerangles(acti.angles);
                    level.activ setOrigin(acti.origin);
                    level.activ TakeAllWeapons();
                    level.activ GiveWeapon("winchester1200_mp");
                    level.activ switchToWeapon("winchester1200_mp");
                    level.activ.maxhealth = 100;
                }

                level.activ freezeControls(true);
                player freezeControls(true);
                wait 3;
                player freezeControls(false);
                level.activ freezeControls(false);

	    	    player waittill("death");
	    	    level.inRoom = false;
        }
    }
}

purestart() {

    level.strafe = getEnt ("trig_purestrafe_room", "targetname");
    orig_jumper = getEnt ("pure_jumper_origin", "targetname");
    orig_acti = getEnt ("pure_activator_origin", "targetname");

    while (1)
    {
        level.strafe setHintString ("^3PureStrafe");
        level.strafe waittill ("trigger", player);

        level.sniper delete();
        level.shotgun delete();
        level.weapon delete();
        level.knife delete();
        level.deagle delete();

        player setOrigin (orig_jumper.origin);
        player setPlayerAngles (orig_jumper.angles);
        player takeAllWeapons();
        player freezecontrols (1);
        player giveWeapon("knife_mp");
        player switchToWeapon ("knife_mp");
        player.maxhealth = 100;

        if(isDefined(level.activ) && isAlive(level.activ))
        {
            level.activ setPlayerAngles(orig_acti.angles);
            level.activ setOrigin(orig_acti.origin);
            level.activ takeAllWeapons();
            level.activ giveWeapon("knife_mp");
            level.activ switchToWeapon("knife_mp");
            level.activ.maxhealth = 100;
            level.activ freezecontrols(1);
        }
        strafe_hud = SpawnStruct();
	    strafe_hud.titleText = "Pure Strafe Room";
	    strafe_hud.notifyText = player.name + " [^8VS^7] " + level.activ.name;
	    strafe_hud.glowcolor = (.1725, .7373, .8);
	    strafe_hud.duration = 5;
	    players = getEntArray("player", "classname");
	    for (i = 0; i < players.size; i++) {
	    	players[i] thread maps\mp\gametypes\_hud_message::notifyMessage(strafe_hud);
	    }
        wait 5;
        player freezecontrols (0);
        level.activ freezecontrols(0);
        thread pureend(player, level.activ);

        while(isAlive(player) && isDefined(player))
            wait .05;

        level notify("strafeend");

        iPrintLnBold ("^3" + player.name + " got shit on");
    }
}

pureend(who, who2)
{
    level endon("strafeend");
    trig = getEnt ("pure_end_trig", "targetname");
    origWin = getEnt ("pure_end_winner", "targetname");
    origLose = getEnt ("pure_end_loser", "targetname");

    while(1)
    {
        trig waittill("trigger", winner);
        winner freezeControls (1);
        winner iPrintLnBold("^3You won !");
        winner setOrigin (origWin.origin);
        winner setPlayerAngles (origWin.angles);
        winner takeAllWeapons();
        wait 2;
        winner freezeControls (0);
        winner giveWeapon("deserteagle_mp");
        winner giveMaxAmmo("deserteagle_mp");
        winner
        switchToWeapon("deserteagle_mp");


        if (winner == who)
            loser = who2;
        else
            loser = who;

        if (isDefined(loser))
        {
            loser setOrigin (origLose.origin);
            loser setPlayerAngles (origLose.angles);
            loser freezeControls (1);
            loser takeAllWeapons();
            loser iPrintLnBold("^3You got shit on");
        }
    }
}

knife() {

    level.knife = getEnt("knife_trig", "targetname");
    jump = getEnt("jump_origin", "targetname");
    acti = getEnt("acti_origin", "targetname");

    while(1) {

        level.inRoom = false;
        level.knife setHintString("^3Knife");
        level.knife waittill("trigger", player);

            if(!level.inRoom) {

            if(isDefined(level.knife))
            level.inRoom = true;
            level.inKnife = true;

            level.sniper delete();
            level.strafe delete();
            level.weapon delete();
            level.shotgun delete();
            level.deagle delete();

                wait 0.05;
		        knife_hud = SpawnStruct();
	    	    knife_hud.titleText = "Knife Room";
	    	    knife_hud.notifyText = player.name + " [^8VS^7] " + level.activ.name;
	    	    knife_hud.glowcolor = (.1725, .7373, .8);
	    	    knife_hud.duration = 5;
	    	    players = getEntArray("player", "classname");
	    	    for (i = 0; i < players.size; i++) {
	    	        players[i] thread maps\mp\gametypes\_hud_message::notifyMessage(knife_hud);
	    	    }

                player SetPlayerAngles(jump.angles);
                player setOrigin(jump.origin);
                player TakeAllWeapons();
                player GiveWeapon("knife_mp");
                player switchToWeapon("knife_mp");
                player.maxhealth = 100;

                if(isDefined(level.activ) && isAlive(level.activ)) {

                    level.activ setPlayerangles(acti.angles);
                    level.activ setOrigin(acti.origin);
                    level.activ TakeAllWeapons();
                    level.activ GiveWeapon("knife_mp");
                    level.activ switchToWeapon("knife_mp");
                    level.activ.maxhealth = 100;
                }

                level.activ freezeControls(true);
                player freezeControls(true);
                wait 3;
                player freezeControls(false);
                level.activ freezeControls(false);

	    	    player waittill("death");
	    	    level.inRoom = false;
        }
    }
}

sniper() {

    level.sniper = getEnt("sniper_trig", "targetname");
    jump = getEnt("jump_origin", "targetname");
    acti = getEnt("acti_origin", "targetname");

    while(1) {

        level.inRoom = false;
        level.sniper setHintString("^3Sniper");
        level.sniper waittill("trigger", player);

        if(!level.inRoom) {

            if( isDefined(level.sniper))
            level.inRoom = true;
            level.inSniper = true;

            level.shotgun delete();
            level.strafe delete();
            level.weapon delete();
            level.knife delete();
            level.deagle delete();

            wait 0.05;
		    sniper_hud = SpawnStruct();
		    sniper_hud.titleText = "Sniper Room";
		    sniper_hud.notifyText = player.name + " [^3VS^7] " + level.activ.name;
		    sniper_hud.glowcolor = (.1725, .7373, .8);
		    sniper_hud.duration = 5;

            players = getEntArray("player", "classname");
		    for (i = 0; i < players.size; i++) {
		        players[i] thread maps\mp\gametypes\_hud_message::notifyMessage(sniper_hud);
		    }

                player SetPlayerAngles(jump.angles);
                player setOrigin(jump.origin);
                player TakeAllWeapons();
                player GiveWeapon("m40a3_mp");
                player giveMaxAmmo("m40a3_mp");
                player GiveWeapon("remington700_mp");
                player giveMaxAmmo("remington700_mp");
                player switchToWeapon("remington700_mp");
                player.maxhealth = 100;

            if(isDefined(level.activ) && isAlive(level.activ)) {

                level.activ setPlayerangles(acti.angles);
                level.activ setOrigin(acti.origin);
                level.activ TakeAllWeapons();
                level.activ GiveWeapon("m40a3_mp");
                level.activ giveMaxAmmo("m40a3_mp");
                level.activ GiveWeapon("remington700_mp");
                level.activ giveMaxAmmo("remington700_mp");
                level.activ SwitchToWeapon("remington700_mp");
                level.activ.maxhealth = 100;
            }

            level.activ freezeControls(true);
            player freezeControls(true);
            wait 3;
            player freezeControls(false);
            level.activ freezeControls(false);

            player waittill("death");
	    	level.inRoom = false;
        }
    }
}

credits () {
	while(1) {
		wait 8;
		iprintln("Mapped and scripted by Liserd");
		wait 8;
		iprintln("Huge thanks to Rex109 for teaching me how to script!");
		wait 8;
		iprintln("My YouTube channel: youtube.com/c/Liserd");
		wait 8;
        iprintln("Thanks to Rex109 for the rune scimitar model");
        wait 8;
	}
}
spikelighting() {
	triga = getEnt("trap1_hurt", "targetname");
    upa = getEnt("trap1", "targetname");
	trigb = getEnt("trap2_hurt", "targetname");
    upb = getEnt("trap2", "targetname");
	trigc = getEnt("trap3_hurt", "targetname");
    wall = getEnt("trap3", "targetname");
	trigf = getEnt("trap6_hurt", "targetname");
    upf = getEnt("trap6", "targetname");
	trigg = getEnt("trap9_hurt", "targetname");
	upg = getEnt("trap9", "targetname");
	triga enablelinkto();
	trigb enablelinkto();
	trigc enablelinkto();
	trigf enablelinkto();
	trigg enablelinkto();
	triga linkto(upa);
	trigb linkto(upb);
	trigc linkto(wall);
	trigf linkto(upf);
	trigg linkto(upg);

	upa moveZ(-100, 0.1);
	upb moveZ(-100, 0.1);
	wall moveY(100, 0.1);
	upf moveZ(-100, 0.1);
	upg moveZ(-100, 0.1);
}

fuckyou() {
    trig = getEnt("fuckyou","targetname");
    trig waittill("trigger",player);

    for(;;)
    {
        trig waittill("trigger",player);
        player iprintlnbold("fuck you");
    }
}

niggaballs() {
    trig = getEnt("niggaballs","targetname");
    trig waittill("trigger",player);

    for(;;)
    {
        trig waittill("trigger",player);
        player iprintlnbold("nigga balls");
    }
}
bangzorsong() {
    trig = getEnt("bangzorsong","targetname");
    trig waittill ("trigger", player);
    ambientplay ("bangzor");
    trig delete();
    wait 6;
    ambientstop();
}

yobamossong() {
    trig = getEnt("yobamossong","targetname");
    trig waittill ("trigger", player);
    ambientplay ("yobamos");
    trig delete();
    wait 5;
    ambientstop();
}
secretsong1() {
	trig = getEnt("tracksecret_trig","targetname");
	trig waittill("trigger",player);
	iPrintlnBold(player.name + "'s Fishing level is 99");
    trig delete();
	ambientPlay("tracksecret");
}

secretsong2() {
    trig = getEnt("tracksecret_trig2","targetname");
	trig waittill("trigger",player);
	iPrintlnBold(player.name + " is a sussy baka");
    trig delete();
	ambientPlay("tracksecret2");
    wait 15;
    ambientStop();
}

chest() {
    trig = getEnt("chest_trigger","targetname");
    chest = getEnt("chest","targetname");
    trig setHintString("Press &&1 to loot chest");
    scim = getEnt("rune_scimitar","targetname");
    while(true)
	{
		trig waittill("trigger",player);
		if(level.brasskey == true)
		{
			chest rotatepitch (30,1);
            trig sethintstring(" ");
            chest waittill ("rotatedone");
            trig sethintstring("Press &&1 for secret weapon");
            trig waittill("trigger", player);
            player giveWeapon("scimitar_mp");
            player switchtoweapon("scimitar_mp");
            trig delete();
            scim delete();
			break;
		}
		else
		player iprintlnbold("It's locked");
	}
}

secretkey() {
    trig = getEnt("key_trig","targetname");
    key = getEnt("secretkey","targetname");
    trig waittill("trigger",player);
    trig delete();
    key delete();
}

secret() {
    trig = getEnt("secret_entrance","targetname");
    tele = getEnt("secret_origin","targetname");
    trig setHintString("Press &&1 to open ^5Gate");
    while(true)
	{
		trig waittill("trigger",player);
		{
            player thread sr\api\_speedrun::changeWay("secret_0");
			player setOrigin(tele.origin);
            player setPlayerAngles(tele.angles);
		}
	}
}

secretfail() {

    trig = getEnt("secret_fail","targetname");
    tele = getEnt("secret_fail_origin","targetname");

    for(;;)
    {
        trig waittill("trigger",player);
        player setOrigin(tele.origin);
        player setPlayerAngles(tele.angles);
    }
}

secretteleport() {

    trig = getEnt("secret_end","targetname");
    tele = getEnt("end_origin","targetname");

    for(;;)
    {
        trig waittill("trigger",player);
        player thread sr\api\_speedrun::finishWay("secret_0");
        player setOrigin(tele.origin);
        player setPlayerAngles(tele.angles);
    }
}

musicBox()
{
    trig=getent("jukebox_trig","targetname");

    trig setHintString("Press &&1 to choose a track");
    trig waittill("trigger",p);
    trig delete();

    p freezecontrols(1);
	p thread musicfix();
    p musicMenu();
}

musicfix()
{
	self waittill( "death" );
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
}

musicMenu()
{
    self endon("disconnect");
    self endon("death");
    self endon("spawned");
    self endon("joined_spectators");
    self endon("music thread terminated");

    self.hud_music = [];
    self.selection = 0;

    i = 0;

    self.hud_music[i] = braxi\_mod::addTextHud(self, 320, 30, 0.93, "center", "top", 1.4);
    self.hud_music[i].sort = 884;
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud(self, 320, 360, 1, "center", "bottom", 1.4);
    self.hud_music[i].sort = 886;
    //self.hud_music[i] setText("Scroll: ^3[{+attack}] ^7| Select: ^3[{+activate}] ^7");

    for(j = 0; j < level.music.size; j++)
    {
        i++;
        self.hud_music[i] = braxi\_mod::addTextHud(self, 320, 230+(j*16), 0.93, "center", "top", 1.4);
        self.hud_music[i].sort = 882;
        self.hud_music[i].font = "objective";
        self.hud_music[i].glowalpha=1;
        if(isdefined(level.randomcolor))
            self.hud_music[i].glowcolor=level.randomcolor;
        else
            self.hud_music[i].glowcolor=(1,0.5,0);

        entry = level.music[j];
        self.hud_music[i] setText(entry["song"]);
    }

    i++;
    self.hud_music[self.hud_music.size] = braxi\_mod::addTextHud(self, 320, 230, 0.4, "center", "top", 1.4);
    self.hud_music[i].sort = 881;
    indicator = self.hud_music[self.hud_music.size-1];
    indicator setShader("white", 550, 17);
    indicator.color=(0,0.7,1);

	wait 0.5;

    while(self.sessionstate == "playing")
    {
        wait 0.1;

        if(self attackButtonPressed())
        {
            self.hud_music[2+self.selection].alpha = 0.93;

            self.selection++;
            if(self.selection >= level.music.size)
                self.selection = 0;

            item = self.hud_music[2+self.selection];
            item.alpha = 1;
            indicator.y = item.y;
        }
        else if(self useButtonPressed())
        {
            iprintln("^6>> ^7Now playing: ^1"+level.music[self.selection]["song"]);
            ambientPlay(level.music[self.selection]["alias"]);
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

startdoor() {
	level waittill( "round_started" );
	iprintlnbold("Get to Edgeville!");
	startdoor = getent("startdoor","targetname");
	startdoor moveZ(-500, 1);
	startdoor waittill ("movedone");
	startdoor delete();
}

brasskey() {
	trig = getEnt("brasskeytrig","targetname");
	key = getEnt("brasskey","targetname");
	trig waittill("trigger",player);
	level.brasskey = true;
	trig delete();
	key delete();
}

secretdoor() {
	doortrig = getEnt("secretdoortrig","targetname");
	leftdoor = getEnt("secretdoor1","targetname");
	rightdoor = getEnt("secretdoor2","targetname");
    doortrig waittill("trigger",player);
    doortrig delete();
	leftdoor rotateyaw (90,1);
	rightdoor rotateyaw (-90,1);
}

trap1() {
	trig = getEnt("trap1_trig", "targetname");
    up = getEnt("trap1", "targetname");
    trig setHintString("Press &&1 to activate floor spikes");
    trig waittill("trigger", player);
    trig setHintString("Activated");

    up moveZ(90, 0.1);
    wait 3;
    up moveZ(-90, 0.1);
}

trap2() {
	trig = getEnt("trap2_trig", "targetname");
    up = getEnt("trap2", "targetname");
    trig setHintString("Press &&1 to activate floor spikes");
    trig waittill("trigger", player);
    trig setHintString("Activated");

    up moveZ(90, 0.1);
    wait 3;
    up moveZ(-90, 0.1);
}

trap3() {
	trig = getEnt("trap3_trig", "targetname");
    wall = getEnt("trap3", "targetname");
    trig setHintString("Press &&1 to activate spear trap");
    trig waittill("trigger", player);
    trig setHintString("Activated");

    wall moveY(-80, 0.1);
    wait 3;
    wall moveY(80, 0.1);
}

trap4() {
	trig = getEnt("trap4_trig", "targetname");
    floor = getEnt("trap4", "targetname");
    trig setHintString("Press &&1 to destroy floors");
    trig waittill("trigger", player);
    trig setHintString("Activated");

	floor delete();
}

trap5() {
	trig = getEnt("trap5_trig", "targetname");
    floor = getEnt("trap5", "targetname");
    trig setHintString("Press &&1 to destroy floors");
	trig waittill("trigger", player);
    trig setHintString("Activated");

	floor delete();
}

trap6() {
	trig = getEnt("trap6_trig", "targetname");
    up = getEnt("trap6", "targetname");
    trig setHintString("Press &&1 to activate floor spikes");
    trig waittill("trigger", player);
    trig setHintString("Activated");

	up moveZ(90, 0.1);
    wait 3;
    up moveZ(-90, 0.1);
}

trap7() {
	trig = getEnt("trap7_trig", "targetname");
    gas = getEntArray("trap7", "targetname");
	hurt = getent("trap7_hurt", "targetname");
    trig setHintString("Press &&1 to release poison gas");
    trig waittill("trigger", player);
    trig setHintString("Activated");
	playfx(level.gas, gas[0].origin);
	playfx(level.gas, gas[1].origin);
	playfx(level.gas, gas[2].origin);
	playfx(level.gas, gas[3].origin);
	wait 3;
	hurt thread maps\mp\_utility::triggerOn();
	wait 14;
	hurt thread maps\mp\_utility::triggerOff();
}

trap8() {
	trig = getEnt("trap8_trig", "targetname");
    gas = getEntArray("trap8", "targetname");
	hurt = getent("trap8_hurt", "targetname");
    trig setHintString("Press &&1 to release poison gas");
    trig waittill("trigger", player);
    trig setHintString("Activated");
	playfx(level.gas, gas[0].origin);
	playfx(level.gas, gas[1].origin);
	playfx(level.gas, gas[2].origin);
	wait 3;
	hurt thread maps\mp\_utility::triggerOn();
	wait 14;
	hurt thread maps\mp\_utility::triggerOff();
}

trap9() {
	trig = getEnt("trap9_trig", "targetname");
    up = getEnt("trap9", "targetname");
    trig setHintString("Press &&1 to activate floor spikes");
    trig waittill("trigger", player);
    trig setHintString("Activated");

    up moveZ(90, 0.1);
    wait 3;
    up moveZ(-90, 0.1);
}