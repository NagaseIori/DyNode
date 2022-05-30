
// In-Variables

visible = false;
animSpeed = 0.07;
animState = 1.0;
animTarget = 0.0;
animTargetX = 0.8;
animTargetY = 0.9;
animCurvChan = animcurve_get_channel(curvShadowFade, "curve1");
animTime = room_speed*0.5;
animLast = 0;

originalWidth = sprite_get_width(sprite_index);
nowWidth = 1;
extraWidth = 250;

nowScaleX = 1;