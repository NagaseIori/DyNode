/// @description Update Notes' States

if(instance_exists(editorSelectSingleTarget) && !editorSelectOccupied)
    with(editorSelectSingleTarget) {
        state = stateSelected;
        state();
    }