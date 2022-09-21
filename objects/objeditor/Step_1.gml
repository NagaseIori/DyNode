/// @description Clear Tags & Update Editor

// Clear selection tags and then update
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
    else if((state == stateAttach || state == stateDrop) && id == editor_get_note_attaching_center()) {
        _hl = true;
    }
    else if(state == stateAttachSub || state == stateDropSub) {
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
    
    if(keycheck_down(ord("Z"))) {
        editorGridYEnabled = !editorGridYEnabled;
        announcement_adjust("时间方向网格吸附", editorGridYEnabled);
    }
        
    if(keycheck_down(ord("X"))) {
        editorGridXEnabled = !editorGridXEnabled;
        announcement_adjust("位置方向网格吸附", editorGridXEnabled);
    }
        
    if(keycheck_down(ord("H"))) {
        editorHighlightLineEnabled = !editorHighlightLineEnabled;
        announcement_adjust("时间/位置高亮显示", editorHighlightLineEnabled);
    }
    
    if(keycheck_down(ord("Y"))) {
        timing_point_create(true);
    }
    
    if(keycheck_down_ctrl(ord("Z"))) {
        operation_undo();
    }
    if(keycheck_down_ctrl(ord("Y"))) {
        operation_redo();
    }
        
    editorGridWidthEnabled = !ctrl_ishold();
    
    // Editor Side Switch
    if(keycheck_down(vk_up))
        editor_set_editside((editor_get_editside() + 1) % 3);
    if(editorSide != editorLastSide) {
        _attach_sync_request = true;
        with(objNote) {
            if(state == stateSelected)
                state = stateNormal;
        }
    }
    
    // Editor Mode Switch
    for(var i=1; i<=5; i++)
        if(keycheck_down(ord(string(i)))) {
            if(editorMode != i)
                _attach_reset_request = true;
            editorMode = i;
        }
    
    if(keycheck_down_ctrl(ord("V")) && array_length(copyStack) && editorSelectCount == 0 && editorMode != 0) {
        editorModeBeforeCopy = editorMode;
        editorMode = 0; // Paste Mode
        _attach_reset_request = true;
    }
    if(keycheck_down(vk_escape)) {
        if(editorMode == 0) {
            editorMode = editorModeBeforeCopy;
            _attach_reset_request = true;
        }
        else
			game_end_confirm();
    }
    
    // Copies Mirror
    if(editorMode == 0) {
        if(keycheck_down(ord("M"))) {
            for(var i=0, l=array_length(copyStack); i<l; i++)
                copyStack[i].position = 5 - copyStack[i].position;
            _attach_reset_request = true;
        }
        if(keycheck_down_ctrl(ord("1"))) {
            for(var i=0, l=array_length(copyStack); i<l; i++)
                copyStack[i].noteType = 0;
            _attach_reset_request = true;
        }
        if(keycheck_down_ctrl(ord("2"))) {
            for(var i=0, l=array_length(copyStack); i<l; i++)
                copyStack[i].noteType = 1;
            _attach_reset_request = true;
        }
    }

    // Sync or Destroy attached instance
    if(editorNoteAttaching != -1) {
        if(!instance_exists(editorNoteAttaching[0]))
            editorNoteAttaching = -1;
        if(_attach_reset_request) {
            var i=0, l=array_length(editorNoteAttaching);
            for(; i<l; i++)
                instance_destroy(editorNoteAttaching[i]);
            editorNoteAttaching = -1;
            if(editorMode != 0) editorNoteAttachingCenter = 0;
        }
        if(_attach_sync_request) {
            var i=0, l=array_length(editorNoteAttaching);
            for(; i<l; i++)
                editorNoteAttaching[i].side = editorSide;
        }
    }
    
    editorLastSide = editorSide;
   

    switch editorMode {
        case 0:
            if(editorNoteAttaching == -1) {
                editorNoteAttaching = [];
                for(var i=0, l=array_length(copyStack); i<l; i++) {
                    var _str = copyStack[i];
                    array_push(editorNoteAttaching, note_build_attach(
                        _str.noteType,
                        editorSide,
                        _str.width,
                        _str.position,
                        _str.time,
                        _str.lastTime
                        ));
                }
            }
            
            var _chg = keycheck_down_ctrl(vk_right) - keycheck_down_ctrl(vk_left);
            var _len = array_length(editorNoteAttaching);
            editorNoteAttachingCenter = (editorNoteAttachingCenter + _chg + _len) % _len; 
            
            break;
        case 1:
        case 2:
        case 3:
            if(editorNoteAttaching == -1) {
                editorNoteAttaching = [note_build_attach(editorMode - 1, editorSide, editorDefaultWidth)];
                editorNoteAttachingCenter = 0;
            }
            break;
            
        case 4:
        default:
            break;
    }
    
    // Copy
    if((keycheck_down_ctrl(ord("C")) || keycheck_down_ctrl(ord("X"))) && editorSelectCount > 0) {
        var _cnt = 0;
        copyStack = [];
        with(objNote) {
            if(state == stateSelected && noteType <= 2) {
                array_push(objEditor.copyStack, get_prop());
                _cnt ++;
                if(keycheck_down_ctrl(ord("X"))) {
                    recordRequest = true;
                    instance_destroy();
                }
            }
        }
        array_sort_f(copyStack, function (_a, _b) { return _a.time == _b.time? _a.position < _b.position : _a.time < _b.time; });
        
        if(keycheck_down_ctrl(ord("X")))
            announcement_play("剪切音符共 " + string(_cnt) + " 处");
        else
            announcement_play("复制音符共 " + string(_cnt) + " 处");
    }

#endregion