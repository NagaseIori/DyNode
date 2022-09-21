
/*
    Needed variables created:
    str, lastTime
*/

element = scribble(cjk_prefix() + str)
	.wrap(0.7 * global.resolutionW, -1, true)
	.align(fa_right, fa_bottom)
	.transform(0.8, 0.8);
	
	
image_alpha = 0;
animTargetAlpha = 1;

shiftInX = -50;
shiftTime = 500;
shiftCurv = animcurve_get_channel(curvShiftIn, "curve1");
timer = 0;
targetY = 0;
nowShiftY = 0;