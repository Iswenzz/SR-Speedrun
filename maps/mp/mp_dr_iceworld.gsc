main() {
	maps\mp\_load::main();

    // Disables Fall Damage
    setdvar( "bg_fallDamageMaxHeight","999999999" );
    setdvar( "bg_fallDamageMinHeight","9999999" );

    setdvar( "bg_bobamplitudesprinting", "0" );
    setdvar( "bg_bobamplitudeducked", "0" );
    setdvar( "bg_bobamplitudeprone", "0" );
    setdvar( "bg_bobamplitudestanding", "0" );

    preCacheItem( "m40a3_mp" );
    preCacheItem( "remington700_mp" );
    preCacheItem( "ak47_mp" );
    preCacheItem( "deserteagle_mp" );
    preCacheModel( "lion" );
    preCacheModel( "viewhands_lion" );

thread sr\api\_map::createSpawn((0,0,60), 0);
thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_speedrun::createSecretWays("Secret Way;");

    thread startdoor();
    thread secret_enter();
    thread secret_fail();
    thread secret_finish();
    thread traps();

}

startdoor() 
{
    door = getEnt( "startdoor", "targetname" );
    swing1 = getEnt( "secret_open_1", "targetname" );
    swing2 = getEnt( "secret_open_2", "targetname" );

    door delete();
    swing1 delete();
    swing2 delete();
}

secret_enter() 
{
    enter = getEnt( "secret_enter", "targetname" );
    level.secret = getEnt( "secret_org", "targetname" );

    enter setHintString( "^7Press ^8&&1 ^7To enter the secret!" );

    while( 1 ) 
    {
        enter waittill( "trigger", player );
        player thread sr\api\_speedrun::changeWay("secret_0");
        player setorigin (level.secret.origin);
        player setplayerangles (level.secret.angles);
    }
}

secret_fail() 
{
    fail = getEnt( "secret_fail", "targetname" );

    while( 1 ) {
        fail waittill( "trigger", player );
        player setorigin (level.secret.origin);
        player setplayerangles (level.secret.angles);
    }
}

secret_finish() 
{
    trig = getEnt( "secret_finish", "targetname" );
    org = getEnt( "secret_finish_org", "targetname" );

    while( 1 ) 
    {
    trig waittill( "trigger", player );
    player thread sr\api\_speedrun::finishWay("secret_0");
    }
}

traps() 
{
    door = getEnt( "trap4_ice", "targetname" );
    doors = getEnt( "trap5_doors", "targetname" );
    laser = getEnt( "trap10_1", "targetname" );
    hurt = getEnt ( "trap10_hurt", "targetname" );

    door delete();
    doors delete();
    laser delete();
    hurt delete();
}