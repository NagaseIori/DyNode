
if(keyboard_check_pressed(ord("T"))) {
    var _tp = timingPoints[array_length(timingPoints) - 1];
    timing_point_add(objMain.nowTime, _tp.beatLength, _tp.meter);
}

var _modchg = keyboard_check_pressed(ord("V")) - keyboard_check_pressed(ord("C"));
beatlineNowMode += _modchg;
beatlineNowMode = clamp(beatlineNowMode, 0, array_length(beatlineModes)-1);

animBeatlineTargetAlpha[0] += 0.7 * keyboard_check_pressed(vk_down);
animBeatlineTargetAlpha[1] += 0.7 * keyboard_check_pressed(vk_left);
animBeatlineTargetAlpha[2] += 0.7 * keyboard_check_pressed(vk_right);
for(var i=0; i<3; i++) {
    if(animBeatlineTargetAlpha[i] > 1.4)
        animBeatlineTargetAlpha[i] = 0;
    beatlineAlpha[i] = lerp_a(beatlineAlpha[i], min(animBeatlineTargetAlpha[i], 1), animSpeed);
}
    

for(var i=0; i<=16; i++)
    beatlineEnabled[i] = 0;
var l = array_length(beatlineModes[beatlineNowMode]);
for(var i=0; i<l; i++)
    beatlineEnabled[beatlineModes[beatlineNowMode][i]] = 1;