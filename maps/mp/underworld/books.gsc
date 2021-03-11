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

	thread book_1a();
	thread book_1b();
	thread book_2a();
	thread book_2b();
	thread book_3a();
	thread book_3b();
	thread book_4a();
	thread book_4b();
	thread book_5a();
	thread book_5b();
	thread book_6a();
	thread book_6b();

}

book_1a()
{
    target = getEnt ("book_1", "targetname");
	trigger = getEnt ("book_1_trigger", "targetname");
	
	trigger waittill ("trigger", player );
	trigger delete();
	target delete();
}

book_1b()
{
    target = getEnt ("book_1", "targetname");

	while (1)
	{
	    target rotateYaw (360, 3);
		wait 3;
	}
}

book_2a()
{
    target = getEnt ("book_2", "targetname");
	trigger = getEnt ("book_2_trigger", "targetname");
	
	trigger waittill ("trigger", player );
	trigger delete();
	target delete();
}

book_2b()
{
    target = getEnt ("book_2", "targetname");

	while (1)
	{
	    target rotateYaw (360, 3);
		wait 3;
	}
}

book_3a()
{
    target = getEnt ("book_3", "targetname");
	trigger = getEnt ("book_3_trigger", "targetname");
	
	trigger waittill ("trigger", player );
	trigger delete();
	target delete();
}

book_3b()
{
    target = getEnt ("book_3", "targetname");

	while (1)
	{
	    target rotateYaw (360, 3);
		wait 3;
	}
}

book_4a()
{
    target = getEnt ("book_4", "targetname");
	trigger = getEnt ("book_4_trigger", "targetname");
	
	trigger waittill ("trigger", player );
	trigger delete();
	target delete();
}

book_4b()
{
    target = getEnt ("book_4", "targetname");

	while (1)
	{
	    target rotateYaw (360, 3);
		wait 3;
	}
}

book_5a()
{
    target = getEnt ("book_5", "targetname");
	trigger = getEnt ("book_5_trigger", "targetname");
	
	trigger waittill ("trigger", player );
	trigger delete();
	target delete();
}

book_5b()
{
    target = getEnt ("book_5", "targetname");

	while (1)
	{
	    target rotateYaw (360, 3);
		wait 3;
	}
}

book_6a()
{
    target = getEnt ("book_6", "targetname");
	trigger = getEnt ("book_6_trigger", "targetname");
	
	trigger waittill ("trigger", player );
	trigger delete();
	target delete();
}

book_6b()
{
    target = getEnt ("book_6", "targetname");

	while (1)
	{
	    target rotateYaw (360, 3);
		wait 3;
	}
}