
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
        map_import_xml(_file, _import_info);
    
    objManager.chartPath = _file;
    
    show_debug_message("Import map sucessfully.");
    announcement_play("导入谱面完毕。");
}

function map_import_xml(_file, _import_info) {
	notes_reallocate_id();
    
    var _f = file_text_open_read(_file);
    var _str = snap_alter_from_xml(snap_from_xml(file_text_read_all(_f)));
    file_text_close(_f);

    var _import_tp = false;
    var _note_id, _note_type, _note_time,
        _note_position, _note_width, _note_subid;
    var _barpm, _offset;
    var _tp_lists = [], _nbpm;
    
    // Import Information & bpm
    var _main = _str.CMap;
    if(_import_info) {
    	objMain.chartTitle = _main.m_path.text;
    	objMain.chartSideType[0] = _main.m_leftRegion.text;
    	objMain.chartSideType[1] = _main.m_rightRegion.text;
    	objMain.chartID = _main.m_mapID.text;
    }
    _barpm = real(_main.m_barPerMin.text);
	_offset = real(_main.m_timeOffset.text);
	
	// Import 3 sides Notes
	
	var _import_fun = function (_arr, _side) {
		if(!is_array(_arr)) _arr = [_arr];
		for(var i=0, l=array_length(_arr); i<l; i++) {
			_note_id = _arr[i].m_id.text;
			_note_type = _arr[i].m_type.text;
			_note_time = _arr[i].m_time.text;
			_note_position = _arr[i].m_position.text;
			_note_width = _arr[i].m_width.text;
			_note_subid = _arr[i].m_subId.text;
	
			var _err = build_note(_note_id+"_imported", _note_type, _note_time,
	            _note_position, _note_width, _note_subid+"_imported",
	            _side, true);
	        if(_err < 0) return;
		}
	}
	
	_import_fun(_main.m_notes.m_notes.CMapNoteAsset, 0);
	_import_fun(_main.m_notesLeft.m_notes.CMapNoteAsset, 1);
	_import_fun(_main.m_notesRight.m_notes.CMapNoteAsset, 2);
	
	if(variable_struct_exists(_main, "m_argument")) {
		_import_tp = show_question("是否导入 Dynamaker Modified 谱面文件中的变 BPM 数据？");
		var _bpms = _main.m_argument.m_bpmchange.CBpmchange;
		if(!is_array(_bpms)) _bpms = [_bpms];
		for(var i=0, l=array_length(_bpms); i<l; i++) {
			_note_time = real(_bpms[i].m_time.text);
			_nbpm = real(_bpms[i].m_value.text);
		
			array_push(_tp_lists, {
	    		time: _note_time,
	    		barpm: _nbpm
	    	});
		}
	}
	
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

function map_import_osu() {
    var _file = "";
    _file = get_open_filename_ext("OSU Files (*.osu)|*.osu", "", 
        program_directory, "Load osu! Chart File 加载 osu! 谱面文件");
        
    if(_file == "") return;
    
    var _import_hitobj = show_question("是否导入 .osu 中的物件？（要进行转谱吗？）");
    var _clear_notes = show_question("是否清除所有原谱面物件？此操作不可撤销！");
    if(_clear_notes) note_delete_all();
    var _delay_time = 0;
    
    timing_point_reset();
    var _f = file_text_open_read(_file);
    var _grid = snap_from_csv(file_text_read_all(_f));
    file_text_close(_f);
	
    show_debug_message("CSV Load Finished.");
    
    var _type = "";
    var _h = array_length(_grid);
    var _mode = 0;				// Osu Game Mode
    
    for(var i=0; i<_h; i++) {
        if(string_last_pos("[", _grid[i][0]) != 0) {
        	_type = _grid[i][0];
        }
            
        else if(_grid[i][0] != ""){
            switch _type {
            	case "[General]":
            		if(string_last_pos("Mode", _grid[i][0]) != 0)
            			_mode = real(string_digits(_grid[i][0]));
            		break;
                case "[TimingPoints]":
					if(array_length(_grid[i]) < 3) break;
                    var _time = real(_grid[i][0]) + _delay_time;
                    var _mspb = string_letters(_grid[i][1]) != ""?-1:real(_grid[i][1]);
                    var _meter = real(_grid[i][2]);
                    if(_mspb > 0)
                        timing_point_add(_time, _mspb, _meter);
                    break;
                case "[HitObjects]":
                	if(_import_hitobj) {
						if(array_length(_grid[i]) < 6) break;
                		var _ntime = real(_grid[i][2]) + _delay_time;
                		var _ntype = real(_grid[i][3]);
                		if(_ntime > 0) {
	                		switch _mode {
	                			case 0:
	                			case 1:
	                			case 2:
	                				var _x = real(_grid[i][0]);
	                				var _y = real(_grid[i][1]);
	                				build_note(random_id(9), 0, _ntime, _x / 512 * 5, 1.0, -1, 0, false);
	                				break;
	                			case 3: // Mania Mode
	                				var _x = real(_grid[i][0]);
	                				if(_ntype & 128) { // If is a Mania Hold
	                					var _subtim = real(string_copy(_grid[i][5], 1, string_pos(":", _grid[i][5])-1)) + _delay_time;
	                					build_hold(random_id(9), _ntime, _x / 512 * 5, 1.0, random_id(9), _subtim, 0);
	                				} 
	                				else
	                					build_note(random_id(9), 0, _ntime, _x / 512 * 5, 1.0, -1, 0, false);
	                				break;
	                		}
                		}
                	}
                	break;
				default:
					break;
            }
        }
    }
    
    timing_point_sort();
    note_sort_all();
    
    announcement_play("导入谱面信息完毕。", 1000);
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
        	announcement_error("音乐文件加载失败，可能原因为类型不支持或文件损坏。\nFMOD 错误信息："+FMODGMS_Util_GetErrorMessage());
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
        usingMP3 = string_lower(filename_ext(_file)) == ".mp3";
        if(usingMP3)
        	show_debug_message("The music file is using the mp3 format")
        
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
	var _forbidden_chars = "?*:\"<>\\/|"
	var _title = objMain.chartTitle;
	for(var i=1, l=string_length(_forbidden_chars); i<l; i++)
		_title = string_replace_all(_title, string_char_at(_forbidden_chars, i), "_");
	
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

function map_add_offset(_offset = "", record = false) {
	var _record = false;
	if(_offset == "") {
		var _nega = 1;
		_offset = get_string("请输入你想要添加的全局时间偏移量（以毫秒记，正数代表增加延迟）。这将会影响所有的 Timing Points 和 Notes 所在的时间。", "");
		if(_offset == "") return;
		if(string_char_at(_offset, 1) == "-")
			_nega = -1;
		_offset = real(string_real(_offset))*_nega;
		_record = true;
	}
	
	with(objEditor) {
		for(var i=0, l=array_length(timingPoints); i<l; i++)
			timingPoints[i].time += _offset;
	}
	
	instance_activate_object(objNote);
	with(objMain) {
		for(var i=0, l=array_length(chartNotesArray); i<l; i++) {
			chartNotesArray[i].inst.time += _offset;
		}
	}
	notes_array_update();
	
	announcement_play("全局时间偏移添加完毕。");
	
	if(record)
		operation_step_add(OPERATION_TYPE.OFFSET, _offset, -1);
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
    
    
    ///// Old version workaround
    
	    if(_contents.version < "v0.1.5") {
	    	var _question = show_question("检测到来自特定旧版本的项目。\n该谱面是否使用了从 .osu 中导入校时信息并添加了 64ms 的延迟？\n这个延迟在新的版本中建议被撤销。如果你选择“是”，则所有放置的 Note 和 Timing Point 都会被提前 64ms 。\n在调整之前我们建议你先对 .dyn 文件进行备份。你也可以在之后手动进行调整。\n这个警告不会出现第二遍。");
			if(_question)
				map_add_offset(-64, true);
	    }
		
	/////
    
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
	if(variable_struct_exists(_con, "FMOD_MP3_DELAY"))
		global.FMOD_MP3_DELAY = _con.FMOD_MP3_DELAY;
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
		autoupdate: global.autoupdate,
		FMOD_MP3_DELAY: global.FMOD_MP3_DELAY
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
			time_source_stop(tsAutosave);
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
    _ret = _ret - global.FMOD_MP3_DELAY * objMain.usingMP3;
    return _ret;
}

function sfmod_channel_set_position(pos, channel, spr) {
    pos = pos + global.FMOD_MP3_DELAY * objMain.usingMP3;
    FMODGMS_Chan_Set_Position(channel, pos);
}

