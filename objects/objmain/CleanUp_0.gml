
surface_free_f(bottomBgSurf);
surface_free_f(bottomBgSurfPing);

instance_destroy(objNote);
instance_destroy(objChain);
instance_destroy(objHold);
instance_destroy(objHoldSub);
instance_destroy(objScoreBoard);
instance_destroy(objPerfectIndc);
instance_destroy(objEditor);

time_source_destroy(timesourceResumeDelay);
part_emitter_destroy_all(partSysNote);
part_system_destroy(partSysNote);
part_type_destroy(partTypeNoteDL);
part_type_destroy(partTypeNoteDR);

if(bgImageSpr != -1)
    sprite_delete(bgImageSpr);

for(var i=0; i<3; i++)
    ds_map_destroy(chartNotesMap[i]);

if(!is_undefined(music))
    FMODGMS_Snd_Unload(music);