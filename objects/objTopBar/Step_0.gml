
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
        _inst = new Checkbox(
            "pitchshift",
            _nw - layout.padding - layoutBar.w/2, layout.fromTop + layout.paddingH,
            layoutCheckbox.l, i18n_get("tab_pitchshift"),
            0, function (val) {
                objMain.music_pitchshift_switch(!val);
                return !val;
            }, function () {
                return USE_DSP_PITCHSHIFT;
            }, function () {
                return !is_undefined(objMain.channel);
            }
            );
    }
    else {
        gui_manager_destroy();
    }
    
    active = !active;
}