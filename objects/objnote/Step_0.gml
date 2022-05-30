
x = round(note_pos_to_x(position, side));
y = round(y)

pWidth = width * 300 - 30;

image_xscale = pWidth / originalWidth;
image_alpha = lerp(image_alpha, animTargetA, animSpeed * global.fpsAdjust);

state();