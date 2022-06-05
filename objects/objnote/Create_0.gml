
visible = false;
depth = 100;

// In-Variables

    width = 2.0;
    origWidth = width; // For editor
    position = 2.5;
    side = 0;
    // offset = 0;
    bar = 0;
    time = 0;
    nid = -1; // Note id
    sid = -1; // Sub id
    noteType = 0; // 0 Note 1 Chain 2 Hold
    
    // For Hold
    lastTime = 0;
    lastAlphaL = 0.4;
    lastAlphaR = 1.0;
    lastAlpha = lastAlphaL;
    
    pWidth = (width * 300 - 30)*2; // Width In Pixels
    originalWidth = sprite_get_width(sprite_index);
    
    animSpeed = 0.4;
    animTargetA = 0;
    animTargetLstA = lastAlpha;
    image_alpha = 0;
    
    // Particles Number
    partNumber = 40;
    partNumberLast = 1;
    
    // Correction Values
    lFromLeft = 5;
    rFromRight = 5;

// In-Functions

    _prop_init = function () {
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
        if(side > 0 && objMain.chartSideType[side-1] == "MIXER")
            _shadow = objShadowMIX;
        var _inst = instance_create_depth(_x, _y, 1, _shadow), _scl = 1;
        _inst.nowWidth = pWidth;
        _inst.visible = true;
        _inst.image_angle = image_angle;
        
        _burst_particle(partNumber, 0);
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
            animTargetA = 0.5;
            x = mouse_x;
            y = !objEditor.editorGridYEnabled?mouse_y:objEditor.editorGridYMousePos;
            position = x_to_note_pos(x, side);
            time = y_to_note_time(y, side);
            if(mouse_check_button_pressed(mb_left)) {
                state = stateDrop;
                origWidth = width;
            }
                
        }
        
        // State Dropping down
        stateDrop = function() {
            animTargetA = 1;
            width = origWidth + 2.5 * mouse_get_delta_lx() / 300;
            width = max(width, 0.01);
            _prop_init();
            
            if(mouse_check_button_released(mb_left)) {
                build_note(random_id(6), noteType, time, position, width, -1, side, false);
                instance_destroy();
            }
        }

    state = stateOut;
    stateString = "OUT";

// Debug Draw Function

    _debug_draw = function() {
        if(debug_mode) {
            
        }
    }