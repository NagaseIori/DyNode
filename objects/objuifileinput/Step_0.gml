
if(mouse_isclick_l() && mouse_inbound(x, y, x+maxWidth, y+scriHeight*2)) {
    if(fType == "Open") {
        input = get_open_filename_ext(filter, fname, dir, fTitle);
    }
    else if(fType == "Save") {
        input = get_save_filename_ext(filter, fname, dir, fTitle);
    }
}

event_inherited();