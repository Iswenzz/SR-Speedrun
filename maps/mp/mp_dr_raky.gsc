main() 
{
    game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
 
	setdvar( "r_specularcolorscale", "1" );
	setdvar("compassmaxrange","1600");
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setDvar("bg_falldamagemaxheight", 3000000 );
	setDvar("bg_falldamageminheight", 1280000 );

	thread sr\api\_map::createSpawn((-117,-72,84),270);
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("^2Easy Secret;^1Hard Secret;^5Acti Secret;");
	thread sr\api\_speedrun::createTeleporter((-364.493, -258.509, 24.125), 60, 50, (17800, -14488, -188), 360, "freeze", "yellow", "secret_0");
	thread sr\api\_speedrun::createTeleporter((118.369, -253.674, 24.125), 60, 50, (-1643, -613, -3724), 90, "freeze", "cyan", "secret_2");

    block_brush = getEnt("trap_6_brush","targetname");
	block_brush delete();

    thread startdoor();
    thread elevator();
	thread trap4();
    thread secrethenter();
    thread secrethexit();
    thread secreteexit();
	thread easy_hurt();
	thread secrets();
	thread actisec_finish();
	thread actisec_hurt();

}

startdoor()
{
door =getEnt("startdoor", "targetname");

door delete();

}

elevator()
{
ele =getEnt("elevator", "targetname");

ele moveZ(-896,0.1);
wait 0.1;
ele moveY(120,0.1);

}

trap4()
{
trap_4 = getEntArray("moving_plat","targetname");
trap_4_1 = getEntArray("moving_ori","targetname");

wait 0.1;

trap_4[0] moveX(200,0.1);
trap_4[1] moveX(200,0.1);
trap_4[2] delete();
trap_4[3] delete();
trap_4_1[0] delete();
trap_4_1[1] delete();
trap_4_1[2] delete();
wait 0.2;
trap_4[1] moveY(-300,0.1);


}

secrethenter()
{
trig = getEnt("hard_enter", "targetname");
tele1 = getEnt("hard_ori", "targetname");

	for(;;)
		{
		trig waittill("trigger", player);

        player thread sr\api\_speedrun::changeWay("secret_1");
		player setOrigin(tele1.origin);
		player setPlayerAngles(tele1.angles);		
        
		}
}

secrethexit()
{
trig = getEnt("hard_finish", "targetname");

	for(;;)
		{
		trig waittill("trigger", player);

        player thread sr\api\_speedrun::finishWay("secret_1");
        
		}
}

secreteexit()
{
trig = getEnt("easy_finish", "targetname");

	for(;;)
		{
		trig waittill("trigger", player);

        player thread sr\api\_speedrun::finishWay("secret_0");
        
		}
}

easy_hurt()
{
trig = getEnt("easy_trig", "targetname");

	for(;;)
		{
		trig waittill("trigger", player);

        player Suicide();
        
		}
}

secrets()
{
	secret = [];

	for(i = 0; i < 2; i++)
		secret[i] = SpawnStruct();

	secret[1].name = "hard";

	thread secrets_setup(secret[1]);
}

secrets_setup(secret)
{
	trig = getEnt(secret.name+"_trig","targetname");
	trig_checkpoint = getEntArray(secret.name+"_respawn_trig","targetname");
	ori = getEntArray(secret.name+"_respawn_ori","targetname");

	thread secret_enter(secret);

	for(i = 0; i < trig_checkpoint.size; i++)
		trig_checkpoint[i] thread secret_checkpoint(secret,i);

	while(1)
	{
		trig waittill("trigger",player);

		if(!isDefined(player.secret_checkpoint[secret.name]))
			player thread safe_tp(getEnt(secret.name+"_ori","targetname"));
		else
			player thread safe_tp(ori[player.secret_checkpoint[secret.name]]);
	}
}

secret_checkpoint(secret,i)
{
	for(;;)
	{
		self waittill("trigger",player);

		if(!isDefined(player.secret_checkpoint[secret.name]) ||
			isDefined(player.secret_checkpoint[secret.name]) &&
			player.secret_checkpoint[secret.name] != i)
			player.secret_checkpoint[secret.name] = i;
		else
			wait 1;
	}
}

secret_enter(secret)
{
	trig = getEnt(secret.name+"_enter","targetname");
	ori = getEnt(secret.name+"_ori","targetname");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread safe_tp(ori);
		player.secret_checkpoint = [];
		player.secret_checkpoint[secret.name] = undefined;
	}
}

safe_tp(ori)
{
	self endon("death");
	self endon("disconnect");

	self freezeControls(true);
	self setOrigin(ori.origin);
	self setPlayerAngles(ori.angles);
	wait 0.05;
	self freezeControls(false);
}

actisec_finish()
{
trig = getEnt("run_finish_jumper","targetname");

    for(;;)
	{
	trig waittill("trigger", player);

    player thread sr\api\_speedrun::finishWay("secret_2");
        
	}
}

actisec_hurt()
{
trig[0] = getEnt("trigger_fail_run", "targetname");

	for(;;)
	{
	trig[0] waittill("trigger", player);

    player Suicide();
        
	}
}