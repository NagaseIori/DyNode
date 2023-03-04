
drawVisible = false;
origDepth = -10000000;
image_yscale = global.scaleYAdjust;

// In-Variables

    sprite = sprNote2;
    width = 2.0;
    position = 2.5;
    side = 0;
    bar = 0;
    time = 0;
    nid = -1;						// Note id
    sid = -1;						// Sub id
    sinst = -999;					// Sub instance id
    finst = -999;					// Father instance id
    noteType = 0;					// 0 Note 1 Chain 2 Hold
    arrayPos = -1;					// Position in chartNotesArray
    
    // For Editor
    origWidth = width;
    origTime = time;
    origPosition = position;
    origY = y;
    origX = x;
    origLength = 0;					// For hold
    origSubTime = 0;				// For hold's sub
    origProp = -1;					// For Undo & Redo
    fixedLastTime = -1; 			// For hold's copy and paste
    isDragging = false;
    nodeRadius = 22;				// in Pixels
    nodeColor = c_blue;
    
    // For Hold & Sub
    lastTime = 0;
    beginTime = 999999999;
    lastAlphaL = 0;
    lastAlphaR = 1;
    lastAlpha = lastAlphaL;
    
    pWidth = (width * 300 - 30)*2; // Width In Pixels
    originalWidth = sprite_get_width(sprite);
    
    // For edit
    selected = false;
    selBlendColor = 0x4fd5ff;
    nodeAlpha = 0;
    infoAlpha = 0;
    animTargetNodeA = 0;
    animTargetInfoA = 0;
    recordRequest = false;
    selectInbound = false;			// If time inbound multi selection
    selectUnlock = false;			// If the state in last step is select
    selectTolerance = false;		// Make the notes display normally when being or might be selected
    attaching = false;				// If is a attaching note
    lastAttachBar = -1;
    
    animSpeed = 0.4;
    animPlaySpeedMul = 1;
    animTargetA = 0;
    animTargetLstA = lastAlpha;
    image_alpha = 0;
    
    // Particles Number
    partNumber = 12;
    partNumberLast = 1;
    
    // Correction Values
    lFromLeft = 5;
    rFromRight = 5;
    dFromBottom = 0;
    uFromTop = 0;

// In-Functions

    _prop_init = function () {
    	origDepth = -20000000;
    	if(noteType == 1) origDepth *= 2;
    	else if(noteType == 2) origDepth /= 2;
    	if(side != 0) origDepth += 5000000;
    	
    	if(attaching) origDepth = -100000000;
        originalWidth = sprite_get_width(sprite);
        pWidth = width * 300 / (side == 0 ? 1:2) - 30 + lFromLeft + rFromRight;
        pWidth = max(pWidth, originalWidth) * global.scaleXAdjust;
        image_xscale = pWidth / originalWidth;
        image_angle = (side == 0 ? 0 : (side == 1 ? 270 : 90));
        depth = origDepth - arrayPos*16;
        if(noteType == 3 && instance_exists(finst))
        	depth = finst.depth;
        
        noteprop_set_xy(position, time, side);
    }
    _prop_init();

    _emit_particle = function(_num, _type, _force = false) {
        
        if(!objMain.nowPlaying && !_force)
            return;
        
        if(!objMain.particlesEnabled)
            return;
        
        // Emit Particles
        var _x, _y, _x1, _x2, _y1, _y2;
        if(side == 0) {
            _x = x;
            _x1 = x - pWidth / 2;
            _x2 = x + pWidth / 2;
            _y = global.resolutionH - objMain.targetLineBelow;
            _y1 = _y;
            _y2 = _y;
        }
        else {
            _x = side == 1 ? objMain.targetLineBeside : 
                             global.resolutionW - objMain.targetLineBeside;
            _x1 = _x;
            _x2 = _x;
            _y = y;
            _y1 = y - pWidth / 2;
            _y2 = y + pWidth / 2; 
        }
        
        // Emit particles on mixer's position
        if(side > 0 && objMain.chartSideType[side-1] == "MIXER") {
            _y = objMain.mixerX[side-1];
        }
        
        var _ang = image_angle, _scl = image_xscale;
        with(objMain) {
            _partemit_init(partEmit, _x1, _x2, _y1, _y2);
            if(_type == 0) {
                _parttype_noted_init(partTypeNoteDL, 1, _ang);
                _parttype_noted_init(partTypeNoteDR, 1, _ang+180);
                
                part_emitter_burst(partSysNote, partEmit, partTypeNoteDL, _num);
                part_emitter_burst(partSysNote, partEmit, partTypeNoteDR, _num);
            }
            else if(_type == 1) {
                _parttype_hold_init(partTypeHold, 1, _ang);
                part_emitter_burst(partSysNote, partEmit, partTypeHold, _num);
            }
        }
    }

    _create_shadow = function (_force = false) {
        if(!objMain.nowPlaying && !_force)
            return;
        if(objMain.topBarMousePressed)
        	return;
        
        // Play Sound
        if(objMain.hitSoundOn)
            audio_play_sound(sndHit, 0, 0);
        
        // Create Shadow
        if(side > 0 && objMain.chartSideType[side-1] == "MIXER") {
            objMain.mixerShadow[side-1]._hit();
        }
        else {
        	var _x, _y;
	        if(side == 0) {
	            _x = x;
	            _y = global.resolutionH - objMain.targetLineBelow;
	        }
	        else {
	            _x = side == 1 ? objMain.targetLineBeside : 
	                             global.resolutionW - objMain.targetLineBeside;
	            _y = y;
	        }
	        var _shadow = objShadow;
	        
	        var _inst = instance_create_depth(_x, _y, origDepth * 3, _shadow), _scl = 1;
	        _inst.nowWidth = pWidth;
	        _inst.visible = true;
	        _inst.image_angle = image_angle;
	        _inst._prop_init();
        }
        
        _emit_particle(ceil(partNumberLast * image_xscale), 0);
    }
    
    _mouse_inbound_check = function (_mode = 0) {
        switch _mode {
            case 0:
                return mouse_inbound(bbox_left, bbox_top, bbox_right, bbox_bottom);
            case 1:
                return mouse_inbound_last_l(bbox_left, bbox_top, bbox_right, bbox_bottom);
        }
        
    }
    
    get_prop = function (_fromxml = false) {
    	return {
        	time : _fromxml?bar:time,
        	side : side,
        	width : width,
        	position : position,
        	lastTime : lastTime,
        	noteType : noteType,
        	inst : id,
        	beginTime : beginTime
        };
    }
    
    set_prop = function (props) {
    	if(!is_struct(props))
    		show_error("property must be a struct.", true);
    	
    	time = props.time;
    	side = props.side;
    	width = props.width;
    	position = props.position;
    	lastTime = props.lastTime;
    	noteType = props.noteType;
    	beginTime = props.beginTime;
    	
    	if(noteType == 2 && sinst > 0) {
    		note_activate(sinst);
    		sinst.time = time + lastTime;
    		_prop_hold_update();
    	}
    }
    
    // _outbound_check was moved to scrNote

// State Machines
    
    // State Normal
    stateNormal = function() {
    	if(stateString == "SEL")
    		selectUnlock = true;
        stateString = "NM";
        animTargetA = 1.0;
        animTargetLstA = lastAlphaL;
        
        // Side Fading
        if(editor_get_editmode() == 5 && side > 0) {
        	animTargetA = lerp(0.25, 1, abs(x - resor_to_x(0.5)) / resor_to_x(0.5-0.2));
        	animTargetA = clamp(animTargetA, 0, 1);
        }
        
        // Update Mixer's Position
	    if(side > 0) {
	        var _nside = side-1, _noff = time, _nx = y, _nid = id;
	        
	        with(objMain) {
	            if((_noff-nowTime)*playbackSpeed/global.resolutionW < MIXER_REACTION_RANGE &&
	              (mixerNextNote[_nside] == -1 || _noff < mixerNextNote[_nside].time)) {
	                mixerNextNote[_nside] = _nid;
	                mixerNextX[_nside] = _nx;
	            }
	        }
	    }
        
        var _limTime = min(objMain.nowTime, objMain.animTargetTime);
        
        // If inbound then the state wont change
        if(!selectInbound) {
        	if(time <= _limTime) {
        		// If the state in last step is SELECT then skip create_shadow
        		if(!selectUnlock)
	            	_create_shadow();
	            state = stateLast;
	            state();
	        }
	        if(_outbound_check(x, y, side)) {
	            state = stateOut;
	            state();
	        }
        }
        
        
        // Check Selecting
        if(editor_get_editmode() == 4 && side == editor_get_editside() && !objMain.topBarMousePressed
            && !(objEditor.editorSelectOccupied && noteType == 3)) {
        	var _mouse_click_to_select = mouse_isclick_l() && _mouse_inbound_check();
        	var _mouse_drag_to_select = mouse_ishold_l() && _mouse_inbound_check(1) 
        		&& !editor_select_is_area() && !editor_select_is_dragging()
        		&& !keyboard_check(vk_control);
        	
            if(_mouse_click_to_select || _mouse_drag_to_select) {
                objEditor.editorSelectSingleTarget =
                    editor_select_compare(objEditor.editorSelectSingleTarget, id);
            }
            
            if(_mouse_inbound_check()) {
                objEditor.editorSelectSingleTargetInbound = 
                    editor_select_compare(objEditor.editorSelectSingleTargetInbound, id);
            }
        }
    }
    
    // State Last
    stateLast = function () {
        stateString = "LST";
        animTargetLstA = lastAlphaR;
        
        var _limTime = min(objMain.nowTime, objMain.animTargetTime);
        if(time + lastTime <= _limTime) {
            state = stateOut;
            image_alpha = lastTime == 0 ? 0 : image_alpha;
            state();
        }
        else if(objMain.nowPlaying || editor_get_editmode() == 5) {
            _emit_particle(ceil(partNumberLast * image_xscale * global.fpsAdjust), 1, true);
        }
        
        if(time > objMain.nowTime) {
            state = stateNormal;
            state();
        }
    }
    
    // State Targeted
    stateOut = function() {
        stateString = "OUT";
        
        animTargetA = 0.0;
        animTargetLstA = lastAlphaL;
        
        if(time + lastTime> objMain.nowTime && !_outbound_check(x, y, side)) {
	        drawVisible = true;
	        state = stateNormal;
	        state();
	    }
	    
	    if(time > objMain.nowTime && beginTime <= objMain.nowTime)
	    	note_activate(finst);
    }
    
    // Editors
        // State attached to cursor
        stateAttach = function() {
            stateString = "ATCH";
            animTargetA = _outbound_check(x, y, side) ? 0:0.5;
            
            if(editor_get_note_attaching_center() == id) {
            	if(side == 0) {
	                x = editor_snap_to_grid_x(mouse_x, side);
	                lastAttachBar = editor_snap_to_grid_y(mouse_y, side);
	                y = lastAttachBar.y;
	                position = x_to_note_pos(x, side);
	                time = y_to_note_time(y, side);
	            }
	            else {
	                y = editor_snap_to_grid_x(mouse_y, side);
	                lastAttachBar = editor_snap_to_grid_y(mouse_x, side);
	                x = lastAttachBar.y;
	                position = x_to_note_pos(y, side);
	                time = y_to_note_time(x, side);
	            }
	            
	            var _pos = position, _time = time;
	            with(objNote) {
	            	var _center = editor_get_note_attaching_center();
	            	if(state == stateAttach) {
	            		position = _pos + origPosition - _center.origPosition;
	            		time = _time + origTime - _center.origTime;
	            		_prop_init();
		            	if(noteType == 2)
		            		_prop_hold_update();
	            	}
	            }
            }
            
            if(mouse_check_button_pressed(mb_left) && !_outbound_check(x, y, side)
            	&& id == editor_get_note_attaching_center()) {
                with(objNote) if(state == stateAttach) {
                	state = stateDrop;
                	origWidth = width;
                }
            }
                
        }
        
        // State Dropping down
        stateDrop = function() {
            stateString = "DROP";
            animTargetA = 0.8;
            
            
            if(mouse_check_button_released(mb_left)) {
            	if(editor_get_editmode() > 0)
                	editor_set_default_width(width);
                if(noteType == 2) {
                	if(fixedLastTime != -1) {
                		build_hold(random_id(9), time, position, width, random_id(9), time + fixedLastTime, side, true);
                		instance_destroy();
                		return;
                	}
                    var _time = time;
                    state = stateAttachSub;
                    sinst = instance_create_depth(x, y, depth, objHoldSub);
                    sinst.dummy = true;
                    sinst.time = time;
                    return;
                }
                build_note(random_id(9), noteType, time, position, width, -1, side, false, true);
                
                if(_outscreen_check(x, y, side))
                	announcement_warning("warning_note_outbound");
                
                instance_destroy();
            }
            
            if(!mouse_ishold_l())
            	width = origWidth;
            else {
            	if(side == 0)
	                width = origWidth + 2.5 * mouse_get_delta_last_x_l() / 300;
	            else
	                width = origWidth - 2.5 * mouse_get_delta_last_y_l() / 150;
            }
            
            width = editor_snap_width(width);
            width = max(width, 0.01);
            _prop_init();
        }
        
        stateAttachSub = function () {
            stateString = "ATCHS";
            sinst.lastAttachBar = editor_snap_to_grid_y(side == 0?mouse_y:mouse_x, side);
            sinst.time = y_to_note_time(sinst.lastAttachBar.y, side);
            
            if(mouse_check_button_pressed(mb_left)) {
                state = stateDropSub;
                origWidth = width;
            }
        }
        
        stateDropSub = function () {
            stateString = "DROPS";
            animTargetA = 1.0;
            if(mouse_check_button_released(mb_left)) {
                var _subid = random_id(9);
                var _teid = random_id(9);
                build_hold(_teid, time, position, width, _subid, sinst.time, side, true);
                instance_destroy(sinst);
                instance_destroy();
                sinst = -999;
            }
        }
        
        // State Selected
        stateSelected = function() {
        	animTargetA = 1;
            if(stateString != "SEL" && instance_exists(sinst)) {
                origLength = sinst.time - time;
                origSubTime = sinst.time;
            }
            stateString = "SEL";
            
            if(editor_get_editmode() != 4 || editor_get_editside() != side)
                state = stateNormal;
            
            if(editor_select_is_multiple() && noteType == 3)
                state = stateNormal;
            
            if(!editor_select_is_dragging() && mouse_ishold_l() && _mouse_inbound_check(1)) {
                if(!isDragging) {
                    isDragging = true;
                    objEditor.editorSelectDragOccupied = 1;
                    with(objNote) {
                        if(state == stateSelected) {
                        	origProp = get_prop();
                            origX = x;
                            origY = y;
                        }
                    }
                }
            }
            if(mouse_check_button_released(mb_left)) {
                if(isDragging) {
                    isDragging = false;
                    
                    with(objNote) {
                    	if(state == stateSelected) {
                    		operation_step_add(OPERATION_TYPE.MOVE, origProp, get_prop());
                    	}
                    	
                    	if(_outscreen_check(x, y, side))
                			announcement_warning("warning_note_outbound", 5000, "wob");
                    }
                    
                    note_sort_request();
                }
            }
            if(isDragging) {
                if(side == 0) {
                	lastAttachBar = editor_snap_to_grid_y(origY + mouse_get_delta_last_y_l(), side);
                    y = lastAttachBar.y;
                    x = editor_snap_to_grid_x(origX + mouse_get_delta_last_x_l(), side);
                    position = x_to_note_pos(x, side);
                    time = y_to_note_time(y, side);
                }
                else {
                	lastAttachBar = editor_snap_to_grid_y(origX + mouse_get_delta_last_x_l(), side);
                    x = lastAttachBar.y;
                    y = editor_snap_to_grid_x(origY + mouse_get_delta_last_y_l(), side);
                    position = x_to_note_pos(y, side);
                    time = y_to_note_time(x, side);
                }
                
                var _delta_x = x - origX;
                var _delta_y = y - origY;
                
                with(objNote) {
                    if(state == stateSelected) {
                        x = origX + _delta_x;
                        y = origY + _delta_y;
                        
                        position = x_to_note_pos(side?y:x, side);
                        time = y_to_note_time(side?x:y, side);
                        if(noteType == 2) {
                            sinst.time = (ctrl_ishold() || editor_select_is_multiple()) ? time + origLength : origSubTime;
                            _prop_hold_update();
                        }
                    }
                }
            }
            
            if((keycheck_down(vk_delete) || keycheck_down(vk_backspace)) && noteType != 3) {
            	recordRequest = true;
            	instance_destroy();
            }
                
            
            if(keycheck_down(ord("T"))) {
            	timing_point_duplicate(time);
		    }
		    if(keycheck_down_ctrl(vk_delete)) {
		    	timing_point_delete_at(time, true);
		    }
		    if(keycheck_down_ctrl(ord("C")) && !editor_select_is_multiple()) {
		    	editor_set_default_width(width);
		    	announcement_play(i18n_get("copy_width", string_format(width, 1, 2)));
		    }
		    
		    
		    // Pos / Time Adjustment
		    var _poschg = (keycheck_down_ctrl(vk_right) - keycheck_down_ctrl(vk_left)) * (shift_ishold() ? 0.05: 0.01);
		    var _timechg = (keycheck_down_ctrl(vk_up) - keycheck_down_ctrl(vk_down)) * (shift_ishold() ? 5: 1);
		    
		    if(_timechg != 0 || _poschg != 0)
		    	origProp = get_prop();
		    time += _timechg;
		    position += _poschg;
		    if(_timechg != 0)
		    	note_sort_request();
		    if(_timechg != 0 || _poschg != 0)
		    	operation_step_add(OPERATION_TYPE.MOVE, origProp, get_prop());
		    	
        }

    state = stateOut;
    stateString = "OUT";