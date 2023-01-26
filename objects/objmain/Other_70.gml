
var _type = async_load[? "type"];

if(_type == "video_start" && !bgVideoLoaded) {
	
	bgVideoLoaded = true;
	bgVideoLength = video_get_duration();
	video_pause();
	
	if(!bgVideoReloading)
		announcement_play("视频加载完毕。");
	bgVideoReloading = false;
}
else if(_type == "video_end") {
	bgVideoReloading = true;
	video_load(objManager.videoPath);
	show_debug_message("VIDEO PLAYBACK FINISHED.");
}