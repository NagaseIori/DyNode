{
  "resourceType": "GMExtension",
  "resourceVersion": "1.2",
  "name": "libfilesystem",
  "androidactivityinject": "",
  "androidclassname": "",
  "androidcodeinjection": "",
  "androidinject": "",
  "androidmanifestinject": "",
  "androidPermissions": [],
  "androidProps": false,
  "androidsourcedir": "",
  "author": "",
  "classname": "",
  "copyToTargets": 202375362,
  "date": "2020-05-31T05:57:01",
  "description": "",
  "exportToGame": true,
  "extensionVersion": "1.0.0",
  "files": [
    {"resourceType":"GMExtensionFile","resourceVersion":"1.0","name":"","constants":[
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"working_directory","hidden":false,"value":"directory_get_current_working()",},
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"program_directory","hidden":false,"value":"executable_get_directory()",},
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"temp_directory","hidden":false,"value":"directory_get_temporary_path()",},
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"program_filename","hidden":false,"value":"executable_get_filename()",},
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"program_pathname","hidden":false,"value":"executable_get_pathname()",},
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"FD_RDONLY","hidden":false,"value":"0",},
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"FD_WRONLY","hidden":false,"value":"1",},
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"FD_RDWR","hidden":false,"value":"2",},
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"FD_APPEND","hidden":false,"value":"3",},
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"FD_RDAP","hidden":false,"value":"4",},
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"DC_ATOZ","hidden":false,"value":"0",},
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"DC_ZTOA","hidden":false,"value":"1",},
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"DC_AOTON","hidden":false,"value":"2",},
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"DC_ANTOO","hidden":false,"value":"3",},
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"DC_MOTON","hidden":false,"value":"4",},
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"DC_MNTOO","hidden":false,"value":"5",},
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"DC_COTON","hidden":false,"value":"6",},
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"DC_CNTOO","hidden":false,"value":"7",},
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"DC_RAND","hidden":false,"value":"8",},
      ],"copyToTargets":202375362,"filename":"libfilesystem.dll","final":"","functions":[
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_copy","argCount":2,"args":[
            1,
            1,
          ],"documentation":"","externalName":"file_copy","help":"file_copy(fname,newname)","hidden":false,"kind":12,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_rename","argCount":2,"args":[
            1,
            1,
          ],"documentation":"","externalName":"file_rename","help":"file_rename(oldname,newname)","hidden":false,"kind":12,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_exists","argCount":1,"args":[
            1,
          ],"documentation":"","externalName":"file_exists","help":"file_exists(fname)","hidden":false,"kind":12,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_delete","argCount":1,"args":[
            1,
          ],"documentation":"","externalName":"file_delete","help":"file_delete(fname)","hidden":false,"kind":12,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"directory_create","argCount":1,"args":[
            1,
          ],"documentation":"","externalName":"directory_create","help":"directory_create(dname)","hidden":false,"kind":12,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"directory_copy","argCount":2,"args":[
            1,
            1,
          ],"documentation":"","externalName":"directory_copy","help":"directory_copy(dname,newname)","hidden":false,"kind":12,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"directory_rename","argCount":2,"args":[
            1,
            1,
          ],"documentation":"","externalName":"directory_rename","help":"directory_rename(oldname,newname)","hidden":false,"kind":12,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"directory_exists","argCount":1,"args":[
            1,
          ],"documentation":"","externalName":"directory_exists","help":"directory_exists(dname)","hidden":false,"kind":12,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"directory_destroy","argCount":1,"args":[
            1,
          ],"documentation":"","externalName":"directory_destroy","help":"directory_destroy(dname)","hidden":false,"kind":12,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"filename_absolute","argCount":1,"args":[
            1,
          ],"documentation":"","externalName":"filename_absolute","help":"filename_absolute(fname)","hidden":false,"kind":12,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"environment_get_variable","argCount":1,"args":[
            1,
          ],"documentation":"","externalName":"environment_get_variable","help":"environment_get_variable(name)","hidden":false,"kind":12,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"environment_set_variable","argCount":2,"args":[
            1,
            1,
          ],"documentation":"","externalName":"environment_set_variable","help":"environment_set_variable(name,value)","hidden":false,"kind":12,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"directory_get_current_working","argCount":0,"args":[],"documentation":"","externalName":"directory_get_current_working","help":"directory_get_current_working()","hidden":false,"kind":12,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"directory_set_current_working","argCount":1,"args":[
            1,
          ],"documentation":"","externalName":"directory_set_current_working","help":"directory_set_current_working(dname)","hidden":false,"kind":12,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"executable_get_directory","argCount":-1,"args":[],"documentation":"","externalName":"executable_get_directory","help":"executable_get_directory()","hidden":false,"kind":12,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"executable_get_filename","argCount":-1,"args":[],"documentation":"","externalName":"executable_get_filename","help":"executable_get_filename()","hidden":false,"kind":12,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"executable_get_pathname","argCount":-1,"args":[],"documentation":"","externalName":"executable_get_pathname","help":"executable_get_pathname()","hidden":false,"kind":12,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_size","argCount":0,"args":[
            1,
          ],"documentation":"","externalName":"file_size","help":"file_size(fname)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"directory_size","argCount":0,"args":[
            1,
          ],"documentation":"","externalName":"directory_size","help":"directory_size(dname)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"filename_canonical","argCount":0,"args":[
            1,
          ],"documentation":"","externalName":"filename_canonical","help":"filename_canonical(fname)","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"environment_expand_variables","argCount":0,"args":[
            1,
          ],"documentation":"","externalName":"environment_expand_variables","help":"environment_expand_variables(str)","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"directory_contents_first","argCount":0,"args":[
            1,
            1,
            2,
            2,
          ],"documentation":"","externalName":"directory_contents_first","help":"directory_contents_first(dname,pattern,includedirs,recursive)","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"directory_contents_next","argCount":0,"args":[],"documentation":"","externalName":"directory_contents_next","help":"directory_contents_next()","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"directory_contents_close","argCount":0,"args":[],"documentation":"","externalName":"directory_contents_close","help":"directory_contents_close()","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_bin_open","argCount":0,"args":[
            1,
            2,
          ],"documentation":"","externalName":"file_bin_open","help":"file_bin_open(fname,mode)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_bin_rewrite","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"file_bin_rewrite","help":"file_bin_rewrite(fd)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_bin_close","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"file_bin_close","help":"file_bin_close(fd)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_bin_size","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"file_bin_size","help":"file_bin_size(fd)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_bin_position","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"file_bin_position","help":"file_bin_position(fd)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_bin_seek","argCount":0,"args":[
            2,
            2,
          ],"documentation":"","externalName":"file_bin_seek","help":"file_bin_seek(fd,pos)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_bin_read_byte","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"file_bin_read_byte","help":"file_bin_read_byte(fd)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_bin_write_byte","argCount":0,"args":[
            2,
            2,
          ],"documentation":"","externalName":"file_bin_write_byte","help":"file_bin_write_byte(fd,byte)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_text_open_read","argCount":0,"args":[
            1,
          ],"documentation":"","externalName":"file_text_open_read","help":"file_text_open_read(fname)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_text_open_write","argCount":0,"args":[
            1,
          ],"documentation":"","externalName":"file_text_open_write","help":"file_text_open_write(fname)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_text_open_append","argCount":0,"args":[
            1,
          ],"documentation":"","externalName":"file_text_open_append","help":"file_text_open_append(fname)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_text_write_real","argCount":0,"args":[
            2,
            2,
          ],"documentation":"","externalName":"file_text_write_real","help":"file_text_write_real(fd,val)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_text_write_string","argCount":0,"args":[
            2,
            1,
          ],"documentation":"","externalName":"file_text_write_string","help":"file_text_write_string(fd,str)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_text_writeln","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"file_text_writeln","help":"file_text_writeln(fd)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_text_eoln","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"file_text_eoln","help":"file_text_eoln(fd)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_text_eof","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"file_text_eof","help":"file_text_eof(fd)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_text_read_real","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"file_text_read_real","help":"file_text_read_real(fd)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_text_read_string","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"file_text_read_string","help":"file_text_read_string(fd)","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_text_readln","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"file_text_readln","help":"file_text_readln(fd)","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_text_read_all","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"file_text_read_all","help":"file_text_read_all(fd)","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_text_open_from_string","argCount":0,"args":[
            1,
          ],"documentation":"","externalName":"file_text_open_from_string","help":"file_text_open_from_string(str)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_text_close","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"file_text_close","help":"file_text_close(fd)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"environment_unset_variable","argCount":0,"args":[
            1,
          ],"documentation":"","externalName":"environment_unset_variable","help":"environment_unset_variable(name)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_bin_hardlinks","argCount":0,"args":[
            2,
            1,
            2,
          ],"documentation":"","externalName":"file_bin_hardlinks","help":"file_bin_hardlinks(fd,dnames,recursive)","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"directory_contents_get_order","argCount":0,"args":[],"documentation":"","externalName":"directory_contents_get_order","help":"directory_contents_get_order()","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"directory_contents_set_order","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"directory_contents_set_order","help":"directory_contents_set_order(order)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"directory_get_temporary_path","argCount":0,"args":[],"documentation":"","externalName":"directory_get_temporary_path","help":"directory_get_temporary_path()","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_datetime_accessed_year","argCount":0,"args":[
            1,
          ],"documentation":"","externalName":"file_datetime_accessed_year","help":"file_datetime_accessed_year(fname)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_datetime_accessed_month","argCount":0,"args":[
            1,
          ],"documentation":"","externalName":"file_datetime_accessed_month","help":"file_datetime_accessed_month(fname)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_datetime_accessed_day","argCount":0,"args":[
            1,
          ],"documentation":"","externalName":"file_datetime_accessed_day","help":"file_datetime_accessed_day(fname)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_datetime_accessed_hour","argCount":0,"args":[
            1,
          ],"documentation":"","externalName":"file_datetime_accessed_hour","help":"file_datetime_accessed_hour(fname)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_datetime_accessed_minute","argCount":0,"args":[
            1,
          ],"documentation":"","externalName":"file_datetime_accessed_minute","help":"file_datetime_accessed_minute(fname)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_datetime_accessed_second","argCount":0,"args":[
            1,
          ],"documentation":"","externalName":"file_datetime_accessed_second","help":"file_datetime_accessed_second(fname)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_datetime_modified_year","argCount":0,"args":[
            1,
          ],"documentation":"","externalName":"file_datetime_modified_year","help":"file_datetime_modified_year(fname)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_datetime_modified_month","argCount":0,"args":[
            1,
          ],"documentation":"","externalName":"file_datetime_modified_month","help":"file_datetime_modified_month(fname)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_datetime_modified_day","argCount":0,"args":[
            1,
          ],"documentation":"","externalName":"file_datetime_modified_day","help":"file_datetime_modified_day(fname)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_datetime_modified_hour","argCount":0,"args":[
            1,
          ],"documentation":"","externalName":"file_datetime_modified_hour","help":"file_datetime_modified_hour(fname)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_datetime_modified_minute","argCount":0,"args":[
            1,
          ],"documentation":"","externalName":"file_datetime_modified_minute","help":"file_datetime_modified_minute(fname)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_datetime_modified_second","argCount":0,"args":[
            1,
          ],"documentation":"","externalName":"file_datetime_modified_second","help":"file_datetime_modified_second(fname)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_datetime_created_year","argCount":0,"args":[
            1,
          ],"documentation":"","externalName":"file_datetime_created_year","help":"file_datetime_created_year(fname)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_datetime_created_month","argCount":0,"args":[
            1,
          ],"documentation":"","externalName":"file_datetime_created_month","help":"file_datetime_created_month(fname)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_datetime_created_day","argCount":0,"args":[
            1,
          ],"documentation":"","externalName":"file_datetime_created_day","help":"file_datetime_created_day(fname)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_datetime_created_hour","argCount":0,"args":[
            1,
          ],"documentation":"","externalName":"file_datetime_created_hour","help":"file_datetime_created_hour(fname)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_datetime_created_minute","argCount":0,"args":[
            1,
          ],"documentation":"","externalName":"file_datetime_created_minute","help":"file_datetime_created_minute(fname)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_datetime_created_second","argCount":0,"args":[
            1,
          ],"documentation":"","externalName":"file_datetime_created_second","help":"file_datetime_created_second(fname)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_bin_datetime_accessed_year","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"file_bin_datetime_accessed_year","help":"file_bin_datetime_accessed_year(fd)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_bin_datetime_accessed_month","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"file_bin_datetime_accessed_month","help":"file_bin_datetime_accessed_month(fd)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_bin_datetime_accessed_day","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"file_bin_datetime_accessed_day","help":"file_bin_datetime_accessed_day(fd)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_bin_datetime_accessed_hour","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"file_bin_datetime_accessed_hour","help":"file_bin_datetime_accessed_hour(fd)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_bin_datetime_accessed_minute","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"file_bin_datetime_accessed_minute","help":"file_bin_datetime_accessed_minute(fd)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_bin_datetime_accessed_second","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"file_bin_datetime_accessed_second","help":"file_bin_datetime_accessed_second(fd)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_bin_datetime_modified_year","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"file_bin_datetime_modified_year","help":"file_bin_datetime_modified_year(fd)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_bin_datetime_modified_month","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"file_bin_datetime_modified_month","help":"file_bin_datetime_modified_month(fd)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_bin_datetime_modified_day","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"file_bin_datetime_modified_day","help":"file_bin_datetime_modified_day(fd)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_bin_datetime_modified_hour","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"file_bin_datetime_modified_hour","help":"file_bin_datetime_modified_hour(fd)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_bin_datetime_modified_minute","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"file_bin_datetime_modified_minute","help":"file_bin_datetime_modified_minute(fd)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_bin_datetime_modified_second","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"file_bin_datetime_modified_second","help":"file_bin_datetime_modified_second(fd)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_bin_datetime_created_year","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"file_bin_datetime_created_year","help":"file_bin_datetime_created_year(fd)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_bin_datetime_created_month","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"file_bin_datetime_created_month","help":"file_bin_datetime_created_month(fd)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_bin_datetime_created_day","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"file_bin_datetime_created_day","help":"file_bin_datetime_created_day(fd)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_bin_datetime_created_hour","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"file_bin_datetime_created_hour","help":"file_bin_datetime_created_hour(fd)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_bin_datetime_created_minute","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"file_bin_datetime_created_minute","help":"file_bin_datetime_created_minute(fd)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_bin_datetime_created_second","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"file_bin_datetime_created_second","help":"file_bin_datetime_created_second(fd)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"directory_contents_get_maxfiles","argCount":0,"args":[],"documentation":"","externalName":"directory_contents_get_maxfiles","help":"directory_contents_get_maxfiles()","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"directory_contents_set_maxfiles","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"directory_contents_set_maxfiles","help":"directory_contents_set_maxfiles(maxfiles)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"directory_contents_get_cntfiles","argCount":0,"args":[],"documentation":"","externalName":"directory_contents_get_cntfiles","help":"directory_contents_get_cntfiles()","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"symlink_create","argCount":0,"args":[
            1,
            1,
          ],"documentation":"","externalName":"symlink_create","help":"symlink_create(fname,newname)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"symlink_copy","argCount":0,"args":[
            1,
            1,
          ],"documentation":"","externalName":"symlink_copy","help":"symlink_copy(fname,newname)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"symlink_exists","argCount":0,"args":[
            1,
          ],"documentation":"","externalName":"symlink_exists","help":"symlink_exists(fname)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"hardlink_create","argCount":0,"args":[
            1,
            1,
          ],"documentation":"","externalName":"hardlink_create","help":"hardlink_create(fname,newname)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_numblinks","argCount":0,"args":[
            1,
          ],"documentation":"","externalName":"file_numblinks","help":"file_numblinks(fname)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"file_bin_numblinks","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"file_bin_numblinks","help":"file_bin_numblinks(fd)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"filename_equivalent","argCount":0,"args":[
            1,
            1,
          ],"documentation":"","externalName":"filename_equivalent","help":"filename_equivalent(fname1,fname2)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"environment_get_variable_exists","argCount":0,"args":[
            1,
          ],"documentation":"","externalName":"environment_get_variable_exists","help":"environment_get_variable_exists(name)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"directory_contents_first_async","argCount":0,"args":[
            1,
            1,
            2,
            2,
          ],"documentation":"","externalName":"directory_contents_first_async","help":"directory_contents_first_async(dname,pattern,includedirs,recursive)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"directory_contents_get_completion_status","argCount":0,"args":[],"documentation":"","externalName":"directory_contents_get_completion_status","help":"directory_contents_get_completion_status()","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"directory_contents_set_completion_status","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"directory_contents_set_completion_status","help":"directory_contents_set_completion_status(complete)","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"directory_contents_get_length","argCount":0,"args":[],"documentation":"","externalName":"directory_contents_get_length","help":"directory_contents_get_length()","hidden":false,"kind":1,"returnType":2,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"directory_get_desktop_path","argCount":0,"args":[],"documentation":"","externalName":"directory_get_desktop_path","help":"directory_get_desktop_path()","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"directory_get_documents_path","argCount":0,"args":[],"documentation":"","externalName":"directory_get_documents_path","help":"directory_get_documents_path()","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"directory_get_downloads_path","argCount":0,"args":[],"documentation":"","externalName":"directory_get_downloads_path","help":"directory_get_downloads_path()","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"directory_get_music_path","argCount":0,"args":[],"documentation":"","externalName":"directory_get_music_path","help":"directory_get_music_path()","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"directory_get_pictures_path","argCount":0,"args":[],"documentation":"","externalName":"directory_get_pictures_path","help":"directory_get_pictures_path()","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"directory_get_videos_path","argCount":0,"args":[],"documentation":"","externalName":"directory_get_videos_path","help":"directory_get_videos_path()","hidden":false,"kind":1,"returnType":1,},
      ],"init":"","kind":1,"order":[],"origname":"extensions\\libfilesystem.dll","ProxyFiles":[
        {"resourceType":"GMProxyFile","resourceVersion":"1.0","name":"libfilesystem.dylib","TargetMask":1,},
        {"resourceType":"GMProxyFile","resourceVersion":"1.0","name":"libfilesystem_x64.dll","TargetMask":6,},
        {"resourceType":"GMProxyFile","resourceVersion":"1.0","name":"libfilesystem_arm.so","TargetMask":7,},
        {"resourceType":"GMProxyFile","resourceVersion":"1.0","name":"libfilesystem_arm64.so","TargetMask":7,},
        {"resourceType":"GMProxyFile","resourceVersion":"1.0","name":"libfilesystem.so","TargetMask":7,},
      ],"uncompress":false,"usesRunnerInterface":false,},
    {"resourceType":"GMExtensionFile","resourceVersion":"1.0","name":"","constants":[],"copyToTargets":0,"filename":"libfilesystem.zip","final":"","functions":[],"init":"","kind":4,"order":[],"origname":"extensions\\libfilesystem.zip","ProxyFiles":[],"uncompress":false,"usesRunnerInterface":false,},
    {"resourceType":"GMExtensionFile","resourceVersion":"1.0","name":"","constants":[],"copyToTargets":194,"filename":"libfilesystem.gml","final":"","functions":[
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"generate_working_directory","argCount":0,"args":[],"documentation":"","externalName":"generate_working_directory","help":"","hidden":false,"kind":2,"returnType":1,},
      ],"init":"generate_working_directory","kind":2,"order":[],"origname":"","ProxyFiles":[],"uncompress":false,"usesRunnerInterface":false,},
  ],
  "gradleinject": "",
  "hasConvertedCodeInjection": true,
  "helpfile": "",
  "IncludedResources": [],
  "installdir": "",
  "iosCocoaPodDependencies": "",
  "iosCocoaPods": "",
  "ioscodeinjection": "",
  "iosdelegatename": "",
  "iosplistinject": "",
  "iosProps": false,
  "iosSystemFrameworkEntries": [],
  "iosThirdPartyFrameworkEntries": [],
  "license": "Free to use, also for commercial games.",
  "maccompilerflags": "",
  "maclinkerflags": "",
  "macsourcedir": "",
  "options": [],
  "optionsFile": "options.json",
  "packageId": "",
  "parent": {
    "name": "Extensions",
    "path": "folders/Extensions.yy",
  },
  "productId": "ACBD3CFF4E539AD869A0E8E3B4B022DD",
  "sourcedir": "",
  "supportedTargets": 202375362,
  "tvosclassname": "",
  "tvosCocoaPodDependencies": "",
  "tvosCocoaPods": "",
  "tvoscodeinjection": "",
  "tvosdelegatename": "",
  "tvosmaccompilerflags": "",
  "tvosmaclinkerflags": "",
  "tvosplistinject": "",
  "tvosProps": false,
  "tvosSystemFrameworkEntries": [],
  "tvosThirdPartyFrameworkEntries": [],
}