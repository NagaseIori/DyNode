/// @description Startup Initialization

// Macros

#macro BASE_RES_W 1920
#macro BASE_RES_H 1080
#macro BASE_FPS 60
#macro MAXIMUM_DELAY_OF_SOUND 20        	// in ms
#macro EPS 0.001
#macro MIXER_REACTION_RANGE 0.35			// Mixer's reaction pixel range's ratio of resolutionW
#macro NOTE_DEACTIVATION_TIME 20			// Every fixed time than deactivated notes in queue
#macro NOTE_DEACTIVATION_LIMIT 100			// if notes' being deactivated number exceeds the limit than excecute immediately

// Global Configs

global.configPath = program_directory + "config.json";

global.version = "v0.1.7.1"

global.resolutionW = 1920
global.resolutionH = 1080
global.fps = display_get_frequency();
global.autosave = false;
global.autoupdate = true;
global.fullscreen = false;
global.FMOD_MP3_DELAY = 60;
global.ANNOUNCEMENT_MAX_LIMIT = 7;

// Themes Init

theme_init();

// Localization Init

i18n_init();

// Load Settings

// if(debug_mode) save_config();

_lastConfig_md5 = load_config();

// Global Variables

global.difficultyName = ["CASUAL", "NORMAL", "HARD", "MEGA", "GIGA", "TERA"];
global.difficultySprite = [sprCasual, sprNormal, sprHard, sprMega, sprGiga, sprTera];
global.difficultyString = "CNHMGT";
global.difficultyCount = string_length(global.difficultyString);

global.noteTypeName = ["NORMAL", "CHAIN", "HOLD", "SUB"];

// Generate Temp Sprite

global.sprLazer = generate_lazer_sprite(2000);

// Set GUI & Window Resolution

surface_resize(application_surface, global.resolutionW, global.resolutionH);
display_set_gui_size(global.resolutionW, global.resolutionH);

// Smoother

gpu_set_tex_filter(true);
gc_target_frame_time(50);

// FMODGMS Initialization

    // Optional: Check to see if FMODGMS has loaded properly
    if (FMODGMS_Util_Handshake() != "FMODGMS is working.") {
        announcement_error("FMOD_load_err");
    }
    
    // Create the system
    if (FMODGMS_Sys_Create() < 0) {
        show_error_async(i18n_get("FMOD_create_sys_err") + FMODGMS_Util_GetErrorMessage(), false);
    }
    
    // Initialize the system
    FMODGMS_Sys_Set_DSPBufferSize(512, 4);
    FMODGMS_Sys_Initialize(32);
    // FMODGMS_Sys_Set_SoftwareFormat(48000, 0);
    

// Input Initialization

instance_create(x, y, objInput);

// Fonts Initialization

global._notoFont = font_add("fonts/NotoSansCJKkr-Black.otf", 30, false, false, 32, 65535);
scribble_anim_cycle(0.2, 255, 255);
scribble_font_bake_shadow("fOrbitron48", "fOrbitron48s", 0, 10, c_black, 0.4, 0, true);
scribble_font_bake_shadow("fDynamix16", "fDynamix16s", 0, 2, c_black, 0.3, 0, true);
scribble_font_bake_outline_8dir("fDynamix16", "fDynamix16o", c_white, true);
	// Prefetch Msdf Fonts' Texture (this takes time)
	var _texarr = texturegroup_get_textures("texFonts");
	for(var i=0, l=array_length(_texarr); i<l; i++) {
		texture_prefetch(_texarr[i]);
	}

// Window Frame Init

_windowframe_inited = false;

// Randomize

randomize();

// Check For Update

if(global.autoupdate && !string_last_pos("dev", global.version))
	_update_get = http_get("https://api.github.com/repos/NagaseIori/DyNode/releases/latest");
_update_url = "";

// Init finished

if(debug_mode) room_goto(rMain);
else
	room_goto(rStartPage);

#region Project Properties

	projectPath = "";
	backgroundPath = "";
	musicPath = "";
	chartPath = "";
	
#endregion

#region Inner Variables

	// For Announcement
	announcements = [];
	annoThresholdNumber = 7;
	annoThresholdTime = 400;
	annosY = [];
	animAnnoSpeed = 1 / room_speed;
	
	initVars = undefined;
	initWithProject = false;
	
	var _auto_save = function () {
		if(projectPath != "")
			project_save();
		announcement_play("autosave_complete");
	}
	tsAutosave = time_source_create(time_source_game, 60*5, time_source_units_seconds, _auto_save, [], -1);
	if(global.autosave) {
		global.autosave = false;
		switch_autosave();
	}
	
	// For config.json update
	
	tsConfigLiveChange = time_source_create(time_source_game, 1, time_source_units_seconds, 
		function() {
			with(objManager)
				if(_lastConfig_md5 != md5_config()) {
					_lastConfig_md5 = load_config();
					show_debug_message("MD5: "+_lastConfig_md5);
					announcement_play("检测到配置被更改，改变后的一部分配置已经生效。");
				}
		}
		, [], -1);
	// time_source_start(tsConfigLiveChange);

#endregion