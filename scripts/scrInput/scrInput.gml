

// Get mouse's delta x from last frame
function mouse_get_delta_x() {
    return mouse_x - objInput.last_mouse_x;
}
function mouse_get_delta_y() {
    return mouse_y - objInput.last_mouse_y;
}

// Get mouse's delta x from last pressed mb_left frame
function mouse_get_delta_last_x_l() {
    return mouse_x - objInput.last_mouse_pressedl_x;
}
function mouse_get_delta_last_y_l() {
    return mouse_y - objInput.last_mouse_pressedl_y;
}

function mouse_inbound(x1, y1, x2, y2) {
    return pos_inbound(mouse_x, mouse_y, x1, y1, x2, y2);
}
function mouse_square_inbound(x, y, a) {
    return pos_inbound(mouse_x, mouse_y, x-a/2, y-a/2, x+a/2, y+a/2);
}
function mouse_inbound_last_l(x1, y1, x2, y2) {
    var _nx = objInput.last_mouse_pressedl_x;
    var _ny = objInput.last_mouse_pressedl_y;
    return pos_inbound(_nx, _ny, x1, y1, x2, y2);
}
function mouse_square_inbound_last_l(x, y, a) {
    var _nx = objInput.last_mouse_pressedl_x;
    var _ny = objInput.last_mouse_pressedl_y;
    return pos_inbound(_nx, _ny, x-a/2, y-a/2, x+a/2, y+a/2);
}

function mouse_ishold_l() {
    return objInput.mouseHoldTimeL > objInput.mouseHoldThreshold;
}

function ctrl_ishold() {
    return keyboard_check_direct(vk_control);
}
function nofunkey_ishold() {
    return !(ctrl_ishold());
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