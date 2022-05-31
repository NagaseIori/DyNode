
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
}



if(visible || image_alpha>0) {
    pWidth = width * 300 / (side == 0 ? 1:2) - 30 + lFromLeft + rFromRight;
    pWidth = max(pWidth, originalWidth);
    
    image_xscale = pWidth / originalWidth;
    image_alpha = lerp(image_alpha, animTargetA, animSpeed * global.fpsAdjust);
    image_angle = (side == 0 ? 0 : (side == 1 ? 270 : 90));
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