///////////////////////////////////////////////////////////////
////|         |///|        |///|       |/\  \/////  ///|  |////
////|  |////  |///|  |//|  |///|  |/|  |//\  \///  ////|__|////
////|  |////  |///|  |//|  |///|  |/|  |///\  \/  /////////////
////|          |//|  |//|  |///|       |////\    //////|  |////
////|  |////|  |//|         |//|  |/|  |/////    \/////|  |////
////|  |////|  |//|  |///|  |//|  |/|  |////  /\  \////|  |////
////|  |////|  |//|  | //|  |//|  |/|  |///  ///\  \///|  |////
////|__________|//|__|///|__|//|__|/|__|//__/////\__\//|__|////
///////////////////////////////////////////////////////////////
/*
	BraXi's Death Run Mod
	
	Website: www.braxi.org
	E-mail: paulina1295@o2.pl

	[DO NOT COPY WITHOUT PERMISSION]
*/

init()
{
	precacheShader( "black" );
	while( 1 )
	{
		level waittill( "player_killed", victim, eInflictor, attacker );

		if( !isDefined( attacker ) || !isDefined(victim) )	
			return;

		thread showPlayerCard( attacker, victim, "" );
	}
}

showPlayerCard( attacker, victim, text )
{
	if( attacker == victim || !isPlayer( attacker ) )
		return;

	level notify( "new emblem" );	// one instance at a time
	level endon( "new emblem" );

	destroyPlayerCard();

	logo1 = level.rankIconInfo[attacker.pers["rank"] - 1]["icon"];
	logo2 = level.rankIconInfo[victim.pers["rank"] - 1]["icon"];

	level.playerCard[0] = newHudElem( level );
	level.playerCard[0].x = 170;
	level.playerCard[0].y = 390;
	level.playerCard[0].alpha = 0;
	level.playerCard[0] setShader( "black", 300, 64 );
	level.playerCard[0].sort = 990;

	//logos
	level.playerCard[1] = braxi\_mod::addTextHud( level, 0, 390, 0, "left", "top", 1.8 ); 
	level.playerCard[1] setShader( logo1, 64, 64 );
	level.playerCard[1].sort = 998;
	
	level.playerCard[2] = braxi\_mod::addTextHud( level, 640, 390, 0, "left", "top", 1.8 ); 
	level.playerCard[2] setShader( logo2, 64, 64 );
	level.playerCard[2].sort = 998;
	
	level.playerCard[3] = braxi\_mod::addTextHud( level, 320, 390, 0, "center", "top", 1.6 ); 
	level.playerCard[3] setText( text );
	level.playerCard[3].sort = 999;

	level.playerCard[4] = braxi\_mod::addTextHud( level, 320, 420, 0, "center", "top", 1.5 ); 
	level.playerCard[4] setText( attacker.name + " ^7killed^7 " + victim.name );
	level.playerCard[4].sort = 999;

	for( i = 3; i < 5; i++ )
	{
		level.playerCard[i].color = (0.8,0.8,0.8);
		level.playerCard[i].glowColor = (0.6,0.6,0.6);
		level.playerCard[i] SetPulseFX( 30, 100000, 700 );
		level.playerCard[i].glowAlpha = 0.8;
	}

	// === animation === //
	level.playerCard[1] moveOverTime( 0.44 );
	level.playerCard[1].x = 170;
	level.playerCard[2] moveOverTime( 0.44 );
	level.playerCard[2].x = 170+300-64;
	for( i = 0; i < level.playerCard.size; i++ )
	{
		level.playerCard[i] fadeOverTime( 0.3 );

		if( i == 0 ) // hack
			level.playerCard[i].alpha = 0.5;
		else
			level.playerCard[i].alpha = 1.0;
	}
	wait 3;

	for( i = 0; i < level.playerCard.size; i++ )
	{
		level.playerCard[i] fadeOverTime( 0.8 );
		level.playerCard[i].alpha = 0;
	}
	wait 0.8;
	
	destroyPlayerCard();
}

destroyPlayerCard()
{
	if( !isDefined( level.playerCard ) || !level.playerCard.size )
		return;

	for( i = 0; i < level.playerCard.size; i++ )
		level.playerCard[i] destroy();
	level.playerCard = [];
}
