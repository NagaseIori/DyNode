/// @description Clear Tags & Update Editor

editorSelectSingleTarget = -999;
editorSelectSingleTargetInbound = -999;
editorSelectOccupied = false;
editorSelectDragOccupied = false;
editorSelectInbound = false;
editorHighlightLine = false;

editorSelectCount = 0;
with(objNote) {
    var _hl = false;
    if(state == stateSelected) {
        objEditor.editorSelectCount ++;
        objEditor.editorSelectInbound |= _mouse_inbound_check() || _mouse_inbound_check(1);
        objEditor.editorSelectOccupied = 1;
        objEditor.editorSelectDragOccupied |= isDragging;
        if(isDragging) _hl = true;
    }
    else if(state == stateAttach || state == stateAttachSub || state == stateDrop || state == stateDropSub) {
        _hl = true;
    }
    
    // Update Highlight Lines
    if(_hl && objEditor.editorHighlightLineEnabled) {
        objEditor.editorHighlightLine = true;
        objEditor.editorHighlightTime = time;
        objEditor.editorHighlightPosition = position;
        objEditor.editorHighlightSide = side;
        if(state == stateAttachSub || state == stateDropSub) {
            objEditor.editorHighlightTime = sinst.time;
        }
    }
}

editorSelectMultiple = editorSelectCount > 1;

#region Input Checks

    var _attach_reset_request = false, _attach_sync_request = false;
    
    if(keycheck_down(vk_f10))
        timing_point_load_from_osz();
    if(keycheck_down(ord("Z")))
        editorGridYEnabled = !editorGridYEnabled;
    if(keycheck_down(ord("X")))
        editorGridXEnabled = !editorGridXEnabled;
    if(keycheck_down(ord("H")))
        editorHighlightLineEnabled = !editorHighlightLineEnabled;
    editorGridWidthEnabled = !ctrl_ishold();
    
    // Editor Side Switch
    editorSide += keycheck_down(vk_up);
    if(keycheck_down(vk_up)) {
        _attach_sync_request = true;
        if(editorMode == 5)
            editorMode = 4;
    }
    if(editorSide == 3) editorSide = 0;
    
    // Editor Mode Switch
    for(var i=1; i<=5; i++)
        if(keycheck_down(ord(string(i)))) {
            if(editorMode != i)
                _attach_reset_request = true;
            editorMode = i;
        }

    // Sync or Destroy attached instance
    if(instance_exists(editorNoteAttaching)) {
        if(_attach_reset_request)
            instance_destroy(editorNoteAttaching);
        if(_attach_sync_request)
            editorNoteAttaching.side = editorSide;
    }
   

    switch editorMode {
        case 1:
            if(!instance_exists(editorNoteAttaching))
                editorNoteAttaching = note_build_attach(0, editorSide, editorDefaultWidth);
            break;
        case 2:
            if(!instance_exists(editorNoteAttaching))
                editorNoteAttaching = note_build_attach(1, editorSide, editorDefaultWidth);
            break;
        case 3:
            if(!instance_exists(editorNoteAttaching))
                editorNoteAttaching = note_build_attach(2, editorSide, editorDefaultWidth);
            break;
            
        case 4:
        default:
            break;
    }

#endregion