
function GUIElement() constructor {
    value = undefined;      // contained value
    name = undefined;       // id
    content = undefined;   // things to draw
    manager = global.__GUIManager;
    
    ds_list_add(manager.elements, self);
    
    // Layout
    width = 100;
    height = 64;
    padding = 16;
    rounding = 5;
    color = c_white;
    fontSize = 16;
    
    // States
    inbound = false;
    focus = false;
    active = true;
    pressing = 0;       // probably for animation...
    
    // Animation Prop
    aspd = 0.4;                 // Animation Speed
    amagnet = 0.03;            // Mouse Magnet Effect
    ashrink = [0.1, -0.05];     // Element Shrink Effect
                                // [0] = inbound; [1] = pressing
    
    x = 0;
    y = 0;
    
    center = {
        x: 0,
        y: 0
    };
    
    // Animation States
    acenter = {
        x: 0,
        y: 0
    };  // Animation Center
    atcenter = {
        x: 0,
        y: 0
    };  // Animation Target Center
    
    ascale = 1;
    atscale = 1;
    
    // Focus part
    static focus_action = function () { };
    static has_focus = function() {
        return focus;
    }
    static set_focus = function() {
        focus = true;
        
        manager.element_in_focus = self;
        
        show_debug_message("Element "+name+" focused.");
    }
    static remove_focus = function() {
        focus = false;
        
        manager.element_in_focus = undefined;
        
        show_debug_message("Element "+name+" unfocused.");
    }
    
    // Animation Effects
    static _a_magnet = function() {
        atcenter = lerp_pos(
                center,
                { x: mouse_x, y: mouse_y},
                amagnet
            );
    }
    static _a_shrink = function(_pressing) {
        atscale = 1 + ashrink[_pressing];
    }
    
    // Inbound part
    static update_inbound = function() {
        inbound = mouse_inbound(x, y, x+width, y+height);
    }
    
    // Value Fetcher
    static get = function() { return value; }
    static set = function(_val) { value = _val; }
    
    // Active part
    static set_active = function() {
        active = true;
    }
    static remove_active = function() {
        active = false;
    }
    static get_active = function() {
        return active;
    }
    static update_active = function() {
        active = get_active();
    }
    
    // Position part
    static set_position = function(_x, _y) {
        x = _x;
        y = _y;
        center = { x:x, y:y };
        acenter = center;
        atcenter = center;
    }
    
    // Events
    static step = function() {
        update_inbound();
        update_active();
        center.x = x + width/2;
        center.y = y + height/2;
        atcenter = center;
        atscale = 1;
        
        if(inbound) {
            if(!pressing && mouse_check_button_pressed(mb_left)) {
                pressing = 1;
            }
            else if(pressing && mouse_check_button_released(mb_left))
                pressing = 0;
            
            _a_shrink(pressing);
            _a_magnet();
            
            if(mouse_isclick_l()) {
                click();
                mouse_clear_click();
            }
            else if(mouse_ishold_l() && mouse_inbound_last_l(x, y, x+width, y+height)) {
                drag();
                mouse_clear_hold();
            }
        }
        else pressing = 0;
        
        acenter = lerp_a_pos(acenter, atcenter, aspd);
        ascale = lerp_a(ascale, atscale, aspd);
    }
    static click = function() {
        set_focus();
        show_debug_message("Element "+name+" is clicked.");
    }
    static drag = function() {
        set_focus();
        show_debug_message("Element "+name+" is dragged.");
    }
    static listen = function() { }
    
    static custom_action = function() { }

    // Draw
    static draw = function() {
        var _x = acenter.x;
        var _y = acenter.y;
        CleanRectangleXYWH(_x, _y, width*ascale, height*ascale)
            .Blend(c_white, 1)
            .Border(0, c_white, 0)
            .Rounding(rounding)
            .Draw();
        
        var _content = content;
        if(has_cjk(content)) _content = cjk_prefix() + content;
        scribble(content)
            .starting_format("mDynamix", c_black)
            .align(fa_center, fa_middle)
            .scale(ascale, ascale)
            .draw(_x, _y);
    } 
    static destroy = function() {
        ds_list_delete(manager.elements,
            ds_list_find_index(manager.elements, self)
        );
    }
}

// Button: Click to do an action
// _content: Element description string to draw
// _action: custom action, called when value is changed
function Button(_id, _x, _y, _content, _action = undefined, _active_check = undefined) : GUIElement() constructor {
    if(!is_undefined(_active_check))
        get_active = _active_check;
    
    if(!is_undefined(_action))
        custom_action = _action;
    
    content = _content;
    set_position(_x, _y);
    name = _id;
    
    static click = function() {
        if(!active) return;
        
        custom_action();
        
        show_debug_message("Button "+name+" is clicked.");
    }
}

// Bar: Drag or Click to set value
// _range: should be an array including 2 elements = [range_l, range_r]
// _action: custom action, called when value is changed
function Bar(_id, _x, _y, _content, _range, _action = undefined, _active_check = undefined) : GUIElement() constructor {
    if(!is_undefined(_active_check))
        get_active = _active_check;
    
    if(!is_undefined(_action))
        custom_action = _action;
        
    content = _content;
    set_position(_x, _y);
    name = _id;
    
    value = 0.5;
    range = _range;
    
    // Animation States
    aval = 0;
    atval = 0;
    
    // Animation Props
    ashrink = [0.01, -0.01];
    amagnet = 0.01;
    aspdval = 0.4;
    
    static get_progress = function() {
        var _prog = clamp((mouse_x - x)/width, 0, 1);
        return _prog;
    }
    
    static click = function() {
        set(get_progress());
    }
    
    static listen = function() {
        if(mouse_check_button_released(mb_left)) remove_focus();
        
        set(get_progress());
    }
    
    static __step = step;
    static step = function() {
        __step();
        atval = value;
        aval = lerp_a(aval, atval, aspdval);
    }
    
    static get = function() {
        return lerp(range[0], range[1], value);
    }
    
    static draw = function() {
        var _x = acenter.x;
        var _y = acenter.y;
        CleanRectangleXYWH(_x, _y, width*ascale, height*ascale)
            .Blend(c_black, 1)
            .Border(0, c_black, 0)
            .Rounding(rounding)
            .Draw();
        
        CleanRectangleXYWH(_x - width*ascale*(0.5-aval/2), _y, width*ascale*aval, height*ascale)
            .Blend(c_white, 1)
            .Border(0, c_white, 0)
            .Rounding(rounding)
            .Draw();
    }
}

function GUIManager() constructor {
    global.__GUIManager = self;
    
    elements = ds_list_create();
    
    element_in_focus = undefined;
    
    static step = function() {
        if(mouse_isclick_l()) {
            if(!is_undefined(element_in_focus))
                element_in_focus.remove_focus();
        }
        
        for(var i=ds_list_size(elements)-1; i>=0; i--) {
            elements[| i].step();
        }
        
        if(element_in_focus != undefined)
            element_in_focus.listen();
    }
    
    static draw = function() {
        for(var i=ds_list_size(elements)-1; i>=0; i--) {
            elements[| i].draw();
        }
    }
    
    static destroy = function() {
        for(var i=ds_list_size(elements)-1; i>=0; i--) {
            delete elements[| i];
        }
        ds_list_destroy(elements);
        delete global.__GUIManager;
        global.__GUIManager = undefined;
    }
}