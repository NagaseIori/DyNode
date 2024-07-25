
if(async_load[? "id"] == savingProjectId.id) {
	if(async_load[? "status"]) {
		if(objManager.autosaving) {
			announcement_play("autosave_complete");
			objManager.autosaving = false;
		}
		else
			announcement_play("anno_project_save_complete");
	}
	else
		announcement_error("anno_project_save_failed");
	buffer_delete(savingProjectId.buffer);
	savingProjectId.id = -1;
}

else if(async_load[? "id"] == savingExportId.id) {
	if(async_load[? "status"])
		announcement_play("anno_export_complete");
	else
		announcement_error("anno_export_failed");
	buffer_delete(savingExportId.buffer);
	savingExportId.id = -1;
}