//////////////////////////Map By///////////////////////////////
//               Map & Script by DaiiZed (Nephy)             //
//                                                           //
//   Thx Frazzle & Blade for giving me so script they made   //
///////////////////////////////////////////////////////////////

main()
{
thread sr\api\_map::createSpawn((-1456, 8960, 2124), 90);
thread sr\api\_speedrun::createNormalWays("Normal Way;");
	maps\mp\_load::main();

	game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";
    setdvar( "r_specularcolorscale", "1" );
    setdvar("r_glowbloomintensity0",".25");
    setdvar("r_glowbloomintensity1",".25");
    setdvar("r_glowskybleedintensity0",".3");
	setdvar("bg_fallDamageMaxHeight", "99999");
	setdvar("bg_fallDamageMinHeight", "99998");
	setdvar( "r_specular", "0" );
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");

	addTriggerToList("trap_1_use");
	addTriggerToList("trap_2_use");
	addTriggerToList("trap_3_use");
	addTriggerToList("trap_4_use");
	addTriggerToList("trap_5_1_use");
	addTriggerToList("trap_5_2_use");
	addTriggerToList("trap_6_use");
	addTriggerToList("trap_7_use");
	addTriggerToList("trap_8_use");
	addTriggerToList("trap_9_use");
	addTriggerToList("trap_10_use");



	//Music info (name, duration)
	self.songs = [];
	self.songs[0] = [];
	self.songs[0][0] = "Deaf Kev - Invicible";
	self.songs[0][1] = 181;
	self.songs[1] = [];
	self.songs[1][0] = "Max Brhon - Humanity";
	self.songs[1][1] = 130;
	self.songs[2] = [];
	self.songs[2][0] = "Polo G - I Know";
	self.songs[2][1] = 163;
	self.songs[3] = [];
	self.songs[3][0] = "ENHYPEN - Given Taken";
	self.songs[3][1] = 178;
	self.songs[4] = [];
	self.songs[4][0] = "Cartoon - On & On Feath Daniel Levi";
	self.songs[4][1] = 187;
	self.songs[5] = [];
	self.songs[5][0] = "Hyolyn - See Sea";
	self.songs[5][1] = 145;





	// PRECACHE
    precacheItem("colt45_mp");
	precacheItem("barrett_mp");
	precacheItem("m40a3_mp");
	precacheItem("deserteagle_mp");
	preCacheMenu("frzl_music");
	preCacheMenu("frzl_music_main"); //Custom music menu

    // RANDOM
	thread messages();

	// thread musicbox();
	// TRAPS
	thread trap_1();
	thread trap_2();
	thread trap_3();
    thread trap_4();
    thread trap_5_1();
    thread trap_5_2();
    thread trap_6();
	thread trap_7();
    thread trap_8();
	thread trap_9();
	thread trap_10();


  // ENDROOMS
	// thread endrooms();
	// thread sniperroom();
	// thread kniferoom();
    // thread deagleroom();

	//SECRET


}

addTriggerToList(name)
{
    if(!isDefined(level.trapTriggers)) level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt(name,"targetname");
}



messages()
{
	level waittill("round_started");

	// wait 2;
	// // iprintlnBold("Welcome to ^5xM^0#^7Nephy v2 ^7:3\n^7Made by: ^6N^7ephy aka DaiiZed");
	// wait 2;

	thread startdoor();

	// for(;;)
	// {
	// 	iprintln("^2>> ^7Map Made By: ^6N^7ephy aka DaiiZed");
	// 	wait 30;
	// 	iprintln("^2>> ^7Report any map bug to ^2>> ^1Discord^7 : DaiiZed#6873");
	// 	wait 30;
	// 	iprintln("^2>> ^7Special Thanks to ^1Blade ^7and ^1Frazzle ^7for helping me");
	// 	wait 30;
	//     iprintln("^2>> ^7Map made for ^5xM^0#^7Deathrun");
	// 	wait 30;
	// 	iprintln("^2>> ^7Hope you'll enjoy playing my map");
	// }
}

startdoor()
{
	door = getent("start","targetname");

	// wait 5;
	door movez(-400,5);
	// wait 5;
	door delete();

	// iprintlnbold("Start Door Opened !");
	// wait 5;
	// iprintlnbold("^7Map made for ^5xM^0#^7Deathrun");
}

musicbox()
{
	music = getent("musicbox","targetname");

	music sethintstring("Press ^1[USE]^7 to select music");
	music waittill("trigger", player);
	music delete();

	player openMenu("frzl_music_main");
	player waittill("menuresponse", menu, response);

	while (true)
	{
		songData = self.songs[int(response) - 1];
		ambientPlay("frzl_music_" + response);
		iPrintLn("^1>> ^7Now Playing: " + songData[0]);
		wait(songData[1]);
		response = randomIntRange(1, self.songs.size + 1);
	}
}




// TRAPS

trap_1()
{
	trap1 = getEnt("trap_1", "targetname");
	trig1 = getEnt("trap_1_use", "targetname");
	trig1 setHintString("^2> ^7Press ^1[USE] ^7to activate the rotator ! ^2<");
	// trig1 waittill ("trigger");
	// trig1 setHintString("^2> ^7Trap already ^1USED^2 <");
	// while(1){
	// 	wait 0.1;
	// 	trap1 rotatePitch(180, 1.3);
	// }
}

trap_2()
{
    trap2 = getent("trap_2","targetname");
	trig = getent("trap_2_use","targetname");
    trig setHintString("^2> ^7Press ^1[USE] ^7to delete the slope ^2<");
	// trig waittill("trigger", player);
	// trig setHintString("^2> ^7Trap already ^1USED^2 <");
	// trap2 delete();


}

trap_3()
{
    trap3_1 = getent("trap_3_1","targetname");
	trap3_2 = getent("trap_3_2","targetname");
	trap3_3 = getent("trap_3_3","targetname");
	trig = getent("trap_3_use","targetname");
    trig setHintString("^2> ^7Press ^1[USE] ^7to activate the rotators ^2<");
	// trig waittill("trigger", player);
	// trig setHintString("^2> ^7Trap already ^1USED^2 <");
	// while(1){
    //     wait 0.1;
	// 	trap3_1 rotateYaw (360, 3.5);
	// 	trap3_2 rotateYaw (360, 3.5);
	// 	trap3_3 rotateYaw (360, 3.5);

	// }
}

trap_4()
{
    trap4 = getent("trap_4","targetname");
	trig = getent("trap_4_use","targetname");
    trig setHintString("^2> ^7Press ^1[USE] ^7to raise the spikes ^2<");
	trig waittill("trigger", player);
	// trig setHintString("^2> ^7Trap already ^1USED^2 <");
	// trap4_dmg1 = getent ("trap_4_1", "targetname");
	// trap4_dmg1 enableLinkTo();
	// trap4_dmg1 linkTo(trap4);

	// while(1){

	// 	trap4 movez (150, 1.3);
	// 	trap4 waittill ("movedone");
	// 	trap4 movez (-150, 1.3);
	// 	trap4 waittill ("movedone");
	// 	wait 5;
	// }
}

trap_5_1()
{
	trap5_1 = getent("trap_5_1","targetname");
	trap5_3 = getent("trap_5_3","targetname");
	trap5_2 = getent("trap_5_2","targetname");
	trap5_4 = getent("trap_5_4","targetname");
	trig = getent ("trap_5_1_use","targetname");
	trig2 = getent ("trap_5_2_use","targetname");

	// {
	// 	trig setHintString("^2> ^7Press ^1[USE] ^7to delete the white bounce ^2<");
   	//  	trig waittill("trigger", player);
	// 	trig setHintString("^2> ^7Trap already ^1USED^2 <");
	// 	trap5_2 delete();
	// 	trap5_4 delete();
	// 	trig2 delete();
    // }
}

trap_5_2()
{
	trap5_1 = getent("trap_5_1","targetname");
	trap5_3 = getent("trap_5_3","targetname");
	trap5_2 = getent("trap_5_2","targetname");
	trap5_4 = getent("trap_5_4","targetname");
	trig2 = getent ("trap_5_1_use","targetname");
	trig = getent ("trap_5_2_use","targetname");

	// {
	// 	trig setHintString("^2> ^7Press ^1[USE] ^7to delete the black bounce ^2<");
    // 	trig waittill("trigger", player);
	// 	trig setHintString("^2> ^7Trap already ^1USED^2 <");
	// 	trap5_1 delete();
	// 	trap5_3 delete();
	// 	trig2 delete();

	// }
}




trap_6()
{
	trap6 = getent("trap_6","targetname");
	trap6_1 = getent("trap_6_1","targetname");
	trig = getent ("trap_6_use","targetname");
	// {
	// 	trig setHintString("^2> ^7Press ^1[USE] ^7to separate the stairs ^2<");
	// 	trig waittill ("trigger");
	// 	trig setHintString("^2> ^7Trap already ^1USED^2 <");
	// 	wait 0.1;
	// 	trap6 movex(96, 1, .5, .5);
	// 	trap6_1 movex(-96, 1, .5, .5);
	// }
}


trap_7()
{
	trap7 = getent("trap_7","targetname");
	trig = getent ("trap_7_use","targetname");
	trig setHintString("^2> ^7Press ^1[USE] ^7to make the bounce spin ^2<");
    // trig waittill("trigger", player);
	// trig setHintString("^2> ^7Trap already ^1USED^2 <");

	// while(1){
	// 	wait 0.1;
	// 	trap7 rotateYaw (360, 3.5);
	//     trap7 waittill ("movedone");
	// 	wait 3;
    // }
}

trap_8()
{
	trap8 = getent("trap_8","targetname");
	trig = getent ("trap_8_use","targetname");
	trig setHintString("^2> ^7Press ^1[USE] ^7to activate the swipers ^2<");
    // trig waittill("trigger", player);
	// trig setHintString("^2> ^7Trap already ^1USED^2 <");

	// while(1){
	// 	wait 0.1;
	// 	trap8 rotatePitch (360, 2.5);

    // }
}

trap_9()
{
	trap8 = getent("trap_9","targetname");
	trig = getent ("trap_9_use","targetname");
	trig setHintString("^2> ^7Press ^1[USE] ^7to make the bridge disappear ^2<");
    // trig waittill("trigger", player);
	// trig setHintString("^2> ^7Trap already ^1USED^2 <");

	// {
	// 	wait 0.1;
	// 	trap8 delete();

    // }
}

trap_10()
{
	trap10 = getent("trap_10","targetname");
	trig = getent ("trap_10_use","targetname");
	trig setHintString("^2> ^7Press ^1[USE] ^7to make to platform rotate ^2<");
    // trig waittill("trigger", player);
	// trig setHintString("^2> ^7Trap already ^1USED^2 <");

	// while(1){
	// 	wait 0.1;
	// 	trap10 rotateYaw (360, 2.5);

    // }
}



RoomDeath()
{
	self common_scripts\utility::waittill_any("death","disconnect");
	iPrintLnBold("^2"+self.name+" ^7is dead ^2!");
	iPrintLnBold("^2Selection Room ^7is now ^7open^2!!!");
}

endrooms()
{
	end_game_selection = getent("trig_end","targetname");
	end_game_target = getent("origin_end","targetname");

	while(1)
	{
		end_game_selection waittill("trigger",who);
		if(!isdefined(end_game_selection))
			return;

        if (isDefined(who.ghost) && who.ghost) {
            who suicide();
            continue;
        } //kill players in ghost mode

        if (who.pers["team"] == "axis") //only accept jumpers
            continue;

        if (isDefined(level.disableRoomPlugin) && !level.disableRoomPlugin) { //check if respect plugin is enabled
            if (!respectPluginCheck(who))
                continue;
        }

		if(!isdefined(level.xm_spaceship_first))
		{
			level.xm_spaceship_first = true;
			iprintlnbold("^2"+who.name+"^7 has entered the ^2Game Selection^7!");
		}
		else
			iprintlnbold("^2"+who.name+"^7 has entered the ^2Game Selection^7!");

		who setorigin(end_game_target.origin);
		who setplayerangles(end_game_target.angles);
		who takeallweapons();

		who RoomDeath();
		while(isAlive(who) && isDefined(who))
            wait 1;

	}
}





deagleroom()
{
	level.deagle = getent("trig_deagle","targetname");
	acti = getent("origin_actideagle","targetname");
	jump = getent("origin_jumperdeagle","targetname");

	level.deagle setHintString("^1>>^7 Press ^1&&1 ^7 to Enter The ^2Deagle ^7Room!");
	while(1)
	{
		level.deagle waittill("trigger", player);

		if(!isdefined(level.sniper))
			return;

		if(isdefined(level.activ))
        {
		    player room_setup(jump,"deserteagle_mp",undefined,"yes",1);
            level.activ room_setup(acti,"deserteagle_mp",undefined,"yes",1);
			iprintln("^2"+player.name+"^7 has entered the ^2Deagle^7!");
            noti = SpawnStruct();
            noti.titleText = "Deagle Room";
            noti.notifyText = "^7"+level.activ.name+" ^1vs ^7"+player.name;
            noti.duration = 6;
            noti.glowcolor = (1,0,1);
            players = getEntArray("player", "classname");
            for(i=0;i<players.size;i++)
            	players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );

 			wait 1;
           	player iPrintLnBold("^63");
			level.activ iPrintLnBold("^23");
			wait 1;
			player iPrintLnBold("^62");
			level.activ iPrintLnBold("^22");
			wait 1;
			player iPrintLnBold("^61");
			level.activ iPrintLnBold("^21");
			wait 1;
			player iPrintLnBold("^1FIGHT!");
			level.activ iPrintLnBold("^1FIGHT!");

            player freezecontrols(0);
            level.activ freezecontrols(0);
        }
        else
        {
            player room_setup(jump,"deserteagle_mp",undefined,"yes",1);

            iprintln("^2"+player.name+"^7 has entered the ^2Deagle^7!");
			wait 1;
           	player iPrintLnBold("^23");
			wait 1;
			player iPrintLnBold("^22");
			wait 1;
			player iPrintLnBold("^21");
			wait 1;
			player iPrintLnBold("^1FIGHT!");

            player freezecontrols(0);
        }

		while(isAlive(player) && isDefined(player))
            wait 1;

        iPrintLnBold("^6"+player.name+" ^7is dead ^6!");
	}
}

sniperroom()
{
	level.sniper = getent("trig_sniper","targetname");
	acti = getent("origin_actisnip","targetname");
	jump = getent("origin_jumpersnip","targetname");

	level.sniper setHintString("^1>>^7 Press ^1&&1 ^7 to Enter The ^2Sniper ^7Room!");
	while(1)
	{
		level.sniper waittill("trigger", player);

		if(!isdefined(level.sniper))
			return;

		if(isdefined(level.activ))
        {
		    player room_setup(jump,"m40a3_mp","remington700_mp","yes",1);
            level.activ room_setup(acti,"remington700_mp","m40a3_mp","yes",1);
			iprintln("^2"+player.name+"^7 has entered the ^2Sniper^7!");
            noti = SpawnStruct();
            noti.titleText = "Sniper Room";
            noti.notifyText = "^7"+level.activ.name+" ^1vs ^7"+player.name;
            noti.duration = 6;
            noti.glowcolor = (1,0,1);
            players = getEntArray("player", "classname");
            for(i=0;i<players.size;i++)
            	players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );

 			wait 1;
           	player iPrintLnBold("^63");
			level.activ iPrintLnBold("^23");
			wait 1;
			player iPrintLnBold("^62");
			level.activ iPrintLnBold("^22");
			wait 1;
			player iPrintLnBold("^61");
			level.activ iPrintLnBold("^21");
			wait 1;
			player iPrintLnBold("^1FIGHT!");
			level.activ iPrintLnBold("^1FIGHT!");

            player freezecontrols(0);
            level.activ freezecontrols(0);
        }
        else
        {
            player room_setup(jump,"m40a3_mp","remington700_mp","yes",1);

            iprintln("^2"+player.name+"^7 has entered the ^2Sniper^7!");
			wait 1;
           	player iPrintLnBold("^23");
			wait 1;
			player iPrintLnBold("^22");
			wait 1;
			player iPrintLnBold("^21");
			wait 1;
			player iPrintLnBold("^1FIGHT!");

            player freezecontrols(0);
        }

		while(isAlive(player) && isDefined(player))
            wait 1;

        iPrintLnBold("^6"+player.name+" ^7is dead ^6!");
	}
}

kniferoom()
{
	level.knife = getent("trig_knife","targetname");
	acti = getent("origin_actiknife","targetname");
	jump = getent("origin_jumperknife","targetname");

	level.knife setHintString("^1>>^7 Press ^1&&1 ^7 to Enter The ^2Knife ^7Room!");
	while(1)
	{
		level.knife waittill("trigger", player);

		if(!isdefined(level.knife))
			return;

		if(isdefined(level.activ))
        {
			player room_setup(jump,"knife_mp","hands_mp","yes",1);
            level.activ room_setup(acti,"knife_mp","hands_mp","yes",1);
			iprintln("^2"+player.name+"^7 has entered the ^2Knife^7!");
            noti = SpawnStruct();
            noti.titleText = "Knife Room";
            noti.notifyText = "^7"+level.activ.name+" ^1vs ^7"+player.name;
            noti.duration = 6;
            noti.glowcolor = (1,0,1);
            players = getEntArray("player", "classname");
            for(i=0;i<players.size;i++)
            	players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );

 			wait 1;
           	player iPrintLnBold("^63");
			level.activ iPrintLnBold("^23");
			wait 1;
			player iPrintLnBold("^62");
			level.activ iPrintLnBold("^22");
			wait 1;
			player iPrintLnBold("^61");
			level.activ iPrintLnBold("^21");
			wait 1;
			player iPrintLnBold("^1FIGHT!");
			level.activ iPrintLnBold("^1FIGHT!");

            player freezecontrols(0);
            level.activ freezecontrols(0);
        }
        else
        {
            player room_setup(jump,"knife_mp","hands_mp","yes",1);

            iprintln("^2"+player.name+"^7 has entered the ^2Knife^7!");
			wait 1;
           	player iPrintLnBold("^23");
			wait 1;
			player iPrintLnBold("^22");
			wait 1;
			player iPrintLnBold("^21");
			wait 1;
			player iPrintLnBold("^1FIGHT!");

            player freezecontrols(0);
        }

		while(isAlive(player) && isDefined(player))
            wait 1;

        iPrintLnBold("^6"+player.name+" ^7is dead ^6!");
	}
}





// If you use 2 Weapons as in maybe sniper room
// player room_setup(jump,"m40a3_mp","remington700_mp","yes",1);
//
// If you use 1 Weapon as in Bounce or Knife
//player room_setup(jump,"knife_mp",undefined,"yes",1);
room_setup(targ,weap,weap2,health,freeze)
{
    self setorigin(targ.origin);
    self setplayerangles(targ.angles);

    self takeallweapons();
    self giveweapon(weap);
    self switchtoweapon(weap);
    self givemaxammo(weap);

    if(isdefined(weap2))
    {
        self giveweapon(weap2);
        self givemaxammo(weap2);
    }

    self freezecontrols(freeze);

    if( health == "yes")
    {
        if(self.health < self.maxhealth)
            self.health=self.maxhealth;
    }
}




//Respect plugin
respectPluginCheck(player) { //support for _respect plugin
	if (level.finishPosition[level.playerEnterNum].guid != player.guid || level.inRoomPlugin) {
		player IPrintLnBold("^1Wait your turn");
		//teleport player here
		player setOrigin((180, 9675, 2160));
		return false;
	}

	player notify("romm_enter_plugin"); //stop the onQueueDeath check
	level.inRoomPlugin = true;
	player thread respectPluginOnRoomDeath();
	respectPluginUpdateHud();
	return true;
}

respectPluginOnRoomDeath() {
	while(isAlive(self) && isDefined(self))
		wait(0.1);
	level.playerEnterNum++;
	level.inRoomPlugin = false;

	respectPluginUpdateHud();
}

respectPluginUpdateHud() {
	queueStr = "";

	if (isDefined(level.finishPosition[level.playerEnterNum]))
		queueStr += "^7[ ^5Current Player ^7]^7\n" + level.finishPosition[level.playerEnterNum].name + "\n\n^7[ ^5Queue ^5^7]^7\n";
	for (i = level.playerEnterNum; i < level.finishPosition.size; i++)
		queueStr += "^7" + level.finishPosition[i].name + "\n";
	level.queueHud SetText(queueStr);
}