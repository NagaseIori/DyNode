
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

function map_reset() {
	map_close();
	instance_create_depth(0, 0, 0, objMain);
}

function map_load(_file = "") {

	if(is_struct(_file)) {
		map_load_struct(_file);
		return;
	}
	var _direct = _file != "";
	if(_file == "")
	    _file = get_open_filename_ext("XML Files (*.xml)|*.xml", "example.xml", 
	        program_directory, "Load Dynamix Chart File 加载谱面文件");
        
    if(_file == "") return;
    
    if(!file_exists(_file)) {
        announcement_error("谱面文件不存在。导入中止。");
        return;
    }
    
    var _confirm = _direct? true:show_question("确认导入谱面？所有操作将不可撤销。");
    if(!_confirm) return;
    var _clear = _direct? true:show_question("是否清除所有原谱面物件？");
    if(_clear) note_delete_all();
    
    var _import_info = show_question("是否导入谱面信息（标题、难度、Timing等）？");
    
    if(filename_ext(_file) == ".xml")
        map_load_xml(_file, _import_info);
    
    objManager.chartPath = _file;
    
    show_debug_message("Import map sucessfully.");
    announcement_play("导入谱面完毕。");
}

function map_load_xml(_file, _import_info) {
	notes_reallocate_id();
    DerpXmlRead_OpenFile(_file);
    
    var _stack = [];
    var _line = 0;
    var _in_notes = 0;
    var _in_left = 0;
    var _in_right = 0;
    var _in_assets = 0;
    var _in_argument = 0;
    var _in_bpm = 0;
    var _import_tp = false;
    var _note_id, _note_type, _note_time,
        _note_position, _note_width, _note_subid;
    var _barpm, _offset;
    var _tp_lists = [], _nbpm;
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
                    case "m_argument":
                    	_in_argument ++;
                    	_import_tp = show_question("是否导入 Dynamaker Modified 谱面文件中的变 BPM 数据？");
                    	break;
                    case "CMapNoteAsset":
                        _in_assets ++;
                        break;
                    case "CBpmchange":
                    	_in_bpm ++;
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
                    case "m_argument":
                    	_in_argument --;
                    	break;
                    case "CMapNoteAsset":
                        _in_assets --;
                        var _err = build_note(_note_id+"_imported", _note_type, _note_time,
                            _note_position, _note_width, _note_subid+"_imported",
                            _in_left + _in_right*2, true);
                        if(_err < 0) return;
                        break;
                     case "CBpmchange":
                    	_in_bpm --;
                    	array_push(_tp_lists, {
                    		time: _note_time,
                    		barpm: _nbpm
                    	});
                    	break;
                }
                break;
            case DerpXmlType_Text:
                var _val = DerpXmlRead_CurValue();
                switch array_top(_stack) {
                    case "m_path":
                    	if(_import_info)
                        objMain.chartTitle = _val;
                        break;
                    case "m_barPerMin":
                        _barpm = real(_val);
                        break;
                    case "m_timeOffset":
                        _offset = real(_val);
                        break;
                    case "m_leftRegion":
                    	if(_import_info)
                        objMain.chartSideType[0] = _val;
                        break;
                    case "m_rightRegion":
                    	if(_import_info)
                        objMain.chartSideType[1] = _val;
                        break;
                    case "m_mapID":
                    	if(_import_info)
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
                        else if(_in_bpm) {
                        	switch array_top(_stack) {
                        		case "m_time":
                        			_note_time = real(_val);
                        			break;
                        		case "m_value":
                        			_nbpm = real(_val);
                        			break;
                        	}
                        }
                        break;
                }
                break;
        }
    }
    
    DerpXmlRead_CloseFile();
    
    
    if(_import_info) {
    	with(objMain) {
    		
    		chartBarPerMin = _barpm;
    		chartBeatPerMin = _barpm * 4;
    		chartBarOffset = _offset;
    		chartTimeOffset = bar_to_time(_offset);
    		chartBarUsed = true;
        
	        // Reset to the beginning
	        nowTime = 0;
	        animTargetTime = nowTime;
	        
	        // Sort Notes Array base on time
	        note_sort_all();
	        
	        // Get the chart's difficulty
	        chartDifficulty = difficulty_char_to_num(string_char_at(chartID, string_length(chartID)));
	        
	        // Initialize Timing Points
	    	timing_point_reset();
	        timing_point_add(
	            0, bpm_to_mspb(chartBeatPerMin), 4);
    	}
    }
    
    // Fix every note's & tp's time
    _offset = bar_to_time(_offset, _barpm);
    if(instance_exists(objNote)) {
        with(objNote) {
        	if(string_last_pos("_imported", nid) > 0) {
        		
        		if(array_length(_tp_lists) > 1) {
        			var _ntime = bar;
        			var _rtime = 0;
	        		for(var i=1, l=array_length(_tp_lists); i<=l; i++) {
	        			if(i == l || _tp_lists[i].time > _ntime) {
	        				_rtime += bar_to_time(_ntime - _tp_lists[i-1].time, _tp_lists[i-1].barpm);
	        				break;
	        			}
        				_rtime += bar_to_time(_tp_lists[i].time - _tp_lists[i-1].time, _tp_lists[i-1].barpm);
	        		}
	        		time = _rtime;
        		}
        		else
        			time = bar_to_time(bar, _barpm);    	 // Bar to Chart Time in ms
        		
	            time = time_to_mtime(time, _offset);         // Chart Time to Music Time in ms (Fix the offset to 0)
	            if(noteType == 2)
	            	_prop_hold_update();			// Hold prop init
        	}
        }
    }
    
    // Import timing points info from dynamaker-modified
    if(_import_tp && _import_info) {
    	timing_point_reset();
    	var _rtime = 0;
    	for(var i=0, l=array_length(_tp_lists); i<l; i++) {
    		var _ntime = _tp_lists[i].time;
    		if(i>0)
    			_ntime = bar_to_time(_ntime - _tp_lists[i-1].time, _tp_lists[i-1].barpm) + _rtime;
    		// _ntime = time_to_mtime(_ntime, _offset);
    		_rtime = _ntime;
    		
    		timing_point_add(_ntime, bpm_to_mspb(_tp_lists[i].barpm*4), 4);
    	}
    	
    	timing_point_sort();
    }
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
    
    announcement_play("音乐加载完毕。", 1000);
}

function image_load(_file = "") {
	if(_file == "")
	    _file = get_open_filename_ext("Image Files (*.jpg;*.jpeg;*.png)|*.jpg;*.jpeg;*.png|JPG Files (*.jpg)|*.jpg|PNG Files (*.png)|*.png", "",
	        program_directory, "Load Background File 加载背景图片");
        
    if(_file == "") return;
    
    if(!file_exists(_file)) {
        announcement_error("图片文件不存在。\n[scale, 0.8]路径："+_file);
        return;
    }
    
    var _spr = sprite_add(_file, 1, 0, 0, 0, 0);
    if(_spr < 0) {
        announcement_error("图片文件读取失败。图片可能过大或损坏。");
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
    var _mapid = "_map_" + map_get_alt_title() + "_" + difficulty_num_to_char(objMain.chartDifficulty);
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
    
    // For Compatibility
    notes_reallocate_id();
    if(!objMain.chartBarUsed)
    	timing_point_sync_with_chart_prop();
    instance_activate_object(objNote); // Temporarily activate all notes
    
    DerpXmlWrite_New();
    DerpXmlWrite_OpenTag("CMap");
        DerpXmlWrite_LeafElement("m_path", objMain.chartTitle);
        DerpXmlWrite_LeafElement("m_barPerMin", string_format(objMain.chartBarPerMin, 1, 9));
        DerpXmlWrite_LeafElement("m_timeOffset", string_format(objMain.chartBarOffset, 1, 9));
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
                            DerpXmlWrite_LeafElement("m_time", string_format(time_to_bar(mtime_to_time(time)), 1, 9));
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
                            DerpXmlWrite_LeafElement("m_time", string_format(time_to_bar(mtime_to_time(time)), 1, 9));
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
                            DerpXmlWrite_LeafElement("m_time", string_format(time_to_bar(mtime_to_time(time)), 1, 9));
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
	
	announcement_play("谱面导出完毕。");
}

function map_get_struct() {
	var _arr = [];
	
	with(objMain) {
		instance_activate_all();
		notes_array_update();
		var i=0, l=chartNotesCount, _inst;
		for(; i<l; i++) {
			var _str = chartNotesArray[i];
			if(_str.noteType != 3)
				array_push(_arr, {
					width : _str.width,
					side : _str.side,
					noteType : _str.noteType,
					position : _str.position,
					time : _str.time,
					lastTime : _str.lastTime,
				});
		}
	}
	
	var _str = {
		title: objMain.chartTitle,
		bpm: objMain.chartBeatPerMin,
		barpm: objMain.chartBarPerMin,
		difficulty: objMain.chartDifficulty,
		sidetype: objMain.chartSideType,
		barused: objMain.chartBarUsed,
		notes: _arr
	}
	
	return _str;
}

function build_note_withprop(prop) {
	if(prop.noteType < 2) {
		return build_note(random_id(9), prop.noteType, prop.time, prop.position, 
			prop.width, "-1", prop.side);
	}
	else {
		return build_hold(random_id(9), prop.time, prop.position, prop.width,
			random_id(9), prop.time + prop.lastTime, prop.side);
	}
}

function map_load_struct(_str) {
	note_delete_all();
	
	with(objMain) {
		chartTitle = _str.title;
		chartBeatPerMin = _str.bpm;
		chartBarPerMin = _str.barpm;
		chartDifficulty = _str.difficulty;
		chartSideType = _str.sidetype;
		
		if(variable_struct_exists(_str, "barused"))
			chartBarUsed = _str.barused;
	}
	
	var _arr = _str.notes;
	for(var i=0, l=array_length(_arr); i<l; i++) 
		build_note_withprop(_arr[i]);
	
	show_debug_message("Load map from struct sucessfully.");
}

function map_get_alt_title() {
	var _title = objMain.chartTitle;
	_title = string_replace_all(_title, "\"", "");
	
	return _title;
}

function map_set_global_bar() {
	
	var _barpm = get_string("请输入自定义的全局 Bar Per Minute :", "");
	_barpm = string_real(_barpm);
	if(_barpm == "") return;
	var _offset = string_digits(get_string("请输入用于 Bar 显示与导出的全局 Offset （毫秒）:", ""));
	if(_offset == "") return;
	with(objMain) {
		chartBarPerMin = real(_barpm);
		chartBarUsed = true;
		chartTimeOffset = real(_offset);
		chartBarOffset = time_to_bar(chartTimeOffset);
	}
	
	announcement_play("已更改全局 BarPM 与 Offset 至："+_barpm+"/"+string(_offset));
	
}

#endregion

#region PROJECT FUNCTIONS

function project_load(_file = "") {
	if(_file == "") 
		_file = get_open_filename_ext("DyNode File (*.dyn)|*.dyn", map_get_alt_title() + ".dyn", program_directory, 
        "Load Project 打开项目");
    
    if(_file == "") return 0;
    
    var _f = file_text_open_read(_file);
    var _contents = json_parse(file_text_read_all(_f));
    file_text_close(_f);
    
    map_reset();
    
    with(objManager) {
    	musicPath = _contents.musicPath;
    	backgroundPath = _contents.backgroundPath;
    	chartPath = _contents.chartPath;
    }
    
    
    if(variable_struct_exists(_contents, "charts")) {
    	objMain.animTargetTime = 0;
    	map_load(_contents.charts);
    }
    else
    	map_load(chartPath);
    music_load(musicPath);
    image_load(backgroundPath);
    
    timing_point_reset();
    objEditor.timingPoints = _contents.timingPoints;
    timing_point_sort();
    
    projectPath = _file;
    
    announcement_play("打开项目完毕。");
    
    return 1;
}

function project_save() {
	return project_save_as(objManager.projectPath);
}

function project_save_as(_file = "") {
	
	if(_file == "")
		_file = get_save_filename_ext("DyNode File (*.dyn)|*.dyn", map_get_alt_title() + ".dyn", program_directory, 
	        "Project save as 项目另存为");
	
	if(_file == "") return 0;
	
	var _contents = {
		version : global.version,
		musicPath: objManager.musicPath,
		backgroundPath: objManager.backgroundPath,
		chartPath: objManager.chartPath,
		timingPoints: objEditor.timingPoints,
		charts: []
	};
	
	_contents.charts = map_get_struct();
	
	var _f = file_text_open_write(_file);
	file_text_write_string(_f, json_stringify(_contents));
	file_text_close(_f);
	
	objManager.projectPath = _file;
	
	announcement_play("项目保存完毕。");
	
	return 1;
}

function project_new() {
	
	var _confirm = show_question("确定要创建新的工程吗？所有未保存的更改都将丢失。");
	if(!_confirm) return;
	
	with(objManager) {
		musicPath = "";
		backgroundPath = "";
		chartPath = "";
		projectPath = "";
	}
	
	room_goto(rProjectInit);
}

#endregion

#region THEME FUNCTIONS

function theme_init() {
	
	global.themes = [];
	global.themeAt = 0;
	
	/// Theme Configuration
	
	array_push(global.themes, {
		title: "[c_aqua]Dynamix[/c]",
		color: c_aqua,
		partSpr: sprParticleW,		// Particle Sprite
		partColA: 0x652dba, 		// Note's Particle Color
		partColB: 0x652dba,
		partColHA: 0x16925a,		// Hold's Particle Color
		partColHB: 0x16925a,
		partBlend: true
	});
	
	array_push(global.themes, {
		title: "[c_sakura]Sakura[/c]",
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
	
	if(instance_exists(objMain))
		objMain.themeColor = global.themes[global.themeAt].color;
	
	announcement_play("已切换到主题 [[" + global.themes[global.themeAt].title + "]", 1000);
}

function theme_get() {
	return global.themes[global.themeAt];
}

#endregion

#region ANNOUNCEMENT FUNCTIONS

function announcement_play(str, time = 3000) {
	with(objManager) {
		announcementString = str;
		announcementLastTime = time;
		announcementTime = 0;
	}
}

function announcement_warning(str, time = 5000) {
	announcement_play("[c_warning][[警告] [/c]" + str, time);
}

function announcement_error(str, time = 8000) {
	announcement_play("[#f44336][[错误] " + str, time);
}

function announcement_adjust(str, val) {
	announcement_play(str + "：" + (val?"开启":"关闭"));
}

#endregion

#region SYSTEM FUNCTIONS

function load_config() {
	if(!file_exists(global.configPath)) return;
	
	var _f = file_text_open_read(global.configPath);
	var _con = json_parse(file_text_read_all(_f));
	file_text_close(_f);
	
	if(variable_struct_exists(_con, "theme"))
		global.themeAt = _con.theme;
	if(variable_struct_exists(_con, "FPS"))
		global.fps = _con.FPS;
	if(variable_struct_exists(_con, "resolutionH"))
		global.resolutionH = _con.resolutionH;
	if(variable_struct_exists(_con, "resolutionW"))
		global.resolutionW = _con.resolutionW;
	if(variable_struct_exists(_con, "autosave"))
		global.autosave = _con.autosave;
	if(variable_struct_exists(_con, "autoupdate"))
		global.autoupdate = _con.autoupdate;
}

function save_config() {
	
	var _f = file_text_open_write(global.configPath);
	file_text_write_string(_f, json_stringify({
		theme: global.themeAt,
		FPS: global.fps,
		resolutionW: global.resolutionW,
		resolutionH: global.resolutionH,
		version: global.version,
		autosave: global.autosave,
		autoupdate: global.autoupdate
	}));
	
	file_text_close(_f);
	
}

function switch_debug_info() {
	with(objMain) {
		showDebugInfo = !showDebugInfo;
		announcement_play("调试信息："+(showDebugInfo?"打开":"关闭"));
	}
}

function switch_autosave() {
	with(objManager) {
		if(!global.autosave) {
			announcement_play("自动保存已开启。", 2000);
			time_source_start(tsAutosave);
		}
		else {
			announcement_play("自动保存已关闭。", 2000);
			time_source_start(tsAutosave);
		}
		global.autosave = !global.autosave;
	}
}

#endregion

function reset_scoreboard() {
	with(objScoreBoard) {
		nowScore = 0;
		animTargetScore = 0;
	}
	with(objPerfectIndc) {
		nowTime = 99999;
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

