extends Node2D

func _on_botao_masculino_pressed() -> void:
	Global.personagem_selecionado = preload("res://bonecos/anim_menino.tres")
	ir_para_o_jogo()

func _on_botao_feminino_pressed() -> void:
	Global.personagem_selecionado = preload("res://bonecos/anim_menina.tres")
	ir_para_o_jogo()

func ir_para_o_jogo():
	# Troca para a cena do pátio que já está no seu projeto
	get_tree().change_scene_to_file("res://bonecos/patio.tscn")
