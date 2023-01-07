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
	self endon("death");
	self endon("disconnect");
	self endon("joined_spectators");

	self clear();

	self.huds["speedrun"] = [];
 	self.huds["speedrun"]["background"] = addHud(self, 0, 0, 1, "left", "top", 1.8, 90, true);
	self.huds["speedrun"]["background"] setShader("time_hud", 142, 80);
	self.huds["speedrun"]["background"].glowAlpha = 1;

	self.huds["speedrun"]["name"] = addHud(self, 3, 0, 1, "left", "top", 1.4, 99, true);
 	self.huds["speedrun"]["name"] setText("Normal Way");
 	self.huds["speedrun"]["mode"] = addHud(self, 4, 18, 1, "left", "top", 1.8, 99, true);
	self.huds["speedrun"]["mode"] setText(self.sr_mode);

	self.huds["speedrun"]["row1"] = addHud(self, 72, 18, 1, "left", "top", 1.8, 99, true);
	self.huds["speedrun"]["row1"].label = &"^5&&1";
	self.huds["speedrun"]["row1"] setTenthsTimerUp(0.0001);
 	self.huds["speedrun"]["row2"] = addHud(self, 5, 42, 1, "left", "top", 1.4, 99, true);
 	self.huds["speedrun"]["row2"] setText("(PB)");
 	self.huds["speedrun"]["row3"] = addHud(self, 5, 61, 1, "left", "top", 1.4, 99, true);
 	self.huds["speedrun"]["row3"] setText("(WR)");

 	self.huds["speedrun"]["role"] = addHud(self, 142, 18, 1, "left", "top", 1.8, 99, true);
	self.huds["speedrun"]["vip"] = addHud(self, 144, -1, 1, "left", "top", 1.8, 99, true);
	self.huds["speedrun"]["wr_icon"] = addHud(self, 170, 1, 1, "left", "top", 1.4, 99, true);
	self.huds["speedrun"]["wr_icon_count"] = addHud(self, 185, 5, 1, "left", "top", 1.4, 100, true);

	if (isDefined(self.showRank))
	{
		if (self.pers["prestige"] > 0)
			self.huds["speedrun"]["rank"] = addHud(self, 197, 5, 1, "left", "top", 1.4, 81, true);
		self.huds["speedrun"]["rank_icon"] = addHud(self, 185, 1, 1, "left", "top", 1.4, 80, true);
	}

	self updateAdmin();
	self updateRank();
	self updateWay();

	self notify("speedrun_hud");
}

updateRank()
{
	if (!isDefined(self.showRank))
		return;

	self endon("death");
	self endon("disconnect");

	self loading("rank");
	icon = level.assets["rank"][self.pers["rank"]];

	if (self.pers["prestige"] > 0)
	{
		icon = level.assets["prestige"][self.pers["prestige"]];
		self.huds["speedrun"]["rank"] setValue(self.pers["rank"]);
	}
	self.huds["speedrun"]["rank_icon"] setShader(icon, 18, 18);
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

	self.huds["speedrun"]["row2"] setText(fmt("(PB)                  ^3%s", pb));
	self.huds["speedrun"]["row3"] setText(fmt("(WR)                 ^2%s", wr));

	if (isDefined(self.wrBaseCount) && self.wrBaseCount >= 10)
	{
		self.huds["speedrun"]["wr_icon"] setShader("speedrunner_logo", 18, 18);
		self.huds["speedrun"]["wr_icon_count"] setText(fmt("^3%d ^7[%d]", self.wrBaseCount, self.wrCount));
	}
}

updateTime()
{
	self.huds["speedrun"]["row1"] setText(self.time.min + ":" + self.time.sec + "." + self.time.ms);
	self.huds["speedrun"]["row1"].fontScale = 1.4;
	self.huds["speedrun"]["row1"].x = 73;
	self.huds["speedrun"]["row1"].y = 21;
}

updateWay()
{
	self endon("death");
	self endon("disconnect");

	if (isDefined(self.demo))
		return;

	level loading("leaderboards");
	self loading("pbs");

	self updateRecords();

	if (self sr\game\minigames\_main::isInAnyQueue())
		return;
	if (self sr\player\modes\_main::isInAnyMode())
		return;

	name = speedrun\game\_leaderboards::getLeaderboardName(self.sr_mode, self.sr_way);
	self.huds["speedrun"]["name"] setText(name);
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
