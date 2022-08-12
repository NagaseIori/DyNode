/// @description Animation runs

for(var i=0; i<3; i++) {
    gradAlpha[i] = lerp_a(gradAlpha[i], animTargetGradAlpha[i], animSpeed);
    if(gradAlpha[i]<0.01) gradAlpha[i] = 0;
}