
draw_self();

// draw_set_color(c_red);
// draw_circle(x, y, 5, false)

if(debug_mode) {
    scribble(stateString).starting_format("fDynamix20", c_white)
    .align(fa_left, fa_middle)
    .draw(round(x + pWidth/2), y);
}