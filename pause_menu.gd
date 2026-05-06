extends Control

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS 
	# Garante que o menu comece escondido
	hide()

func _process(_delta):
	# Verifica se o jogador apertou o ESC (nossa ação "pausa")
	if Input.is_action_just_pressed("pausa"):
		toggle_pause()

func toggle_pause():
	# Inverte o estado atual (se pausado vira despausado e vice-versa)
	var new_state = !get_tree().paused
	get_tree().paused = new_state
	
	# Se pausou, mostra o menu. Se despausou, esconde.
	visible = new_state

func _on_resume_pressed():
	# Quando clicar no botão Resume, chama a mesma função para despausar
	toggle_pause()


func _on_sair_pressed():
	get_tree().quit()


func _on_quitmenu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://title_screen/title_screen.tscn")


func _on_config_pressed() -> void:
	pass # Replace with function body.
