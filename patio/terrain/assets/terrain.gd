extends Node2D
func sequencia_bullying():
	var vitima = $Personagens/vitima
	
	# Posições próximas da vítima
	var alvo = vitima.global_position + Vector2(-10, -30)
	var alvo2 = vitima.global_position + Vector2(30, 10)
	
	$Personagens/bully.ir_para(alvo)
	$Personagens/bully3.ir_para(alvo2)
	
	# Espera ambos terminarem de andar
	while $Personagens/bully.andando or $Personagens/bully3.andando:
		await get_tree().physics_frame
	$Personagens/vitima/AnimatedSprite2D.play("conversa")
	
func _ready() -> void:
	configurar_posicoes_iniciais()

func configurar_posicoes_iniciais() -> void:
	if has_node("vitima"):
		$Personagens/vitima/AnimatedSprite2D.play("default")
		$Personagens/vitima/Collision.disabled = true
func bully_sair():
	$Personagens/bully/AnimatedSprite2D.play("frente")
	$Personagens/bully3/AnimatedSprite2D.play("frente")

	# 2. Cria o Tween para movê-los
	var t3 = create_tween()
	var t4 = create_tween()
	
	var recuo1 = Vector2(120, 400) # desce 5 pixels
	var recuo2 = Vector2(120, 395) 
	
	#tween.tween_property(vitima, "position", pos_lado, 0.6)
	#tween.tween_callback(func():
	$Personagens/bully/AnimatedSprite2D.play("esquerda")
	$Personagens/bully3/AnimatedSprite2D.play("esquerda")
	#)
	# 3. Espera 2 segundos 
	await get_tree().create_timer(2.0, true).timeout
	#var recuo1 = Vector2(10, 5) # desce 5 pixels
	#var recuo2 = Vector2(20, 5) 
	
	#var pos_frente = pos_lado + Vector2(0, 24)
	#tween.tween_property(vitima, "position", pos_frente, 0.7)
	# Calcula a altura exata para ela parar logo abaixo do professor
	#var pos_prof = Vector2(pos_lado.x, prof.position.y)
	
	# O tempo (ex: 2.0 segundos) ajusta a velocidade do trajeto
	#tween.tween_property(vitima, "position", pos_prof, 2.0)
	#var offset_x: float = -28.0 
	
	#tween.tween_callback(func():
		#sprite.play("walk_lado")
		#sprite.flip_h = (offset_x < 0) # ajusta o lado para onde ela anda
	#)
	#var pos_final_lado = prof.position + Vector2(offset_x, 0)
	#tween.tween_property(vitima, "position", pos_final_lado, 0.8)
	
	# posição atual de CADA BULLY como base
	#t3.tween_property($Personagens/bully, "global_position", $Personagens/bully.global_position + recuo1, 2.0)
	#t4.tween_property($Personagens/bully3, "global_position", $Personagens/bully3.global_position + recuo2, 2.0)
	
	#await t3.finished
	#await t4.finished
	
