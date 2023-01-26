/// @description Video Events

var _type = async_load[? "type"];

if(_type == "video_start") {
	if(!bgVideoDisplay) {
		bgVideoLoaded = true;
		bgVideoLength = video_get_duration();
		safe_video_pause();
		
		if(!bgVideoReloading)
			announcement_play("视频加载完毕。");
	}
	bgVideoDisplay = true;
	bgVideoReloading = false;
}
else if(_type == "video_end") {
	bgVideoReloading = true;
	bgVideoDisplay = false;
	video_load(objManager.videoPath);
	show_debug_message("VIDEO PLAYBACK FINISHED.");
}