extends CanvasLayer
@onready var menu_progresso = $PanelContainer
@onready var TELA_CONFIG = $Config
# Novos Nós do Pop-up de Confirmação
@onready var confirmacao_popup = $Confirmaçao

# Variável para armazenar qual ação o jogador solicitou ("reiniciar", "menu", "sair")
var acao_pendente: String = ""

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS 
	# Garante que o menu comece escondido
	hide()
	
func _process(_delta):
	# Verifica se o jogador apertou o ESC (nossa ação "pausa")
	if Input.is_action_just_pressed("pausa"):
		toggle_pause()

func toggle_pause():
	# Inverte o estado atual (se pausado vira despausado e vice-versa)
	var new_state = !get_tree().paused
	get_tree().paused = new_state
	
	# Se pausou, mostra o menu. Se despausou, esconde.
	visible = new_state
		
func _on_resume_pressed():
	$AudioStreamPlayer.play()
	# Quando clicar no botão Resume, chama a mesma função para despausar
	toggle_pause()

func _on_sair_pressed():
	$AudioStreamPlayer.play()
	confirmacao_popup.pedir_confirmacao(
		"Tem certeza de que deseja sair do jogo?",
		"sair"
	)
	menu_progresso.visible = false

func _on_quitmenu_pressed():
	$AudioStreamPlayer.play()
	confirmacao_popup.pedir_confirmacao(
		"Tem certeza de que deseja voltar ao menu? 
		Seu progresso nesta fase será perdido.",
		"menu"
	)
	menu_progresso.visible = false
		
func _on_config_pressed() -> void:
	$AudioStreamPlayer.play()
	# Instancia a cena de configurações como se fosse um novo nó
	#var menu_config = TELA_CONFIG.instantiate()
	# Adiciona a cena de configurações na árvore atual (aparece na tela)
	#get_tree().current_scene.add_child(menu_config)
	TELA_CONFIG.visible = true

#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_cancel"): # Tecla ESC
		#toggle_pause()

func _on_reiniciar_pressed() -> void:
	$AudioStreamPlayer.play()
	if confirmacao_popup != null:
		confirmacao_popup.pedir_confirmacao(
			"Tem certeza de que deseja reiniciar?", 
			"reiniciar"
		)
		menu_progresso.visible = false
	else:
		print("ERRO: O nó confirmacao_popup não foi encontrado na árvore!")
	
func _on_confirmaçao_confirmado(acao: String) -> void:
	match acao:
		"reiniciar":
			# Garante que o jogo esteja despausado
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
			get_tree().reload_current_scene()

		"menu":
			get_tree().paused = false
			get_tree().change_scene_to_file("res://title_screen/title_screen.tscn")

		"sair":
			get_tree().quit()

func _on_confirmaçao_cancelado() -> void:
	menu_progresso.visible = true
