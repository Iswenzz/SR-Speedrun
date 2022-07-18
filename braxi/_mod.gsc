#include maps\mp\gametypes\_hud_util;

#include sr\sys\_events;
#include sr\utils\_math;
#include sr\utils\_common;

main()
{
	braxi\_dvar::initDvars();

	level.freeRun = true;
	level.trapsDisabled = false;

	disableTraps();
}

endTimer()
{
	self speedrun\player\run\_main::endTimer();
}

addTextHud(who, x, y, alpha, alignX, alignY, fontScale)
{
	if (isPlayer(who))
		hud = newClientHudElem(who);
	else
		hud = newHudElem();

	hud.x = x;
	hud.y = y;
	hud.alpha = alpha;
	hud.alignX = alignX;
	hud.alignY = alignY;
	hud.fontScale = fontScale;
	return hud;
}

endRoundAnnoucement(text, color)
{
	notifyData = spawnStruct();
	notifyData.titleText = text;
	notifyData.notifyText = ("Starting round ^3" + game["roundsplayed"] + "^7 out of ^3" + level.dvar["round_limit"]);
	notifyData.glowColor = color;
	notifyData.duration = 8.8;

	players = getAllPlayers();
	for (i = 0; i < players.size; i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage(notifyData);
}

disableTraps()
{
	if (!isDefined(level.trapTriggers))
		return;

	level.trapsDisabled = true;
	for (i = 0; i < level.trapTriggers.size; i++)
		if (isDefined(level.trapTriggers[i]))
		level.trapTriggers[i].origin = level.trapTriggers[i].origin - (0, 0, 10000);
	level notify("traps_disabled");
}

endingHud(align, fade_in_time, x_off, y_off)
{
	hud = newHudElem();
	hud.foreground = true;
	hud.x = x_off;
	hud.y = y_off;
	hud.alignX = align;
	hud.alignY = "middle";
	hud.horzAlign = align;
	hud.vertAlign = "middle";
	hud.fontScale = 3;
	hud.color = (0.8, 1.0, 0.8);
	hud.font = "objective";
	hud.glowColor = (0.3, 0.6, 0.3);
	hud.glowAlpha = 1;
	hud.alpha = 0;
	hud fadeovertime(fade_in_time);
	hud.alpha = 1;
	hud.hidewheninmenu = true;
	hud.sort = 10;
	return hud;
}

drawInformation(start_offset, movetime, mult, text)
{
	start_offset *= mult;
	hud = endingHud("center", 0.1, start_offset, 90);
	hud setText(text);
	hud moveOverTime(movetime);
	hud.x = 0;
	wait (movetime);
	wait (3);
	hud moveOverTime(movetime);
	hud.x = start_offset * -1;

	wait movetime;
	hud destroy();
}

giveLife() { }
