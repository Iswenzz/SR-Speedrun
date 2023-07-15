//map by Freek Also visit http://infocrawlers.blogspot.com/ for DR plugins and other Essentials
main()
{
	thread sr\api\_defrag::weapons("");
maps\mp\_load::main();

PreCacheItem("deserteaglegold_mp");
        PreCacheItem("winchester1200_mp");
        PreCacheItem("skorpion_mp");
        PreCacheItem("remington700_mp");



	addTriggerToList( "t1" );
	addTriggerToList( "t2" );
	addTriggerToList( "t3" );
	addTriggerToList( "t4" );
	addTriggerToList( "t5" );
	addTriggerToList( "t6" );
	addTriggerToList( "t7" );
	addTriggerToList( "t8" );

        thread sr\api\_map::createSpawn((685,-65,252),180);
 		thread sr\api\_speedrun::createNormalWays("Normal Way;");
        thread sr\api\_speedrun::createSecretWays("1K Way;");
        thread sr\api\_speedrun::createWay((-1271, 257, 556), 1000, 150, "none", "secret_0");
        thread sr\api\_speedrun::createEndMap((-1050.02, -1915.34, 320.125), 210, 100);

//thread rotate();
//thread trap1();
//thread trap2();
//thread trap3();
//thread trap4();
//thread trap5();
//thread trap6();
//thread trap7();
//thread trap8();
//thread givesniper();
//thread sniper_room();
//thread knife_room();
}

givesniper()
{
        trigger = getEnt("wepsniper", "targetname");
        precacheItem("remington700_mp");
        while(1)
        {
                trigger waittill("trigger", player);
                player takeallweapons();
                player GiveWeapon("remington700_mp");
                player SwitchToWeapon( "remington700_mp" );
        }
}


addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}




trap1()
{
brush = getEnt ("b1", "targetname");
trig = getEnt ("t1", "targetname");
trig waittill ("trigger");



}


trap2()
{
brush = getEnt ("b2", "targetname");
trig = getEnt ("t2", "targetname");
trig waittill ("trigger");

}

trap3()
{
brush = getEnt ("b3", "targetname");
trig = getEnt ("t3", "targetname");
trig waittill ("trigger");

}

trap4()
{
brush = getEnt ("b4", "targetname");
trig = getEnt ("t4", "targetname");
trig waittill ("trigger");

}


trap5()
{
brush = getEnt ("b5", "targetname");
trig = getEnt ("t5", "targetname");
trig waittill ("trigger");

}

trap6()
{
brush = getEnt ("b6", "targetname");
trig = getEnt ("t6", "targetname");
trig waittill ("trigger");


}

trap7()
{
brush = getEnt ("b7", "targetname");
trig = getEnt ("t7", "targetname");
trig waittill ("trigger");

}


trap8()
{
brush = getEnt ("b8", "targetname");
trig = getEnt ("t8", "targetname");
trig waittill ("trigger");

}

sniper_room()
{
    level.sniper_trig = getEnt( "sniper_room", "targetname");
        jump = getEnt( "sniper_jump", "targetname" );
        acti = getEnt( "sniper_acti", "targetname");

        while(1)
        {
                level.sniper_trig waittill( "trigger", player );
                if( !isDefined( level.sniper_trig ) )
                        return;

                level.wall_trig delete();
                level.knife_trig delete();


                player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                player TakeAllWeapons();
                player GiveWeapon( "remington700_mp" );
                level.activ setPlayerangles( acti.angles );
                level.activ setOrigin( acti.origin );
                level.activ TakeAllWeapons();
                level.activ GiveWeapon( "remington700_mp" );
                wait 0.05;
                player switchToWeapon( "remington700_mp" );
                level.activ SwitchToWeapon( "remington700_mp" );
                iPrintlnBold( " ^6" + player.name + " has chosen snipe room!" );                //change it as you wish
                while( isAlive( player ) && isDefined( player ) )
                        wait 1;
        }
}

knife_room()
{
    level.knife_trig = getEnt( "kroom", "targetname");
        jump = getEnt( "knife_jump", "targetname");
        acti = getEnt( "knife_acti", "targetname");

        while(1)
        {
                level.knife_trig waittill( "trigger", player );
                if( !isDefined( level.knife_trig ) )
                        return;

                level.sniper_trig delete();
                level.wall_trig delete();


                player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                player TakeAllWeapons();
                player GiveWeapon( "tomahawk_mp" );
                level.activ setPlayerangles( acti.angles );
                level.activ setOrigin( acti.origin );
                level.activ TakeAllWeapons();
                level.activ GiveWeapon( "tomahawk_mp" );
                wait 0.05;
                player switchToWeapon( "tomahawk_mp" );
                level.activ SwitchToWeapon( "tomahawk_mp" );
                iPrintlnBold( " ^6" + player.name + " has chosen knife room" );                //change it as you wish
                while( isAlive( player ) && isDefined( player ) )
                        wait 1;
        }
}
