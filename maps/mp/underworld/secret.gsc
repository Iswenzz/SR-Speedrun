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

	thread secret_1();
	thread secret_1_weapon();
	thread secret_2();
	thread secret_2_weapon();

}

secret_1()
{
    trigger = getEnt ("secret_1_trigger", "targetname");
	target = getEnt ("secret_1", "targetname");
	
	trigger waittill ("trigger", player );
	trigger delete();
	
	target moveZ (180, 4);
	wait 4;
}

secret_1_weapon()
{
    trigger = getEnt ("secret_1_weapon", "targetname");
	
	while (1)
	{
	    trigger waittill ("trigger", player );
		
	    player TakeAllWeapons();
        wait 0.1;
	    player giveWeapon ( "deserteagle_mp" );
	    wait 0.1;
	    player giveMaxAmmo ( "deserteagle_mp" );
	    wait 0.1;
	    player switchToWeapon ( "deserteagle_mp" );
	    wait 0.1;
	    player iprintln ( "^1>> ^7You got a desert eagle");
		wait 0.5;
	}
}

secret_2()
{
    trigger = getEnt ("secret_2_unlock", "targetname");
	target = getEnt ("secret_2", "targetname");
	
	trigger waittill ("trigger", player );
	trigger delete();
	
	target delete();
	wait  0.5;
	player iprintln ( "^1>> ^7You unlocked something");
}

secret_2_weapon()
{
    trigger = getEnt ("secret_2_weapon", "targetname");
	
	while (1)
	{
	    trigger waittill ("trigger", player );
		
	    player giveWeapon ( "m40a3_mp" );
	    wait 0.1;
	    player giveMaxAmmo ( "m40a3_mp" );
	    wait 0.1;
	    player switchToWeapon ( "m40a3_mp" );
	    wait 0.1;
	    player iprintln ( "^1>> ^7You got a m40a3");
		wait 0.5;
	}
}