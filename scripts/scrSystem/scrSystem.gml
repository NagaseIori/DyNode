
function note_all_sort() {
    var _f = function(_a, _b) {
        return _a.time < _b.time;
    }
    array_sort_f(objMain.chartNotesArray, _f);
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
                time = bar_to_time(bar);           // Bar to Chart Time in ms
                time = time_to_mtime(time);         // Chart Time to Music Time in ms (Fix the offset to 0)
            }
        }
        
        chartTimeOffset = 0;                        // Set the offset to 0
        
        // Reset to the beginning
        nowTime = 0;                                // Now music time equals chart time
        animTargetTime = nowTime;
        
        // Pre-cache Title Element
        titleElement = scribble(chartTitle).starting_format("fDynamix48", c_white)
        .align(fa_left, fa_middle)
        .transform(0.7, 0.7);
        titleElement.build(true);
        
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

function map_load() {
    var _file = "";
    _file = get_open_filename_ext("XML Files (*.xml)|*.xml", "example.xml", 
        program_directory, "Load Dynamix Chart File 加载谱面文件");
        
    if(_file == "") return;
    
    // Cleanup.
    instance_destroy(objMain);
    instance_create_depth(0, 0, 0, objMain);
    
    
    if(!file_exists(_file)) {
        show_error("Map file " + _file + " doesnt exist.", false);
        return;
    }
    
    if(filename_ext(_file) == ".xml")
        map_load_xml(_file);
    
    map_init();
    
    show_debug_message("Load sucessfully.");
}

function build_note(_id, _type, _time, _position, _width, _subid, _side, _fromxml = true) {
    var _obj = undefined;
    switch(_type) {
        case "NORMAL":
        case 0:
            _obj = objNote;
            break;
        case "CHAIN":
        case 1:
            _obj = objChain;
            break;
        case "HOLD":
        case 2:
            _obj = objHold;
            break;
        case "SUB":
        case 3:
            _obj = objHoldSub;
            break;
        default:
            return;
    }
    var _inst = instance_create_depth(0, 0, 0, _obj);
    _inst.width = real(_width);
    _inst.side = real(_side);
    // _inst.offset = real(_time);
    if(_fromxml)
        _inst.bar = real(_time);
    else
        _inst.time = _time;
    _inst.position = real(_position);
    _inst.nid = _id;
    _inst.sid = _subid;
    
    if(_fromxml)
        _inst.position += _inst.width/2;
    
    with(_inst) _prop_init();
    with(objMain) {
        array_push(chartNotesArray, _inst);
        if(ds_map_exists(chartNotesMap[_inst.side], _id)) {
            show_error_async("Duplicate Note ID " + _id + " in side " 
                + string(_side), false);
            return true;
        }
        chartNotesMap[_inst.side][? _id] = _inst;
        
        if(!_fromxml)
            note_all_sort();
    }
}

function note_delete(_id) {
    with(objMain) {
        var l=array_length(chartNotesArray);
        for(var i=0; i<l; i++)
            if(chartNotesArray[i].nid == _id) {
                var _insta = chartNotesArray[i];
                array_delete(chartNotesArray, i, 1);
                if(_insta.sid != -1)
                    note_delete(_insta.sid);
                instance_destroy(_insta);
                break;
            }
    }
    note_all_sort();
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

function music_load() {
    var _file = "";
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
        music = FMODGMS_Snd_LoadSound(_file);
        FMODGMS_Snd_PlaySound(music, channel);
        if(!nowPlaying) FMODGMS_Chan_PauseChannel(channel);
        else {
            nowTime = chartTimeOffset;
        }
        sampleRate = FMODGMS_Chan_Get_Frequency(channel);
        musicLength = FMODGMS_Snd_Get_Length(music);
        musicLength = FMODGMS_Util_SamplesToSeconds(musicLength, sampleRate) * 1000;
    }
    
    show_debug_message("Load sucessfully.");
}

function image_load() {
    var _file = "";
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
        
        bgImageFile = _file;
        bgImageSpr = _nspr;
        
        // Bottom reset
        
        surface_free_f(bottomBgSurf);
        bottomBgSurf = -1;
    }
    
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
    
    DerpXmlWrite_New();
    DerpXmlWrite_OpenTag("CMap");
        DerpXmlWrite_LeafElement("m_path", objMain.chartTitle);
        DerpXmlWrite_LeafElement("m_barPerMin", objMain.chartBarPerMin);
        DerpXmlWrite_LeafElement("m_timeOffset", "0");
        DerpXmlWrite_LeafElement("m_leftRegion", objMain.chartSideType[0]);
        DerpXmlWrite_LeafElement("m_rightRegion", objMain.chartSideType[1]);
        DerpXmlWrite_LeafElement("m_mapID", _mapid);
        
        // Down Side Notes
        var l = array_length(objMain.chartNotesArray);
        DerpXmlWrite_OpenTag("m_notes");
            DerpXmlWrite_OpenTag("m_notes");
                for(var i=0; i<l; i++) with objMain.chartNotesArray[i] {
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
                for(var i=0; i<l; i++) with objMain.chartNotesArray[i] {
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
                for(var i=0; i<l; i++) with objMain.chartNotesArray[i] {
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
}

function sfmod_channel_get_position(channel, spr) {
    var _ret = FMODGMS_Chan_Get_Position(channel);
    _ret = FMODGMS_Util_SamplesToSeconds(_ret, spr) * 1000.0;
    return _ret;
}

function sfmod_channel_set_position(pos, channel, spr) {
    pos = FMODGMS_Util_SecondsToSamples(pos / 1000.0, spr);
    FMODGMS_Chan_Set_Position(channel, pos);
}