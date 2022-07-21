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
thread sr\api\_map::createSpawnOrigin((-66.063, 538.287, 14.125), 307);
 maps\mp\_load::main();

 level._effect[ "firepartic" ] = loadfx( "fire/custom_fire_r" );

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

	thread lift();
	thread fireparticles();
	thread startdoor();
	thread secret1();
	thread mrotate();
	thread end();

	entTransporter = getentarray( "enter", "targetname" );
	if(isdefined(entTransporter))
	for( i = 0; i < entTransporter.size; i++ )
	entTransporter[i] thread transporter();
}

transporter() {
	for(;;)
	{
		self waittill( "trigger", player );
		entTarget = getEnt( self.target, "targetname" );
		if ( self.target == "auto35") {
			iprintlnbold("entered secret");
			player sr\api\_speedrun::changeWay("secret_0");
		}
		player setOrigin( entTarget.origin );
		player setplayerangles( entTarget.angles );
		wait 0.1;
	}
}

end() //First D:
{
trigger = GetEnt( "end", "targetname" );
	while (1){
		trigger waittill ("trigger", player);
        player thread braxi\_mod::endTimer();
    }
}

mrotate()
{
rotate1 = getEnt("m_turn1", "targetname");
rotate2 = getEnt("m_turn2", "targetname");
rotate3 = getEnt("m_turn3", "targetname");

	while(1)
	{
	rotate1 rotateYaw(360, 4);
	rotate2 rotateYaw(-360, 4);
	rotate3 rotateYaw(360, 4);
	wait 3;
	}
}

fireparticles()
{
fire1 = getEnt("fx_fire1", "targetname");
fire2 = getEnt("fx_fire2", "targetname");
fire3 = getEnt("fx_fire3", "targetname");
fire4 = getEnt("fx_fire4", "targetname");
fire5 = getEnt("fx_fire5", "targetname");
fire6 = getEnt("fx_fire6", "targetname");
fire7 = getEnt("fx_fire7", "targetname");
fire8 = getEnt("fx_fire8", "targetname");
fire9 = getEnt("fx_fire9", "targetname");
fire10 = getEnt("fx_fire10", "targetname");
fire11 = getEnt("fx_fire11", "targetname");
fire12 = getEnt("fx_fire12", "targetname");
level._effect[ "firepartic" ] = loadfx( "fire/custom_fire_r" );

	while(1)
	{
	playFx(level._effect["firepartic"],fire1.origin);
	playFx(level._effect["firepartic"],fire2.origin);
	playFx(level._effect["firepartic"],fire3.origin);
	playFx(level._effect["firepartic"],fire4.origin);
	playFx(level._effect["firepartic"],fire5.origin);
	playFx(level._effect["firepartic"],fire6.origin);
	playFx(level._effect["firepartic"],fire7.origin);
	playFx(level._effect["firepartic"],fire8.origin);
	playFx(level._effect["firepartic"],fire9.origin);
	playFx(level._effect["firepartic"],fire10.origin);
	playFx(level._effect["firepartic"],fire11.origin);
	playFx(level._effect["firepartic"],fire12.origin);
	wait 1;
	}
}

lift()
{
elev4 = getent("lift","targetname");
trigger = getent("lift_trigger","targetname");
trigger waittill ("trigger", player );
trigger delete();
while(1)
{
elev4 moveY(400, 4, 1, 0);
elev4 waittill ("movedone");
wait 0.05;
elev4 moveY(7378, 3, 0, 1);
elev4 waittill ("movedone");
wait 2;
elev4 moveY(-7778, 2, 0.5, 0.5);
elev4 waittill ("movedone");
wait 3;
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
	{
	secret hide();
	secret notsolid();
	wait 0.2;
	}
}

mapper()
{
	object1 = getent("mapper","targetname");

     while(1)
    {
	    object1 rotateYaw(360, 4);
		wait 3;
    }
}


//END\\
