extends Node2D
@onready var anim = $TextureRect/aluna_nova
@onready var vitima = $TextureRect/vitima
@onready var bully = $TextureRect2/bully
@onready var bully3 = $TextureRect2/bully3
@onready var jogador = $TextureRect/jogador
@onready var camera = $Camera2D  
@onready var cenario1 = $TextureRect
@onready var cenario2 = $TextureRect2
@onready var cenario3 = $TextureRect3
@onready var cenario4 = $TextureRect4
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
	anim.play("desconfiada")
	parar()
	$TextureRect/jogador/AnimatedSprite2D.play("culpa")
	await get_tree().create_timer(4, true).timeout
	$TextureRect/bully/AnimatedSprite2D.play("default")
	$TextureRect/bully3/AnimatedSprite2D.play("julga2")
	
	if Transicao.has_method("fade_out"):
		await Transicao.fade_out()
		panel.visible = true
	cenario2.visible = false
	
	await Transicao.fade_in()

	
	# Depois da transição, muda de cena
	# get_tree().change_scene_to_file("res://cenas/proxima_cena.tscn")

	await exibir_mensagem_consequencia()
	exibir_menu_progresso()
	
func camera_aproximar(duracao: float) -> void:
		
	# Tweens simultâneos de Zoom e Offset
	var tween_offset = create_tween()
	tween_offset.tween_property(camera, "offset", Vector2(0, 400), duracao)
	
	var tween_zoom = create_tween()
	tween_zoom.tween_property(camera, "zoom", Vector2(2.5, 2.5), duracao)
	
	# IMPORTANTE: Espera o tween de zoom terminar para a função só retornar quando o tempo acabar!
	await tween_zoom.finished
	
	# Opcional: troca para a animação parado quando o zoom acabar
	#var anim_bully = bully.get_node_or_null("AnimatedSprite2D")
	#if anim_bully:
		#anim_bully.play("parado_frente")
func camera_resetar(duracao: float) -> void:
	# Tweens simultâneos para voltar ao estado original
	var tween_offset = create_tween()
	tween_offset.tween_property(camera, "offset", Vector2.ZERO, duracao)
	
	var tween_zoom = create_tween()
	tween_zoom.tween_property(camera, "zoom", Vector2(1, 1), duracao)
	
	# Espera o tween terminar
	await tween_zoom.finished
	
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
	get_tree().change_scene_to_file("res://escola/sala_de_aula.tscn")


func _on_sair_pressed() -> void:
	get_tree().quit()


func _on_quitmenu_pressed() -> void:
	get_tree().change_scene_to_file("res://title_screen/title_screen.tscn")
