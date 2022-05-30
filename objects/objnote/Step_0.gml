
x = note_pos_to_x(position, side);
y = global.resolutionH
    - (objMain.playbackSpeed * (offset - objMain.nowOffset) + objMain.targetLineBelow);

if(y<-100 || y>global.resolutionH) visible = false;
else visible = true;

if(visible) {
    pWidth = width * 300 - 30;
    pWidth = max(pWidth, originalWidth);
    
    image_xscale = pWidth / originalWidth;
    image_alpha = lerp(image_alpha, animTargetA, animSpeed * global.fpsAdjust);
    
    
    state();
}
    