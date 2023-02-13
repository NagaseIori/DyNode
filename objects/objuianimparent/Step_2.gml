/// @description Animation runs

gradAlpha = lerp_a(gradAlpha, animTargetGradAlpha, animSpeed);

if(gradAlpha < gradMin) gradAlpha = 0;