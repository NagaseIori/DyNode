
var _vec2 = noteprop_to_xy(position, time, side);
x = _vec2[0]; y = _vec2[1];
if(state == stateOut && image_alpha<EPS) {
	drawVisible = false;
}
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
}

state();

// If no longer visible then deactivate self
if(!drawVisible && nodeAlpha<EPS && infoAlpha < EPS && !instance_exists(finst)) {
	if(instance_exists(sinst))
		instance_deactivate_object(sinst);
	instance_deactivate_object(id);
}

// Update Highlight Line's Position
if(objEditor.editorHighlightLine && instance_exists(id)) {
	if(state == stateSelected && isDragging || state == stateAttach || state == stateAttachSub || state == stateDrop || state == stateDropSub) {
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