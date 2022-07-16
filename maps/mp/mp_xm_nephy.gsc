// MIT License

// Copyright (c) 2020 Fraser Watt

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

//Map created by Neph, scripted by Frazzle

main()
{
	maps\mp\_load::main(); 
 
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	
	thread speedrun\_way_name::create_spawn((-2180, -2910, 574),90);

	//Dvars
	setDvar("r_specularcolorscale", "1");
	setDvar("r_glowbloomintensity0",".1");
	setDvar("r_glowbloomintensity1",".1");
	setDvar("r_glowskybleedintensity0",".1");
	setDvar("g_speed","210");
	setDvar("dr_jumpers_speed" ,"1.1");
	setDvar("bg_fallDamageMaxHeight", "99999"); 
	setDvar("bg_fallDamageMinHeight", "99998");

	//Trap info
	level.trapTriggers = [];
	self.activatedTraps = [];
	self.trapCount = 7;
	//Misc triggers
	self.miscCount = 8;

	//Music info (name, duration)
	self.songs = [];
	self.songs[0] = [];
	self.songs[0][0] = "BLACKPINK - How you like that?";
	self.songs[0][1] = 182;
	self.songs[1] = [];
	self.songs[1][0] = "Stray Kids - Back Door";
	self.songs[1][1] = 189;
	self.songs[2] = [];
	self.songs[2][0] = "Stray Kids - MIROH";
	self.songs[2][1] = 208;
	self.songs[3] = [];
	self.songs[3][0] = "Suga(BTS) - Seesaw";
	self.songs[3][1] = 246;
	self.songs[4] = [];
	self.songs[4][0] = "BLACKPINK - DDU-DU DDU-DU";
	self.songs[4][1] = 215;
	self.songs[5] = [];
	self.songs[5][0] = "SAINt JHN - Roses (imanbek remix)";
	self.songs[5][1] = 177;

	//Map messages
	self.messages = "Map Made By: ^2xM^0#^7Nephy;Thanks to ^1VC'Glen ^7& ^1Frazzle ^7for helping me;Special Thanks to ^9 ^2xM^0#^7rAKy ^7 and ^1... ^7 for testing my map!;There is ^91 ^7normal way on this map and ^10 ^7Secret way on this map!";

	//Room status
	level.roomOccupied = false;

	precacheItem("m40a3_mp");
	precacheItem("remington700_mp"); //sniper room
	precacheItem("knife_mp"); //ss, knife, bounce rooms
	preCacheItem("p90_silencer_mp");
	preCacheItem("ak47_silencer_mp");
	preCacheItem("g36c_silencer_mp");
	preCacheItem("uzi_silencer_mp");
	preCacheItem("mp5_silencer_mp"); //MTAR variants, weapon room
	preCacheItem("wwii_bat");
	preCacheItem("nes_zapper_mp");
	preCacheMenu("frzl_music");
	preCacheMenu("frzl_music_main"); //Custom music menu

	for (id = 0; id < self.trapCount; id++) {
		thread trapData(id);
	}

	for (id = 0; id < self.miscCount; id++) {
		thread miscData(id);
	}

	level waittill("round_started");

	thread timedMessages();
	thread startDoor(10, 5);
}

//Timed informative messages/credits
timedMessages() {
	count = 0;
	messages = strTok(self.messages, ";");

	while (true) {
		iPrintLn("^1>> ^7" + messages[count]);
		count++;
		if (count >= messages.size)
			count = 0;
		wait(10);
	}
}

//Start door
startDoor(interval, time) {
	door = getEnt("startdoor", "targetname");

	iPrintLnBold("Welcome to mp_xm_nephy^7!");
	wait(2);
	iPrintLnBold("^7Map Made By: ^2xM^0#^7Nephy");
	wait(interval - 5);
	iPrintLnBold("^4Opening in...");

	for (i = 3; i > 0; i--) {
		iPrintLnBold("^" + i + "" + i);
		wait(1);
	}

	door moveZ(-335, time);
}

//Thread for moving spinner trap (3rd trap)
spinnerTrap(entity, interval, time) {
	if (interval > 0)
		wait(interval);

	while(true) {
		entity rotateYaw(360, time);
		wait(time);
	}
}

//Trap functionality
trapData(id) {
	self.activatedTraps[id] = false;
	level.trapTriggers[id] = getEnt("trap_" + id + "_trigger", "targetname");

	if (!isDefined(level.trapTriggers[id]))
		return;

	switch(id) { //before activation functionality
		case 1:
			//attach hurt trigger to spikes trap
			spikes = getEnt("trap_" + id + "_spikes", "targetname");
			spikesTrigger = getEnt("trap_" + id + "_hurt", "targetname");
			spikesTrigger enableLinkTo();
			spikesTrigger linkTo(spikes);
			break;
		default:
			break;
	}

	level.trapTriggers[id] waittill("trigger", player);
	self.activatedTraps[id] = true;
	level.trapTriggers[id] delete();

	switch(id) { //after activation functionality
		case 0: //Rotating platform
			platform = getEnt("trap_" + id + "_platform", "targetname");
			while (true) {
				platform rotatePitch(360, 1.2);
				wait(0.7);
			}
		case 1: //Moving spikes
			spikes = getEnt("trap_" + id + "_spikes", "targetname");
			while (true) {
				spikes moveZ(132, 2);
				wait(2);
				spikes moveZ(-132, 2);
				wait(8);
			}
			break;
		case 2: //Moving spinners
			spinners = getEntArray("trap_" + id + "_spinner", "targetname");
			spinInterval = 0.2;
			spinTime = 1.6;			

			for (i = 0; i < spinners.size; i++) {
				thread spinnerTrap(spinners[i], spinInterval, spinTime);
				spinInterval += 0.1;
				spinTime += 0.1;
			}
			break;
		case 3: //Hide bounce
			bounce = getEnt("trap_" + id + "_bounce", "targetname");
			bounce moveX(55, 2);
			break;
		case 4: //Platform removal colour picker
		case 5:
			if (id == 4) //only allow one option to be selected
				level.trapTriggers[5] delete();
			else
				level.trapTriggers[4] delete();
			
			platform = getEnt("trap_" + id + "_platform", "targetname");
			platform moveZ(-864, 2);
			break;
		case 6: //Remove ladder for 5 seconds and return it
			ladder = getEnt("trap_" + id + "_ladder", "targetname");
			ladder hide();
			ladder notSolid();

			wait(5); //wait 5 secs

			ladder show();
			ladder solid();			
			break;
		default:
			break;
	}
}

miscData(id) {
	while (true) {
		miscTrigger = getEnt("misc_" + id + "_trigger", "targetname");

		if (!isDefined(miscTrigger))
			return;

		miscTrigger waittill("trigger", player);

		switch(id) {
			case 0: //Music selection
				player openMenu("frzl_music_main");
				player waittill("menuresponse", menu, response);

				if (menu == "frzl_music_main")
					switch(response) {
						case "1":
						case "2":
						case "3":
						case "4":
						case "5":
						case "6":
							while (true) {
								songData = self.songs[int(response) - 1];
								ambientPlay("frzl_music_" + response);
								iPrintLn("^1>> ^7Now Playing: " + songData[0]);
								wait(songData[1]);
								response = randomIntRange(1, self.songs.size + 1);
							}
							break;
					};
				break;
			case 1:
			case 2:
			case 3:
			case 4: //End rooms
				if (isDefined(player.ghost) && player.ghost) {
					player suicide();
					continue;
				} //kill players in ghost mode

				if (player.pers["team"] == "axis") //only accept jumpers	
					continue;

				//get room participants
				//gen player spawn side
				players = [];
				players[0] = player;
				spawnSide = [];
				spawnSide[0] = randomInt(2);
				spawnSide[1] = 0;
				if (spawnSide[0] == spawnSide[1])
					spawnSide[1] = 1;
				if (isDefined(level.activ) && isAlive(level.activ))
					players[1] = level.activ;
				//get trigger data (room name, spawns count, weapons ...)
				triggerData = strTok(miscTrigger.script_noteworthy, ";");
				//gen random spawn point
				spawnCount = int(triggerData[1]);
				spawnPoint = randomInt(spawnCount);

				//get a list of weapons to give to the player
				weapons = [];
				if (triggerData.size > 3) {
					for (i = 3; i < triggerData.size; i++)
						weapons[weapons.size] = triggerData[i];

					if (triggerData[2] == "1") {
						randomWeaponIdx = randomInt(weapons.size);
						randomWeapon = weapons[randomWeaponIdx];
						weapons = [];
						weapons[0] = randomWeapon;
					} //select random weapon if enabled
				}

				iPrintLnBold("^1" + player.name + " ^7chose ^5" + triggerData[0]); //inform players of room chosen

				for (player = 0; player < players.size; player++) {
					spawn = getEnt("misc_" + id + "_spawn_" + spawnSide[player] + "_" + spawnPoint, "targetname");
					players[player] setOrigin(spawn.origin);
					players[player] setPlayerAngles(spawn.angles);
					players[player] setNormalHealth(100);
					players[player] freezeControls(true);
					players[player] takeAllWeapons();

					if (weapons.size > 0) {
						for (i = 0; i < weapons.size; i++) {
							players[player] giveWeapon(weapons[i]);
							players[player] giveMaxAmmo(weapons[i]);
						}

						players[player] switchToWeapon(weapons[weapons.size - 1]);
					} //give players room weapons
				}

				for (count = 3; count >= 0; count--) {							
					for (player = 0; player < players.size; player++) {
						if (count != 0)
							players[player] iPrintLnBold("^" + count + "" + count);
						else {
							players[player] iPrintLnBold("^5Fight!");
							players[player] freezeControls(false);
						}
					}
					wait(1);
				} //Countdown

				for (side = 0; side < spawnSide.size; side++) //setup in-room teleports
					thread roomTeleportListener(id, side, spawnCount);
				break;
			case 5: //End selection teleport
				if (isDefined(player.ghost) && player.ghost) {
					player suicide();
					continue;
				} //kill players in ghost mode

				if (player.pers["team"] == "axis") //only accept jumpers
					continue;

				if (isDefined(level.disableRoomPlugin) && !level.disableRoomPlugin) { //check if respect plugin is enabled
					if (!respectPluginCheck(player))
						continue;
				} else if (level.roomOccupied)
					continue;

				if (!(isDefined(level.disableRoomPlugin) && !level.disableRoomPlugin)) { //check if respect plugin is disabled
					level.roomOccupied = true;
					player thread roomDeathListener();
				}

				spawn = getEnt("misc_" + id + "_spawn", "targetname");
				player takeAllWeapons();
				player setOrigin(spawn.origin);
				player setPlayerAngles(spawn.angles);
				break;
			case 6: //Bounce room weapon pickup
				weapons = strTok(miscTrigger.script_noteworthy, ";");
				weapon = weapons[1];

				if (weapons.size > 2) {
					randomWeapon = randomIntRange(1, weapons.size);
					weapon = weapons[randomWeapon];
				}

				weaponList = player getWeaponsList();
				hasWeapon = false;

				for (i = 0; i < weaponList.size; i++) {
					if (isSubStr(weaponList[i], weapons[0])) {
						player giveMaxAmmo(weapon);
						player switchToWeapon(weapon);
						hasWeapon = true;
						break;
					}
				} //don't give player the same type of weapon

				if (!hasWeapon) {
					player giveWeapon(weapon);
					player giveMaxAmmo(weapon);
					player switchToWeapon(weapon);
				}
				break;
			case 7: //Secret teleport
				spawn = getEnt("misc_" + id + "_spawn", "targetname");
				player setOrigin(spawn.origin);
				player setPlayerAngles(spawn.angles);				
			default:
				break;
		}

		wait(0.1);
	}
}

//teleport players who fall to a relevant spawn point
roomTeleportListener(roomId, side, spawnCount) {
	trigger = getEnt("misc_" + roomId + "_teleport_" + side, "targetname");

	if (isDefined(trigger))
		while(level.roomOccupied || (isDefined(level.inRoomPlugin) && level.inRoomPlugin)) {
			trigger waittill("trigger", player);
			spawnPoint = randomInt(spawnCount);
			spawn = getEnt("misc_" + roomId + "_spawn_" + side + "_" + spawnPoint, "targetname");
			player setOrigin(spawn.origin);
			player setPlayerAngles(spawn.angles);
		};
}

//listen for player death in end room
roomDeathListener() {
	while (isDefined(self) && isAlive(self)) {
		wait(0.1);
	}

	level.roomOccupied = false;

	if (isDefined(level.activ) && isAlive(level.activ)) {
		spawn = getEnt("activator_wait_area", "targetname");
		level.activ setOrigin(spawn.origin);
		level.activ setPlayerAngles(spawn.angles);		
	} //move activator to waiting room
}

//Respect plugin
respectPluginCheck(player) { //support for _respect plugin
	if (level.finishPosition[level.playerEnterNum].guid != player.guid || level.inRoomPlugin) {
		spawn = getEnt("respect_teleport", "targetname");
		player IPrintLnBold("^1Wait your turn");
		//teleport player here
		player setOrigin(spawn.origin);
		player setPlayerAngles(spawn.angles);
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

	if (isDefined(level.activ) && isAlive(level.activ)) {
		spawn = getEnt("activator_wait_area", "targetname");
		level.activ setOrigin(spawn.origin);
		level.activ setPlayerAngles(spawn.angles);		
	} //move activator to waiting room

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