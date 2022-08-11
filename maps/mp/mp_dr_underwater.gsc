main()
{
maps\mp\_load::main();
maps\mp\_teleport2::main();

thread sr\api\_map::createSpawn((0,-321,-436),90);
thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_speedrun::createSecretWays("Secret Way;");
thread sr\api\_speedrun::createTeleporter((258.271, -124.821, -495.875), 50, 20, (464, 3208, -580), 90, "freeze", "yellow", "secret_0");

thread secretend();
thread door();
thread lift();
thread lift2();
thread trap4();

}

secretend()
{
 
    trig = getent("teleport","targetname");
    tele = getent("secret_finish", "targetname");
       
        for(;;)
        {
        trig waittill("trigger", player);
        player thread sr\api\_speedrun::finishWay("secret_0");						
		player setorigin(tele.origin);				
        }
}

door()
{
door = getent("door", "targetname");

wait 0.1;

door delete();

}

lift()
{
lift=getent("lift","targetname");

wait 0.1;

lift movez (-370,0.1);

}

lift2()
{
lift2=getent("lift2","targetname");

wait 0.1;

lift2 moveY(50,0.1);

}

trap4()
{
trap4a = getent("trap4", "targetname");
trap4b = getent("trap4b", "targetname");

wait 0.1;
trap4a moveY(1400,0.1);
trap4b moveX(-135,0.1);
wait 0.4;
trap4a moveX(135,0.1);

}