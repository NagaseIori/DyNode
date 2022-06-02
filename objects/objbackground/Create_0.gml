
image_spr = -1;

// Shader Init

surf_w = display_get_gui_width()
surf_h = display_get_gui_height()
surf = surface_create(surf_w, surf_h);
last_radius = 0;
u_size = shader_get_uniform(shd_gaussian_blur, "size");
u_uvs = shader_get_uniform(shd_gaussian_blur, "uvs");