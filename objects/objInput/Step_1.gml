/// @description Update Input

windowNFocusTime = delta_time / 1000;

if(windowNFocusTime > windowNFocusTimeThreshold) {
    io_clear();
    
    last_mouse_x = 0;
    last_mouse_y = 0;
    
    last_mouse_pressedl_x = 0;
    last_mouse_pressedl_y = 0;
    
    mouseHoldThreshold = 125;
    mouseHoldDistanceThreshold = 20;
    mouseHoldTimeL = 0;
    mouseHoldClear = false;
    mouseClickL = false;
}

last_mouse_x = mouse_x;
last_mouse_y = mouse_y;

if(mouse_check_button_pressed(mb_left)) {
    last_mouse_pressedl_x = mouse_x;
    last_mouse_pressedl_y = mouse_y;
}


if(mouse_check_button_released(mb_left) && !mouseHoldClear) {
    mouseClickL = !mouse_ishold_l();
}
else mouseClickL = false;

if(mouse_check_button(mb_left) && !mouseHoldClear) {
    mouseHoldTimeL += delta_time / 1000;
    if(point_distance(mouse_x, mouse_y, last_mouse_pressedl_x, last_mouse_pressedl_y) > mouseHoldDistanceThreshold)
        mouseHoldTimeL = 1000000;
}
else {
    mouseHoldTimeL = 0;
}

mouseHoldClear = false;
