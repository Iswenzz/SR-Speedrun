#include sr\sys\_events;
#include sr\utils\_hud;
#include sr\utils\_common;
#include sr\utils\_math;

main()
{
	event("death", ::clear);
}

hud()
{
	self endon("spawned");
	self endon("death");
	self endon("disconnect");

	if (!self isDemo())
		return;

	self clear();
	self huds();

	version = self getDemoVersion();
	timeOffset = Ternary(version == 1, 900, -100);

	while (true)
	{
		origin = timeOffset + self getDemoTimer();
		if (origin < 0)
			origin = 0;

		time = originToTime(origin);
		self.huds["speedrun"]["row1"] setText(speedrun\core\_run::formatTime(time, !self jumpButtonPressed()));

		wait 0.05;
	}
}

huds()
{
	timeFormat = speedrun\core\_run::formatTime(self.demo["time"]);
	wayName = speedrun\core\_leaderboards::getLeaderboardName(self.demo["mode"], self.demo["way"]);

	self.huds["demo"] = [];
	self.huds["demo"]["fastforward"] = addHud(self, 3, -50, 1, "left", "bottom", 1.4);
	self.huds["demo"]["fastforward"] setText("Hold ^5[{+forward}]^7 to fast forward");
	self.huds["demo"]["rewind"] = addHud(self, 3, -35, 1, "left", "bottom", 1.4);
	self.huds["demo"]["rewind"] setText("Hold ^5[{+back}]^7 to rewind");
	self.huds["demo"]["slowmo"] = addHud(self, 3, -20, 1, "left", "bottom", 1.4);
	self.huds["demo"]["slowmo"] setText("Hold ^5[{+gostand}]^7 to slowmo");

	self.huds["speedrun"]["row2"] setText(self.demo["name"]);
	self.huds["speedrun"]["row2"].label = level.texts["empty"];
	self.huds["speedrun"]["row3"] setText("^2" + timeFormat);
	self.huds["speedrun"]["row3"].label = level.texts["empty"];
	self.huds["speedrun"]["mode"] setText(self.demo["mode"]);
	self.huds["speedrun"]["name"] setText(wayName);
}

clear()
{
	if (isDefined(self.huds["demo"]))
	{
		keys = getArrayKeys(self.huds["demo"]);
		for (i = 0; i < keys.size; i++)
		{
			if (isDefined(self.huds["demo"][keys[i]]))
				self.huds["demo"][keys[i]] destroy();
		}
	}
}
