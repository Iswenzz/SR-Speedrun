#include sr\sys\_events;
#include sr\utils\_hud;
#include sr\utils\_common;

main()
{
	event("death", ::clear);
}

hud()
{
	wait 0.05;

	self endon("death");
	self endon("disconnect");
	self endon("joined_spectators");
	self endon("demo_stop");

	if (!isDefined(self.demo))
		return;

	self clear();
	self huds();

	while (true)
	{
		time = originToTime(1000 + self getDemoTimer());
		self.huds["speedrun"]["row1"] setText(fmt("%d:%d.%d", time.min, time.sec, int(time.ms / 100)));

		wait 0.05;
	}
}

huds()
{
	time = self.demo["time"];
	timeFormat = fmt("%d:%d.%d", time.min, time.sec, time.ms);
	wayName = speedrun\game\_leaderboards::getLeaderboardName(self.demo["mode"], self.demo["way"]);

	self.huds["demo"] = [];
	self.huds["demo"]["rewind"] = addHud(self, 3, -50, 1, "left", "bottom", 1.4);
	self.huds["demo"]["rewind"] setText("Hold ^5[{+back}]^7 to rewind");
	self.huds["demo"]["slowmo"] = addHud(self, 3, -35, 1, "left", "bottom", 1.4);
	self.huds["demo"]["slowmo"] setText("Hold ^5[{+gostand}]^7 to slowmo");

	self.huds["speedrun"]["row2"] setText(self.demo["name"]);
	self.huds["speedrun"]["row3"] setText("^2" + timeFormat);
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
