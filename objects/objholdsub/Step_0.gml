
if(!dummy)
    event_inherited();

if(finst != -999 && state != stateOut)
    instance_activate_object(finst);

image_yscale = 0.6 * global.scaleYAdjust;