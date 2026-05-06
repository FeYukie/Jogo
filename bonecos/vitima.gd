extends CharacterBody2D

const speed = 30
var is_roaming = true
var is_chatting = false

# Carregue o recurso de diálogo aqui para facilitar o uso
@export var dialogo_recurso: DialogueResource = preload("res://dialogue/dialogue1.dialogue")
@export var dialogo_titulo: String = "start"
@onready var aviso_chat: Label = $AvisoChat # Pega a referência do texto
@onready var bully = $"../Bully"

func iniciar_dialogo():
	if not is_chatting:
		is_chatting = true
		is_roaming = false
		
	# Validação
	if dialogo_recurso == null:
		push_error("Falha ao carregar o Resource de Diálogo. Verifique o caminho do arquivo.")
		return

		# Usa a função do singleton global do Dialogue Manager
	DialogueManager.show_dialogue_balloon(dialogo_recurso, dialogo_titulo, [self, bully])
		
		# Opcional: Conectar sinal para saber quando o diálogo termina
	DialogueManager.dialogue_ended.connect(_ao_terminar_dialogo, CONNECT_ONE_SHOT)

func _ao_terminar_dialogo(_resource):
	is_chatting = false
	is_roaming = true
	
func fazer_bully_andar():
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(400, 300), 1.5)
	$AnimatedSprite2D.play("frente")
	
	# O 'await' faz o Dialogue Manager pausar o texto até o movimento acabar
	await tween.finished
	$AnimatedSprite2D.stop()
	
	# Quando o movimento acabar, ele para de animar
	tween.finished.connect(func(): $Bully/AnimatedSprite2D.stop())
# Sinais da Area2D (Actionable)
func _on_actionable_body_entered(body: Node2D) -> void:
	print("Colidiu com: ", body.name) # Isso vai aparecer no console lá embaixo
	if body.has_method("jogador"):
		body.pode_interagir = true
		body.npc_proximo = self
		print("Jogador detectado!")
		aviso_chat.visible = true

func _on_actionable_body_exited(body: Node2D) -> void:
	if body.has_method("jogador"):
		body.pode_interagir = false
		body.npc_proximo = null
		aviso_chat.visible = false # Esconde o aviso quando o chat começa[cite: 2]
