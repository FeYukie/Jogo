extends Node2D
func sequencia_bullying():
	var vitima = $Personagens/vitima
	
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
	var recuo1 = Vector2(0, 600) # Desce 600 pixels
	var recuo2 = Vector2(10, 600) 
	
	$bully/AnimatedSprite2D.play("frente")
	$bully3/AnimatedSprite2D.play("frente")
	
	# posição atual de CADA BULLY como base
	t3.tween_property($bully, "global_position", $bully.global_position + recuo1, 2.0)
	t4.tween_property($bully3, "global_position", $bully3.global_position + recuo2, 2.0)
	
	await t3.finished
	await t4.finished
	
func andar():
	var vitima2 = $Personagens/vitima
	$Personagens/bully.play("frente")
	$bully3/AnimatedSprite2D.play("frente")
	
	# Posições próximas da vítima
	var ate = vitima2.global_position + Vector2(-10, -30)
	var ate2 = vitima2.global_position + Vector2(10, -30)
	
	$Personagens/bully.ir_para(ate)
	$Personagens/bully3.ir_para(ate2)
	
	
