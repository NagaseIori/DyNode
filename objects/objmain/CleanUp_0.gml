
instance_destroy(objNote);
instance_destroy(objChain);
instance_destroy(objHold);
instance_destroy(objHoldSub);
instance_destroy(objScoreBoard);

part_system_destroy(partSysNote);
part_type_destroy(partTypeNoteDL);
part_type_destroy(partTypeNoteDR);

for(var i=0; i<3; i++)
    ds_map_destroy(chartNotesMap[i]);

if(!is_undefined(music))
    FMODGMS_Snd_Unload(music);