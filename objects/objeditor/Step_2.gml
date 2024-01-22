/// @description Update Notes' States

if(editorMode == 4) {
    // If the note being selected selectable
    var _selectable = instance_exists(editorSelectSingleTarget) && !editorSelectInbound;
    // Detect if the mouse is dragging to enable selecting area
    if(!instance_exists(editorSelectSingleTarget) && !editorSelectArea 
        && mouse_ishold_l() && !editorSelectInbound && !editorSelectDragOccupied && !editorSelectSingleTargetInbound) {
            editorSelectArea = true;
            var _pos = mouse_get_last_pos(0);
            editorSelectAreaPosition = xy_to_noteprop(_pos[0], _pos[1], editorSide);
            if(!ctrl_ishold()) {
                editorSelectResetRequest = true;
            }
        }
    if(editorSelectDragOccupied)
        editorSelectArea = false;
    
    // If necessary reset all selected notes
    if(_selectable && !ctrl_ishold()) { 
        editorSelectResetRequest = true;
    }
    if(mouse_isclick_l() && !editorSelectInbound && !_selectable) {
        editorSelectResetRequest = true;
    }
    
    if(editorSelectResetRequest) {
        // For mousewheel width adjust undo
        if(editorWidthAdjustTime < editorWidthAdjustTimeThreshold) {
            editorWidthAdjustTime = editorWidthAdjustTimeThreshold + 1;
            with(objNote) if(state == stateSelected) {
                operation_step_add(OPERATION_TYPE.MOVE, origProp, get_prop());
            }
        }
        
        note_select_reset();
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
        if(!mouse_ishold_l()) {
            editorSelectArea = false;
            
            with(objNote) {
                if(side == editor_get_editside() && 
                    (state == stateNormal || state == stateSelected) && 
                    editor_select_inbound(x, y, side, noteType)) {
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

#region UNDO & REDO Management

// Operation stack flush
if(array_length(operationStackStep)) {
    operation_step_flush(operationStackStep);
    operationStackStep = [];
}

while(operationCount>MAXIMUM_UNDO_STEPS) {
	array_shift(operationStack);
	operationCount --;
	operationPointer --;
}

#endregion