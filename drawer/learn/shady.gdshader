shader_type canvas_item;

uniform float sonic_radius: hint_range(0.0, 1.0) = 0.4;
uniform float sonic_edge: hint_range(0.0, 1.0) = 0.1;
uniform float sonic_smooth_radius: hint_range(0.0, 1.0) = 0.05;

uniform vec4 sonic_color: source_color = vec4(0.15, 0.45, 0.85, 1.0);
uniform vec4 sonic_edge_color: source_color = vec4(0.8, 0.8, 1.0, 1.0);
uniform	vec4 tails_color: source_color = vec4(1.0, 0.5, 0.0, 1.0);
uniform vec4 knuckles_color: source_color = vec4(0.85, 0.15, 0.15, 1.0);

void fragment() {
	float dist = distance(UV, vec2(0.5, 0.5));

	float sonic_circle = smoothstep(sonic_radius, sonic_radius - sonic_smooth_radius, dist);
	float pulse = ((sin(TIME) + 1.0) * 1.5) + 3.0;
	vec4 sonic_knuckles_color = mix(knuckles_color, sonic_color, min(dist * pulse, 1.0));

	float sonic_edge_circle = smoothstep(sonic_radius + sonic_edge, sonic_radius, dist) - sonic_circle;
	sonic_knuckles_color += sonic_edge_circle * sonic_edge_color;

	COLOR = vec4(mix(tails_color.rgb, sonic_knuckles_color.rgb, sonic_edge_circle + sonic_circle), 1.0);
}

// void vertex() {
// 	// Called for every vertex the material is visible on.
// }

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
