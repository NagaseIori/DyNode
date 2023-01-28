/// @description Video Events

var _type = async_load[? "type"];

if(_type == "video_start") {
	if(!bgVideoDisplay) {
		bgVideoLoaded = true;
		bgVideoLength = video_get_duration();
		safe_video_pause();
		
		if(!bgVideoReloading)
			announcement_play("video_load_finished");
	}
	bgVideoDisplay = true;
	bgVideoReloading = false;
}
else if(_type == "video_end") {
	if(bgVideoDestroying) {
		bgVideoDestroying = false;
		return;
	}
	
	// Idk why i have to add this line but this does work
	if(objManager.videoPath != "") {
		video_load(objManager.videoPath);
		bgVideoReloading = true;
		bgVideoDisplay = false;
		show_debug_message_safe("Video reloading.");
	}
		
}