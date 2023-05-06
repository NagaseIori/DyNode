_prop_init();

if(state == undefined)
	state = stateOut;

if(state == stateOut && image_alpha<EPS) {
	drawVisible = false;
}
else
    drawVisible = true;

selectInbound = editor_select_is_area() && editor_select_inbound(x, y, side, noteType, side);
selectTolerance = selectInbound || state == stateSelected;

state();
update_prop();

selectUnlock = false;

if(drawVisible || nodeAlpha>EPS || infoAlpha>EPS || image_alpha>EPS) {
	var _factor = 1;
	if(editor_get_editmode() < 5 && objMain.fadeOtherNotes && side != editor_get_editside())
    	_factor = 0.5;
    if(editor_get_editmode() < 5) {
    	image_alpha = lerp_a(image_alpha, animTargetA * _factor,
        	animSpeed * (objMain.nowPlaying ? objMain.musicSpeed * animPlaySpeedMul : 1));
    }
    else {
    	image_alpha = animTargetA;
    }
    lastAlpha = lerp_a(lastAlpha, animTargetLstA * _factor,
        animSpeed * (objMain.nowPlaying ? objMain.musicSpeed * animPlaySpeedMul : 1));
    
    if(keycheck(ord("A")) || keycheck(ord("D")) || 
    	objMain.topBarMousePressed || (side == 0 && objMain.nowPlaying)) {
		image_alpha = animTargetA * _factor;
		lastAlpha = animTargetLstA * _factor;
	}
    
    nodeAlpha = lerp_a(nodeAlpha, animTargetNodeA, animSpeed);
    infoAlpha = lerp_a(infoAlpha, animTargetInfoA, animSpeed);
}

// If no longer visible then deactivate self
if(!drawVisible && nodeAlpha<EPS && infoAlpha < EPS && !instance_exists(finst)) {
	note_deactivate_request(id);
	return;
}
// Else then update the color rectangle
else if(editor_get_editmode() <= 4){
	var _col = c_blue;
    
    animTargetInfoA = 0;
    if(editor_select_is_area()) {
        if(editor_select_inbound(x, y, side, noteType)) {
            _col = 0x28caff;
            animTargetNodeA = 1;
        }
        else {
            animTargetNodeA = 0;
        }
    }
    else {
        if((!objEditor.editorSelectOccupied || ctrl_ishold()) && objEditor.editorSelectSingleTargetInbound == id) {
            animTargetNodeA = 1.0;
            animTargetInfoA = ctrl_ishold()? 1:0;
        }
        else if(objEditor.editorHighlightLine && objEditor.editorHighlightPosition == position &&
            objEditor.editorHighlightSide == side) {
            animTargetNodeA = 1.0;
            animTargetInfoA = ctrl_ishold()? 1:0;
            _col = 0xc2577e;
        }
        else animTargetNodeA = 0;
    }
    if(state == stateSelected) {
    	if(editor_select_is_area() && editor_select_inbound(x, y, side, noteType))
    		_col = scribble_rgb_to_bgr(0xff1744);
    	else 
        	_col = c_white;
        animTargetNodeA = 1.0;
        animTargetInfoA = 1;
    }
	if(state == stateAttach || state == stateAttachSub || state == stateDrop || state == stateDropSub) {
		animTargetNodeA = 0.0;
		animTargetInfoA = 1;
	}
	if((state == stateLast && noteType == 2) || state == stateOut) {
		animTargetNodeA = 0;
		animTargetInfoA = 0;
	}
	
	if(animTargetNodeA > 0)
	    nodeColor = _col;
}

// Update Highlight Line's Position
if(objEditor.editorHighlightLine && instance_exists(id)) {
	if(state == stateSelected && isDragging || state == stateAttachSub || state == stateDropSub
		|| ((state == stateAttach || state == stateDrop) && id == editor_get_note_attaching_center())) {
		objEditor.editorHighlightTime = time;
        objEditor.editorHighlightPosition = position;
        objEditor.editorHighlightSide = side;
        if(state == stateAttachSub || state == stateDropSub) {
            objEditor.editorHighlightTime = sinst.time;
        }
	}
}

// Add selection blend

if(state == stateSelected)
    image_blend = selBlendColor;
else
    image_blend = c_white;