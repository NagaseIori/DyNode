/// @description Update Notes' States

if(editorMode == 4) {
    if(!instance_exists(editorSelectSingleTarget) && !editorSelectArea 
        && mouse_ishold_l() && !editorSelectInbound && !editorSelectDragOccupied) {
            editorSelectArea = true;
            if(!ctrl_ishold()) {
                with(objNote) {
                    if(state == stateSelected) {
                        state = stateNormal;
                        state();
                    }
                }
            }
        }
    if(editorSelectDragOccupied)
        editorSelectArea = false;
    
    // Select a note
    if(instance_exists(editorSelectSingleTarget) && (!editorSelectOccupied || ctrl_ishold()) && !keyboard_check_pressed(vk_up))
        with(editorSelectSingleTarget) {
            state = stateSelected;
            state();
        }           
    // If necessary reset all selected notes
    else if((mouse_isclick_l() && !editorSelectInbound) || keyboard_check_pressed(vk_up)) { 
        with(objNote) {
            if(state == stateSelected) {
                state = stateNormal;
                state();
            }
        }
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