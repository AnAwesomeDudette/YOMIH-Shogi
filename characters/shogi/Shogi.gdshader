shader_type canvas_item;

const vec4 replacement_color = vec4(1.0, 1.0, 1.0, 1.0);
const float super_dim_amount = 0.35;

uniform bool use_extra_color_1 = false;
uniform bool use_extra_color_2 = false;
uniform bool use_extra_color_3 = true;
uniform vec4 extra_replace_color_1 : hint_color  = vec4(1.0, 0.0, 1.0, 1.0);
uniform vec4 extra_replace_color_2 : hint_color  = vec4(1.0, 0.0, 1.0, 1.0);
uniform vec4 extra_replace_color_3 : hint_color  = vec4(0.455, 0.0, 0.247, 1.0);

uniform vec4 color: hint_color = vec4(1.0);
uniform vec4 extra_color_1: hint_color = vec4(1.0);
uniform vec4 extra_color_2: hint_color = vec4(1.0);

uniform float max_color_distance = 0.01;

uniform bool super_dim = false;
uniform bool use_outline = false;
uniform bool is_particle = false;

uniform vec4 outline_color : hint_color = vec4(0.0, 0.0, 0.0, 1.0);

bool same_color(vec3 color1, vec3 color2) {
	return distance(color1, color2) < max_color_distance;
}

void fragment() {
	vec4 col = texture(TEXTURE, UV);
	COLOR *= col;
	if (same_color(col.rgb, replacement_color.rgb)) {
		COLOR.rgb = color.rgb;
		//if (!is_particle){
			COLOR.a *= texture(TEXTURE, UV).a;
		//}
	}
	if (use_outline && COLOR.a == 0.0 && !is_particle) {
		float size_x = 1.0/float(textureSize(TEXTURE, 0).x);
		float size_y = 1.0/float(textureSize(TEXTURE, 0).y);
		vec4 sprite_color = texture(TEXTURE, UV);
		float alpha = -8.0 * sprite_color.a;
		alpha += texture(TEXTURE, UV + vec2(size_x, 0)).a * float(same_color(texture(TEXTURE, UV + vec2(size_x, 0)).rgb, replacement_color.rgb));
		alpha += texture(TEXTURE, UV + vec2(-size_x, 0)).a * float(same_color(texture(TEXTURE, UV + vec2(-size_x, 0)).rgb, replacement_color.rgb));
		alpha += texture(TEXTURE, UV + vec2(0, size_y)).a * float(same_color(texture(TEXTURE, UV + vec2(0, size_y)).rgb, replacement_color.rgb));
		alpha += texture(TEXTURE, UV + vec2(0, -size_y)).a * float(same_color(texture(TEXTURE, UV + vec2(0, -size_y)).rgb, replacement_color.rgb));
		//For outlining corners
		//Change the -4.0 to -8.0 in alpa if adding these lines
		alpha += texture(TEXTURE, UV + vec2(size_x, size_y)).a * float(same_color(texture(TEXTURE, UV + vec2(size_x, size_y)).rgb, replacement_color.rgb));
		alpha += texture(TEXTURE, UV + vec2(-size_x, size_y)).a * float(same_color(texture(TEXTURE, UV + vec2(-size_x, size_y)).rgb, replacement_color.rgb));
		alpha += texture(TEXTURE, UV + vec2(-size_x, -size_y)).a * float(same_color(texture(TEXTURE, UV + vec2(-size_x, -size_y)).rgb, replacement_color.rgb));
		alpha += texture(TEXTURE, UV + vec2(size_x, -size_y)).a * float(same_color(texture(TEXTURE, UV + vec2(size_x, -size_y)).rgb, replacement_color.rgb));
		vec4 final_color = mix(sprite_color, outline_color, clamp(alpha, 0.0, 1.0));
		COLOR = vec4(final_color.rgb, clamp(abs(alpha) + sprite_color.a, 0.0, 1.0)) * MODULATE;
	}
	if (use_extra_color_1 && same_color(col.rgb, extra_replace_color_1.rgb)) {
		COLOR.rgb = extra_color_1.rgb;
		if (!is_particle){
			COLOR.a *= texture(TEXTURE, UV).a;
		}
	}
	if (use_extra_color_2 && same_color(col.rgb, extra_replace_color_2.rgb)) {
		COLOR.rgb = extra_color_2.rgb;
		if (!is_particle){
			COLOR.a *= texture(TEXTURE, UV).a;
		}
	}
	if (use_extra_color_3 && same_color(col.rgb, extra_replace_color_3.rgb)) {
		vec4 replace_color = vec4(extra_color_2.r * 0.455, extra_color_2.g, extra_color_2.b * 0.568, extra_color_2.a);
		COLOR.rgb = replace_color.rgb;
		if (!is_particle){
			COLOR.a *= texture(TEXTURE, UV).a;
		}
	}
}