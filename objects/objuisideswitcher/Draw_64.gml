
var _col = theme_get().color;
var _cont = ["L", "D", "R", "L & R"];

// if(!surface_exists(bgSurf)) {
//     bgSurf = get_blur_shapesurf(function () {
//         CleanRectangle(x - sideButtonWidth * 1.7, y - 30, x + sideButtonWidth * 1.7, y + 30)
//             .Blend(c_white, 1.0)
//             .Border(0, c_white, 1.0)
//             .Rounding(10)
//             .Draw();
//     });
// }

// draw_set_alpha(alpha);
// draw_surface_ext(bgSurf, 0, 0, 0, 0, 0, c_grey, 1.0);
// draw_surface(bgSurf, 0, 0);
CleanRectangle(x - sideButtonWidth * 1.7, y - 30, x + sideButtonWidth * 1.7, y + 30)
    .Blend(c_black, 0.5 * alpha)
    .Rounding(10)
    .Draw();

CleanRectangle(x - sideButtonWidth * 0.7, y - 30*3 - upButtonPadding, x + sideButtonWidth * 0.7, y - 30 - upButtonPadding)
.Blend(c_black, 0.5 * alpha)
    .Rounding(10)
    .Draw();

for(var i=0; i<3; i++) {
    scribble(_cont[i])
        .starting_format("fDynamix20", c_white)
        .gradient(_col, gradAlpha[i])
        .msdf_shadow(_col, gradAlpha[i]*0.3, 0, gradAlpha[i]*shadowDistance)
        .align(fa_middle, fa_center)
        .blend(c_white, alpha)
        .draw(x + (i-1) * sideButtonWidth, y);
}

scribble(_cont[3])
    .starting_format("fDynamix20", c_white)
    .gradient(c_red, gradAlpha[i])
    .msdf_shadow(c_red, gradAlpha[i]*0.3, 0, gradAlpha[i]*shadowDistance)
    .align(fa_middle, fa_center)
    .blend(c_white, alpha)
    .draw(x, y - 60 - upButtonPadding);

draw_set_alpha(1);

surface_free_f(bgSurf);