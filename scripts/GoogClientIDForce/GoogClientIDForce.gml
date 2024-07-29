/// @param id
/// 
/// Forces the client ID to the given value. This library automatically generates a client ID for the user so this is rarely 
/// 
/// The ID provided to this function should be a UUIDv4 (http://www.ietf.org/rfc/rfc4122.txt)

function GoogClientIDForce(_id)
{
    if (_id != global.__GoogClientID)
    {
        global.__GoogClientID = string(_id);
        __GoogTrace("Set client ID to \"", global.__GoogClientID, "\"");
    }
}