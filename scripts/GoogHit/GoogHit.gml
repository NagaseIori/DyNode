/// @param eventName
/// @param eventParameterStruct
/// @param [eventName]
/// @param [eventParameterStruct]
/// @param ...
/// 
/// Sends a set of events to Google Analytics with the given name and, optionally, some parameters defined in a struct
/// You must use event names and parameters from Google's specification, see https://developers.google.com/analytics/devguides/collection/protocol/ga4/reference/events

function GoogHit()
{
    //Build an array of events in the format Google expects from the arguments passed into the function
    var _eventArray = array_create(argument_count div 2);
    var _i = 0;
    repeat(argument_count div 2)
    {
        _eventArray[@ _i] = {
            name: argument[2*_i],
            params: argument[2*_i + 1],
        };
        
        ++_i;
    }
    
    var _data = { //TODO - Optimize by building this string manually without needing to allocate a struct that is then immediately JSONified
        client_id: global.__GoogClientID,
        user_id: global.__GoogUserID,
        user_properties: global.__GoogUserProperties,
        non_personalized_ads: true,
        timestamp_micros: __GoogUnixTimeMicroseconds(),
        events: _eventArray,
    };
    
    var _string = json_stringify(_data);
    var _id = http_post_string(global.__GoogURL, _string);
    if (GOOG_DEBUG) __GoogTrace("Sent HTTP request for event \"", _string, "\"");
    
    if (global.__GoogFirstRequestTime == undefined) global.__GoogFirstRequestTime = current_time;
    
    if ((global.__GoogUsingAsyncEvent == undefined) && (current_time - global.__GoogFirstRequestTime > 30000))
    {
        if (os_is_network_connected(false))
        {
            __GoogTrace("Warning! No async HTTP event handled, make sure GoogAsyncHTTPEvent() is being called in a persistent object");
            global.__GoogUsingAsyncEvent = false;
            ds_map_clear(global.__GoogHTTPResponseMap);
        }
        else
        {
            global.__GoogFirstRequestTime = undefined;
        }
    }
    
    if ((global.__GoogUsingAsyncEvent == undefined) || global.__GoogUsingAsyncEvent)
    {
        global.__GoogHTTPResponseMap[? _id] = _string;
    }
}