/// DyCore Interface.

enum DYCORE_ASYNC_EVENT_TYPE { PROJECT_SAVING };
function DyCoreManager() constructor {
    // DyCore Step function.
    static step = function() {
        // Manage async events.
        if(DyCore_has_async_event())
            do_async_events(json_parse(DyCore_get_async_event()));
    }

    static do_async_events = function(event) {
        switch(event[$ "type"]) {
            case DYCORE_ASYNC_EVENT_TYPE.PROJECT_SAVING:
                if(event[$ "status"] == 0) {
                    if(objManager.autosaving) {
                        if(editor_get_editmode() != 5)  // Ignore announcement when edit mode is playback.
                            announcement_play("autosave_complete");
                        objManager.autosaving = false;
                    }
                    else
                        announcement_play("anno_project_save_complete");
                }
                else {
                    announcement_error(i18n_get("anno_project_save_failed", event[$ "message"]));
                }
                break;
            default:
                show_debug_message("!Warning: Unknown dycore async event type.");
                break;
        }
    }
}