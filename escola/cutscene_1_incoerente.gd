extends Node2D

@onready var bully = $bully 
@onready var bully3 = $bully3
@onready var vitima = $vitima
@onready var jogador = $jogador
@onready var camera = $Camera2D         
# Nós da UI
@onready var panel = $Panel
@onready var ui_consequencia = $CanvasLayer/Mensagem
@onready var label_mensagem = $CanvasLayer/Mensagem/Panel/MarginContainer/Label

@onready var menu_progresso = $CanvasLayer/Menu
@onready var botao_reiniciar = $CanvasLayer/Menu/Panel/Reiniciar
@onready var botao_proxima = $CanvasLayer/Menu/Panel/Prosseguir
	
func parar():
	if jogador and jogador.has_method("travar_movimento"):
		jogador.travar_movimento()
		
func _ready() -> void:
	# Espera 1 frame para garantir que tudo na tela foi carregado
	await get_tree().process_frame
	var anim_vit = vitima.get_node_or_null("AnimatedSprite2D")
	if anim_vit:
		anim_vit.play("confusa")
	var anim_jog = jogador.get_node_or_null("AnimatedSprite2D")
	if anim_jog:
		anim_jog.play("virado")
	parar()
	# 1. Faz o Bully começar a andar para a frente
	var anim_bully1 = bully.get_node_or_null("AnimatedSprite2D")
	var anim_bully2 = bully3.get_node_or_null("AnimatedSprite2D")
	if anim_bully1:
		anim_bully1.play("frente")
	if anim_bully2:
		anim_bully2.play("julga")
	# 2. Move o Bully um pouco
	var posicao_alvo = bully.global_position + Vector2(0, 100)
	var posicao_alvo2 = bully3.global_position + Vector2(0, 100)
	var tween_movimento = create_tween()
	var tween_mov = create_tween()
	var tween_mov2 = create_tween()
	
	tween_mov.tween_property(bully, "global_position", posicao_alvo, 3)
	tween_mov2.tween_property(bully3, "global_position", posicao_alvo2, 3)
	# Espera 2 segundos dele a andar antes de começar o zoom da câmera
	await get_tree().create_timer(1, true).timeout
	
	# 3. CHAMA A CUTSCENE DO ZOOM E USA O 'await' PARA ESPERAR ELA TERMINAR COMPLETAMENTE (7 segundos)
	await cutscene_bully_aproximar(3)
	
	# 4. SÓ AGORA (quando o zoom de 7s acabar), a transição global é chamada!
	if Transicao.has_method("fade_out"):
		await Transicao.fade_out()
	panel.visible = true
	await Transicao.fade_in()
	# Depois da transição, muda de cena
	# get_tree().change_scene_to_file("res://cenas/proxima_cena.tscn")

	await exibir_mensagem_consequencia()
	exibir_menu_progresso()
	
func cutscene_bully_aproximar(duracao: float) -> void:
	if not bully or not camera:
		return
		
	# Tweens simultâneos de Zoom e Offset
	var tween_offset = create_tween()
	tween_offset.tween_property(camera, "offset", Vector2(0, 380), duracao)
	
	var tween_zoom = create_tween()
	tween_zoom.tween_property(camera, "zoom", Vector2(2.5, 2.5), duracao)
	
	# IMPORTANTE: Espera o tween de zoom terminar para a função só retornar quando o tempo acabar!
	await tween_zoom.finished
	
	# Opcional: troca para a animação parado quando o zoom acabar
	#var anim_bully = bully.get_node_or_null("AnimatedSprite2D")
	#if anim_bully:
		#anim_bully.play("parado_frente")

	
func exibir_mensagem_consequencia() -> void:
	ui_consequencia.visible = true
	
	# Espera 6 segundos exibindo a mensagem na tela antes de fechar
	await get_tree().create_timer(8.0).timeout
	

func exibir_menu_progresso() -> void:
	menu_progresso.visible = true


func _on_prosseguir_pressed() -> void:
	#Global.zerar_pontos()
	await Transicao.fade_out()
	get_tree().change_scene_to_file("res://patio/parque.tscn")
	await Transicao.fade_in()


func _on_reiniciar_pressed() -> void:
	$AudioStreamPlayer.play()
	#Global.zerar_pontos() # Reseta o contador
	Engine.time_scale = 1.0
	get_tree().paused = false

			# Esconde o menu de pausa
	hide()
			# Reseta o estado do Autoload Vida
	Vida.hp = Vida.max_hp
	Vida.vida_atual = Vida.max_hp
	Vida.falhou_na_missao = false

	# Reseta as variáveis globais
	Global.vidas = 3
	Global.vidas_atuais = 3

	await get_tree().process_frame
	Engine.time_scale = 1.0
	#zerar_pontos()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://patio/terrain/assets/patio.tscn")

func _on_sair_pressed() -> void:
	$AudioStreamPlayer.play()
	get_tree().quit()


func _on_quitmenu_pressed() -> void:
	$AudioStreamPlayer.play()
	get_tree().change_scene_to_file("res://title_screen/title_screen.tscn")
