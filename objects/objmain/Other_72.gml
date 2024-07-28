
if(async_load[? "id"] == savingExportId.id) {
	if(async_load[? "status"])
		announcement_play("anno_export_complete");
	else
		announcement_error("anno_export_failed");
	buffer_delete(savingExportId.buffer);
	savingExportId.id = -1;
}