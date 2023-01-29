main()
{

}

start()
{
	level endon("intermission");
	level endon("game over");

	while (true)
	{
		bot = addTestClient();
		bot.run = "^5Bot";

		wait 0.1;
		bot notify("menuresponse", "main_mp", "autoassign");

		wait 10;
		self notify("menuresponse", "main_mp", "spectator");
	}
}
