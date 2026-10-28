extends Control
@export var fase: int = 1
@onready var menu_fases = $Menu_fases
@onready var menu_controles = $Menu_controles
@onready var btn_fase_1 = $Menu_fases/PanelContainer/VBoxContainer4/VBoxContainer/Fase1
@onready var btn_fase_2 = $Menu_fases/PanelContainer/VBoxContainer4/VBoxContainer2/Fase2
@onready var btn_fase_3 = $Menu_fases/PanelContainer/VBoxContainer4/VBoxContainer3/Fase3
const TELA_CONFIG = preload("res://title_screen/Config.tscn")
# Variável para armazenar qual ação o jogador solicitou ("reiniciar", "menu", "sair")
var acao_pendente: String = ""

func _ready():
	atualizar_botoes_fase()

func atualizar_botoes_fase() -> void:
	var max_fase = SaveSystem.fase_maxima_desbloqueada
	# Fase 1 sempre disponível
	btn_fase_1.disabled = false
	# Bloqueia/Desbloqueia os botões das fases seguintes
	btn_fase_2.disabled = (max_fase < 2)
	btn_fase_3.disabled = (max_fase < 3)
	
func _process(_delta):
	pass

# BOTÕES DO MENU
func _on_start_btn_pressed():
	$AudioStreamPlayer.play()
	get_tree().change_scene_to_file("res://title_screen/selecao_personagem.tscn")
	Global.fase = SaveSystem.fase_maxima_desbloqueada
#func _on_start_btn_2_pressed() -> void:
	#pass # Replace with function body.

func _on_start_btn_3_pressed() -> void:
	$AudioStreamPlayer.play()
	get_tree().quit()

func _on_fases_pressed() -> void:
	$AudioStreamPlayer.play()
	#abre o menu com todas as fases
	menu_fases.visible = true

# BOTÕES DE FASES
func _on_fechar_pressed() -> void:
	$AudioStreamPlayer.play()
	menu_fases.visible = false
	menu_controles.visible = false
	
func _on_fase_1_pressed() -> void:
	$AudioStreamPlayer.play()
	carregar_fase()
	Global.fase = 1
func _on_fase_2_pressed() -> void:
	$AudioStreamPlayer.play()
	carregar_fase()
	Global.fase = 2
func _on_fase_3_pressed() -> void:
	$AudioStreamPlayer.play()
	carregar_fase()
	Global.fase = 3
func carregar_fase() -> void:
	get_tree().change_scene_to_file("res://title_screen/selecao_personagem.tscn")

func _on_controles_pressed() -> void:
	$AudioStreamPlayer.play()
	menu_controles.visible = true

func _on_config_pressed() -> void:
	print("clicado")
	$AudioStreamPlayer.play()
	# Instancia a cena de configurações como se fosse um novo nó
	var menu_config = TELA_CONFIG.instantiate()
	# Adiciona a cena de configurações na árvore atual (aparece na tela)
	get_tree().current_scene.add_child(menu_config)
	
	
