#include sr\sys\_events;
#include sr\utils\_common;

main()
{
	event("death", ::stop);
}

// The world record of the player's mode and way runs beside them, from the given time into the run.
start(time)
{
	self stop();
	self.ghostWay = self.sr_way;

	if (self isDemo() || self isBot() || !self sr\core\_settings::getPlayerSetting("player_ghost", false))
		return;

	id = speedrun\core\_leaderboards::getLeaderboardIndex(self.sr_mode, self.sr_way);
	if (!isDefined(level.demos) || !isDefined(level.demos[id]))
		return;

	demo = level.demos[id];
	if (self StartGhost(id, demo["name"], IfUndef(time, 0), demo["time"].origin))
		self.ghost = id;
}

// The delta against the ghost stays at how the run ended.
finish(time)
{
	if (isDefined(self.ghost))
		self FinishGhost(time);
}

stop()
{
	if (!isDefined(self.ghost))
		return;

	self.ghost = undefined;
	self StopGhost();
}

// A way switch keeps the run's timer, and every way's record is timed from the spawn, so the ghost only
// has to become the new way's record at the same time into the run.
wayChanged()
{
	if (!isDefined(self.ghostWay) || self.ghostWay == self.sr_way)
		return;

	self refresh();
}

// A setting change takes effect in the run under way.
refresh()
{
	if (self isPlaying() && isDefined(self.time) && !self.finishedMap)
		self start(getTime() - self.time.origin);
	else
		self stop();
}
