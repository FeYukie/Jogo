extends Label

func _input(event):
	# Verifica se a tecla 'C' foi pressionada
	if Input.is_action_just_pressed("chat"):
		hide() # Esconde a label
