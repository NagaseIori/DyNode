
// In-Variables

width = 2.0;
position = 2.5;
side = 0;

pWidth = width * 300 - 30; // Width In Pixels
originalWidth = sprite_get_width(sprite_index);

shadow = objShadow;

animSpeed = 0.3;
animTargetA = 1;
image_alpha = 1;

partNumber = 30;

// State Machines

    // State Fadein
    stateIn = function () {
        stateString = "IN";
        animTargetA = 1.0;
        if(image_alpha > 0.98) {
            state = stateNormal;
            image_alpha = 1;
        }
            
    }
    
    // State Normal
    stateNormal = function() {
        stateString = "NM";
        
        if(debug_mode) {
            if(keyboard_check_pressed(vk_f1))
                state = stateOut;
        }
    }
    
    // State Targeted
    stateOut = function() {
        stateString = "OUT";
        
        if(image_alpha == 1.0) {
            // Create Shadow
            var _inst = instance_create_depth(x, y, depth, shadow);
            _inst.nowWidth = pWidth;
            _inst.visible = true;
            
            // Burst Particles
            var _x = x, _y = y, _num = partNumber;
            with(objMain) {
                part_particles_create(partSysNote, _x, _y, partTypeNoteDL, _num/2);
                part_particles_create(partSysNote, _x, _y, partTypeNoteDR, _num/2);
            }
            
            
            image_alpha = 0.0;
            animTargetA = 0.0;
        }
        if(debug_mode) {
            if(keyboard_check_pressed(vk_f1))
                state = stateIn;
        }
    }

state = stateNormal;
stateString = " ";