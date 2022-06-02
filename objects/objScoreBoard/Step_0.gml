/// @description Update scoreboard

if(debug_mode) {
    if(keyboard_check(vk_f10))
        _update_score(animTargetScore+1)
    if(keyboard_check(vk_f11))
        _update_score(animTargetScore-1)
}

if(int64(nowScore) <= scoreLimit)
    animTargetAlpha = 0;
else
    animTargetAlpha = 1;

nowScore = lerp_a(nowScore, animTargetScore, animSpeed);
scaleMul = lerp_a(scaleMul, animTargetScaleMul, animSpeed);
alpha = lerp_a(alpha, animTargetAlpha, animSpeed);

nowString = string_format(abs(nowScore), preZero, 0);
nowString = string_replace_all(nowString, " ", "0");