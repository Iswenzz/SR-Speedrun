#include sr\sys\_events;
#include sr\utils\_common;

main()
{
	menu("sr_leaderboard", "open", ::menu_Open);
	menu("sr_leaderboard", "demo", ::menu_Demo);
	menu_multiple("sr_leaderboard", "way", ::menu_Leaderboard);
	menu_multiple("sr_leaderboard", "mode", ::menu_Mode);
}

menu_Open(arg)
{
	if (!isDefined(self.leaderboard_way))
		self.leaderboard_way = self.sr_way;
	if (!isDefined(self.leaderboard_mode))
		self.leaderboard_mode = self.sr_mode;

	self display();
}

menu_Demo(arg)
{
	index = speedrun\core\_leaderboards::getLeaderboardIndex(self.leaderboard_mode, self.leaderboard_way);
	self thread speedrun\core\_demo::play(index);

	self closeMenu();
	self closeInGameMenu();
}

menu_Leaderboard(args)
{
	way = args[1];

	self.leaderboard_way = way;
	self display();
}

menu_Mode(args)
{
	mode = args[1];

	self.leaderboard_mode = mode;
	self display();
}

display()
{
	if (!speedrun\core\_leaderboards::mapHasLeaderboards())
		return;

	numbers = "";
	names = "";
	times = "";

	leaderboard = speedrun\core\_leaderboards::getLeaderboard(self.leaderboard_mode, self.leaderboard_way);
	if (!isDefined(leaderboard))
		return;

	entries = leaderboard.entries;

	self setClientDvar("leaderboard_name", fmt("%s ^7%s", self.leaderboard_mode, leaderboard.name));

	if (!isDefined(entries))
		return;

	for (i = 0; i < int(level.leaderboard_max_entries / 10); i++)
	{
		self setClientDvars(
			"leaderboard_numbers_" + i, "",
			"leaderboard_names_" + i, "",
			"leaderboard_values_" + i, ""
		);
	}

	stringIndex = 0;
	for (i = 0; i < entries.size; i++)
    {
		placement = i + 1;
		numbers += fmt("#%d\n", placement);
        color = "^7";

		switch (placement)
		{
			case 1: color = "^3"; break;
			case 2: color = "^>"; break;
			case 3: color = "^<"; break;
		}

		names += fmt("%s%s^7\n", color, entries[i]["name"]);
		times += fmt("^7%d:%d.%d\n", entries[i]["time"].min, entries[i]["time"].sec, entries[i]["time"].ms);

		if (!(placement % 10) || i == entries.size - 1)
		{
			self setClientDvars(
				"leaderboard_numbers_" + stringIndex, numbers,
				"leaderboard_names_" + stringIndex, names,
				"leaderboard_values_" + stringIndex, times
			);

			numbers = "";
			names = "";
			times = "";
			stringIndex++;
		}
	}
}
