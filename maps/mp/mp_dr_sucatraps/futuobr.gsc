main()
{
      // thread key1(); 
       // thread easy();
      //  thread hard();
       thread afterroundstart();
	   thread exitsecret_easy();
	   thread exitsecret_hard();

}

key1()
{ 
	key1    = getent( "futrig1", "targetname" ); 
	
	while(true) 
	{ 
      key1 waittill("trigger",player);
      
      player.key1 = true;
     // player thread the_key1();
      wait (5);

      }
}
the_key1()
{
if(isDefined(self.the_key1))
		self.the_key1 destroy();

self.the_key1 = newClientHudElem(self);
			self.the_key1.alignX = "center";
			self.the_key1.alignY = "top";
			self.the_key1.horzAlign = "fullscreen";
			self.the_key1.vertAlign = "fullscreen";
			self.the_key1.x = 130;
			self.the_key1.y = 0;
			self.the_key1.alpha = 0;
			self.the_key1.sort = 1;
			self.the_key1.hideWhenInMenu = false;
			self.the_key1 setShader("big_s", 45, 45);
			self.the_key1.alpha = 1;
self.the_key1 moveOverTime(4);
self.the_key1.y = 5;
// self.the_key1  thread key2();

}


key2()
{ 
	key2    = getent( "futrig2", "targetname" ); 
	
	while(true) 
	{ 
      key2 waittill("trigger",player);
      if ( isPlayer( player ) && isdefined( player.key1 ) )
        {
      
      player.key2 = true;
     // player thread the_key2();
      wait (5);
       }
      }
}

the_key2()
{
if(isDefined(self.the_key2))
		self.the_key2 destroy();

self.the_key2 = newClientHudElem(self);
			self.the_key2.alignX = "center";
			self.the_key2.alignY = "top";
			self.the_key2.horzAlign = "fullscreen";
			self.the_key2.vertAlign = "fullscreen";
			self.the_key2.x = 175;
			self.the_key2.y = 0;
			self.the_key2.alpha = 0;
			self.the_key2.sort = 1;
			self.the_key2.hideWhenInMenu = false;
			self.the_key2 setShader("p", 45, 45);
			self.the_key2.alpha = 1;
self.the_key2 moveOverTime(4);
self.the_key2.y = 5;
// self.the_key2 thread key3();
}

key3()
{ 
	key3    = getent( "futrig3", "targetname" ); 
	
	while(true) 
    {
      key3 waittill("trigger",player);
      if ( isPlayer( player ) && isdefined( player.key2 ) )
     
	{ 
      key3 waittill("trigger",player);
      
      player.key3 = true;
      // player thread the_key3();
      wait (5);
      }
   }
}
the_key3()
{
if(isDefined(self.the_key3))
		self.the_key3 destroy();

self.the_key3 = newClientHudElem(self);
			self.the_key3.alignX = "center";
			self.the_key3.alignY = "top";
			self.the_key3.horzAlign = "fullscreen";
			self.the_key3.vertAlign = "fullscreen";
			self.the_key3.x = 220;
			self.the_key3.y = 0;
			self.the_key3.alpha = 0;
			self.the_key3.sort = 1;
			self.the_key3.hideWhenInMenu = false;
			self.the_key3 setShader("a", 45, 45);
			self.the_key3.alpha = 1;
self.the_key3 moveOverTime(4);
self.the_key3.y = 5;
// self.the_key3 thread key4();
}          
key4()
{ 
	key4    = getent( "futrig4", "targetname" ); 
	
	while(true) 
	{ 
      key4 waittill("trigger",player);
      if ( isPlayer( player ) && isdefined( player.key3 ) )
        {
      
      player.key4 = true;
     //  player thread the_key4();
      wait (5);
       }
      }
}

the_key4()
{
if(isDefined(self.the_key4))
		self.the_key4 destroy();

self.the_key4 = newClientHudElem(self);
			self.the_key4.alignX = "center";
			self.the_key4.alignY = "top";
			self.the_key4.horzAlign = "fullscreen";
			self.the_key4.vertAlign = "fullscreen";
			self.the_key4.x = 265;
			self.the_key4.y = 0;
			self.the_key4.alpha = 0;
			self.the_key4.sort = 1;
			self.the_key4.hideWhenInMenu = false;
			self.the_key4 setShader("r", 45, 45);
			self.the_key4.alpha = 1;
self.the_key4 moveOverTime(4);
self.the_key4.y = 5;
// self.the_key4 thread key5();
}
key5()
{ 
	key5    = getent( "futrig5", "targetname" ); 
	
	while(true) 
	{ 
      key5 waittill("trigger",player);
      if ( isPlayer( player ) && isdefined( player.key4 ) )
        {
      
      player.key5 = true;
      // player thread the_key5();
      wait (5);
       }
      }
}

the_key5()
{
if(isDefined(self.the_key5))
		self.the_key5 destroy();

self.the_key5 = newClientHudElem(self);
			self.the_key5.alignX = "center";
			self.the_key5.alignY = "top";
			self.the_key5.horzAlign = "fullscreen";
			self.the_key5.vertAlign = "fullscreen";
			self.the_key5.x = 310;
			self.the_key5.y = 0;
			self.the_key5.alpha = 0;
			self.the_key5.sort = 1;
			self.the_key5.hideWhenInMenu = false;
			self.the_key5 setShader("t", 45, 45);
			self.the_key5.alpha = 1;
self.the_key5 moveOverTime(4);
self.the_key5.y = 5;
// self.the_key5 thread key6();

}


key6()
{ 
	key6    = getent( "futrig6", "targetname" ); 
	
	while(true) 
	{ 
      key6 waittill("trigger",player);
      if ( isPlayer( player ) && isdefined( player.key5 ) )
        {
      
      player.key6 = true;
      // player thread the_key6();
      wait (5);
       }
      }
}

the_key6()
{
if(isDefined(self.the_key6))
		self.the_key6 destroy();

self.the_key6 = newClientHudElem(self);
			self.the_key6.alignX = "center";
			self.the_key6.alignY = "top";
			self.the_key6.horzAlign = "fullscreen";
			self.the_key6.vertAlign = "fullscreen";
			self.the_key6.x = 355;
			self.the_key6.y = 0;
			self.the_key6.alpha = 0;
			self.the_key6.sort = 1;
			self.the_key6.hideWhenInMenu = false;
			self.the_key6 setShader("a_2", 45, 45);
			self.the_key6.alpha = 1;
self.the_key6 moveOverTime(4);
self.the_key6.y = 5;
// self.the_key6 thread key7();
}

key7()
{ 
	key7    = getent( "futrig7", "targetname" ); 
	
	while(true) 
    {
      key7 waittill("trigger",player);
      if ( isPlayer( player ) && isdefined( player.key6 ) )
     
	{ 
      key7 waittill("trigger",player);
      
      player.key7 = true;
     // player thread the_key7();
      wait (5);
      }
   }
}
the_key7()
{
if(isDefined(self.the_key7))
		self.the_key7 destroy();

self.the_key7 = newClientHudElem(self);
			self.the_key7.alignX = "center";
			self.the_key7.alignY = "top";
			self.the_key7.horzAlign = "fullscreen";
			self.the_key7.vertAlign = "fullscreen";
			self.the_key7.x = 400;
			self.the_key7.y = 0;
			self.the_key7.alpha = 0;
			self.the_key7.sort = 1;
			self.the_key7.hideWhenInMenu = false;
			self.the_key7 setShader("c", 45, 45);
			self.the_key7.alpha = 1;
self.the_key7 moveOverTime(4);
self.the_key7.y = 5;
// self.the_key7 thread key8();
}          
key8()
{ 
	key8    = getent( "futrig8", "targetname" ); 
	
	while(true) 
{ 
      key8 waittill("trigger",player);
      if ( isPlayer( player ) && isdefined( player.key7 ) )
        {
      
      player.key8 = true;
      // player thread the_key8();
      wait (5);
       }
   }
}

the_key8()
{
if(isDefined(self.the_key8))
		self.the_key8 destroy();

self.the_key8 = newClientHudElem(self);
			self.the_key8.alignX = "center";
			self.the_key8.alignY = "top";
			self.the_key8.horzAlign = "fullscreen";
			self.the_key8.vertAlign = "fullscreen";
			self.the_key8.x = 445;
			self.the_key8.y = 0;
			self.the_key8.alpha = 0;
			self.the_key8.sort = 1;
			self.the_key8.hideWhenInMenu = false;
			self.the_key8 setShader("u", 45, 45);
			self.the_key8.alpha = 1;
self.the_key8 moveOverTime(4);
self.the_key8.y = 5;
// self.the_key8 thread key9();
}

key9()
{ 
	key9    = getent( "futrig9", "targetname" ); 
	
	while(true) 
{ 
      key9 waittill("trigger",player);
      if ( isPlayer( player ) && isdefined( player.key8 ) )
        {
      
      player.key9 = true;
     // player thread the_key9();
      wait (5);
       }
   }
}

the_key9()
{
if(isDefined(self.the_key9))
		self.the_key9 destroy();

self.the_key9 = newClientHudElem(self);
			self.the_key9.alignX = "center";
			self.the_key9.alignY = "top";
			self.the_key9.horzAlign = "fullscreen";
			self.the_key9.vertAlign = "fullscreen";
			self.the_key9.x = 490;
			self.the_key9.y = 0;
			self.the_key9.alpha = 0;
			self.the_key9.sort = 1;
			self.the_key9.hideWhenInMenu = false;
			self.the_key9 setShader("small_s", 45, 45);
			self.the_key9.alpha = 1;
self.the_key9 moveOverTime(4);
self.the_key9.y = 5;
// self.the_key9 thread key10();
}

key10()
{ 
	key10    = getent( "futrig10", "targetname" ); 
	
	while(true) 
	{ 
      key10 waittill("trigger",player);
      if ( isPlayer( player ) && isdefined( player.key9 ) )
        {
      
      player.key10 = true;
     // player thread the_key10();
      wait (25);
       }
      }

}
the_key10()
{
if(isDefined(self.the_key10))
		self.the_key10 destroy();

self.the_key10 = newClientHudElem(self);
			self.the_key10.alignX = "center";
			self.the_key10.alignY = "top";
			self.the_key10.horzAlign = "fullscreen";
			self.the_key10.vertAlign = "fullscreen";
			self.the_key10.x = 320;
			self.the_key10.y = 0;
			self.the_key10.alpha = 0;
			self.the_key10.sort = 1;
			self.the_key10.hideWhenInMenu = false;
			self.the_key10 setShader("the_futulogo", 512, 256);
			self.the_key10.alpha = 1;
self.the_key10 moveOverTime(15);
self.the_key10.y = 500;
// self.the_key10 thread futuport();
}


futuport()
{   
    trigger = getent("futuport","targetname");
  	while(1)
    {
    	
    trigger waittill("trigger", player);
    if(player.key1 == true && player.key2 == true && player.key3 == true && player.key4 == true && player.key5 == true && player.key6 == true && player.key7 == true && player.key8 == true && player.key9 == true && player.key10 == true)
        player setOrigin( (1356,1918,2116) );

    wait .1;
  	}
}

afterroundstart()
{
	level waittill("round_started");
	players = getentarray("player","classname");
	for(i=0;i<players.size;i++)
	{
		players[i].ineasy = false;
		players[i].inhard = false;
	}
}

easy()
{
	trigger = getent("easy_trigger","targetname");
	starteasy = getent("easy_origin","targetname");
	for(;;)
	{
		trigger waittill("trigger",player);
		player setOrigin(starteasy.origin);
		player setplayerangles(starteasy.angles);
		player.ineasy = true;
		player thread ifdead();
    	player thread secret_timer();
	}
}

hard()
{
	trigger = getent("hard_trigger","targetname");
	starthard = getent("hard_origin","targetname");
	for(;;)
	{
		trigger waittill("trigger",player);
		player setOrigin(starthard.origin);
		player setplayerangles(starthard.angles);
		player.inhard = true;
		player thread ifdead();
    	player thread secret_timer();
	}
}

ifdead()
{
	self endon("disconnect");

	self waittill("death");
	self.ineasy = false;
	self.inhard = false;
}

secret_timer()
{
	self endon("disconnect");

	self.timer = NewClientHudElem(self);
	self.timer.alignX = "left";
	self.timer.alignY = "middle";
	self.timer.horzalign = "left";
	self.timer.vertalign = "middle";
	self.timer.alpha = 0;
	self.timer.x = 0;
	self.timer.y = 0;
	self.timer.font = "default";
	self.timer.fontscale = 2;
	self.timer.glowalpha = 1;
	self.timer.glowcolor = (1, 0.5, 0);
	self.timer.label = &"Secret Timer: ^1&&1";
	self.timer fadeovertime(1);
	self.timer.alpha = 1;

	time = 10; //added it gave u error kuz it wasnt defined in the first place

	if(self.ineasy == true && self.inhard == false)
    	time = 200;
    if(self.ineasy == false && self.inhard == true)
    	time = 240;

	while(self.sessionstate == "playing" && self.ineasy == true || self.sessionstate == "playing" && self.inhard == true)
	{
		if(time == 0)
		{
			self.ineasy = false;
			self.inhard = false;
			self suicide();
		}

		self.timer setvalue(time);
		time--;
		wait 1;
	}
	self.timer fadeovertime(.5);
	self.timer.alpha = 0;
	wait .5;
	self.timer destroy();
}

exitsecret_easy()
{
	trig = getent("exitsecret_trig_e","targetname");
	exitorigin = getent("exitsecret_origin_e","targetname");
	for(;;)
	{
		trig waittill("trigger",player);
			
		player setorigin(exitorigin.origin);
		player setplayerangles(exitorigin.angles);
		player.ineasy = false;
		player thread speedrun\_way_name::finish_way("s0");
		
	}
}

exitsecret_hard()
{
	trig = getent("exitsecret_trig_h","targetname");
	exitorigin = getent("exitsecret_origin_h","targetname");
	for(;;)
	{
		trig waittill("trigger",player);
		
		player setorigin(exitorigin.origin);
		player setplayerangles(exitorigin.angles);
		player.inhard = false;
		player thread speedrun\_way_name::finish_way("s1");

	}
}