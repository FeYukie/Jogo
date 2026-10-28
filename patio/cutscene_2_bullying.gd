extends Node2D

@onready var bully = $bully 
@onready var bully3 = $bully3
@onready var vitima = $vitima
@onready var jogador = $jogador
@onready var camera = $Camera2D 
@onready var cenario1 = $janela
@onready var cenario2 = $quarto
# Nós da UI
@onready var panel = $Panel
@onready var ui_consequencia = $CanvasLayer/Mensagem
@onready var label_mensagem = $CanvasLayer/Mensagem/Panel/MarginContainer/Label

@onready var menu_progresso = $CanvasLayer/Menu
@onready var botao_reiniciar = $CanvasLayer/Menu/Panel/Reiniciar
@onready var botao_proxima = $CanvasLayer/Menu/Panel/Prosseguir

# Instanciação direta do balão personalizado
const BALAO_CENA = preload("res://personalizado.tscn")

@export var dialogo_recurso: DialogueResource = preload("res://dialogue/cutscene2_ruim.dialogue")
@export var dialogo_titulo: String = "start"
func triste():
	var anim = $quarto/AnimatedSprite2D
	anim.play("triste")
	
func _ready() -> void:
	# Espera 1 frame para garantir que tudo na tela foi carregado
	await get_tree().process_frame
	# Espera 3 segundos dele a andar antes de começar o zoom da câmera
	await get_tree().create_timer(3, true).timeout
	var balao_custom = BALAO_CENA.instantiate()
	get_tree().current_scene.add_child(balao_custom)
	
	
	if Transicao.has_method("fade_out"):
		await Transicao.fade_out()
	cenario1.visible = false
	cenario2.visible = true
	await Transicao.fade_in()
	# Inicia o diálogo passando os nós de contexto
	var anim = $quarto/AnimatedSprite2D
	anim.play("default")
	await balao_custom.start(dialogo_recurso, dialogo_titulo)
	# Depois da transição, muda de cena
	# get_tree().change_scene_to_file("res://cenas/proxima_cena.tscn")
	await balao_custom.tree_exited
	await get_tree().create_timer(2, true).timeout
	if Transicao.has_method("fade_out"):
		await Transicao.fade_out()
	panel.visible = true
	await Transicao.fade_in()
	
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
	await get_tree().create_timer(7.0).timeout
	

func exibir_menu_progresso() -> void:
	menu_progresso.visible = true


func _on_prosseguir_pressed() -> void:
	#Global.zerar_pontos()
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

func _on_sair_pressed() -> void:
	$AudioStreamPlayer.play()
	get_tree().quit()


func _on_quitmenu_pressed() -> void:
	$AudioStreamPlayer.play()
	get_tree().change_scene_to_file("res://title_screen/title_screen.tscn")
