setPlayerModel()
{
	if (self getStat(980) > level.numCharacters)
		self setStat(980, 0);
	if (self getStat(985) > level.numGlove)
		self setStat(985, 0);

	self detachAll();
	cid = self getStat(980);
	hid = self getStat(985);

	// if a player doesnt have a char model, he will have unlimited health and can cause alot of bugs
	if (!isDefined(level.characterInfo[cid]))
	{
		self setStat(980, 0);
		cid = 0;
	}

	self setModel(level.characterInfo[cid]["model"]);
	self setViewModel(level.gloveInfo[hid]["model"]);
}

setHealth()
{
	self.maxhealth = 100;
	switch (self.pers["team"])
	{
		case "allies":
		self.maxhealth = level.dvar["allies_health"];
		break;

		case "axis":
		self.maxhealth = level.dvar["axis_health"];
		break;

	}
	self.health = self.maxhealth;
}

setTeam(team)
{
	if (self.pers["team"] == team)
		return;

	if (isAlive(self))
		self suicide();

	self.pers["weapon"] = "none";
	self.pers["team"] = team;
	self.team = team;
	self.sessionteam = team;

	menu = game["menu_team"];
	if (team == "allies")
		self.pers["weapon"] = "colt45_mp";
	else if (team == "axis")
		self.pers["weapon"] = "knife_mp";
	self setClientDvars("g_scriptMainMenu", menu);
}

setSpectatePermissions()
{
	self allowSpectateTeam("allies", true);
	self allowSpectateTeam("axis", true);
	self allowSpectateTeam("none", false);
}
