
inputsMap = ds_map_create();

// In-Functions

register_input = function (nid, inst) {
    if(ds_map_exists(inputsMap, nid)) {
        show_error("Duplicated input id: "+nid, true);
    }
    inputsMap[? nid] = inst;
}

get_input = function (nid) {
    if(!ds_map_exists(inputsMap, nid)) {
        show_error("Input id not found: "+nid, true);
    }
    return inputsMap[? nid].input;
}

get_list_pointer = function (nid) {
    if(!ds_map_exists(inputsMap, nid)) {
        show_error("Input id not found: "+nid, true);
    }
    return inputsMap[? nid].listPointer;
}