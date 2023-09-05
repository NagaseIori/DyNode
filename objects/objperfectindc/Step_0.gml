/// @description Update perfect indic

scaleMul = lerp_a(scaleMul, animTargetScaleMul, PERFECTINDC_ANIMATION_SPEED);

nowTime += delta_time / 1000;

// Perfect Indicator Fade Out

    if(nowTime < lastTime) {
        alpha = lerp_a(alpha, 1.0, 0.4);
    }
    else if(nowTime < lastTime + PERFECTINDC_ANIMATION_LASTTIME) {
        alpha = animcurve_channel_evaluate(animCurvChan, (nowTime-lastTime) / PERFECTINDC_ANIMATION_LASTTIME);
    }
    else {
        alpha = 0;
    }

// Bloom Fade Out

    if(nowTime < lastTimeBloom) {
        bloomAlpha = lerp_a(bloomAlpha, 1.0, 0.4);
    }
    else if(nowTime < lastTimeBloom + PERFECTINDC_ANIMATION_LASTTIME) {
        bloomAlpha = animcurve_channel_evaluate(animCurvChan, (nowTime-lastTimeBloom) / PERFECTINDC_ANIMATION_LASTTIME);
    }
    else {
        bloomAlpha = 0;
    }

if(objMain.hideScoreboard && !(editor_get_editmode() == 5))
    animTargetAlphaMul = 0;
else
    animTargetAlphaMul = 1;

alphaMul = lerp_a(alphaMul, animTargetAlphaMul, PERFECTINDC_ANIMATION_SPEED);
nowTime = min(nowTime, 99999999);

if(debug_mode && PERFECTINDC_DEBUG) {
    alpha = 1;
    alphaMul = 1;
}