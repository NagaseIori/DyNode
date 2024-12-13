function test_at_start() {
    show_debug_message("=====DEBUG======")

    var _str_bef = "This is a string.\nthe string."

    var _cSize = DyCore_compress_string(_str_bef, buffer_get_address(global.__DyCore_Buffer), 11);
    
    var _str_aft = DyCore_decompress_string(buffer_get_address(global.__DyCore_Buffer), _cSize);

    if(_str_bef == _str_aft)
        show_debug_message("Validation pass.");
}