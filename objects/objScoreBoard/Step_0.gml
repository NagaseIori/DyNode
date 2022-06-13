/// @description Update scoreboard

if(int64(nowScore) <= scoreLimit || objMain.hideScoreboard)
    animTargetAlpha = 0;
else
    animTargetAlpha = 1;

nowScore = lerp_a(nowScore, animTargetScore, animSpeed);
scaleMul = lerp_a(scaleMul, animTargetScaleMul, animSpeed);
alpha = lerp_a(alpha, animTargetAlpha, animSpeed);

nowString = string_format(abs(nowScore), preZero, 0);
nowString = string_replace_all(nowString, " ", "0");