/// @description Update Notes' States

if(instance_exists(editorSelectSingleTarget) && !editorSelectSingleOccupied)
    with(editorSelectSingleTarget) {
        state = stateSelected;
        state();
    }