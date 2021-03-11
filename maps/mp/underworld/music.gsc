//////////////////////////////////////////////////
////////////| mp_deathrun_underworld |////////////
//////////////////////////////////////////////////
//////////////| map made by Icomar |//////////////
//////////////////////////////////////////////////
///////////////| xFire: icomar727 |///////////////
//////////////////////////////////////////////////
///////////////| Thanks to: Blade |///////////////
//////////////////////////////////////////////////



main()
{

    ambientPlay( "ambient1" );
	
	thread sniper();
	thread knife();
	thread bounce();
	thread old();

}
	
sniper()
{
    trigger = getEnt ("sniper_room", "targetname");
	
	trigger waittill ("trigger", player );
	ambientStop(0);
	wait 3;
	ambientPlay( "ambient2" );
}

knife()
{
    trigger = getEnt ("knife_room", "targetname");
	
	trigger waittill ("trigger", player );
	ambientStop(0);
	wait 3;
	ambientPlay( "ambient2" );
}

bounce()
{
    trigger = getEnt ("bounce_room", "targetname");
	
	trigger waittill ("trigger", player );
	ambientStop(0);
	wait 3;
	ambientPlay( "ambient2" );
}

old()
{
    trigger = getEnt ("old_way", "targetname");
	
	trigger waittill ("trigger", player );
	ambientStop(0);
	wait 3;
	ambientPlay( "ambient2" );
}