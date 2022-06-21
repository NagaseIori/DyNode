
drawVisible = false;
depth = 100;

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
    noteType = 0; // 0 Note 1 Chain 2 Hold
    
    // For Editor
    origWidth = width;
    origTime = time;
    origPosition = position;
    origY = y;
    origX = x;
    isDragging = false;
    mouseDetectRange = 20; // in Pixels
    
    // For Hold
    lastTime = 0;
    lastAlphaL = 0.4;
    lastAlphaR = 1.0;
    lastAlpha = lastAlphaL;
    
    pWidth = (width * 300 - 30)*2; // Width In Pixels
    originalWidth = sprite_get_width(sprite);
    
    // For edit
    selected = false;
    selBlendColor = 0x4fd5ff;
    
    animSpeed = 0.4;
    animTargetA = 0;
    animTargetLstA = lastAlpha;
    image_alpha = 0;
    
    // Particles Number
    partNumber = 24;
    partNumberLast = 1;
    
    // Correction Values
    lFromLeft = 5;
    rFromRight = 5;

// In-Functions

    _prop_init = function () {
        originalWidth = sprite_get_width(sprite);
        pWidth = width * 300 / (side == 0 ? 1:2) - 30 + lFromLeft + rFromRight;
        pWidth = max(pWidth, originalWidth);
        image_xscale = pWidth / originalWidth;
        image_angle = (side == 0 ? 0 : (side == 1 ? 270 : 90));
    }
    _prop_init();

    _burst_particle = function(_num, _type, _force = false) {
        
        if(!objMain.nowPlaying && !_force)
            return;
        
        // Burst Particles
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
        
        // Particles burst on mixer's position
        if(side > 0 && objMain.chartSideType[side-1] == "MIXER") {
            _y = objMain.mixerX[side-1];
        }
        
        var _ang = image_angle, _scl = image_xscale;
        with(objMain) {
            if(_type == 0) {
                _parttype_noted_init(partTypeNoteDL, 1, _ang);
                _parttype_noted_init(partTypeNoteDR, 1, _ang+180);
                
                part_particles_create(partSysNote, _x, _y, partTypeNoteDL, _num/2);
                part_particles_create(partSysNote, _x, _y, partTypeNoteDR, _num/2);
            }
            else if(_type == 1) {
                _parttype_hold_init(partTypeHold, 1, _ang);
                _partemit_hold_init(partEmitHold, _x1, _x2, _y1, _y2);
                // part_particles_create(partSysNote, _x, _y, partTypeHold, _num);
                part_emitter_burst(partSysNote, partEmitHold, partTypeHold, _num);
            }
        }
    }

    _create_shadow = function (_force = false) {
        if(!objMain.nowPlaying && !_force)
            return;
        
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
            
        var _inst = instance_create_depth(_x, _y, -1, _shadow), _scl = 1;
        _inst.nowWidth = pWidth;
        _inst.visible = true;
        _inst.image_angle = image_angle;
        
        _burst_particle(partNumber, 0);
    }
    
    _mouse_inbound_check = function (_mode = 0) {
        switch _mode {
            case 0:
                return mouse_inbound(bbox_left, bbox_top, bbox_right, bbox_bottom);
            case 1:
                return mouse_inbound_last_l(bbox_left, bbox_top, bbox_right, bbox_bottom);
        }
        
    }
    
    // _outbound_check was moved to scrNote

// State Machines

    // State Fade in
    stateIn = function () {
        
        stateString = "IN";
        animTargetA = 1.0;
        animTargetLstA = lastAlphaL;
        
        var _limTime = min(objMain.nowTime, objMain.animTargetTime);
        if(time <= _limTime) {
            _create_shadow();
            state = stateLast;
            state();
        }
        // If is using adm to adjust time then speed the things hell up
        if(keyboard_check(ord("A")) || keyboard_check(ord("D")) || 
            objMain.topBarMousePressed) {
            image_alpha = 1;
            animTargetA = 1;
            state = stateNormal;
        }
        else if(image_alpha > 0.98) {
            state = stateNormal;
            image_alpha = 1;
        }
        
        if(_outbound_check(x, y, side)) {
            state = stateOut;
            state();
        }
    }
    
    // State Normal
    stateNormal = function() {
        stateString = "NM";
        
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
        if(editor_get_editmode() == 4 && side == editor_get_editside() && !objMain.topBarMousePressed) {
            if((mouse_check_button_pressed(mb_left) && _mouse_inbound_check())
                || (mouse_ishold_l() && _mouse_inbound_check(1))) {
                objEditor.editorSelectSingleTarget = id;
            }
            
            if(_mouse_inbound_check()) {
                objEditor.editorSelectSingleTargetInbound = id;
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
        else _burst_particle(ceil(partNumberLast * image_xscale * global.fpsAdjust), 1, true);
        
        if(time > objMain.nowTime) {
            state = stateIn;
            state();
        }
    }
    
    // State Targeted
    stateOut = function() {
        stateString = "OUT";
        
        animTargetA = 0.0;
        animTargetLstA = lastAlphaL;
        
        if(time + lastTime> objMain.nowTime && !_outbound_check(x, y, side)) {
            // In Some situations no need for fading in
            if(keyboard_check(ord("A")) || keyboard_check(ord("D")) || 
                objMain.topBarMousePressed ||
                (side == 0 && objMain.nowPlaying)) {
                image_alpha = 1;
                animTargetA = 1;
                state = stateNormal;
            }
            else 
                state = stateIn;
            state();
        }
    }
    
    // Editors
        // State attached to cursor
        stateAttach = function() {
            stateString = "ATCH";
            animTargetA = 0.5;
            
            if(side == 0) {
                x = mouse_x;
                y = editor_snap_to_grid_y(mouse_y, side);
                position = x_to_note_pos(x, side);
                time = y_to_note_time(y, side);
            }
            else {
                y = mouse_y;
                x = editor_snap_to_grid_y(mouse_x, side);
                position = x_to_note_pos(y, side);
                time = y_to_note_time(x, side);
            }
            
            
            if(mouse_check_button_pressed(mb_left) && !_outbound_check(x, y, side)) {
                state = stateDrop;
                origWidth = width;
            }
                
        }
        
        // State Dropping down
        stateDrop = function() {
            stateString = "DROP";
            animTargetA = 0.8;
            if(side == 0)
                width = origWidth + 2.5 * mouse_get_delta_last_x_l() / 300;
            else
                width = origWidth - 2.5 * mouse_get_delta_last_y_l() / 150;
            width = max(width, 0.01);
            _prop_init();
            
            if(mouse_check_button_released(mb_left)) {
                editor_set_width_default(width);
                if(noteType == 2) {
                    var _time = time;
                    state = stateAttachSub;
                    sinst = instance_create_depth(x, y, depth, objHoldSub);
                    sinst.dummy = true;
                    sinst.time = time;
                    return;
                }
                build_note(random_id(6), noteType, time, position, width, -1, side, false);
                instance_destroy();
            }
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
                var _subid = random_id(6);
                build_note(_subid, 3, sinst.time, position, width, -1, side, false);
                build_note(random_id(6), 2, time, position, width, _subid, side, false);
                instance_destroy(sinst);
                instance_destroy();
                sinst = -1;
            }
        }
        
        // State Selected
        stateSelected = function() {
            stateString = "SEL";
            // If Single Select Then Occupy
            objEditor.editorSelectSingleOccupied = true;
            
            if(editor_get_editmode() != 4)
                state = stateNormal;
            if(mouse_check_button_pressed(mb_left) && editor_get_editmode() == 4) {
                if(!_mouse_inbound_check()) {
                    state = stateNormal;
                }
            }
            if(mouse_ishold_l() && _mouse_inbound_check(1)) {
                if(!isDragging) {
                    isDragging = true;
                    origY = y;
                    origX = x;
                }
            }
            if(mouse_check_button_released(mb_left)) {
                if(isDragging) {
                    isDragging = false;
                    note_all_sort();
                }
            }
            if(isDragging) {
                if(side == 0) {
                    y = editor_snap_to_grid_y(origY + mouse_get_delta_last_y_l(), side);
                    x = origX + mouse_get_delta_last_x_l();
                    position = x_to_note_pos(x, side);
                    time = y_to_note_time(y, side);
                }
                else {
                    x = editor_snap_to_grid_y(origX + mouse_get_delta_last_x_l(), side);
                    y = origY + mouse_get_delta_last_y_l();
                    position = x_to_note_pos(y, side);
                    time = y_to_note_time(x, side);
                }
            }
            
            if(keyboard_check_pressed(vk_delete) && noteType != 3)
                note_delete(nid);
        }

    state = stateOut;
    stateString = "OUT";