#include sr\sys\_events;
#include sr\utils\_common;

main()
{
	sr\_main::main();

	speedrun\game\_callbacks::main();
	speedrun\game\_menus::main();

	braxi\_mod::main();
}

onConnect()
{
	if (self.isBot)
		return;

	self.sr_mode = "190";
	self.voteCoolDown = getTime();
	self.sr_cheatmode = false;
	self.sr_practise = false;
	self.sr_savePos = [];
	self setClientDvar("ui_3dwaypointtext", "1");
	self.enable3DWaypoints = true;
	self setClientDvar("ui_deathicontext", "1");
	self.enableDeathIcons = true;
	self.classType = undefined;
	self.selectedClass = false;

	self setClientDvar("cl_maxpackets", 125);
	self setClientDvar("rate", 25000);

	self sr\player\_id::load();

	self clientCmd("setu com_maxfps 125");
	self clientCmd("setu sr_xp_bar 0")
}

onPlayerSpawned()
{
	self setSpeed();
	self setContents(0);
	self.sr_way = "normal_0";
	self.sr_secret = false;
	self.fps = "125";
	self thread speedrun\player\huds\_speedrun::hud();
	self thread updateRunHuds();

	if (!self.sr_cheatmode)
	{
		self.runNumber = randomInt(999999);
		self thread watchWay();
		self thread record();
	}
	self thread speedrun\player\huds\_cheat::hud();

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
		self thread sr\player\modes\_practise::init();
		wait 0.3;
		if (isDefined(self.huds.speedrun[5]))
			self.huds.speedrun[5] setText("^1Practise Mode");
	}
}

record()
{
	self endon("death");
	self endon("disconnect");

	if (self.isBot)
		return;

	thread recordTimeout();

	mapname = getDvar("mapname");
	self.demoPath = PathJoin(PATH_Mod("sr/data/demos"), self.id, mapname, self.runNumber, ".dm_1");
	exec(fmt("record %d %s", self getEntityNumber(), path));
}

recordTimeout()
{
	self endon("death");
	self endon("disconnect");

	wait 120;
	recordDelete();
}

recordSave()
{
	exec("stoprecord " + self GetEntityNumber());
}

recordDelete()
{
	if (FILE_Exists(self.demoPath))
		FILE_Remove(self.demoPath);
}

spawnTrail()
{
	self endon("death");
	self endon("disconnect");

	while (true)
	{
		self.trail = spawn("script_model", self.origin);
		self.trail setModel("tag_origin");
		self.trail linkTo(self);

		if (self.vip_trail != 0)
			playFXOnTag(level.fx["viptrail" + self.vip_trail], self.trail, "tag_origin");
	}
}

setSpeed()
{
	if (sr\api\_speedrun::isSlide())
	{
		speed = Ternary(self.sr_mode == "210", 1.8, 1.0);
		self setMoveSpeedScale(speed);
		self setGravity(1000);
		self setJumpHeight(70);
		self setMoveSpeed(190 * level.map_slide_multiplier);
		return;
	}

	speedScale = Ternary(self.sr_mode == "210", 1.12, 1.05);
	speed = Ternary(self.sr_mode == "210", 210, 190);
	self setMoveSpeed(speed);
	self setMoveSpeedScale(speedScale);
	self setgravity(800);
}

watchWay()
{
	self endon("disconnect");
	self endon("death");
	self endon("joined_spectators");

	way = self.sr_way;

	while (true)
	{
		if (way != self.sr_way)
		{
			way = self.sr_way;

			self thread speedrun\player\huds\_speedrun::updatePB();
			self thread speedrun\player\huds\_speedrun::updateWR();
		}
		wait 0.1;
	}
}

antiLowFps()
{
	self endon("disconnect");

	if (self.sr_cheatmode || self.pers["team"] == "axis" || !self.antiLowFps)
		return;

	if (self.fps < 1)
		self suicide();
}

antiElevator()
{
	self endon("disconnect");

	if (self.sr_cheatmode || self.pers["team"] == "axis" || !self.antiElevator)
		return;

	before = self.origin;
	waittillframeend;

	inAir = !self isOnGround() && !self isOnLadder() && !self isMantling();
	if (self.origin[2] != before[2] && self.velocity == (0, 0, 0) && inAir)
		self suicide();
}
