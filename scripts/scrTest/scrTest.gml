function test_at_start() {
    show_debug_message("=====DEBUG======")
    show_debug_message(array_lower_bound([1, 2, 4, 5], 6))
    show_debug_message(array_lower_bound([1, 2, 4, 5], 5))
    show_debug_message(array_lower_bound([1, 2, 4, 5], 4))
    show_debug_message(array_lower_bound([1, 2, 4, 5], 3))
    show_debug_message(array_lower_bound([1, 2, 4, 5], 2))
    show_debug_message(array_lower_bound([1, 2, 4, 5], 1))
    
}