#include sr\sys\_admins;

main()
{
    cmd("player", 	"defrag",   ::cmd_Defrag);
    cmd("player", 	"speed",    ::cmd_Speed);
    cmd("player", 	"portal",   ::cmd_Portal);
	cmd("player", 	"practise",	::cmd_Practise);
}

cmd_Speed(args)
{
    speed = Ternary(self.sr_mode == "190", "210", "190");
	self setStat(1700, Ternary(speed == "190", 1, 2));
    self.sr_mode = speed;
    self pm(fmt("Run mode: ^5%s", speed));
    self suicide();
}

cmd_Portal(args)
{
	if (self sr\player\modes\_main::isInMode("portal"))
		return;

	self setStat(1700, 3);
	self.sr_mode = "Portal";
    self pm("Run mode: ^5Portal");
    self suicide();
}

cmd_Defrag(args)
{
	if (self sr\player\modes\_main::isInMode("defrag"))
		return;

	self setStat(1700, 4);
	self.sr_mode = "Defrag";
    self pm("Run mode: ^3Defrag");
    self suicide();
}

cmd_Practise(args)
{
    if (self sr\player\modes\_main::isInOtherMode("practise"))
		return;

	self sr\player\modes\_main::toggleMode("practise");
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
