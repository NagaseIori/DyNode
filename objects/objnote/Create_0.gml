
visible = false;
depth = 100;

// In-Variables

    width = 2.0;
    position = 2.5;
    side = 0;
    offset = 0;
    nid = -1; // Note id
    sid = -1; // Sub id
    noteType = 0; // 0 Note 1 Chain 2 Hold
    
    // For Hold
    lastOffset = 0;
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
    partNumber = 20;
    partNumberLast = 6;
    
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
        var _ang = image_angle;
        with(objMain) {
            if(_type == 0) {
                _parttype_noted_init(partTypeNoteDL, 1, _ang);
                _parttype_noted_init(partTypeNoteDR, 1, _ang+180);
                
                part_particles_create(partSysNote, _x, _y, partTypeNoteDL, _num/2);
                part_particles_create(partSysNote, _x, _y, partTypeNoteDR, _num/2);
            }
            else if(_type == 1) {
                _parttype_hold_init(partTypeHold, 1, _ang);
                
                part_particles_create(partSysNote, _x, _y, partTypeHold, _num);
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
        var _inst = instance_create_depth(_x, _y, depth, _shadow), _scl = 1;
        _inst.nowWidth = pWidth;
        _inst.visible = true;
        _inst.image_angle = image_angle;
        
        _burst_particle(partNumber, 0);
    }
    
    // _outbound_check = function (_x, _y, _side) {
    //     if(_side == 0 && _y < -100)
    //         return true;
    //     else if(_side == 1 && _x >= global.resolutionW / 2)
    //         return true;
    //     else if(_side == 2 && _x <= global.resolutionW / 2)
    //         return true;
    //     else
    //         return false;
    // }

// State Machines

    // State Fade in
    stateIn = function () {
        
        stateString = "IN";
        animTargetA = 1.0;
        animTargetLstA = lastAlphaL;
        
        var _limOffset = min(objMain.nowOffset, objMain.animTargetOffset);
        if(offset <= _limOffset) {
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
        var _limOffset = min(objMain.nowOffset, objMain.animTargetOffset);
        stateString = "NM";
        
        if(offset <= _limOffset) {
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
        
        var _limOffset = min(objMain.nowOffset, objMain.animTargetOffset);
        if(offset + lastOffset <= _limOffset) {
            state = stateOut;
            image_alpha = lastOffset == 0 ? 0 : image_alpha;
            state();
        }
        else _burst_particle(ceil(partNumberLast * global.fpsAdjust), 1, true);
        
        if(offset > objMain.nowOffset) {
            state = stateIn;
            state();
        }
    }
    
    // State Targeted
    stateOut = function() {
        stateString = "OUT";
        
        animTargetA = 0.0;
        animTargetLstA = lastAlphaL;
        
        if(offset + lastOffset> objMain.nowOffset && !_outbound_check(x, y, side)) {
            // If is using ad to adjust time then speed the things hell up
            if(keyboard_check(ord("A")) || keyboard_check(ord("D")) || 
                objMain.topBarMousePressed) {
                image_alpha = 1;
                animTargetA = 1;
                state = stateNormal;
            }
            else 
                state = stateIn;
            state();
        }
    }

    state = stateOut;
    stateString = "OUT";

// Debug Draw Function

    _debug_draw = function() {
        if(debug_mode) {
            // scribble(stateString+" "+string(nid)+"\n"+string(position)).starting_format("fDynamix20", c_white)
            // .align(fa_left, fa_middle)
            // .draw(round(x + pWidth/2), y);
            
            // draw_set_color(c_red);
            // draw_line(x - pWidth/2, y, x + pWidth/2, y);
            
            // draw_set_color(c_red);
            // draw_circle(x, y, 5, 0);
        }
    }