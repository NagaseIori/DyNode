/// @description Vars init

gradAlpha = 0;
animTargetGradAlpha = 0;
animSpeed = 0.2;
shadowDistance = 3;
gradMin = 0.05;

// In-function

_fade_in = function () {
    animTargetGradAlpha = 1;
}

_fade_out = function () {
    animTargetGradAlpha = 0;
}