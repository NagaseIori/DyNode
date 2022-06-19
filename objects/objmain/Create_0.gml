
// Shaders

    shaderBlur = shd_gaussian_blur_2pass;
    u_size = shader_get_uniform(shaderBlur, "size");
    u_blur_vector = shader_get_uniform(shaderBlur, "blur_vector");

// Make Original Background Layer Invisible

    layer_set_visible(layer_get_id("Background"), false);

#region Layouts Init

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

#endregion

#region Mixer
    
    mixerX = array_create(2, global.resolutionH/2);
    mixerNextX = array_create(2, note_pos_to_x(2.5, 1));
    mixerSpeed = 0.5;
    mixerMaxSpeed = 250; // px per frame
    mixerNextNote = [-1, -1]

#endregion

#region Chart Properties

    chartTitle = "Last Train at 25 O'Clock"
    chartBeatPerMin = 180;
    chartBarPerMin = 180/4;
    chartBarOffset = 0;
    chartTimeOffset = 0;
    chartDifficulty = 0;
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

#endregion

#region Playview Properties

    themeColor = 0xFFFF00;
    themeColor = 0xc5b7ff; // Sakura pink ❤

    nowBar = 0;
    nowMusicTime = 0;
    nowTime = 0;
    nowPlaying = false;
    nowScore = 0;
    nowCombo = 0;
    playbackSpeed = 1.6;
    adtimeSpeed = 50.0; // Use AD to Adjust Time ms per frame
    scrolltimeSpeed = 300.0; // Use mouse scroll to Adjust Time ms per frame
    
    animSpeed = 0.3;
    animTargetTime = 0;
    animTargetPlaybackSpeed = playbackSpeed;
    
    musicProgress = 0.0;
    musicSpeed = 1.0;
    
    hideScoreboard = false;
    
    // Bottom
        bottomDim = 0.75;
        bottomBgSurf = -1;
        bottomBgSurfPing = -1;
        bottomBgBlurAmount = 20;
        bottomBgBlurSigma = 10;
    
    // Background
        bgDim = 0.65;
        
        // Image
        bgImageFile = "";
        bgImageSpr = -1;
        bgFaintAlpha = 0.5;
        animTargetBgFaintAlpha = 0.5; 
        animSpeedFaint = 0.1;
        
        _faint_hit = function() {
            bgFaintAlpha = 0.7;
        }

#endregion

#region Particles Init

    // PartSys
    partSysNote = part_system_create();
    partAlphaMul = 0.75;
    part_system_automatic_draw(partSysNote, false);

    // PartType
    
        // Note
        _parttype_noted_init = function(_pt, _scl = 1.0, _ang = 0.0) {
            part_type_sprite(_pt, sprParticleW, false, true, false);
            part_type_alpha3(_pt, partAlphaMul, 0.6 * partAlphaMul, 0);
            part_type_speed(_pt, _scl * 3 * global.fpsAdjust
                            , _scl * 25 * global.fpsAdjust,
                            _scl * -0.25 * global.fpsAdjust, 0);
            // part_type_color3(_pt, c_white, c_orange, c_aqua);
            part_type_color2(_pt, 0x652dba, themeColor);
            part_type_size(_pt, 0.5, 0.8, -0.01 * global.fpsAdjust, 0);
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
            part_type_alpha3(_pt, 0.3 * partAlphaMul, 0.3 * 0.6 * partAlphaMul, 0);
            part_type_speed(_pt, _scl * 3 * global.fpsAdjust
                            , _scl * 15 * global.fpsAdjust,
                            _scl * -0.25 * global.fpsAdjust, 0);
            part_type_color2(_pt, 0x16925a, themeColor);
            // part_type_color2(_pt, 0x89ffff, 0xffffe5)
            part_type_size(_pt, 0.8, 1.2, -0.02 * global.fpsAdjust, 0);
            // part_type_scale(_pt, _scl * 2, _scl * 2);
            part_type_orientation(_pt, 0, 360, 0.5 * global.fpsAdjust, 0, false);
            part_type_life(_pt, room_speed*0.3, room_speed*0.5);
            part_type_blend(_pt, true);
            part_type_direction(_pt, _ang, _ang+180, 0, 0);
        }
        partTypeHold = part_type_create();
        _parttype_hold_init(partTypeHold);
        
    // Part Emitter
    
        partEmitHold = part_emitter_create(partSysNote);
        _partemit_hold_init = function(_pe, _x1, _y1, _x2, _y2) {
            part_emitter_region(partSysNote, _pe, _x1, _y1, _x2, _y2, 
                ps_shape_line, ps_distr_linear);
        }

#endregion

#region Scoreboard Init

    scbDepth = 1000;
    scbLeft = create_scoreboard(resor_to_x(0.29), resor_to_y(0.54),
        scbDepth, 7, fa_middle, 0);
    scbRight = create_scoreboard(resor_to_x(0.88), resor_to_y(0.54),
        scbDepth, 0, fa_right, 3);

#endregion

#region Perfect Indicator Init

    perfDepth = 1000;
    perfLeft = instance_create_depth(resor_to_x(0.262), resor_to_y(0.635), 
        perfDepth, objPerfectIndc);
    perfRight = instance_create_depth(resor_to_x(0.748), resor_to_y(0.635), 
        perfDepth, objPerfectIndc);
        
#endregion

#region Editor Init

    editor = instance_create_depth(0, 0, -10000, objEditor);

#endregion

// FMODGMS Related

    channel = FMODGMS_Chan_CreateChannel();
    music = undefined;
    sampleRate = 0;
    channelPaused = false; // Only used for time correction
    musicLength = 0;

// Scribble Related

    titleElement = undefined;

// Init

    map_init(true);