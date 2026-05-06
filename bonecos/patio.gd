extends Node2D

func sequencia_bullying():
	var t1 = create_tween()
	var t2 = create_tween()
	var vitima = $vitima
   
	# posição próxima da vítima
	var alvo = vitima.global_position + Vector2(-10, -30) 
	var alvo2 = vitima.global_position + Vector2(10, -30) 
	$bully/AnimatedSprite2D.play("frente")
	$bully3/AnimatedSprite2D.play("frente")
	
	# Cada um vai para um lugar diferente relativo a si mesmo
	t1.tween_property($bully, "position", alvo, 1.5)
	t2.tween_property($bully3, "position", alvo2, 1.5)
	
	await t1.finished
	await t2.finished
	$bully/AnimatedSprite2D.stop()
	$bully3/AnimatedSprite2D.stop()
	$bully/AnimatedSprite2D.frame = 0 # Fica parado no primeiro frame
	$bully3/AnimatedSprite2D.frame = 0 # Fica parado no primeiro frame

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
