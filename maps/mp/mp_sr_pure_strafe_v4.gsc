/*
______           __  _____  _____ 
| ___ \         /  ||  _  ||  _  |
| |_/ /_____  __`| || |/' || |_| |
|    // _ \ \/ / | ||  /| |\____ |
| |\ \  __/>  < _| |\ |_/ /.___/ /
\_| \_\___/_/\_\\___/\___/ \____/ 

*/

main()
{
	maps\mp\_load::main();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	
	thread speedrun\_way_name::create_normal_way("Normal Way");
    thread speedrun\_way_name::create_secret_way("Secret Way");

    //thread speedrun\_way_name::create_spawn((-215,527,76),300);

	//DISABLING FALLDAMAGE
	setDvar("bg_falldamagemaxheight", 9999999 );
    setDvar("bg_falldamageminheight", 999999 );

    thread secret_start();
    thread secret_end();
}

secret_start()
{
    trig = getent("secret_trig","targetname");
    org = getent("secret_start","targetname");

    while(1)
    {
        trig waittill("trigger",player);
        player thread speedrun\_way_name::change_way("s0");
        player setOrigin(org.origin);
        player setPlayerAngles(org.angles);
    }
}

secret_end()
{
    trig = getent("secret_end","targetname");

    while(1)
    {
        trig waittill("trigger",player);
        player thread speedrun\_way_name::finish_way("s0");
    }
}