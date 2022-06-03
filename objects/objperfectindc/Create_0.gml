/// @description Var init

nowTime = 9999;
lastTime = 1000; // ms

scale = 1.0;
scaleMul = 1.0;

alpha = 0.0;
alphaMul = 1.0;
bloomAlpha = 0.0;

animSpeed = 0.2;
animTargetScore = 0;
animTargetScaleMul = 1.0;
animTargetBloomAlpha = 0.0;
animTargetAlphaMul = alphaMul;

animCurvChan = animcurve_get_channel(curvShadowFade, "curve1");
animLastTime = 400; // ms

_hitit = function () {
    scaleMul = 1.2;
    bloomAlpha = 1.0;
    nowTime = 0;
}
