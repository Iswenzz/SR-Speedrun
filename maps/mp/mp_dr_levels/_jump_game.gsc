main()
{
// thread game_start();
// thread jumper_sniper();
// thread sniper_weapon();
// thread acti_sniper();
// thread red_jumper_1();
// thread red_acti_1();
// thread green_jumper_1();
// thread green_acti_1();
// thread blue_jumper_1();
// thread blue_acti_1();
// thread purple_jumper_1();
// thread purple_acti_1();
// thread light_jumper_1();
// thread light_acti_1();
//thread gold_jumper_1();
//thread gold_acti_1();
//thread violet_jumper_1();
//thread violet_acti_1();
////thread brown_jumper_1();
//thread brown_acti_1();
//thread silver_jumper_1();
//thread silver_acti_1();
///thread red_jumper_2();
//thread red_acti_2();
//thread green_jumper_2();
///thread green_acti_2();
//thread blue_jumper_2();
//thread blue_acti_2();
//thread purple_jumper_2();
//thread purple_acti_2();
//thread light_jumper_2();
//thread light_acti_2();
//thread gold_jumper_2();
////thread gold_acti_2();
//thread violet_jumper_2();
/////thread violet_acti_2();
/////thread brown_jumper_2();
//thread brown_acti_2();
//thread silver_jumper_2();
//thread silver_acti_2();
//thread red_jumper_3();
//thread red_acti_3();
//thread green_jumper_3();
//thread green_acti_3();
//thread blue_jumper_3();
//thread blue_acti_3();
//thread purple_jumper_3();
///thread purple_acti_3();
//thread light_jumper_3();
//thread light_acti_3();
//thread gold_jumper_3();
//thread gold_acti_3();
//thread violet_jumper_3();
///thread violet_acti_3();
//thread brown_jumper_3();
//thread brown_acti_3();
//thread silver_jumper_3();
//thread silver_acti_3();
//thread second_stage_jumper();
//thread second_stage_acti();
//thread third_stage_jumper();
//thread third_stage_acti();
//thread acti_weapon();
}

//Good Luck Understanding all of this :D

jumper_sniper()
{
trig = getEnt("jump_sniper","targetname");
door = getEnt("jump_sniper_door","targetname");

trig waittill("trigger", user);
trig delete();
door moveZ(-96,1);
door waittill("movedone");
door delete();
}

acti_sniper()
{
trig = getEnt("acti_sniper_trig","targetname");
door = getEnt("acti_sniper_door","targetname");

trig waittill("trigger", user);
trig delete();
door moveZ(-96,1);
door waittill("movedone");
door delete();
}

sniper_weapon()
{
weapon = getEnt("sniper_weapon","targetname");
trig = getEnt("take_sniper","targetname");

trig waittill("trigger", user);
trig delete();
user TakeAllWeapons();
weapon delete();
user GiveWeapon("remington700_mp");
wait 0.01;
user SwitchToWeapon("remington700_mp");
wait 0.1;
}

acti_weapon()
{
weapon = getEnt("acti_sniper_weapon","targetname");
trig = getEnt("take_acti_sniper","targetname");

trig waittill("trigger", user);
trig delete();
user TakeAllWeapons();
weapon delete();
user GiveWeapon("remington700_mp");
wait 0.01;
user SwitchToWeapon("remington700_mp");
wait 0.1;
}

game_start()
{
game_start = getEnt("game_start","targetname");
button = getEnt("button_jumper_1","targetname");
walls = getEnt("wall_jump","targetname");
clip = getEnt("clip_game_start","targetname");
red = getEnt("red_brush_jumper_1","targetname");
red_trig = getEnt("red_block_jumper_1","targetname");
red_acti = getEnt("red_brush_acti_1","targetname");
red_acti_trig = getEnt("red_block_acti_1","targetname");
green = getEnt("green_brush_jumper_1","targetname");
green_trig = getEnt("green_block_jumper_1","targetname");
green_acti = getEnt("green_brush_acti_1","targetname");
green_acti_trig = getEnt("green_block_acti_1","targetname");
blue = getEnt("blue_brush_jumper_1","targetname");
blue_trig = getEnt("blue_block_jumper_1","targetname");
blue_acti = getEnt("blue_brush_acti_1","targetname");
blue_acti_trig = getEnt("blue_block_acti_1","targetname");
purple = getEnt("purple_brush_jumper_1","targetname");
purple_trig = getEnt("purple_block_jumper_1","targetname");
purple_acti = getEnt("purple_brush_acti_1","targetname");
purple_acti_trig = getEnt("purple_block_acti_1","targetname");
light = getEnt("light_brush_jumper_1","targetname");
light_trig = getEnt("light_block_jumper_1","targetname");
light_acti = getEnt("light_brush_acti_1","targetname");
light_acti_trig = getEnt("light_block_acti_1","targetname");
gold = getEnt("gold_brush_jumper_1","targetname");
gold_trig = getEnt("gold_block_jumper_1","targetname");
gold_acti = getEnt("gold_brush_acti_1","targetname");
gold_acti_trig = getEnt("gold_block_acti_1","targetname");
violet = getEnt("violet_brush_jumper_1","targetname");
violet_trig = getEnt("violet_block_jumper_1","targetname");
violet_acti = getEnt("violet_brush_acti_1","targetname");
violet_acti_trig = getEnt("violet_block_acti_1","targetname");
brown = getEnt("brown_brush_jumper_1","targetname");
brown_trig = getEnt("brown_block_jumper_1","targetname");
brown_acti = getEnt("brown_brush_acti_1","targetname");
brown_acti_trig = getEnt("brown_block_acti_1","targetname");
silver = getEnt("silver_brush_jumper_1","targetname");
silver_trig = getEnt("silver_block_jumper_1","targetname");
silver_acti = getEnt("silver_brush_acti_1","targetname");
silver_acti_trig = getEnt("silver_block_acti_1","targetname");

red_trig enablelinkto();
red_trig linkto(red);

red_acti_trig enablelinkto();
red_acti_trig linkto(red_acti);

green_trig enablelinkto();
green_trig linkto(green);

green_acti_trig enablelinkto();
green_acti_trig linkto(green_acti);

blue_trig enablelinkto();
blue_trig linkto(blue);

blue_acti_trig enablelinkto();
blue_acti_trig linkto(blue_acti);

purple_trig enablelinkto();
purple_trig linkto(purple);

purple_acti_trig enablelinkto();
purple_acti_trig linkto(purple_acti);

light_trig enablelinkto();
light_trig linkto(light);

light_acti_trig enablelinkto();
light_acti_trig linkto(light_acti);

gold_trig enablelinkto();
gold_trig linkto(gold);

gold_acti_trig enablelinkto();
gold_acti_trig linkto(gold_acti);

violet_trig enablelinkto();
violet_trig linkto(violet);

violet_acti_trig enablelinkto();
violet_acti_trig linkto(violet_acti);

brown_trig enablelinkto();
brown_trig linkto(brown);

brown_acti_trig enablelinkto();
brown_acti_trig linkto(brown_acti);

silver_trig enablelinkto();
silver_trig linkto(silver);

silver_acti_trig enablelinkto();
silver_acti_trig linkto(silver_acti);

game_start waittill("trigger", user);
game_start delete();

button moveZ(-4,2);
button waittill("movedone");
walls moveZ(-160,3);
walls waittill("movedone");
walls delete();

iprintlnbold("^1Wait for all the blocks to come up");
red moveZ(656,0.5);
red_acti moveZ(656,0.5);
wait 1;
green moveZ(656,0.5);
green_acti moveZ(656,0.5);
wait 1;
blue moveZ(656,0.5);
blue_acti moveZ(656,0.5);
wait 1;
purple moveZ(656,0.5);
purple_acti moveZ(656,0.5);
wait 1;
light moveZ(656,0.5);
light_acti moveZ(656,0.5);
wait 1;
gold moveZ(656,0.5);
gold_acti moveZ(656,0.5);
wait 1;
violet moveZ(656,0.5);
violet_acti moveZ(656,0.5);
wait 1;
brown moveZ(656,0.5);
brown_acti moveZ(656,0.5);
wait 1;
silver moveZ(656,0.5);
silver_acti moveZ(656,0.5);
wait 1;
clip delete();
}

red_jumper_1()
{
trig = getEnt("red_block_jumper_1","targetname");
brush = getEnt("red_brush_jumper_1","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}

red_acti_1()
{
trig = getEnt("red_block_acti_1","targetname");
brush = getEnt("red_brush_acti_1","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}

light_jumper_1()
{
trig = getEnt("light_block_jumper_1","targetname");
brush = getEnt("light_brush_jumper_1","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}

light_acti_1()
{
trig = getEnt("light_block_acti_1","targetname");
brush = getEnt("light_brush_acti_1","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}

green_jumper_1()
{
trig = getEnt("green_block_jumper_1","targetname");
brush = getEnt("green_brush_jumper_1","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}

green_acti_1()
{
trig = getEnt("green_block_acti_1","targetname");
brush = getEnt("green_brush_acti_1","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}

blue_jumper_1()
{
trig = getEnt("blue_block_jumper_1","targetname");
brush = getEnt("blue_brush_jumper_1","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}

blue_acti_1()
{
trig = getEnt("blue_block_acti_1","targetname");
brush = getEnt("blue_brush_acti_1","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}

purple_jumper_1()
{
trig = getEnt("purple_block_jumper_1","targetname");
brush = getEnt("purple_brush_jumper_1","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}


purple_acti_1()
{
trig = getEnt("purple_block_acti_1","targetname");
brush = getEnt("purple_brush_acti_1","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}

gold_jumper_1()
{
trig = getEnt("gold_block_jumper_1","targetname");
brush = getEnt("gold_brush_jumper_1","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}


gold_acti_1()
{
trig = getEnt("gold_block_acti_1","targetname");
brush = getEnt("gold_brush_acti_1","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}

violet_jumper_1()
{
trig = getEnt("violet_block_jumper_1","targetname");
brush = getEnt("violet_brush_jumper_1","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}

violet_acti_1()
{
trig = getEnt("violet_block_acti_1","targetname");
brush = getEnt("violet_brush_acti_1","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}

brown_jumper_1()
{
trig = getEnt("brown_block_jumper_1","targetname");
brush = getEnt("brown_brush_jumper_1","targetname");

trig waittill("trigger", who);
trig delete();
brush delete();
}

brown_acti_1()
{
trig = getEnt("brown_block_acti_1","targetname");
brush = getEnt("brown_brush_acti_1","targetname");

trig waittill("trigger", who);
trig delete();
brush delete();
}

silver_jumper_1()
{
trig = getEnt("silver_block_jumper_1","targetname");
brush = getEnt("silver_brush_jumper_1","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}

silver_acti_1()
{
trig = getEnt("silver_block_acti_1","targetname");
brush = getEnt("silver_brush_acti_1","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}

second_stage_jumper()
{
trig = getEnt("switch_jumper_1","targetname");
button = getEnt("button_jumper_2","targetname");
clip = getEnt("second_clip_jumper","targetname");
red = getEnt("red_brush_jumper_2","targetname");
red_trig = getEnt("red_block_jumper_2","targetname");
green = getEnt("green_brush_jumper_2","targetname");
green_trig = getEnt("green_block_jumper_2","targetname");
blue = getEnt("blue_brush_jumper_2","targetname");
blue_trig = getEnt("blue_block_jumper_2","targetname");
purple = getEnt("purple_brush_jumper_2","targetname");
purple_trig = getEnt("purple_block_jumper_2","targetname");
light = getEnt("light_brush_jumper_2","targetname");
light_trig = getEnt("light_block_jumper_2","targetname");
gold = getEnt("gold_brush_jumper_2","targetname");
gold_trig = getEnt("gold_block_jumper_2","targetname");
violet = getEnt("violet_brush_jumper_2","targetname");
violet_trig = getEnt("violet_block_jumper_2","targetname");
brown = getEnt("brown_brush_jumper_2","targetname");
brown_trig = getEnt("brown_block_jumper_2","targetname");
silver = getEnt("silver_brush_jumper_2","targetname");
silver_trig = getEnt("silver_block_jumper_2","targetname");

red_trig enablelinkto();
red_trig linkto(red);

green_trig enablelinkto();
green_trig linkto(green);

blue_trig enablelinkto();
blue_trig linkto(blue);

purple_trig enablelinkto();
purple_trig linkto(purple);

light_trig enablelinkto();
light_trig linkto(light);

gold_trig enablelinkto();
gold_trig linkto(gold);

violet_trig enablelinkto();
violet_trig linkto(violet);

brown_trig enablelinkto();
brown_trig linkto(brown);

silver_trig enablelinkto();
silver_trig linkto(silver);

trig waittill("trigger", user);
trig delete();

button moveZ(-4,2);
button waittill("movedone");
red moveZ(656,0.5);
wait 1;
green moveZ(656,0.5);
wait 1;
blue moveZ(656,0.5);
wait 1;
purple moveZ(656,0.5);
wait 1;
light moveZ(656,0.5);
wait 1;
gold moveZ(656,0.5);
wait 1;
violet moveZ(656,0.5);
wait 1;
brown moveZ(656,0.5);
wait 1;
silver moveZ(656,0.5);
wait 1;
clip delete();
}

second_stage_acti()
{
trig = getEnt("switch_acti_1","targetname");
button = getEnt("button_acti_1","targetname");
clip = getEnt("second_clip_acti","targetname");
red = getEnt("red_brush_acti_2","targetname");
red_trig = getEnt("red_block_acti_2","targetname");
green = getEnt("green_brush_acti_2","targetname");
green_trig = getEnt("green_block_acti_2","targetname");
blue = getEnt("blue_brush_acti_2","targetname");
blue_trig = getEnt("blue_block_acti_2","targetname");
purple = getEnt("purple_brush_acti_2","targetname");
purple_trig = getEnt("purple_block_acti_2","targetname");
light = getEnt("light_brush_acti_2","targetname");
light_trig = getEnt("light_block_acti_2","targetname");
gold = getEnt("gold_brush_acti_2","targetname");
gold_trig = getEnt("gold_block_acti_2","targetname");
violet = getEnt("violet_brush_acti_2","targetname");
violet_trig = getEnt("violet_block_acti_2","targetname");
brown = getEnt("brown_brush_acti_2","targetname");
brown_trig = getEnt("brown_block_acti_2","targetname");
silver = getEnt("silver_brush_acti_2","targetname");
silver_trig = getEnt("silver_block_acti_2","targetname");

red_trig enablelinkto();
red_trig linkto(red);

green_trig enablelinkto();
green_trig linkto(green);

blue_trig enablelinkto();
blue_trig linkto(blue);

purple_trig enablelinkto();
purple_trig linkto(purple);

light_trig enablelinkto();
light_trig linkto(light);

gold_trig enablelinkto();
gold_trig linkto(gold);

violet_trig enablelinkto();
violet_trig linkto(violet);

brown_trig enablelinkto();
brown_trig linkto(brown);

silver_trig enablelinkto();
silver_trig linkto(silver);

trig waittill("trigger", user);
trig delete();

button moveZ(-4,2);
button waittill("movedone");
red moveZ(656,0.5);
wait 1;
green moveZ(656,0.5);
wait 1;
blue moveZ(656,0.5);
wait 1;
purple moveZ(656,0.5);
wait 1;
light moveZ(656,0.5);
wait 1;
gold moveZ(656,0.5);
wait 1;
violet moveZ(656,0.5);
wait 1;
brown moveZ(656,0.5);
wait 1;
silver moveZ(656,0.5);
wait 1;
clip delete();
}

red_jumper_2()
{
trig = getEnt("red_block_jumper_2","targetname");
brush = getEnt("red_brush_jumper_2","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}

red_acti_2()
{
trig = getEnt("red_block_acti_2","targetname");
brush = getEnt("red_brush_acti_2","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}

light_jumper_2()
{
trig = getEnt("light_block_jumper_2","targetname");
brush = getEnt("light_brush_jumper_2","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}

light_acti_2()
{
trig = getEnt("light_block_acti_2","targetname");
brush = getEnt("light_brush_acti_2","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}

green_jumper_2()
{
trig = getEnt("green_block_jumper_2","targetname");
brush = getEnt("green_brush_jumper_2","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}

green_acti_2()
{
trig = getEnt("green_block_acti_2","targetname");
brush = getEnt("green_brush_acti_2","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}

blue_jumper_2()
{
trig = getEnt("blue_block_jumper_2","targetname");
brush = getEnt("blue_brush_jumper_2","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}

blue_acti_2()
{
trig = getEnt("blue_block_acti_2","targetname");
brush = getEnt("blue_brush_acti_2","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}

purple_jumper_2()
{
trig = getEnt("purple_block_jumper_2","targetname");
brush = getEnt("purple_brush_jumper_2","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}


purple_acti_2()
{
trig = getEnt("purple_block_acti_2","targetname");
brush = getEnt("purple_brush_acti_2","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}

gold_jumper_2()
{
trig = getEnt("gold_block_jumper_2","targetname");
brush = getEnt("gold_brush_jumper_2","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}


gold_acti_2()
{
trig = getEnt("gold_block_acti_2","targetname");
brush = getEnt("gold_brush_acti_2","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}

violet_jumper_2()
{
trig = getEnt("violet_block_jumper_2","targetname");
brush = getEnt("violet_brush_jumper_2","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}

violet_acti_2()
{
trig = getEnt("violet_block_acti_2","targetname");
brush = getEnt("violet_brush_acti_2","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}

brown_jumper_2()
{
trig = getEnt("brown_block_jumper_2","targetname");
brush = getEnt("brown_brush_jumper_2","targetname");

trig waittill("trigger", who);
trig delete();
brush delete();
}

brown_acti_2()
{
trig = getEnt("brown_block_acti_2","targetname");
brush = getEnt("brown_brush_acti_2","targetname");

trig waittill("trigger", who);
trig delete();
brush delete();
}

silver_jumper_2()
{
trig = getEnt("silver_block_jumper_2","targetname");
brush = getEnt("silver_brush_jumper_2","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}

silver_acti_2()
{
trig = getEnt("silver_block_acti_2","targetname");
brush = getEnt("silver_brush_acti_2","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 1;
}

third_stage_jumper()
{
trig = getEnt("switch_jumper_2","targetname");
button = getEnt("button_jumper_3","targetname");
clip = getEnt("third_clip_jumper","targetname");
red = getEnt("red_brush_jumper_3","targetname");
red_trig = getEnt("red_block_jumper_3","targetname");
green = getEnt("green_brush_jumper_3","targetname");
green_trig = getEnt("green_block_jumper_3","targetname");
blue = getEnt("blue_brush_jumper_3","targetname");
blue_trig = getEnt("blue_block_jumper_3","targetname");
purple = getEnt("purple_brush_jumper_3","targetname");
purple_trig = getEnt("purple_block_jumper_3","targetname");
light = getEnt("light_brush_jumper_3","targetname");
light_trig = getEnt("light_block_jumper_3","targetname");
gold = getEnt("gold_brush_jumper_3","targetname");
gold_trig = getEnt("gold_block_jumper_3","targetname");
violet = getEnt("violet_brush_jumper_3","targetname");
violet_trig = getEnt("violet_block_jumper_3","targetname");
brown = getEnt("brown_brush_jumper_3","targetname");
brown_trig = getEnt("brown_block_jumper_3","targetname");
silver = getEnt("silver_brush_jumper_3","targetname");
silver_trig = getEnt("silver_block_jumper_3","targetname");

red_trig enablelinkto();
red_trig linkto(red);

green_trig enablelinkto();
green_trig linkto(green);

blue_trig enablelinkto();
blue_trig linkto(blue);

purple_trig enablelinkto();
purple_trig linkto(purple);

light_trig enablelinkto();
light_trig linkto(light);

gold_trig enablelinkto();
gold_trig linkto(gold);

violet_trig enablelinkto();
violet_trig linkto(violet);

brown_trig enablelinkto();
brown_trig linkto(brown);

silver_trig enablelinkto();
silver_trig linkto(silver);

trig waittill("trigger", user);
trig delete();

button moveZ(-4,2);
button waittill("movedone");
red moveZ(656,0.5);
wait 1;
green moveZ(656,0.5);
wait 1;
blue moveZ(656,0.5);
wait 1;
purple moveZ(656,0.5);
wait 1;
light moveZ(656,0.5);
wait 1;
gold moveZ(656,0.5);
wait 1;
violet moveZ(656,0.5);
wait 1;
brown moveZ(656,0.5);
wait 1;
silver moveZ(656,0.5);
wait 1;
clip delete();
}

third_stage_acti()
{
trig = getEnt("switch_acti_2","targetname");
button = getEnt("button_acti_2","targetname");
clip = getEnt("third_clip_acti","targetname");
red = getEnt("red_brush_acti_3","targetname");
red_trig = getEnt("red_block_acti_3","targetname");
green = getEnt("green_brush_acti_3","targetname");
green_trig = getEnt("green_block_acti_3","targetname");
blue = getEnt("blue_brush_acti_3","targetname");
blue_trig = getEnt("blue_block_acti_3","targetname");
purple = getEnt("purple_brush_acti_3","targetname");
purple_trig = getEnt("purple_block_acti_3","targetname");
light = getEnt("light_brush_acti_3","targetname");
light_trig = getEnt("light_block_acti_3","targetname");
gold = getEnt("gold_brush_acti_3","targetname");
gold_trig = getEnt("gold_block_acti_3","targetname");
violet = getEnt("violet_brush_acti_3","targetname");
violet_trig = getEnt("violet_block_acti_3","targetname");
brown = getEnt("brown_brush_acti_3","targetname");
brown_trig = getEnt("brown_block_acti_3","targetname");
silver = getEnt("silver_brush_acti_3","targetname");
silver_trig = getEnt("silver_block_acti_3","targetname");

red_trig enablelinkto();
red_trig linkto(red);

green_trig enablelinkto();
green_trig linkto(green);

blue_trig enablelinkto();
blue_trig linkto(blue);

purple_trig enablelinkto();
purple_trig linkto(purple);

light_trig enablelinkto();
light_trig linkto(light);

gold_trig enablelinkto();
gold_trig linkto(gold);

violet_trig enablelinkto();
violet_trig linkto(violet);

brown_trig enablelinkto();
brown_trig linkto(brown);

silver_trig enablelinkto();
silver_trig linkto(silver);

trig waittill("trigger", user);
trig delete();

button moveZ(-4,2);
button waittill("movedone");
red moveZ(656,0.5);
wait 1;
green moveZ(656,0.5);
wait 1;
blue moveZ(656,0.5);
wait 1;
purple moveZ(656,0.5);
wait 1;
light moveZ(656,0.5);
wait 1;
gold moveZ(656,0.5);
wait 1;
violet moveZ(656,0.5);
wait 1;
brown moveZ(656,0.5);
wait 1;
silver moveZ(656,0.5);
wait 1;
clip delete();
}

red_jumper_3()
{
trig = getEnt("red_block_jumper_3","targetname");
brush = getEnt("red_brush_jumper_3","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}

red_acti_3()
{
trig = getEnt("red_block_acti_3","targetname");
brush = getEnt("red_brush_acti_3","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}

light_jumper_3()
{
trig = getEnt("light_block_jumper_3","targetname");
brush = getEnt("light_brush_jumper_3","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}

light_acti_3()
{
trig = getEnt("light_block_acti_3","targetname");
brush = getEnt("light_brush_acti_3","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}

green_jumper_3()
{
trig = getEnt("green_block_jumper_3","targetname");
brush = getEnt("green_brush_jumper_3","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}

green_acti_3()
{
trig = getEnt("green_block_acti_3","targetname");
brush = getEnt("green_brush_acti_3","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}

blue_jumper_3()
{
trig = getEnt("blue_block_jumper_3","targetname");
brush = getEnt("blue_brush_jumper_3","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}

blue_acti_3()
{
trig = getEnt("blue_block_acti_3","targetname");
brush = getEnt("blue_brush_acti_3","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}

purple_jumper_3()
{
trig = getEnt("purple_block_jumper_3","targetname");
brush = getEnt("purple_brush_jumper_3","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}


purple_acti_3()
{
trig = getEnt("purple_block_acti_3","targetname");
brush = getEnt("purple_brush_acti_3","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}

gold_jumper_3()
{
trig = getEnt("gold_block_jumper_3","targetname");
brush = getEnt("gold_brush_jumper_3","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}


gold_acti_3()
{
trig = getEnt("gold_block_acti_3","targetname");
brush = getEnt("gold_brush_acti_3","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}

violet_jumper_3()
{
trig = getEnt("violet_block_jumper_3","targetname");
brush = getEnt("violet_brush_jumper_3","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}

violet_acti_3()
{
trig = getEnt("violet_block_acti_3","targetname");
brush = getEnt("violet_brush_acti_3","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}

brown_jumper_3()
{
trig = getEnt("brown_block_jumper_3","targetname");
brush = getEnt("brown_brush_jumper_3","targetname");

trig waittill("trigger", who);
trig delete();
brush delete();
}

brown_acti_3()
{
trig = getEnt("brown_block_acti_3","targetname");
brush = getEnt("brown_brush_acti_3","targetname");

trig waittill("trigger", who);
trig delete();
brush delete();
}

silver_jumper_3()
{
trig = getEnt("silver_block_jumper_3","targetname");
brush = getEnt("silver_brush_jumper_3","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}

silver_acti_3()
{
trig = getEnt("silver_block_acti_3","targetname");
brush = getEnt("silver_brush_acti_3","targetname");

trig waittill("trigger", who);
trig delete();
wait 0.5;
brush moveZ(-686,0.5);
wait 0.5;
}

//Sooo.....You still thinking of doing this minigame your self? o.o