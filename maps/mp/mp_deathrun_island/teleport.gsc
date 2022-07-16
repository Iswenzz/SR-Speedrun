/*
Map made by Sheep Wizard
youtube: http://www.youtube.com/user/paap15
xfire: paap15
*/
main()
{
     thread setupTeleport("secrettrig", (1593, 216, -550), "secrettarget");
	 thread setupTeleport("secretend", (-696, -7064, 88), "meow");
	 thread setupTeleport("shack", (3408, -2240, -1005), "shacktar");
	 thread setupTeleport("actitele1", (-320, -5572, 1304), "actitarget");
	 thread setupTeleport("actitele2", (1084, -11068,204), "actitarget2");
	 thread setupTeleport("actitele3", (3280, -1664, -1984), "actitarget3");
}

setupTeleport(trigger_targetname, location, angle) //feel free to use this.
{
	trig = getent (trigger_targetname,"targetname");
	target = getent (angle,"targetname");
	while(1)
	{
		trig waittill ("trigger",player);
        if(trig.targetname == "secrettrig"){
            player speedrun\_way_name::startSecret(); //Speedrun Copy Paste
        }
        if(trig.targetname == "secretend"){
            player braxi\_mod::endTimer();
            continue;
        }
		player setOrigin(location);
		player SetPlayerAngles( target.angles );
	}
}