
animLast ++;

animState = animcurve_channel_evaluate(animCurvChan, animLast/animTime);
image_xscale = lerp(nowScaleX, nowScaleX * animTargetX, 1-animState);
image_yscale = lerp(1, animTargetY, 1-animState);
image_alpha = lerp(1, 0, 1-animState);

if(image_alpha == 0) instance_destroy();