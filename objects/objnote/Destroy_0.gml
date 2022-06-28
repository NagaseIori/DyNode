/// @description Delete id in array and map

if(instance_exists(sinst))
    instance_destroy(sinst);

note_delete(sid);
note_delete(nid);