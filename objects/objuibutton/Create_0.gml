
scriElement = scribble("[sprMsdfNotoSans][scale, 1.5]"+i18n_get(content))
    .starting_format("fDynamix16", c_white)
    .transform(scale, scale)
    .align(fa_left, fa_top);
scriHeight = scriElement.get_height();

gradAlpha = 0;
animTargetGradAlpha = 0;
animSpeed = 0.2;
shadowDistance = 3;

eventFunc = function () {
    announcement_play("按钮 "+content+" 被按下了 lol");
}