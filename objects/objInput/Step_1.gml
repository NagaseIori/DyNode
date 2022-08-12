/// @description Update Input

windowNFocusTime = delta_time / 1000;

if(windowNFocusTime > windowNFocusTimeThreshold) {
    io_clear_diag();
    
    _ioclear();
}

last_mouse_x = mouse_x;
last_mouse_y = mouse_y;

for(var i=0; i<mouseButtonCount; i++) {
    var _nbut = mouseButtons[i];
    if(mouse_check_button_pressed(mouseButtons[i]))
        lastMousePressedPos[i] = [mouse_x, mouse_y];
    
    if(mouse_check_button_released(_nbut) && !mouseHoldClear) {
        mouseClick[i] = !mouse_ishold_l();
    }
    else mouseClick[i] = false;
    
    if(mouse_check_button(_nbut) && !mouseHoldClear) {
        mouseHoldTime[i] += delta_time / 1000;
        if(point_distance(mouse_x, mouse_y, lastMousePressedPos[i][0], lastMousePressedPos[i][1]) > mouseHoldDistanceThreshold)
            mouseHoldTime[i] = 1000000;
    }
    else {
        mouseHoldTime[i] = 0;
    }
}

// if(mouse_check_button_pressed(mb_left)) {
//     last_mouse_pressedl_x = mouse_x;
//     last_mouse_pressedl_y = mouse_y;
// }


// if(mouse_check_button_released(mb_left) && !mouseHoldClear) {
//     mouseClickL = !mouse_ishold_l();
// }
// else mouseClickL = false;

// if(mouse_check_button(mb_left) && !mouseHoldClear) {
//     mouseHoldTimeL += delta_time / 1000;
//     if(point_distance(mouse_x, mouse_y, last_mouse_pressedl_x, last_mouse_pressedl_y) > mouseHoldDistanceThreshold)
//         mouseHoldTimeL = 1000000;
// }
// else {
//     mouseHoldTimeL = 0;
// }

mouseHoldClear = false;
