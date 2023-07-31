
function InputManager() constructor {
    #macro INPUT_GROUP_DEFAULT_NAME "default"
    #macro INPUT_MOUSE_HOLD_THRESHOLD 300 // Time Threshold to judge if a mouse press is a hold
    #macro INPUT_MOUSE_DOUBLE_CLICK_THRESHOLD 500
    
    // In-functions
    
    static _ioclear = function () {
        last_mouse_x = 0;
        last_mouse_y = 0;
        
        mouseButtons = [mb_left, mb_right];
        mouseButtonCount = array_length(mouseButtons);
        lastMousePressedPos = [];
        for(var i=0; i<mouseButtonCount; i++)
            lastMousePressedPos[i] = [0, 0];
        mouseHoldTime = array_create(mouseButtonCount, 0);
        mouseClick = array_create(mouseButtonCount, -1);
        
        mouseHoldDistanceThreshold = 20;
        mouseHoldClear = true;
    }
    
    static _pressclear = function () {
        array_fill(mouseClick, -1, 0, 2);
        array_fill(mouseClickDouble, -1, 0, 2);
        array_fill(mouseClickLastTime, 0, 0, 2);
    }
    
    static _holdclear = function () {
        _pressclear();
        mouseHoldClear = true;
        array_fill(mouseHoldTime, 0, 0, 2);
    }
    
    last_mouse_x = 0;
    last_mouse_y = 0;
    
    mouseButtons = [mb_left, mb_right];
    mouseButtonCount = array_length(mouseButtons);
    lastMousePressedPos = [];
    for(var i=0; i<mouseButtonCount; i++)
        lastMousePressedPos[i] = [0, 0];
    mouseHoldTime = array_create(mouseButtonCount, 0);
    mouseClick = array_create(mouseButtonCount, -1);
    mouseClickDouble = array_create(mouseButtonCount, -1);
        // -1 = no input; 0 = not sure if is click (pressing); 1 = is click
    mouseClickLastTime = array_create(mouseButtonCount, 0);
    
    mouseHoldDistanceThreshold = 20;
            // Distance Threshold to judge if a mouse press is a drag (also hold)
    mouseHoldClear = true;
            // Whethere to clear the state of mouse hold
    
    
    // For Input Reset
    windowNFocusTime = 0;
    windowNFocusTimeThreshold = 500;
    
    // For Input Group
    inputGroup = "default";     // used for changing a code block's input group
    checkGroup = "default";     // the focusing group
    
    static step = function () {
        windowNFocusTime = delta_time / 1000;

        if(windowNFocusTime > windowNFocusTimeThreshold) {
            io_clear_diag();
            
            _ioclear();
            
            show_debug_message_safe("IO Cleared.");
        }
        
        last_mouse_x = mouse_x;
        last_mouse_y = mouse_y;
        
        for(var i=0; i<mouseButtonCount; i++) {
            var _nbut = mouseButtons[i];
            if(mouseClick[i] == 1) {
                mouseClick[i] = -1;
            }
            if(mouseClickDouble[i] == 1) {
                mouseClickDouble[i] = -1;
            }
            if(mouse_check_button_pressed(_nbut)) {
                lastMousePressedPos[i][0] = mouse_x;
                lastMousePressedPos[i][1] = mouse_y;
                mouseClick[i] = 0;
            }
                
            
            if(mouse_check_button_released(_nbut) && !mouseHoldClear && mouseClick[i] == 0) {
                var clicking = !(mouseHoldTime[i] > INPUT_MOUSE_HOLD_THRESHOLD)
                if(clicking) {
                    var double_clicking = get_timer() - mouseClickLastTime[i] < 
                            INPUT_MOUSE_DOUBLE_CLICK_THRESHOLD * 1000;
                    if(!double_clicking) {
                        mouseClickLastTime[i] = get_timer();
                        // show_debug_message($"Set timer {mouseClickLastTime[i]}");
                        mouseClick[i] = 1;
                    }
                    else {
                        mouseClick[i] = 1;
                        mouseClickDouble[i] = 1;
                        mouseClickLastTime[i] = 0;
                    }
                }
                else {
                    mouseClick[i] = -1;
                }
            }
            else if(mouseHoldClear) mouseClick[i] = -1;
            
            if(mouse_check_button(_nbut) && !mouseHoldClear) {
                mouseHoldTime[i] += delta_time / 1000;
                if(point_distance(mouse_x, mouse_y, lastMousePressedPos[i][0], lastMousePressedPos[i][1]) 
                    > mouseHoldDistanceThreshold)
                    mouseHoldTime[i] = 1000000;
            }
            else {
                mouseHoldTime[i] = 0;
            }
        }
        
        if(!mouse_check_button(mb_left) && !mouse_check_button(mb_right))
            mouseHoldClear = false;
    }
}


// Get mouse's delta x from last frame
function mouse_get_delta_x() {
    return mouse_x - global.__InputManager.last_mouse_x;
}
function mouse_get_delta_y() {
    return mouse_y - global.__InputManager.last_mouse_y;
}

// Get mouse's delta x from last pressed mb_left frame
function mouse_get_delta_last_x_l() {
    return mouse_x - global.__InputManager.lastMousePressedPos[0][0];
}
function mouse_get_delta_last_y_l() {
    return mouse_y - global.__InputManager.lastMousePressedPos[0][1];
}

function mouse_get_delta_last_x_r() {
    return mouse_x - global.__InputManager.lastMousePressedPos[1][0];
}
function mouse_get_delta_last_y_r() {
    return mouse_y - global.__InputManager.lastMousePressedPos[1][1];
}

function mouse_get_last_pos(button) {
    return global.__InputManager.lastMousePressedPos[button];
}

function mouse_inbound(x1, y1, x2, y2) {
    return pos_inbound(mouse_x, mouse_y, x1, y1, x2, y2);
}
function mouse_square_inbound(x, y, a) {
    return pos_inbound(mouse_x, mouse_y, x-a/2, y-a/2, x+a/2, y+a/2);
}
function mouse_inbound_last_l(x1, y1, x2, y2) {
    var _nx = global.__InputManager.lastMousePressedPos[0][0];
    var _ny = global.__InputManager.lastMousePressedPos[0][1];
    return pos_inbound(_nx, _ny, x1, y1, x2, y2);
}
function mouse_square_inbound_last_l(x, y, a) {
    var _nx = global.__InputManager.lastMousePressedPos[0][0];
    var _ny = global.__InputManager.lastMousePressedPos[0][1];
    return pos_inbound(_nx, _ny, x-a/2, y-a/2, x+a/2, y+a/2);
}

function mouse_clear_hold() {
    global.__InputManager._holdclear();
}

function mouse_ishold_l() {
    return global.__InputManager.mouseHoldTime[0] > INPUT_MOUSE_HOLD_THRESHOLD;
}
function mouse_isclick_l() {
    return global.__InputManager.mouseClick[0] > 0;
}
function mouse_ishold_r() {
    return global.__InputManager.mouseHoldTime[1] > INPUT_MOUSE_HOLD_THRESHOLD;
}
function mouse_isclick_r() {
    return global.__InputManager.mouseClick[1] > 0;
}
function mouse_isclick_double(button) {
    return global.__InputManager.mouseClickDouble[button] > 0;
}
function mouse_clear_click() {
    global.__InputManager._pressclear();
}

function ctrl_ishold() {
    return keyboard_check_direct(vk_control);
}
function alt_ishold() {
    return keyboard_check_direct(vk_alt);
}
function shift_ishold() {
    return keyboard_check_direct(vk_shift);
}
function nofunkey_ishold() {
    return !(ctrl_ishold()) && !(alt_ishold()) && !(shift_ishold());
}
function keycheck_ctrl(key) {
    return ctrl_ishold() && keyboard_check(key);
}
function keycheck_down_ctrl(key) {
    return ctrl_ishold() && keyboard_check_pressed(key);
}

function keycheck(key) {
    return nofunkey_ishold() && keyboard_check(key);
}
function keycheck_down(key) {
    return nofunkey_ishold() && keyboard_check_pressed(key);
}
function keycheck_up(key) {
    return keyboard_check_released(key);
}
function wheelcheck_up() {
    return mouse_wheel_up() && nofunkey_ishold();
}
function wheelcheck_down() {
    return mouse_wheel_down() && nofunkey_ishold();
}
function wheelcheck_up_ctrl() {
    return mouse_wheel_up() && ctrl_ishold();
}
function wheelcheck_down_ctrl() {
    return mouse_wheel_down() && ctrl_ishold();
}

function input_group_set(group = INPUT_GROUP_DEFAULT_NAME) {
    global.__InputManager.inputGroup = group;
}
function input_group_reset() {
    global.__InputManager.inputGroup = INPUT_GROUP_DEFAULT_NAME;
}
function input_check_group_set(group = INPUT_GROUP_DEFAULT_NAME) {
    global.__InputManager.checkGroup = group;
}
function input_check_group_reset() {
    global.__InputManager.checkGroup = INPUT_GROUP_DEFAULT_NAME;
}
function input_group_validate(input_group = global.__InputManager.inputGroup) {
    return input_group == global.__InputManager.checkGroup;
}