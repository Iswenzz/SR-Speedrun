main()
{
	thread car_door();
	// thread wait_connect();
	thread main_dinosaur();
	// thread final_doors();
	// thread dino_sound();
	
	level.custom_knife = true; //false = ak47; true = tomahawk
	level.pre_weapon = false;
	
	// thread bounce_weapon();
	// thread secret_room();
	// thread secret_room2();
	
	if(level.custom_knife)
		PreCacheItem("tomahawk_mp");
		
	PreCacheItem("m40a3_mp");
	PreCacheItem("remington700_mp");
}

car_door()
{
	door1 = getent("dra","targetname");
	door2 = getent("drb","targetname");
	
	car_model = getent("cara","targetname");
	car_player = getent("carb","targetname");
	
	// level waittill("first_spawn");
	
	wait 0.1;
	
	//car_player EnableLinkTo();
	car_player LinkTo(car_model);
	
	car_model movey(672, 3); //druhy udaj je rychlost
	wait 2;
	
	door1 rotateyaw(90,1); //druhy udaj je rychlost
	door2 rotateyaw(-90,1);
	
	car_model waittill("movedone");
	car_model Unlink();
}

main_dinosaur()
{
	//tak s nama sulinama si robi co chce?
	//to je mi uroven....:D
	brush = [];
	
	for(i = 0;i < 1;i++)
	{	
		brush[i] = getent("shark_"+i , "targetname");
		brush[i] thread move_dinosaur(7,1);
	}
	
	for(i = 0;i < 1;i++)
	{	
		brush[i] = getent("ptak_"+i , "targetname");
		brush[i] thread move_dinosaur(5,1);
	}
	
	for(i = 0;i < 1;i++)
	{	
		brush[i] = getent("dino_"+i , "targetname");
		brush[i] thread move_dinosaur(8,1);
	}
			
	for(i = 0;i < 1;i++)
	{	
		brush[i] = getent("das_"+i , "targetname");
		brush[i] thread move_dinosaur(5,1);
	}
											
	for(i = 0;i < 1;i++)
	{	
		brush[i] = getent("mas_"+i , "targetname");
		brush[i] thread move_dinosaur(5,1);
	}
			
	for(i = 0;i < 1;i++)
	{	
		brush[i] = getent("tak_"+i , "targetname");
		brush[i] thread move_dinosaur(7,1);
	}
		
	for(i = 0;i < 1;i++)
	{	
		brush[i] = getent("tyr_"+i , "targetname");
		brush[i] thread move_dinosaur(5,1);
	}
	

}

move_dinosaur(speed1,speed2)
{
	ent = [];
	i = 1;
	ent[0] = self;
	
	//log_on_spawn("start funkcion");
	for(;;)
	{
		next = getent( ent[i-1].target , "targetname" );
		
		if(isdefined(next) && next != self)
		{
			ent[i] = next;
		}	
		else
		{
			break;
		}
		i++;
	}
	
	//log_on_spawn("for1 done");
	origin = [];
	angles = [];
	
	for(j = 0; j < i; j++)
	{
		origin[j] = ent[j].origin;
		angles[j] = ent[j].angles;
	}
	//log_on_spawn("for2 done");
	max = i;
	
	while(1)
	{
		for(i = 0;i<max;i++)
		{
			dis = distance(self.origin,origin[i]);
			//iprintln("dis: "+dis );
			self moveto(origin[i], speed1);
			self waittill("movedone");
			self RotateTo(angles[i], speed2);
		}
		//log_on_spawn("for3 done");
	}
}

final_doors()
{
	old_trig = getent("final_old","targetname");
	snip_trig = getent("final_snip","targetname");
	bounce_trig = getent("final_bounce","targetname");
	weapons_trig = getent("final_weapons","targetname");
	knife_trig = getent("final_knife","targetname");
	
	old_trig thread old(snip_trig,bounce_trig,weapons_trig,knife_trig);
	snip_trig thread snip(old_trig,bounce_trig,weapons_trig,knife_trig);
	bounce_trig thread bounce(snip_trig,old_trig,weapons_trig,knife_trig);
	weapons_trig thread weapons(snip_trig,old_trig,bounce_trig,knife_trig);
	knife_trig thread knife(snip_trig,old_trig,bounce_trig,weapons_trig);
}

old(final1,final2,final3,final4)
{
	self waittill("trigger", player);
	
	self delete();
	final1 delete();
	final2 delete();
	final3 delete();
	final4 delete();
	
	// AmbientPlay( "song2" );
	iprintlnbold("Player ^1"+player.name+" ^7open old room!");
	
	doors = getentarray("final_door","targetname");
	
	r = randomint(doors.size);
	doors[r] movez(110,2);
}

snip(final1,final2,final3,final4)
{
	self waittill("trigger", player);
	
	//self delete();
	final1 delete();
	final2 delete();
	final3 delete();
	final4 delete();
	
	// AmbientPlay( "song2" );
	
	iprintlnbold("Player ^1"+player.name+" ^7open snipe room!");
	
	porty_allies = getentarray("snip_allies","targetname");
	porty_axis = getentarray("snip_axis","targetname");
	raxis = randomint(porty_axis.size);
	
	players = getentarray("player","classname");
	
	for(i = 0;i < players.size;i++)
	{
		if(isdefined(players[i]) && isplayer(players[i]) && isalive(players[i]) && players[i].pers["team"] == "axis")
		{
			players[i] setorigin(porty_axis[raxis].origin);
			players[i] SetPlayerAngles(porty_axis[raxis].angles);
			
			if(randomint(2))
				weap = "m40a3_mp";
			else
				weap = "remington700_mp";
			
			players[i] TakeAllWeapons();
			players[i] GiveWeapon(weap);
			wait 0.01;
			players[i] SwitchToWeapon(weap);
		}
	}
	
	while(true)
	{
		if(randomint(2))
			weap = "m40a3_mp";
		else
			weap = "remington700_mp";
	
		self jumper_port(player,porty_allies,weap);
		
		self on_player_death(player);
		
		self waittill("trigger",player);
	}
	
}

on_player_death(player)
{	
	player endon("disconnect");
	
	player waittill("death");
}

jumper_port(player,porty_allies,weapon)
{
	rallies = randomint(porty_allies.size);
	
	player setorigin(porty_allies[rallies].origin);
	player SetPlayerAngles(porty_allies[rallies].angles);
	
	player TakeAllWeapons();
	player GiveWeapon(weapon);
	wait 0.01;
	player SwitchToWeapon(weapon);
}

bounce(final1,final2,final3,final4)
{
	self waittill("trigger", player);
	
	//self delete();
	final1 delete();
	final2 delete();
	final3 delete();
	final4 delete();
	
	// AmbientPlay( "song2" );
	
	iprintlnbold("Player ^1"+player.name+" ^7open bounce room!");
	
	porty_allies = getentarray("bounce_allies","targetname");
	porty_axis = getentarray("bounce_axis","targetname");
	raxis = randomint(porty_axis.size);
	
	thread bounce_teleport(porty_allies,porty_axis);
	thread bounce_weapon();
	
	players = getentarray("player","classname");
	
	for(i = 0;i < players.size;i++)
	{
		if(isdefined(players[i]) && isplayer(players[i]) && isalive(players[i]) && players[i].pers["team"] == "axis")
		{
			players[i] setorigin(porty_axis[raxis].origin);
			players[i] SetPlayerAngles(porty_axis[raxis].angles);
		}
	}
	
	while(true)
	{
		if(level.custom_knife)
			weap = "tomahawk_mp";
		else
			weap = "ak47_mp";
			
		self jumper_port(player,porty_allies,weap);
		
		//self on_player_death(player);
		
		self waittill("trigger",player);
	}
	
}

bounce_teleport(port_allies,port_axis)
{
	trig = getent("bounce_tele","targetname");
	
	while(true)
	{
		trig waittill("trigger",player);
		
		raxis = randomint(port_axis.size);
		rallies = randomint(port_allies.size);
		
		if(isplayer(player)&&isalive(player))
		{
			if(player.pers["team"] == "axis")
			{
				player setorigin(port_axis[raxis].origin);
				player SetPlayerAngles(port_axis[raxis].angles);
			}

			if(player.pers["team"] == "allies")
			{
				player setorigin(port_allies[rallies].origin);
				player SetPlayerAngles(port_allies[rallies].angles);
			}			
		}
	}
}

bounce_weapon()
{
	level.jura_weapons = [];
	level.jura_weapons[level.jura_weapons.size] = "saw_reflex_mp";
	level.jura_weapons[level.jura_weapons.size] = "rpd_reflex_mp";
	level.jura_weapons[level.jura_weapons.size] = "p90_reflex_mp";
	level.jura_weapons[level.jura_weapons.size] = "mp5_silencer_mp";
	level.jura_weapons[level.jura_weapons.size] = "m60e4_reflex_mp";
	level.jura_weapons[level.jura_weapons.size] = "m4_reflex_mp";
	level.jura_weapons[level.jura_weapons.size] = "m21_acog_mp";
	level.jura_weapons[level.jura_weapons.size] = "m16_mp";
	level.jura_weapons[level.jura_weapons.size] = "m14_reflex_mp";
	level.jura_weapons[level.jura_weapons.size] = "g3_mp";
	level.jura_weapons[level.jura_weapons.size] = "dragunov_acog_mp";
	level.jura_weapons[level.jura_weapons.size] = "deserteagle_mp";
	level.jura_weapons[level.jura_weapons.size] = "ak74u_acog_mp";
	level.jura_weapons[level.jura_weapons.size] = "ak47_mp";
	level.jura_weapons[level.jura_weapons.size] = "colt45_silencer_mp";

	if(!level.pre_weapon)
	{
		level.pre_weapon = true;
		
		for(i = 0;i < level.jura_weapons.size;i++)
		{
			PreCacheItem(level.jura_weapons[i]);
		}
		
		return;
	}
	else
	{
		trig = getent("bounce_weapon","targetname");
		trig waittill("trigger",player);
		trig delete();
		
		rz = randomint(level.jura_weapons.size);
		rk = randomint(2);
		
		if(rk)
		{
			player TakeAllWeapons();
			player GiveWeapon(level.jura_weapons[rz]);
			wait 0.01;
			player SwitchToWeapon(level.jura_weapons[rz]);
			//player iprintlnbold("Toll, sehr schon Gewehr fur dich.");
		}
	}	
}

weapons(final1,final2,final3,final4)
{
	self waittill("trigger", player);
	
	//self delete();
	final1 delete();
	final2 delete();
	final3 delete();
	final4 delete();
	
	// AmbientPlay( "song2" );
	
	iprintlnbold("Player ^1"+player.name+" ^7open weapons room!");

	rz = randomint(level.jura_weapons.size);
	weap = level.jura_weapons[rz];
	
	porty_axis = getentarray("weapons_axis","targetname");
	raxis = randomint(porty_axis.size);
	
	players = getentarray("player","classname");
	
	for(i = 0;i < players.size;i++)
	{
		if(isdefined(players[i]) && isplayer(players[i]) && isalive(players[i]) && players[i].pers["team"] == "axis")
		{
			players[i] setorigin(porty_axis[raxis].origin);
			players[i] SetPlayerAngles(porty_axis[raxis].angles);
			
			players[i] TakeAllWeapons();
			players[i] GiveWeapon(weap);
			wait 0.01;
			players[i] SwitchToWeapon(weap);
		}
	}
	
	porty_allies = getentarray("weapons_allies","targetname");
	
	while(true)
	{
		rz = randomint(level.jura_weapons.size);
		weap = level.jura_weapons[rz];
		
		self jumper_port(player,porty_allies,weap);
		
		self on_player_death(player);
		
		self waittill("trigger",player);
	}
}

knife(final1,final2,final3,final4)
{
	self waittill("trigger", player);
	
	//self delete();
	final1 delete();
	final2 delete();
	final3 delete();
	final4 delete();
	
	// AmbientPlay( "song2" );
	
	iprintlnbold("Player ^1"+player.name+" ^7open knife room!");
	
	if(level.custom_knife)
		weap = "tomahawk_mp";
	else
		weap = "ak47_mp";
	
	while(1)
	{
		porty_axis = getentarray("knife_axis","targetname");
		raxis = randomint(porty_axis.size);
		porty_allies = getentarray("knife_allies","targetname");
		rallies = randomint(porty_allies.size);
	
		players = getentarray("player","classname");
		
		for(i = 0;i < players.size;i++)
		{
			if(isdefined(players[i]) && isplayer(players[i]) && isalive(players[i]) && players[i].pers["team"] == "axis")
			{
				players[i] setorigin(porty_axis[raxis].origin);
				players[i] SetPlayerAngles(porty_axis[raxis].angles);
			}
		}

		self jumper_port(player,porty_allies,weap);
		
		self on_player_death(player);
		
		self waittill("trigger",player);	
	}	
}

secret_room()
{
	trig = getent("secret","targetname");
	target = getent(trig.target , "targetname");
	
	for(;;)
	{
		trig waittill("trigger",player);
		
		if(player getStance() != "prone")
			continue;
		
		player setorigin(target.origin);
		player SetPlayerAngles(target.angles);
	}
}

secret_room2()
{
	trig = getent("secret2","targetname");
	target = getent(trig.target , "targetname");
	
	for(;;)
	{
		trig waittill("trigger",player);

		player setorigin(target.origin);
		player SetPlayerAngles(target.angles);
	}
}

dino_sound()
{
	trig = getent("rex","targetname");
	trig waittill("trigger");
	trig PlaySound("trex");
}
