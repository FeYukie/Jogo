extends Node2D

@onready var area_escuta = $Area2D
@onready var barreira_colisao: StaticBody2D = $Personagens/StaticBody2D
var dialogo_ja_aconteceu = false
var omissao: int = 0
var bullying: int = 0
var bom: int = 0

# Funções chamadas pelo Dialogue Manager
func adicionar_omissao() -> void:
	omissao += 1

func adicionar_bullying() -> void:
	bullying += 1

func adicionar_bom() -> void:
	bom += 1

func zerar_pontos() -> void:
	omissao = 0
	bullying = 0
	bom = 0
	
const BALAO_CENA = preload("res://personalizado.tscn")
@export var dialogo_recurso: DialogueResource = preload("res://dialogue/dialogue3.dialogue")
@export var dialogo_titulo: String = "start"

func bloquear_passagem() -> void:
	barreira_colisao.process_mode = PROCESS_MODE_INHERIT

func liberar_passagem() -> void:
	barreira_colisao.process_mode = PROCESS_MODE_DISABLED
	
func _ready() -> void:
	# Espera 1 frame para garantir que tudo na tela foi carregado
	await get_tree().process_frame
	liberar_passagem()
	
	#var anim_jogador = $jogador/AnimatedSprite2D
	#anim_jogador.stop()
	#if anim_jogador:
		#anim_jog.play("frente2")
	#	if anim_jogador.sprite_frames.has_animation("frente2"):
	#		anim_jogador.play("frente2")
			

	var balao = BALAO_CENA.instantiate()
	parar()
	get_tree().current_scene.add_child(balao)
	var dialogo: DialogueResource = preload("res://dialogue/procura.dialogue")
	await balao.start(dialogo, "inicio") #[self]
	# Depois da transição, muda de cena
	# get_tree().change_scene_to_file("res://cenas/proxima_cena.tscn")
	await balao.tree_exited
	mover()
	$Personagens/bully/AnimatedSprite2D.play("lado")
	$Personagens/bully3/AnimatedSprite2D.play("lado")
func parar():
	var player = $Personagens/jogador
	if player and player.has_method("travar_movimento"):
		player.travar_movimento()

func mover() -> void:
	var player = $Personagens/jogador
	if player and player.has_method("liberar_movimento"):
		player.liberar_movimento()
	
func sequencia_bullying():
	var vitima = $Personagens/vitima2
	
	# Posições próximas da vítima
	var alvo = vitima.global_position + Vector2(-10, -30)
	var alvo2 = vitima.global_position + Vector2(10, -30)
	
	$Personagens/bully.ir_para(alvo)
	$Personagens/bully3.ir_para(alvo2)
	
	# Espera ambos terminarem de andar
	while $Personagens/bully.andando or $Personagens/bully3.andando:
		await get_tree().physics_frame
		
func bully_sair():
	var t3 = create_tween()
	var t4 = create_tween()
	var recuo1 = Vector2(1000, 0) # Sobe 200 pixels
	var recuo2 = Vector2(1000, 0) 
	
	$Personagens/bully/AnimatedSprite2D.play("direita")
	$Personagens/bully3/AnimatedSprite2D.play("direita")
	
	t3.tween_property($Personagens/bully, "global_position", $Personagens/bully.global_position + recuo1, 6.0)
	t4.tween_property($Personagens/bully3, "global_position", $Personagens/bully3.global_position + recuo2, 6.0)
	
	#await t3.finished
	#await t4.finished
	
func andar():
	var vitima2 = $Personagens/vitima
	$Personagens/bully.play("frente")
	$Personagens/bully3/AnimatedSprite2D.play("frente")
	
	var ate = vitima2.global_position + Vector2(-10, -30)
	var ate2 = vitima2.global_position + Vector2(10, -30)
	
	$Personagens/bully.ir_para(ate)
	$Personagens/bully3.ir_para(ate2)

# Gatilho de Proximidade
func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Algum corpo entrou na Area2D: ", body.name)
	
	if body.name=="jogador" and not dialogo_ja_aconteceu:
		print("Jogador detectado! Iniciando diálogo...")
		dialogo_ja_aconteceu = true
		area_escuta.monitoring = false
		iniciar_conversas_bullying()
	else:
		print("Corpo ignorado (não é do grupo 'jogador' ou diálogo já aconteceu)")

func iniciar_conversas_bullying() -> void:
	var balao_custom = BALAO_CENA.instantiate()
	get_tree().current_scene.add_child(balao_custom)
	
	# Inicia o diálogo usando a variável dialogo_recurso (que é o dialogue3)
	balao_custom.start(dialogo_recurso, dialogo_titulo)
	
	# Espera o balão ser fechado/destruído
	await balao_custom.tree_exited
	
func verificar_final_da_fase() -> void:
	if omissao >= 2:
		get_tree().change_scene_to_file("res://patio/cutscene2_omissao.tscn")
		print("omissao", omissao)
	elif bullying >= 2 and bom==0:
		get_tree().change_scene_to_file("res://patio/cutscene2_bullying.tscn")
		print("ruim", bullying)
	elif bom>=2 and bullying==0:
		get_tree().change_scene_to_file("res://patio/cutscene2_bom.tscn")
		print("bom", bom)
		SaveSystem.desbloquear_fase(3)
	else:
		get_tree().change_scene_to_file("res://patio/cutscene2_incoerente.tscn")
		print("incoerente")

func virar():
	$Personagens/vitima/AnimatedSprite2D.play("default")
	$Personagens/vitima/AnimatedSprite2D.play("triste")
	
func grata():
	$Personagens/vitima/AnimatedSprite2D.play("calma")
	await get_tree().create_timer(3.0, true).timeout
	
func rir():
	#$Personagens/bully/AnimatedSprite2D.play("risada")
	$Personagens/bully3/AnimatedSprite2D.play("risada")
	$Personagens/bully/AnimatedSprite2D.play("risada")
func para():
	$Personagens/bully/AnimatedSprite2D.play("lado")
	$Personagens/bully3/AnimatedSprite2D.play("lado")
func ri():
	#$Personagens/bully/AnimatedSprite2D.play("risada")
	$Personagens/bully3/AnimatedSprite2D.play("ri")

func normal():
	$Personagens/bully/AnimatedSprite2D.play("lado")
	$Personagens/bully3/AnimatedSprite2D.play("lado")
	$Personagens/enoque/AnimatedSprite2D.play("default")
func af():
	#$Personagens/bully/AnimatedSprite2D.play("risada")
	$Personagens/bully3/AnimatedSprite2D.play("ladoAf")
	
func feliz():
	$Personagens/Feliz/npc3.play("feliz")

func sorri():
	$Personagens/enoque/AnimatedSprite2D.play("feliz")
