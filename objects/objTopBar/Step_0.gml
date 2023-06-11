
if(keycheck_down(vk_tab)) {
    if(!active) {
        var _nw = global.resolutionW/2;
        gui_manager_create();
        var _inst = new BarVolumeMain("mainvol", _nw - layout.padding - layoutBar.w/2, layout.fromTop);
        _inst.set_wh(layoutBar.w ,layoutBar.h);
        _inst = new BarVolumeHitSound("hitvol", _nw - layoutBar.w/2, layout.fromTop);
        _inst.set_wh(layoutBar.w ,layoutBar.h);
        _inst = new BarBackgroundDim("bgdim", _nw + layout.padding - layoutBar.w/2, layout.fromTop);
        _inst.set_wh(layoutBar.w ,layoutBar.h);
    }
    else {
        gui_manager_destroy();
    }
    
    active = !active;
}