
part_system_destroy(partSysNote);
part_type_destroy(partTypeNoteDL);
part_type_destroy(partTypeNoteDR);

if(!is_undefined(music))
    FMODGMS_Snd_Unload(music);