#include sr\sys\_admins;
#include sr\utils\_common;

main()
{
	cmd("fx",       "player", ::cmd_FX,       "Toggle game FX");
	cmd("practise", "player", ::cmd_Practise, "Toggle practise mode");
	cmd("sheep",    "player", ::cmd_Sheep,    "Toggle sheep mode");
	cmd("teleport", "player", ::cmd_Teleport, "Teleport to a player in practise mode");
    cmd("190",      "player", ::cmd_190,      "Game mode with original movements at 190 g_speed with 1.05 scale");
    cmd("210",      "player", ::cmd_210,      "Game mode with original movements at 210 g_speed with 1.12 scale");
    cmd("q3",       "player", ::cmd_Q3,       "Game mode with Q3 (VQ3) movements");
    cmd("q3cpm",    "player", ::cmd_Q3CPM,    "Game mode with Q3 (CPM) movements");
    cmd("q3cpmw",   "player", ::cmd_Q3CPMW,   "Game mode with Q3 (CPM) movements and weapons");
    cmd("cs",       "player", ::cmd_CS,       "Game mode with CS movements");
    cmd("portal",   "player", ::cmd_Portal,   "Game mode with CS movements and a portal gun");
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

cmd_Q3(args)
{
	self setStat(1700, 3);
	self.sr_mode = "Q3";
    self pm("Run mode: ^5Q3");
	self thread speedrun\core\_leaderboards::updateMenuInfo();
    self suicide();
}

cmd_Q3CPM(args)
{
	self setStat(1700, 4);
	self.sr_mode = "Q3CPM";
    self pm("Run mode: ^5Q3CPM");
	self thread speedrun\core\_leaderboards::updateMenuInfo();
    self suicide();
}

cmd_Q3CPMW(args)
{
	self setStat(1700, 5);
	self.sr_mode = "Q3CPMW";
    self pm("Run mode: ^5Q3CPMW");
	self thread speedrun\core\_leaderboards::updateMenuInfo();
    self suicide();
}

cmd_CS(args)
{
	self setStat(1700, 6);
	self.sr_mode = "CS";
    self pm("Run mode: ^5CS");
	self thread speedrun\core\_leaderboards::updateMenuInfo();
    self suicide();
}

cmd_Portal(args)
{
	self setStat(1700, 7);
	self.sr_mode = "Portal";
    self pm("Run mode: ^5Portal");
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
        self iPrintLn("Bind ^3Practise Save^7, ^3Load^7 and ^3Rewind^7 in Controls > Multiplayer");
        self iPrintLn("Hold ^3[{+activate}]^7 on load for older saves, rewind steps back 1s");
        self iPrintLn("Press ^5[{+frag}]^7 to noclip, ^2[{+gostand}]^7 to exit or speed up");
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

