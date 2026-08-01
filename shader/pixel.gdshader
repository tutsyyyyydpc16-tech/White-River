shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture;
uniform float pixel_size : hint_range(0.0, 100.0, 2.0) = 4.0;
void fragment() {
	vec2 tex_size = vec2(textureSize(screen_texture, 0));
	vec2 pixel_count = tex_size / pixel_size;
	vec2 pixelated_uv = floor(SCREEN_UV * pixel_count) / pixel_count;
	vec4 color = texture(screen_texture, pixelated_uv);
	COLOR = color;
}