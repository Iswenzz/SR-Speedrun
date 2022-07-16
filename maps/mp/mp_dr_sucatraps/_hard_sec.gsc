main()
{

thread hsp0();
thread hsp1();
thread hsp2();
thread hsp3();
thread hsf();
	
}

hsp0()
{
	hsp0 = getent("hsp0", "targetname");
	while(1)
	{
		hsp0 waittill("trigger", player);
		player.fail = 0;


	}

}

hsp1()
{
	hsp1 = getent("hsp1", "targetname");
	while(1)
	{
		hsp1 waittill("trigger", player);
		player.fail = 1;


	}
	
}

hsp2()
{
	hsp2 = getent("hsp2", "targetname");
	while(1)
	{
		hsp2 waittill("trigger", player);
		player.fail = 2;


	}
	
}
hsp3()
{
	hsp3 = getent("hsp3", "targetname");
	while(1)
	{
		hsp3 waittill("trigger", player);
		player.fail = 3;


	}

	
}


hsf()
{
	hsf = getent("hsfail", "targetname");
	orig0 = getent("hsop0", "targetname");
	orig1 = getent("hsop1", "targetname");
	orig2 = getent("hsop2", "targetname");
	orig3 = getent("hsop3", "targetname");


	while(1)
{
	hsf waittill("trigger", player);
	if(player.fail == 0)
	{
		player setOrigin(orig0.origin);

	}
	else if(player.fail == 1)
	{
		player setOrigin(orig1.origin);

	}
	else if(player.fail == 2)
	{
		player setOrigin(orig2.origin);
		
	}
	else if(player.fail == 3)
	{
		player setOrigin(orig3.origin);
		
	}
	else
	{
		player setOrigin(orig0.origin);
	}

}


	
}






