
var vx = camera_get_view_x(view_camera[0]);
var vy = camera_get_view_y(view_camera[0]);

switch(global.bg_type) {
	case 0:
		draw_set_color(global.bg_col);
		draw_rectangle(vx, vy, vx+absolute_pos_x(1), vy+absolute_pos_y(1), false);
		break;
	case 1:
		if(!sprite_exists(image_spr)) {
			event_user(0);
			if(!sprite_exists(image_spr)) break;
		}
		if(global.bg_radius) {
			if(global.bg_radius != last_radius) {
				surface_set_target(surf);
				var uvs = sprite_get_uvs(image_spr, 0);
				shader_set(shd_gaussian_blur);
					shader_set_uniform_f(
						u_size, 
						(uvs[2]-uvs[0])/sprite_get_width(image_spr), 
						(uvs[3]-uvs[1])/sprite_get_height(image_spr), 
						global.bg_radius);
					shader_set_uniform_f_array(u_uvs, uvs);
					draw_sprite(image_spr, 0, 0, 0);
				shader_reset(); 
				surface_reset_target();
			}
			draw_surface(surf, vx, vy);
			last_radius = global.bg_radius;
		}
		else
			draw_sprite(image_spr, 0, vx, vy);
		break;
}


draw_reset();