extends CanvasLayer # Certifique-se que o nó PauseMenu é um CanvasLayer

func _ready():
	# Remova ou comente o hide() para o botão aparecer no teste
	show() 
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_dano_pressed() -> void:
	print("Botão de dano clicado!")
	# Busca o nó do player (seu CharacterBody2D) pelo grupo
	var player = get_tree().get_first_node_in_group("player")
	
	if player:
		player.perder_vida() # Chama a função de dano que você criou
	else:
		print("Erro: Player não encontrado. Verifique se add_to_group('player') está no _ready do player.")
