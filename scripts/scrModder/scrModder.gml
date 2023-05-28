function sDyNodeModder() constructor {
    
    /// Modder Setup
    modding_directory = program_directory+"/Plugins";
    modding_directory = file_path_fix(modding_directory);
    mods = {};
    
    /// Catspeak Setup
    var configs = catspeak_config();
    configs.processTimeLimit = 10;      // by default limit one process to 10 seconds
    
    /// Catspeak Library Setup
    catspeak_add_function("anno", modlib_anno);
    
    /// Catspeak Read And Compile
    
    // Compilation Callback Function
    static compile_callback_andthen = function(code) {
        
    }
    
    if(directory_exists(modding_directory)) {
        var _f = file_find_first(modding_directory + "/*.cat", 0);
        var _buf = buffer_load(_f);
        var _proc = catspeak_compile_buffer(_buf, true);
    }
    else directory_create(modding_directory)
    
}

// Mod Library Function modlib_anno()
// To create an announcement.
// text: Announcement content
// aID: used for announcement update.
function modlib_anno(text, aid="") {
    announcement_play(text, 3000, aid);
}