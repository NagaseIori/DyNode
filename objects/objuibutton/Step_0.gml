
var _bbox = scriElement.get_bbox(x, y);
var _inbound = mouse_inbound(_bbox.left, _bbox.top, _bbox.right, _bbox.bottom)

animTargetGradAlpha = _inbound;
gradAlpha = lerp_a(gradAlpha, animTargetGradAlpha, animSpeed);

if(gradAlpha < gradMin) gradAlpha = 0;

if(mouse_isclick_l() && _inbound) {
    eventFunc();
}
