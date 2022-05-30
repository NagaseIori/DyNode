
// Particles

    // PartSys
    partSysNote = part_system_create();
    part_system_automatic_draw(partSysNote, false);

    // PartType
    _parttype_noted_init = function(_pt, _scl = 1.0) {
        part_type_sprite(_pt, sprParticleW, false, true, false);
        part_type_alpha3(_pt, 0.6, 0.36, 0);
        part_type_speed(_pt, _scl * 3 * global.fpsAdjust
                        , _scl * 25 * global.fpsAdjust,
                        _scl * -0.25 * global.fpsAdjust, 0);
        part_type_color3(_pt, c_white, c_orange, c_aqua);
        part_type_size(_pt, 0.8, 1.2, -0.02 * global.fpsAdjust, 0);
        part_type_scale(_pt, _scl * 2, _scl * 2);
        part_type_orientation(_pt, 0, 360, 0.5 * global.fpsAdjust, 0, false);
        part_type_life(_pt, room_speed*0.3, room_speed*0.5);
    }
    
    partTypeNoteDL = part_type_create();
    _parttype_noted_init(partTypeNoteDL);
    partTypeNoteDR = part_type_create();
    _parttype_noted_init(partTypeNoteDR);
    part_type_direction(partTypeNoteDR, 180, 180, 0, 0);
    

// Target Line

targetLineBelow = 137*global.resolutionH/1080;
targetLineBeside = 112*global.resolutionW/1920;
targetLineBelowH = 8;
targetLineBesideW = 6;

_position_update = function () {
    targetLineBelow = 137*global.resolutionH/1080;
    targetLineBeside = 112*global.resolutionW/1920;
}

// Chart Properties

chartTitle = "Last Train at 25 O'Clock"
chartBeatPerMin = 180;
chartBarPerMin = 180/4;
chartOffset = 0;
chartDifficulty = "CASUAL";
chartLeftType = "MIXER";
chartRightType = "MULTI";
chartID = "";
chartMusicFile = "";
chartFile = "";

// Playview Properties

nowOffset = 0;
nowTime = 0;
nowPlaying = false;
playbackSpeed = 1000.0;
adtimeSpeed = 200.0; // Use AD to Adjust Time ms per frame
scrolltimeSpeed = 750.0; // Use mouse scroll to Adjust Time ms per frame

animSpeed = 0.3;
animTargetOffset = chartOffset;

// FMODGMS Related

channel = FMODGMS_Chan_CreateChannel();
music = undefined;
sampleRate = 0;
channelPaused = false; // Only used for time correction
musicLength = 0;
