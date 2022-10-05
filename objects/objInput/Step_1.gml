/// @description Update Input

windowNFocusTime = delta_time / 1000;

if(windowNFocusTime > windowNFocusTimeThreshold) {
    io_clear_diag();
    
    _ioclear();
    
    show_debug_message("IO Cleared.");
}

last_mouse_x = mouse_x;
last_mouse_y = mouse_y;

for(var i=0; i<mouseButtonCount; i++) {
    var _nbut = mouseButtons[i];
    if(mouseClick[i] == 1) mouseClick[i] = -1;
    if(mouse_check_button_pressed(_nbut)) {
        lastMousePressedPos[i][0] = mouse_x;
        lastMousePressedPos[i][1] = mouse_y;
        mouseClick[i] = 0;
    }
        
    
    if(mouse_check_button_released(_nbut) && !mouseHoldClear && mouseClick[i] == 0) {
        mouseClick[i] = !mouse_ishold_l();
    }
    else if(mouseHoldClear) mouseClick[i] = -1;
    
    if(mouse_check_button(_nbut) && !mouseHoldClear) {
        mouseHoldTime[i] += delta_time / 1000;
        if(point_distance(mouse_x, mouse_y, lastMousePressedPos[i][0], lastMousePressedPos[i][1]) > mouseHoldDistanceThreshold)
            mouseHoldTime[i] = 1000000;
    }
    else {
        mouseHoldTime[i] = 0;
    }
}

mouseHoldClear = false;
