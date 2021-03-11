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

	thread vip_room();
	thread vip_weapon_unlock();
	thread vip_r700();
	thread vip_m40();
	thread vip_aku();
	thread vip_ak();
	thread vip_p90();
	thread vip_mp5();
	thread vip_brick();
	thread vip_teleport_1();
	thread vip_teleport_2();

}

vip_room()
{
    vip_trig = getEnt ("vip_trig", "targetname");
    org = getEnt ("vip_origin", "targetname");
	
	level.accepted1 = "d6ec95f9f147a89a16451765be27ae55"; //Icomar
    level.accepted2 = "f0909b6a1c65356edf1cbaaac409ae43"; //Blade
	level.accepted3 = "0e203268047e9de843546fb60b705598"; //SmokeZ

    while (1)
    {
        vip_trig waittill( "trigger", player );
        tempGuid = player getGUID();

        if(player isTouching(vip_trig) && player useButtonPressed())
        {
            if((tempGuid == level.accepted1) || (tempGuid == level.accepted2) || (tempGuid == level.accepted3))
            {
                player SetOrigin( org.origin );
                player iprintlnbold("^2<< ^3You entered VIP Room ^2>>");
            }
            else
            {
                wait 0.5;
				player iprintlnbold("^1<< No entry >>");
            }
        }
        else
        {
            wait 0.5;
        }
    }
}

vip_weapon_unlock()
{
    trigger = getEnt ("vip_weapon_unlock_trigger", "targetname");
	target = getEnt ("vip_weapon_unlock_target", "targetname");
	
	trigger waittill ("trigger", player );
	trigger delete();
	
	target moveZ (52, 4);
	wait 4;
}

vip_r700()
{  
    trigger = getEnt("vipr700_trig", "targetname");
	
	while (1)
	{
        trigger waittill ("trigger", player );

        player TakeAllWeapons();
        player GiveWeapon( "remington700_mp" );
        player giveMaxammo("remington700_mp");
        player switchToWeapon("remington700_mp");
	}
}

vip_m40()
{   
    trigger = getEnt("vipm40_trig", "targetname");
	
	while (1)
	{
        trigger waittill ("trigger", player );

        player TakeAllWeapons();
        player GiveWeapon( "m40a3_mp" );
        player giveMaxammo("m40a3_mp");
        player switchToWeapon("m40a3_mp");
    }
}

vip_aku()
{   
    trigger = getEnt("vipaku_trig", "targetname");
	
	while (1)
	{
        trigger waittill ("trigger", player );

        player TakeAllWeapons();
        player GiveWeapon( "ak74u_mp" );
        player giveMaxammo("ak74u_mp");
        player switchToWeapon("ak74u_mp");
	}
}

vip_ak()
{   
    trigger = getEnt("vipak_trig", "targetname");
	
	while (1)
	{
        trigger waittill ("trigger", player );

        player TakeAllWeapons();
        player GiveWeapon( "ak47_mp" );
        player giveMaxammo("ak47_mp");
        player switchToWeapon("ak47_mp");
	}
}

vip_p90()
{   
    trigger = getEnt("vipp90_trig", "targetname");
	
	while (1)
	{
        trigger waittill ("trigger", player );

        player TakeAllWeapons();
        player GiveWeapon( "p90_mp" );
        player giveMaxammo("p90_mp");
        player switchToWeapon("p90_mp");
    }		
}

vip_mp5()
{   
    trigger = getEnt ("vipmp5_trig", "targetname");
	
	while (1)
	{
        trigger waittill ("trigger", player );

        player TakeAllWeapons();
        player GiveWeapon( "mp5_mp" );
        player giveMaxammo("mp5_mp");
        player switchToWeapon("mp5_mp");
	}
}

vip_brick()
{   
    trigger = getEnt ("vipbrick_trig", "targetname");
	
	while (1)
	{
        trigger waittill ("trigger", player );

        player TakeAllWeapons();
        player GiveWeapon( "brick_blaster_mp" );
        player giveMaxammo("brick_blaster_mp");
        player switchToWeapon("brick_blaster_mp");
	}
}

vip_teleport_1()
{
	trigger = getEnt ("vip_port_trigger_1", "targetname");
	target = getEnt ("vip_port_target_1", "targetname");
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

vip_teleport_2()
{
	trigger = getEnt ("vip_port_trigger_2", "targetname");
	target = getEnt ("vip_port_target_2", "targetname");
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
		
		player FreezeControls(1);
		player iprintlnbold("^1<< HAX >>");
		wait 5;
		player FreezeControls(0);
	}
}