
// Down Side
if(side == 0) {
    x = note_pos_to_x(position, side);
    y = note_time_to_y(time, side);
    if(state == stateOut && image_alpha == 0)
            visible = false;
    else
        visible = true;
}
// LR Side
else {
    y = note_pos_to_x(position, side);
    x = note_time_to_y(time, side);
    if(state == stateOut && image_alpha == 0)
            visible = false;
    else
        visible = true;
    
    if(visible) {
        var _nside = side-1, _noff = time, _nx = y, _nid = id;
        
        with(objMain) {
            if(mixerNextNote[_nside] == -1 || _noff < mixerNextNote[_nside].time) {
                mixerNextNote[_nside] = _nid;
                mixerNextX[_nside] = _nx;
            }
        }
    }
}



if(visible || image_alpha>0) {
    image_alpha = lerp_a(image_alpha, animTargetA,
        animSpeed * (objMain.nowPlaying ? objMain.musicSpeed : 1));
    lastAlpha = lerp_a(lastAlpha, animTargetLstA,
        animSpeed * (objMain.nowPlaying ? objMain.musicSpeed : 1));
}

if(visible)
    state();
else if(stateString == "OUT") {   // stateMachine is slow --- in VM
    if(time + lastTime > objMain.nowTime && !_outbound_check(x, y, side)) {
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