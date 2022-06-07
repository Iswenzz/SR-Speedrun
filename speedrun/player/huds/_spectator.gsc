#include sr\sys\_events;
#include sr\utils\_common;
#include sr\utils\_hud;

main()
{
	precacheShader("key_w");
	precacheShader("key_a");
	precacheShader("key_s");
	precacheShader("key_d");

	event("spawn", ::clear);
	event("spectator", ::hud);
}

hud()
{
	self endon("disconnect");
	self endon("spawned_player");

	self hudKeys();
	self hudFps();

	while (self.sessionstate == "spectator")
	{
		wait 0.05;
		player = self getSpectatorClient();

		if (!isDefined(player))
			continue;

		self updateKeys(player);
		self updateFps(player);
		self updateVelocity(player);
	}
}

hudFps()
{
	self.huds["spectator_fps"] = [];
	self.huds["spectator_fps"] = addhud(self, 0, 50, 1, "center", "top", 1.8);
	self.huds["spectator_fps"].archived = false;
	self.huds["spectator_fps"].horzAlign = "center";
	self.huds["spectator_fps"].vertAlign = "top";
	self.huds["spectator_fps"].hidewheninmenu = true;

	self.huds["spectator_velocity"] = [];
	self.huds["spectator_velocity"] = addhud(self, 0, 0, 1, "center", "bottom", 1.8);
	self.huds["spectator_velocity"].archived = false;
	self.huds["spectator_velocity"].horzAlign = "center";
	self.huds["spectator_velocity"].vertAlign = "bottom";
	self.huds["spectator_velocity"].hidewheninmenu = true;
}

hudKeys()
{
	self.huds["spectator_keys"] = [];

	self.huds["spectator_keys"][0] = addHud(self, 320, 370, 0.6, "center", "bottom", 1.8);
	self.huds["spectator_keys"][0].archived = false;
	self.huds["spectator_keys"][0] setShader("key_w", 30, 30);
	self.huds["spectator_keys"][0].hidewheninmenu = true;

	self.huds["spectator_keys"][1] = addHud(self, 285, 405, 0.6, "center", "bottom", 1.8);
	self.huds["spectator_keys"][1].archived = false;
	self.huds["spectator_keys"][1] setShader("key_a", 30, 30);
	self.huds["spectator_keys"][1].hidewheninmenu = true;

	self.huds["spectator_keys"][2] = addHud(self, 320, 405, 0.6, "center", "bottom", 1.8);
	self.huds["spectator_keys"][2].archived = false;
	self.huds["spectator_keys"][2] setShader("key_s", 30, 30);
	self.huds["spectator_keys"][2].hidewheninmenu = true;

	self.huds["spectator_keys"][3] = addHud(self, 355, 405, 0.6, "center", "bottom", 1.8);
	self.huds["spectator_keys"][3].archived = false;
	self.huds["spectator_keys"][3] setShader("key_d", 30, 30);
	self.huds["spectator_keys"][3].hidewheninmenu = true;
}

clear()
{
	if (isDefined(self.huds["spectator_fps"]))
		self.huds["spectator_fps"] destroy();
	if (isDefined(self.huds["spectator_keys"]))
	{
		for (i = 0; i < self.huds["spectator_keys"].size; i++)
			self.huds["spectator_keys"][i] destroy();
	}
	if (isDefined(self.huds["spectator_velocity"]))
		self.huds["spectator_velocity"] destroy();
}

updateKeys(player)
{
	self.huds["spectator_keys"][0].alpha = Ternary(player forwardButtonPressed(), 1, 0.6);
	self.huds["spectator_keys"][1].alpha = Ternary(player moveLeftButtonPressed(), 1, 0.6);
	self.huds["spectator_keys"][2].alpha = Ternary(player backButtonPressed(), 1, 0.6);
	self.huds["spectator_keys"][3].alpha = Ternary(player moveRightButtonPressed(), 1, 0.6);
}

updateFps(player)
{
	player.fps = ToInt(player getUserInfo("com_maxfps"));

	switch (player.fps)
	{
		case 20:
		case 30:
		case 125:
		case 142:
		case 166:
		case 250:
		case 333:
		case 500:
		case 1000:
			self.huds["spectator_fps"] setShader("fps_" + player.fps, 90, 60);
			break;
	}
}

updateVelocity(player)
{
	self.huds["spectator_velocity"] setValue(player getPlayerVelocity());
}
