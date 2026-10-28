extends Node2D

@onready var jogador = $jogador      
@onready var irma = $AnimatedSprite2D
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
	parar()
	# Espera 1 frame para garantir que tudo na tela foi carregado
	await get_tree().process_frame
	
	var anim_jog = jogador.get_node_or_null("AnimatedSprite2D")
	if anim_jog:
		anim_jog.play("virado")
	irma.play("feliz")
	await get_tree().create_timer(4, true).timeout
	
	if Transicao.has_method("fade_out"):
		await Transicao.fade_out()
	panel.visible = true
	await Transicao.fade_in()
	# Depois da transição, muda de cena
	# get_tree().change_scene_to_file("res://cenas/proxima_cena.tscn")

	await exibir_mensagem_consequencia()
	exibir_menu_progresso()
	
	
	# Opcional: troca para a animação parado quando o zoom acabar
	#var anim_bully = bully.get_node_or_null("AnimatedSprite2D")
	#if anim_bully:
		#anim_bully.play("parado_frente")

	
func exibir_mensagem_consequencia() -> void:
	ui_consequencia.visible = true
	
	# Espera 10 segundos exibindo a mensagem na tela antes de fechar
	await get_tree().create_timer(10.0).timeout
	

func exibir_menu_progresso() -> void:
	menu_progresso.visible = true


func _on_prosseguir_pressed() -> void:
	$AudioStreamPlayer.play()
	#Global.zerar_pontos()
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
	await Transicao.fade_out()
	get_tree().change_scene_to_file("res://escola/sala_de_aula.tscn")
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

	get_tree().change_scene_to_file("res://patio/parque.tscn")



func _on_menu_pressed() -> void:
	$AudioStreamPlayer.play()
	get_tree().change_scene_to_file("res://title_screen/title_screen.tscn")



func _on_sair_pressed() -> void:
	$AudioStreamPlayer.play()
	get_tree().quit()
