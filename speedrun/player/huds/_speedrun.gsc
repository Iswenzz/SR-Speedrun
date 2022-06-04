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
		(self getStat(1650) / 255, self getStat(1651) / 255, self getStat(1652) / 255),
		(0, 0, 0));

	self.huds.speedrun = [];
 	self.huds.speedrun[0] = addHud(self, 0, 0, 1, "left", "top", 1.8);
	self.huds.speedrun[0] setShader("time_hud", 142, 80);
	self.huds.speedrun[0].hidewheninmenu = true;
	self.huds.speedrun[0].color = color;
	self.huds.speedrun[0].glowColor = color;
	self.huds.speedrun[0].glowAlpha = 1;

 	self.huds.speedrun[1] = addHud(self, 4, 18, 1, "left", "top", 1.8);
	self.huds.speedrun[1] setText(self.sr_mode);
	self.huds.speedrun[1].hidewheninmenu = true;
	self.huds.speedrun[1].sort = 99;

 	self.huds.speedrun[2] = addHud(self, 5, 42, 1, "left", "top", 1.4);
	self.huds.speedrun[2].hidewheninmenu = true;
	self.huds.speedrun[2].sort = 99;

 	self.huds.speedrun[3] = addHud(self, 5, 61, 1, "left", "top", 1.4);
	self.huds.speedrun[3].hidewheninmenu = true;
	self.huds.speedrun[3].sort = 99;

 	self.huds.speedrun[4] = addHud(self, 72, 18, 1, "left", "top", 1.8);
	self.huds.speedrun[4].sort = 99;
	self.huds.speedrun[4] setText(" ");
	self.huds.speedrun[4].label = &"^5&&1";
	self.huds.speedrun[4] setTenthsTimerUp(0.0001);
	self.huds.speedrun[4].hidewheninmenu = true;

	way = Ternary(isDefined(level.normal_way[0]), level.normal_way[0].name, "");
 	self.huds.speedrun[5] = addHud(self, 3, 0, 1, "left", "top", 1.4);
	self.huds.speedrun[5] setText(way);
	self.huds.speedrun[5].hidewheninmenu = true;
	self.huds.speedrun[5].sort = 99;

 	self.huds.speedrun[6] = addHud(self, 142, 18, 1, "left", "top", 1.8);
	self.huds.speedrun[6] setText(self sr\sys\_admins::getGroupString());
	self.huds.speedrun[6].hidewheninmenu = true;

	self updatePB();
	self updateWR();
}

updateHud()
{
	if (!isDefined(self.huds.speedrun[4]))
		return;

	self.huds.speedrun[4] setText(self.time.min + ":" + self.time.sec + "." + self.time.milsec);
	self.huds.speedrun[4].fontScale = 1.4;
	self.huds.speedrun[4].x = 73;
	self.huds.speedrun[4].y = 21;
}

updateWR()
{
	if (!isDefined(self.huds.speedrun[3]))
		return;
	if (!isDefined(level.normal_way) || !isDefined(level.normal_way.size))
		return;
	if (!isDefined(level.secret_way) || !isDefined(level.secret_way.size))
		return;

	mode = self.sr_mode;
	way = self.sr_way;

	for (i = 0; i < level.normal_way.size; i++)
	{
		if (way == "ns" + i && mode == 190)
		{
			self.huds.speedrun[3] setText("(WR)");

			if (!isDefined(level.normal_way_info_190[i]))
				continue;

			if (level.normal_way_info_190[i].size > 0)
				self.huds.speedrun[3] setText("(WR)                 ^2" + level.normal_way_info_190[i][0]["time"].min + ":" + level.normal_way_info_190[i][0]["time"].sec + "." + level.normal_way_info_190[i][0]["time"].milsec);
		}

		if (way == "ns" + i && mode == 210)
		{
			self.huds.speedrun[3] setText("(WR)");

			if (!isDefined(level.normal_way_info_210[i]))
				continue;

			if (level.normal_way_info_210[i].size > 0)
				self.huds.speedrun[3] setText("(WR)                 ^2" + level.normal_way_info_210[i][0]["time"].min + ":" + level.normal_way_info_210[i][0]["time"].sec + "." + level.normal_way_info_210[i][0]["time"].milsec);
		}
	}

	for (i = 0; i < level.secret_way.size; i++)
	{
		if (way == "s" + i && mode == 190)
		{
			self.huds.speedrun[3] setText("(WR)");

			if (!isDefined(level.secret_way_info_190[i]))
				continue;

			if (level.secret_way_info_190[i].size > 0)
				self.huds.speedrun[3] setText("(WR)                 ^2" + level.secret_way_info_190[i][0]["time"].min + ":" + level.secret_way_info_190[i][0]["time"].sec + "." + level.secret_way_info_190[i][0]["time"].milsec);
		}

		if (way == "s" + i && mode == 210)
		{
			self.huds.speedrun[3] setText("(WR)");

			if (!isDefined(level.secret_way_info_210[i]))
				continue;

			if (level.secret_way_info_210[i].size > 0)
				self.huds.speedrun[3] setText("(WR)                 ^2" + level.secret_way_info_210[i][0]["time"].min + ":" + level.secret_way_info_210[i][0]["time"].sec + "." + level.secret_way_info_210[i][0]["time"].milsec);
		}
	}
}

updatePB()
{
	if (!isDefined(self.huds.speedrun[2]))
		return;
	if (!isDefined(level.normal_way) || !isDefined(level.normal_way.size))
		return;
	if (!isDefined(level.secret_way) || !isDefined(level.secret_way.size))
		return;

	mode = self.sr_mode;
	way = self.sr_way;

	for (i = 0; i < level.normal_way.size; i++)
	{
		if (way == "ns" + i && mode == 190)
		{
			self.huds.speedrun[2] setText("(PB)");

			if (!isDefined(self.pb_190["ns_" + i]))
				continue;

			if (self.pb_190["ns_" + i].size > 0)
				self.huds.speedrun[2] setText("(PB)                  ^3" + self.pb_190["ns_" + i]["time"].min + ":" + self.pb_190["ns_" + i]["time"].sec + "." + self.pb_190["ns_" + i]["time"].milsec);
		}

		if (way == "ns" + i && mode == 210)
		{
			self.huds.speedrun[2] setText("(PB)");

			if (!isDefined(self.pb_210["ns_" + i]))
				continue;

			if (self.pb_210["ns_" + i].size > 0)
				self.huds.speedrun[2] setText("(PB)                  ^3" + self.pb_210["ns_" + i]["time"].min + ":" + self.pb_210["ns_" + i]["time"].sec + "." + self.pb_210["ns_" + i]["time"].milsec);
		}
	}

	for (i = 0; i < level.secret_way.size; i++)
	{
		if (!isDefined(self.pb_190["s_" + i]))
			continue;

		if (way == "s" + i && mode == 190)
		{
			self.huds.speedrun[2] setText("(PB)");

			if (self.pb_190["s_" + i].size > 0)
				self.huds.speedrun[2] setText("(PB)                  ^3" + self.pb_190["s_" + i]["time"].min + ":" + self.pb_190["s_" + i]["time"].sec + "." + self.pb_190["s_" + i]["time"].milsec);
		}

		if (way == "s" + i && mode == 210)
		{
			self.huds.speedrun[2] setText("(PB)");

			if (!isDefined(self.pb_210["s_" + i]))
				continue;

			if (self.pb_210["s_" + i].size > 0)
				self.huds.speedrun[2] setText("(PB)                  ^3" + self.pb_210["s_" + i]["time"].min + ":" + self.pb_210["s_" + i]["time"].sec + "." + self.pb_210["s_" + i]["time"].milsec);
		}
	}
}

clear()
{
	self endon("disconnect");

	if (isDefined(self.huds.speedrun))
	{
		for (i = 0; i < self.huds.speedrun.size; i++)
		{
			if (isDefined(self.huds.speedrun[i]))
				self.huds.speedrun[i] destroy();
		}
	}
}
