/// @description Animation runs

gradAlpha = lerp_a(gradAlpha, animTargetGradAlpha, animSpeed);

if(gradAlpha<0.01) gradAlpha = 0;