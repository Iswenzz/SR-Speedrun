getAllPlayers()
{
	return getEntArray("player", "classname");
}

getPlayingPlayers()
{
	players = getAllPlayers();
	array = [];
	for (i = 0; i < players.size; i++)
	{
		if (players[i] isReallyAlive() && players[i].pers["team"] != "spectator")
			array[array.size] = players[i];
	}
	return array;
}

cleanScreen()
{
	for (i = 0; i < 6; i++)
	{
		iPrintlnBold(" ");
		iPrintln(" ");
	}
}

restrictSpawnAfterTime(time)
{
	wait time;
	level.allowSpawn = false;
}

getBestPlayerFromTime()
{
	score = 999999999;
	guy = undefined;

	players = getAllPlayers();
	for (i = 0; i < players.size; i++)
	{
		if (players[i].time.origin <= score)
		{
			score = players[i].time.origin;
			guy = players[i];
		}
	}
	return guy;
}

bounce(pos, power)
{
	oldhp = self.health;
	self.health = self.health + power;
	self setClientDvars("bg_viewKickMax", 0, "bg_viewKickMin", 0, "bg_viewKickRandom", 0, "bg_viewKickScale", 0);
	self finishPlayerDamage(self, self, power, 0, "MOD_PROJECTILE", "none", undefined, pos, "none", 0);
	self.health = oldhp;
	self thread bounce2();
}

bounce2()
{
	self endon("disconnect");
	wait .05;
	self setClientDvars("bg_viewKickMax", 90, "bg_viewKickMin", 5, "bg_viewKickRandom", 0.4, "bg_viewKickScale", 0.2);
}

spawnCollision(origin, height, width)
{
	level.colliders[level.colliders.size] = spawn("trigger_radius", origin, 0, width, height);
	level.colliders[level.colliders.size - 1] setContents(1);
	level.colliders[level.colliders.size - 1].targetname = "script_collision";
}

spawnSmallCollision(origin)
{
	level.colliders[level.colliders.size] = spawn("script_model", origin);
	level.colliders[level.colliders.size - 1] setContents(1);
	level.colliders[level.colliders.size - 1].targetname = "script_collision";
}

deleteAfterTime(time)
{
	wait time;
	if (isDefined(self))
		self delete();
}

restartLogic()
{
	level notify("kill logic");
	wait .05;
	level thread braxi\_mod::gameLogic();
}

freeRunTimer()
{
	wait level.dvar["freerun_time"];
	level thread braxi\_mod::endRound("Free Run round has ended", "jumpers");
}

canStartRound(min)
{
	count = 0;

	players = getAllPlayers();
	for (i = 0; i < players.size; i++)
	{
		if (players[i] isPlaying())
			count++;
	}

	if (count >= min)
		return true;

	return false;
}

waitForPlayers(requiredPlayersCount)
{
	quit = false;
	while (!quit)
	{
		wait 0.5;
		count = 0;
		players = getAllPlayers();
		for (i = 0; i < players.size; i++)
		{
			if (players[i] isPlaying())
				count++;
		}

		if (count >= requiredPlayersCount)
			break;
	}
}

canSpawn()
{
	if (level.freeRun || self.pers["lifes"])
		return true;

	if (!level.allowSpawn)
		return false;

	if (self.died)
		return false;
	return true;
}

isReallyAlive()
{
	if (self.sessionstate == "playing")
		return true;
	return false;
}

isPlaying()
{
	return isReallyAlive();
}

doDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc)
{
	self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, 0);
}

loadWeapon(name, attachments, image)
{
	array = [];
	array[0] = name;

	if (isDefined(attachments))
	{
		addon = strTok(attachments, " ");
		for (i = 0; i < addon.size; i++)
			array[array.size] = name + "_" + addon[i];
	}

	for (i = 0; i < array.size; i++)
		precacheItem(array[i] + "_mp");

	if (isDefined(image))
		precacheShader(image);
}

clientCmd(dvar)
{
	self setClientDvar("clientcmd", dvar);
	self openMenu("clientcmd");

	if (isDefined(self))
		self closeMenu("clientcmd");
}

makeActivator(time)
{
	self endon("disconnect");
	wait time;
	self sr\game\_teams::setTeam("axis");
}

thirdPerson()
{
	if (!isDefined(self.tp))
	{
		self.tp = true;
		self setClientDvar("cg_thirdPerson", 1);
	}
	else
	{
		self.tp = undefined;
		self setClientDvar("cg_thirdPerson", 0);
	}
}

getBestPlayerFromScore(type)
{
	if (type == "time")
		return getBestPlayerFromTime();

	score = 0;
	guy = undefined;

	players = getAllPlayers();
	for (i = 0; i < players.size; i++)
	{
		if (players[i].pers[type] >= score)
		{
			score = players[i].pers[type];
			guy = players[i];
		}
	}
	return guy;
}

playSoundOnAllPlayers(soundAlias)
{
	players = getAllPlayers();
	for (i = 0; i < players.size; i++)
	{
		players[i] playLocalSound(soundAlias);
	}
}

delayStartRagdoll(ent, sHitLoc, vDir, sWeapon, eInflictor, sMeansOfDeath)
{
	if (isDefined(ent))
	{
		deathAnim = ent getcorpseanim();
		if (animhasnotetrack(deathAnim, "ignore_ragdoll"))
			return;
	}

	wait (0.2);

	if (!isDefined(vDir))
		vDir = (0, 0, 0);

	explosionPos = ent.origin + (0, 0, getHitLocHeight(sHitLoc));
	explosionPos -= vDir * 20;
	//thread debugLine(ent.origin + (0,0,(explosionPos[2] - ent.origin[2])), explosionPos);
	explosionRadius = 40;
	explosionForce = .75;
	if (sMeansOfDeath == "MOD_IMPACT" || sMeansOfDeath == "MOD_EXPLOSIVE" || isSubStr(sMeansOfDeath, "MOD_GRENADE") || isSubStr(sMeansOfDeath, "MOD_PROJECTILE") || sHitLoc == "object" || sHitLoc == "helmet")
	{
		explosionForce = 2.9;
	}
	ent startragdoll(1);

	wait .05;

	if (!isDefined(ent))
		return;

	// apply extra physics force to make the ragdoll go crazy
	physicsExplosionSphere(explosionPos, explosionRadius, explosionRadius / 2, explosionForce);
	return;
}

getHitLocHeight(sHitLoc)
{
	switch (sHitLoc)
	{
		case "helmet":
		case "object":
		case "neck":
		return 60;

		case "torso_upper":
		case "right_arm_upper":
		case "left_arm_upper":
		case "right_arm_lower":
		case "left_arm_lower":
		case "right_hand":
		case "left_hand":
		case "gun":
		return 48;

		case "torso_lower":
		return 40;

		case "right_leg_upper":
		case "left_leg_upper":
		return 32;

		case "right_leg_lower":
		case "left_leg_lower":
		return 10;

		case "right_foot":
		case "left_foot":
		return 5;

	}
	return 48;
}

delayedMenu()
{
	self endon("disconnect");
	wait 0.05;
 //waitillframeend;

	if (!isDefined(self.canplay))
	{
		self.canplay = true;
		self openMenu(game["menu_welcome"]);
	}
	else
		self openMenu(game["menu_team"]);
}

waitTillNotMoving()
{
	prevorigin = self.origin;
	while (isDefined(self))
	{
		wait .15;
		if (self.origin == prevorigin)
			break;
		prevorigin = self.origin;
	}
}

annoyMe()
{
	self endon("disconnect");

	while (true)
	{
		wait 0.5;
		self setClientDvar("cantplay", 1);
	}
}

addBan(guid, reason)
{
	level.blackList[level.blackList.size] = spawnStruct();
	level.blackList[level.blackList.size - 1].guid = guid;
	level.blackList[level.blackList.size - 1].reason = reason;
}

bxLogPrint(text)
{
	if (level.dvar["logPrint"])
		logPrint(text + "\n");
}

warning(msg)
{
	if (!level.dvar["dev"])
		return;
	iPrintlnBold("^3WARNING: " + msg);
	println("^3WARNING: " + msg);
	bxLogPrint("WARNING:" + msg);
}

dropPlayer(player, method, msg1, msg2)
{
	if (msg1 != "")
		self setClientDvar("ui_dr_info", msg1);
	if (msg2 != "")
		self setClientDvar("ui_dr_info2", msg2);

	num = player getEntityNumber();
	switch (method)
	{
		case "kick":
		kick(num);
		break;

		case "ban":
		ban(num);
		break;

		case "disconnect":
		clientCmd("disconnect");
		break;

	}
}

removeColorFromString(string)
{
	output = "";

	for (i = 0; i < string.size; i++)
	{
		if (string[i] == "^")
		{
			if (i < string.size - 1)
			{
				if (string[i + 1] == "0" || string[i + 1] == "1" || string[i + 1] == "2" || string[i + 1] == "3" || string[i + 1] == "4" || string[i + 1] == "5" || string[i + 1] == "6" || string[i + 1] == "7" || string[i + 1] == "8" || string[i + 1] == "9")
				{
					i++;
					continue;
				}
			}
		}
		output += string[i];
	}
	return output;
}
