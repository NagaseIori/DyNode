

function ButtonSideSwitcher(_id, _x, _y, _side) : StateButton(_id, _x, _y, "", 0) constructor {
    side = _side;
    content = string_char_at("DLR", _side+1);
    get_value = function () {
        return editor_get_editmode() != 5 && editor_get_editside() == side;
    }
    
    custom_action = function (val) {
        if(!val) {
            editor_set_editside(side);
            return true;
        }
        return val;
    }
}

function BarVolumeMain(_id, _x, _y) : Bar(_id, _x, _y, "Main Volume", 0, 0) constructor {
	range = [0, 1];
// 	updateColddown = 200;
    get_active = function () {
        return objMain.music!=undefined;
    }
    get_value = function () {
        if(!active) return 0;
        return FMODGMS_Chan_Get_Volume(objMain.channel);
    }
    custom_action = function() {
        FMODGMS_Chan_Set_Volume(objMain.channel, value);
    }
    
    update_active();
    value = get_value();
    aval = value;
    atval = value;
}

function BarVolumeHitSound(_id, _x, _y) : Bar(_id, _x, _y, "Main Volume", 0, 0) constructor {
	range = [0, 1];
	active = true;
	get_active = function() {
		return instance_exists(objMain);
	}
    get_value = function () {
    	if(!active) return;
    	if(!objMain.hitSoundOn)
    		return 0;
        return audio_sound_get_gain(sndHit);
    }
    custom_action = function() {
        if(value == 0) {
        	objMain.hitSoundOn = false;
        }
        else {
        	objMain.hitSoundOn = true;
        	audio_sound_gain(sndHit, value, 0);
        }
    }
    
    update_active();
    value = get_value();
    aval = value;
    atval = value;
}