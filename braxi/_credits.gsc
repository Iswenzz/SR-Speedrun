main()
{
	level.creditTime = 4;

	braxi\_common::cleanScreen();

	thread showCredit("SR Mod (c) 2016-2022", 2, 80);
	wait 0.5;
	thread showCredit("SuX Lolz", 1.8, 120);
	wait 1;
	thread showCredit("Additional Help", 2, 160);
	wait 0.5;
	thread showCredit("Sheep Wizard", 1.7, 200);
	wait 0.5;
	thread showCredit("IzNoGod", 1.7, 240);
	wait 0.5;
	thread showCredit("Vc' Blade", 1.7, 280);
	wait 0.5;
	thread showCredit("3xP' Noob", 1.7, 320);
	wait 1;

	wait level.creditTime + 2;
}

showCredit(text, scale, y)
{
	end_text = newHudElem();
	end_text.font = "objective";
	end_text.fontScale = scale;
	end_text SetText(text);
	end_text.alignX = "center";
	end_text.alignY = "top";
	end_text.horzAlign = "center";
	end_text.vertAlign = "top";
	end_text.x = 0;
	end_text.y = y;
	end_text.sort = -1;
	end_text.glowColor = (119 / 255, 0 / 255, 255 / 255);
	end_text.glowAlpha = 1;
	end_text.alpha = 0;
	end_text fadeOverTime(0.9);
	end_text.alpha = 1;
	end_text.foreground = true;
	wait level.creditTime;
	end_text fadeOverTime(0.9);
	end_text.alpha = 0;
	wait 0.9;
	end_text destroy();
}

neon()
{
	neon = addNeon("", 1.4);
	while (1)
	{
		neon moveOverTime(12);
		neon.x = 800;
		wait 15;
		neon moveOverTime(12);
		neon.x = -800;
		wait 15;
	}
}

addNeon(text, scale)
{
	end_text = newHudElem();
	end_text.font = "objective";
	end_text.fontScale = scale;
	end_text SetText(text);
	end_text.alignX = "center";
	end_text.alignY = "top";
	end_text.horzAlign = "center";
	end_text.vertAlign = "top";
	end_text.x = -200;
	end_text.y = 8;
	end_text.sort = -1;
	end_text.alpha = 1;
	end_text.foreground = true;
	return end_text;
}
