

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