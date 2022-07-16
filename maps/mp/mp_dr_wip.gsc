#include maps\mp\_utility;
#include common_scripts\utility;
main()
{
    trigger = spawn( "trigger_radius", (-5977, 217, 60), 0, 30, 75 );
    trigger.targetname = "endmap_trig";
    trigger.radius = 30;

    trigger2 = spawn( "trigger_radius", (193, 354, 39), 0, 150, 100 );
    trigger2.targetname = "death";

    trigger3 = spawn( "trigger_radius", (437, 548, 76), 0, 200, 100 );
    trigger3.targetname = "death2";

    trigger4 = spawn( "trigger_radius", (-2325, -25, -400), 0, 5000, 50 );
    trigger4.targetname = "death2";
    
    thread watch1(trigger2);
    thread watch1(trigger3);
    thread watch1(trigger4);
    

    //thread speedrun\_way_name::create_normal_way("^6Sheep ^4Is ^6Cool");
    thread speedrun\_way_name::create_spawn((-116,1,28), 40);
    thread speedrun\_way_name::create_normal_way("^6Sheep ^4Is ^6Cool;");
    thread speedrun\_way_name::create_endmap((-1160,1000,28), 120, 100);

    thread onConnect();
    
}

onConnect()
{
    for(;;)
    {
        level waittill( "connected", player );
        player SetClientDvar("r_specularmap", 2);
        player thread onPlayerSpawned();
    }
}

onPlayerSpawned()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("spawned_player");
        self thread clone();
	}
}

clone(){
    self endon("death");
    self endon("disconnect");
    while(1){
        self.clone = self clonePlayer(1);
        forward = vector_scale(anglesToForward(self.angles), -20);
        self.clone.origin = self.origin+forward;
        self.clone.angles = self.angles;
        wait 0.1;
    }
}

watch1(trigger2){
    for(;;){
        trigger2 waittill("trigger", player);
        player suicide();
    }
}



	
