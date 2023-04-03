
function sNote(prop) constructor {
	if(!is_struct(prop))
		show_error("prop in sNote must be a struct.", true);
	
	/// Builtin Props
	width = 2.0;
    position = 2.5;
    side = 0;
    time = 0;
    lastTime = 0;
    noteType = 0;
    arrayPos = -1;
    
	/// Builtin Image Variables
	image_xscale = 1;
	image_angle = 0;
	image_yscale = global.scaleYAdjust;

	/// Display Variables
	drawVisible = false;
	sprite = sprNote2;
	pWidth = (width * 300 - 30)*2; // Width In Pixels
    originalWidth = sprite_get_width(sprite);
	lastAlphaL = 0;
    lastAlphaR = 1;
    lastAlpha = lastAlphaL;

	/// Related instances
    inst = undefined;
    sinst = undefined;
    snote = undefined;
    finst = undefined;
    fnote = undefined;
    selfPointer = self;

	/// Editor Variables
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

	/// Animation Variables
	animSpeed = 0.4;
    animPlaySpeedMul = 1;
    animTargetA = 0;
    animTargetLstA = lastAlpha;
    image_alpha = 0;

	/// Particles Variables
    partNumber = 12;
    partNumberLast = 1;

	/// Layout Variables
	lFromLeft = 5;
    rFromRight = 5;
    dFromBottom = 0;
    uFromTop = 0;

/// Private Methods

	static _prop_init = function () {
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

	static _emit_particle = function(_num, _type, _force = false) {
        
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

	static _mouse_inbound_check = function (_mode = 0) {
        switch _mode {
            case 0:
                return mouse_inbound(bbox_left, bbox_top, bbox_right, bbox_bottom);
            case 1:
                return mouse_inbound_last_l(bbox_left, bbox_top, bbox_right, bbox_bottom);
        }
    }

/// State Methods

	static stateNormal = function() {
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

	static stateLast = function () {
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

	static stateOut = function() {
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

	static stateAttach = function() {
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

	static stateDrop = function() {
		stateString = "DROP";
		animTargetA = 0.8;
		
		if(mouse_check_button_released(mb_left)) {
			if(editor_get_editmode() > 0)
				editor_set_default_width(width);
			if(noteType == 2) {
				if(fixedLastTime != -1) {
					lastTime = fixedLastTime;
					//build_hold(random_id(9), time, position, width, random_id(9), time + fixedLastTime, side, true);
					build_note(get_prop(), false, true);
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
			build_note(get_prop(), false, true);
			
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
	
	static stateAttachSub = function () {
		stateString = "ATCHS";
		sinst.lastAttachBar = editor_snap_to_grid_y(side == 0?mouse_y:mouse_x, side);
		sinst.time = y_to_note_time(sinst.lastAttachBar.y, side);
		
		if(mouse_check_button_pressed(mb_left)) {
			state = stateDropSub;
			origWidth = width;
		}
	}
	
	static stateDropSub = function () {
		stateString = "DROPS";
		animTargetA = 1.0;
		if(mouse_check_button_released(mb_left)) {
			var _subid = random_id(9);
			var _teid = random_id(9);
			lastTime = sinst.time - time;
			build_note(get_prop(), false, true);
			instance_destroy(sinst);
			instance_destroy();
			sinst = -999;
		}
	}
	
	// State Selected
	static stateSelected = function() {
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
					sync_prop_set();
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
	
/// Public Methods
	static set_prop = function (prop) {
		width = prop.width;
		position = prop.position;
		side = prop.side;
		noteType = prop.noteType;
		time = prop.time;
		lastTime = prop.lastTime;
	}
	
	set_prop(prop);
	
	static get_prop = function (with_inst = true) {
		var _ret = {
			width: width,
			position: position,
			side: side,
			noteType: noteType,
			time: time,
			lastTime: lastTime
		};
		if(with_inst) {
			variable_struct_set(_ret, "inst", inst);
			variable_struct_set(_ret, "sinst", sinst);
		}
		return _ret;
	}
	
	static create_self = function () {
		if(instance_exists(inst))
			show_error("Create self failed. There has been a instance related to the note.", true);
		static obj_types = [objNote, objChain, objHold, objHoldSub];
		var obj_type = obj_types[noteType];
		inst = instance_create_depth(0, 0, 0, obj_type, {fstruct: selfPointer});
		return inst;
	}
	
	static get_begin_time = function () {
		if(noteType == 3) return time - lastTime;
		return 0x3f3f3f3f;
	}
	
	static activate = function () {
		note_activate(inst);
		inst.sync_prop_get();
	}
	
	static deactivate = function () {
		note_deactivate_request(inst);
	}
	
	static destroy = function (_record = true) {
		if(arrayPos == -1) {
			return;
		}
		var i = arrayPos;
    	if(_record)
    		operation_step_add(OPERATION_TYPE.REMOVE, get_prop(), -1);
		if(array_length(objMain.chartNotesArray))
    		ds_map_delete(objMain.chartNotesMap[objMain.chartNotesArray[i].side], inst.nid);
        time = INF;
	}

/// Event Methods

	static _event_draw = function() {
		if(!drawVisible) return;
		if(side == 0) {
			draw_sprite_ext(sprNote2, image_number, x - pWidth / 2, y, 
				image_xscale, image_yscale, image_angle, image_blend, image_alpha);
		}
		else {
			draw_sprite_ext(sprNote2, image_number, x, y + pWidth / 2 * (side == 1?-1:1), 
				image_xscale, image_yscale, image_angle, image_blend, image_alpha);
		}
	}

	static _event_draw_gui = function() {
		if(_outroom_check(x, y)) return;

		if((drawVisible || nodeAlpha > EPS || infoAlpha > EPS) && editor_get_editmode() <= 4) {
			var _col = c_blue;
			
			animTargetInfoA = 0;
			if(editor_select_is_area()) {
				if(editor_select_inbound(x, y, side, noteType)) {
					_col = 0x28caff;
					animTargetNodeA = 1;
				}
				else {
					animTargetNodeA = 0;
				}
			}
			else {
				if((!objEditor.editorSelectOccupied || ctrl_ishold()) && objEditor.editorSelectSingleTargetInbound == id) {
					animTargetNodeA = 1.0;
					animTargetInfoA = ctrl_ishold()? 1:0;
				}
				else if(objEditor.editorHighlightLine && objEditor.editorHighlightPosition == position &&
					objEditor.editorHighlightSide == side) {
					animTargetNodeA = 1.0;
					animTargetInfoA = ctrl_ishold()? 1:0;
					_col = 0xc2577e;
				}
				else animTargetNodeA = 0;
			}
			if(state == stateSelected) {
				if(editor_select_is_area() && editor_select_inbound(x, y, side, noteType))
					_col = scribble_rgb_to_bgr(0xff1744);
				else 
					_col = c_white;
				animTargetNodeA = 1.0;
				animTargetInfoA = 1;
			}
			if(state == stateAttach || state == stateAttachSub || state == stateDrop || state == stateDropSub) {
				animTargetNodeA = 0.0;
				animTargetInfoA = 1;
			}
			if((state == stateLast && noteType == 2) || state == stateOut) {
				animTargetNodeA = 0;
				animTargetInfoA = 0;
			}
			
			var _inv = noteType == 3 ? -1:1;
			
			if(animTargetNodeA > 0)
				nodeColor = _col;
			
			// Draw Node
			if(nodeAlpha>EPS) {
				CleanRectangleXYWH(x, y, nodeRadius, nodeRadius)
					.Rounding(5)
					.Blend(nodeColor, nodeAlpha)
					.Draw();
			}
			
			// Draw Information
			if(infoAlpha > EPS) {
				var _dx = 20, _dy = (noteType == 2? dFromBottom:20) * _inv,
					_dyu = (noteType == 2? dFromBottom:25) * _inv;
				scribble(string_format(position, 1, 2))
					.starting_format("fDynamix16", c_aqua)
					.transform(global.scaleXAdjust, global.scaleYAdjust)
					.blend(c_white, infoAlpha)
					.align(fa_right, fa_middle)
					.draw(x - _dx, y + _dy);
				
				scribble(string_format(width, 1, 2))
					.starting_format("fDynamix16", c_white)
					.transform(global.scaleXAdjust, global.scaleYAdjust)
					.blend(c_white, infoAlpha)
					.align(fa_left, fa_middle)
					.draw(x + _dx, y + _dy);
				
				var _time = objMain.showBar ? "Bar " + string_format(time_to_bar(mtime_to_time(time)), 1, 6) : string_format(time, 1, 0);
				scribble(_time)
					.starting_format("fDynamix16", scribble_rgb_to_bgr(0xb2fab4))
					.transform(global.scaleXAdjust, global.scaleYAdjust)
					.blend(c_white, infoAlpha)
					.align(fa_right, fa_middle)
					.draw(x - _dx, y - _dyu);
				
				if(is_struct(lastAttachBar) && lastAttachBar.bar != undefined) {
					var _bar = string_format(lastAttachBar.bar, 1, 0)+" + "+string_format(lastAttachBar.diva, 1, 0)+"/"+string(lastAttachBar.divb)
					_bar += " [0xFFAB91]("+string(lastAttachBar.divc)+")"
					scribble(_bar)
						.starting_format("fDynamix16", scribble_rgb_to_bgr(0xFFE082))
						.transform(global.scaleXAdjust, global.scaleYAdjust)
						.blend(c_white, infoAlpha)
						.align(fa_left, fa_middle)
						.draw(x + _dx, y - _dyu);
				}
			}
			
		}
		else animTargetNodeA = 0;

		if(debug_mode && objMain.showDebugInfo && !_outroom_check(x, y)) {
			draw_set_font(fDynamix16)
			draw_set_halign(fa_center);
			draw_set_valign(fa_top);
			draw_text(x, y+5, stateString + " " + string(depth) + " " + string(arrayPos))
		}
	}

	static _event_step = function() {
		sync_prop_get();

		_prop_init();

		if(state == stateOut && image_alpha<EPS) {
			drawVisible = false;
		}
		else
			drawVisible = true;

		selectInbound = editor_select_is_area() && editor_select_inbound(x, y, side, noteType, side);
		selectTolerance = selectInbound || state == stateSelected;

		state();

		sync_prop_set();

		selectUnlock = false;

		if(drawVisible || nodeAlpha>EPS || infoAlpha>EPS || image_alpha>EPS) {
			var _factor = 1;
			if(editor_get_editmode() < 5 && objMain.fadeOtherNotes && side != editor_get_editside())
				_factor = 0.5;
			if(editor_get_editmode() < 5) {
				image_alpha = lerp_a(image_alpha, animTargetA * _factor,
					animSpeed * (objMain.nowPlaying ? objMain.musicSpeed * animPlaySpeedMul : 1));
			}
			else {
				image_alpha = animTargetA;
			}
			lastAlpha = lerp_a(lastAlpha, animTargetLstA * _factor,
				animSpeed * (objMain.nowPlaying ? objMain.musicSpeed * animPlaySpeedMul : 1));
			
			if(keycheck(ord("A")) || keycheck(ord("D")) || 
				objMain.topBarMousePressed || (side == 0 && objMain.nowPlaying)) {
				image_alpha = animTargetA * _factor;
				lastAlpha = animTargetLstA * _factor;
			}
			
			nodeAlpha = lerp_a(nodeAlpha, animTargetNodeA, animSpeed);
			infoAlpha = lerp_a(infoAlpha, animTargetInfoA, animSpeed);
		}

		// If no longer visible then deactivate self
		if(!drawVisible && nodeAlpha<EPS && infoAlpha < EPS && !instance_exists(finst)) {
			note_deactivate_request(id);
			return;
		}

		// Update Highlight Line's Position
		if(objEditor.editorHighlightLine && instance_exists(id)) {
			if(state == stateSelected && isDragging || state == stateAttachSub || state == stateDropSub
				|| ((state == stateAttach || state == stateDrop) && id == editor_get_note_attaching_center())) {
				objEditor.editorHighlightTime = time;
				objEditor.editorHighlightPosition = position;
				objEditor.editorHighlightSide = side;
				if(state == stateAttachSub || state == stateDropSub) {
					objEditor.editorHighlightTime = sinst.time;
				}
			}
		}



		// Add selection blend

		if(state == stateSelected)
			image_blend = selBlendColor;
		else
			image_blend = c_white;
	}
}

function _outbound_check(_x, _y, _side) {
    if(_side == 0 && _y < -100)
        return true;
    else if(_side == 1 && _x >= global.resolutionW / 2)
        return true;
    else if(_side == 2 && _x <= global.resolutionW / 2)
        return true;
    else
        return false;
}

function _outroom_check(_x, _y) {
	return !pos_inbound(_x, _y, 0, 0, global.resolutionW, global.resolutionH);
}

function _outbound_check_t(_time, _side) {
    var _pos = note_time_to_y(_time, _side);
    if(_side == 0 && _pos < -100)
        return true;
    else if(_side == 1 && _pos >= global.resolutionW / 2)
        return true;
    else if(_side == 2 && _pos <= global.resolutionW / 2)
        return true;
    else
        return false;
}

function _outscreen_check(_x, _y, _side) {
	return _side == 0? !in_between(_x, 0, global.resolutionW) : !in_between(_y, 0, global.resolutionH);
}

function note_sort_all() {
    var _f = function(_a, _b) {
        return sign(_a.time == _b.time ? int64(_a.inst) - int64(_b.inst) : _a.time - _b.time);
    }
    array_sort(objMain.chartNotesArray, _f);
    
    // Update arrayPos & Flush deleted notes
    with(objMain) {
    	chartNotesCount = array_length(chartNotesArray);
    	
    	for(var i=0; i<chartNotesCount; i++)
			chartNotesArray[i].arrayPos = i;
    	
    	while(array_length(chartNotesArray) > 0 && array_last(chartNotesArray).time == INF) {
    		array_pop(chartNotesArray);
    		// show_debug_message("Remove one note from array.");
    	}
    }
}

function note_sort_request() {
	objEditor.editorNoteSortRequest = true;
}

function build_note(prop, _fromxml = false, _record = false, _selecting = false) {
    var _note = new sNote(prop);
	var _inst = _note.create_self();
	
	if(_note.noteType == 2) {
		var _sprop = SnapDeepCopy(prop);
		_sprop.time = _note.time+_note.lastTime;
		_sprop.noteType = 3;
		var _snote = build_note(_sprop, _fromxml)
		_note.sinst = _snote.inst;
		_note.snote = _snote;
		_snote.finst = _note.inst;
		_snote.fnote = _note;
	}
    
    if(_fromxml)
        _note.position += _note.width/2;
    
    with(_inst) {
    	_prop_init();
    	if(noteType == 2) _prop_hold_update();
    	if(_selecting) state = stateSelected;
    }
    with(objMain) {
        array_push(chartNotesArray, _note);
        note_sort_request();
    }
    
    if(_record)
    	operation_step_add(OPERATION_TYPE.ADD, _note.get_prop(), -1);
    
    return _note;
}

function build_note_withprop(prop, record = false, selecting = false) {
	return build_note(prop, false, record, selecting);
}

function note_delete(_note, _record = false) {
	if(is_undefined(_note)) return;
	_note.destroy(_record);
}

function note_delete_all() {
	with(objMain) {
		chartNotesArray = [];
		chartNotesArrayAt = 0;
		ds_map_clear(chartNotesMap[0]);
		ds_map_clear(chartNotesMap[1]);
		ds_map_clear(chartNotesMap[2]);
		
		instance_activate_all();
		with(objNote) arrayPos = -1;
		instance_destroy(objNote);
	}
}

function notes_reallocate_id() {
	with(objMain) {
		instance_activate_object(objNote);
		var i=0, l=chartNotesCount;
		ds_map_clear(chartNotesMap[0]);
		ds_map_clear(chartNotesMap[1]);
		ds_map_clear(chartNotesMap[2]);
		for(; i<l; i++) {
			var _inst = chartNotesArray[i].inst;
			_inst.nid = string(i);
			chartNotesMap[_inst.side][? _inst.nid] = _inst;
		}
		for(i=0; i<l; i++) {
			var _inst = chartNotesArray[i].inst;
			if(_inst.noteType == 2)
				_inst.sid = _inst.sinst.nid;
			else
				_inst.sid = "-1";
		}
		note_activation_reset();
	}
}

function note_check_and_activate(_posistion_in_array) {
	var _str = objMain.chartNotesArray[_posistion_in_array];
	_str.arrayPos = _posistion_in_array;
	var _flag;
	_flag = _outbound_check_t(_str.time, _str.side);
	if((!_flag || (_str.noteType == 3 && _str.get_begin_time() < nowTime)) && _str.time + _str.lastTime > nowTime) {
		_str.activate();
		_str.arrayPos = _posistion_in_array;
		return 1;
	}
	else if(_flag && _outbound_check_t(_str.time, !(_str.side))) {
		return -1;
	}
	return 0;
}

function note_deactivate_request(inst) {
	objMain.deactivationQueue[? inst] = true;
}

function note_activate(inst) {
	instance_activate_object(inst);
	if(ds_map_exists(objMain.deactivationQueue, inst))
		ds_map_delete(objMain.deactivationQueue, inst);
}

function note_deactivate_flush() {
	with(objMain) {
		var q=deactivationQueue;
		var k=ds_map_find_first(q), s=ds_map_size(q);
		if(s)
			show_debug_message_safe("DEACTIVATED "+string(s)+" NOTES.");
		for(; s>0; s--) {
			if(instance_exists(k.sinst))
				instance_deactivate_object(k.sinst);
			instance_deactivate_object(k);
			k=ds_map_find_next(q, k);
		}
		
		ds_map_clear(q);
	}
}

function note_select_reset(isself = false) {
	with(isself?id:objNote)
		if(state == stateSelected) {
			state = stateNormal;
			state();
		}
}

function note_activation_reset() {
	instance_deactivate_object(objNote);
	with(objMain) {
		ds_map_clear(deactivationQueue);
		for(var i=0; i<chartNotesCount; i++)
			note_check_and_activate(i);
	}
}