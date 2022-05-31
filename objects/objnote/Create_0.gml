
depth = 0;

// In-Variables

width = 2.0;
position = 2.5;
side = 0;
offset = 0;
nid = -1; // Note id
sid = -1; // Sub id

pWidth = (width * 300 - 30)*2; // Width In Pixels
originalWidth = sprite_get_width(sprite_index);

shadow = objShadow;

animSpeed = 0.3;
animTargetA = 0;
image_alpha = 0;

partNumber = 40;

_create_shadow = function () {
    // Create Shadow
    var _x = x, _y = global.resolutionH - objMain.targetLineBelow;
    var _inst = instance_create_depth(_x, _y, depth, shadow), _scl = 1;
    _inst.nowWidth = pWidth;
    _inst.visible = true;
    
    // Burst Particles
    var _num = partNumber;
    with(objMain) {
        // _parttype_noted_init(partTypeNoteDL, _scl);
        // _parttype_noted_init(partTypeNoteDR, _scl);
        
        part_particles_create(partSysNote, _x, _y, partTypeNoteDL, _num/2);
        part_particles_create(partSysNote, _x, _y, partTypeNoteDR, _num/2);
    }
}

// State Machines

    // State Fade in
    stateIn = function () {
        stateString = "IN";
        animTargetA = 1.0;
        if(offset <= min(objMain.nowOffset, objMain.animTargetOffset)) {
            state = stateOut;
            _create_shadow();
            state();
        }
        if(image_alpha > 0.98) {
            state = stateNormal;
            image_alpha = 1;
        }
    }
    
    // State Normal
    stateNormal = function() {
        stateString = "NM";
        
        if(offset <= min(objMain.nowOffset, objMain.animTargetOffset)) {
            state = stateOut;
            _create_shadow();
            state();
        }
    }
    
    // State Targeted
    stateOut = function() {
        stateString = "OUT";
        
        image_alpha = 0.0;
        animTargetA = 0.0;
        
        if(offset > objMain.nowOffset) {
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
            
        if(debug_mode) {
            if(keyboard_check_pressed(vk_f1))
                state = stateIn;
        }
    }

state = stateOut;
stateString = " ";