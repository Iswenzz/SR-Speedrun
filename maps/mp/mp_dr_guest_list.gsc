//Map by Fish Da Rekter


main()
{
 maps\mp\_load::main();
 
 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"] = "desert";
 
	
	setdvar( "r_specularcolorscale", "1" );

	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	
	setDvar("bg_falldamagemaxheight", 2000000000 );
	setDvar("bg_falldamageminheight", 1500000000 );
	
	level.boom_fx = LoadFx("explosions/default_explosion");

	thread way_connect();

	thread messages();
	thread startdoors();
	//thread song1();
	//thread song2();
	//thread song3();
	//thread song4();
	//thread trap1();
	//thread trap2();
	//thread trap3();
	//thread trap4();
	//thread trap5();
	//thread trap6();
//	thread trap7();
//	thread trap8();
//	thread old();
//	thread sniper();
//	thread knife();
//	thread jump();
	thread jumperteleport();
//	thread activatorteleport();
//	thread jumpweapon();
	
	
	addTriggerToList( "trig_trap1" );
	addTriggerToList( "trig_trap2" );
	addTriggerToList( "trig_trap3" );
	addTriggerToList( "trig_trap4" );
	addTriggerToList( "trig_trap5" );
	addTriggerToList( "trig_trap6" );
	addTriggerToList( "trig_trap7" );
	addTriggerToList( "trig_trap8" );
 
}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    speedrun\_way_name::createWay("normal", "Normal Way", "1");
	
    for(;;)
    {
        level waittill( "connected", player );
        player thread speedrun\_way_name::way_name();
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////

addTriggerToList( name )
{
  if( !isDefined( level.trapTriggers ) )
      level.trapTriggers = [];
  level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

messages()
{
wait 5;
iprintlnBold("^1Map by Fish Da Rekter (BETA version)");
wait 1;
}

startdoors()
{
door = getent("startdoor","targetname");
{

door moveZ (-280, 1);

}

}

song1()
{
trig1 = getent("song1_activate", "targetname");
trig2 = getent("song2_activate", "targetname");
trig3 = getent("song3_activate", "targetname");
trig4 = getent("song4_activate", "targetname");
trig1 sethintstring("^2 Maroon 5 - Animals");  
trig1 waittill ("trigger", player);
{
ambientPlay("guest1");
iPrintLn ("^0>> ^1Now playing: ^2 Maroon 5 - Animals ^0<<");
trig2 delete();
trig3 delete();
trig4 delete();
}

}

song2()
{
trig1 = getent("song1_activate", "targetname");
trig2 = getent("song2_activate", "targetname");
trig3 = getent("song3_activate", "targetname");
trig4 = getent("song4_activate", "targetname");
trig2 sethintstring("^2 Nicky Romero vs Krewella - Legacy (Vicetone Remix)");  
trig2 waittill ("trigger", player);
{
ambientPlay("guest2");
iPrintLn ("^0>> ^1Now playing: ^2 Nicky Romero vs Krewella - Legacy (Vicetone Remix) ^0<<");
trig1 delete();
trig3 delete();
trig4 delete();
}

}

song3()
{
trig1 = getent("song1_activate", "targetname");
trig2 = getent("song2_activate", "targetname");
trig3 = getent("song3_activate", "targetname");
trig4 = getent("song4_activate", "targetname");
trig3 sethintstring ("^2 Fedde Le Grand & Nicky Romero ft. Matthew Koma - Sparks (Vicetone Remix)");
trig3 waittill ("trigger", player);
{
ambientPlay("guest3");
iPrintLn ("^0>> ^1Now playing: ^2 Fedde Le Grand & Nicky Romero ft. Matthew Koma - Sparks (Vicetone Remix) ^0<<");
trig1 delete();
trig2 delete();
trig4 delete();
}

}

song4()
{
trig1 = getent("song1_activate", "targetname");
trig2 = getent("song2_activate", "targetname");
trig3 = getent("song3_activate", "targetname");
trig4 = getent("song4_activate", "targetname");
trig4 sethintstring ("^2 Alvaro & Jetfire - Guest List (Onderkoffer Remix)");
trig4 waittill ("trigger", player);
{
ambientPlay("guest4");
iPrintLn ("^0>> ^1Now playing: ^2 Alvaro & Jetfire - Guest List (Onderkoffer Remix) ^0<<");
trig1 delete();
trig2 delete();
trig3 delete();
}

}

trap1()
{
block1 = getent("trap1a","targetname");
block2 = getent("trap1b","targetname");
block3 = getent("trap1c","targetname");
block4 = getent("trap1d","targetname");
block5 = getent("trap1e","targetname");
block6 = getent("trap1f","targetname");
block7 = getent("trap1g","targetname");
block8 = getent("trap1h","targetname");
trig = getent("trig_trap1","targetname");
trig sethintstring ("^1Press &&1 to activate!");
trig waittill("trigger",player);
trig sethintstring ("^5Activated :/");

x=randomint(1);

	if(x==0) {
	block1 delete();
	block4 delete();
	block6 delete();
	block7 delete();
	}
	if(x==1) {
	block2 delete();
	block3 delete();
	block5 delete();
	block8 delete();
	}
	

}

trap2()
{
rotater = getent("trap2a", "targetname");
trig = getent("trig_trap2","targetname");
trig sethintstring ("^1Press &&1 to activate!");
trig waittill("trigger",player);
trig sethintstring ("^5Activated :/");

rotater rotateroll(90, 1);
wait 2;
rotater rotateroll(-90, 1);
}

trap3()
{
blocky1 = getent("trap3a", "targetname");
blocky2 = getent("trap3b", "targetname");
blocky3 = getent("trap3c", "targetname");
bounce1trap = getent("bounce1", "targetname");
bounce2trap = getent("bounce2", "targetname");
bounce3trap = getent("bounce3", "targetname");
bounce4trap = getent("bounce4", "targetname");
trig = getent("trig_trap3","targetname");
trig sethintstring ("^1Press &&1 to activate!");
trig waittill("trigger",player);
trig sethintstring ("^5Activated :/");


x=randomint(1);

	if(x==0) {
	bounce2trap delete();
	bounce4trap delete();
	}
	if(x==1) {
	bounce1trap delete();
	bounce3trap delete();
	}

blocky1 moveX (65, 1);
blocky3 moveX (65, 1);

while(1)
{
blocky1 moveX (-65, 1);
blocky3 moveX (-65, 1);
blocky2 moveX (65, 1);
wait 1;
blocky1 moveX (65, 1);
blocky3 moveX (65, 1);
blocky2 moveX (-65, 1);
wait 1;
}

}

trap4()
{
pusher1 = getent("trap4a", "targetname");
pusher2 = getent("trap4b", "targetname");
pusher3 = getent("trap4c", "targetname");
pusher4 = getent("trap4d", "targetname");
pusher5 = getent("trap4e", "targetname");
pusher6 = getent("trap4f", "targetname");
trig = getent("trig_trap4","targetname");
trig sethintstring ("^1Press &&1 to activate!");
trig waittill("trigger",player);
trig sethintstring ("^5Activated :/");

pusher1 moveZ (-192,1);
pusher2 moveZ (-192,1);
pusher3 moveZ (-192,1);
pusher4 moveZ (-192,1);
pusher5 moveZ (-192,1);
pusher6 moveZ (-192,1);
wait 3;
pusher1 moveZ (192,1);
pusher2 moveZ (192,1);
pusher3 moveZ (192,1);
pusher4 moveZ (192,1);
pusher5 moveZ (192,1);
pusher6 moveZ (192,1);
}

trap5()
{
platform1 = getent("trap5a", "targetname");
platform2 = getent("trap5b", "targetname");
trig = getent("trig_trap5","targetname");
trig sethintstring ("^1Press &&1 to activate!");
trig waittill("trigger",player);
trig sethintstring ("^5Activated :/");

x=randomint(1);

	if(x==0) {
	platform1 delete();
	}
	if(x==1) {
	platform2 delete();
	}
}

trap6()
{
moving1 = getent("trap6a", "targetname");
moving2 = getent("trap6b", "targetname");
moving3 = getent("trap6c", "targetname");
moving4 = getent("trap6d", "targetname");
moving5 = getent("trap6e", "targetname");
moving6 = getent("trap6f", "targetname");
trig = getent("trig_trap6","targetname");
trig sethintstring ("^1Press &&1 to activate!");
trig waittill("trigger",player);
trig sethintstring ("^5Activated :/");

while(1)
{
moving1 moveX (128,1);
moving2 moveX (-128,1);
moving3 moveX (-128,1);
moving4 moveX (128,1);
moving5 moveX (128,1);
moving6 moveX (-128,1);
wait 1;
moving1 moveX (-128,1);
moving2 moveX (128,1);
moving3 moveX (128,1);
moving4 moveX (-128,1);
moving5 moveX (-128,1);
moving6 moveX (128,1);
wait 1;
}

}

trap7()
{
pushy1 = getent("trap7a", "targetname");
pushy2 = getent("trap7b", "targetname");
pushy3 = getent("trap7c", "targetname");
pushy4 = getent("trap7d", "targetname");
trig = getent("trig_trap7","targetname");
trig sethintstring ("^1Press &&1 to activate!");
trig waittill("trigger",player);
trig sethintstring ("^5Activated :/");

while(1)
{
pushy1 moveY (192,1);
pushy2 moveY (192,1);
pushy3 moveY (192,1);
pushy4 moveY (192,1);
wait 4;
pushy1 moveY (-192,3);
pushy2 moveY (-192,3);
pushy3 moveY (-192,3);
pushy4 moveY (-192,3);
wait 6;
}

}

trap8()
{
blockade1 = getent("trap8a", "targetname");
blockade2 = getent("trap8b", "targetname");
thingy = getent("trap8c", "targetname");
hurt = getent("damager", "targetname");
explosion = getent ("fx_origin", "targetname");
trig = getent("trig_trap8","targetname");
trig sethintstring ("^1Press &&1 to activate!");
trig waittill("trigger",player);
trig sethintstring ("^5Activated :/");

hurt EnableLinkTo();
hurt LinkTo( thingy );
blockade1 moveZ (-368, 0.5);
blockade2 moveZ (-368, 0.5);
wait 4;
thingy moveZ (96,0.1);
PlayFX( level.boom_fx, explosion.origin );
MusicPlay("boomboom");
wait 1;
thingy moveZ (-96,0.1);
wait 1;
blockade1 moveZ (368, 0.5);
blockade1 moveZ (368, 0.5);
wait 1;
blockade1 delete();
blockade2 delete();

}


old()
{
			level.old_trigger = getent ( "oldroom", "targetname" );
			level.knife_trigger = getent("trig_knife", "targetname");
			level.sniper_trigger = getEnt("trig_sniper", "targetname");
			level.jump_trigger = getent("trig_jump", "targetname");
			oldorigin = getent ( "oldroom_teleport", "targetname" );
		
			while(1)
			{
			level.old_trigger waittill("trigger", player);
			
			level.knife_trigger delete();
			level.sniper_trigger delete();
			level.jump_trigger delete();
		
			iPrintLnBold("^3" + player.name + "^5 chosen the old room");

			player setOrigin (oldorigin.origin);
			}
}


sniper()
{		
		level.teleactorigin3 = getEnt("sniper_activator", "targetname");
		telejumporigin3 = getEnt("sniper_jumper", "targetname");
		level.sniper_trigger = getEnt("trig_sniper", "targetname");
		level.old_trigger = getEnt("oldroom", "targetname");
		level.knife_trigger = getent("trig_knife", "targetname");
		level.jump_trigger = getent("trig_jump", "targetname");

		while(1)
		{
		level.sniper_trigger waittill( "trigger", player );
		
		
		level.old_trigger delete();
		level.knife_trigger delete();
		level.jump_trigger delete();


		if( !isDefined( level.sniper_trigger ))
					return;
			if(level.firstenter==true)
		{
				//level.knife_trigger delete();
				level.old_trigger delete();
				//level.jump_trigger delete();
				level.firstenter=false;
				} 
				wait(0.05);
		player setOrigin( telejumporigin3.origin );
		player setPlayerAngles( telejumporigin3.angles );
		player takeAllWeapons();
		player giveWeapon("m40a3_mp");
		player giveWeapon( "remington700_mp" ); 
		player giveMaxAmmo("m40a3_mp");
		player giveMaxAmmo( "remington700_mp" );
		wait (0.05);
		player switchToWeapon("m40a3_mp"); 
		wait(0.05);
		level.activ setOrigin (level.teleactorigin3.origin);
		level.activ setPlayerAngles (level.teleactorigin3.angles);
		level.activ takeAllWeapons();
		level.activ giveWeapon( "m40a3_mp" );
		level.activ giveWeapon( "remington700_mp" );
		level.activ giveMaxAmmo("m40a3_mp");
		level.activ giveMaxAmmo( "remington700_mp" );
		wait (0.05);
		level.activ switchToWeapon("m40a3_mp");
		player freezeControls(true); 
		level.activ freezeControls(true);
		iPrintLnBold( " ^3" + player.name + " ^5 has chosen the Sniper room^2!" );
		wait 2;
		player freezeControls(false); 
		level.activ freezeControls(false); 
		
		player waittill( "death" );
		level.PlayerInRoom = false;

}

}

knife()
{		
		level.teleactorigin2 = getEnt("knife_activator", "targetname");
		telejumporigin2 = getEnt("knife_jumper", "targetname");
		level.knife_trigger = getent("trig_knife", "targetname");
		level.sniper_trigger = getEnt("trig_sniper", "targetname");
		level.old_trigger = getEnt("oldroom", "targetname");
		level.jump_trigger = getent("trig_jump", "targetname");
		
		while(1)
		{
		level.knife_trigger waittill( "trigger", player );
		
		
			if( !isDefined( level.knife_trigger ))
			return;
			if(level.firstenter==true)
		{
		level.sniper_trigger delete();
		level.old_trigger delete();
		level.jump_trigger delete();
		level.firstenter=false;
		}
		
		{
		wait (0.05);
		
		player setOrigin( telejumporigin2.origin );
		player setPlayerAngles( telejumporigin2.angles );
		player takeAllWeapons();
		player giveWeapon("knife_mp");
		player switchToWeapon("knife_mp"); 
		wait(0.05);
		level.activ setOrigin (level.teleactorigin2.origin);
		level.activ setPlayerAngles (level.teleactorigin2.angles);
		level.activ takeAllWeapons();
		level.activ giveWeapon( "knife_mp" );
		level.activ switchToWeapon("knife_mp"); 
		player freezeControls(true); 
		level.activ freezeControls(true);
		iPrintLnBold( " ^3" + player.name + " ^5 has chosen the Knife room^2!" ); 		
		wait 2;
		player freezeControls(false); 
		level.activ freezeControls(false); 		
		
		player waittill( "death" );
		level.PlayerInRoom = false;

		}

}

}

jump()
{	
		level.teleactorigin = getEnt("jump_activator", "targetname");
		telejumporigin = getEnt("jump_jumper", "targetname");
		level.jump_trigger = getent("trig_jump", "targetname");
		level.knife_trigger = getent("trig_knife", "targetname");
		level.sniper_trigger = getEnt("trig_sniper", "targetname");
		level.old_trigger = getEnt("oldroom", "targetname");
		
	
		
		while(1)
		{
		level.jump_trigger waittill( "trigger", player );
		
		
		if( !isDefined( level.jump_trigger ))
					return;
			if(level.firstenter==true)
				{
				level.sniper_trigger delete();
				level.knife_trigger delete();
				level.old_trigger delete();
				level.firstenter=false;
				} 
				wait(0.05);
		
		player setOrigin( telejumporigin.origin );
		player setPlayerAngles( telejumporigin.angles );
		player takeAllWeapons();
		player giveWeapon("knife_mp");
		wait (0.05);
		player switchToWeapon("knife_mp"); 
		wait (0.05);
		level.activ setOrigin (level.teleactorigin.origin);
		level.activ setPlayerAngles (level.teleactorigin.angles);
		level.activ takeAllWeapons();
		level.activ giveWeapon( "knife_mp" );
		wait (0.05);
		level.activ switchToWeapon("knife_mp");
		player freezeControls(true); 
		level.activ freezeControls(true);
		iPrintLnBold( " ^3" + player.name + " ^5 has chosen the Jump room^2!" );
		wait 2;
		player freezeControls(false); 
		level.activ freezeControls(false); 
		
		player waittill( "death" );
		level.PlayerInRoom = false;
		}
}

jumperteleport()
{
	trig = getent("trigger_teleport1", "targetname");
	tele1 = getent("origin_teleport1", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin (tele1.origin);
	}
}

activatorteleport()
{
	trig2 = getent("trigger_teleport2", "targetname");
	tele2 = getent ("origin_teleport2", "targetname");
	
	for(;;)
	{
		trig2 waittill("trigger", player);
		player setOrigin (tele2.origin);
	}
}

jumpweapon()
{
weapon = getent("jump_weapon", "targetname");
weapon sethintstring ("^2 Press &&1 for weapon!");

while(1)
{
weapon waittill ("trigger", player);
player giveWeapon ("m40a3_mp");
player giveMaxAmmo ("m40a3_mp");
player switchToWeapon ("m40a3_mp");
player iPrintLnBold ("^3 You got a sniper!");
}

}