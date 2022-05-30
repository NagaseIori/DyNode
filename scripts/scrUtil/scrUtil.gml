

function note_pos_to_x(_pos, _side) {
    if(_side == 0) {
        return global.resolutionW/2 + (_pos-2.5)*300;
    }
    else {
        return global.resolutionH/2 + (2.5-_pos)*150;
    }
}