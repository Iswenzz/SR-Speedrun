#include sr\sys\_events;
#include sr\utils\_common;
#include sr\utils\_hud;

main()
{
	precacheShader("fps_20");
	precacheShader("fps_30");
	precacheShader("fps_125");
	precacheShader("fps_142");
	precacheShader("fps_166");
	precacheShader("fps_250");
	precacheShader("fps_333");
	precacheShader("fps_500");
	precacheShader("fps_1000");

	precacheShader("key_w");
	precacheShader("key_a");
	precacheShader("key_s");
	precacheShader("key_d");

	event("spawn", ::hud);
	event("spectator", ::hud);
	event("death", ::clear);
}

hud()
{
	self endon("death");
	self endon("disconnect");
	self endon("joined_spectators");

	self clear();
	self hudFps();
	self hudVelocity();
	self hudKeys();

	while (true)
	{
		player = IfUndef(self getSpectatorClient(), self);

		if (!isDefined(player))
		{
			wait 0.05;
			continue;
		}
		if (player != self && !self.settings["hud_spectator"] || player == self && self.isBot)
		{
			self clear();
			break;
		}		

		self updateFps(player);
		self updateVelocity(player);
		self updateKeys(player);
		
		wait 0.05;
	}
}

hudFps()
{
	self.huds["fps"] = addHud(self, -15, -26, 1, "right", "bottom", 1.8);
	self.huds["fps"].archived = false;
	self.huds["fps"].hidewheninmenu = true;
}

hudVelocity()
{
	if (!self.settings["hud_velocity"])
		return;
	
	self.huds["velocity"] = addHud(self, 0, 0, 1,
		getHorizontal(self.settings["hud_velocity"]),
		getVertical(self.settings["hud_velocity"]), 1.6);
	self.huds["velocity"].archived = false;
	self.huds["velocity"].hidewheninmenu = true;
}

hudKeys()
{
	if (self.sessionstate != "spectator")
		return;

	self.huds["keys"] = [];
	self.huds["keys"][0] = addHud(self, 0, -120, 0.6, "center", "bottom", 1.8);
	self.huds["keys"][0].archived = false;
	self.huds["keys"][0] setShader("key_w", 30, 30);
	self.huds["keys"][0].hidewheninmenu = true;

	self.huds["keys"][1] = addHud(self, -35, -85, 0.6, "center", "bottom", 1.8);
	self.huds["keys"][1].archived = false;
	self.huds["keys"][1] setShader("key_a", 30, 30);
	self.huds["keys"][1].hidewheninmenu = true;

	self.huds["keys"][2] = addHud(self, 0, -85, 0.6, "center", "bottom", 1.8);
	self.huds["keys"][2].archived = false;
	self.huds["keys"][2] setShader("key_s", 30, 30);
	self.huds["keys"][2].hidewheninmenu = true;

	self.huds["keys"][3] = addHud(self, 35, -85, 0.6, "center", "bottom", 1.8);
	self.huds["keys"][3].archived = false;
	self.huds["keys"][3] setShader("key_d", 30, 30);
	self.huds["keys"][3].hidewheninmenu = true;
}

updateKeys(player)
{
	if (!isDefined(self.huds["keys"]) || !self.huds["keys"].size || self.sessionstate != "spectator")
		return;

	self.huds["keys"][0].alpha = Ternary(player forwardButtonPressed(), 1, 0.6);
	self.huds["keys"][1].alpha = Ternary(player moveLeftButtonPressed(), 1, 0.6);
	self.huds["keys"][2].alpha = Ternary(player backButtonPressed(), 1, 0.6);
	self.huds["keys"][3].alpha = Ternary(player moveRightButtonPressed(), 1, 0.6);
}

updateFps(player)
{
	fps = player getFPS();

	switch (fps)
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
			self.huds["fps"] setShader("fps_" + fps, 90, 60);
			break;
	}
}

updateVelocity(player)
{
	self.huds["velocity"] setValue(player getPlayerVelocity());
}

clear()
{
	if (isDefined(self.huds["fps"]))
		self.huds["fps"] destroy();
	if (isDefined(self.huds["velocity"]))
		self.huds["velocity"] destroy();
	if (isDefined(self.huds["keys"]))
	{
		for (i = 0; i < self.huds["keys"].size; i++)
		{
			if (isDefined(self.huds["keys"][i]))
				self.huds["keys"][i] destroy();
		}
	}
}
