
#region MAP FUNCTIONS

function map_close() {
	with(objMain) {
		safe_video_free();
		kawase_destroy(kawaseArr);
		surface_free_f(bottomInfoSurf);
		
		note_delete_all();
		instance_destroy(objScoreBoard);
		instance_destroy(objPerfectIndc);
		instance_destroy(objEditor);
		instance_destroy(objShadow);
		
		time_source_destroy(timesourceResumeDelay);
		time_source_destroy(timesourceDeactivateFlush);
		part_emitter_destroy_all(partSysNote);
		part_system_destroy(partSysNote);
		part_type_destroy(partTypeNoteDL);
		part_type_destroy(partTypeNoteDR);
		
		if(bgImageSpr != -1)
		    sprite_delete(bgImageSpr);
		
		for(var i=0; i<3; i++)
		    ds_map_destroy(chartNotesMap[i]);
		ds_map_destroy(deactivationQueue);
		
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
		
		note_activation_reset();
		return;
	}
	var _direct = _file != "";
	if(_file == "")
	    _file = get_open_filename_ext(i18n_get("fileformat_chart") + " (*.xml;*.dyn;*.osu)|*.xml;*.dyn;*.osu", "", 
	        program_directory, "Load Dynamix Chart File 加载谱面文件");
        
    if(_file == "") return;
    
    if(!file_exists(_file)) {
        announcement_error(i18n_get("anno_chart_not_exists"));
        return;
    }
    
    var _confirm = _direct? true:show_question_i18n("box_q_import_confirm");
    if(!_confirm)
    	return;
    
    var _clear = _direct? true:show_question_i18n("box_q_import_clear");
    if(_clear)
    	note_delete_all();
    
    var _timing_reset = _direct? true:show_question_i18n("box_q_import_timing_reset");
    if(_timing_reset)
    	timing_point_reset();
    
    switch filename_ext(_file) {
    	case ".xml":
    		map_import_xml(_file);
    		break;
    	case ".osu":
    		map_import_osu(_file);
    		break;
    	case ".dyn":
    		map_import_dyn(_file);
    		break;
    }
    
    note_sort_all();
    notes_reallocate_id();
    note_activation_reset();
    
    announcement_play("anno_import_chart_complete");
}

function map_import_xml(_file) {
    var _buf = buffer_load(_file);
    var _str = snap_alter_from_xml(SnapBufferReadXML(_buf, 0, buffer_get_size(_buf)));
    buffer_delete(_buf);

	var _import_info = show_question_i18n("box_q_import_info");
    var _import_tp = show_question_i18n("box_q_import_bpm");
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
		for(var i=0, l=array_length(_arr); i<l; i++) if(variable_struct_names_count(_arr[i]) >= 6) {
			_note_id = _arr[i].m_id.text;
			_note_type = _arr[i].m_type.text;
			_note_time = _arr[i].m_time.text;
			_note_position = _arr[i].m_position.text;
			_note_width = _arr[i].m_width.text;
			_note_subid = _arr[i].m_subId.text;
			
			if(_note_subid != "-1")
				_note_subid += "_imported";
			_note_id += "_imported";
	
			var _err = build_note(_note_id, _note_type, _note_time,
	            _note_position, _note_width, _note_subid,
	            _side, true);
	        if(_err < 0) return;
		}
	}
	
	_import_fun(_main.m_notes.m_notes.CMapNoteAsset, 0);
	_import_fun(_main.m_notesLeft.m_notes.CMapNoteAsset, 1);
	_import_fun(_main.m_notesRight.m_notes.CMapNoteAsset, 2);
	
	var _imp_dym = false;
	if(variable_struct_exists(_main, "m_argument")) {
		if(variable_struct_exists(_main.m_argument, "m_bpmchange") && variable_struct_exists(_main.m_argument.m_bpmchange, "CBpmchange")) {
			_imp_dym = true;
			try {
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
				
				array_sort(_tp_lists, function (a, b) { return sign(a.time-b.time); });
			}
			catch (e) {
				announcement_error("error_dym_bpm_load_failed");
			}
		}
	}
	
    if(_import_info) {
    	with(objMain) {
	        // Reset to the beginning
	        nowTime = 0;
	        animTargetTime = nowTime;
	        
	        // Sort Notes Array base on time
	        note_sort_all();
	        
	        // Get the chart's difficulty
	        chartDifficulty = difficulty_char_to_num(string_char_at(chartID, string_length(chartID)));
    	}
    }
    
    // Initialize global bar info
    if(_import_tp) {
    	with(objMain) {
    		chartBarPerMin = _barpm;
    		chartBeatPerMin = _barpm * 4;
    		chartBarOffset = _offset;
    		chartTimeOffset = bar_to_time(_offset);
    		chartBarUsed = true;
    	}
    }
    
    // Import timing points info
    if(_import_tp) {
    	if(_imp_dym) {
	    	var _rtime = bar_to_time(-_offset, _barpm);
	    	for(var i=0, l=array_length(_tp_lists); i<l; i++) {
	    		var _ntime = _tp_lists[i].time;
	    		if(i>0)
	    			_ntime = bar_to_time(_ntime - _tp_lists[i-1].time, _tp_lists[i-1].barpm) + _rtime;
	    		else
	    			_ntime = _rtime;
	    		_rtime = _ntime;
	    		
	    		timing_point_add(_ntime, bpm_to_mspb(_tp_lists[i].barpm*4), 4);
	    	}
	    }
	    else {
	    	timing_point_add(
	            bar_to_time(-_offset, _barpm), bpm_to_mspb(_barpm*4), 4);
	    }
	    timing_point_sort();
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
}

function map_import_osu(_file = "") {
    if(_file == "")
	    _file = get_open_filename_ext("OSU Files (*.osu)|*.osu", "", 
	        program_directory, "Load osu! Chart File 加载 osu! 谱面文件");
        
    if(_file == "") return;
    
    var _import_hitobj = show_question_i18n(i18n_get("box_q_osu_import_objects"));
    var _delay_time = 0;
    
    var _buf = buffer_load(_file);
    var _grid = SnapBufferReadCSV(_buf, 0);
    buffer_delete(_buf);
	
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
    
    announcement_play("anno_import_info_complete", 1000);
}

function map_import_dyn(_file) {
	var _import_info = show_question_i18n("box_q_import_info");
    var _import_tp = show_question_i18n("box_q_import_bpm");
    
    var _str = json_parse(SnapStringFromFile(_file));
    
    if(!is_struct(_str))
    	show_error("Load failed.", true);
    
    if(_import_tp) {
    	objEditor.timingPoints = array_concat(objEditor.timingPoints, _str.timingPoints);
    	timing_point_sort();
    }
    
    map_load_struct(_str.charts, _import_info, _import_tp);
}

function map_set_title() {
	var _title = get_string_i18n(i18n_get("box_set_chart_title") + ": ", objMain.chartTitle);
	
	if(_title == "") return;
	
	objMain.chartTitle = _title;
}

function music_load(_file = "") {
    if(_file == "")
	    _file = get_open_filename_ext("Music Files (*.mp3;*.flac;*.wav;*.ogg;*.aiff;*.mid)|*.mp3;*.flac;*.wav;*.ogg;*.aiff;*.mid", "", 
	        program_directory, "Load Music File 加载音乐文件");
        
    if(_file == "") return;
    
    if(!file_exists(_file)) {
        announcement_error("Music file " + _file + " doesnt exist.", false);
        return;
    }
    
    with(objMain) {
        if(!is_undefined(music))
            FMODGMS_Snd_Unload(music);
        
        chartMusicFile = _file;
        music = FMODGMS_Snd_LoadSound_Ext2(_file, 0x00004200);
        // music = FMODGMS_Snd_LoadSound(_file);
        if(music < 0) {
        	announcement_error(i18n_get("anno_music_load_err")+FMODGMS_Util_GetErrorMessage());
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
        	show_debug_message_safe("The music file is using the mp3 format")
        
    }
    objManager.musicPath = _file;
    show_debug_message_safe("Load sucessfully.");
    
    announcement_play("anno_music_load_complete", 1000);
}

function background_load(_file = "") {
	if(_file == "")
	    _file = get_open_filename_ext("Background Files (*.jpg;*.jpeg;*.png;*.mp4;*.avi;*.mkv)|*.jpg;*.jpeg;*.png;*.mp4;*.avi;*.mkv|JPG Files (*.jpg)|*.jpg|PNG Files (*.png)|*.png", "",
	        program_directory, "Load Background File 加载背景文件");
        
    if(_file == "") return;
    
    switch(filename_ext(_file)) {
    	case ".jpg":
    	case ".jpeg":
    	case ".png":
    		image_load(_file);
    		break;
    	case ".mp4":
    	case ".avi":
    	case ".mkv":
    		video_load(_file);
    		break;
    }
}

function background_reset() {
	with(objManager) {
		backgroundPath = "";
		videoPath = "";
		with(objMain) {
			if(sprite_exists(bgImageSpr))
				sprite_delete(bgImageSpr);
			bgImageSpr = -1;
		}
		safe_video_free();
		announcement_play("anno_background_reset");
	}
}

function video_load(_file, _safe = true) {
	if(!file_exists(_file)) {
	        announcement_error("video_playback_file_not_exists"+_file);
        return;
    }
    if(_safe)
		safe_video_free();
	else
		video_close();
    
    if(variable_global_exists("__tmp_handlevo") && global.__tmp_handlevo != undefined)
    	call_cancel(global.__tmp_handlevo);
    global.__tmp_handlevo_time = 0;
    global.__tmp_handlevo = call_later(1, time_source_units_frames, function () {
    	if(delta_time <= 1000000)
    		global.__tmp_handlevo_time += delta_time / 1000;
    	if(video_get_status() == video_status_closed && global.__tmp_handlevo_time < 3000) {
    		video_open(objManager.videoPath);
			video_set_volume(0);
    	}
    	else {
    		if(global.__tmp_handlevo_time >= 3000)
    			announcement_error("video_playback_open_timeout");
    		call_cancel(global.__tmp_handlevo);
    		global.__tmp_handlevo = undefined;
    	}
    }, true);
	
	objManager.videoPath = _file;
}

function image_load(_file) {
	if(!file_exists(_file)) {
        announcement_error(i18n_get("anno_graph_not_exists")+_file);
        return;
    }
    
    var _spr = sprite_add(_file, 1, 0, 0, 0, 0);
    if(_spr < 0) {
        announcement_error("anno_graph_load_err");
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
    }
    objManager.backgroundPath = _file;
    sprite_delete(_spr);
}

function map_export_xml() {
	if(array_length(objEditor.timingPoints) == 0) {
		announcement_error("export_timing_error");
		return;
	}
	
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
        "Export Dynamix Chart as XMl File 导出谱面XML文件");
    
    if(_file == "") return;
    
    // For Compatibility
    notes_reallocate_id();
    instance_activate_object(objNote); // Temporarily activate all notes
    
    var _export_to_dym = show_question_i18n("export_to_dym_question");
    if(!objMain.chartBarUsed && !_export_to_dym)
    	timing_point_sync_with_chart_prop();
    if(_export_to_dym) {
    	// Force reset all bar settings
    	timing_point_sync_with_chart_prop(true, true);
    }
    var _fix_dec = _export_to_dym? false:show_question_i18n("export_fix_decimal_question");
    
    var _gen_narray = function (_side, _dec, _dym) {
    	var _ret = [];
    	var _bfun = _dym? time_to_bar_for_dym:time_to_bar;
		var l = array_length(objMain.chartNotesArray);
    	for(var i=0; i<l; i++) with (objMain.chartNotesArray[i].inst) {
            if(side == _side) {
            	var _time = _dec?round(time):time;
            	if(!_dym)
            		_time = mtime_to_time(_time);
                array_push(_ret, {
                	m_id : { text : nid },
                	m_type : { text : note_type_num_to_string(noteType) },
                	m_time : { text : string_format(_bfun(_time), 1, EXPORT_XML_EPS) },
                	m_position : { text : string_format(position - width / 2, 1, 4) },
                	m_width : { text : width },
                	m_subId: { text : sid }
                });
            }
        }
        if(array_length(_ret) == 0)
        	_ret = { text : "" };
        return _ret;
    }
    
    var _str = {
    	CMap : {
    		m_path : { text : objMain.chartTitle },
	    	m_barPerMin : { text : string_format(objMain.chartBarPerMin, 1, EXPORT_XML_EPS) },
	    	m_timeOffset : { text : string_format(objMain.chartBarOffset, 1, EXPORT_XML_EPS) },
	    	m_leftRegion : { text : objMain.chartSideType[0] },
	    	m_rightRegion : { text : objMain.chartSideType[1] },
	    	m_mapID : { text : _mapid },
	    	m_notes : {
	    		m_notes : {
	    			CMapNoteAsset : _gen_narray(0, _fix_dec, _export_to_dym)
	    		}
	    	},
	    	m_notesLeft : {
	    		m_notes : {
	    			CMapNoteAsset : _gen_narray(1, _fix_dec, _export_to_dym)
	    		}
	    	},
	    	m_notesRight : {
	    		m_notes : {
	    			CMapNoteAsset : _gen_narray(2, _fix_dec, _export_to_dym)
	    		}
	    	}
    	}
    }
    
    if(_export_to_dym) {
    	var _rbar = 0;
    	var _arr = [];
    	
    	with(objEditor) {
    		var l = array_length(timingPoints);
    		for(var i=0; i<l; i++) {
    			if(i>0)
    				_rbar += time_to_bar(timingPoints[i].time - timingPoints[i-1].time,
    					mspb_to_bpm(timingPoints[i-1].beatLength)/4);
    			
    			array_push(_arr, {
    				m_time : { text : string_format(_rbar, 1, EXPORT_XML_EPS) },
    				m_value : { text : string_format(mspb_to_bpm(timingPoints[i].beatLength)/4, 1, EXPORT_XML_EPS) }
    			});
    		}
    	}
    	
    	_str.CMap.m_argument = {
    		m_bpmchange : {
    			CBpmchange : _arr
    		}
    	}
    }
	
	objMain.savingExportId = 
		fast_file_save_async(_file, SnapToXML(snap_alter_to_xml(_str)));
	
	objManager.chartPath = _file;
	
	note_activation_reset();
}

function map_get_struct() {
	var _arr = [];
	
	with(objMain) {
		var i=0, l=chartNotesCount;
		for(; i<l; i++) {
			var _str = chartNotesArray[i];
			if(_str.noteType != 3)
				array_push(_arr, _str.get_prop(false));
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
	
	note_activation_reset();
	
	return _str;
}

function map_load_struct(_str, _import_info = true, _import_tp = true) {
	note_delete_all();
	
	with(objMain) {
		if(_import_info) {
			chartTitle = _str.title;
			chartDifficulty = _str.difficulty;
			chartSideType = _str.sidetype;
		}
		
		if(_import_tp) {
			chartBeatPerMin = _str.bpm;
			chartBarPerMin = _str.barpm;
			
			if(variable_struct_exists(_str, "barused"))
				chartBarUsed = _str.barused;
		}
	}
	
	var _arr = _str.notes;
	for(var i=0, l=array_length(_arr); i<l; i++) 
		build_note_withprop(_arr[i]);
	
	show_debug_message_safe("Load map from struct sucessfully.");
}

function map_get_alt_title() {
	if(!instance_exists(objMain)) return "example";
	var _forbidden_chars = "?*:\"<>\\/|"
	var _title = objMain.chartTitle;
	for(var i=1, l=string_length(_forbidden_chars); i<l; i++)
		_title = string_replace_all(_title, string_char_at(_forbidden_chars, i), "_");
	
	return _title;
}

function map_set_global_bar() {
	if(objMain.chartBarUsed) {
		var _resetq = show_question_i18n("bar_reset_question");
		if(_resetq) {
			objMain.chartBarUsed = false;
			objMain.showBar = false;
			announcement_play("bar_reset_complete");
		}
		return;
	}
	
	if(timing_point_sync_with_chart_prop(false, false))
		return;
	var _barpm = get_string_i18n(i18n_get("box_set_global_bar_1")+ " :", "");
	_barpm = string_real(_barpm);
	if(_barpm == "") return;
	var _offset = string_digits(get_string_i18n(i18n_get("box_set_global_bar_2")+":", ""));
	if(_offset == "") return;
	with(objMain) {
		chartBarPerMin = real(_barpm);
		chartBarUsed = true;
		chartTimeOffset = real(_offset);
		chartBarOffset = time_to_bar(chartTimeOffset);
	}
	
	announcement_play(i18n_get("anno_set_global_bar_complete") + ": " +_barpm+"/"+string(_offset));
	
}

function map_add_offset(_offset = "", record = false) {
	var _record = false;
	if(_offset == "") {
		var _nega = 1;
		_offset = get_string_i18n(i18n_get("box_add_offset"), "");
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
	
	with(objMain) {
		for(var i=0, l=array_length(chartNotesArray); i<l; i++) {
			chartNotesArray[i].time += _offset;
		}
	}
	
	announcement_play("anno_add_offset_complete");
	
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
    
    var _buf = buffer_load(_file);
    var _contents = json_parse(buffer_read(_buf, buffer_text));
    buffer_delete(_buf);
    
    map_reset();
    
    with(objManager) {
    	musicPath = _contents.musicPath;
    	backgroundPath = _contents.backgroundPath;
    	chartPath = _contents.chartPath;
    	if(variable_struct_exists(_contents, "videoPath"))
    		videoPath = _contents.videoPath;
    	else
    		videoPath = "";
    	
    	if(variable_struct_exists(_contents, "charts")) {
	    	objMain.animTargetTime = 0;
	    	map_load(_contents.charts);
	    }
	    else
	    	map_load(chartPath);
	    
	    music_load(musicPath);
	    if(backgroundPath != "")
	    	background_load(backgroundPath);
	    if(videoPath != "")
	    	background_load(videoPath);
	    	
	    timing_point_reset();
	    objEditor.timingPoints = _contents.timingPoints;
	    timing_point_sort();
	    
	    projectPath = _file;
	    
	    if(variable_struct_exists(_contents, "settings"))
	    	project_set_settings(_contents.settings);
    }
    
    ///// Old version workaround
    
	    if(version_cmp(_contents.version, "v0.1.5") < 0) {
	    	var _question = show_question_i18n(i18n_get("old_version_warn_1"));
			if(_question)
				map_add_offset(-64, true);
	    }
		
	/////
    
    announcement_play("anno_project_load_complete");
    
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
		version : VERSION,
		musicPath: objManager.musicPath,
		backgroundPath: objManager.backgroundPath,
		chartPath: objManager.chartPath,
		videoPath: objManager.videoPath,
		timingPoints: objEditor.timingPoints,
		charts: [],
		settings: project_get_settings()
	};
	
	_contents.charts = map_get_struct();
	
	objMain.savingProjectId = fast_file_save_async(_file, json_stringify(_contents));
	
	objManager.projectPath = _file;
	
	return 1;
}

function project_get_settings() {
	return {
		editside: editor_get_editside(),
		editmode: editor_get_editmode(),
		defaultWidth: objEditor.editorDefaultWidth,
		defaultWidthMode: objEditor.editorDefaultWidthMode,
		ntime: objMain.nowTime,
		fade: objMain.fadeOtherNotes
	};
}

function project_set_settings(str) {
	editor_set_editmode(str.editmode);
	if(str.editmode < 5)
		editor_set_editside(str.editside);
	with(objEditor) {
		editorDefaultWidth = str.defaultWidth;
		editorDefaultWidthMode = str.defaultWidthMode;
	}
	if(variable_struct_exists(str, "ntime")) {
		objMain.nowTime = str.ntime;
		objMain.animTargetTime = str.ntime;
	}
	if(variable_struct_exists(str, "fade")) {
		objMain.fadeOtherNotes = str.fade;
	}
}

function project_new() {
	
	var _confirm = show_question_i18n(i18n_get("new_project_warn"));
	if(!_confirm) return;
	
	with(objManager) {
		musicPath = "";
		backgroundPath = "";
		chartPath = "";
		projectPath = "";
	}
	
	map_close();
	
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
	
	announcement_play(i18n_get("anno_switch_theme_to") + " [[" + global.themes[global.themeAt].title + "]", 1000);
}

function theme_get() {
	return global.themes[global.themeAt];
}

#endregion

#region ANNOUNCEMENT FUNCTIONS

function announcement_play(_str, time = 3000, _uniqueID = "null") {
	_str = i18n_get(_str);
	
	var _below = 10;
	var _beside = 10;
	var _nx = global.resolutionW - _beside;
	var _ny = global.resolutionH - _below;
	
	if(_uniqueID == "null")
		_uniqueID = random_id(8);
	
	var _found = false;
	with(objManager) {
		var arr = announcements;
		for(var i=0, l=array_length(arr); i<l; i++)
			if(instance_exists(arr[i]) && arr[i].uniqueID == _uniqueID) {
				_found = true;
				with(arr[i]) {
					str = _str;
					lastTime = timer + time;
					_generate_element();
				}
			}
	}
	if(_found) return;
	
	var _inst = instance_create_depth(_nx, _ny, 0, objAnnouncement, {
		str: _str,
		lastTime: time,
		uniqueID: _uniqueID
	});
	
	array_push(objManager.announcements, _inst);
	show_debug_message_safe("NEW MD5 ANNO: " + _uniqueID);
}

function announcement_warning(str, time = 5000, uid = "null") {
	str = i18n_get(str);
	announcement_play("[c_warning][[" + i18n_get("anno_prefix_warn") + "] [/c]" + str, time, uid);
}

function announcement_error(str, time = 8000, uid = "null") {
	str = i18n_get(str);
	announcement_play("[#f44336][[" + i18n_get("anno_prefix_err") + "] " + str, time, uid);
}

function announcement_adjust(str, val) {
	str = i18n_get(str);
	announcement_play(str + ": " + i18n_get(val?"anno_adjust_enabled":"anno_adjust_disabled"), 3000, md5_string_unicode(str));
}

function announcement_set(str, val) {
	str = i18n_get(str);
	if(is_real(val))
		val = string_format(val, 1, 2);
	announcement_play(str + ": " + i18n_get(string(val)), 3000, md5_string_unicode(str));
}

#endregion

#region SYSTEM FUNCTIONS

function load_config() {
	if(!file_exists(global.configPath) || debug_mode)
		save_config();
	
	if(!file_exists(global.configPath))
		show_error("Config file creating failed.", true)
	
	var _buf = buffer_load(global.configPath);
	var _con = SnapBufferReadLooseJSON(_buf, 0);
	buffer_delete(_buf);
	
	// If config file is corrupted
	if(!is_struct(_con)) {
		show_error_i18n("error_config_file_corrupted", false);
		file_delete(global.configPath);
		load_config();
		return -1;
	}
	
	var _check_set = function (struct, struct_name, global_name = "") {
		if(global_name == "") global_name = struct_name;
		if(variable_struct_exists(struct, struct_name))
			variable_global_set(global_name, variable_struct_get(struct, struct_name));
	}
	
	_check_set(_con, "theme", "themeAt");
	_check_set(_con, "FPS", "fps");
	_check_set(_con, "resolutionH");
	_check_set(_con, "resolutionW");
	_check_set(_con, "autosave");
	_check_set(_con, "autoupdate");
	_check_set(_con, "FMOD_MP3_DELAY");
	_check_set(_con, "ANNOUNCEMENT_MAX_LIMIT");
	_check_set(_con, "fullscreen");
	if(variable_struct_exists(_con, "language"))
		i18n_set_lang(_con.language);
	_check_set(_con, "simplify");
	_check_set(_con, "updatechannel");
	_check_set(_con, "graphics");
		
	vars_init();
	
	return md5_file(global.configPath);
}

function save_config() {
	
	fast_file_save(global.configPath, SnapToJSON({
		theme: global.themeAt,
		FPS: global.fps,
		resolutionW: global.resolutionW,
		resolutionH: global.resolutionH,
		version: VERSION,
		autosave: global.autosave,
		autoupdate: global.autoupdate,
		FMOD_MP3_DELAY: global.FMOD_MP3_DELAY,
		ANNOUNCEMENT_MAX_LIMIT: global.ANNOUNCEMENT_MAX_LIMIT,
		fullscreen: global.fullscreen,
		language: i18n_get_lang(),
		simplify: global.simplify,
		updatechannel: global.updatechannel,
		graphics: global.graphics
	}, true));
	
}

function md5_config() {
	if(!file_exists(global.configPath))
		save_config();
	
	return md5_file(global.configPath);
}

function vars_init() {
	// Some variables that will take changes immediately
	
	if(debug_mode) global.fps = 165;
	game_set_speed(global.fps, gamespeed_fps);
	global.fpsAdjust = BASE_FPS / global.fps;
	global.scaleXAdjust = global.resolutionW / BASE_RES_W;
	global.scaleYAdjust = global.resolutionH / BASE_RES_H;
}

function switch_debug_info() {
	with(objMain) {
		showDebugInfo = !showDebugInfo;
		announcement_adjust("anno_debug_info", showDebugInfo);
	}
}

function switch_autosave(state = !global.autosave) {
	with(objManager) {
		if(state) {
			announcement_play("autosave_enable", 2000);
			time_source_start(tsAutosave);
		}
		else {
			announcement_play("autosave_disable", 2000);
			time_source_stop(tsAutosave);
		}
		global.autosave = state;
	}
}

#endregion

#region STAT FUNCTIONS

function stat_reset() {
	objMain.statCount = [
		[0, 0, 0, 0],
		[0, 0, 0, 0],
		[0, 0, 0, 0],
		[0, 0, 0, 0]
		];
}

function stat_count(side, type) {
	if(type > 2)
		return;
	
	with(objMain) {
		statCount[side][type] ++;
		statCount[side][3] += 1 + (type == 2);
		statCount[3][type] ++;
		statCount[3][3] += 1 + (type == 2);
	}
}

function stat_string(stype, ntype) {
	with(objMain)
		if(stype == 1) {
			return string(statCount[3][ntype]);
		}
		else if(stype == 2) {
			return string_concat(statCount[1][ntype],"/",
								 statCount[0][ntype],"/",
								 statCount[2][ntype]);
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

function game_end_confirm() {
	var _confirm_exit = instance_exists(objMain) ? show_question_i18n("confirm_close") : true;
	if(_confirm_exit)
		game_end();
}