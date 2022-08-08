/// @description Update Notes' States

if(editorMode == 4) {
    // If the note being selected selectable
    var _selectable = instance_exists(editorSelectSingleTarget) && !keycheck_down(vk_up) && !editorSelectInbound;
    // Detect mouse's drag to enable selecting area
    if(!instance_exists(editorSelectSingleTarget) && !editorSelectArea 
        && mouse_ishold_l() && !editorSelectInbound && !editorSelectDragOccupied && !editorSelectSingleTargetInbound) {
            editorSelectArea = true;
            if(!ctrl_ishold()) {
                editorSelectResetRequest = true;
            }
        }
    if(editorSelectDragOccupied)
        editorSelectArea = false;
    
    // If necessary reset all selected notes
    if((_selectable && !ctrl_ishold()) || keycheck_down(vk_up)) { 
        editorSelectResetRequest = true;
    }
    if(mouse_isclick_l() && !editorSelectInbound && !_selectable) {
        editorSelectResetRequest = true;
    }
    
    if(editorSelectResetRequest) {
        // For wheel width adjust undo
        if(editorWidthAdjustTime < editorWidthAdjustTimeThreshold) {
            editorWidthAdjustTime = 1000;
            with(objNote) if(state == stateSelected) {
                operation_step_add(OPERATION_TYPE.MOVE, origProp, get_prop());
            }
        }
        
        with(objNote) {
            if(state == stateSelected) {
                state = stateNormal;
                state();
            }
        }
        editorSelectResetRequest = false;
    }
    
    // Select a note
    if(_selectable)
        with(editorSelectSingleTarget) {
            state = stateSelected;
            state();
        }
    
    // Selecting Area part
    if(editorSelectArea) {
        
        editorSelectAreaPosition = [
            objInput.last_mouse_pressedl_x,
            objInput.last_mouse_pressedl_y,
            mouse_x,
            mouse_y
            ];
        
        var _pos = editorSelectAreaPosition;
        
        if(!mouse_ishold_l()) {
            editorSelectArea = false;
            
            with(objNote) {
                if(side == editor_get_editside() && noteType != 3 && 
                    (state == stateNormal || state == stateSelected) && 
                    pos_inbound(x, y, _pos[0], _pos[1], _pos[2], _pos[3])) {
                        state = (state == stateSelected ? stateNormal : stateSelected);
                        state();
                    }
            }
        }
        
    }
}

// Note's array update & sort
if(editorNoteSortRequest) {
    note_sort_all();
    editorNoteSortRequest = false;
}

// Operation stack flush
if(array_length(operationStackStep)) {
    operation_step_flush(operationStackStep);
    operationStackStep = [];
}