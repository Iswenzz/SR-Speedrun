#include sr\sys\_events;

main()
{
	flags();

	event("connect", 	braxi\_mod::playerConnect);
	event("disconnect", braxi\_mod::playerDisconnect);
	event("laststand", 	braxi\_mod::playerLastStand);
	event("damage", 	braxi\_mod::playerDamage);
	event("killed", 	braxi\_mod::playerKilled);
	event("command", 	sr\sys\_admins::command);

	level.allies 	= ::allies;
	level.axis 		= ::axis;
	level.spectator = ::spectator;
}

flags()
{
	level.iDFLAGS_RADIUS				= 1;
	level.iDFLAGS_NO_ARMOR				= 2;
	level.iDFLAGS_NO_KNOCKBACK			= 4;
	level.iDFLAGS_PENETRATION			= 8;
	level.iDFLAGS_NO_TEAM_PROTECTION 	= 16;
	level.iDFLAGS_NO_PROTECTION			= 32;
	level.iDFLAGS_PASSTHRU				= 64;
}

allies()
{
	self sr\game\_teams::setTeam("allies");
}

axis()
{
	self sr\game\_teams::setTeam("axis");
}

spectator()
{
	self sr\game\_teams::setTeam("spectator");
}
