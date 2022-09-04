
drawVisible = false;
origDepth = -10000000;
image_yscale = global.scaleYAdjust;

// In-Variables

    sprite = sprNote2;
    width = 2.0;
    position = 2.5;
    side = 0;
    // offset = 0;
    bar = 0;
    time = 0;
    nid = -1; // Note id
    sid = -1; // Sub id
    sinst = -999; // Sub instance id
    finst = -999; // Father instance id
    noteType = 0; // 0 Note 1 Chain 2 Hold
    
    // For Editor
    origWidth = width;
    origTime = time;
    origPosition = position;
    origY = y;
    origX = x;
    origLength = 0; // For hold
    origSubTime = 0; // For hold's sub
    origProp = -1; // For Undo & Redo
    fixedLastTime = -1; // For hold's copy and paste
    isDragging = false;
    nodeRadius = 22; // in Pixels
    nodeColor = c_blue;
    
    // For Hold & Sub
    lastTime = 0;
    beginTime = 999999999;
    lastAlphaL = 0;
    lastAlphaR = 0.7;
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
        originalWidth = sprite_get_width(sprite);
        pWidth = width * 300 / (side == 0 ? 1:2) - 30 + lFromLeft + rFromRight;
        pWidth = max(pWidth, originalWidth) * global.scaleXAdjust;
        image_xscale = pWidth / originalWidth;
        image_angle = (side == 0 ? 0 : (side == 1 ? 270 : 90));
        depth = origDepth - time;
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
                // part_particles_create(partSysNote, _x, _y, partTypeNoteDL, _num/2);
                // part_particles_create(partSysNote, _x, _y, partTypeNoteDR, _num/2);
            }
            else if(_type == 1) {
                _parttype_hold_init(partTypeHold, 1, _ang);
                // part_particles_create(partSysNote, _x, _y, partTypeHold, _num);
                part_emitter_burst(partSysNote, partEmit, partTypeHold, _num);
            }
        }
    }

    _create_shadow = function (_force = false) {
        if(!objMain.nowPlaying && !_force)
            return;
        
        // Play Sound
        if(objMain.hitSoundOn)
            audio_play_sound(sndHit, 0, 0);
        
        // Create Shadow
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
        if(side > 0 && objMain.chartSideType[side-1] == "MIXER") {
            _shadow = objShadowMIX;
            _y = objMain.mixerX[side-1];
        }
            
        var _inst = instance_create_depth(_x, _y, origDepth * 3, _shadow), _scl = 1;
        _inst.nowWidth = pWidth;
        _inst.visible = true;
        _inst.image_angle = image_angle;
        
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
    		instance_activate_object(sinst);
    		sinst.time = time + lastTime;
    		_prop_hold_update();
    	}
    }
    
    // _outbound_check was moved to scrNote

// State Machines
    
    // State Normal
    stateNormal = function() {
        stateString = "NM";
        animTargetA = 1.0;
        animTargetLstA = lastAlphaL;
        
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
        if(time <= _limTime) {
            _create_shadow();
            state = stateLast;
            state();
        }
        if(_outbound_check(x, y, side)) {
            state = stateOut;
            state();
        }
        
        // Check Selecting
        if(editor_get_editmode() == 4 && side == editor_get_editside() && !objMain.topBarMousePressed
            && !(objEditor.editorSelectOccupied && noteType == 3)) {
            if((mouse_isclick_l() && _mouse_inbound_check())
                || (mouse_ishold_l() && _mouse_inbound_check(1) && !editor_select_is_area() && !editor_select_is_dragging())) {
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
	    	instance_activate_object(finst);
    }
    
    // Editors
        // State attached to cursor
        stateAttach = function() {
            stateString = "ATCH";
            animTargetA = _outbound_check(x, y, side) ? 0:0.5;
            
            if(editor_get_note_attaching_center() == id) {
            	if(side == 0) {
	                x = editor_snap_to_grid_x(mouse_x, side);
	                y = editor_snap_to_grid_y(mouse_y, side);
	                position = x_to_note_pos(x, side);
	                time = y_to_note_time(y, side);
	            }
	            else {
	                y = editor_snap_to_grid_x(mouse_y, side)
	                x = editor_snap_to_grid_y(mouse_x, side);
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
                	editor_set_width_default(width);
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
                	announcement_warning("你正在放置一个中心超出屏幕的音符。\n该音符可能在屏幕内不可见，并且之后将因此无法编辑。\n你可以使用撤销来退回上一步操作。");
                
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
            sinst.time = y_to_note_time(editor_snap_to_grid_y(side == 0?mouse_y:mouse_x, side), side);
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
            if(stateString != "SEL" && instance_exists(sinst)) {
                origLength = sinst.time - time;
                origSubTime = sinst.time;
            }
            stateString = "SEL";
            
            if(editor_get_editmode() != 4)
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
                    }
                    
                    note_sort_request();
                }
            }
            if(isDragging) {
                if(side == 0) {
                    y = editor_snap_to_grid_y(origY + mouse_get_delta_last_y_l(), side);
                    x = editor_snap_to_grid_x(origX + mouse_get_delta_last_x_l(), side);
                    position = x_to_note_pos(x, side);
                    time = y_to_note_time(y, side);
                }
                else {
                    x = editor_snap_to_grid_y(origX + mouse_get_delta_last_x_l(), side);
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
                
            if(keycheck_down(ord("M"))) {
            	origProp = get_prop();
            	position = 5 - position;
            	operation_step_add(OPERATION_TYPE.MOVE, origProp, get_prop());
            	announcement_play("镜像音符共 " + string(editor_select_count()) + " 处");
            }
            if(keycheck_down(ord("T"))) {
            	timing_point_duplicate(time);
		    }
		    if(keycheck_down_ctrl(vk_delete)) {
		    	timing_point_delete_at(time, true);
		    }
		    if(keycheck_down_ctrl(ord("C")) && !editor_select_is_multiple()) {
		    	objEditor.editorDefaultWidth = width;
		    	announcement_play("复制宽度："+string_format(width, 1, 2));
		    }
		    if(keycheck_down_ctrl(ord("V"))) {
		    	origProp = get_prop();
		    	width = objEditor.editorDefaultWidth;
		    	operation_step_add(OPERATION_TYPE.MOVE, origProp, get_prop());
		    	announcement_play("设置宽度："+string_format(width, 1, 2)+"\n共 "+string(editor_select_count())+" 处");
		    }
		    if(keycheck_down_ctrl(ord("1"))) {
		    	if(noteType < 2) {
		    		recordRequest = true;
		    		instance_destroy();
		    		build_note(nid, 0, time, position, width, sid, side, false, true);
		    		announcement_play("设置类型：NOTE\n共 "+string(editor_select_count())+" 处");
		    	}
		    }
		    if(keycheck_down_ctrl(ord("2"))) {
		    	if(noteType < 2) {
		    		recordRequest = true;
		    		instance_destroy();
		    		build_note(nid, 1, time, position, width, sid, side, false, true);
		    		announcement_play("设置类型：CHAIN\n共 "+string(editor_select_count())+" 处");
		    	}
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