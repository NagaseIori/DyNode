/// @description 

// Inherit the parent event
event_inherited();

noteType = 2;
holdAlpha = 0.8;
bgLightness = 0.6;

image_yscale = 0.6 * global.scaleYAdjust;

originalHeight = sprite_get_height(sprHoldEdge);
pHeight = originalHeight; // Height in Pixels base on sprHoldEdge

sprite = sprHoldEdge2;
_prop_init();

// In-Function

    function _prop_hold_update() {
        if(sinst > 0 || (sid != -1 && ds_map_exists(objMain.chartNotesMap[side], sid))) {
            if(sinst <= 0)
		        sinst = objMain.chartNotesMap[side][? sid]
		    
		    if(state != stateOut)
		    	note_activate(sinst);
    
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
		    sinst.update_prop();
    
    		
		    pHeight = max(0, objMain.playbackSpeed * 
		    	(sinst.time - max(time, selectTolerance?0:objMain.nowTime)))
		        + dFromBottom + uFromTop;
		    if(!global.simplify) {
		    	pHeight = max(pHeight, originalHeight);
		    }
		    lastTime = sinst.time - time;
		    lastTime = max(lastTime, 1);
        }
    }

// Correction Value

    dFromBottom = 26;
    uFromTop = 13; 
    lFromLeft = 12;
    rFromRight = 12;

// Simplification Color Configuration

	inColor = [c_green, c_green];
	inColorAlp = [0.5, 0.7];
	outColor = [scribble_rgb_to_bgr(0xe6ee9c), c_white];
	outColorAlp = [1, 1];