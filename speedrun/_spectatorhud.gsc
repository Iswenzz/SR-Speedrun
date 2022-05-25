init()
{
	self endon("disconnect");
	self notify("spechud_end");
	self endon("spechud_end");

	wait 0.05;

	self thread watchspec();

	fps = undefined;

	while (self.sessionstate == "spectator")
	{
		player = self getspectatorClient();

		if (!isDefined(player))
		{
			wait 0.05;
			continue;
		}

		if (!isDefined(self.keyshudspec))
			keyshud();

		if (!isDefined(self.fpshudspec))
			fpshud();

		if (!player.isBot)
			self watchkeys(player);
		else
			self watchkeys_bot(player);

		self.velocity_hudspec setValue(getPlayerSpecedVelocity(player));

		if (!player.isBot)
			fps = player getuserinfo("com_maxfps");
		else
			fps = player.bot_fps;

		if (!isDefined(fps))
		{
			wait 0.05;
			continue;
		}

		switch (fps)
		{
			case "20":
			case "30":
			case "125":
			case "142":
			case "166":
			case "250":
			case "333":
			case "500":
			case "1000":
				self.fpshudspec SetShader("fps_" + fps, 90, 60);
			break;

		}
		wait 0.05;
	}
}

getPlayerSpecedVelocity(player)
{
	velocity = player getVelocity();
	return int(sqrt((velocity[0] * velocity[0]) + (velocity[1] * velocity[1])));
}

watchspec()
{
	self waittill("spawned_player");

	if (isDefined(self.fpshudspec))
		self.fpshudspec Destroy();

	if (isDefined(self.velocity_hudspec))
		self.velocity_hudspec Destroy();

	if (isDefined(self.keyshudspec))
		for (i = 0; i < self.keyshudspec.size; i++)
		self.keyshudspec[i] Destroy();

	self.keyshudspec = undefined;
	self.fpshudspec = undefined;
	self.velocity_hudspec = undefined;
}

watchkeys(a)
{
	self endon("spec_end");
	self endon("disconnect");
	self endon("spawned_player");
	a endon("disconnect");

	if (a forwardButtonPressed())
		self.keyshudspec[0].alpha = 1;
	else
		self.keyshudspec[0].alpha = 0.6;

	if (a moveLeftButtonPressed())
		self.keyshudspec[1].alpha = 1;
	else
		self.keyshudspec[1].alpha = 0.6;

	if (a backButtonPressed())
		self.keyshudspec[2].alpha = 1;
	else
		self.keyshudspec[2].alpha = 0.6;

	if (a moveRightButtonPressed())
		self.keyshudspec[3].alpha = 1;
	else
		self.keyshudspec[3].alpha = 0.6;

}

watchkeys_bot(a)
{
	self endon("spec_end");
	self endon("disconnect");
	self endon("spawned_player");
	a endon("disconnect");

	if (isDefined(a.key_w) && a.key_w == 1)
		self.keyshudspec[0].alpha = 1;
	if (isDefined(a.key_w) && a.key_w == 0)
		self.keyshudspec[0].alpha = 0.6;

	if (isDefined(a.key_a) && a.key_a == 1)
		self.keyshudspec[1].alpha = 1;
	if (isDefined(a.key_a) && a.key_a == 0)
		self.keyshudspec[1].alpha = 0.6;

	if (isDefined(a.key_s) && a.key_s == 1)
		self.keyshudspec[2].alpha = 1;
	if (isDefined(a.key_s) && a.key_s == 0)
		self.keyshudspec[2].alpha = 0.6;

	if (isDefined(a.key_d) && a.key_d == 1)
		self.keyshudspec[3].alpha = 1;
	if (isDefined(a.key_d) && a.key_d == 0)
		self.keyshudspec[3].alpha = 0.6;
}

fpsHud()
{
	self.fpshudspec = addhud(self, 0, 50, 1, "center", "top", 1.8);
	self.fpshudspec.archived = false;
	self.fpshudspec.horzAlign = "center";
	self.fpshudspec.vertAlign = "top";
	self.fpshudspec.hidewheninmenu = true;

	self.velocity_hudspec = addhud(self, 0, 0, 1, "center", "bottom", 1.8);
	self.velocity_hudspec.archived = false;
	self.velocity_hudspec.horzAlign = "center";
	self.velocity_hudspec.vertAlign = "bottom";
	self.velocity_hudspec.hidewheninmenu = true;
}

keyshud()
{
	self.keyshudspec = [];

	self.keyshudspec[0] = addHud(self, 320, 370, 0.6, "center", "bottom", 1.8);
	self.keyshudspec[0].archived = false;
	self.keyshudspec[0] SetShader("key_w", 30, 30);
	self.keyshudspec[0].hidewheninmenu = true;

	self.keyshudspec[1] = addHud(self, 285, 405, 0.6, "center", "bottom", 1.8);
	self.keyshudspec[1].archived = false;
	self.keyshudspec[1] SetShader("key_a", 30, 30);
	self.keyshudspec[1].hidewheninmenu = true;

	self.keyshudspec[2] = addHud(self, 320, 405, 0.6, "center", "bottom", 1.8);
	self.keyshudspec[2].archived = false;
	self.keyshudspec[2] SetShader("key_s", 30, 30);
	self.keyshudspec[2].hidewheninmenu = true;

	self.keyshudspec[3] = addHud(self, 355, 405, 0.6, "center", "bottom", 1.8);
	self.keyshudspec[3].archived = false;
	self.keyshudspec[3] SetShader("key_d", 30, 30);
	self.keyshudspec[3].hidewheninmenu = true;
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
	hud.fontScale = fontScale;
	return hud;
}
