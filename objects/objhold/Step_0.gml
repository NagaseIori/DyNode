
// Inherit the parent event
event_inherited();

if(sid != -1 && ds_map_exists(objMain.chartNotesMap[side], sid)) {
    var _inst = objMain.chartNotesMap[side][? sid]
    pHeight = objMain.playbackSpeed * (_inst.offset - max(offset, objMain.nowOffset))
        + dFromBottom + uFromTop;
    pHeight = max(pHeight, originalHeight);
    
    lastOffset = _inst.offset - offset;
    lastOffset = max(lastOffset, 0.0001);
    
    image_yscale = pHeight / originalHeight;
}
else {
    visible = false;
}