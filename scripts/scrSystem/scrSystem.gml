

// After loading map, map_init is called to init objMain again.
function map_init() {
        
    with(objMain) {
        // Reset to beginning
        nowOffset = _time_to_offset(0);
        animTargetOffset = nowOffset;
        
        // Pre-cache Title Element
        titleElement = scribble(chartTitle).starting_format("fDynamix48", c_white)
        .align(fa_left, fa_middle)
        .transform(0.7, 0.7);
        titleElement.build(true);
        
        // Sort Notes Array base on time
        var _f = function(_a, _b) {
            return _a.offset < _b.offset;
        }
        // show_debug_message("ARRAY LENGTH:"+string(array_length(chartNotesArray)));
        // show_debug_message("ARRAY:"+string(chartNotesArray));
        array_sort_f(chartNotesArray, _f);
    }
    
}

function map_load() {
    var _file = "";
    _file = get_open_filename_ext("XML Files|*.xml", "example.xml", 
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

function build_note(_id, _type, _time, _position, _width, _subid, _side) {
    var _obj = undefined;
    switch(_type) {
        case "NORMAL":
            _obj = objNote;
            break;
        case "CHAIN":
            _obj = objChain;
            break;
        case "HOLD":
            _obj = objHold;
            break;
        case "SUB":
            _obj = objHoldSub;
            break;
        default:
            return;
    }
    var _inst = instance_create_depth(0, 0, 0, _obj);
    _inst.width = real(_width);
    _inst.side = real(_side);
    _inst.offset = real(_time);
    _inst.position = real(_position);
    _inst.nid = _id;
    _inst.sid = _subid;
    
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
    }
    
    return 0;
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
                        objMain.chartOffset = real(_val);
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
}

function music_load() {
    var _file = "";
    _file = get_open_filename_ext("Music Files|*.mp3;*.flac;*.wav;*.ogg", "", 
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
        sampleRate = FMODGMS_Chan_Get_Frequency(channel);
        musicLength = FMODGMS_Snd_Get_Length(music);
        musicLength = FMODGMS_Util_SamplesToSeconds(musicLength, sampleRate) * 1000;
    }
    
    show_debug_message("Load sucessfully.");
}

function image_load() {
    var _file = "";
    _file = get_open_filename_ext("Image Files|*.jpg;*.png|JPG Files|*.jpg|PNG Files|*.png", "",
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

function sfmod_channel_get_position(channel, spr) {
    var _ret = FMODGMS_Chan_Get_Position(channel);
    _ret = FMODGMS_Util_SamplesToSeconds(_ret, spr) * 1000.0;
    return _ret;
}

function sfmod_channel_set_position(pos, channel, spr) {
    pos = FMODGMS_Util_SecondsToSamples(pos / 1000.0, spr);
    FMODGMS_Chan_Set_Position(channel, pos);
}