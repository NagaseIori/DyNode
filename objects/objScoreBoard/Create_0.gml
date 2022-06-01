/// @description Var init

// In-Variables

scale = 0.5;
scaleMul = 1.0;
preZero = 7;
nowScore = 0;
nowString = "";
align = fa_middle;

animSpeed = 0.2;
animTargetScore = 0;
animTargetScaleMul = 1.0;

sprWidth = sprite_get_width(sprNumber)
shorten = 20; // total shorten pixels for each number in lr side

visible = true;

_update_score = function (_scr, _hit = true, _force = false) {
    if(_hit) scaleMul = 1.1;
    animTargetScore = _scr;
    if(_force) nowScore = _scr;
}