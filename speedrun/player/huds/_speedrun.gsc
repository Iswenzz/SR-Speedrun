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

	color = Ternary(self sr\sys\_admins::isVIP(),
		ToRGB(self getStat(1650), self getStat(1651), self getStat(1652)),
		(0, 0, 0));

	wr = "";
	pb = "";
	leaderboard = speedrun\game\_leaderboards::getLeaderboard(self.sr_mode, self.sr_way);
	entries = leaderboard.entries;

	if (entries.size)
		wr = fmt("%d:%d.%d", entries[0]["time"].min, entries[0]["time"].sec, entries[0]["time"].ms);

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

 	self.huds["speedrun"]["pb"] = addHud(self, 5, 42, 1, "left", "top", 1.4);
	self.huds["speedrun"]["pb"].hidewheninmenu = true;
	self.huds["speedrun"]["pb"].sort = 99;
	self.huds["speedrun"]["pb"] setText(fmt("(PB)                 ^3%s", pb));

 	self.huds["speedrun"]["wr"] = addHud(self, 5, 61, 1, "left", "top", 1.4);
	self.huds["speedrun"]["wr"].hidewheninmenu = true;
	self.huds["speedrun"]["wr"].sort = 99;
	self.huds["speedrun"]["wr"] setText(fmt("(WR)                 ^2%s", wr));

 	self.huds["speedrun"]["time"] = addHud(self, 72, 18, 1, "left", "top", 1.8);
	self.huds["speedrun"]["time"].sort = 99;
	self.huds["speedrun"]["time"] setText(" ");
	self.huds["speedrun"]["time"].label = &"^5&&1";
	self.huds["speedrun"]["time"] setTenthsTimerUp(0.0001);
	self.huds["speedrun"]["time"].hidewheninmenu = true;

 	self.huds["speedrun"]["name"] = addHud(self, 3, 0, 1, "left", "top", 1.4);
	self.huds["speedrun"]["name"] setText(leaderboard.name);
	self.huds["speedrun"]["name"].hidewheninmenu = true;
	self.huds["speedrun"]["name"].sort = 99;

 	self.huds["speedrun"]["role"] = addHud(self, 142, 18, 1, "left", "top", 1.8);
	self.huds["speedrun"]["role"] setText(self sr\sys\_admins::getRoleName());
	self.huds["speedrun"]["role"].hidewheninmenu = true;

	self updateWay();
}

updateTime()
{
	self.huds["speedrun"]["time"] setText(self.time.min + ":" + self.time.sec + "." + self.time.ms);
	self.huds["speedrun"]["time"].fontScale = 1.4;
	self.huds["speedrun"]["time"].x = 73;
	self.huds["speedrun"]["time"].y = 21;
}

updateWay()
{
	name = speedrun\game\_leaderboards::getLeaderboardIndex(self.sr_mode, self.sr_way);
	self.huds["speedrun"]["name"] setText(level.leaderboards[name].name);
}

clear()
{
	self endon("disconnect");

	if (isDefined(self.huds["speedrun"]))
	{
		huds = getArrayKeys(self.huds["speedrun"]);
		for (i = 0; i < huds.size; i++)
			self.huds["speedrun"][huds[i]] destroy();
	}
}
