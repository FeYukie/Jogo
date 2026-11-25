//void vertex() {
	// Called for every vertex the material is visible on.
//}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
shader_type canvas_item;

uniform float radius : hint_range(0.0, 0.5) = 0.15;

void fragment() {
	vec2 uv = UV;
	vec2 center = vec2(0.5);
	vec2 half_size = vec2(0.5);
	vec2 q = abs(uv - center) - (half_size - vec2(radius));
	float dist = length(max(q, 0.0)) + min(max(q.x, q.y), 0.0) - radius;

	vec4 tex = texture(TEXTURE, uv);
	if (dist > 0.0) {
		tex.a = 0.0;
	}
	COLOR = tex;
}