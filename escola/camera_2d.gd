extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func dar_zoom_camera(zoom_final: Vector2, duracao: float) -> void:
	var camera = $Camera2D # Ajuste para o caminho real da sua câmera
	if not camera:
		return
		
	var tween_zoom = create_tween()
	# Interpola o zoom atual da câmera até o valor desejado (ex: Vector2(1.5, 1.5))
	tween_zoom.tween_property(camera, "zoom", zoom_final, duracao)
	await tween_zoom.finished
