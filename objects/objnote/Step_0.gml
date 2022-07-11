
var _vec2 = noteprop_to_xy(position, time, side);
x = _vec2[0]; y = _vec2[1];
if(state == stateOut && image_alpha < EPS)
    drawVisible = false;
else
    drawVisible = true;

if(_outroom_check(x, y)) {
	nodeAlpha = 0;
	infoAlpha = 0;
}

if(drawVisible || nodeAlpha>EPS || infoAlpha>EPS || image_alpha>EPS) {
    image_alpha = lerp_a(image_alpha, animTargetA,
        animSpeed * (objMain.nowPlaying ? objMain.musicSpeed * animPlaySpeedMul : 1));
    lastAlpha = lerp_a(lastAlpha, animTargetLstA,
        animSpeed * (objMain.nowPlaying ? objMain.musicSpeed * animPlaySpeedMul : 1));
    
    nodeAlpha = lerp_a(nodeAlpha, animTargetNodeA, animSpeed);
    infoAlpha = lerp_a(infoAlpha, animTargetInfoA, animSpeed);
    
    _prop_init();
    
    // Update Mixer's Position
    if(side > 0) {
        var _nside = side-1, _noff = time, _nx = y, _nid = id;
        
        with(objMain) {
            if(mixerNextNote[_nside] == -1 || _noff < mixerNextNote[_nside].time) {
                mixerNextNote[_nside] = _nid;
                mixerNextX[_nside] = _nx;
            }
        }
    }
    
    // Update Highlight Line's Position
    if(objEditor.editorHighlightLine) {
    	if(state == stateSelected && isDragging || state == stateAttach || state == stateAttachSub || state == stateDrop || state == stateDropSub) {
    		objEditor.editorHighlightTime = time;
            objEditor.editorHighlightPosition = position;
            objEditor.editorHighlightSide = side;
            if(state == stateAttachSub || state == stateDropSub) {
                objEditor.editorHighlightTime = sinst.time;
            }
    	}
    }
}



if(drawVisible)
    state();
else if(stateString == "OUT") {   // stateMachine is slow --- in VM
    if(time + lastTime> objMain.nowTime && !_outbound_check(x, y, side)) {
        drawVisible = true;
        // In Some situations no need for fading in
        if(keycheck(ord("A")) || keycheck(ord("D")) || 
            objMain.topBarMousePressed ||
            (side == 0 && objMain.nowPlaying)) {
            image_alpha = 1;
            animTargetA = 1;
            state = stateNormal;
        }
        else 
            state = stateIn;
        state();
    }
}

// Add selection blend

if(state == stateSelected)
    image_blend = selBlendColor;
else
    image_blend = c_white;