/// @description Update perfect indic

scaleMul = lerp_a(scaleMul, animTargetScaleMul, animSpeed);
bloomAlpha = lerp_a(bloomAlpha, animTargetBloomAlpha, animSpeed);

nowTime += delta_time / 1000;
if(nowTime < lastTime) {
    alpha = lerp_a(alpha, 1.0, 0.4);
}
else if(nowTime < lastTime + animLastTime) {
    alpha = animcurve_channel_evaluate(animCurvChan, (nowTime-lastTime) / animLastTime);
}
else {
    alpha = 0;
}