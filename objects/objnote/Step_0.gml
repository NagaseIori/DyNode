_prop_init();

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