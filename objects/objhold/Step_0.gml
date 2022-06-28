
// Inherit the parent event
event_inherited();

if(visible && (sinst != -1 || (sid != -1 && ds_map_exists(objMain.chartNotesMap[side], sid)))) {
    if(sinst == -1)
        sinst = objMain.chartNotesMap[side][? sid]
    
    // Being destroyed
    if(!instance_exists(sinst))
        return;
    
    // Sync the properties
    sinst.position = position;
    sinst.width = width;
    sinst.depth = depth;
    sinst.side = side;
    
    pHeight = objMain.playbackSpeed * (sinst.time - max(time, objMain.nowTime))
        + dFromBottom + uFromTop;
    pHeight = max(pHeight, originalHeight);
    
    lastTime = sinst.time - time;
    lastTime = max(lastTime, 0.0001);
    
    edgeScaleY = pHeight / originalHeight;
}