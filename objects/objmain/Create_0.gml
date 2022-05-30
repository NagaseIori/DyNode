
// Particles

    // PartSys
    partSysNote = part_system_create();
    part_system_automatic_draw(partSysNote, false);

    // PartType
    var _parttype_noted_init = function(_pt) {
        part_type_sprite(_pt, sprParticleW, false, true, false);
        part_type_alpha3(_pt, 1, 0.6, 0);
        part_type_speed(_pt, 7 * global.fpsAdjust
                        , 20 * global.fpsAdjust,
                        -0.15 * global.fpsAdjust, 0);
        part_type_color3(_pt, c_white, c_orange, c_aqua);
        part_type_size(_pt, 0.8, 1.2, -0.02 * global.fpsAdjust, 0);
        part_type_scale(_pt, 2, 2);
        part_type_orientation(_pt, 0, 360, 0.5 * global.fpsAdjust, 0, false);
        part_type_life(_pt, room_speed*0.3, room_speed*0.5);
    }
    
    partTypeNoteDL = part_type_create();
    _parttype_noted_init(partTypeNoteDL);
    partTypeNoteDR = part_type_create();
    _parttype_noted_init(partTypeNoteDR);
    part_type_direction(partTypeNoteDR, 180, 180, 0, 0);
    

// Target Line

targetLineBelow = 137/1080*global.resolutionH;
targetLineBeside = 112/1920*global.resolutionW;
targetLineBelowH = 8;
targetLineBesideW = 6;

_position_update = function () {
    targetLineBelow = 137/1080*global.resolutionH;
    targetLineBeside = 112/1920*global.resolutionW;
}

// Chart Properties

chartTitle = "Last Train at 25 O'Clock"
chartBeatPerMin = 180;
chartBarPerMin = 180/4;
