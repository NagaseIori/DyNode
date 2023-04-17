

// Get mouse's delta x from last frame
function mouse_get_delta_x() {
    return mouse_x - objInput.last_mouse_x;
}
function mouse_get_delta_y() {
    return mouse_y - objInput.last_mouse_y;
}

// Get mouse's delta x from last pressed mb_left frame
function mouse_get_delta_last_x_l() {
    return mouse_x - objInput.lastMousePressedPos[0][0];
}
function mouse_get_delta_last_y_l() {
    return mouse_y - objInput.lastMousePressedPos[0][1];
}

function mouse_get_delta_last_x_r() {
    return mouse_x - objInput.lastMousePressedPos[1][0];
}
function mouse_get_delta_last_y_r() {
    return mouse_y - objInput.lastMousePressedPos[1][1];
}

function mouse_get_last_pos(button) {
    return objInput.lastMousePressedPos[button];
}

function mouse_inbound(x1, y1, x2, y2) {
    return pos_inbound(mouse_x, mouse_y, x1, y1, x2, y2);
}
function mouse_square_inbound(x, y, a) {
    return pos_inbound(mouse_x, mouse_y, x-a/2, y-a/2, x+a/2, y+a/2);
}
function mouse_inbound_last_l(x1, y1, x2, y2) {
    var _nx = objInput.lastMousePressedPos[0][0];
    var _ny = objInput.lastMousePressedPos[0][1];
    return pos_inbound(_nx, _ny, x1, y1, x2, y2);
}
function mouse_square_inbound_last_l(x, y, a) {
    var _nx = objInput.lastMousePressedPos[0][0];
    var _ny = objInput.lastMousePressedPos[0][1];
    return pos_inbound(_nx, _ny, x-a/2, y-a/2, x+a/2, y+a/2);
}

function mouse_clear_hold() {
    objInput._holdclear();
}

function mouse_ishold_l() {
    return objInput.mouseHoldTime[0] > objInput.mouseHoldThreshold;
}
function mouse_isclick_l() {
    return objInput.mouseClick[0] > 0;
}
function mouse_ishold_r() {
    return objInput.mouseHoldTime[1] > objInput.mouseHoldThreshold;
}
function mouse_isclick_r() {
    return objInput.mouseClick[1] > 0;
}
function mouse_clear_click() {
    objInput._pressclear();
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
    objInput.inputGroup = group;
}
function input_group_reset() {
    objInput.inputGroup = INPUT_GROUP_DEFAULT_NAME;
}
function input_check_group_set(group = INPUT_GROUP_DEFAULT_NAME) {
    objInput.checkGroup = group;
}
function input_check_group_reset() {
    objInput.checkGroup = INPUT_GROUP_DEFAULT_NAME;
}
function input_group_validate(input_group = objInput.inputGroup) {
    return input_group == objInput.checkGroup;
}