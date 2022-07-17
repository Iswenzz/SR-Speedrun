/*
I am also leaving this custome challanges to every server owner, who ever wants it can remake them and add some of his ideas, same gouse for the random suprise :P! Hope u enjoy :D
*/
main()
{
	// PreCacheShellShock("flashbang");
	precachemodel("weapon_ak47");
	precachemodel("weapon_beretta");
	precachemodel("weapon_remington700");
	precachemodel("weapon_g3");
	precachemodel("weapon_rpg7");

	precacheitem("ak47_mp");
	precacheitem("beretta_mp");
	precacheitem("rpg_mp");
	precacheitem("g3_mp");

	// thread connect();
	// thread chanallangehud();
	// thread hud("^5* * ^3Custome ^2Challenges^3 Loaded!^5 * *");
	// thread legendchallange_time1();
	// thread secret_steps();
	// thread watchsteps();
	// thread givexpifalive();
	thread secretbounce();
	thread secretfailtele();
	// thread legendsrandomsuprise();
	thread secretendtele();
	// thread box();
	// level.box hide();

}

connect()
{
	for(;;)
	{
	level waittill("connected", player );
	player thread acti_killstreak();
	}
}

acti_killstreak()
{
   self endon("disconnect");
   self endon("killed_player");
   self endon("joined_spectators");

   streak = 0;
   before = self.kills;

   if (isDefined(self.pers["acti_killstreak"]) || level.freeRun == true)
   	return;

   for(;;)
   {
      current = self.kills;
      while(current == self.kills)
         wait 0.05;

      streak = self.kills - before;

      if((streak % 5) == 0 && !self.pers["acti_killstreak"] && self.pers["team"] == "axis")
      {
      	self.pers["acti_killstreak"] = true;
      	self braxi\_rank::giverankxp(undefined,500);
      	actik = self;
      	thread challange("^5"+actik.name+" ^2Completed The Activator Challenge!");
      }
   }
}

challange(text)
{
	challange = NewHudElem();
	challange.alignX = "center";
	challange.alignY = "middle";
	challange.horzalign = "center";
	challange.vertalign = "middle";
	challange.alpha = 1;
	challange.x = 0;
	challange.y = -300;
	challange.font = "default";
	challange.fontscale = 2;
	challange.glowalpha = 1;
	challange.glowcolor = (1,0,0);
	challange setText( text );
	challange moveovertime(2.5);
	challange.y = 0;
	wait 3.5;
	challange moveovertime(2.5);
	challange.y = 300;
	wait 3;
	challange destroy();
}

hud(text)
{
	huds = NewHudElem();
	huds.alignX = "center";
	huds.alignY = "top";
	huds.horzalign = "center";
	huds.vertalign = "top";
	huds.alpha = 1;
	huds.x = -1000;
	huds.y = 0;
	huds.font = "default";
	huds.fontscale = 2;
	huds.glowalpha = 1;
	huds.glowcolor = (1,0,0);
	huds setText( text );
	wait 5;
	huds moveovertime(10);
	huds.x = 1000;
	wait 10;
	huds destroy();
}

chanallangehud() //and some other huds
{
	wait 10;
	thread hud("^5* * ^2Kill 5 Jumpers In A Row and Get ^1500 XP!^5 * *");
	wait 12;
	thread hud("^5* * ^2Finish Map Under 36 Secounds and Get ^11000 XP!^5 * *");
	wait 14;
	thread hud("^5* * ^2Big Thanks To ^1VC'Blade^5 * *");
	wait 16;
	thread hud("^5* * ^2Thanks ^3Xplosive ^2For Some Trap Ideas^5 * *");
}

legendchallange_time1()
{
	trig = getEntArray( "endmap_trig", "targetname" );
	if( !trig.size || trig.size > 1 )
		return;

	level.mapHasTimeTrigger = true;

	trig = trig[0];
	while( 1 )
	{
		trig waittill( "trigger", user );

		user thread legendchallange_time2();
	}
}

legendchallange_time2()
{
	if( isDefined( self.pers["timechallange"] ) || level.freeRun == true) //remaked stopwatch - Braxi script
	return;

	time = (getTime() - self.timerStartTime) / 1000;
	if (time > 36 && !self.pers["timechallange"] && !self.notcompleted)
	{
		self iprintln("^1Challange was not completed :/");
		self.notcompleted = true;

	}
	else if (time <= 36 && !self.pers["timechallange"])
	{
		self braxi\_rank::giverankxp(undefined,500);
		self braxi\_rank::giverankxp(undefined,500);
		self.pers["timechallange"] = true;
		timec = self;
		thread challange("^5"+timec.name+"^2 Completed The Time Challenge!");
	}

}

secret_steps()
{
		trig1 = getent("step1","targetname");
		trig2 = getent("step2","targetname");
		trig3 = getent("step3","targetname");
		secretorigin = getent("secretspot","targetname");
}

watchsteps()
{
	while(1)
	{
		level waittill("player_spawn", user );

		user thread sethands();
		user.step1 = 0;
		user.step2 = 0;
		user.step3 = 0;
		user.counter = 0;
	}
}

sethands()
{
	self endon( "disconnect" );

	waittillframeend;
	self detachAll();
	self setViewmodel("viewmodel_base_viewhands");
}

givexpifalive()
{
	wait 50+randomint(10);
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
	{
		if (isAlive(players[i]))
		{
			players[i] braxi\_rank::giverankxp(undefined, 10);
		}
	}
}

secretbounce()
{
	level waittill("round_started");
	level.knockback = getDvarInt("g_knockback");

	bounce = getEnt("bounce","targetname");
	bounce thread bounce();
}

bounce()
{
	for(;;)
	{
		self waittill("trigger", p);

		if(!isDefined(p.bouncing))
			p thread player_bounce(self);
	}
}

player_bounce(trigger)
{
	self.bouncing = true;

	vel = self getVelocity();

	temp0 = (((vel[0] < 350 && vel[0] > 0) || (vel[0] > -350 && vel[0] < 0)));
	temp1 = (((vel[1] < 350 && vel[1] > 0) || (vel[1] > -350 && vel[1] < 0)));

	if((!temp0 && !temp1) || vel[2] > -350)
	{
		wait 1;

		self.bouncing = undefined;
		return;
	}

	health    = self.health;
	maxHealth = self.maxHealth;
	self.health    = 1000000;
	self.maxhealth = 1000000;

	setDvar("g_knockback", (vel[2]*-9)-500);
	self finishPlayerDamage(self, self, 1000, 0, "MOD_UNKNOWN", "bounce", self.origin, (0,0,1) , "none", 0);

	wait 0.05;
	setDvar("g_knockback", level.knockback);

	self.health    = health;
	self.maxhealth = maxHealth;

	while(self isTouching(trigger))
		wait 0.05;

	self.bouncing = undefined;
}

secretfailtele()
{
	level.secretspot = getent("secretfail","targetname");
	trig = getEnt("secretfailtrig","targetname");
	for(;;)
	{
		trig waittill("trigger", failer);
		failer setOrigin( level.secretspot.origin );
		failer setplayerangles( level.secretspot.angles );
		wait .0005;
	}
}

secretendtele()
{
	secretendtrig = getEnt("secretendtrig","targetname");
	level.telesend = getent("telesend","targetname");
	for(;;)
	{
		secretendtrig waittill("trigger", player );
		// player iprintlnBold("Teleporting in 5 secounds!");
		// player thread teletoendsecret();
		// player thread secretcheack();
player thread sr\api\_speedrun::finishWay("secret_0");
	}
}

secretcheack()
{
	if (isDefined(self.pers["secret"]))
		return;

		self braxi\_rank::giverankxp(undefined, 200);
		self.pers["secret"] = true;
}
teletoendsecret()
{
	wait 5;
	self setOrigin( level.telesend.origin );
	self setplayerangles( level.telesend.angles );
}

legendsrandomsuprise()
{
	level waittill("round_started");
	players = getentarray("player", "classname");
	wait 2;
	x = randomint(11);
	{
		if (x == 1)
		{
			iprintlnBold("Error 404, suprise not found!");
		}

		if (x == 2)
		{
			iprintlnBold("Random Suprise: All players get deagle!");
			for(i=0;i<players.size;i++)
			{
				players[i] GiveWeapon("deserteagle_mp");
				players[i] givemaxammo("deserteagle_mp");
				wait .0001;
				players[i] SwitchToWeapon("deserteagle_mp");
			}
		}

		if (x == 3)
		{
			iprintlnBold("Random Suprise: Nothing!");
		}

		if (x == 4)
		{
			iprintlnBold("Random Suprise: This round will be skiped!");
			iprintlnBold("All players will die!");
			wait 1;
			for(i=0;i<players.size;i++)
			{
				players[i] suicide();
			}
		}

		if (x == 5)
		{
			wait 5;
			iprintlnBold("Random Suprise: All players will be flashed!");
			wait 1;
			for(i=0;i<players.size;i++)
			{
				players[i] ShellShock("flashbang", randomint(5));
			}
		}

		if (x == 6)
		{
			iprintlnBold("Random Suprise: All players will be bounced!");
			for(i=0;i<players.size;i++)
			{
				players[i] thread Bouncer();
				wait .1;
				players[i] thread Bouncer();
				wait .1;
				players[i] thread Bouncer();
				wait .1;
				players[i] thread Bouncer();
			}
		}

		if (x == 7)
		{
			iprintlnBold("Random Suprise: All players will be teleported to secret!");
			for(i=0;i<players.size;i++)
			{
				players[i] setOrigin( level.secretspot.origin );
				wait .00001;
				level.activ setOrigin( level.rubytele.origin );
			}
		}

		if (x == 8)
		{
			iprintlnBold("No suprise this round!");
		}

		if (x == 9)
		{
			iprintlnBold("Random Suprise: All players get 50 xp!");
			for(i=0;i<players.size;i++)
			{
				players[i]  braxi\_rank::giverankxp(undefined, 50);
			}
		}

		if (x == 10)
		{
			iprintlnBold("Random Suprise: Weapon Box spawned!");
			thread weaponbox();
			level.box show();
		}

		if (x == 11)
		{
			iprintlnBold("Random Suprise: Higher speed for all players!");
			for(i=0;i<players.size;i++)
			{
				// players[i] sr\api\_player::setPlayerSpeedScale(1.5);
			}
		}

	}
}

Bouncer()
{
	self endon("death");
	{
	self bounceran( vectorNormalize( self.origin - (self.origin - (0,0,50)) ), 10000 );
	}
}

bounceran( pos, power )
{
	oldhp = self.health;
	self.health = self.health + power;
	self setClientDvars( "bg_viewKickMax", 0, "bg_viewKickMin", 0, "bg_viewKickRandom", 0, "bg_viewKickScale", 0 );
	self finishPlayerDamage( self, self, power, 0, "MOD_PROJECTILE", "none", undefined, pos, "none", 0 );
	self.health = oldhp;
	self thread bounce2();
}
bounce2()
{
	self endon( "disconnect" );
	wait .05;
	self setClientDvars( "bg_viewKickMax", 90, "bg_viewKickMin", 5, "bg_viewKickRandom", 0.4, "bg_viewKickScale", 0.2 );
}

box()
{
	level.box = getEnt("wepbox","targetname");
}

weaponbox()
{
	boxtrig = getEnt("boxtrig","targetname");
	wepmodel = spawn("script_model",(-208, 560, 0));

	wep = randomint(6);

			if (wep == 1)
			{
				wepmodel setModel("weapon_ak47");
				wepmodel moveZ(45, 1, .5);
				for(;;)
				{
					boxtrig waittill("trigger", player );
					player GiveWeapon("ak47_mp");
					player givemaxammo("ak47_mp");
					wait .1;
					player SwitchToWeapon("ak47_mp");
				}
			}

			if (wep == 2)
			{
				wepmodel setModel("weapon_beretta");
				wepmodel moveZ(45, 1, .5);
				for(;;)
				{
					boxtrig waittill("trigger", player );
					player GiveWeapon("beretta_mp");
					player givemaxammo("beretta_mp");
					wait .1;
					player SwitchToWeapon("beretta_mp");
				}
			}

			if (wep == 3)
			{
				wepmodel setModel("weapon_remington700");
				wepmodel moveZ(45, 1, .5);
				for(;;)
				{
					boxtrig waittill("trigger", player );
					player GiveWeapon("remington700_mp");
					player givemaxammo("remington700_mp");
					wait .1;
					player SwitchToWeapon("remington700_mp");
				}
			}

			if (wep == 4)
			{
				wepmodel setModel("weapon_desert_eagle_gold");
				wepmodel moveZ(45, 1, .5);
				for(;;)
				{
					boxtrig waittill("trigger", player );
					player GiveWeapon("deserteaglegold_mp");
					player givemaxammo("deserteaglegold_mp");
					wait .1;
					player SwitchToWeapon("deserteaglegold_mp");
				}
			}

			if (wep == 5)
			{
				wepmodel setModel("weapon_g3");
				wepmodel moveZ(45, 1, .5);
				for(;;)
				{
					boxtrig waittill("trigger", player );
					player GiveWeapon("g3_mp");
					player givemaxammo("g3_mp");
					wait .1;
					player SwitchToWeapon("g3_mp");
				}
			}

			if (wep == 6)
			{
				wepmodel setModel("weapon_rpg7");
				wepmodel moveZ(45, 1, .5);
				for(;;)
				{
					boxtrig waittill("trigger", player );
					player GiveWeapon("rpg_mp");
					player givemaxammo("rpg_mp");
					wait .1;
					player SwitchToWeapon("rpg_mp");
				}
			}
}