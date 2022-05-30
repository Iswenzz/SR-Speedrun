main()
{
    cmd("player", 	"speed",    ::cmd_Speed);
	cmd("player", 	"practise", ::cmd_Practise);
}

cmd_Speed()
{
    speed = Ternary(self.sr_speed == 190, 210, 190);
    self.sr_speed = speed;
    self sr\sys\_admins::pm(fmt("Move speed set to %d", speed));
    self suicide();
}

cmd_Practise()
{
    state = !self.sr_practise;
    self.sr_practise = state;
    self.sr_cheatmode = state;
    
    if (self.sr_practise)
    {
        self iPrintLnBold("^2Practise mode enabled!");
        self iPrintLnBold("Press [{+melee}] to save position");
        self iPrintLnBold("Press [{+activate}] to load positon");
    }
    else
        self iPrintLnBold("^1Practise mode disabled!");
    self suicide();
}
