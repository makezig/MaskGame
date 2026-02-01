shader_type canvas_item;

uniform vec2 scroll_speed = vec2(0.1, 0.0);
uniform vec4 tint_color : source_color = vec4(1.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = UV + TIME * scroll_speed;
	vec4 tex = texture(TEXTURE, uv);
	COLOR = tex * tint_color;
}


//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
