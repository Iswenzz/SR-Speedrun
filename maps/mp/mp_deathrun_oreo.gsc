//Map by Sheep Wizard
//youtube: http://www.youtube.com/user/paap15
//xfire: paap15
//Thanks to people on braxi and codjumper forums

main()
{
     maps\mp\_load::main();
	 	 
	 game["allies"] = "marines";
     game["axis"] = "opfor";
     game["attackers"] = "axis";
     game["defenders"] = "allies";
     game["allies_soldiertype"] = "desert";
     game["axis_soldiertype"] = "desert";
	 
	 precacheItem( "ak47_mp" );
	 precacheItem( "deserteaglegold_mp" );
	 precacheItem( "dragunov_acog_mp" );
	 precacheItem("deserteagle_mp");
	 precacheItem("tomahawk_mp");
	 precacheItem( "barrett_mp" );
	 precacheItem("m40a3_mp");
	 precacheItem("uzi_acog_mp");
	 precacheItem( "rpg_mp" );

	 thread way_connect();
    
     thread startdoor();
	 thread update();
	 thread secret();
	 thread secret2();
	 thread credits();
	 thread spicy();
	 //thread tele1();
	 //thread tele2();
	 //thread trap1();
     //thread trap2();
	 //thread trap3();
	 //thread trap4();
	 //thread trap5();
	 //thread trap6();
	 //thread trap7();
	 /*
	 thread ak();
	 thread baret();
	 thread sniper();
	 thread uzi();
	 thread rpg();
	 thread tomahawk();
	 thread deagle();*/
}


////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    sr\api\_speedrun::createNormalWays("Normal Way;");
	sr\api\_speedrun::createSecretWays("Secret Way;");
	
    for(;;)
    {
        level waittill( "connected", player );

    }
}
////////////////////////////////////////////////////////////////////////////////////////////////


GiveJumpersWeapon( weap )
{
	 if( !isDefined( weap ) || weap == "" )
		return;
 
	 players = getEntArray( "player", "classname" );
	 for( i=0; i<players.size; i++ )
	{
		 if( !isAlive( players[i] ) || players[i].pers["team"] != "allies" )
			continue;
			
         players[i] TakeAllWeapons();
		 wait 0.01;
		 players[i] giveWeapon( weap );
		 players[i] giveMaxAmmo( weap );
		 players[i] setSpawnWeapon( weap );
		
	}
}

update()
{

}

secret()
{
    trig = getent ("secrettrig", "targetname");
	target = getent("secrettarget", "targetname");
	for(;;)
	{
	    trig waittill("trigger", player);
	    player sr\api\_speedrun::changeWay("secret_0"); //Speedrun Copy Paste
		player setOrigin(target.origin);
	}
}

secret2()
{
    trig = getent ("secrettrig2", "targetname");
	target = getent("secrettarget2", "targetname");
	for(;;)
	{
	    trig waittill("trigger", player);
		player setOrigin(target.origin);
	}
}

tele1()
{
    trig = getent ("teleport_trig1", "targetname");
	target = getent("teleport_target1", "targetname");
	for(;;)
	{
	    trig waittill("trigger", player);
		player setOrigin(target.origin);
	}
}

tele2()
{
    trig = getent ("teleport_trig2", "targetname");
	target = getent("teleport_target2", "targetname");
	for(;;)
	{
	    trig waittill("trigger", player);
		player setOrigin(target.origin);
	}
}

credits()
{
wait 5;
for(;;)
	 {
	 iPrintLn ("^1>>^3Map By Sheep Wizard");
	 wait 7;
	 iPrintLn ("^1>>^3Youtube: paap15");
	 wait 7;
	 iPrintLn ("^1>>^3Xfire: paap15");
	 wait 7;
	 iPrintLn ("^1>>^3Updated version of map");
	 wait 18;
	 }
}
	
	

startdoor()
{
    
     door = getEnt("door", "targetname");
	 door2 = getEnt("door2", "targetname");
     wait(10);
	 iPrintLnBold (" ^2Game ^6will ^2start ^6in ^210 ^6second");
	 wait(1);
	 iPrintLnBold (" ^2Map by ^6Sheep Wizard");
	 wait(10);
	 iPrintLnBold ("Begin");
     door moveX(385,8);
	 door2 moveX(-385,8);
	 door waittill("movedone");
	 wait 2;
	 door delete();
	 door2 delete();	 
}

spicy()
{
      
	  spicy = getEnt("spicy", "targetname");
	  spicy waittill ("trigger", player);
	  spicy delete();
	  iPrintLnBold ("^3S^5picy ^3W^5einer's ^3T^5ingly ^3N^5ips");
	  
}
	
//Traps:
trap1()
{
     trig = getEnt("trap1_trig", "targetname");
	 move = getEnt("trap1_move", "targetname");
	 move2 = getEnt("trap1_move2", "targetname");
	 
	 trig waittill ("trigger", player);
	 trig delete();
	 
	 while(1)
	 {
	     move moveX(448,1);
		 move waittill ("movedone");
	     move2 movex(-448,1);
	     move2 waittill ("movedone");
		 move moveX(-448,1);
		 move waittill ("movedone");
	     move2 movex(448,1);
	     move2 waittill ("movedone");
		}
}
	
trap2()
{
     trig = getEnt("trap2_trig", "targetname");
	 bounce = getEnt("trap2_bounce", "targetname");
	 
	 trig waittill ("trigger", player);
	 trig delete();
	 
	 while(1)
	 {
	     bounce rotatepitch (180,11);
		 wait 11;
		}
}

trap3()
{
     trig = getEnt("trap3_trig", "targetname");
	 push = getEnt("trap3_push", "targetname");
	 
	 trig waittill ("trigger", player);
	 trig delete();
	 
	 while(1)
	 {
	     push moveY(-448,0.5);
	     push waittill ("movedone");
	     wait 3;
	     push moveY(448,0.5);
		 push waittill ("movedone");
		 wait 3;
		}
}

trap4()
{
     trig = getEnt("trap4_trig", "targetname");
	 spin = getEnt("trap4_spin", "targetname");
	 spin2 = getEnt("trap4_spin2", "targetname");
	 spin3 = getEnt("trap4_spin3", "targetname");
	 spin4 = getEnt("trap4_spin4", "targetname");
	 
	 trig waittill ("trigger", player);
	 trig delete();
	 
	 while(1)
	 {
	     spin rotateyaw (180,2);
		 spin2 rotateyaw(-180,2);
		 spin3 rotateyaw(180,2);
		 spin4 rotateyaw(-180,2);
		 wait 2;
		}
	 
}
	
trap5()
{
     trig = getEnt("trap5_trig","targetname");
	 pole = getEnt("trap5_pole", "targetname");
	 pole2 = getEnt("trap5_pole2", "targetname");
	 pole3 = getEnt("trap5_pole3", "targetname");
	 pole4 = getEnt("trap5_pole4", "targetname");
	 
	 trig waittill ("trigger", player);
	 trig delete();
	 
     while(1)
	{
	     pole movey(-260, 1);
	     pole2 movez(-60, 1);
		 pole3 movey(260, 1);
		 pole4 movex (-260, 1);
	     wait 0.8;
	     pole movey(260, 1);
	     pole2 movez(60, 1);
		 pole3 movey(-260, 1);
		 pole4 movex (260, 1);
         wait 0.8;
	}
}

trap6()
{
     trig = getEnt("trap6_trig", "targetname");
	 baa = getEnt("trap6_baa", "targetname");
	 baa2 = getEnt("trap6_baa2", "targetname");
	 baa3 = getEnt("trap6_baa3", "targetname");
	 baa4 = getEnt("trap6_baa4", "targetname");
	 
	 trig waittill ("trigger", player);
	 trig delete();
	 
	 baa movex (272, 1);
	 baa2 movex (272, 1);
	 baa3 movex (-272, 1);
	 baa4 movex (-272, 1);
	 
	 while (1)
	 {
	     wait 5;
		 baa movex (-544, 1);
	     baa2 movex (-544, 1);
	     baa3 movex (544, 1);
	     baa4 movex (544, 1);
		 wait 5;
		 baa movex (544, 1);
	     baa2 movex (544, 1);
	     baa3 movex (-544, 1);
	     baa4 movex (-544, 1);
		}
}


trap7()
{
     trig = getEnt("trap7_trig", "targetname");
	 strip = getEnt("trap7_strip", "targetname");
	 strip2 = getEnt("trap7_strip2", "targetname");
	 strip3 = getEnt("trap7_strip3", "targetname");

	 
	 trig waittill ("trigger", player);
	 trig delete();
	 
	 while(1)
	 {
	     strip rotateroll (180,0.5);
		 strip2 rotateroll(-180,0.5);
		 strip3 rotateroll(180,0.5);
		 wait 0.5;
		}
	 
}
	
//End room:	
ak()
{
     ak = getEnt("ak", "targetname");
	 baret = getEnt("baret", "targetname");
	 sniper = getEnt("sniper", "targetname");
	 uzi = getEnt("uzi", "targetname");
	 rpg = getEnt("rpg", "targetname");
	 tomahawk = getEnt("tomahawk", "targetname");
	 deagle = getEnt("deagle", "targetname");
	 door9 = getEnt("door9", "targetname");
	 finaldoor = getEnt("finaldoor", "targetname");
	 ak waittill ("trigger", player); 
	 baret delete();
	 sniper delete();
	 uzi delete();
	 rpg delete();
	 tomahawk delete();
	 deagle delete();
	 door9 delete();
	 
	 GiveJumpersWeapon( "ak47_mp" );
	 level.activ TakeAllWeapons();
	 level.activ giveWeapon ("ak47_mp" );
	 level.activ SwitchToWeapon("ak47_mp");
	 iprintlnbold("^3"+ player.name + " "+ "entered ^5Ak47 ^3fight!");
	 wait 4;
	 finaldoor moveZ (-272, 5);
}

baret()
{
     ak = getEnt("ak", "targetname");
	 baret = getEnt("baret", "targetname");
	 sniper = getEnt("sniper", "targetname");
	 uzi = getEnt("uzi", "targetname");
	 rpg = getEnt("rpg", "targetname");
	 tomahawk = getEnt("tomahawk", "targetname");
	 deagle = getEnt("deagle", "targetname");
	 door8 = getEnt("door8", "targetname");
	 finaldoor = getEnt("finaldoor", "targetname");
	 
	 baret waittill ("trigger", player);
	 
	 ak delete();
	 sniper delete();
	 uzi delete();
	 rpg delete();
	 tomahawk delete();
	 deagle delete();
	 door8 delete();
	 
	 GiveJumpersWeapon( "barrett_mp" );
	 level.activ TakeAllWeapons();
	 level.activ giveWeapon ("barrett_mp" );
	 level.activ SwitchToWeapon("barrett_mp");
	 iprintlnbold("^3"+ player.name + " "+ "entered ^5Barrett ^3fight!");
	 wait 4;
	 finaldoor moveZ (-272, 5);
}

sniper()
{
     ak = getEnt("ak", "targetname");
	 baret = getEnt("baret", "targetname");
	 sniper = getEnt("sniper", "targetname");
	 uzi = getEnt("uzi", "targetname");
	 rpg = getEnt("rpg", "targetname");
	 tomahawk = getEnt("tomahawk", "targetname");
	 deagle = getEnt("deagle", "targetname");
	 door3 = getEnt("door3", "targetname");
	 finaldoor = getEnt("finaldoor", "targetname");
	 
	 sniper waittill ("trigger", player);
	 
	 ak delete();
	 baret delete();
	 uzi delete();
	 rpg delete();
	 tomahawk delete();
	 deagle delete();
	 door3 delete();
	 
	 GiveJumpersWeapon("m40a3_mp" );
	 level.activ TakeAllWeapons();
	 level.activ giveWeapon ("m40a3_mp" );
	 level.activ SwitchToWeapon("m40a3_mp");
	 iprintlnbold("^3"+ player.name + " "+ "entered ^5m40a3 ^3fight!");
	 wait 4;
	 finaldoor moveZ (-272, 5);
}

uzi()
{
     ak = getEnt("ak", "targetname");
	 baret = getEnt("baret", "targetname");
	 sniper = getEnt("sniper", "targetname");
	 uzi = getEnt("uzi", "targetname");
	 rpg = getEnt("rpg", "targetname");
	 tomahawk = getEnt("tomahawk", "targetname");
	 deagle = getEnt("deagle", "targetname");
	 door4 = getEnt("door4", "targetname");
	 finaldoor = getEnt("finaldoor", "targetname");
	 
	 uzi waittill ("trigger", player);
	 
	 ak delete();
	 baret delete();
	 sniper delete();
	 rpg delete();
	 tomahawk delete();
	 deagle delete();
	 door4 delete();
	 
	 GiveJumpersWeapon("uzi_acog_mp" );
	 level.activ TakeAllWeapons();
	 level.activ giveWeapon ("uzi_acog_mp" );
	 level.activ SwitchToWeapon("uzi_acog_mp");
	 iprintlnbold("^3"+ player.name + " "+ "entered ^5Uzi ^3fight!");
	 wait 4;
	 finaldoor moveZ (-272, 5);
}

rpg()
{
     ak = getEnt("ak", "targetname");
	 baret = getEnt("baret", "targetname");
	 sniper = getEnt("sniper", "targetname");
	 uzi = getEnt("uzi", "targetname");
	 rpg = getEnt("rpg", "targetname");
	 tomahawk = getEnt("tomahawk", "targetname");
	 deagle = getEnt("deagle", "targetname");
	 door5 = getEnt("door5", "targetname");
	 finaldoor = getEnt("finaldoor", "targetname");
	 
	 rpg waittill ("trigger", player);
	 
	 ak delete();
	 baret delete();
	 sniper delete();
	 uzi delete();
	 tomahawk delete();
	 deagle delete();
	 door5 delete();
	 
	 GiveJumpersWeapon( "rpg_mp" );
	 level.activ TakeAllWeapons();
	 level.activ giveWeapon ("rpg_mp");
	 level.activ SwitchToWeapon("rpg_mp");
	 iprintlnbold("^3"+ player.name + " "+ "entered ^5RPG ^3fight!");
	 wait 4;
	 finaldoor moveZ (-272, 5);
}

tomahawk()
{
     ak = getEnt("ak", "targetname");
	 baret = getEnt("baret", "targetname");
	 sniper = getEnt("sniper", "targetname");
	 uzi = getEnt("uzi", "targetname");
	 rpg = getEnt("rpg", "targetname");
	 tomahawk = getEnt("tomahawk", "targetname");
	 deagle = getEnt("deagle", "targetname");
	 door6 = getEnt("door6", "targetname");
	 finaldoor = getEnt("finaldoor", "targetname");
	 
	 tomahawk waittill ("trigger", player);
	 
	 ak delete();
	 baret delete();
	 sniper delete();
	 uzi delete();
	 rpg delete();
	 deagle delete();
	 door6 delete();
	 
	 GiveJumpersWeapon( "tomahawk_mp" );
	 level.activ TakeAllWeapons();
	 level.activ giveWeapon ("tomahawk_mp" );
	 level.activ SwitchToWeapon("tomahawk_mp");
	 iprintlnbold("^3"+ player.name + " "+ "entered ^5Knife ^3fight!");
	 wait 4;
	 finaldoor moveZ (-272, 5);
}

deagle()
{
     ak = getEnt("ak", "targetname");
	 baret = getEnt("baret", "targetname");
	 sniper = getEnt("sniper", "targetname");
	 uzi = getEnt("uzi", "targetname");
	 rpg = getEnt("rpg", "targetname");
	 tomahawk = getEnt("tomahawk", "targetname");
	 deagle = getEnt("deagle", "targetname");
	 door7 = getEnt("door7", "targetname");
	 finaldoor = getEnt("finaldoor", "targetname");
	 
	 deagle waittill ("trigger", player);
	 
	  ak delete();
	 baret delete();
	 sniper delete();
	 uzi delete();
	 rpg delete();
	 tomahawk delete();
	 door7 delete();
	 
     GiveJumpersWeapon( "deserteagle_mp" );
	 level.activ TakeAllWeapons();
	 level.activ giveWeapon ("deserteagle_mp" );
	 level.activ SwitchToWeapon("deserteagle_mp");
	 iprintlnbold("^3"+ player.name + " "+ "entered ^5Deagle ^3fight!");
	 wait 4;
	 finaldoor moveZ (-272, 5);

}




























