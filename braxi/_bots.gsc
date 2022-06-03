addTestClients()
{
	if (isDefined(game["matchstarted"]))
		return;
	wait 2;

	ent = [];
	testclients = level.dvar["bots"];
	for (i = 0; i < testclients + 1; i++)
	{
		ent[i] = addTestClient();
		wait .05;
		if (isDefined(ent[i]))
			ent[i] thread TestClient();
		wait 0.5;
	}
}

TestClient()
{
	while (!isDefined(self.pers["team"]))
		wait .05;

	wait 0.05;
	self notify("menuresponse", game["menu_team"], "axis");
}
