/// @description Var init

#macro PERFECTINDC_ALPHABETS_WIDTH 418
#macro PERFECTINDC_SPRITE_ALPHABETS_WIDTH 418
#macro PERFECTINDC_SPRITE_ALPHABETS_HEIGHT 75
#macro PERFECTINDC_ALPHABETS_X 54
#macro PERFECTINDC_ALPHABETS_Y 53
#macro PERFECTINDC_DEBUG true

#macro PERFECTINDC_ANIMATION_SPEED 0.3
#macro PERFECTINDC_ANIMATION_LASTTIME 400       // in ms

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

animTargetScore = 0;
animTargetScaleMul = 1.0;
animTargetAlphaMul = alphaMul;

animCurvChan = animcurve_get_channel(curvShadowFade, "curve1");

function _hitit() {
    scaleMul = 1.3;
    bloomAlpha = 1.0;
    nowTime = 0;
}
