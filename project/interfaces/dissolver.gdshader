shader_type canvas_item;

uniform sampler2D noise_texture : hint_default_white;
uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform float edge_size : hint_range(0.0, 0.2) = 0.05;
uniform vec4 edge_color : source_color = vec4(1.0, 0.5, 0.0, 1.0);

void fragment() {
	vec4 base_color = COLOR;
	float noise = texture(noise_texture, UV).r;
	
	float dissolve = smoothstep(progress, progress + edge_size, noise);
	float edge = smoothstep(progress - edge_size, progress, noise);
	
	base_color.a *= dissolve;
	
	base_color.rgb = mix(edge_color.rgb, base_color.rgb, dissolve);
	base_color.rgb += edge * edge_color.rgb;
	
	COLOR = base_color;
}