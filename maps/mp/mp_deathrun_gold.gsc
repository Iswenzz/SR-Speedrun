main()
{
level.spawn["allies"] = getEntArray("mp_jumper_spawn", "classname");
if (!level.spawn["allies"].size)
	level.spawn["allies"] = getEntArray("mp_dm_spawn", "classname");
	maps\mp\_load::main();
	// maps\mp\teleporter::teleporter();
	// ambientPlay("lol");
	
	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";
	
	setDvar("bg_falldamagemaxheight", 300000 );
	setDvar("bg_falldamageminheight", 128000 );

	thread way_connect();
	thread spinnything();
	// thread trap1();
	// thread trap2();
	// thread trap3();
	// thread trap4();
	// thread trap5();
	// thread sniper();
	// thread knife();
	// thread addTestClients();
	thread secret();
	thread secretend();
	
	// addTriggerToList( "trap1_trigger" );
	// addTriggerToList( "trap2_trigger" );
	// addTriggerToList( "trap3_trigger" );
	// addTriggerToList( "trap4_trigger" );
	// addTriggerToList( "trap5_trigger" );
}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    sr\api\_speedrun::createNormalWays("Normal Way;");
	sr\api\_speedrun::createSecretWays("Secret Way;");
	
    for(;;)
    {
        level waittill( "connected", player );

    }
}
////////////////////////////////////////////////////////////////////////////////////////////////

addTriggerToList( name )
{
if( !isDefined( level.trapTriggers ) )
level.trapTriggers = [];
level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

addTestClients()
{
    setDvar("scr_testclients", "");
    wait 1;
    for(;;)
    {
        if(getdvarInt("scr_testclients") > 0)
            break;
        wait 1;
    }
    testclients = getdvarInt("scr_testclients");
    setDvar( "scr_testclients", 0 );
    for(i=0;i<testclients;i++)
    {
        ent[i] = addtestclient();

        if (!isdefined(ent[i]))
        {
            println("Could not add test client");
            wait 1;
            continue;
        }
        ent[i].pers["isBot"] = true;
        ent[i] thread TestClient("autoassign");
    }
    thread addTestClients();
}
TestClient(team)
{
    self endon( "disconnect" );

    while(!isdefined(self.pers["team"]))
        wait .05;
        
    self notify("menuresponse", game["menu_team"], team);
    wait 0.5;
}


trap1(){
trig = getEnt ("trap1_trigger", "targetname"); 
hurt = getEnt ("hurttrig", "targetname"); 
spikes = getEnt ("goldcrush", "targetname"); 

hurt enablelinkto(); 
hurt linkto (spikes); 

trig waittill ("trigger");
trig delete();
{ 
spikes moveZ (-112,0.6);
wait 2;
spikes moveZ (112,3);
}
}

trap2(){
trig2 = getEnt ("trap2_trigger", "targetname");
lines1 = getEnt ("lines1", "targetname");
lines2 = getEnt ("lines2", "targetname");
hurt1 = getEnt ("lines1hurt", "targetname");
hurt2 = getEnt ("lines2hurt", "targetname");

hurt1 enablelinkto(); 
hurt1 linkto (lines1);

hurt2 enablelinkto(); 
hurt2 linkto (lines2);  

trig2 waittill ("trigger");
trig2 delete();
{
lines1 moveX (144,0.9);
lines2 moveX (-144,0.9);
}
}

spinnything(){
spinny2 = getent ("spinnythingy", "targetname");
while(1){
spinny2 rotateyaw(360,3);
wait 1;
}
}

trap3(){
trig3 = getEnt ("trap3_trigger", "targetname"); 
roll = getEnt ("spinnythingy", "targetname"); 

trig3 waittill ("trigger");
trig3 delete();
{ 
roll moveY (-400,0.5);
wait 2;
roll moveY (400,1);
}
}

trap4(){
trig4 = getEnt ("trap4_trigger", "targetname"); 
spinny5 = getEnt ("goldspin", "targetname");

trig4 waittill ("trigger");
trig4 delete();
{ 
while(1){
spinny5 rotateroll(360,2);
wait 3;
}
}
}

trap5(){
trig5 = getEnt ("trap5_trigger", "targetname");
spikei = getEnt ("spikespinz", "targetname");
hurt2 = getEnt ("hurttrig2", "targetname");
hurt3 = getEnt ("hurttrig3", "targetname");

hurt2 enablelinkto();
hurt2 linkto (spikei);

hurt3 enablelinkto();
hurt3 linkto (spikei);

trig5 waittill ("trigger");
trig5 delete();
{
while(1){
spikei rotateroll(360,1.5);
wait 0.1;
}
}
}

sniper()
{
    level.knife_trig = getEnt( "snipe_trig", "targetname");
    jump = getEnt( "enter_snipe", "targetname" );
    acti = getEnt( "acti_snipe", "targetname" );
    
    while(1)
    {
        level.knife_trig waittill( "trigger", player );
        if( !isDefined( level.knife_trig ) )
            return;
        
		level.snipe_trig delete();
  
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "m40a3_mp" ); //jumper weapon        
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "m40a3_mp" );        
        wait 0.05;
        player switchToWeapon( "m40a3_mp" ); //activator weapon
        level.activ SwitchToWeapon( "m40a3_mp" );
        iPrintlnBold( " ^6" + player.name + " ^5 HAS CHOSEN SNIPE^1!" );     //change to what you want it to be
        while( isAlive( player ) && isDefined( player ) )
		
		
            wait 1;	
    }
}	

knife()
{
    level.snipe_trig = getEnt( "knife_trig", "targetname");
    jump1 = getEnt( "jumper_knife", "targetname" );
    acti2 = getEnt( "acti_knife", "targetname" );
    
    while(1)
    {
        level.snipe_trig waittill( "trigger", player );
        if( !isDefined( level.snipe_trig ) )
            return;
			
        level.knife_trig delete();
  
        player SetPlayerAngles( jump1.angles );
        player setOrigin( jump1.origin );
        player TakeAllWeapons();
        player GiveWeapon( "tomahawk_mp" ); //jumper weapon        
        level.activ setPlayerangles( acti2.angles );
        level.activ setOrigin( acti2.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "tomahawk_mp" );        
        wait 0.05;
        player switchToWeapon( "tomahawk_mp" ); //activator weapon
        level.activ SwitchToWeapon( "tomahawk_mp" );
        iPrintlnBold( " ^6" + player.name + " ^5 HAS CHOSEN KNIFE^1!" );     //change to what you want it to be
        while( isAlive( player ) && isDefined( player ) )
		
		
            wait 1;	
    }
}	

secret(){
trig=getent("secret","targetname");
origin=getent("origin","targetname");
while(1){
trig waittill("trigger",user);
user SetOrigin( origin.origin );
user sr\api\_speedrun::changeWay("secret_0"); //Speedrun Copy Paste
}
}

secretend(){
trig7=getent("secretend","targetname");
origin7=getent("origin2","targetname");
while(1){
trig7 waittill("trigger",user);
user SetOrigin( origin7.origin );
user thread braxi\_mod::endTimer();
}
}
