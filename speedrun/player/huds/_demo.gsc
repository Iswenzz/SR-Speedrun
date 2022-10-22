#include sr\sys\_events;
#include sr\utils\_hud;
#include sr\utils\_common;

main()
{
	event("death", ::clear);
}

hud()
{
	self endon("death");
	self endon("disconnect");
	self endon("joined_spectators");
	self endon("demo_stop");

	self clear();
	self huds();

	timer = 1000;

	while (true)
	{
		time = originToTime(timer);
		self.huds["speedrun"]["row1"] setText(fmt("%d:%d.%d", time.min, time.sec, int(time.ms / 100)));
		timer += 50;

		wait 0.05;
	}
}

huds()
{
	time = self.demo["time"];
	timeFormat = fmt("%d:%d.%d", time.min, time.sec, time.ms);
	wayName = speedrun\game\_leaderboards::getLeaderboardName(self.demo["mode"], self.demo["way"]);

	self.huds["demo"] = [];

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
