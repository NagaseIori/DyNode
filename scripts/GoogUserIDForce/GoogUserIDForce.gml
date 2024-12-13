/// @param id
/// 
/// Forces the user ID to the given value. This library automatically generates a user ID for the user so this is rarely necessary
/// 
/// For more information see https://support.google.com/analytics/answer/9213390

function GoogUserIDForce(_id)
{
    if (_id != global.__GoogUserID)
    {
        global.__GoogUserID = string(_id);
        __GoogTrace("Set user ID to \"", global.__GoogUserID, "\"");
    }
}