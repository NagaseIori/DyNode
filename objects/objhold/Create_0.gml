/// @description 

// Inherit the parent event
event_inherited();

noteType = 2;
edgeScaleY = 1;

origDepth += 5000;
image_yscale = 0.6 * global.scaleYAdjust;

originalHeight = sprite_get_height(sprHoldEdge);
pHeight = originalHeight; // Height in Pixels base on sprHoldEdge

sprite = sprHoldEdge2;
_prop_init();

// In-Function

    _prop_hold_update = function () {
        if(drawVisible && (sinst > 0 || (sid != -1 && ds_map_exists(objMain.chartNotesMap[side], sid)))) {
            if(sinst <= 0)
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
    }

// Correction Value

    dFromBottom = 26;
    uFromTop = 13; 
    lFromLeft = 12;
    rFromRight = 12;

// Surfaces
    
    surf_temp = -1;