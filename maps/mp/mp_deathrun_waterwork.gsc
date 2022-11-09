//////////////////////////////////////////////////////////////
/////Do not use any of these scripts with out my permission///
////xfire:killertaco5/////////////////////////////////////////
////Helped by Lossy, xfire: xlossx////////////////////////////
//////////////////////////////////////////////////////////////

main()
{
        maps\mp\_load::main();

        thread sr\api\_map::createSpawn((-1500,-670,60),91);
        thread sr\api\_speedrun::createNormalWays("Normal Way;");
        thread sr\api\_speedrun::createSecretWays("Secret Way;");
        thread sr\api\_speedrun::createTeleporter((-948.616, -137.213, 0.125), 60, 35, (1224, 5608, 252), 1, "freeze", "yellow", "secret_0");

        //thread trap1();
        //thread trap2();
        //thread trap3();
        //thread trap4();
        //thread trap5();
        //thread trap6();
        //thread trap7();
        //thread trap8();
        //thread Sniper();
        //thread Knife();
        //thread Nade();
        //thread secret_enter();
        thread secret_end();
        //thread amkimbo();
        //thread nadesammo();
        //thread nadesammo2();
        thread teleport();
        thread teleport2();
        thread teleport3();
       //thread old();

        level.rooms_cantenter = getEnt( "rooms_cantenter", "targetname");
        level.rooms_cantenter hide();
        level.rooms_cantenter notsolid();
}

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

trap1()
{
        act1 = getEnt ("trap1_acti", "targetname");
        rotate1 = getEnt ("trap1_trap" , "targetname");
        rotate2 = getEnt ("trap2_trap" , "targetname");

        act1 waittill ("trigger");


}

trap2()
{
        trig = getEnt("trap2_acti","targetname");
        brush1 = getEnt("trap2_ran1","targetname");
        brush2 = getEnt("trap2_ran2","targetname");

        trig waittill("trigger");

}

trap3()
{
        act1 = getEnt ("trap3_acti", "targetname");
        rotate1 = getEnt ("trap3_trap", "targetname");

        act1 waittill ("trigger");

}

trap4()
{
        trig = getEnt ("trap4_acti" , "targetname");
        trap1 = getEnt ("trap4_trap1" , "targetname");
        trap2 = getEnt ("trap4_trap2" , "targetname");
        trap3 = getEnt ("trap4_trap3" , "targetname");
        trap4 = getEnt ("trap4_trap4" , "targetname");

        trig waittill ("trigger");

}

trap5()
{
        act1 = getEnt ("trap5_acti", "targetname");
        rotate1 = getEnt ("trap5_trap1" , "targetname");
        rotate2 = getEnt ("trap5_trap2" , "targetname");
        rotate3 = getEnt ("trap5_trap3" , "targetname");
        rotate4 = getEnt ("trap5_trap4" , "targetname");

        act1 waittill ("trigger");

}

trap6()
{
                act1 = getEnt ("trap6_acti", "targetname");
                rotate1 = getEnt ("trap6_trap1" , "targetname");
                rotate2 = getEnt ("trap6_trap2" , "targetname");
                rotate3 = getEnt ("trap6_trap3" , "targetname");
                rotate4 = getEnt ("trap6_trap4" , "targetname");
                rotate5 = getEnt ("trap6_trap5" , "targetname");

                act1 waittill ("trigger");


}

trap7()
{
        act1 = getEnt ("trap7_acti", "targetname");
        rotate1 = getEnt ("trap7_trap1", "targetname");
        rotate2 = getEnt ("trap7_trap2", "targetname");
        rotate3 = getEnt ("trap7_trap3", "targetname");

        act1 waittill ("trigger");

}

trap8()
{
        act1 = getEnt ("trap8_acti", "targetname");
        rotate1 = getEnt ("trap8_trap", "targetname");

        act1 waittill ("trigger");

}

Sniper()
{
        level.snip_trig = getEnt( "sniper_trig", "targetname");
        jump = getEnt( "sniper_orig", "targetname" );
        acti = getEnt( "sniper_acti", "targetname" );

        while(1)
        {
                level.snip_trig waittill( "trigger", player );
                if( !isDefined( level.snip_trig ) )
                return;

                level.rooms_cantenter show();
                level.rooms_cantenter solid();
                level.rooms_cantenter movey(45,0.4);

                player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                player TakeAllWeapons();
                player GiveWeapon( "m40a3_mp" );
                player givemaxammo( "m40a3_mp" );
                player GiveWeapon( "remington700_mp" );
                player givemaxammo( "remington700_mp" );
                level.activ setPlayerangles( acti.angles );
                level.activ setOrigin( acti.origin );
                level.activ TakeAllWeapons();
                level.activ GiveWeapon( "m40a3_mp" );
                level.activ givemaxammo( "m40a3_mp" );
                level.activ GiveWeapon( "remington700_mp" );
                level.activ givemaxammo( "remington700_mp" );
                iPrintlnBold( " " + player.name + " ^4 has entered Sniper room!" );
                wait 0.05;
                player switchToWeapon( "m40a3_mp" );
                level.activ SwitchToWeapon( "m40a3_mp" );
                player freezecontrols(true);
                level.activ freezecontrols(true);
                wait 1;
                player iPrintlnBold( "^53" );
                level.activ iPrintlnBold( "^53" );
                wait 1;
                player iPrintlnBold( "^52" );
                level.activ iPrintlnBold( "^52" );
                wait 1;
                player iPrintlnBold( "^51" );
                level.activ iPrintlnBold( "^51" );
                wait 1;
                player iPrintlnBold( "^5Fight^1!" );
                level.activ iPrintlnBold( "^5Fight^1!" );
                player freezecontrols(false);
                level.activ freezecontrols(false);
                player died();
        }
}

amkimbo()
{
        trig = getEnt ("lossy_secret", "targetname");
        target1 = getEnt ("secret_2", "targetname");

        trig waittill ("trigger", user);
        trig delete();

        {
                user SetOrigin(target1.origin);
                user SetPlayerAngles( target1.angles );
                user giveweapon( "g3_mp" );
                user givemaxammo( "g3_mp" );
                wait .1;
                user switchtoweapon( "g3_mp" );
                user braxi\_rank::giveRankXP("", 100);
                wait .1
                thread text();

        }
}
text()
{
        {
                noti = SpawnStruct();
                noti.titleText = "^1Lossy was here ^0:O";
                noti.notifyText = "^5Here a gun and 100 xp^1! ^5To who ever found this ^0:o";
                noti.duration = 10;
                noti.glowcolor = (1,0,0);
                players = getentarray("player", "classname");
                for(i=0;i<players.size;i++)
                players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
                }
}


Knife()
{
        level.knife_trig = getEnt( "knife_trig", "targetname");
        jump = getEnt( "knife_orig", "targetname" );
        acti = getEnt( "knife_acti", "targetname" );

        while(1)
        {
                level.knife_trig waittill( "trigger", player );
                if( !isDefined( level.knife_trig ) )
                return;

                level.rooms_cantenter show();
                level.rooms_cantenter solid();
                level.rooms_cantenter movey(45,0.4);

                player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                player TakeAllWeapons();
                player GiveWeapon( "tomahawk_mp" );
                level.activ setPlayerangles( acti.angles );
                level.activ setOrigin( acti.origin );
                level.activ TakeAllWeapons();
                level.activ GiveWeapon( "tomahawk_mp" );
                iPrintlnBold( " ^2" + player.name + " ^5 has entered the Knife room^1!" );
                wait 0.05;
                player switchToWeapon( "tomahawk_mp" );
                level.activ SwitchToWeapon( "tomahawk_mp" );
                player freezecontrols(true);
                level.activ freezecontrols(true);
                wait 1;
                player iPrintlnBold( "^53" );
                level.activ iPrintlnBold( "^53" );
                wait 1;
                player iPrintlnBold( "^52" );
                level.activ iPrintlnBold( "^52" );
                wait 1;
                player iPrintlnBold( "^51" );
                level.activ iPrintlnBold( "^51" );
                wait 1;
                player iPrintlnBold( "^5Fight^1!" );
                level.activ iPrintlnBold( "^5Fight^1!" );
                player freezecontrols(false);
                level.activ freezecontrols(false);
                player died();

        }
}

Nade()
{
        level.nade_trig = getEnt( "nade_trig", "targetname");
        jump = getEnt( "nade_orig", "targetname" );
        acti = getEnt( "nade_acti", "targetname" );

        while(1)
        {
                level.nade_trig waittill( "trigger", player );
                if( !isDefined( level.nade_trig ) )
                return;

                level.rooms_cantenter show();
                level.rooms_cantenter solid();
                level.rooms_cantenter movey(45,0.4);

                player SetPlayerAngles( jump.angles );
                player takeallweapons();
                player giveweapon("frag_grenade_mp");
                player givemaxammo("frag_grenade_mp");
                player setOrigin( jump.origin );
                level.activ setPlayerangles( acti.angles );
                level.activ setOrigin( acti.origin );
                level.activ takeallweapons();
                level.activ giveweapon("frag_grenade_mp");
                level.activ givemaxammo("frag_grenade_mp");
                iPrintlnBold( " ^2" + player.name + " ^5 has entered the Nade room^1!" );
                wait 0.05;
                player switchtoweapon("frag_grenade_mp");
                level.activ switchtoweapon("frag_grenade_mp");
                player freezecontrols(true);
                level.activ freezecontrols(true);
                wait 1;
                player iPrintlnBold( "^53" );
                level.activ iPrintlnBold( "^53" );
                wait 1;
                player iPrintlnBold( "^52" );
                level.activ iPrintlnBold( "^52" );
                wait 1;
                player iPrintlnBold( "^51" );
                level.activ iPrintlnBold( "^51" );
                wait 1;
                player iPrintlnBold( "^5Bounce^1!" );
                level.activ iPrintlnBold( "^5Fight^1!" );
                player freezecontrols(false);
                level.activ freezecontrols(false);
                player died();
        }
}

nadesammo()
{
        trig = getEnt("nadeammo","targetname");

        while(1)
    {
        trig waittill ("trigger", who);
        who GiveMaxAmmo( "frag_grenade_mp" );
        }
}

nadesammo2()
{
        trig = getEnt("nadeammo2","targetname");

        while(1)
    {
        trig waittill ("trigger", who);
        who GiveMaxAmmo( "frag_grenade_mp" );
        }
}


died()
{
        self endon("disconnect");

        self waittill("death");
        iPrintlnBold("^2"+self.name+" ^5died^1!");
        level.rooms_cantenter hide();
        level.rooms_cantenter notsolid();
        level.rooms_cantenter movey(-45,0.4);
}

secret_enter()
{
        level.secret_trig = getEnt ("secret_enter", "targetname");
        target1 = getEnt ("secret_startori", "targetname");

        for(;;)
        {
                level.secret_trig waittill ("trigger", user);
                user SetOrigin(target1.origin);
                user SetPlayerAngles( target1.angles );
        }
}

secret_end()
{
        trig = getEnt ("secret_endtrig", "targetname");
        target1 = getEnt ("secret_end", "targetname");

        for(;;)
        {
                trig waittill ("trigger", player);
                player thread sr\api\_speedrun::finishWay("secret_0");
                player SetOrigin(target1.origin);
                player SetPlayerAngles( target1.angles );

        }
}

teleport()
{
        trig = getEnt ("teleport", "targetname");
        target = getEnt ("teleport1_org", "targetname");

        for(;;)
        {
                trig waittill ("trigger", player);

                player FreezeControls (1);
                player FreezeControls (0);
                player SetPlayerAngles( target.angles );
                player SetOrigin(target.origin);
        }
}

teleport2()
{
        trig = getEnt ("teleport2", "targetname");
        target = getEnt ("teleport2_org", "targetname");

        for(;;)
        {
                trig waittill ("trigger", player);

                player FreezeControls (1);
                player FreezeControls (0);
                player SetPlayerAngles( target.angles );
                player SetOrigin(target.origin);
        }
}

teleport3()
{
        trig = getEnt ("teleport3", "targetname");
        target = getEnt ("teleport3_org", "targetname");

        for(;;)
        {
                trig waittill ("trigger", player);

                player FreezeControls (1);
                player FreezeControls (0);
                player SetPlayerAngles( target.angles );
                player SetOrigin(target.origin);
        }
}

old()
{
        old_trig = getEnt ("map_finish", "targetname");//trigger
        door = getEnt ("finish_door", "targetname");//door

        old_trig waittill ("trigger", player);
        knife_trigger = getEnt ("knife_trig", "targetname");//minigame
        sniper_trigger = getEnt( "sniper_trig", "targetname" );//minigame
        nade_trigger = getEnt ("nade_trig", "targetname");//minigame

        old_trig delete();
        door delete();
        knife_trigger delete();
		sniper_trigger delete();
        nade_trigger delete();

        iprintlnbold (player.name + " ^2Opened the old way!");
}