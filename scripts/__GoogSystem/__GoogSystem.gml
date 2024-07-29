#macro GOOG_USER_PROPERTIES  global.__GoogUserProperties

#macro __GOOG_VERSION  "1.0.0"
#macro __GOOG_DATE     "2022-01-09"

__GoogTrace("Welcome to Google Analytics Measuremenet Protocol (v4), implemented by @jujuadams! This is version " + __GOOG_VERSION + ", " + __GOOG_DATE);

global.__GoogClientID         = undefined;
global.__GoogUserID           = undefined;
global.__GoogUserProperties   = {};
global.__GoogHTTPResponseMap  = ds_map_create();
global.__GoogFirstRequestTime = undefined;
global.__GoogUsingAsyncEvent  = undefined;
global.__GoogURL              = "https://www.google-analytics.com/mp/collect?measurement_id=" + GOOG_MEASUREMENT_ID + "&api_secret=" + GOOG_API_SECRET;

global.__GoogHeaderMap = ds_map_create();
global.__GoogHeaderMap[? "Content-Type"] = "application/json";

//Set up the XORShift32 starting seed
global.__GoogXORShift32State = floor(1000000*date_current_datetime() + display_mouse_get_x() + display_get_width()*display_mouse_get_y());



var _generateClientID = true;
if (file_exists(GOOG_PERSISTENT_CACHE))
{
    __GoogTrace("Found persistent cache, trying to load");
    
    try
    {
        var _buffer = buffer_load(GOOG_PERSISTENT_CACHE);
        var _string = buffer_read(_buffer, buffer_string);
        var _json = json_parse(_string);
        
        GoogClientIDForce(_json.clientID);
        
        __GoogTrace("Persistent cache loaded successfully");
        _generateClientID = false;
    }
    catch(_)
    {
        __GoogTrace("Warning! Persistent cache failed to load, generating a new client ID");
    }
}
else
{
    __GoogTrace("No persistent cache found, generating a new client ID");
}

if (_generateClientID)
{
    GoogClientIDForce(__GoogGenerateUUID4String(true));
    
    //Save out the generated client ID to our cache for use next time
    var _string = json_stringify({ clientID: GoogClientIDGet() });
    var _buffer = buffer_create(string_byte_length(_string), buffer_fixed, 1);
    buffer_write(_buffer, buffer_text, _string);
    buffer_save(_buffer, GOOG_PERSISTENT_CACHE);
    buffer_delete(_buffer);
    
    __GoogTrace("Persistent cache saved to disk");
}

//If we don't have a user ID, set that now
if (global.__GoogUserID == undefined) GoogUserIDForce(md5_string_utf8(global.__GoogClientID));



//Google Analytics wants timestamps using microseconds for some reason?
function __GoogUnixTimeMicroseconds()
{
    return floor(1000000*date_second_span(25569, date_current_datetime()));
}

/// @param [hyphenate=false]
function __GoogGenerateUUID4String(_hyphenate = false)
{
    //As per https://www.cryptosys.net/pki/uuid-rfc4122.html (though without the hyphens)
    var _UUID = md5_string_utf8(string(current_time) + string(date_current_datetime()) + string(__GoogXORShift32Random(1000000)));
    _UUID = string_set_byte_at(_UUID, 13, ord("4"));
    _UUID = string_set_byte_at(_UUID, 17, ord(__GoogXORShift32Choose("8", "9", "a", "b")));
    
    if (_hyphenate)
    {
        _UUID = string_copy(_UUID, 1, 8) + "-" + string_copy(_UUID, 9, 4) + "-" + string_copy(_UUID, 13, 4) + "-" + string_copy(_UUID, 17, 4) + "-" + string_copy(_UUID, 21, 12);
    }
    
    return _UUID;
}

//Basic XORShift32, nothing fancy
function __GoogXORShift32Random(_value)
{
    var _state = global.__GoogXORShift32State;
    _state ^= _state << 13;
    _state ^= _state >> 17;
    _state ^= _state <<  5;
    global.__GoogXORShift32State = _state;
    
	return _value * abs(_state) / (real(0x7FFFFFFFFFFFFFFF) + 1.0);
}

function __GoogXORShift32Choose()
{
    return argument[floor(__GoogXORShift32Random(argument_count))];
}

function __GoogTrace()
{
    var _string = "Google Analytics: ";
    
    var _i = 0;
    repeat(argument_count)
    {
        _string += argument[_i];
        ++_i;
    }
    
    show_debug_message(_string);
    
    return _string;
}