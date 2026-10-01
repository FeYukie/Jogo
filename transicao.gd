extends Node2D

@onready var color_rect: ColorRect = $CanvasLayer/ColorRect
func fade_in(tempo: float = 0.5) -> void:
	print("Iniciando Fade In...")
	color_rect.color.a = 1.0
	var tween = create_tween()
	tween.tween_property(color_rect, "color:a", 0.0, tempo)
	await tween.finished
	print("Fade In concluído!")

func fade_out(tempo: float = 0.5) -> void:
	print("Iniciando Fade Out...")
	color_rect.color.a = 0.0
	var tween = create_tween()
	tween.tween_property(color_rect, "color:a", 1.0, tempo)
	await tween.finished
	print("Fade Out concluído!")

func mudar_fase_com_fade(caminho_nova_cena: String, tempo: float = 0.5) -> void:
	# Escurece o ecrã
	await fade_out(tempo)
	# Muda de cena enquanto o ecrã está preto
	get_tree().change_scene_to_file(caminho_nova_cena)
	# Clareia o ecrã na nova fase
	await fade_in(tempo)
