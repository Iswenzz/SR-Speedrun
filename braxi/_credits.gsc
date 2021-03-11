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

	showCredit() written by Bipo.
*/

main()
{
	level.creditTime = 6;

	braxi\_common::cleanScreen();

	thread showCredit( "Deathrun Created by Braxi", 2, 40 );
	wait 0.5;
	thread showCredit( "SpeedRun Mod Created by:", 2, 80 );
	wait 0.5;
	thread showCredit( "Sheep Wizard", 1.8, 100 );
	wait 0.5;
	thread showCredit( "Sux Lolz", 1.8, 120 );
	wait 1;
	thread showCredit( "Characters/Weapons Rigged By:", 2.4, 160 );
	wait 0.8;
	thread showCredit( "|MACOM|Hacker", 1.8, 180 );
	wait 0.8;
	thread showCredit( "_INSANE_", 1.8, 200 );
	wait 0.8;
	thread showCredit( "Lenny", 1.8, 220 );
	wait 0.8;
	thread showCredit( "Sanya", 1.8, 240 );
	wait 0.8;
	thread showCredit( "Hacker22", 1.8, 260 );
	wait 0.8;
	thread showCredit( "ConvictioNDR", 1.8, 280 );
	wait 0.8;
	thread showCredit( "mitsurugi", 1.8, 300 );
	wait 0.8;
	thread showCredit( "darkraptor", 1.8, 320 );
	wait 0.8;
	thread showCredit( "Additional Help", 2, 360 );
	wait 0.8;
	thread showCredit( "IzNoGod -- Vc' Blade -- Jax -- Mist -- jaay", 1.8, 380 );
	wait 1.2;

	wait level.creditTime + 2;
}

showCredit( text, scale, y )
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
	end_text.glowColor = (119/255, 0/255, 255/255);
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
	neon = addNeon( "", 1.4 );
	while( 1 )
	{
		neon moveOverTime( 12 );
		neon.x = 800;
		wait 15;
		neon moveOverTime( 12 );
		neon.x = -800;
		wait 15;
	}
}

addNeon( text, scale )
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
