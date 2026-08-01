shader_type canvas_item;
uniform float distortion_strength : hint_range(-2.0, 2.0) = 0.5;
uniform float distortion_radius : hint_range(0.0, 1.0) = 1.0;
uniform sampler2D screen_texture : hint_screen_texture, filter_linear;

void fragment() {
	vec2 uv = SCREEN_UV - vec2(0.5);
	float dist = length(uv);
	
	if (dist < distortion_radius) {
		float amount = dist / distortion_radius;
		vec2 distorted_uv = uv * (1.0 + amount * distortion_strength) + vec2(0.5);
		
		if (distorted_uv.x < 0.0 || distorted_uv.x > 1.0 || distorted_uv.y < 0.0 || distorted_uv.y > 1.0) {
			COLOR = vec4(0.0, 0.0, 0.0, 1.0);
		} else {
			COLOR = texture(screen_texture, distorted_uv);
		}
	} else {
		COLOR = texture(screen_texture, SCREEN_UV);
	}
}