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
        objEditor.editorHighlightWidth = width;
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
        announcement_adjust("adjust_grid_y", editorGridYEnabled);
    }
        
    if(keycheck_down(ord("X"))) {
        editorGridXEnabled = !editorGridXEnabled;
        announcement_adjust("adjust_grid_x", editorGridXEnabled);
    }
        
    if(keycheck_down(ord("H"))) {
        editorHighlightLineEnabled = !editorHighlightLineEnabled;
        announcement_adjust("adjust_highlight", editorHighlightLineEnabled);
    }
    
    if(keycheck_down(ord("Y"))) {
        timing_point_create(true);
    }
    
    if(keycheck_down_ctrl(ord("Z"))) {
        operation_undo();
    }
    else if(keycheck_down_ctrl(ord("Y"))) {
        operation_redo();
    }
    operation_synctime_sync();
    
    if(keycheck_down(ord("L"))) {
    	editorDefaultWidthMode ++;
    	editorDefaultWidthMode %= 4;
    	announcement_set("default_width_mode", editorDefaultWidthModeName[editorDefaultWidthMode]);
    	_attach_sync_request = true;
    }
    if(keycheck_down(ord("K"))) {
    	_attach_sync_request = editor_set_default_width_qbox();
    }
    
    if(keycheck_down(ord("J"))) {
    	beatlineStyleCurrent ++;
    	beatlineStyleCurrent %= BEATLINE_STYLES_COUNT;
    	global.beatlineStyle = beatlineStyleCurrent;
    	announcement_set("beatline_style", beatlineStylesName[beatlineStyleCurrent]);
    }
    
    if(keycheck_down(ord("0")))
    	advanced_expr();
    
    
    
    // Notes operation
    
    if(editor_select_count() > 0) {
    	if(keycheck_down(ord("M"))) {
	    	with(objNote) {
	    		if(state == stateSelected) {
	    			origProp = get_prop();
	    			position = 5 - position;
	    			operation_step_add(OPERATION_TYPE.MOVE, origProp, get_prop());
	    		}
	    	}
	    	announcement_play(i18n_get("notes_mirror", string(editor_select_count())));
	    }
	    if(keycheck_down_ctrl(ord("M"))) {
	    	with(objNote) {
	    		if(state == stateSelected) {
	    			var prop = get_prop();
	    			prop.position = 5 - prop.position;
	    			note_select_reset(true);
	    			build_note_withprop(prop, true, true);
	    		}
	    	}
	    	announcement_play(i18n_get("notes_mirror_copy", string(editor_select_count())));
	    }
	    if(keycheck_down(ord("R"))) {
	    	var _found = 0;
	    	with(objNote) {
	    		if(state == stateSelected)
		    		if(side > 0) {
		    			origProp = get_prop();
			    		side = 1 + (!(side - 1));
			    		operation_step_add(OPERATION_TYPE.MOVE, origProp, get_prop());
			    		_found ++;
			    	}
	    	}
	    	if(_found>0) {
	    		announcement_play(i18n_get("notes_rotate", string(_found)));
	    		editorSide = 1 + (!(editorSide - 1));
	    	}
	    		
	    	else
	    		announcement_warning("warning_notes_rotate");
	    }
	    if(keycheck_down_ctrl(ord("R"))) {
	    	var _found = 0;
	    	with(objNote) {
	    		if(state == stateSelected)
		    		if(side > 0) {
		    			var prop = get_prop();
			    		prop.side = 1 + (!(prop.side - 1));
			    		note_select_reset(true);
			    		build_note_withprop(prop, true, true);
			    		_found ++;
			    	}
	    	}
	    	if(_found>0) {
	    		announcement_play(i18n_get("notes_rotate_copy", string(_found)));
	    		editorSide = 1 + (!(editorSide - 1));
	    	}
	    		
	    	else
	    		announcement_warning("warning_notes_rotate_copy");
	    }
	    if(keycheck_down_ctrl(ord("V"))) {
	    	with(objNote)
	    		if(state == stateSelected) {
	    			origProp = get_prop();
			    	width = editor_get_default_width();
			    	operation_step_add(OPERATION_TYPE.MOVE, origProp, get_prop());
	    		}
	    	announcement_play(i18n_get("notes_set_width", string_format(editor_get_default_width(), 1, 2),
	    		string(editor_select_count())));
	    }
	    if(keycheck_down_ctrl(ord("1"))) {
	    	with(objNote)
	    		if(state == stateSelected)
			    	if(noteType < 2) {
			    		recordRequest = true;
			    		instance_destroy();
			    		var _prop = get_prop();
			    		_prop.noteType = 0;
			    		build_note_withprop(_prop, true, true);
			    	}
			announcement_play(i18n_get("notes_set_type", "NOTE", string(editor_select_count())));
	    }
	    if(keycheck_down_ctrl(ord("2"))) {
	    	with(objNote)
	    		if(state == stateSelected)
			    	if(noteType < 2) {
			    		recordRequest = true;
			    		instance_destroy();
			    		var _prop = get_prop();
			    		_prop.noteType = 1;
			    		build_note_withprop(_prop, true, true);
			    	}
			announcement_play(i18n_get("notes_set_type", "CHAIN", string(editor_select_count())));
	    }
    }
    
        
    editorGridWidthEnabled = !ctrl_ishold();
    
    // Editor Side Switch
    if(keycheck_down(vk_up))
        editor_set_editside((editor_get_editside() + 1) % 3);
    if(editorSide != editorLastSide) {
        _attach_sync_request = true;
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
        else {
            game_end_confirm();
        }
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
            for(; i<l; i++) {
            	editorNoteAttaching[i].side = editorSide;
            	if(editorMode != 0)
            		editorNoteAttaching[i].width = editor_get_default_width();
            }
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
                editorNoteAttaching = [note_build_attach(editorMode - 1, editorSide, editor_get_default_width())];
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
        array_sort(copyStack, function (_a, _b) { 
            return sign(_a.time == _b.time? _a.position - _b.position : _a.time - _b.time); });
        
        if(keycheck_down_ctrl(ord("X")))
            announcement_play(i18n_get("cut_notes", string(_cnt)));
        else
            announcement_play(i18n_get("copy_notes", string(_cnt)));
    }

#endregion