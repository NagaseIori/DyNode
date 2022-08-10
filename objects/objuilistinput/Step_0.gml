/// @description 

var _inbound = mouse_inbound(x, y, x+maxWidth, y+scriHeight*2);

if(mouse_isclick_l() && _inbound) {
	listPointer ++;
	listPointer %= listCount;
	input = lists[listPointer];
}

animTargetGradAlpha = _inbound;
gradAlpha = lerp_a(gradAlpha, animTargetGradAlpha, animSpeed);