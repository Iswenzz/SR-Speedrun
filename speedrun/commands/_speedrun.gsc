#include sr\sys\_admins;

main()
{
    cmd("player", 	"speed",    ::cmd_Speed);
	cmd("player", 	"practise", ::cmd_Practise);
}

cmd_Speed(args)
{
    speed = Ternary(self.sr_mode == "190", "210", "190");
    self.sr_mode = speed;
    self pm(fmt("Move speed set to %s", speed));
    self suicide();
}

cmd_Practise(args)
{
	self suicide();

    state = !self.sr_practise;
    self.sr_practise = state;
    self.sr_cheat = state;

    if (self.sr_practise)
    {
        self pm("^2Practise mode enabled!");
        self iPrintLn("Press [{+melee}] to save position");
        self iPrintLn("Press [{+activate}] to load positon");
    }
    else
        self pm("^1Practise mode disabled!");
}
