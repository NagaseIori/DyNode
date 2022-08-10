
if(!instance_exists(objUIInputManager))
    instance_create(0, 0, objUIInputManager);

objUIInputManager.register_input(inputID, id);

input = "";

scriElement = scribble("[sprMsdfNotoSans]"+title)
    .starting_format("fDynamix16", c_white)
    .align(fa_left, fa_top);
scriHeight = scriElement.get_height();
maxWidth = 300;

gradAlpha = 0;
animTargetGradAlpha = 0;
animSpeed = 0.2;
shadowDistance = 3;
lineShootDistance = 30;