extends CanvasLayer

var coracoes: Array[CoracaoGUI] = []
var sfx_perder_vida: AudioStreamPlayer
const SOM_DANO = preload("res://perda.wav")
var ultimo_hp: int = -1 # Guarda o HP anterior para detectar perda de vida

func _ready() -> void:
	add_to_group("gui_vida")
	obter_coracoes()
	# Aguarda 1 frame de processo para garantir que o Player já resetou a vida na cena
	#await get_tree().process_frame
	#sincronizar_com_player()
	sfx_perder_vida = AudioStreamPlayer.new()
	sfx_perder_vida.stream = SOM_DANO
	# Se tiver um barramento de efeitos ou quiser usar Master/Ambiente:
	sfx_perder_vida.bus = "Efeitos"
	add_child(sfx_perder_vida)
	
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
	# Se já tínhamos um HP registrado e o atual é menor, o jogador perdeu vida
	if ultimo_hp != -1 and hp_atual < ultimo_hp:
		tremer_coracoes()

		if sfx_perder_vida and sfx_perder_vida.stream:
			sfx_perder_vida.play(0.52)
			print("som de perda")
	ultimo_hp = hp_atual
	for i in range(coracoes.size()):
		coracoes[i].value = 2 if i < hp_atual else 1

	#print("--- ESTADO VISUAL ---")
	for coracao in coracoes:
		print(
			coracao.name,
			" | value=", coracao.value,
			" | visible=", coracao.sprite.visible
		)
func piscar_vermelho(alpha_max: float = 0.28, duracao: float = 0.25) -> void:
	var flash: ColorRect = $FlashDano
	# Garante que começa invisível e vermelho
	flash.color = Color(0.9, 0.15, 0.15, 0.0)
	
	var tween := create_tween()
	# Sobe rápido para vermelho transparente (ex: 28% de opacidade)
	tween.tween_property(flash, "color:a", alpha_max, duracao * 0.3)
	# Volta suavemente para 0 (invisível)
	tween.tween_property(flash, "color:a", 0.0, duracao * 0.7)
	
func tremer_coracoes(intensidade: float = 6.0, duracao: float = 0.25) -> void:
	var alvo := $Control/HFlowContainer
	var pos_original: Vector2 = alvo.position
	var tween := create_tween()
	var passos := 6
	var intervalo := duracao / float(passos)

	for i in range(passos):
		var offset := Vector2(
			randf_range(-intensidade, intensidade),
			randf_range(-intensidade, intensidade)
		)
		tween.tween_property(alvo, "position", pos_original + offset, intervalo)

	tween.tween_property(alvo, "position", pos_original, intervalo)
