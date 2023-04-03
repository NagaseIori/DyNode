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

    _prop_hold_update = function () {
        if(sinst > 0) {
		    if(state != stateOut)
		    	note_activate(sinst);
    
		    // Being destroyed
		    if(!instance_exists(sinst))
		        return;
		    
		    // Sync the properties
		    
		    if(sinst.dummy) {
		    	sinst.time = max(sinst.time, time+0.0001);
		    	if(fixedLastTime != -1)
		    		sinst.time = time + fixedLastTime;
		    	pHeight = max(0, objMain.playbackSpeed * 
			    	(sinst.time - max(time, selectTolerance?0:objMain.nowTime)))
			        + dFromBottom + uFromTop;
			    if(!global.simplify)
			    	pHeight = max(pHeight, originalHeight);
			    
			    lastTime = sinst.time - time;
			    lastTime = max(lastTime, 1);
				return;
		    }
		    
		    var snote = sinst.fstruct;
		    snote.position = position;
		    snote.width = width;
		    snote.side = side;
		    snote.time = max(snote.time, time+0.0001);
		    
		    if(fixedLastTime != -1)
		    	snote.time = time + fixedLastTime;
    		
		    pHeight = max(0, objMain.playbackSpeed * 
		    	(snote.time - max(time, selectTolerance?0:objMain.nowTime)))
		        + dFromBottom + uFromTop;
		    if(!global.simplify) {
		    	pHeight = max(pHeight, originalHeight);
		    }
		    lastTime = snote.time - time;
		    lastTime = max(lastTime, 1);
		    
		    snote.lastTime = lastTime;
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