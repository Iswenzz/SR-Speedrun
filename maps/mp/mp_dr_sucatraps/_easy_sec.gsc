main()
{
thread esp0();
thread esp1();
thread esp2();
thread esp3();
thread esp4();
thread esFail0();
	
}

esp0()
{
	esp0 = getent("esp0", "targetname");
	while(1)
	{
		esp0 waittill("trigger", player);
		player.fail = 0;


	}

}

esp1()
{
	esp1 = getent("esp1", "targetname");
	while(1)
	{
		esp1 waittill("trigger", player);
		player.fail = 1;


	}
	
}

esp2()
{
	esp2 = getent("esp2", "targetname");
	while(1)
	{
		esp2 waittill("trigger", player);
		player.fail = 2;


	}
	
}
esp3()
{
	esp3 = getent("esp3", "targetname");
	while(1)
	{
		esp3 waittill("trigger", player);
		player.fail = 3;


	}

	
}

esp4()
{
	esp4 = getent("esp4", "targetname");
	while(1)
	{
		esp4 waittill("trigger", player);
		player.fail = 4;


	}	




}



esFail0()
{
	esFail0 = getent("esFail", "targetname");
	orig0 = getent("esop0", "targetname");
	orig1 = getent("esop1", "targetname");
	orig2 = getent("esop2", "targetname");
	orig3 = getent("esop3", "targetname");
	orig4 = getent("esop4", "targetname");	

	while(1)
{
	esFail0 waittill("trigger", player);
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
	else if(player.fail == 4)
	{
	player setOrigin(orig4.origin);
		
	}
	else
	{
		player setOrigin(orig0.origin);
	}

}


	
}






