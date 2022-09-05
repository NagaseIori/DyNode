/// @description 

// Inherit the parent event
event_inherited();

noteType = 2;
edgeScaleY = 1;
holdAlpha = 0.8;

image_yscale = 0.6 * global.scaleYAdjust;

originalHeight = sprite_get_height(sprHoldEdge);
pHeight = originalHeight; // Height in Pixels base on sprHoldEdge

sprite = sprHoldEdge2;
_prop_init();

// In-Function

    _prop_hold_update = function () {
        if(sinst > 0 || (sid != -1 && ds_map_exists(objMain.chartNotesMap[side], sid))) {
            if(sinst <= 0)
		        sinst = objMain.chartNotesMap[side][? sid]
		    
		    if(state != stateOut)
		    	instance_activate_object(sinst);
    
		    // Being destroyed
		    if(!instance_exists(sinst))
		        return;
    
		    // Sync the properties
		    sinst.position = position;
		    sinst.width = width;
		    sinst.depth = depth;
		    sinst.side = side;
		    sinst.finst = id;
		    sinst.time = max(sinst.time, time+0.0001);
		    
		    if(fixedLastTime != -1)
		    	sinst.time = time + fixedLastTime;
		    
		    sinst.beginTime = time;
    
		    pHeight = objMain.playbackSpeed * (sinst.time - max(time, objMain.nowTime))
		        + dFromBottom + uFromTop;
		    pHeight = max(pHeight, originalHeight);
    
		    lastTime = sinst.time - time;
		    lastTime = max(lastTime, 0.0001);
    
		    edgeScaleY = min(pHeight, side==0?global.resolutionH:global.resolutionW) / originalHeight;
        }
    }

// Correction Value

    dFromBottom = 26;
    uFromTop = 13; 
    lFromLeft = 12;
    rFromRight = 12;