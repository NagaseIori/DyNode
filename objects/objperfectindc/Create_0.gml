/// @description Var init

#macro PERFECTINDC_ALPHABETS_WIDTH 418
#macro PERFECTINDC_SPRITE_ALPHABETS_WIDTH 418
#macro PERFECTINDC_SPRITE_ALPHABETS_HEIGHT 75
#macro PERFECTINDC_ALPHABETS_X 54
#macro PERFECTINDC_ALPHABETS_Y 53
#macro PERFECTINDC_DEBUG true

nowTime = 9999;
lastTime = 3000; // ms
lastTimeBloom = 100;

scale = 1.0;
scaleMul = 1.0;

sprWidth = sprite_get_width(sprPerfect);
sprHeight = sprite_get_height(sprPerfect);

alpha = 0.0;
alphaMul = 1.0;
bloomAlpha = 0.0;

animSpeed = 0.2;
animTargetScore = 0;
animTargetScaleMul = 1.0;
animTargetAlphaMul = alphaMul;

animCurvChan = animcurve_get_channel(curvShadowFade, "curve1");
animLastTime = 400; // ms

function _hitit() {
    scaleMul = 1.2;
    bloomAlpha = 1.0;
    nowTime = 0;
}
