shader_type canvas_item;

uniform float energy_total = 500.0;
uniform float energy_left = 500.0;
uniform float energy_lost = 0.0;

uniform vec4 energy_color: source_color = vec4(0.65, 0.0, 0.0, 1.0);
uniform vec4 energy_lost_color: source_color = vec4(0.1, 0.1, 0.1, 1.0);
uniform vec4 energy_losing_color: source_color = vec4(0.8, 0.6, 0.0, 1.0);

void fragment() {
	float energy_curr = energy_left / energy_total;
	float energy_lost_ratio = energy_lost / energy_total;
	float energy_losing = energy_curr + energy_lost_ratio;

	float is_active = step(UV.x, energy_curr);
	float is_losing = step(UV.x + (fract(UV.y * 5.0) * 0.01 * TIME), energy_losing) * (1.0 - is_active);

	float center_dist = distance(UV.y, 0.5);
	// float is_odd_frag = mod(FRAGCOORD.x + FRAGCOORD.y, 1.0);

	vec4 active_color = vec4(mix(energy_color.rgb * 1.6, vec3(0.0), center_dist), 1.0);
	// vec4 losing_color = mix(energy_losing_color, energy_lost_color, is_odd_frag);
	vec4 losing_color = energy_losing_color;

	vec4 energy_mix = mix(energy_lost_color, active_color, is_active);
	energy_mix = mix(energy_mix, losing_color, is_losing);

	COLOR = energy_mix;
}
