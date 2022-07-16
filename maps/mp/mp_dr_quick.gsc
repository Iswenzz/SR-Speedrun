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

main() {
	maps\mp\mp_dr_quick_fx::main();
	maps\mp\_load::main();

	thread speedrun\_way_name::create_normal_way("Normal Way;");

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setDvar("bg_FallDamageMaxHeight","99999");
	setDvar("bg_FallDamageMinHeight","99998"); //remove fall dmg

	level.trapTriggers = [];
	level.roomOccupied = false;
	self.activatedTraps = [];
	self.trapCount = 6;
	self.miscCount = 6;

	//secret rewards/offset END

	//Music info (name, duration)
	self.songs = [];
	self.songs[0] = [];
	self.songs[0][0] = "Clean Bandit - Solo";
	self.songs[0][1] = 223;
	self.songs[1] = [];
	self.songs[1][0] = "Armin van Buuren - Blah Blah Blah";
	self.songs[1][1] = 194;
	self.songs[2] = [];
	self.songs[2][0] = "Sean Paul - No Lie";
	self.songs[2][1] = 228;
	self.songs[3] = [];
	self.songs[3][0] = "Human";
	self.songs[3][1] = 197;
	//Music Info End

	//Map messages
	self.messages = "Created by Frazzle.;Discord: frazzle#6627;This was a ^3quick ^7map created in 12hours~";

	precacheItem("m40a3_mp");
	precacheItem("remington700_mp"); //sniper room
	precacheItem("knife_mp"); //knife, bounce rooms
	preCacheItem("mp5_mp"); //weapon room
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
	door = getEntArray("start_door", "targetname");

	wait(interval - 3);

	iPrintLnBold("^4Opening in...");

	for (i = 3; i > 0; i--) {
		iPrintLnBold("^" + i + "" + i);
		wait(1);
	}

	for (i = 0; i < door.size; i++)
		door[i] moveX(int(door[i].script_noteworthy), time);
}

//Remove a row of platforms, animation (trap 4)
removePlatform(amnt, time) {
	self moveZ(amnt, time);
	wait(time);
	self delete();
}

//Move platform (trap 3)
movePlatform(amnt, time, interval) {
	while (true) {
		self moveY(amnt, time);
		wait(time);
		wait(interval);
		self moveY(0 - amnt, time);
		wait(time);
		wait(interval);
	}
}

//Thread for moving spinner trap (trap 1 and 5)
spinnerTrap(axis, amnt, time, interval) {
	if (interval > 0)
		wait(interval);

	while(true) {
		switch(axis) {
			case "pitch":
				self rotatePitch(amnt, time);
				break;
			case "yaw":
				self rotateYaw(amnt, time);
				break;
			default:
				break;
		}
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
		case 0: //Rotating vertical spinners
			//attach hurt trigger to rotating vertical spinners
			for (i = 0; i < 2; i++) {
				spinner = getEnt("trap_" + id + "_spinner_" + i, "targetname");
				spinnerTrigger = getEnt("trap_" + id + "_hurt_" + i, "targetname");
				spinnerTrigger enableLinkTo();
				spinnerTrigger linkTo(spinner);
			}
			break;
		case 3: //Make platform move
			platform = getEnt("trap_" + id + "_platform", "targetname");
			platform thread movePlatform(-384, 1.5, 1);
			break;
		default:
			break;
	}

	level.trapTriggers[id] waittill("trigger", player);
	self.activatedTraps[id] = true;
	level.trapTriggers[id] delete();

	switch(id) { //after activation functionality
		case 0: //Rotating vertical spinners
			rotation = 360;
			for (i = 0; i < 2; i++) {
				spinner = getEnt("trap_" + id + "_spinner_" + i, "targetname");
				spinner thread spinnerTrap("pitch", rotation, 2, 0);
				rotation = 0 - rotation;
			}
			break;
		case 1: //Remove 2 of 4 platforms
			for (i = 0; i < 2; i++) {
				platforms = getEntArray("trap_" + id + "_platform_" + i, "targetname");
				randomPlatform = randomInt(platforms.size);
				platforms[randomPlatform] hide();
				platforms[randomPlatform] notSolid();
			}
			break;
		case 2: //Remove a row of platforms
			randomRow = randomInt(2);
			platforms = getEntArray("trap_" + id + "_platform_" + randomRow, "targetname");
			platformTime = 1;
			for (i = 0; i < platforms.size; i++) {
				platforms[i] thread removePlatform(-336, platformTime);
				platformTime += 0.3;
			}
			break;
		case 3: //Throw players off moving platform
			mover = getEnt("trap_" + id + "_mover", "targetname");
			mover moveX(-640, 1);
			wait(1);
			mover moveX(640, 1);
			break;
		case 4: //Rotating horizontal spinners
			spinners = getEntArray("trap_" + id + "_spinner", "targetname");
			rotation = 360;
			for (i = 0; i < spinners.size; i++) {
				spinners[i] thread spinnerTrap("yaw", rotation, 1.5, 0);
				rotation = 0 - rotation;				
			}
			break;
		case 5: //Ladder removal
			ladders = getEntArray("trap_" + id + "_ladder", "targetname");
			randomLadder = randomInt(ladders.size);
			ladders[randomLadder] hide();
			ladders[randomLadder] notSolid();
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
			case 1: //End Rooms
			case 2:
			case 3:
			case 4:
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
				if (triggerData.size > 2) {
					for (i = 2; i < triggerData.size; i++)
						weapons[weapons.size] = triggerData[i];
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
			case 5: //Bounce room weapon pickup
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