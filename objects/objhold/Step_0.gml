
// Inherit the parent event
event_inherited();

if(visible && sid != -1 && ds_map_exists(objMain.chartNotesMap[side], sid)) {
    var _inst = objMain.chartNotesMap[side][? sid]
    
    // Sync the position and width
    _inst.position = position;
    _inst.width = width;
    
    pHeight = objMain.playbackSpeed * (_inst.time - max(time, objMain.nowTime))
        + dFromBottom + uFromTop;
    pHeight = max(pHeight, originalHeight);
    
    lastTime = _inst.time - time;
    lastTime = max(lastTime, 0.0001);
    
    image_yscale = pHeight / originalHeight;
}