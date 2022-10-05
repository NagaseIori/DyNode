
if(delta_time / 1000 < 100) {
    timer += delta_time / 1000;
}
	

if(lastTime < timer) {
    image_alpha -= objManager.animAnnoSpeed;
    if(image_alpha < 0.01)
        instance_destroy();
}
else {
    image_alpha = lerp_a(image_alpha, animTargetAlpha, 0.3);
}

nowShiftY = lerp_a(nowShiftY, targetY, 0.3);
