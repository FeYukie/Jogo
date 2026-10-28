extends CanvasLayer

var coracoes: Array[CoracaoGUI] = []

func _ready() -> void:
	add_to_group("gui_vida")
	obter_coracoes()
	# Aguarda 1 frame de processo para garantir que o Player já resetou a vida na cena
	#await get_tree().process_frame
	#sincronizar_com_player()

func obter_coracoes() -> void:
	coracoes.clear()
	var container = $Control/HFlowContainer
	for child in container.get_children():
		if child is CoracaoGUI:
			coracoes.append(child)
func sincronizar_com_player() -> void:
	var player = get_tree().get_first_node_in_group("player")

	if player:
		print(
			"SYNC UI | jogador: ", player.name,
			" | vida_atual: ", player.vida_atual,
			" | hp: ", player.hp
		)
		update_hp(player.vida_atual, player.max_hp)
	else:
		print("SYNC UI | nenhum jogador encontrado")

func update_hp(hp_atual: int, hp_maximo: int) -> void:
	#print("\n=== UPDATE_HP DA INTERFACE ===")
	#print("HP recebido: ", hp_atual, "/", hp_maximo)
	#print("Instância da interface: ", get_instance_id())
	#print_stack()

	if coracoes.is_empty():
		obter_coracoes()

	for i in range(coracoes.size()):
		coracoes[i].value = 2 if i < hp_atual else 1

	#print("--- ESTADO VISUAL ---")
	for coracao in coracoes:
		print(
			coracao.name,
			" | value=", coracao.value,
			" | visible=", coracao.sprite.visible
		)
