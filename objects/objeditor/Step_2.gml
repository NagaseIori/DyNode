/// @description Update Notes' States

if(editorMode == 4) {
    // If the note being selected selectable
    var _selectable = instance_exists(editorSelectSingleTarget) && !keyboard_check_pressed(vk_up) && !editorSelectInbound;
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
    if((_selectable && !ctrl_ishold()) || keyboard_check_pressed(vk_up)) { 
        editorSelectResetRequest = true;
    }
    if(mouse_isclick_l() && !editorSelectInbound) {
        editorSelectResetRequest = true;
    }
    
    if(editorSelectResetRequest) {
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
                    state == stateNormal && 
                    pos_inbound(x, y, _pos[0], _pos[1], _pos[2], _pos[3])) {
                        state = stateSelected;
                        state();
                    }
            }
        }
        
    }
}