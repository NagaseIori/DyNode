
if(!dummy)
    event_inherited();

if(finst != -999 && state != stateOut)
    note_activate(finst);

image_yscale = 0.6 * global.scaleYAdjust;