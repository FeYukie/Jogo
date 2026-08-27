extends Node2D
func sequencia_bullying():
	var vitima = $vitima
   
	# Posições próximas da vítima
	var alvo = vitima.global_position + Vector2(-10, -30)
	var alvo2 = vitima.global_position + Vector2(10, -30)
	
	# Manda os bullys andarem usando a física interna deles
	$bully.ir_para(alvo)
	$bully3.ir_para(alvo2)
	
	# Espera ambos terminarem de andar
	while $bully.andando or $bully3.andando:
		await get_tree().physics_frame
func bully_sair():
	var t3 = create_tween()
	var t4 = create_tween()
	var recuo1 = Vector2(0, -600) # Sobe 600 pixels
	var recuo2 = Vector2(10, -600) 
	
	$bully/AnimatedSprite2D.play("costas")
	$bully3/AnimatedSprite2D.play("costas")
	
	# IMPORTANTE: Use a posição atual de CADA BULLY como base
	t3.tween_property($bully, "global_position", $bully.global_position + recuo1, 2.0)
	t4.tween_property($bully3, "global_position", $bully3.global_position + recuo2, 2.0)
	
	await t3.finished
	await t4.finished
