extends CharacterBody2D

const speed = 70
var is_roaming = true
var is_chatting = false
var alvo: Vector2
var andando := false

# Cena do balão customizado
const BALAO_CENA = preload("res://personalizado.tscn")

# Recursos de diálogo
@export var dialogo_recurso: DialogueResource = preload("res://dialogue/dialogue1.dialogue")
@export var dialogo_titulo: String = "start"

@onready var aviso_chat: Label = $AvisoChat
@onready var bully = $"../Bully"

func iniciar_dialogo():
	var balao = BALAO_CENA.instantiate()
	get_tree().current_scene.add_child(balao)
	balao.start(dialogo_recurso, dialogo_titulo)
	
func _ao_terminar_dialogo(_resource):
	is_chatting = false
	is_roaming = true

func ir_para(posicao: Vector2):
	alvo = posicao
	andando = true
	$AnimatedSprite2D.play("frente")

func _physics_process(_delta):
	if not andando:
		velocity = Vector2.ZERO
		return

	var direcao = global_position.direction_to(alvo)
	velocity = direcao * speed
	
	move_and_slide()

	if global_position.distance_to(alvo) < 5 or (get_slide_collision_count() > 0 and velocity.length() < 1):
		global_position = alvo if global_position.distance_to(alvo) < 5 else global_position
		velocity = Vector2.ZERO
		andando = false
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.frame = 0

func fazer_bully_andar():
	ir_para(Vector2(400, 300))
	while andando:
		await get_tree().process_frame
	$AnimatedSprite2D.stop()

func _on_actionable_body_entered(body: Node2D) -> void:
	if body.has_method("jogador"):
		body.pode_interagir = true
		body.npc_proximo = self
		if aviso_chat:
			aviso_chat.visible = true

func _on_actionable_body_exited(body: Node2D) -> void:
	if body.has_method("jogador"):
		body.pode_interagir = false
		body.npc_proximo = null
		if aviso_chat:
			aviso_chat.visible = false
