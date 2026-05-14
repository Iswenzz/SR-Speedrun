#include sr\sys\_admins;
#include sr\utils\_common;

main()
{
	cmd("fxenable", "player", ::cmd_FX,       "Toggle game FX");
	cmd("practise", "player", ::cmd_Practise, "Toggle practise mode");
	cmd("sheep",    "player", ::cmd_Sheep,    "Toggle sheep mode");
	cmd("teleport", "player", ::cmd_Teleport, "Teleport to a player in practise mode");
    cmd("190",      "player", ::cmd_190,      "Game mode with original movements at 190 g_speed with 1.05 scale");
    cmd("210",      "player", ::cmd_210,      "Game mode with original movements at 210 g_speed with 1.12 scale");
    cmd("bhop",     "player", ::cmd_Bhop,     "Game mode with bunny hop at 320 g_speed and 0.9 scale");
    cmd("defrag",   "player", ::cmd_Defrag,   "Game mode with bunny hop and defrag weapons at 320 g_speed and 0.9 scale");
    cmd("portal",   "player", ::cmd_Portal,   "Game mode with a portal gun at 210 g_speed with 1.12 scale");
    cmd("speed",    "player", ::cmd_Speed,    "Toggle between 190 and 210 game mode");
}

cmd_Speed(args)
{
    speed = Ternary(self.sr_mode == "190", "210", "190");
	self setStat(1700, Ternary(speed == "190", 1, 2));
    self.sr_mode = speed;
    self pm(fmt("Run mode: ^5%s", speed));
	self thread speedrun\core\_leaderboards::updateMenuInfo();
    self suicide();
}

cmd_190(args)
{
	self setStat(1700, 1);
	self.sr_mode = "190";
    self pm("Run mode: ^5190");
	self thread speedrun\core\_leaderboards::updateMenuInfo();
    self suicide();
}

cmd_210(args)
{
	self setStat(1700, 2);
	self.sr_mode = "210";
    self pm("Run mode: ^5210");
	self thread speedrun\core\_leaderboards::updateMenuInfo();
    self suicide();
}

cmd_Portal(args)
{
	if (self sr\core\_modes::isInMode("portal"))
		return;

	self setStat(1700, 3);
	self.sr_mode = "Portal";
    self pm("Run mode: ^5Portal");
	self thread speedrun\core\_leaderboards::updateMenuInfo();
    self suicide();
}

cmd_Defrag(args)
{
	if (self sr\core\_modes::isInMode("defrag"))
		return;

	self setStat(1700, 4);
	self.sr_mode = "Defrag";
    self pm("Run mode: ^5Defrag");
	self thread speedrun\core\_leaderboards::updateMenuInfo();
    self suicide();
}

cmd_Bhop(args)
{
	self setStat(1700, 5);
	self.sr_mode = "Bhop";
    self pm("Run mode: ^5Bhop");
	self thread speedrun\core\_leaderboards::updateMenuInfo();
    self suicide();
}

cmd_Practise(args)
{
    if (self sr\core\_modes::isInOtherMode("practise"))
		return;

	self sr\core\_modes::toggleMode("practise");
	self suicide();

    if (self.modes["practise"])
    {
        self pm("^2Practise mode enabled!");
        self iPrintLn("Press ^3[{+melee}]^7 to save position");
        self iPrintLn("Press ^3[{+activate}]^7 to load positon");
        self iPrintLn("Press ^5[{+frag}]^7 to noclip");
        self iPrintLn("Press ^2[{+gostand}]^7 to remove noclip or speed up");
    }
    else
        self pm("^1Practise mode disabled!");
}

cmd_Teleport(args)
{
	if (args.size < 1)
		return self pm("Usage: teleport <playerName>");
	if (!self sr\core\_modes::isInMode("practise"))
		return self pm("^1Player need to be in practise mode");

	player = getPlayerByName(args[0]);

	if (!isDefined(player))
		return pm("Could not find player");

	self cheat();
	self setOrigin(player.origin);
}

cmd_Sheep(args)
{
	for (i = 0; i < 25; i++)
	{
		self iPrintLnBold("^3S^2h^1e^4e^6p ^3w^2i^1z^4a^6r^5d");
		wait 0.1;
	}
	self setClientDvar("r_specular", 1);
	self setClientDvar("r_specularmap", 2);
}

cmd_FX(args)
{
	self sr\core\_settings::toggle("gfx_fx");

	msg = Ternary(self.settings["gfx_fx"], "^2FX On", "^1FX Off");
	self pm(msg);
}

