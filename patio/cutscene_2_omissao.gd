extends Node2D
@onready var anim = $AnimatedSprite2D
@onready var anim2 = $npc1
# Nós da UI
@onready var panel = $Panel
@onready var ui_consequencia = $CanvasLayer/Mensagem
@onready var label_mensagem = $CanvasLayer/Mensagem/Panel/MarginContainer/Label

@onready var menu_progresso = $CanvasLayer/Menu
@onready var botao_reiniciar = $CanvasLayer/Menu/Panel/Reiniciar
@onready var botao_proxima = $CanvasLayer/Menu/Panel/Prosseguir
		
func _ready() -> void:
	await get_tree().create_timer(1, true).timeout
	anim2.play("default")
	anim.play("default")
		
	# Espera 2 segundos dele a andar antes de começar o zoom da câmera
	await get_tree().create_timer(3, true).timeout
	
	if Transicao.has_method("fade_out"):
		await Transicao.fade_out()
	panel.visible = true
	await Transicao.fade_in()
	# Depois da transição, muda de cena
	# get_tree().change_scene_to_file("res://cenas/proxima_cena.tscn")

	await exibir_mensagem_consequencia()
	exibir_menu_progresso()
	
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
	get_tree().change_scene_to_file("res://patio/parque.tscn")


func _on_sair_pressed() -> void:
	$AudioStreamPlayer.play()
	get_tree().quit()


func _on_quitmenu_pressed() -> void:
	$AudioStreamPlayer.play()
	get_tree().change_scene_to_file("res://title_screen/title_screen.tscn")
