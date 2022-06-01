
// Down Side
if(side == 0) {
    x = note_pos_to_x(position, side);
    y = global.resolutionH
        - (objMain.playbackSpeed * (offset - objMain.nowOffset) + objMain.targetLineBelow);
    if(state == stateOut && image_alpha == 0)
            visible = false;
    else
        visible = true;
}
// LR Side
else {
    y = note_pos_to_x(position, side);
    x = global.resolutionW / 2
        + (side == 1?-1:1) * 
        (global.resolutionW / 2 - 
        (objMain.playbackSpeed * (offset - objMain.nowOffset)) 
        - objMain.targetLineBeside);
    if(state == stateOut && image_alpha == 0)
            visible = false;
    else
        visible = true;
    
    if(visible) {
        var _nside = side-1, _noff = offset, _nx = y, _nid = id;
        
        with(objMain) {
            if(mixerNextNote[_nside] == -1 || _noff < mixerNextNote[_nside].offset) {
                mixerNextNote[_nside] = _nid;
                mixerNextX[_nside] = _nx;
            }
        }
    }
}



if(visible || image_alpha>0) {
    image_alpha = lerp(image_alpha, animTargetA, animSpeed * global.fpsAdjust);
    lastAlpha = lerp(lastAlpha, animTargetLstA, animSpeed * global.fpsAdjust);
}

if(visible)
    state();
else if(stateString == "OUT") {   // stateMachine is slow --- in VM
    if(offset + lastOffset > objMain.nowOffset && !_outbound_check(x, y, side)) {
        // If is using ad to adjust time then speed the things hell up
        if(keyboard_check(ord("A")) || keyboard_check(ord("D"))) {
            image_alpha = 1;
            animTargetA = 1;
            state = stateNormal;
        }
        else 
            state = stateIn;
        state();
        visible = true;
    }
}