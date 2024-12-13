/// @description GUI Draw

if(global.__GUIManager != undefined)
	global.__GUIManager.draw();

// Update process draw.

if(_update_status == UPDATE_STATUS.DOWNLOADING ||
	_update_status == UPDATE_STATUS.CHECKING_I || _update_status == UPDATE_STATUS.CHECKING_II) {

	var progress = "";
	if(_update_size > 0)
		progress = string_format(_update_received / _update_size * 100, 1, 2) + "%";
	
	if(!stat_visible())
		scribble("Updating ... " + progress)
			.starting_format("fMono16", c_white)
			.align(fa_center, fa_bottom)
			.draw(global.resolutionW / 2, global.resolutionH)
}
else if(_update_status == UPDATE_STATUS.UNZIP) {
	if(!stat_visible())
		scribble("Unzipping ... ")
			.starting_format("fMono16", c_white)
			.align(fa_center, fa_bottom)
			.draw(global.resolutionW / 2, global.resolutionH)
}