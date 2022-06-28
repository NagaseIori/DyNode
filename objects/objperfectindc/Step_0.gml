/// @description Update perfect indic

scaleMul = lerp_a(scaleMul, animTargetScaleMul, animSpeed);

nowTime += delta_time / 1000;

// Perfect Indicator Fade Out

    if(nowTime < lastTime) {
        alpha = lerp_a(alpha, 1.0, 0.4);
    }
    else if(nowTime < lastTime + animLastTime) {
        alpha = animcurve_channel_evaluate(animCurvChan, (nowTime-lastTime) / animLastTime);
    }
    else {
        alpha = 0;
    }

// Bloom Fade Out

    if(nowTime < lastTimeBloom) {
        bloomAlpha = lerp_a(bloomAlpha, 1.0, 0.4);
    }
    else if(nowTime < lastTimeBloom + animLastTime) {
        bloomAlpha = animcurve_channel_evaluate(animCurvChan, (nowTime-lastTimeBloom) / animLastTime);
    }
    else {
        bloomAlpha = 0;
    }

if(objMain.hideScoreboard)
    animTargetAlphaMul = 0;
else
    animTargetAlphaMul = 1;

alphaMul = lerp_a(alphaMul, animTargetAlphaMul, animSpeed);