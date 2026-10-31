main()
{
	visionSetNaked("mp_aion_sanctum", 0);

	setExpFog(1682.2251, 34265.7422, 0.4575, 0.7203, 0.9455, 0);

	thread iz_sounds();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
}

iz_sounds()
{
	ambientPlay("iz_0_kingdom_of_light_ori", 2);
	iz_emitter("iz_1_ambient_waterfall_2", (63730.8867, 54477.9570, 20671.9160), 0, 2.0027);
	iz_emitter("iz_2_ambient_waterfall_2", (71012.9062, 61731.4688, 12101.1211), 0, 2.0027);
	iz_emitter("iz_3_ambient_water_flow_1", (57575.7227, 58081.4492, 22196.9492), 0, 2.9896);
	iz_emitter("iz_2_ambient_waterfall_2", (64201.8164, 60366.1211, 15288.2930), 0, 2.0027);
	iz_emitter("iz_4_ambient_water_flow_1", (58834.9883, 57927.7305, 22468.4473), 0, 2.9896);
	iz_emitter("iz_5_ambient_waterfall_2", (73636.1094, 62588.4883, 20620.0762), 0, 2.0027);
	iz_emitter("iz_6_ambient_waterfall_2", (53802.1875, 57902.3242, 22484.2227), 0, 2.0027);
	iz_emitter("iz_7_ambient_fx_11", (73559.4688, 58779.5938, 31867.6426), 0, 7.0722);
	iz_emitter("iz_8_ambient_water_flow_2", (71066.4141, 61718.1172, 20203.6172), 0, 1.8924);
	iz_emitter("iz_9_ambient_bird_flying", (53871.1094, 59524.8281, 22526.3750), 0, 14);
	iz_emitter("iz_10_ambient_waterfall_2", (71467.1016, 59492.7031, 21311.8262), 0, 2.0027);
	iz_emitter("iz_11_ambient_gem", (54412.1172, 59540.2148, 22811.3750), 0, 3.9966);
	iz_emitter("iz_2_ambient_waterfall_2", (72995.9688, 62524.6250, 18111.8770), 0, 2.0027);
	iz_emitter("iz_12_ambient_water_flow", (56695.6836, 60927.1094, 22039.6992), 0, 2.9896);
	iz_emitter("iz_7_ambient_fx_11", (73060.7578, 59914.0039, 31867.6426), 0, 7.0722);
	iz_emitter("iz_13_ambient_water_flow_1", (54185.7227, 59532.0625, 22434.6562), 0, 2.9896);
	iz_emitter("iz_14_ambient_waterfall_2", (74080.5391, 67485.4141, 21322.8984), 0, 2.0027);
	iz_emitter("iz_15_ambient_waterfall_1", (54823.1094, 72716.8281, 5743.1147), 0, 3.1057);
	iz_emitter("iz_16_ambient_fx_11", (57610.8438, 65595.1875, 22842.0273), 0, 7.0722);
	iz_emitter("iz_2_ambient_waterfall_2", (71429.8516, 57845.3398, 15786.2812), 0, 2.0027);
	iz_emitter("iz_17_ambient_waterfall_1", (55318.5430, 73360.8438, 4183.2124), 0, 3.1057);
	iz_emitter("iz_18_ambient_waterfall_2", (71410.3203, 57895.6992, 10918.9639), 0, 2.0027);
	iz_emitter("iz_19_ambient_waterfall_1", (64463.4492, 66461.9297, 17215.3438), 0, 3.1057);
	iz_emitter("iz_20_ambient_sign_weapon", (62955.0117, 58085.2656, 22638.7383), 0, 1.6184);
	iz_emitter("iz_21_ambient_fx_9", (73507.1562, 59487.5117, 30184.1953), 0, 2.5194);
	iz_emitter("iz_16_ambient_fx_11", (57169.4648, 66023.8672, 22841.4531), 0, 7.0722);
	iz_emitter("iz_22_ambient_water_flow_1", (58195.2344, 60017.0430, 22425.2402), 0, 2.9896);
	iz_emitter("iz_23_ambient_water_flow_1", (54488.2695, 59532.4414, 22504.5156), 0, 2.9896);
	iz_emitter("iz_24_ambient_water_founta", (65525.1211, 53689.8008, 22032.3203), 0, 2.0480);
	iz_emitter("iz_15_ambient_waterfall_1", (71408.6328, 59586.3086, 18683.7539), 0, 3.1057);
	iz_emitter("iz_25_ambient_sign_post", (57573.7656, 56340.2109, 22604.1465), 0, 1.6631);
	iz_emitter("iz_15_ambient_waterfall_1", (60679.4141, 53379.0859, 19006.5137), 0, 3.1057);
	iz_emitter("iz_2_ambient_waterfall_2", (64469.5234, 66456.4219, 10394.6455), 0, 2.0027);
	iz_emitter("iz_2_ambient_waterfall_2", (63679.0664, 54193.3672, 11369.3330), 0, 2.0027);
	iz_emitter("iz_16_ambient_fx_11", (55650.4336, 64079.0820, 22841.4531), 0, 7.0722);
	iz_emitter("iz_26_ambient_waterfall_1", (65495.9844, 53716.0234, 21557.2227), 0, 3.1057);
	iz_emitter("iz_19_ambient_waterfall_1", (63895.3828, 54385.7188, 13989.1650), 0, 3.1057);
	iz_emitter("iz_27_ambient_water_flow", (57526.5625, 60792.5312, 22366.4434), 0, 2.9896);
	iz_emitter("iz_28_ambient_water_flow", (57659.5703, 60091.1250, 22121.8066), 0, 2.9896);
	iz_emitter("iz_29_ambient_water_flow_1", (64331.8984, 66497.3047, 19164.8633), 0, 2.9896);
	iz_emitter("iz_2_ambient_waterfall_2", (74030.1641, 67511.4531, 16878.7695), 0, 2.0027);
	iz_emitter("iz_21_ambient_fx_9", (73490.2656, 59441.6719, 28783.8613), 0, 2.5194);
	iz_emitter("iz_30_ambient_waterfall_2", (64138.2422, 66600.2109, 19811.9531), 0, 2.0027);
	iz_emitter("iz_4_ambient_water_flow_1", (58795.0820, 61067.0977, 22441.8535), 0, 2.9896);
	iz_emitter("iz_31_ambient_fx_1", (63875.8398, 59567.1406, 22607.9082), 0, 3.6978);
	iz_emitter("iz_32_ambient_waterfall_1", (70979.0469, 61759.0195, 19799.9512), 0, 3.1057);
	iz_emitter("iz_33_ambient_fx_9", (73492.8906, 59521.5469, 24664.4688), 0, 2.5194);
	iz_emitter("iz_34_ambient_abgate", (51738.9102, 59530.7852, 22425.4980), 0, 6.9989);
	iz_emitter("iz_15_ambient_waterfall_1", (63807.1680, 54526.2656, 19006.5137), 0, 3.1057);
	iz_emitter("iz_35_ambient_water_flow_1", (58456.5352, 60616.5820, 22441.8535), 0, 2.9896);
	iz_emitter("iz_35_ambient_water_flow_1", (58420.0117, 58539.0703, 22468.4473), 0, 2.9896);
	iz_emitter("iz_18_ambient_waterfall_2", (54977.3164, 72839.3438, 4167.5020), 0, 2.0027);
	iz_emitter("iz_16_ambient_fx_11", (55010.6250, 64715.2734, 22860.4199), 0, 7.0722);
	iz_emitter("iz_2_ambient_waterfall_2", (71341.5625, 59478.6562, 15991.7754), 0, 2.0027);
	iz_emitter("iz_16_ambient_fx_11", (56626.4609, 66309.3750, 22843.3926), 0, 7.0722);
	iz_emitter("iz_19_ambient_waterfall_1", (60790.3086, 53503.0430, 13989.1650), 0, 3.1057);
	iz_emitter("iz_36_ambient_metal_cycle", (54652.8633, 59529.8633, 22751.3398), 0, 4.2835);
	iz_emitter("iz_10_ambient_waterfall_2", (71583.1797, 61443.4102, 21275.1523), 0, 2.0027);
	iz_emitter("iz_5_ambient_waterfall_2", (71798.6875, 57958.7539, 21297.3320), 0, 2.0027);
	iz_emitter("iz_37_ambient_waterfall_2", (60873.3906, 52905.9258, 21421.5254), 0, 2.0027);
	iz_emitter("iz_38_ambient_gem", (68227.5391, 59584.9805, 23139.2812), 0, 3.9966);
	iz_emitter("iz_7_ambient_fx_11", (73912.7344, 59687.8594, 31867.6426), 0, 7.0722);
	iz_emitter("iz_19_ambient_waterfall_1", (72899.9531, 62463.1211, 16834.9707), 0, 3.1057);
	iz_emitter("iz_9_ambient_bird_flying", (61878.7930, 59512.2930, 22708.2988), 0, 14);
	iz_emitter("iz_7_ambient_fx_11", (73064.6406, 59095.7383, 31867.6426), 0, 7.0722);
	iz_emitter("iz_19_ambient_waterfall_1", (64588.6914, 66578.1016, 12299.5986), 0, 3.1057);
	iz_emitter("iz_18_ambient_waterfall_2", (55279.7383, 73651.3438, 1548.0519), 0, 2.0027);
	iz_emitter("iz_19_ambient_waterfall_1", (60735.7852, 53361.1445, 16628.0234), 0, 3.1057);
	iz_emitter("iz_2_ambient_waterfall_2", (63887.8555, 54471.7383, 16628.0234), 0, 2.0027);
	iz_emitter("iz_39_ambient_fx_weapon", (63845.8125, 59902.8555, 22643.2305), 0, 5.9954);
	iz_emitter("iz_19_ambient_waterfall_1", (71043.0547, 61786.8086, 15030.7725), 0, 3.1057);
	iz_emitter("iz_19_ambient_waterfall_1", (71454.0234, 57918.1797, 18538.4863), 0, 3.1057);
	iz_emitter("iz_2_ambient_waterfall_2", (64132.3594, 60325.5117, 11112.7168), 0, 2.0027);
	iz_emitter("iz_40_ambient_waterfall_2", (60434.8945, 54218.3438, 21836.1680), 0, 2.0027);
	iz_emitter("iz_41_ambient_record", (58019.1953, 62905.1680, 22621.4121), 0, 4.5616);
	iz_emitter("iz_19_ambient_waterfall_1", (71296.5234, 59481.4453, 13016.8555), 0, 3.1057);
	iz_emitter("iz_2_ambient_waterfall_2", (71177.6406, 61688.1719, 17948.1816), 0, 2.0027);
	iz_emitter("iz_15_ambient_waterfall_1", (64056.3008, 60337.2930, 17104.5059), 0, 3.1057);
	iz_emitter("iz_42_ambient_water_flow_2", (60014.8984, 52578.7266, 21525.0039), 0, 1.8924);
	iz_emitter("iz_43_ambient_sign", (58059.2188, 62971.2148, 22626.1035), 0, 2.8750);
	iz_emitter("iz_34_ambient_abgate", (71334.1719, 83649.6953, 20911.6055), 0, 6.9989);
	iz_emitter("iz_7_ambient_fx_11", (73875.8594, 59354.4766, 31867.6426), 0, 7.0722);
	iz_emitter("iz_15_ambient_waterfall_1", (74015.1953, 67573.8906, 19008.1797), 0, 3.1057);
	iz_emitter("iz_6_ambient_waterfall_2", (53794.9805, 61092.2852, 22539.5117), 0, 2.0027);
	iz_emitter("iz_19_ambient_waterfall_1", (74044.3281, 67547.2109, 14239.7471), 0, 3.1057);
	iz_emitter("iz_20_ambient_sign_weapon", (62957.2656, 60929.6016, 22620.5840), 0, 1.6184);
	iz_emitter("iz_19_ambient_waterfall_1", (63956.9180, 60399.3086, 13420.0957), 0, 3.1057);
	iz_emitter("iz_2_ambient_waterfall_2", (72939.2500, 62621.7383, 13188.4131), 0, 2.0027);
	iz_emitter("iz_7_ambient_fx_11", (73537.4141, 60097.8828, 31867.6426), 0, 7.0722);
	iz_emitter("iz_19_ambient_waterfall_1", (71460.2188, 57880.0625, 13008.9131), 0, 3.1057);
	iz_emitter("iz_44_ambient_fx_2", (63874.6367, 59548.0508, 22607.9082), 0, 5.5554);
	iz_emitter("iz_21_ambient_fx_9", (73456.2266, 59495.4805, 25932.4141), 0, 2.5194);
	iz_emitter("iz_28_ambient_water_flow", (57690.9727, 58880.8359, 22105), 0, 2.9896);
	iz_emitter("iz_22_ambient_water_flow_1", (58187.1797, 59015.3555, 22437.9297), 0, 2.9896);
	iz_emitter("iz_2_ambient_waterfall_2", (64481.7500, 66540.7578, 14848.7051), 0, 2.0027);
	iz_emitter("iz_2_ambient_waterfall_2", (60819.9336, 53439.4961, 11369.3330), 0, 2.0027);
}

iz_emitter(alias, origin, interval, length)
{
	ent = spawn("script_origin", origin);
	if (interval <= 0)
		ent playLoopSound(alias);
	else
		ent thread iz_emitter_random(alias, interval, length);
}

// One play at a time: copies started over one another ran out the
// engine's 32 voices, and the sounds that lost theirs restarted.
iz_emitter_random(alias, interval, length)
{
	for (;;)
	{
		wait(randomFloatRange(interval * 0.25, interval));
		self playSound(alias);
		wait(length);
	}
}
