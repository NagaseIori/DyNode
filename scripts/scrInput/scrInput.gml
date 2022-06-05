

// Get mouse's delta x from last frame
function mouse_get_delta_x() {
    return mouse_x - objInput.last_mouse_x;
}
function mouse_get_delta_y() {
    return mouse_y - objInput.last_mouse_y;
}

// Get mouse's delta x from last pressed mb_left frame
function mouse_get_delta_lx() {
    return mouse_x - objInput.last_mouse_pressedl_x;
}
function mouse_get_delta_ly() {
    return mouse_y - objInput.last_mouse_pressedl_y;
}

function mouse_inbound(x1, y1, x2, y2) {
    return mouse_x>=x1 && mouse_x <=x2 && mouse_y>=y1 && mouse_y<=y2;
}