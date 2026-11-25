//void vertex() {
	// Called for every vertex the material is visible on.
//}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
shader_type canvas_item;
uniform float radius_px : hint_range(0.0, 64.0) = 12.0;
// Suavização da borda em pixels para não ficar serrilhado
uniform float feather_px : hint_range(0.0, 4.0) = 1.0;
// Controla o brilho/destaque do hover (0.0 = normal, 0.2 = mais claro)
uniform float hover_light : hint_range(-0.5, 0.5) = 0.0;
void fragment() {
	// Tamanho real em pixels (funciona bem em ColorRect, PanelContainer, TextureRect, etc.)
	vec2 size_px = vec2(1.0) / TEXTURE_PIXEL_SIZE;
	vec2 pos_px = UV * size_px;
	vec2 half_size = size_px * 0.5;

	// Garante que o raio não passe da metade do menor lado
	float r = min(radius_px, min(half_size.x, half_size.y));

	// Distância assinada (SDF) para um retângulo com cantos arredondados em pixels
	vec2 q = abs(pos_px - half_size) - (half_size - vec2(r));
	float dist = length(max(q, vec2(0.0))) + min(max(q.x, q.y), 0.0) - r;

	// Alpha suave apenas na transição do canto
	float mask = 1.0 - smoothstep(-feather_px * 0.5, feather_px * 0.5, dist);

	vec4 tex = texture(TEXTURE, UV);
	tex.a *= mask;
	COLOR = tex;
	
	// Aplica o brilho do hover por cima da cor da imagem
	tex.rgb = clamp(tex.rgb + vec3(hover_light), 0.0, 1.0);
	
}