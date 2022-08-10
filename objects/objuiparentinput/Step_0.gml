animTargetGradAlpha = mouse_inbound(x, y, x+maxWidth, y+scriHeight*2);
gradAlpha = lerp_a(gradAlpha, animTargetGradAlpha, animSpeed);

if(gradAlpha<0.01) gradAlpha = 0;