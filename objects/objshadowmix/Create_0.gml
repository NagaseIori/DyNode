/// @description 

// Inherit the parent event
event_inherited();

visible = true;

animTime = 250;
animLast = 9999;
image_alpha = 0;

alphaMul = 1;

_hit = function () {
    animLast = 0;
}

depth = -80000000;