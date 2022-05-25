timeHud()
{
	self endon("death");
	self endon("disconnect");
	self endon("joined_spectators");

	self waittill("start_time_hud");
	self thread onDeathHud();
	self.timerHud = [];

 	self.timerHud[0] = addHud(self, 0, 0, 1, "left", "top", 1.8);
	self.timerHud[0] setShader("time_hud", 142, 80);
	self.timerHud[0].hidewheninmenu = true;
	self.timerHud[0].color = (0 / 255, 0 / 255, 0 / 255);
	self.timerHud[0].glowColor = (0 / 255, 0 / 255, 0 / 255);
	self.timerHud[0].glowAlpha = 1;

	if (isDefined(self.isVIP) && self.isVIP)
	{
		self.timerHud[0].color = (self getStat(1650) / 255, self getStat(1651) / 255, self getStat(1652) / 255);
		self.timerHud[0].glowColor = (self getStat(1650) / 255, self getStat(1651) / 255, self getStat(1652) / 255);
	}

 	self.timerHud[1] = addHud(self, 4, 18, 1, "left", "top", 1.8);
	if (isDefined(self.sr_speed))
		self.timerHud[1] setText(self.sr_speed);
	else
		self.timerHud[1] setText(" ");
	self.timerHud[1].hidewheninmenu = true;
	self.timerHud[1].sort = 99;

 	self.timerHud[2] = addHud(self, 5, 42, 1, "left", "top", 1.4);
	self.timerHud[2].hidewheninmenu = true;
	self.timerHud[2].sort = 99;

 	self.timerHud[3] = addHud(self, 5, 61, 1, "left", "top", 1.4);
	self.timerHud[3].hidewheninmenu = true;
	self.timerHud[3].sort = 99;

 	self.timerHud[4] = addHud(self, 72, 18, 1, "left", "top", 1.8);
	self.timerHud[4].sort = 99;
	self.timerHud[4] setText(" ");
	self.timerHud[4].label = &"^5&&1";
	if (!self.inRace)
		self.timerHud[4] setTenthsTimerUp(0.0001);
	self.timerHud[4].hidewheninmenu = true;

 	self.timerHud[5] = addHud(self, 3, 0, 1, "left", "top", 1.4);
	self.timerHud[5].hidewheninmenu = true;
	self.timerHud[5].sort = 99;
	if (isDefined(level.normal_way[0]))
		self.timerHud[5] setText(level.normal_way[0].name);
	else
		self.timerHud[5] setText(" ");

 	self.timerHud[6] = addHud(self, 142, 18, 1, "left", "top", 1.8);
	if (self.isBot)
		self.timerHud[6] setText("^8Speedrun Bot");
	switch (self.admin_group)
	{
		case "owner":
			self.timerHud[6] setText("^5Owner");
			break;

		case "masteradmin":
			self.timerHud[6] setText("^9Master Admin");
			break;

		case "adminplus":
			self.timerHud[6] setText("^1Admin+");
			break;

		case "admin":
			self.timerHud[6] setText("^6Admin");
			break;

		case "member":
			self.timerHud[6] setText("^3Member");
			break;
	}
	self.timerHud[6].hidewheninmenu = true;

	self updatepbHud();
	self updatewrHud();
}

updateHud()
{
	if (!isDefined(self.timerHud[4]))
		return;

	self.timerHud[4] setText(self.time.min + ":" + self.time.sec + "." + self.time.milsec);
	self.timerHud[4].fontScale = 1.4;
	self.timerHud[4].x = 73;
	self.timerHud[4].y = 21;
}

onDeathHud()
{
	self endon("disconnect");
	self waittill("death");
	self thread destroyClientHud();
}

destroyClientHud()
{
	if (isDefined(self.timerhud))
	{
		for (i = 0; i < self.timerHud.size; i++)
			if (isDefined(self.timerHud[i]))
			self.timerHud[i] Destroy();
	}
	if (isDefined(self.raceHud))
		self.raceHud destroy();
}

addHud(who, x, y, alpha, alignX, alignY, fontScale)
{
	if (isPlayer(who))
		hud = newClientHudElem(who);
	else
		hud = newHudElem();

	hud.x = x;
	hud.y = y;
	hud.alpha = alpha;
	hud.alignX = alignX;
	hud.alignY = alignY;
	hud.horzAlign = alignX;
	hud.vertAlign = alignY;
	hud.fontScale = fontScale;
	return hud;
}

updatewrHud()
{
	if (!isDefined(self.timerHud[3]))
		return;
	if (!isDefined(level.normal_way) || !isDefined(level.normal_way.size))
		return;
	if (!isDefined(level.secret_way) || !isDefined(level.secret_way.size))
		return;

	speed = self.sr_speed;
	way = self.sr_way;

	for (i = 0; i < level.normal_way.size; i++)
	{
		if (way == "ns" + i && speed == 190)
		{
			self.timerHud[3] setText("(WR)");

			if (!isDefined(level.normal_way_info_190[i]))
				continue;

			if (level.normal_way_info_190[i].size > 0)
				self.timerHud[3] setText("(WR)                 ^2" + level.normal_way_info_190[i][0]["time"].min + ":" + level.normal_way_info_190[i][0]["time"].sec + "." + level.normal_way_info_190[i][0]["time"].milsec);
		}

		if (way == "ns" + i && speed == 210)
		{
			self.timerHud[3] setText("(WR)");

			if (!isDefined(level.normal_way_info_210[i]))
				continue;

			if (level.normal_way_info_210[i].size > 0)
				self.timerHud[3] setText("(WR)                 ^2" + level.normal_way_info_210[i][0]["time"].min + ":" + level.normal_way_info_210[i][0]["time"].sec + "." + level.normal_way_info_210[i][0]["time"].milsec);
		}
	}

	for (i = 0; i < level.secret_way.size; i++)
	{
		if (way == "s" + i && speed == 190)
		{
			self.timerHud[3] setText("(WR)");

			if (!isDefined(level.secret_way_info_190[i]))
				continue;

			if (level.secret_way_info_190[i].size > 0)
				self.timerHud[3] setText("(WR)                 ^2" + level.secret_way_info_190[i][0]["time"].min + ":" + level.secret_way_info_190[i][0]["time"].sec + "." + level.secret_way_info_190[i][0]["time"].milsec);
		}

		if (way == "s" + i && speed == 210)
		{
			self.timerHud[3] setText("(WR)");

			if (!isDefined(level.secret_way_info_210[i]))
				continue;

			if (level.secret_way_info_210[i].size > 0)
				self.timerHud[3] setText("(WR)                 ^2" + level.secret_way_info_210[i][0]["time"].min + ":" + level.secret_way_info_210[i][0]["time"].sec + "." + level.secret_way_info_210[i][0]["time"].milsec);
		}
	}
}

updatepbHud()
{
	if (!isDefined(self.timerHud[2]))
		return;
	if (!isDefined(level.normal_way) || !isDefined(level.normal_way.size))
		return;
	if (!isDefined(level.secret_way) || !isDefined(level.secret_way.size))
		return;

	speed = self.sr_speed;
	way = self.sr_way;

	for (i = 0; i < level.normal_way.size; i++)
	{
		if (way == "ns" + i && speed == 190)
		{
			self.timerHud[2] setText("(PB)");

			if (!isDefined(self.pb_190["ns_" + i]))
				continue;

			if (self.pb_190["ns_" + i].size > 0)
				self.timerHud[2] setText("(PB)                  ^3" + self.pb_190["ns_" + i]["time"].min + ":" + self.pb_190["ns_" + i]["time"].sec + "." + self.pb_190["ns_" + i]["time"].milsec);
		}

		if (way == "ns" + i && speed == 210)
		{
			self.timerHud[2] setText("(PB)");

			if (!isDefined(self.pb_210["ns_" + i]))
				continue;

			if (self.pb_210["ns_" + i].size > 0)
				self.timerHud[2] setText("(PB)                  ^3" + self.pb_210["ns_" + i]["time"].min + ":" + self.pb_210["ns_" + i]["time"].sec + "." + self.pb_210["ns_" + i]["time"].milsec);
		}
	}

	for (i = 0; i < level.secret_way.size; i++)
	{
		if (!isDefined(self.pb_190["s_" + i]))
			continue;

		if (way == "s" + i && speed == 190)
		{
			self.timerHud[2] setText("(PB)");

			if (self.pb_190["s_" + i].size > 0)
				self.timerHud[2] setText("(PB)                  ^3" + self.pb_190["s_" + i]["time"].min + ":" + self.pb_190["s_" + i]["time"].sec + "." + self.pb_190["s_" + i]["time"].milsec);
		}

		if (way == "s" + i && speed == 210)
		{
			self.timerHud[2] setText("(PB)");

			if (!isDefined(self.pb_210["s_" + i]))
				continue;

			if (self.pb_210["s_" + i].size > 0)
				self.timerHud[2] setText("(PB)                  ^3" + self.pb_210["s_" + i]["time"].min + ":" + self.pb_210["s_" + i]["time"].sec + "." + self.pb_210["s_" + i]["time"].milsec);
		}
	}
}
