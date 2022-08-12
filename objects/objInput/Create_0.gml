/// @description Variables-Init

depth = -100000;

// In-functions

_ioclear = function() {
    last_mouse_x = 0;
    last_mouse_y = 0;
    
    mouseButtons = [mb_left, mb_right];
    mouseButtonCount = array_length(mouseButtons);
    lastMousePressedPos = array_create(mouseButtonCount, 0);
    mouseHoldTime = array_create(mouseButtonCount, 0);
    mouseClick = array_create(mouseButtonCount, 0);
    
    mouseHoldThreshold = 125;
    mouseHoldDistanceThreshold = 20;
    mouseHoldClear = false;
}

last_mouse_x = 0;
last_mouse_y = 0;

mouseButtons = [mb_left, mb_right];
mouseButtonCount = array_length(mouseButtons);
lastMousePressedPos = array_create(mouseButtonCount, 0);
mouseHoldTime = array_create(mouseButtonCount, 0);
mouseClick = array_create(mouseButtonCount, 0);

mouseHoldThreshold = 125;
mouseHoldDistanceThreshold = 20;
mouseHoldClear = false;

// For Input Reset
windowNFocusTime = 0;
windowNFocusTimeThreshold = 500;