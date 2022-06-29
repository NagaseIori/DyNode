/// @description Update Notes' States

if(instance_exists(editorSelectSingleTarget) && (!editorSelectOccupied || ctrl_ishold()) && !keyboard_check_pressed(vk_up))
    with(editorSelectSingleTarget) {
        state = stateSelected;
        state();
    }

else if(mouse_check_button_pressed(mb_left) || keyboard_check_pressed(vk_up)) {
    var _reset_state = true;
    if(!keyboard_check_pressed(vk_up))
        with(objNote) {
            if(state == stateSelected && _mouse_inbound_check()) {
                _reset_state = false;
            }
        }
    with(objNote) {
        if(state == stateSelected && _reset_state) {
            state = stateNormal;
        }
    }
}