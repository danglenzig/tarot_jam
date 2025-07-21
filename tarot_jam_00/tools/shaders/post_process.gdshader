shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

uniform bool shader_enabled = true;

uniform bool saturation_enabled = true;
uniform bool sharpness_enabled = true;
uniform bool brightness_enabled = true;
uniform bool warmth_enabled = true;
uniform bool contrast_enabled = true;
uniform bool chromatic_abberation_enabled = true;


group_uniforms saturation;
uniform float saturation_amount : hint_range(0.0, 3.0, 0.1) = 1.0;
uniform vec3 monochrome_color : source_color = vec3(0.145, 0.145, 0.145);

group_uniforms sharpness;
uniform float sharpness_size : hint_range(0.0, 3.0, 0.1) = 1.0;
uniform float sharpness_intensity : hint_range(0.0, 3.0, 0.01) = 1.0;

group_uniforms brightness;
uniform float brightness_amount : hint_range(-1.0, 1.0, 0.01) = 0.0;

group_uniforms warmth;
uniform float warmth_amount : hint_range(-2.0, 2.0, 0.01) = 0.0;

group_uniforms contrast;
uniform float contrast_amount : hint_range(-1.0, 2.0, 0.01) = 0.0;

group_uniforms chromatic_abberation;
uniform float chromatic_abberation_seperation : hint_range(0.0, 0.1, 0.001) = 0.016;
uniform float chromatic_abberation_intensity : hint_range(0.0, 3.0, 0.1) = 1.5;
uniform float chromatic_abberation_blur_strength : hint_range(0.0, 5.0, 0.1) = 1.0;





void fragment() {
	vec4 screenColor = texture(screen_texture, SCREEN_UV);
	vec4 screenColorLOD = textureLod(screen_texture, SCREEN_UV, 1.0);

	if (shader_enabled) {


		if (sharpness_enabled || sharpness_size <= 0.0001){
			vec4 newColor = screenColor - textureLod(screen_texture, SCREEN_UV, sharpness_size);
			screenColor += (newColor) * sharpness_intensity;
		}


		if (saturation_enabled) {
			// Convert to grayscale using luminance method
			float luminance = dot(screenColor.rgb, vec3(0.299, 0.587, 0.114));
			vec3 gray = mix(monochrome_color, vec3(luminance), 0.5);
			screenColor.rgb = mix(gray, screenColor.rgb, saturation_amount);
		}

		if (chromatic_abberation_enabled){
			float strength = (chromatic_abberation_seperation * distance(SCREEN_UV, vec2(0.5)));
			float intensity = chromatic_abberation_intensity * distance(SCREEN_UV, vec2(0.5));

			vec2 UV1 = (SCREEN_UV - vec2(0.5)) * (1.0 + strength) + vec2(0.5);
			vec2 UV2 = (SCREEN_UV - vec2(0.5)) * (1.0 - strength) + vec2(0.5);

			float redCol = textureLod(screen_texture, UV1, chromatic_abberation_blur_strength).r;
			float greenCol = textureLod(screen_texture, UV2, chromatic_abberation_blur_strength).g;
			float blueCol = textureLod(screen_texture, SCREEN_UV, chromatic_abberation_blur_strength).b;
			vec4 newColor = vec4(redCol, greenCol, blueCol, 1.0);
			newColor -= textureLod(screen_texture, SCREEN_UV, chromatic_abberation_blur_strength);
			screenColor += newColor * vec4(vec3(intensity), 1.0);
		}

		if (brightness_enabled) {
			screenColor.rgb += brightness_amount;
		}

		if (warmth_enabled) {
			vec3 warm_filter = vec3(1.05, 0.93, 0.88);
			vec3 cool_filter = vec3(0.90, 0.96, 1.08);
			vec3 warmth_tint = mix(cool_filter, warm_filter, (warmth_amount + 1.0) * 0.5);
			screenColor.rgb *= warmth_tint;
		}

		if (contrast_enabled) {
			vec3 midpoint = vec3(0.5);
			screenColor.rgb = mix(midpoint, screenColor.rgb, contrast_amount + 1.0);
		}


	}
	COLOR = screenColor;



}