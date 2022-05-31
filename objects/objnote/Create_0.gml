
depth = 100;

// In-Variables

    width = 2.0;
    position = 2.5;
    side = 0;
    offset = 0;
    nid = -1; // Note id
    sid = -1; // Sub id
    
    // For Hold
    lastOffset = 0;
    lastAlphaL = 0.4;
    lastAlphaR = 1.0;
    lastAlpha = lastAlphaL;
    
    pWidth = (width * 300 - 30)*2; // Width In Pixels
    originalWidth = sprite_get_width(sprite_index);
    
    shadow = objShadow;
    
    animSpeed = 0.3;
    animTargetA = 0;
    animTargetLstA = lastAlpha;
    image_alpha = 0;
    
    partNumber = 40;
    partNumberLast = 3;
    
    // Correction Values
    lFromLeft = 5;
    rFromRight = 5;

// In-Functions

    _burst_particle = function(_num) {
        // Burst Particles
        var _x = x, _y = global.resolutionH - objMain.targetLineBelow;
        with(objMain) {
            // _parttype_noted_init(partTypeNoteDL, _scl);
            // _parttype_noted_init(partTypeNoteDR, _scl);
            
            part_particles_create(partSysNote, _x, _y, partTypeNoteDL, _num/2);
            part_particles_create(partSysNote, _x, _y, partTypeNoteDR, _num/2);
        }
    }

    _create_shadow = function () {
        // Create Shadow
        var _x = x, _y = global.resolutionH - objMain.targetLineBelow;
        var _inst = instance_create_depth(_x, _y, depth, shadow), _scl = 1;
        _inst.nowWidth = pWidth;
        _inst.visible = true;
        
        _burst_particle(partNumber);
    }

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
        // If is using ad to adjust time then speed the things hell up
        if(keyboard_check(ord("A")) || keyboard_check(ord("D"))) {
            image_alpha = 1;
            animTargetA = 1;
            state = stateNormal;
        }
        else if(image_alpha > 0.98) {
            state = stateNormal;
            image_alpha = 1;
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
    }
    
    // State Last (For Hold)
    stateLast = function () {
        stateString = "LST";
        animTargetLstA = lastAlphaR;
        
        var _limOffset = min(objMain.nowOffset, objMain.animTargetOffset);
        if(offset + lastOffset <= _limOffset) {
            state = stateOut;
            state();
        }
        else _burst_particle(partNumberLast);
        
        if(offset > objMain.nowOffset) {
            state = stateIn;
            state();
        }
    }
    
    // State Targeted
    stateOut = function() {
        stateString = "OUT";
        
        image_alpha = 0.0;
        animTargetA = 0.0;
        animTargetLstA = lastAlphaL;
        
        if(offset + lastOffset> objMain.nowOffset) {
            // If is using ad to adjust time then speed the things hell up
            if(keyboard_check(ord("A")) || keyboard_check(ord("D"))) {
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
    stateString = " ";

// Debug Draw Function

    _debug_draw = function() {
        if(debug_mode) {
            scribble(stateString+" "+string(nid)+"\n"+string(position)).starting_format("fDynamix20", c_white)
            .align(fa_left, fa_middle)
            .draw(round(x + pWidth/2), y);
            
            draw_set_color(c_red);
            draw_line(x - pWidth/2, y, x + pWidth/2, y);
        }
    }