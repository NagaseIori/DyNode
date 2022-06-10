
// Inherit the parent event
event_inherited();

if(visible && (sinst != -1 || (sid != -1 && ds_map_exists(objMain.chartNotesMap[side], sid)))) {
    if(sinst == -1)
        sinst = objMain.chartNotesMap[side][? sid]
    
    // Sync the properties
    sinst.position = position;
    sinst.width = width;
    sinst.depth = depth;
    
    pHeight = objMain.playbackSpeed * (sinst.time - max(time, objMain.nowTime))
        + dFromBottom + uFromTop;
    pHeight = max(pHeight, originalHeight);
    
    lastTime = sinst.time - time;
    lastTime = max(lastTime, 0.0001);
    
    edgeScaleY = pHeight / originalHeight;
}

image_yscale = 1;