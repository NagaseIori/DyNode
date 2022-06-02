
surf_w = display_get_gui_width()
surf_h = display_get_gui_height()

if(!surface_exists(surf)) {
	surf = surface_create(surf_w, surf_h);
	last_radius = 0;
}