extends CharacterBody2D

@export var velocidade_maxima = 300.0
@export var aceleracao = 1500.0
@export var atrito = 1200.0
@export var control_interacao: Control
@onready var animation: AnimationPlayer = $AnimationPlayer
#@onready var sprite: Sprite2D = $Sprite2D
@onready var interface_coracoes = get_tree().get_first_node_in_group("gui_vida")
@onready var anim = $AnimatedSprite2D
signal vida_alterada(valor_atual)
signal jogador_morreu

var vida_maxima: int = 3
var vida_atual: int = 3
var pode_interagir = false
var npc_proximo = null
var hp : int = 6
var max_hp : int = 6

func _ready():
	# Tenta encontrar o nó de várias formas antes de dar erro
	anim = get_node_or_null("AnimatedSprite2D") 
	
	if anim == null:
		# Se não achou pelo nome, tenta procurar em todos os filhos
		for child in get_children():
			if child is AnimatedSprite2D:
				anim = child
				break

	if anim != null:
		if Global.personagem_selecionado != null:
			anim.sprite_frames = Global.personagem_selecionado
	else:
		push_error("O nó AnimatedSprite2D não foi encontrado no Boneco!")
	
	add_to_group("player")
	self.hp = max_hp 
	call_deferred("update_hp", 0)

	#if Global.personagem_selecionado != null:
		#sprite.texture = Global.personagem_selecionado
		
func _process(delta):
	if pode_interagir and Input.is_action_just_pressed("chat"):
		if npc_proximo:
			if control_interacao:
				control_interacao.hide()
			iniciar_dialogo(npc_proximo)

func iniciar_dialogo(npc):
	npc.iniciar_dialogo()
	
# Função para que outros scripts identifiquem que este é o jogador
func jogador():
	pass
	
func _physics_process(delta):
	if atrito == null:
		atrito = 1200.0
	if velocidade_maxima == null: 
		velocidade_maxima = 300.0
	if aceleracao == null: 
		aceleracao = 1500.0
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
	
# 3. LÓGICA DE TROCA DE ANIMAÇÃO
func atualizar_animacao(dir: Vector2):
	if dir.y > 0:
		anim.play("frente") # Nome que você deu no SpriteFrames
	elif dir.y < 0:
		anim.play("costas")
	elif dir.x != 0:
		anim.play("direita")
		# Inverte o sprite horizontalmente se for para a esquerda
		anim.flip_h = (dir.x < 0)
		
# --- SISTEMA DE VIDAS ---

func update_hp( delta : int ) -> void:
	hp = clampi( hp + delta, 0, max_hp)
	if interface_coracoes:
		interface_coracoes.update_hp( hp, max_hp )
	else:
		print("Erro: Interface de corações não encontrada na cena!")
	#Coracoes.update_hp( hp, max_hp ) 
	
# --- FUNÇÕES DE LÓGICA DO JOGO ---
var falhou_na_missao : bool = false
func perder_vida():
	vida_atual -= 1
	vida_alterada.emit(vida_atual) # Avisa a UI para atualizar os corações
	update_hp(-1) # Atualiza visualmente os corações
	print("Você perdeu uma vida por sua escolha social. Vidas restantes: ", vida_atual)
	if vida_atual <= 1:
		falhou_na_missao = true
		print("O jogador cometeu muitos erros, mas vamos concluir a cena.")
		
func verificar_final_de_jogo():
	await get_tree().create_timer(3.0, true).timeout
	get_tree().change_scene_to_file("res://title_screen/title_screen.tscn")

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
