extends CharacterBody2D

@export var velocidade_maxima = 100.0
@export var aceleracao = 1500.0
@export var atrito = 1200.0
@export var control_interacao: Control
@onready var animation: AnimationPlayer = $AnimationPlayer
#@onready var sprite: Sprite2D = $Sprite2D
@onready var interface_coracoes = get_tree().get_first_node_in_group("gui_vida")
@onready var anim = $AnimatedSprite2D
var em_cutscene: bool = false

var pode_mover: bool = true
signal vida_alterada(valor_atual)
signal jogador_morreu

var vida_maxima: int = 3
var vida_atual: int = 3
var pode_interagir = false
var npc_proximo = null
var hp: int = 3
var max_hp: int = 3

func _ready():
	anim = get_node_or_null("AnimatedSprite2D") 
	if anim == null:
		for child in get_children():
			if child is AnimatedSprite2D:
				anim = child
				break
	  
	if anim != null and Global.personagem_selecionado != null:
		anim.sprite_frames = Global.personagem_selecionado
	
	add_to_group("player")
	# Reseta as variáveis locais
	self.hp = max_hp
	self.vida_atual = max_hp
	
	if "vidas_atuais" in Global:
		Global.vidas_atuais = max_hp
	
	# 2. Chama a inicialização da interface de forma diferida (após a árvore montar toda a GUI)
	call_deferred("_inicializar_interface_vidas")
	print("iniciou jogo com ", vida_atual)
	
func _process(delta):
	if pode_interagir and Input.is_action_just_pressed("chat"):
		if npc_proximo and not npc_proximo.is_chatting:
			# Esconde o aviso de interação do NPC
			var aviso = npc_proximo.get_node_or_null("Actionable/Control")
			if aviso:
				aviso.hide()

			if control_interacao:
				control_interacao.hide()

			iniciar_dialogo(npc_proximo)
			
func iniciar_dialogo(npc):
	npc.iniciar_dialogo()
	
# Função para que outros scripts identifiquem que este é o jogador
func jogador():
	pass
	

func _physics_process(delta):
	if em_cutscene:
		return
	if atrito == null:
		atrito = 1200.0
	if velocidade_maxima == null: 
		velocidade_maxima = 300.0
	if aceleracao == null: 
		aceleracao = 1500.0
	# Se estiver travado pela cutscene, zera a velocidade e não processa teclas
	if not pode_mover:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	# 1. PEGAR A DIREÇÃO DO INPUT
	# Retorna um Vector2 indicando para onde as teclas apontam
	var direcao = Input.get_vector("esquerda", "direita", "cima", "baixo")
	if anim == null: # Verifica se a referência existe antes de usar
		return
	# 2. APLICAR MOVIMENTO
	if direcao != Vector2.ZERO:
		# Se houver input, acelera em direção à velocidade máxima
		velocity = velocity.move_toward(direcao * velocidade_maxima, aceleracao * delta)
		atualizar_animacao(direcao) # Chama a função de animação
	else:
		# Se não houver input, aplica atrito até parar
		velocity = velocity.move_toward(Vector2.ZERO, atrito * delta)
		anim.stop() # Para a animação quando solta a tecla
		anim.frame = 0 # Opcional: volta para o frame inicial parado
		
	# 4. EXECUTAR O MOVIMENTO
	move_and_slide()

func desviar_do_caminho(vetor_desvio: Vector2) -> void:
	pode_mover = false
	if anim:
		anim.play("direita") # ou a animação correspondente ao desvio
	
	var tween_player = create_tween()
	# Move o jogador suavemente para fora do trajeto
	tween_player.tween_property(self, "global_position", global_position + vetor_desvio, 0.4)
	
	await tween_player.finished
	
	if anim:
		anim.stop()
		anim.frame = 0
	
	pode_mover = true # Devolve o controle imediatamente após o desvio
	
# 3. LÓGICA DE TROCA DE ANIMAÇÃO
func atualizar_animacao(dir: Vector2):
	if dir.y > 0:
		anim.play("frente") # Nome que você deu no SpriteFrames
	elif dir.y < 0:
		anim.play("costas")
	elif dir.x != 0:
		if dir.x < 0:
			anim.play("esquerda")
		else:
			anim.play("direita")
		
func ir():
	anim.play("esquerda")
	var tween = create_tween()

	var pos_descer_1 = self.global_position + Vector2(-60, 40)
	
	tween.tween_property(self, "global_position", pos_descer_1, 1.2)
	
func travar_movimento() -> void:
	pode_mover = false
	velocity = Vector2.ZERO
	if anim:
		anim.stop()
		anim.frame = 0

func liberar_movimento() -> void:
	pode_mover = true
	
# --- SISTEMA DE VIDAS ---
func _inicializar_interface_vidas() -> void:
	
	# Busca o nó da UI dos corações
	interface_coracoes = get_tree().get_first_node_in_group("gui_vida")
	
	if interface_coracoes and interface_coracoes.has_method("update_hp"):
		print("certo")
		# Envia explicitamente o hp resetado (6) e max_hp (6)
		interface_coracoes.update_hp(self.hp, self.max_hp)
	else:
		print("Aviso: Nó do grupo 'gui_vida' ainda não foi encontrado na cena!")

func update_hp(delta: int) -> void:
	# Altera o HP com o valor do delta (ex: -1 para perder vida)
	# PRINT DE DEPURAÇÃO: Descobre quem chamou o update_hp no início
	#print("UPDATE_HP CHAMADO COM DELTA: ", delta, " | HP ANTES: ", hp)
	#print_stack() # Mostra qual script chamou essa linha
	
	hp = clampi(hp + delta, 0, max_hp)
	vida_atual = hp
	if interface_coracoes == null:
		interface_coracoes = get_tree().get_first_node_in_group("gui_vida")
		
	if interface_coracoes and interface_coracoes.has_method("update_hp"):
		interface_coracoes.update_hp(vida_atual, max_hp)
	#Coracoes.update_hp( hp, max_hp ) 
	
# --- FUNÇÕES DE LÓGICA DO JOGO ---
var falhou_na_missao : bool = false

func perder_vida():
	update_hp(-1)
	vida_alterada.emit(vida_atual)

	print("Você perdeu uma vida por sua escolha social. Vidas restantes: ", vida_atual)

	if vida_atual <= 0:
		falhou_na_missao = true

		#get_tree().change_scene_to_file("res://escola/cutscene3_ruim.tscn")

func verificar_final_de_jogo():
	#await get_tree().create_timer(3.0, true).timeout
	if vida_atual<=1:
	#if omissao > 1:
		get_tree().change_scene_to_file("res://escola/cutscene3_ruim.tscn")
	else:
		get_tree().change_scene_to_file("res://escola/cutscene1_bom.tscn")

		# Aqui você chamaria a sua cena de label_morte.tscn que vimos nos arquivos
		#get_tree().change_scene_to_file("res://title_screen/label_morte.tscn")

func morrer():
	update_hp(-1) # Atualiza visualmente os corações
	var aviso = get_tree().get_first_node_in_group("ui_morte")
	if aviso:
		aviso.show()
	# 2. Trava o mundo para dar destaque à mensagem
	get_tree().paused = true
	# 3. Espera 2 segundos 
	await get_tree().create_timer(2.0, true).timeout
	# 4. Destrava e volta para o menu principal
	get_tree().paused = false
	
	get_tree().change_scene_to_file("res://title_screen/title_screen.tscn")
