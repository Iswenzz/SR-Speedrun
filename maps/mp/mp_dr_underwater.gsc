main()
{
maps\mp\_teleport2::main();

thread speedrun\_way_name::create_spawn((0,-321,-436),90);
thread speedrun\_way_name::create_normal_way("Normal Way;");
thread speedrun\_way_name::create_secret_way("Secret Way;");
thread speedrun\_way_name::create_tp((258.271, -124.821, -495.875), 50, 20, (464, 3208, -580), 90, "freeze", "yellow", "s0");

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
        player thread speedrun\_way_name::finish_way("s0");						
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