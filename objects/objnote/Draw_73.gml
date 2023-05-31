/// @description Draw editor & debug things

if(_outroom_check(x, y)) return;

if((drawVisible || nodeAlpha > EPS || infoAlpha > EPS) && editor_get_editmode() <= 4) {
    var _inv = noteType == 3 ? -1:1;
    
    // Draw Node
    if(nodeAlpha>EPS) {
    	CleanRectangleXYWH(x, y, nodeRadius, nodeRadius)
	        .Rounding(5)
	        .Blend(nodeColor, nodeAlpha)
	        .Draw();
    }
    
    // Draw Information
    if(infoAlpha > EPS) {
    	var _dx = 20, _dy = (noteType == 2? dFromBottom:20) * _inv,
    		_dyu = (noteType == 2? dFromBottom:25) * _inv;
	    scribble(string_format(position, 1, 2))
	    	.starting_format("fDynamix16", c_aqua)
	    	.transform(global.scaleXAdjust, global.scaleYAdjust)
	    	.blend(c_white, infoAlpha)
	    	.align(fa_right, fa_middle)
	    	.draw(x - _dx, y + _dy);
	    
	    scribble(string_format(width, 1, 2))
	    	.starting_format("fDynamix16", c_white)
	    	.transform(global.scaleXAdjust, global.scaleYAdjust)
	    	.blend(c_white, infoAlpha)
	    	.align(fa_left, fa_middle)
	    	.draw(x + _dx, y + _dy);
	    
	    var _time = objMain.showBar ? "Bar " + string_format(time_to_bar(mtime_to_time(time)), 1, 6) : string_format(time, 1, 0);
	    scribble(_time)
	    	.starting_format("fDynamix16", scribble_rgb_to_bgr(0xb2fab4))
	    	.transform(global.scaleXAdjust, global.scaleYAdjust)
	    	.blend(c_white, infoAlpha)
	    	.align(fa_right, fa_middle)
	    	.draw(x - _dx, y - _dyu);
	    
	    if(is_struct(lastAttachBar) && lastAttachBar.bar != undefined) {
	    	var _bar = string_format(lastAttachBar.bar, 1, 0)+" + "+string_format(lastAttachBar.diva, 1, 0)+"/"+string(lastAttachBar.divb)
	    	_bar += " [0xFFAB91]("+string(lastAttachBar.divc)+")"
	    	scribble(_bar)
		    	.starting_format("fDynamix16", scribble_rgb_to_bgr(0xFFE082))
		    	.transform(global.scaleXAdjust, global.scaleYAdjust)
		    	.blend(c_white, infoAlpha)
		    	.align(fa_left, fa_middle)
		    	.draw(x + _dx, y - _dyu);
	    }
    }
    
}
else animTargetNodeA = 0;

if(debug_mode && objMain.showDebugInfo && !_outroom_check(x, y)) {
	draw_set_font(fDynamix16)
	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
    draw_text(x, y+5, stateString + " " + string(depth) + " " + string(arrayPos))
}