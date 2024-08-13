/// Call this function in the Async HTTP Event of a persistent object
/// 
/// It's not *technically* required to ever call this function but it is very useful for tracking down bugs

function GoogAsyncHTTPEvent()
{
    var _id = async_load[? "id"];
    if (ds_map_exists(global.__GoogHTTPResponseMap, _id))
    {
        if(async_load[? "status"] != 0) return;
        if (global.__GoogUsingAsyncEvent == undefined)
        {
            if (GOOG_DEBUG) __GoogTrace("Confirmed use of GoogAsyncHTTPEvent()");
            global.__GoogUsingAsyncEvent = true;
        }
        
        if (async_load[? "http_status"] != undefined && floor(async_load[? "http_status"]/100) == 2)
        {
            if (GOOG_DEBUG)
            {
                __GoogTrace("HTTP request successful (", global.__GoogHTTPResponseMap[? _id], ")");
            }
        }
        else
        {
            __GoogTrace("Warning! HTTP request failed, check your event name and parameters (", global.__GoogHTTPResponseMap[? _id], ")");
        }
        
        ds_map_delete(global.__GoogHTTPResponseMap, _id);
    }
}