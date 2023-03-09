#include sr\sys\_events;
#include sr\utils\_hud;
#include sr\utils\_common;

main()
{
	event("spawn", ::hud);
	event("death", ::clear);
}

hud()
{
	self endon("spawned");
	self endon("death");
	self endon("disconnect");

	self clear();

	self.huds["speedrun"] = [];
 	self.huds["speedrun"]["background"] = addHud(self, 0, 0, 1, "left", "top", 1.8, 90, true);
	self.huds["speedrun"]["background"] setShader("time_hud", 142, 80);
	self.huds["speedrun"]["background"].color = (0, 0, 0);
	self.huds["speedrun"]["background"].glowAlpha = 1;

	self.huds["speedrun"]["name"] = addHud(self, 3, 0, 1, "left", "top", 1.4, 99, true);
 	self.huds["speedrun"]["name"] setText("Normal Way");
 	self.huds["speedrun"]["mode"] = addHud(self, 4, 18, 1, "left", "top", 1.8, 99, true);
	self.huds["speedrun"]["mode"] setText(self.sr_mode);

	self.huds["speedrun"]["row1"] = addHud(self, 72, 18, 1, "left", "top", 1.8, 99, true);
	self.huds["speedrun"]["row1"] setText("^50:00.0");
 	self.huds["speedrun"]["row2"] = addHud(self, 5, 42, 1, "left", "top", 1.4, 99, true);
 	self.huds["speedrun"]["row3"] = addHud(self, 5, 61, 1, "left", "top", 1.4, 99, true);

 	self.huds["speedrun"]["role"] = addHud(self, 142, 18, 1, "left", "top", 1.8, 99, true);
	self.huds["speedrun"]["vip"] = addHud(self, 144, -1, 1, "left", "top", 1.8, 99, true);
	self.huds["speedrun"]["wr_icon"] = addHud(self, 170, 1, 1, "left", "top", 1.4, 99, true);
	self.huds["speedrun"]["wr_icon_count"] = addHud(self, 185, 5, 1, "left", "top", 1.4, 100, true);

	self updateWay();
	self updateAdmin();
	self updateTAS();

	self notify("speedrun");
}

updateAdmin()
{
	self endon("death");
	self endon("disconnect");

	level loading("admins");

	color = Ternary(self sr\sys\_admins::isVIP(),
		ToRGB(self getStat(1650), self getStat(1651), self getStat(1652)),
		(0, 0, 0));

	self.huds["speedrun"]["background"].color = color;
	self.huds["speedrun"]["background"].glowColor = color;

	self.huds["speedrun"]["role"] setText(self sr\sys\_admins::getRoleName());
	if (self sr\sys\_admins::isVIP())
		self.huds["speedrun"]["vip"] setShader("vip_status", 24, 22);
}

updateRecords()
{
	if (!isHud("row2"))
		return;

	wr = speedrun\game\_leaderboards::getWorldRecord(self.sr_mode, self.sr_way);
	pb = self speedrun\game\_pbs::getPersonalBest(self.sr_mode, self.sr_way);

	self.huds["speedrun"]["row2"] setText("^3" + pb);
	self.huds["speedrun"]["row2"].label = &"(PB)                  ";
	self.huds["speedrun"]["row3"] setText("^2" + wr);
 	self.huds["speedrun"]["row3"].label = &"(WR)                 ";

	if (!self hasLoaded("pbs"))
	{
		self.huds["speedrun"]["row2"] setShader("sr_loader", 18, 18);
		self.huds["speedrun"]["row2"].label = &"(PB)                        ";
	}
	if (!level hasLoaded("leaderboards"))
 	{
		self.huds["speedrun"]["row3"] setShader("sr_loader", 18, 18);
 		self.huds["speedrun"]["row3"].label = &"(WR)                       ";
	}
	if (!self hasLoaded("wr"))
	{
		self.huds["speedrun"]["wr_icon"] setShader("sr_loader", 18, 18);
		self.huds["speedrun"]["wr_icon"].alpha = 1;
	}
	if (isDefined(self.pers["wrBaseCount"]))
	{
		self.huds["speedrun"]["wr_icon"].alpha = self.pers["wrBaseCount"] >= 10;

		if (self.pers["wrBaseCount"] >= 10)
		{
			self.huds["speedrun"]["wr_icon"] setShader("speedrunner_logo", 18, 18);
			self.huds["speedrun"]["wr_icon_count"] setText(fmt("^3%d ^7[%d]", self.pers["wrBaseCount"], self.pers["wrCount"]));
		}
	}
}

updateTime()
{
	if (isDefined(self.time))
	{
		self.huds["speedrun"]["row1"] setText(self.time.min + ":" + self.time.sec + "." + self.time.ms);
		self.huds["speedrun"]["row1"].fontScale = 1.4;
		self.huds["speedrun"]["row1"].x = 73;
		self.huds["speedrun"]["row1"].y = 21;
	}
	else
	{
		self.huds["speedrun"]["row1"].label = &"^5&&1";
		self.huds["speedrun"]["row1"] setTenthsTimerUp(0.0001);
	}
}

updateWay()
{
	if (!isHud("name") || self isDemo())
		return;

	self updateRecords();

	name = speedrun\game\_leaderboards::getLeaderboardName(self.sr_mode, self.sr_way);
	self.huds["speedrun"]["name"] setText(name);
}

updateTAS()
{
	if (!self sr\sys\_admins::isTAS())
		return;

	self.huds["speedrun"]["tas"] = addHud(self, 5, 0, 1, "left", "bottom", 1.4, 100, true);
	self.huds["speedrun"]["tas"].label = &"^5TAS";
	self.huds["speedrun"]["tas"].font = "objective";
}

isHud(name)
{
	return isDefined(self.huds["speedrun"]) && isDefined(self.huds["speedrun"][name]);
}

clear()
{
	self endon("disconnect");

	if (isDefined(self.huds["speedrun"]))
	{
		huds = getArrayKeys(self.huds["speedrun"]);
		for (i = 0; i < huds.size; i++)
		{
			if (isDefined(self.huds["speedrun"][huds[i]]))
				self.huds["speedrun"][huds[i]] destroy();
		}
	}
}
