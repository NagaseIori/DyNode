

function note_pos_to_x(_pos, _side) {
    if(_side == 0) {
        return global.resolutionW/2 + (_pos-2.5)*300;
    }
    else {
        return global.resolutionH/2 + (2.5-_pos)*150;
    }
}

function resor_to_x(ratio) {
    return global.resolutionW * ratio;
}
function resor_to_y(ratio) {
    return global.resolutionH * ratio;
}

function array_top(array) {
    return array[array_length(array)-1];
}

function lerp_lim(from, to, amount, limit) {
    var _delta = lerp(from, to, amount)-from;
    
    _delta = min(abs(_delta), limit) * sign(_delta);
    
    return from+_delta;
}

function lerp_lim_a(from, to, amount, limit) {
    return lerp_lim(from, to, 
        amount * global.fpsAdjust, limit * global.fpsAdjust);
}

function lerp_a(from, to, amount) {
    return lerp(from, to, amount * global.fpsAdjust);
}

function create_scoreboard(_x, _y, _dep, _dig, _align) {
    var _inst = instance_create_depth(_x, _y, _dep, objScoreBoard);
    _inst.align = _align;
    _inst.preZero = _dig;
    return _inst;
}

function array_sort_f(array, compare) {
    var length = array_length(array);
    if(length == 0) return;
    
    var i, j;
    var lb, ub;
    var lb_stack = [], ub_stack = [];
    
    var stack_pos = 1;
    var pivot_pos;
    var pivot;
    var temp;
    
    lb_stack[1] = 0;
    ub_stack[1] = length - 1;
    
    do {
        lb = lb_stack[stack_pos];
        ub = ub_stack[stack_pos];
        stack_pos--;
        
        do {
            pivot_pos = (lb + ub) >> 1;
            i = lb;
            j = ub;
            pivot = array[pivot_pos];
            
            do {
                while (compare(array[i], pivot)) i++;
                while (compare(pivot, array[j])) j--;
                
                if (i <= j) {
                    temp = array[i];
                    array[@ i] = array[j];
                    array[@ j] = temp;
                    i++;
                    j--;
                }
            } until (i > j);
            
            if (i < pivot_pos) {
                if (i < ub) {
                    stack_pos++;
                    lb_stack[stack_pos] = i;
                    ub_stack[stack_pos] = ub;
                }
                
                ub = j;
            } else {
                if (j > lb) {
                    stack_pos++;
                    lb_stack[stack_pos] = lb;
                    ub_stack[stack_pos] = j;
                }
                
                lb = i;
            }
        } until (lb >= ub);
    } until (stack_pos == 0);
}