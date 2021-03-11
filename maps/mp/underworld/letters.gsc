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

	thread letter_s();
	thread letter_k();
	thread letter_b();
	thread letter_w();
	thread letter_o();

}

letter_s()
{
    target = getEnt ("letter_s", "targetname");
	
	while (1)
	{
	    target rotateYaw (360, 5);
	    wait 5;
	}
}

letter_k()
{
    target = getEnt ("letter_k", "targetname");
	
	while (1)
	{
	    target rotateYaw (360, 5);
	    wait 5;
	}
}

letter_b()
{
    target = getEnt ("letter_b", "targetname");
	
	while (1)
	{
	    target rotateYaw (360, 5);
	    wait 5;
	}
}

letter_w()
{
    target = getEnt ("letter_w", "targetname");
	
	while (1)
	{
	    target rotateYaw (360, 5);
	    wait 5;
	}
}

letter_o()
{
    target = getEnt ("letter_o", "targetname");
	
	while (1)
	{
	    target rotateYaw (360, 5);
	    wait 5;
	}
}