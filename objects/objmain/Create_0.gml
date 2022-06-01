
// Particles

    // PartSys
    partSysNote = part_system_create();
    part_system_automatic_draw(partSysNote, false);

    // PartType
    
        // Note
        _parttype_noted_init = function(_pt, _scl = 1.0, _ang = 0.0) {
            part_type_sprite(_pt, sprParticleW, false, true, false);
            part_type_alpha3(_pt, 0.3, 0.3*0.6, 0);
            part_type_speed(_pt, _scl * 3 * global.fpsAdjust
                            , _scl * 25 * global.fpsAdjust,
                            _scl * -0.25 * global.fpsAdjust, 0);
            // part_type_color3(_pt, c_white, c_orange, c_aqua);
            part_type_color2(_pt, 0x652dba, c_aqua);
            part_type_size(_pt, 0.8, 1.2, -0.02 * global.fpsAdjust, 0);
            part_type_scale(_pt, _scl * 2, _scl * 2);
            part_type_orientation(_pt, 0, 360, 0.5 * global.fpsAdjust, 0, false);
            part_type_life(_pt, room_speed*0.3, room_speed*0.5);
            part_type_blend(_pt, true);
            part_type_direction(_pt, _ang, _ang, 0, 0);
        }
        
        partTypeNoteDL = part_type_create();
        _parttype_noted_init(partTypeNoteDL);
        partTypeNoteDR = part_type_create();
        _parttype_noted_init(partTypeNoteDR, 1, 180);
        
        // Hold
        _parttype_hold_init = function(_pt, _scl = 1.0, _ang = 0.0) {
            part_type_sprite(_pt, sprParticleW, false, true, false);
            part_type_alpha3(_pt, 0.3, 0.3*0.6, 0);
            part_type_speed(_pt, _scl * 3 * global.fpsAdjust
                            , _scl * 10 * global.fpsAdjust,
                            _scl * -0.1 * global.fpsAdjust, 0);
            part_type_color2(_pt, c_green, c_aqua);
            part_type_size(_pt, 0.8, 1.2, -0.02 * global.fpsAdjust, 0);
            // part_type_scale(_pt, _scl * 2, _scl * 2);
            part_type_orientation(_pt, 0, 360, 0.5 * global.fpsAdjust, 0, false);
            part_type_life(_pt, room_speed*0.3, room_speed*0.5);
            part_type_blend(_pt, true);
            part_type_direction(_pt, _ang, _ang+180, 0, 0);
        }
        partTypeHold = part_type_create();
        _parttype_hold_init(partTypeHold);

        
    

// Target Line

    targetLineBelow = 137*global.resolutionH/1080;
    targetLineBeside = 112*global.resolutionW/1920;
    targetLineBelowH = 8;
    targetLineBesideW = 6;
    
    _position_update = function () {
        targetLineBelow = 137*global.resolutionH/1080;
        targetLineBeside = 112*global.resolutionW/1920;
    }

// Top Progress Bar

    topBarH = 5*global.resolutionH/1080;
    topBarMouseH = 20*global.resolutionH/1080;
    topBarMousePressed = false;
    topBarMouseLastX = 0;
    topBarIndicatorA = 0;
    animTargetTopBarIndicatorA = 0;

// Mixer
    
    mixerX = array_create(2, global.resolutionH/2);
    mixerNextX = array_create(2, note_pos_to_x(2.5, 1));
    mixerSpeed = 0.5;
    mixerMaxSpeed = 250; // px per frame
    mixerNextNote = [-1, -1]

// Chart Properties

    chartTitle = "Last Train at 25 O'Clock"
    chartBeatPerMin = 180;
    chartBarPerMin = 180/4;
    chartOffset = 0;
    chartDifficulty = "CASUAL";
    chartSideType = ["MIXER", "MULTI"];
    chartID = "";
    chartMusicFile = "";
    chartFile = "";
    
    chartNotesArray = [];
    chartNotesArrayAt = 0;
    chartNotesCount = 0;
    chartNotesMap = array_create(3);
    for(var i=0; i<3; i++)
        chartNotesMap[i] = ds_map_create();

// Playview Properties

    nowOffset = 0;
    nowTime = 0;
    nowPlaying = false;
    nowScore = 0;
    nowCombo = 0;
    playbackSpeed = 1600.0;
    adtimeSpeed = 50.0; // Use AD to Adjust Time ms per frame
    scrolltimeSpeed = 300.0; // Use mouse scroll to Adjust Time ms per frame
    
    animSpeed = 0.3;
    animTargetOffset = chartOffset;
    
    musicProgress = 0.0;
    musicSpeed = 1.0;

// Scoreboard Related

    scbDepth = 1000;
    scbLeft = create_scoreboard(global.resolutionW * 0.29,
                global.resolutionH * 0.54, scbDepth, 7, fa_middle);
    scbRight = create_scoreboard(global.resolutionW * 0.88,
                global.resolutionH * 0.54, scbDepth, 0, fa_right);

// FMODGMS Related

    channel = FMODGMS_Chan_CreateChannel();
    music = undefined;
    sampleRate = 0;
    channelPaused = false; // Only used for time correction
    musicLength = 0;

// Scribble Related

    titleElement = undefined;

// In-Functions

    _offset_to_time = function (offset) {
        return (offset - chartOffset) / chartBarPerMin * 60 * 1000;
    }
    _time_to_offset = function (time) {
        return time / 60000 * chartBarPerMin + chartOffset;
    }

// Init

    map_init();