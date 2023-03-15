
draw_circle(x, y, 5, 0);
CleanLine(resor_to_x(0.5 - markLayout.lineLength/2), y, 
    resor_to_x(0.5 + markLayout.lineLength/2), y)
    .Thickness(markLayout.thickness)
    .Blend2(markLayout.color[0], 1, markLayout.color[1], 1)
    .Cap("none", "round")
    .Draw();
    
CleanCapsule(markLayout.padLeft - markLayout.width, y-markLayout.height/2,
    markLayout.padLeft, y+markLayout.height/2, false)
    .Blend(markLayout.color[0], 1)
    .Draw();

scribble(markName, markName+"mark")
    .starting_format("fPopins", c_dkgrey)
    .scale_to_box(markLayout.width, markLayout.height)
    .align(fa_right, fa_middle)
    .draw(markLayout.padLeft, y);