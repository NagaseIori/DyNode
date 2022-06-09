/// @description 

// Inherit the parent event
event_inherited();

sinst = -1;
noteType = 2;
edgeScaleY = 1;

depth *= 2;

originalHeight = sprite_get_height(sprHoldEdge);
pHeight = originalHeight; // Height in Pixels base on sprHoldEdge

sprite = sprHoldEdge;
_prop_init();

// Correction Value

    dFromBottom = 26;
    uFromTop = 13; 
    lFromLeft = 12;
    rFromRight = 12;

// Surfaces
    
    surf_temp = -1;