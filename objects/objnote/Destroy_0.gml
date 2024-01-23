/// @description Delete id in array and map

if(noteType == 2) {
	instance_activate_object(sinst);
	instance_destroy(sinst);
}

note_delete(id, recordRequest);

if(state == stateAttachSub || state == stateDropSub) {
	edtior_lrside_lock_set(false);
}