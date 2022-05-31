#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include braxi\_common;
#include braxi\_dvar;
#include sr\sys\_common;

main()
{
	setDvar("sv_consayname", "^5#SR: ^7");
	setDvar("sv_contellname", "^5#SR^7->^5PM: ^7");

	sr\_main::main();
	braxi\_mod::main();

	thread sr\weapons\_main::main();
	thread speedrun\game\_leaderboard::loadTimes();
	thread sr\game\_fx_triggers::init();
	thread sr\sys\_admins::init();
	thread sr\misc\_spam::init();
	thread sr\sys\mapsetting::init();
	thread sr\sys\maptriggers::init();
	thread sr\game\_race::init();
	thread sr\game\_kz::init();
	thread vipList();
}

getXpBar()
{
	self waittill("spawned_player");

	if (!isDefined(self.getxpbar))
	{
		self clientcmd("setu sr_xp_bar 0");
		self.getxpbar = true;
	}
}

connectMessages()
{
	self endon("disconnect");
	wait 2;

	if (self.pers["team"] != "allies")
		return;

	rank = "^7Player";
	loc = self getgeolocation(2);
	wait 1;

	switch (self.admin_group)
	{
		case "owner":
			rank = "^5Owner";
			break;

		case "masteradmin":
			rank = "^9Master Admin";
			break;

		case "adminplus":
			rank = "^1Admin+";
			break;

		case "admin":
			rank = "^6Admin";
			break;

		case "member":
			rank = "^3Member";
			break;

		case "donator":
			rank = "^2Donator";
			break;

	}
	wait 0.2;
	exec("say  ^2Welcome^7 " + rank + " ^7" + self.name + " from^1 " + loc);
}

adminStuff()
{
	if (!isDefined(self.admin_group))
		return;

	switch (self.admin_group)
	{
		case "owner":
			self thread adminPickup();

			self thread sr\game\_owner::event();
			self thread noclip_check();
			break;
		case "masteradmin":
			self thread adminPickup();
			break;

		case "adminplus":
		case "admin":
		case "member":
			break;
	}
}

noclip_check()
{
	self endon("disconnect");
	self.noclip_ent = spawn("script_origin", (0, 0, 0));
	self.noclip_isLinked = false;

	while (true)
	{
		while (!isDefined(self.noclip))
		{
			if (self.noclip_isLinked)
			{
				self.disableAntiEle = true;
				self.noclip_isLinked = false;
				self unlink();
			}
			wait 1;
		}

		while (self fragButtonPressed())
		{
			if (!self.noclip_isLinked)
			{
				self.noclip_isLinked = true;
				self.disableAntiEle = false;
				self.noclip_ent.origin = self getOrigin();
				self linkTo(self.noclip_ent);
			}

			speed = 70;
			if (self useButtonPressed())
				speed = 300;
			newPos = self getOrigin() + (anglesToForward(self getPlayerAngles()) * speed);
			self.noclip_ent moveTo(newPos, 0.05);
			wait 0.1;
		}
		wait 0.1;
	}
}

adminPickup()
{
	self endon("disconnect");
	self.pickupMode = 0;

	while (1)
	{
		wait 0.1;
		while (!self secondaryoffhandButtonPressed())
			wait 0.05;

		start = self getEye();
		end = start + maps\mp\_utility::vector_scale(anglestoforward(self getPlayerAngles()), 999999);
		trace = bulletTrace(start, end, true, self);
		dist = distance(start, trace["position"]);

		ent = trace["entity"];

		if (!isDefined(ent))
		{
			wait 0.05;
			continue;
		}

		if (!IsPlayer(ent))
		{
			if (!isDefined(ent.originalPlace))
				ent.originalPlace = ent GetOrigin();
		}

		if (isDefined(ent))
		{
			linker = spawn("script_origin", trace["position"]);
			ent linkto(linker);

			if (isDefined(ent.targetname))
				self iprintlnbold(ent.targetname);

			while (self secondaryoffhandButtonPressed())
			{
				wait 0.05;
			}

			while (!self secondaryoffhandButtonPressed() && isDefined(ent))
			{
				if (self UseButtonPressed())
				{
					if (self.pickupMode == 0)
					{
						self.pickupMode = 1;
						self IPrintLnBold("Roate Yaw");
					}
					else if (self.pickupMode == 1)
					{
						self.pickupMode = 2;
						self IPrintLnBold("Roate Pitch");
					}
					else if (self.pickupMode == 2)
					{
						self.pickupMode = 3;
						self IPrintLnBold("Roate Roll");
					}
					else if (self.pickupMode == 3)
					{
						self.pickupMode = 4;
						self IPrintLnBold("Reset");
					}
					else if (self.pickupMode == 4)
					{
						self.pickupMode = 0;
						self IPrintLnBold("Change distance");
					}
					wait 0.1;
				}

				start = self getEye();
				end = start + maps\mp\_utility::vector_scale(anglestoforward(self getPlayerAngles()), dist);
				trace = bulletTrace(start, end, false, ent);
				dist = distance(start, trace["position"]);

				if (self.pickupMode == 0)
				{

					if (self fragButtonPressed() && !self MeleeButtonPressed())
						dist -= 15;
					else if (self fragButtonPressed() && self MeleeButtonPressed())
						dist += 15;
				}
				if (self.pickupMode == 1)
				{
					ang = linker.angles;

					if (self fragButtonPressed() && !self MeleeButtonPressed())
					{
						if (ang[2] == 180)
							linker rotateTo((ang[0], ang[1], -180), 0.05);
						else
							linker rotateTo((ang[0], ang[1], ang[2] + 2), 0.05);
					}
					else if (self fragButtonPressed() && self MeleeButtonPressed())
					{
						if (ang[2] == -180)
							linker rotateTo((ang[0], ang[1], 180), 0.05);
						else
							linker rotateTo((ang[0], ang[1], ang[2] - 2), 0.05);
					}
				}
				if (self.pickupMode == 2)
				{
					ang = linker.angles;

					if (self fragButtonPressed() && !self MeleeButtonPressed())
					{
						if (ang[1] == 180)
							linker rotateTo((ang[0], -180, ang[2]), 0.05);
						else
							linker rotateTo((ang[0], ang[1] + 2, ang[2]), 0.05);
					}
					else if (self fragButtonPressed() && self MeleeButtonPressed())
					{
						if (ang[1] == -180)
							linker rotateTo((ang[0], 180, ang[2]), 0.05);
						else
							linker rotateTo((ang[0], ang[1] - 2, ang[2]), 0.05);
					}
				}
				if (self.pickupMode == 3)
				{
					ang = linker.angles;

					if (self fragButtonPressed() && !self MeleeButtonPressed())
					{
						if (ang[0] == 180)
							linker rotateTo((-180, ang[1], ang[2]), 0.05);
						else
							linker rotateTo((ang[0] + 2, ang[1], ang[2]), 0.05);
					}
					else if (self fragButtonPressed() && self MeleeButtonPressed())
					{
						if (ang[0] == -180)
							linker rotateTo((180, ang[1], ang[2]), 0.05);
						else
							linker rotateTo((ang[0] - 2, ang[1], ang[2]), 0.05);
					}
				}
				if (self.pickupMode == 4)
				{
					if (self fragButtonPressed() && !IsPlayer(ent))
					{
						ent unlink();
						ent MoveTo(ent.originalPlace, 0.05);
						ent rotateTo((0, 0, 0), 0.05);
						break;
					}
				}
				end = start + maps\mp\_utility::vector_Scale(anglestoforward(self getPlayerAngles()), dist);
				trace = bulletTrace(start, end, false, ent);
				linker.origin = trace["position"];

				wait 0.05;
			}

			if (isDefined(ent))
				ent unlink();
			linker delete();
		}

		while (self secondaryoffhandButtonPressed())
			wait 0.05;
	}
}

onConnect()
{
	// if (self checkBanned())
	// 	return;

	self thread sr\_main::onConnect();
	self thread sr\weapons\_main::self_setup();
	self thread sr\player\_id::checkid();
	self thread speedrun\_main::checkVIP();
	// self thread setGroup();
	self thread sr\player\_settings::onConnect();
	self thread speedrun\_main::adminStuff();

	self.pers["fullbright"] = 0;
	self.pers["fovscale"] = 0;
	self.pers["fxenabled"] = 1;
	self.pers["login"] = false;

	self.pb_190 = [];
	self.pb_210 = [];

	if (isDefined(level.normal_way) && isDefined(level.normal_way.size))
	{
		for (j = 0; j < level.normal_way.size; j++)
		{
			self.pb_190["ns_" + j] = [];
			self.pb_210["ns_" + j] = [];
		}
	}

	if (isDefined(level.secret_way) && isDefined(level.secret_way.size))
	{
		for (j = 0; j < level.secret_way.size; j++)
		{
			self.pb_190["s_" + j] = [];
			self.pb_210["s_" + j] = [];
		}
	}

	self.sr_speed = 190;
	self.voteCoolDown = getTime();
	self.sr_cheatmode = false;
	self.sr_practise = false;
	self.raceWon = 0;
	self.wonKz = false;
	self.kzWon = 0;
	self.inRaceDead = false;
	self.inRaceFinish = false;
	self.inRace = false;
	self.inKz = false;
	self.sr_savePos = [];

	self setClientDvar("cl_maxpackets", 125);
	self setClientDvar("rate", 25000);

	if (!self.isBot)
		self thread sr\player\_id::checkid();

	self speedrun\game\_leaderboard::loadPersonBest();
	self thread sr\api\_map::way_name_default();
	self thread sr\api\_map::way_name();
	self thread getFps();
	self thread getXpBar();
}

onPlayerSpawned()
{
	self thread setSpeed();
	self setContents(0);
	self.sr_way = "ns0";
	self.sr_secret = false;
	self thread speedrun\player\_hud_speedrun::hud();
	self thread updateRunHuds();

	if (!self.sr_cheatmode)
	{
		self.runNumber = RandomInt(999999);
		self thread watchWay();
	}
	self thread speedrun\player\_hud_cheat::hud();

	self.stop_demo = false;
	self.fps = "125";
	self thread wait_record();
	self thread stop_2min();

	if (isDefined(self.vip))
	{
		self.statusicon = "vip_status";
		self thread spawnTrail();
	}
}

updateRunHuds()
{
	if (self.inRace)
	{
		self.runNumber = "Race Mode";
		wait 0.3;
		if (isDefined(self.huds.speedrun[5]))
			self.huds.speedrun[5] setText("^2Race Mode");
	}
	else if (self.inKz)
	{
		self.runNumber = "KillZone Mode";
		wait 0.3;
		if (isDefined(self.huds.speedrun[5]))
			self.huds.speedrun[5] setText("^6KillZone Mode");
	}
	else if (self.sr_practise)
	{
		self.runNumber = "Practise Mode";
		self thread sr\player\_practise::init();
		wait 0.3;
		if (isDefined(self.huds.speedrun[5]))
			self.huds.speedrun[5] setText("^1Practise Mode");
	}
}

wait_record()
{
	self endon("death");
	self endon("disconnect");
	mapname = getDvar("mapname");

	if (mapname == "mp_dr_train_rush")
		return;

	wait 1;
	self thread record();
}

stop_2min()
{
	self endon("death");
	self endon("disconnect");

	wait 120;
	stoprecord_delete();
}

record()
{
	if (self.isBot)
		return;

	mapname = getDvar("mapname");
	if (mapname.size > 17)
		mapname = GetSubStr(mapname, mapname.size - 17, mapname.size);

	if (isStringInt(self.runNumber))
		exec("record " + self GetEntityNumber() + " ./" + getDvar("fs_game") + "/sr/data/speedrun/demos/" + self.id + "/" + mapname + "/" + self.runNumber);

	self thread speedrun\game\_bot::record_txt();
}

stoprecord_save()
{
	exec("stoprecord " + self GetEntityNumber());
}

stoprecord_delete()
{
	if (!isDefined(self.stop_demo))
		return;
	if (self.stop_demo)
		return;

	mapname = getDvar("mapname");
	if (mapname.size > 17)
		mapname = GetSubStr(mapname, mapname.size - 17, mapname.size);
	exec("stoprecord " + self GetEntityNumber());
	path = "./sr/data/speedrun/demos/" + self.id + "/" + mapname + "/" + self.runNumber + ".dm_1";
	path2 = "./sr/data/speedrun/txt_demos/" + mapname + "/" + self.runNumber + ".txt";
	file_exists = checkfile(path);
	file_exists2 = checkfile(path2);

	if (!file_exists)
		return;

	deleteFile_late(path);

	if (!file_exists2)
		return;

	deleteFile_late(path2);
}

stoprecord_death()
{
	if (self.stop_demo)
		return;

	mapname = getDvar("mapname");
	if (mapname.size > 17)
		mapname = GetSubStr(mapname, mapname.size - 17, mapname.size);
	exec("stoprecord " + self GetEntityNumber());
	path = "./sr/data/speedrun/demos/" + self.id + "/" + mapname + "/" + self.runNumber + ".dm_1";
	path2 = "./sr/data/speedrun/txt_demos/" + mapname + "/" + self.runNumber + ".txt";
	file_exists = checkfile(path);
	file_exists2 = checkfile(path2);

	if (!file_exists)
		return;

	deleteFile_late(path);

	if (!file_exists2)
		return;

	deleteFile_late(path2);
}

stoprecord_disconnect()
{
	if (!isDefined(self) || !isDefined(self.stop_demo))
		return;
	if (self.stop_demo)
		return;

	mapname = getDvar("mapname");
	if (mapname.size > 17)
		mapname = GetSubStr(mapname, mapname.size - 17, mapname.size);
	path = "./sr/data/speedrun/demos/" + self.id + "/" + mapname + "/" + self.runNumber + ".dm_1";
	path2 = "./sr/data/speedrun/txt_demos/" + mapname + "/" + self.runNumber + ".txt";
	file_exists = checkfile(path);
	file_exists2 = checkfile(path2);

	if (!file_exists)
		return;

	deleteFile_late(path);

	if (!file_exists2)
		return;

	deleteFile_late(path2);
}

spawnTrail()
{
	self endon("death");
	self endon("disconnect");

	if (isDefined(self.trailTag))
	{
		self.trailTag Unlink();
		self.trailTag Delete();
	}
	wait 0.1;
	while (1)
	{
		self.trailTag = spawn("script_model", self.origin);
		self.trailTag setmodel("tag_origin");
		wait 0.05;
		self.trailTag linkto(self);

		if (self.vip_trail != 0)
			PlayFXOnTag(level.fx["viptrail" + self.vip_trail], self.trailTag, "tag_origin");

		wait 10;
		self.trailTag Unlink();
		self.trailTag delete();
	}
}

checkVIP()
{
	if (!isDefined(self.id))
	{
		IPrintLn("^1PLAYER HAS NO ID");
		return;
	}
	path = "./sr/data/admin/vip.txt";
	file_exists = checkfile(path);
	if (!file_exists)
	{
		IPrintLn("^1NO VIP FILE");
		return;
	}
	r = readAll(path);
	for (i = 0; i < r.size; i++)
	{
		a = StrTok(r[i], "\\");
		if (isDefined(a[0]))
		{
			if (self.id == a[0])
			{
				self.vip = true;
				self.vip_trail = self getStat(1570);
				self setStat(2360, 1);
				return;
			}
		}
	}
}

vipList()
{
	level.viplist = [];
	path = "./sr/data/admin/vip.txt";
	file_exists = checkfile(path);
	if (!file_exists)
	{
		IPrintLn("^1NO VIP FILE");
		return;
	}
	level.viplist = readAll(path);
}

getFps()
{
	if (!isDefined(self.getfps))
	{
		self clientcmd("setu com_maxfps 125");
		self.getfps = true;
	}
}

setSpeed()
{
	if (isDefined(level.slide_map) && isDefined(level.slide_map_multiplier))
	{
		speed = 1.0;

		if (self.sr_speed == 210)
			speed = 1.8;

		else if (self.sr_speed == 190)
			speed = 1.0;

		self setgravity(1000);
		self setjumpheight(70);
		self setMoveSpeedScale(speed);
		self setmovespeed(190 * level.slide_map_multiplier);
		return;
	}
	speed = 1.05;

	if (self.sr_speed == 210)
	{
		self setmovespeed(210);
		if (!isDefined(level.fixedgrav))
			self setgravity(800);
		speed = 1.12;
	}

	else if (self.sr_speed == 190)
	{
		self setmovespeed(190);
		if (!isDefined(level.fixedgrav))
			self setgravity(800);
		speed = 1.05;
	}

	self setMoveSpeedScale(speed);
}

watchWay()
{
	self endon("disconnect");
	self endon("death");
	self endon("joined_spectators");

	if (isDefined(level.new_leaderboard))
	{
		self thread watchWay_new();
		return;
	}
	x = self.sr_secret;

	while (1)
	{
		if (x != self.sr_secret)
		{
			x = self.sr_secret;

			if (!self.sr_secret)
				self.sr_way = "ns0";
			if (self.sr_secret)
				self.sr_way = "s0";

			self thread speedrun\player\_hud_speedrun::updatePB();
			self thread speedrun\player\_hud_speedrun::updateWR();

			if (isDefined(self.huds.speedrun[5]))
				self.huds.speedrun[5] setText(level.secret_way[0].name);
		}
		wait 0.1;
	}
}

watchWay_new()
{
	self endon("disconnect");
	self endon("death");
	self endon("joined_spectators");

	x = self.sr_way;

	while (1)
	{
		if (x != self.sr_way)
		{
			x = self.sr_way;
			way = isSubStr(x, "ns");

			if (way)
			{
				way = strTok(x, "ns");
				number = way[0];
				secret = false;
			}

			else
			{
				way = strTok(x, "s");
				number = way[0];
				secret = true;
			}

			self thread speedrun\player\_hud_speedrun::updatePB();
			self thread speedrun\player\_hud_speedrun::updateWR();

			if (isDefined(self.huds.speedrun[5]) && !secret)
				self.huds.speedrun[5] setText(level.normal_way[int(number)].name);

			if (isDefined(self.huds.speedrun[5]) && secret)
				self.huds.speedrun[5] setText(level.secret_way[int(number)].name);
		}

		wait 0.1;
	}
}
