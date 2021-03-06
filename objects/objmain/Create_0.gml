
depth = 0;

// Shaders

    shaderBlur = shd_gaussian_blur_2pass;
    u_size = shader_get_uniform(shaderBlur, "size");
    u_blur_vector = shader_get_uniform(shaderBlur, "blur_vector");

// Make Original Background Layer Invisible

    layer_set_visible(layer_get_id("Background"), false);

#region Time Sources
	
	// To prevent unstable delay from music to chart
	var _tsFun = function() {
		nowPlaying = true;
		nowTime = sfmod_channel_get_position(channel, sampleRate);
	};
	resumeDelay = 15;
	timesourceResumeDelay =
		time_source_create(time_source_game, resumeDelay/1000,
		time_source_units_seconds, _tsFun, [], 1, time_source_expire_after);
	
#endregion

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

    themeColor = theme_get().color;

    nowBar = 0;
    nowTime = 0;
    nowPlaying = false;
    nowScore = 0;
    nowCombo = 0;
    playbackSpeed = 1.6;
    adtimeSpeed = 50.0; // Use AD to Adjust Time ms per frame
    scrolltimeSpeed = 300.0; // Use mouse scroll to Adjust Time ms per frame
    
    particlesEnabled = true;
    
    animSpeed = 0.3;
    animTargetTime = 0;
    animTargetPlaybackSpeed = playbackSpeed;
    
    musicProgress = 0.0;
    musicSpeed = 1.0;
    
    hideScoreboard = true;			// hide score board under editor mode
    hitSoundOn = false;
    
    showDebugInfo = debug_mode;
    
    // For 3 sides targetline's glow
    lazerAlpha = [1.0, 1.0, 1.0];
    animTargetLazerAlpha = lazerAlpha;
    
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
        bgFaintAlpha = 0.75;
        animCurvFaintChan = animcurve_get_channel(curvBgGlow, "curve1");
        animCurvFaintEval = 0.5;
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
        	var _theme = theme_get();
            part_type_sprite(_pt, _theme.partSpr, false, true, false);
            if(_theme.partBlend)
            	part_type_alpha3(_pt, partAlphaMul, 0.6 * partAlphaMul, 0);
            else
            	part_type_alpha3(_pt, 1, 0.6, 0);
            
            part_type_speed(_pt, _scl * 10 * global.fpsAdjust
                            , _scl * 30 * global.fpsAdjust,
                            _scl * -0.5 * global.fpsAdjust, 0);
            part_type_color3(_pt, _theme.partColA, _theme.partColB, themeColor);
            //part_type_color2(_pt, 0x652dba, themeColor);
            part_type_size(_pt, 0.5, 0.8, -0.01 * global.fpsAdjust, 0);
            part_type_scale(_pt, _scl * 2, _scl * 2);
            part_type_orientation(_pt, 0, 360, 0.5 * global.fpsAdjust, 0, false);
            part_type_life(_pt, room_speed*0.2, room_speed*0.4);
            part_type_blend(_pt, _theme.partBlend);
            part_type_direction(_pt, _ang, _ang, 0, 0);
        }
        
        partTypeNoteDL = part_type_create();
        _parttype_noted_init(partTypeNoteDL);
        partTypeNoteDR = part_type_create();
        _parttype_noted_init(partTypeNoteDR, 1, 180);
        
        // Hold
        _parttype_hold_init = function(_pt, _scl = 1.0, _ang = 0.0) {
        	var _theme = theme_get();
            part_type_sprite(_pt, _theme.partSpr, false, true, false);
            if(_theme.partBlend)
            	part_type_alpha3(_pt, 0.6 * partAlphaMul, 0.6 * 0.6 * partAlphaMul, 0);
            else
            	part_type_alpha3(_pt, 1, 0.6, 0);
            part_type_speed(_pt, _scl * 15 * global.fpsAdjust
                            , _scl * 20 * global.fpsAdjust,
                            _scl * -0.3 * global.fpsAdjust, 0);
            part_type_color2(_pt, _theme.partColHA, _theme.partColHB);
            // part_type_color2(_pt, 0x89ffff, 0xffffe5)
            part_type_size(_pt, 0.8, 1.2, -0.02 * global.fpsAdjust, 0);
            // part_type_scale(_pt, _scl * 2, _scl * 2);
            part_type_orientation(_pt, 0, 360, 0.5 * global.fpsAdjust, 0, false);
            part_type_life(_pt, room_speed*0.2, room_speed*0.4);
            part_type_blend(_pt, _theme.partBlend);
            part_type_direction(_pt, _ang, _ang+180, 0, 0);
        }
        partTypeHold = part_type_create();
        _parttype_hold_init(partTypeHold);
        
    // Part Emitter
    
        partEmit = part_emitter_create(partSysNote);
        _partemit_init = function(_pe, _x1, _y1, _x2, _y2) {
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
    perfLeft = instance_create_depth(resor_to_x(0.27), resor_to_y(0.64), 
        perfDepth, objPerfectIndc);
    perfRight = instance_create_depth(resor_to_x(0.744), resor_to_y(0.64), 
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

// Init

    map_init(true);