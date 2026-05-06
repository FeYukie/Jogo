extends HFlowContainer
@onready var sprite_vida = preload("res://title_screen/gui-health.png")

func _ready():
	add_to_group("gui_vida")
	# Pequena pausa para garantir que o Boneco.gd já definiu o HP inicial
	await get_tree().process_frame
	# Busca o jogador para pegar o HP inicial e mostrar os corações cheios
	var player = get_tree().get_first_node_in_group("player")
	if player:
		update_hp(player.hp, player.max_hp)
	# Conecta o sinal do script global a esta interface
	Vida.vida_alterada.connect(_atualizar_coracoes)
	_atualizar_coracoes(Vida.vida_atual)
	# Adiciona o nó ao grupo para o Boneco.gd encontrá-lo via get_first_node_in_group
	
func _atualizar_coracoes(valor):
	# Lógica simples: esconde os corações baseada na vida atual
	var coracoes = get_children()
	for i in range(coracoes.size()):
		# Se o índice for menor que a vida, mostra o coração, senão esconde
		coracoes[i].visible = i < valor

func update_hp(hp_atual: int, max_hp: int):
	var lista_coracoes = get_children()
	for i in range(lista_coracoes.size()):
		var coracao = lista_coracoes[i]
