/// @description Vars init

gradAlpha = [0, 0, 0];
animTargetGradAlpha = [0, 0, 0];
animSpeed = 0.2;
shadowDistance = 3;

sideButtonWidth = 60;
choosing = 1;
side = [1, 0, 2];

// In-function

_fade_in = function () {
    animTargetGradAlpha = 1;
}

_fade_out = function () {
    animTargetGradAlpha = 0;
}