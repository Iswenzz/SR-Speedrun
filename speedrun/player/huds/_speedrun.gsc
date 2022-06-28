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

	color = Ternary(self sr\sys\_admins::isVIP(),
		ToRGB(self getStat(1650), self getStat(1651), self getStat(1652)),
		(0, 0, 0));

	self.huds["speedrun"] = [];
 	self.huds["speedrun"]["background"] = addHud(self, 0, 0, 1, "left", "top", 1.8);
	self.huds["speedrun"]["background"] setShader("time_hud", 142, 80);
	self.huds["speedrun"]["background"].hidewheninmenu = true;
	self.huds["speedrun"]["background"].color = color;
	self.huds["speedrun"]["background"].glowColor = color;
	self.huds["speedrun"]["background"].glowAlpha = 1;

 	self.huds["speedrun"]["mode"] = addHud(self, 4, 18, 1, "left", "top", 1.8);
	self.huds["speedrun"]["mode"] setText(self.sr_mode);
	self.huds["speedrun"]["mode"].hidewheninmenu = true;
	self.huds["speedrun"]["mode"].sort = 99;

	self.huds["speedrun"]["row1"] = addHud(self, 72, 18, 1, "left", "top", 1.8);
	self.huds["speedrun"]["row1"].sort = 99;
	self.huds["speedrun"]["row1"] setText(" ");
	self.huds["speedrun"]["row1"].label = &"^5&&1";
	self.huds["speedrun"]["row1"] setTenthsTimerUp(0.0001);
	self.huds["speedrun"]["row1"].hidewheninmenu = true;

 	self.huds["speedrun"]["row2"] = addHud(self, 5, 42, 1, "left", "top", 1.4);
	self.huds["speedrun"]["row2"].hidewheninmenu = true;
	self.huds["speedrun"]["row2"].sort = 99;

 	self.huds["speedrun"]["row3"] = addHud(self, 5, 61, 1, "left", "top", 1.4);
	self.huds["speedrun"]["row3"].hidewheninmenu = true;
	self.huds["speedrun"]["row3"].sort = 99;

 	self.huds["speedrun"]["name"] = addHud(self, 3, 0, 1, "left", "top", 1.4);
	self.huds["speedrun"]["name"].hidewheninmenu = true;
	self.huds["speedrun"]["name"].sort = 99;

 	self.huds["speedrun"]["role"] = addHud(self, 142, 18, 1, "left", "top", 1.8);
	self.huds["speedrun"]["role"] setText(self sr\sys\_admins::getRoleName());
	self.huds["speedrun"]["role"].hidewheninmenu = true;

	self updateWay();
	self notify("speedrun_hud");
}

updateRecords()
{
	if (!isDefined(self.huds["speedrun"]["row3"]))
		return;

	wr = speedrun\game\_leaderboards::getWorldRecord(self.sr_mode, self.sr_way);
	pb = speedrun\game\_pbs::getPersonalBest(self.sr_mode, self.sr_way);

	self.huds["speedrun"]["row2"] setText(fmt("(PB)                  ^3%s", pb));
	self.huds["speedrun"]["row3"] setText(fmt("(WR)                 ^2%s", wr));
}

updateTime()
{
	if (!isDefined(self.huds["speedrun"]["row1"]))
		return;

	self.huds["speedrun"]["row1"] setText(self.time.min + ":" + self.time.sec + "." + self.time.ms);
	self.huds["speedrun"]["row1"].fontScale = 1.4;
	self.huds["speedrun"]["row1"].x = 73;
	self.huds["speedrun"]["row1"].y = 21;
}

updateWay()
{
	if (!isDefined(self.huds["speedrun"]["name"]))
		return;

	self updateRecords();

	if (self sr\game\minigames\_main::isInAnyQueue())
		return;
	if (self sr\player\modes\_main::isInAnyMode())
		return;

	name = speedrun\game\_leaderboards::getLeaderboardName(self.sr_mode, self.sr_way);
	self.huds["speedrun"]["name"] setText(name);
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
