/// @description Variables-Init

#macro INPUT_GROUP_DEFAULT_NAME "default"

depth = -100000;

// In-functions

function _ioclear() {
    last_mouse_x = 0;
    last_mouse_y = 0;
    
    mouseButtons = [mb_left, mb_right];
    mouseButtonCount = array_length(mouseButtons);
    lastMousePressedPos = [];
    for(var i=0; i<mouseButtonCount; i++)
        lastMousePressedPos[i] = [0, 0];
    mouseHoldTime = array_create(mouseButtonCount, 0);
    mouseClick = array_create(mouseButtonCount, -1);
    
    mouseHoldThreshold = 125;
    mouseHoldDistanceThreshold = 20;
    mouseHoldClear = true;
}

function _pressclear() {
    array_fill(mouseClick, -1, 0, 2);
}

function _holdclear() {
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
        // -1 = no input; 0 = not sure if is click (pressing); 1 = is click

mouseHoldThreshold = 125;
        // Time Threshold to judge if a mouse press is a hold
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
