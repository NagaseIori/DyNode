
var _type = async_load[? "type"];

if(_type == "video_start") {
	bgVideoLoaded = true;
	bgVideoLength = video_get_duration();
	video_pause();
	announcement_play("视频加载完毕。");
}
else if(_type == "video_end") {
	video_pause();
}