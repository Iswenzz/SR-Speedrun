//////////////////////\\\\\\\\\\\\\\\\\\\\\\//////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//    __              ___                 \\//                                   ____    ____         \\
//   /\ \            /\_ \                \\//         __                       /\  _`\ /\  _`\       \\
//   \ \ \        ___\//\ \    ____       \\//    ____/\_\   __  _  ____     ___\ \ \L\ \ \ \L\ \     \\
//    \ \ \  __  / __`\\ \ \  /\_ ,`\     \\//   /',__\/\ \ /\ \/'\/\_ ,`\  / __`\ \ ,  /\ \ ,  /     \\
//     \ \ \L\ \/\ \L\ \\_\ \_\/_/  /_    \\//  /\__, `\ \ \\/>  </\/_/  /_/\ \L\ \ \ \\ \\ \ \\ \    \\
//      \ \____/\ \____//\____\ /\____\   \\//  \/\____/\ \_\/\_/\_\ /\____\ \____/\ \_\ \_\ \_\ \_\  \\
//       \/___/  \/___/ \/____/ \/____/   \\//   \/___/  \/_/\//\/_/ \/____/\/___/  \/_/\/ /\/_/\/ /  \\
// 								          \\// 								                          \\
//////////////////////\\\\\\\\\\\\\\\\\\\\\\//////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
				 //////////////////////////\////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
				 //  Map by 'sixzoRR (edited by Lolz) | Scripted by Lolz / 'sixzoRR  \\
				 //                  All textures & Skybox by Lolz                   \\
				 //                     'sixzoRR Skype: dinac777                     \\
				 //               Lolz Steam: iswenzz1528 / SuX Lolz :]              \\
				 ///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

main()
{
thread sr\api\_map::createSpawnOrigin((-66.063, 538.287, 14.125), 270);
 maps\mp\_load::main();

 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"] = "desert";

	//SETDVAR**
	setdvar( "r_specularcolorscale", "1" );

	setdvar("compassmaxrange","1600");

	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setDvar("bg_falldamagemaxheight", 2000000000 );
	setDvar("bg_falldamageminheight", 1500000000 );
	//SETDVAR*

	//THREAD**

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Secret Way;");

	thread sr\api\_speedrun::createTeleporter((-14.4884, 2512.23, 475.038), 2810, 1000, (-66.063, 538.287, 14.125), 270, "freeze", "blue");

	thread startdoor();
	thread secret1();
	thread end();

	entTransporter = getentarray( "enter", "targetname" );
	if(isdefined(entTransporter))
	for( i = 0; i < entTransporter.size; i++ )
	entTransporter[i] thread transporter();
}

transporter() 
{
	for(;;)
	{
		self waittill( "trigger", player );
		entTarget = getEnt( self.target, "targetname" );
		if ( self.target == "auto35") {
			player sr\api\_speedrun::changeWay("secret_0");
		}
		player setOrigin( entTarget.origin );
		player setplayerangles( entTarget.angles );
		wait 0.1;
	}
}

end() 
{
trigger = GetEnt( "end", "targetname" );
	while (1){
		trigger waittill ("trigger", player);
        player thread braxi\_mod::endTimer();
    }
}


startdoor()
{
	door=getent("startdoor","targetname");
	door delete();
}

secret1()
{
secret = getEnt("secret_1", "targetname");

secret delete();
	
}

