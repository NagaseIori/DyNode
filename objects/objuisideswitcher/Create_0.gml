/// @description Vars init

alpha = 0;
animTargetAlpha = 1;
gradAlpha = [0, 0, 0, 0];
animTargetGradAlpha = [0, 0, 0, 0];
animSpeed = 0.2;
shadowDistance = 3;

sideButtonWidth = 100;
upButtonPadding = 10
choosing = 1;
side = [1, 0, 2, 3];

bgSurf = get_blur_shapesurf(function () {
    CleanRectangle(x - sideButtonWidth * 1.7, y - 30, x + sideButtonWidth * 1.7, y + 30)
        .Blend(c_white, 1.0)
        .Rounding(10)
        .Draw();
    
    CleanRectangle(x - sideButtonWidth * 0.5, y - 30*3 - upButtonPadding, x + sideButtonWidth * 0.5, y - 30 - upButtonPadding)
        .Blend(c_white, 1.0)
        .Rounding(10)
        .Draw();
})