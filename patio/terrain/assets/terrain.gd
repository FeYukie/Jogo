extends Node2D
@onready var barreira_colisao: StaticBody2D = $StaticBody2D
@onready var anim_jog = $Personagens/jogador/AnimatedSprite2D
@onready var confirmacao_popup = $CanvasLayer/Confirmaçao
var omissao: int = 0
var bullying: int = 0
var bom: int = 0
	
const BALAO_CENA = preload("res://personalizado.tscn")
@export var dialogo_recurso: DialogueResource = preload("res://dialogue/dialogue1.dialogue")
@export var dialogo_titulo: String = "start"
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
	
func verificar_final_da_fase() -> void:
	print(bom, bullying, omissao)
	if omissao >= 2:
		get_tree().change_scene_to_file("res://escola/cutscene1_omissao.tscn")
		print("omissao", omissao)
	elif bullying >= 2 and bom==0:
		get_tree().change_scene_to_file("res://escola/cutscene1_bullying.tscn")
		print("ruim", bullying)
	elif bom>=2 and bullying==0:
		get_tree().change_scene_to_file("res://escola/cutscene1_bom.tscn")
		print("bom", bom)
		SaveSystem.desbloquear_fase(2)
	else:
		get_tree().change_scene_to_file("res://escola/cutscene1_incoerente.tscn")
		print("incoerente")
	
		
func bloquear_passagem() -> void:
	barreira_colisao.process_mode = PROCESS_MODE_INHERIT

func liberar_passagem() -> void:
	barreira_colisao.process_mode = PROCESS_MODE_DISABLED

func sequencia_bullying():
	var player = $Personagens/jogador
	var vitima = $Personagens/vitima
	player.get_node("Collision").disabled = true
	# Posições próximas da vítima
	var alvo = vitima.global_position + Vector2(-80, -40)
	var alvo2 = vitima.global_position + Vector2(30, 15)
	
	$Personagens/bully.ir_para(alvo)
	$Personagens/bully3.ir_para(alvo2)
	while is_instance_valid(self) and is_inside_tree() and ($Personagens/bully.andando or $Personagens/bully3.andando):
		var tree = get_tree()
		if not tree:
			return # Interrompe a execução limpadamente se a cena foi reiniciada
		await tree.physics_frame
	
	$Personagens/vitima/AnimatedSprite2D.play("conversa")
	player.get_node("Collision").disabled = false
	liberar_passagem()
	
func _ready() -> void:
	configurar_posicoes_iniciais()
	liberar_passagem()
	
	  # Força a parar qualquer animação salva no .tres
	anim_jog.stop()

	  # Toca explicitamente a animação de início desejada
	anim_jog.play("default") # Ou "frente"
	var balao = BALAO_CENA.instantiate()
	parar()
	get_tree().current_scene.add_child(balao)
	var dialogo: DialogueResource = preload("res://dialogue/orienta.dialogue")
	await balao.start(dialogo, "inicio") #[self]
	# Depois da transição, muda de cena
	# get_tree().change_scene_to_file("res://cenas/proxima_cena.tscn")
	await balao.tree_exited
	mover()
	
func configurar_posicoes_iniciais() -> void:
	if has_node("vitima"):
		$Personagens/vitima/AnimatedSprite2D.play("default")
		$Personagens/vitima/Collision.disabled = true
		
	if has_node("jogador"):
		$Personagens/jogador/AnimatedSprite2D.play("default")
	$Personagens/bully3/AnimatedSprite2D.play("default")
	
func bully_sair() -> void:
	var player = $Personagens/jogador

	# 2. Inicia o trajeto dos bullies normalmente
	$Personagens/bully/AnimatedSprite2D.play("frente")
	$Personagens/bully3/AnimatedSprite2D.play("frente2")
	player.get_node("Collision").disabled = true
	var t_bully = create_tween()
	var t_bully3 = create_tween()

	var pos_descer_1 = $Personagens/bully.global_position + Vector2(0, 40)
	var pos_descer_2 = $Personagens/bully3.global_position + Vector2(0, 40)

	t_bully.tween_property($Personagens/bully, "global_position", pos_descer_1, 1.2)
	t_bully3.tween_property($Personagens/bully3, "global_position", pos_descer_2, 1.2)

	await t_bully.finished

	# Virar e andar para a esquerda
	$Personagens/bully/AnimatedSprite2D.play("esquerda")
	$Personagens/bully3/AnimatedSprite2D.play("esquerda")

	t_bully = create_tween()
	t_bully3 = create_tween()
	
	var pos_esquerda_1 = $Personagens/bully.global_position + Vector2(-370, 0)
	var pos_esquerda_2 = $Personagens/bully3.global_position + Vector2(-350, 0)

	t_bully.tween_property($Personagens/bully, "global_position", pos_esquerda_1, 4)
	t_bully3.tween_property($Personagens/bully3, "global_position", pos_esquerda_2, 4)

	await t_bully.finished
	player.get_node("Collision").disabled = false
	#$Personagens/bully/AnimatedSprite2D.stop()
	#$Personagens/bully3/AnimatedSprite2D.stop()
	$Personagens/bully/AnimatedSprite2D.play("frente")
	$Personagens/bully3/AnimatedSprite2D.play("frente2")
	t_bully = create_tween()
	t_bully3 = create_tween()
	var pos_descer_3 = $Personagens/bully.global_position + Vector2(0, 350)
	var pos_descer_4 = $Personagens/bully3.global_position + Vector2(0, 350)

	t_bully.tween_property($Personagens/bully, "global_position", pos_descer_3, 4)
	t_bully3.tween_property($Personagens/bully3, "global_position", pos_descer_4, 5)

#func colisao():
	#var player = $Personagens/jogador
	#player.get_node("Collision").disabled = false
	
func parar():
	var player = $Personagens/jogador
	if player and player.has_method("travar_movimento"):
		player.travar_movimento()

func mover() -> void:
	var player = $Personagens/jogador
	if player and player.has_method("liberar_movimento"):
		player.liberar_movimento()
	
func seguir():
	var player = $Personagens/jogador
	if player and player.has_method("ir"):
		player.ir()

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
	$Personagens/bully/AnimatedSprite2D.play("default")
	$Personagens/bully3/AnimatedSprite2D.play("default")
func ri():
	#$Personagens/bully/AnimatedSprite2D.play("risada")
	$Personagens/bully3/AnimatedSprite2D.play("ri")

func olhar():
	#$Personagens/bully/AnimatedSprite2D.play("risada")
	$Personagens/bully3/AnimatedSprite2D.play("olhar")
	
func normal():
	#$Personagens/bully/AnimatedSprite2D.play("risada")
	$Personagens/bully3/AnimatedSprite2D.play("lado")
func af():
	#$Personagens/bully/AnimatedSprite2D.play("risada")
	$Personagens/bully3/AnimatedSprite2D.play("af")
	$Personagens/bully/AnimatedSprite2D.play("default")
func ladoAf():
	$Personagens/bully3/AnimatedSprite2D.play("ladoAf")
