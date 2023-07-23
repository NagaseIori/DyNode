

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

function BarVolumeMain(_id, _x, _y) : Bar(_id, _x, _y, i18n_get("tab_main_volume"), 0, 0) constructor {
	range = [0, 1];
// 	updateColddown = 200;
    get_active = function () {
        return objMain.music!=undefined;
    }
    get_value = function () {
        return objMain.volume_get_main();
    }
    custom_action = function() {
        objMain.volume_set_main(value);
    }
    
    update_active();
    value = get_value();
    aval = value;
    atval = value;
}

function BarVolumeHitSound(_id, _x, _y) : Bar(_id, _x, _y, i18n_get("tab_hitsound_volume"), 0, 0) constructor {
	range = [0, 1];
	active = true;
	get_active = function() {
		return instance_exists(objMain);
	}
    get_value = function () {
    	if(!active) return;
    	return objMain.volume_get_hitsound();
    }
    custom_action = function() {
        objMain.volume_set_hitsound(value);
    }
    
    update_active();
    value = get_value();
    aval = value;
    atval = value;
}

function BarBackgroundDim(_id, _x, _y) : Bar(_id, _x, _y, i18n_get("tab_bg_dim"), 0, 0) constructor {
	range = [0, 1];
	active = true;
	get_active = function() {
		return instance_exists(objMain);
	}
	get_value = function () {
    	if(!active) return;
    	return objMain.bgDim;
    }
    custom_action = function() {
    	objMain.bgDim = value;
    }
    
    update_active();
    value = get_value();
    aval = value;
    atval = value;
}