//////////////////////////////////////////////////////////////
//////////////////////map by jerkan///////////////////////////
//////////////////////////////////////////////////////////////
/////////////////////XFire: jerkan18//////////////////////////
//////////////////////////////////////////////////////////////
///////////////////e-mail: jerkan@net.hr//////////////////////
//////////////////////////////////////////////////////////////
////////////////www.jerkanmaps.weebly.com/////////////////////
//////////////////////////////////////////////////////////////

main()
{

	thread weapons();


	precacheItem( "g36c_acog_mp" );
	precacheItem( "p90_acog_mp" );
	precacheItem( "uzi_silencer_mp" );
	precacheItem( "m60e4_grip_mp" );
	precacheItem( "winchester1200_grip_mp" );
	precacheItem( "rpd_acog_mp" );
	precacheItem( "skorpion_silencer_mp" );
	precacheItem( "m14_acog_mp" );
	precacheItem( "brick_blaster_mp" );

}

weapons()
{
	mreza_old = getEnt( "mreza_old", "targetname" );
	mreza_w = getEnt( "mreza_w", "targetname" );
	mreza_s = getEnt( "mreza_s", "targetname" );



	level.enter_weapons = getent ("trigg_weapons" , "targetname");

	level.enter_weapons waittill ("trigger" , jumper);

	mreza_old Solid();
	mreza_w Solid();
	mreza_s Solid();
	mreza_old show();
	mreza_w show();
	mreza_s show();

	ambientPlay("mario_ambient3");


thread teleportiranje_aktivatora_weapons();
jumper thread jumper_weapons();
}


jumper_weapons()
{
	jumper_enter_weapons = getent ("jumper_enter_weapons" , "targetname");

	mreza_w = getEnt( "mreza_w", "targetname" );


self setorigin (jumper_enter_weapons.origin);
self setplayerangles (jumper_enter_weapons.angles);

iprintlnbold ("^3---^1" + self.name + "^3--- ^2entered WEAPON room!");

x = 1+RandomInt(3);
gun = GetRandomWeapon( x );

self TakeAllWeapons();
self GiveWeapon( gun );
wait 0.01;
self SwitchToWeapon( gun );


self SetWeaponAmmoStock( "g36c_acog_mp", 900 );
self SetWeaponAmmoStock( "p90_acog_mp", 900 );
self SetWeaponAmmoStock( "uzi_silencer_mp", 900 );
self SetWeaponAmmoStock( "m60e4_grip_mp", 900 );
self SetWeaponAmmoStock( "winchester1200_grip_mp", 900 );
self SetWeaponAmmoStock( "rpd_acog_mp", 900 );
self SetWeaponAmmoStock( "skorpion_silencer_mp", 900 );
self SetWeaponAmmoStock( "m14_acog_mp", 900 );
//self SetWeaponAmmoStock( "brick_blaster_mp", 900 );


self death();
self thread jumper_port_weapons();

iprintlnbold ("^3---^1" + self.name + "^3--- ^2is dead!");
iprintlnbold ("^2Weapons ^3teleport is opened!!");

	mreza_w notSolid();
	mreza_w hide();

}

death()
{
self endon("disconnect");

self waittill ("death");

}


jumper_port_weapons()
{

	mreza_w = getEnt( "mreza_w", "targetname" );

while(1)
{
level.enter_weapons waittill ("trigger" ,jumper);

mreza_w Solid();
mreza_w show();

i = RandomIntRange(1,4);
jumper_enter_weapons2 = getent ("jumper_enter_weapons2_"+i , "targetname");


jumper setorigin (jumper_enter_weapons2.origin);
jumper setplayerangles (jumper_enter_weapons2.angles);


iprintlnbold ("^3---^1" + jumper.name + "^3--- ^2entered WEAPON room!");

x = 1+RandomInt(3);
gun = GetRandomWeapon( x );

jumper TakeAllWeapons();
jumper GiveWeapon( gun );
wait 0.01;
jumper SwitchToWeapon( gun );


jumper SetWeaponAmmoStock( "g36c_acog_mp", 900 );
jumper SetWeaponAmmoStock( "p90_acog_mp", 900 );
jumper SetWeaponAmmoStock( "uzi_silencer_mp", 900 );
jumper SetWeaponAmmoStock( "m60e4_grip_mp", 900 );
jumper SetWeaponAmmoStock( "winchester1200_grip_mp", 900 );
jumper SetWeaponAmmoStock( "rpd_acog_mp", 900 );
jumper SetWeaponAmmoStock( "skorpion_silencer_mp", 900 );
jumper SetWeaponAmmoStock( "m14_acog_mp", 900 );
//jumper SetWeaponAmmoStock( "brick_blaster_mp", 900 );

jumper death();

iprintlnbold ("^3---^1" + jumper.name + "^3--- ^2is dead!");
iprintlnbold ("^2Weapons ^3teleport is open!!");

mreza_w notSolid();
mreza_w hide();


}
}


teleportiranje_aktivatora_weapons()
{
	players = getEntArray("player", "classname");
	for(i=0;i<players.size;i++)
	{
		if( IsAlive(players[i]))
		{
			if( players[i].pers["team"] == "axis" )
			{

				players.maxhealth = 500;
				players.health = players.maxhealth;


				players[i] thread aktivator_weapons();



			}
		}
	}
}

aktivator_weapons()
{

aktivator_enter_weapons = getent ("aktivator_enter_weapons" , "targetname");


self setorigin (aktivator_enter_weapons.origin);
self setplayerangles (aktivator_enter_weapons.angles);

x = 1+RandomInt(3);
gun = GetRandomWeapon( x );

self TakeAllWeapons();
self GiveWeapon( gun );
wait 0.01;
self SwitchToWeapon( gun );

self SetWeaponAmmoStock( "g36c_acog_mp", 900 );
self SetWeaponAmmoStock( "p90_acog_mp", 900 );
self SetWeaponAmmoStock( "uzi_silencer_mp", 900 );
self SetWeaponAmmoStock( "m60e4_grip_mp", 900 );
self SetWeaponAmmoStock( "winchester1200_grip_mp", 900 );
self SetWeaponAmmoStock( "rpd_acog_mp", 900 );
self SetWeaponAmmoStock( "skorpion_silencer_mp", 900 );
self SetWeaponAmmoStock( "m14_acog_mp", 900 );
//self SetWeaponAmmoStock( "brick_blaster_mp", 900 );


}

GetRandomWeapon( num )
{

		x = RandomInt( 85 );
		if( x < 10 )
			return "g36c_acog_mp";
		if( x > 9 && x < 20 )
			return "p90_acog_mp";
		if( x > 20 && x < 30 )
			return "uzi_silencer_mp";
		if( x > 30 && x < 40 )
			return "m60e4_grip_mp";
		if( x > 40 && x < 50 )
			return "winchester1200_grip_mp";
		if( x > 50 && x < 60 )
			return "rpd_acog_mp";
		if( x > 60 && x < 70 )
			return "skorpion_silencer_mp";
		if( x > 70 && x < 80 )
			return "m14_acog_mp";
		if( x > 80 )
			return "brick_blaster_mp";

}