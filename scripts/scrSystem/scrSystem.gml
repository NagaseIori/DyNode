
#region MAP FUNCTIONS

function map_close() {
	
	with(objMain) {
		surface_free_f(bottomBgSurf);
		surface_free_f(bottomBgSurfPing);
		
		note_delete_all();
		instance_destroy(objScoreBoard);
		instance_destroy(objPerfectIndc);
		instance_destroy(objEditor);
		
		time_source_destroy(timesourceResumeDelay);
		part_emitter_destroy_all(partSysNote);
		part_system_destroy(partSysNote);
		part_type_destroy(partTypeNoteDL);
		part_type_destroy(partTypeNoteDR);
		
		if(bgImageSpr != -1)
		    sprite_delete(bgImageSpr);
		
		for(var i=0; i<3; i++)
		    ds_map_destroy(chartNotesMap[i]);
		
		if(!is_undefined(music)) {
			FMODGMS_Snd_Unload(music);
			FMODGMS_Chan_RemoveChannel(channel);
		}
	}
	
	instance_destroy(objMain);
}

// After loading map, map_init is called to init objMain again.
function map_init(_skipnote = false) {
        
    with(objMain) {
        // By default set chart's bpm from bar
        chartBeatPerMin = chartBarPerMin * 4;
        
        // Get Time Offset
        chartTimeOffset = bar_to_time(chartBarOffset);
        var _offset = chartTimeOffset;
        
        // Fix every note's time
        if(!_skipnote)
        if(instance_exists(objNote)) {
            with(objNote) {
                time = bar_to_time(bar);        	// Bar to Chart Time in ms
                time = time_to_mtime(time);         // Chart Time to Music Time in ms (Fix the offset to 0)
                
                if(noteType == 2)
                	_prop_hold_update();			// Hold prop init
            }
        }
        
        // Update notesArray
        notes_array_update();
        
        chartTimeOffset = 0;                        // Set the offset to 0
        
        // Reset to the beginning
        nowTime = 0;                                // Now music time equals chart time
        animTargetTime = nowTime;
        
        // Sort Notes Array base on time
        note_all_sort();
        
        // Get the chart's difficulty
        chartDifficulty = difficulty_char_to_num(string_char_at(chartID, string_length(chartID)));
        
        // Initialize Timing Points
        timing_point_reset();
        timing_point_add(
            _offset, bpm_to_mspb(chartBeatPerMin), 4);
    }
    
}

function map_load(_file = "") {
	
	if(_file == "")
	    _file = get_open_filename_ext("XML Files (*.xml)|*.xml", "example.xml", 
	        program_directory, "Load Dynamix Chart File 加载谱面文件");
        
    if(_file == "") return;
    
    map_close();
    instance_create_depth(0, 0, 0, objMain);
    
    if(!file_exists(_file)) {
        show_error("Map file " + _file + " doesnt exist.", false);
        return;
    }
    
    if(filename_ext(_file) == ".xml")
        map_load_xml(_file);
    
    map_init();
    objManager.chartPath = _file;
    
    show_debug_message("Load map sucessfully.");
}

function map_load_xml(_file) {
    DerpXmlRead_OpenFile(_file);
    
    var _stack = [];
    var _line = 0;
    var _in_notes = 0;
    var _in_left = 0;
    var _in_right = 0;
    var _in_assets = 0;
    var _note_id, _note_type, _note_time,
        _note_position, _note_width, _note_subid;
    while DerpXmlRead_Read() {
        _line ++;
        switch DerpXmlRead_CurType() {
            case DerpXmlType_OpenTag:
                array_push(_stack, DerpXmlRead_CurValue());
                switch DerpXmlRead_CurValue() {
                    case "m_notes":
                        _in_notes ++;
                        break;
                    case "m_notesLeft":
                        _in_left ++;
                        break;
                    case "m_notesRight":
                        _in_right ++;
                        break;
                    case "CMapNoteAsset":
                        _in_assets ++;
                        break;
                }
                break;
            case DerpXmlType_CloseTag:
                var _top = array_pop(_stack);
                if(_top != DerpXmlRead_CurValue()) {
                    show_error("Closetag error\nLine: " + string(_line) +
                        "\nWrong Tag Match: " + _top + " --- " + 
                        DerpXmlRead_CurValue(), true);
                }
                switch DerpXmlRead_CurValue() {
                    case "m_notes":
                        _in_notes --;
                        break;
                    case "m_notesLeft":
                        _in_left --;
                        break;
                    case "m_notesRight":
                        _in_right --;
                        break;
                    case "CMapNoteAsset":
                        _in_assets --;
                        var _err = build_note(_note_id, _note_type, _note_time,
                            _note_position, _note_width, _note_subid,
                            _in_left + _in_right*2);
                        if(_err) return;
                        break;
                }
                break;
            case DerpXmlType_Text:
                var _val = DerpXmlRead_CurValue();
                switch array_top(_stack) {
                    case "m_path":
                        objMain.chartTitle = _val;
                        break;
                    case "m_barPerMin":
                        objMain.chartBarPerMin = real(_val);
                        break;
                    case "m_timeOffset":
                        objMain.chartBarOffset = real(_val);
                        break;
                    case "m_leftRegion":
                        objMain.chartSideType[0] = _val;
                        break;
                    case "m_rightRegion":
                        objMain.chartSideType[1] = _val;
                        break;
                    case "m_mapID":
                        objMain.chartID = _val;
                        break;
                    default:
                        if(_in_assets) {
                            switch array_top(_stack) {
                                case "m_id":
                                    _note_id = _val;
                                    break;
                                case "m_type":
                                    _note_type = _val;
                                    break;
                                case "m_time":
                                    _note_time = _val;
                                    break;
                                case "m_position":
                                    _note_position = _val;
                                    break;
                                case "m_width":
                                    _note_width = _val;
                                    break;
                                case "m_subId":
                                    _note_subid = _val;
                                    break;
                                default:
                                    break;
                            }
                        }
                        break;
                }
                break;
        }
    }
    
    DerpXmlRead_CloseFile();
}

function map_set_title() {
	var _title = get_string("请输入新的谱面标题：", objMain.chartTitle);
	
	if(_title == "") return;
	
	objMain.chartTitle = _title;
}

function music_load(_file = "") {
    if(_file == "")
	    _file = get_open_filename_ext("Music Files (*.mp3;*.flac;*.wav;*.ogg;*.aiff;*.mid)|*.mp3;*.flac;*.wav;*.ogg;*.aiff;*.mid", "", 
	        program_directory, "Load Music File 加载音乐文件");
        
    if(_file == "") return;
    
    if(!file_exists(_file)) {
        show_error("Music file " + _file + " doesnt exist.", false);
        return;
    }
    
    with(objMain) {
        if(!is_undefined(music))
            FMODGMS_Snd_Unload(music);
        
        chartMusicFile = _file;
        music = FMODGMS_Snd_LoadSound_Ext2(_file, 0x00004200);
        // music = FMODGMS_Snd_LoadSound(_file);
        if(music < 0) {
        	show_error("Load Music Failed. \n FMOD Error Message: " + FMODGMS_Util_GetErrorMessage(), false);
        	music = undefined;
        	return;
        }
        FMODGMS_Snd_PlaySound(music, channel);
        if(!nowPlaying) FMODGMS_Chan_PauseChannel(channel);
        else {
            nowTime = 0;
        }
        sampleRate = FMODGMS_Chan_Get_Frequency(channel);
        musicLength = FMODGMS_Snd_Get_Length(music);
        
        
    }
    objManager.musicPath = _file;
    show_debug_message("Load sucessfully.");
}

function image_load(_file = "") {
	if(_file == "")
	    _file = get_open_filename_ext("Image Files (*.jpg;*.jpeg;*.png)|*.jpg;*.jpeg;*.png|JPG Files (*.jpg)|*.jpg|PNG Files (*.png)|*.png", "",
	        program_directory, "Load Background File 加载背景图片");
        
    if(_file == "") return;
    
    if(!file_exists(_file)) {
        show_error("Image file " + _file + " doesnt exist.\n图片文件不存在。", false);
        return;
    }
    
    var _spr = sprite_add(_file, 1, 0, 0, 0, 0);
    if(_spr < 0) {
        show_error("Loading image file " + _file + " failed.\n图片文件读取失败。", false);
        return;
    }
    
    var _wscl = global.resolutionW / sprite_get_width(_spr);
    var _hscl = global.resolutionH / sprite_get_height(_spr);
    var _scl = max(_wscl, _hscl); // Centre & keep ratios
    
    var _nspr = compress_sprite(_spr, _scl, true);
    
    with(objMain) {
        if(bgImageSpr != -1)
            sprite_delete(bgImageSpr);
        
        bgImageSpr = _nspr;
        
        // Bottom reset
        
        surface_free_f(bottomBgSurf);
        bottomBgSurf = -1;
        
        
    }
    objManager.backgroundPath = _file;
    sprite_delete(_spr);
}

function map_export_xml() {
    var _file = "";
    var _mapid = "_map_" + objMain.chartTitle + "_" + difficulty_num_to_char(objMain.chartDifficulty);
    var _default_file_name = _mapid + "-";
    _default_file_name += string(current_year) + "-";
    _default_file_name += string(current_month) + "-";
    _default_file_name += string(current_day) + "-";
    _default_file_name += string(current_hour) + "-";
    _default_file_name += string(current_minute) + "-";
    _default_file_name += string(current_second);
    _file = get_save_filename_ext("XML File (*.xml)|*.xml", _default_file_name + ".xml", program_directory, 
        "Export Dynamic Chart as XMl File 导出谱面XML文件");
    
    if(_file == "") return;
    
    notes_reallocate_id(); // For Dynamaker's Reading
    instance_activate_object(objNote); // Temporary activate all notes
    
    DerpXmlWrite_New();
    DerpXmlWrite_OpenTag("CMap");
        DerpXmlWrite_LeafElement("m_path", objMain.chartTitle);
        DerpXmlWrite_LeafElement("m_barPerMin", string_format(objMain.chartBarPerMin, 1, 9));
        DerpXmlWrite_LeafElement("m_timeOffset", "0");
        DerpXmlWrite_LeafElement("m_leftRegion", objMain.chartSideType[0]);
        DerpXmlWrite_LeafElement("m_rightRegion", objMain.chartSideType[1]);
        DerpXmlWrite_LeafElement("m_mapID", _mapid);
        
        // Down Side Notes
        var l = array_length(objMain.chartNotesArray);
        DerpXmlWrite_OpenTag("m_notes");
            DerpXmlWrite_OpenTag("m_notes");
                for(var i=0; i<l; i++) with objMain.chartNotesArray[i].inst {
                    if(side == 0) {
                        DerpXmlWrite_OpenTag("CMapNoteAsset");
                            DerpXmlWrite_LeafElement("m_id", nid);
                            DerpXmlWrite_LeafElement("m_type", note_type_num_to_string(noteType));
                            DerpXmlWrite_LeafElement("m_time", string_format(time_to_bar(time), 1, 9));
                            DerpXmlWrite_LeafElement("m_position", string_format(position - width / 2, 1, 4));
                            DerpXmlWrite_LeafElement("m_width", width);
                            DerpXmlWrite_LeafElement("m_subId", sid);
                        DerpXmlWrite_CloseTag();
                    }
                }
            DerpXmlWrite_CloseTag();
        DerpXmlWrite_CloseTag();
        
        // Left Side Notes
        DerpXmlWrite_OpenTag("m_notesLeft");
            DerpXmlWrite_OpenTag("m_notes");
                for(var i=0; i<l; i++) with objMain.chartNotesArray[i].inst {
                    if(side == 1) {
                        DerpXmlWrite_OpenTag("CMapNoteAsset");
                            DerpXmlWrite_LeafElement("m_id", nid);
                            DerpXmlWrite_LeafElement("m_type", note_type_num_to_string(noteType));
                            DerpXmlWrite_LeafElement("m_time", string_format(time_to_bar(time), 1, 9));
                            DerpXmlWrite_LeafElement("m_position", string_format(position - width / 2, 1, 4));
                            DerpXmlWrite_LeafElement("m_width", width);
                            DerpXmlWrite_LeafElement("m_subId", sid);
                        DerpXmlWrite_CloseTag();
                    }
                }
            DerpXmlWrite_CloseTag();
        DerpXmlWrite_CloseTag();
        
        // Right Side Notes
        DerpXmlWrite_OpenTag("m_notesRight");
            DerpXmlWrite_OpenTag("m_notes");
                for(var i=0; i<l; i++) with objMain.chartNotesArray[i].inst {
                    if(side == 2) {
                        DerpXmlWrite_OpenTag("CMapNoteAsset");
                            DerpXmlWrite_LeafElement("m_id", nid);
                            DerpXmlWrite_LeafElement("m_type", note_type_num_to_string(noteType));
                            DerpXmlWrite_LeafElement("m_time", string_format(time_to_bar(time), 1, 9));
                            DerpXmlWrite_LeafElement("m_position", string_format(position - width / 2, 1, 4));
                            DerpXmlWrite_LeafElement("m_width", width);
                            DerpXmlWrite_LeafElement("m_subId", sid);
                        DerpXmlWrite_CloseTag();
                    }
                }
            DerpXmlWrite_CloseTag();
        DerpXmlWrite_CloseTag();
    DerpXmlWrite_CloseTag();
    
    var xmlString = DerpXmlWrite_GetString()
	DerpXmlWrite_UnloadString() // free DerpXml's internal copy of the xml string
	
	var f = file_text_open_write(_file);
	file_text_write_string(f, xmlString);
	file_text_close(f);
	
	objManager.chartPath = _file;
}

#endregion

#region PROJECT FUNCTIONS

function project_load(_file = "") {
	if(_file == "") 
		_file = get_open_filename_ext("DyNode File (*.dyn)|*.dyn", objMain.chartTitle + ".dyn", program_directory, 
        "Load Project 打开工程");
    
    if(_file == "") return 0;
    
    var _f = file_text_open_read(_file);
    var _contents = json_parse(file_text_read_all(_f));
    file_text_close(_f);
    
    with(objManager) {
    	musicPath = _contents.musicPath;
    	backgroundPath = _contents.backgroundPath;
    	chartPath = _contents.chartPath;
    }
    
    map_load(chartPath);
    music_load(musicPath);
    image_load(backgroundPath);
    
    timing_point_reset();
    objEditor.timingPoints = _contents.timingPoints;
    timing_point_sort();
    
    projectPath = _file;
    
    return 1;
}

function project_save() {
	return project_save_as(objManager.projectPath);
}

function project_save_as(_file = "") {
	
	if(_file == "")
		_file = get_save_filename_ext("DyNode File (*.dyn)|*.dyn", objMain.chartTitle + ".dyn", program_directory, 
	        "Project save as 工程另存为");
	
	if(_file == "") return 0;
	
	var _contents = {
		version : global.version,
		musicPath: objManager.musicPath,
		backgroundPath: objManager.backgroundPath,
		chartPath: objManager.chartPath,
		timingPoints: objEditor.timingPoints
	};
	
	var _f = file_text_open_write(_file);
	file_text_write_string(_f, json_stringify(_contents));
	file_text_close(_f);
	
	return 1;
}

#endregion

function theme_init() {
	
	global.themes = [];
	global.themeAt = 0;
	
	/// Theme Configuration
	
	array_push(global.themes, {
		title: "Dynamix",
		color: c_aqua,
		partSpr: sprParticleW,		// Particle Sprite
		partColA: 0x652dba, 		// Note's Particle Color
		partColB: 0x652dba,
		partColHA: 0x16925a,		// Hold's Particle Color
		partColHB: 0x16925a,
		partBlend: true
	});
	
	array_push(global.themes, {
		title: "Sakura",
		color: 0xc5b7ff,
		partSpr: sprParticleW,		// Particle Sprite
		partColA: 0x652dba, 		// Note's Particle Color
		partColB: 0x652dba,
		partColHA: 0x16925a,		// Hold's Particle Color
		partColHB: 0x16925a,
		partBlend: true
	});
	
	array_push(global.themes, {
		title: "Piano",
		color: c_black,
		partSpr: sprParticleW,		// Particle Sprite
		partColA: c_white, 		// Note's Particle Color
		partColB: c_ltgrey,
		partColHA: c_white,		// Hold's Particle Color
		partColHB: c_black,
		partBlend: false
	});
	
	/// End of Configuration
	
	global.themeCount = array_length(global.themes);
	
}

function theme_next() {
	global.themeAt ++;
	global.themeAt %= global.themeCount;
	
	objMain.themeColor = global.themes[global.themeAt].color;
}

function theme_get() {
	return global.themes[global.themeAt];
}

function reset_scoreboard() {
	with(objScoreBoard) {
		nowScore = 0;
		animTargetScore = 0;
	}
	with(objPerfectIndc) {
		lastTime = 99999;
	}
}

function sfmod_channel_get_position(channel, spr) {
    var _ret = FMODGMS_Chan_Get_Position(channel);
    _ret = _ret - FMOD_SOUND_DELAY;
    return _ret;
}

function sfmod_channel_set_position(pos, channel, spr) {
    pos = pos + FMOD_SOUND_DELAY;
    FMODGMS_Chan_Set_Position(channel, pos);
}

