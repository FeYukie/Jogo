extends Node2D

func _on_botao_masculino_pressed() -> void:
	Global.personagem_selecionado = preload("res://bonecos/anim_menino.tres")
	ir_para_o_jogo()

func _on_botao_feminino_pressed() -> void:
	Global.personagem_selecionado = preload("res://bonecos/anim_menina.tres")
	ir_para_o_jogo()

func ir_para_o_jogo():
	get_tree().change_scene_to_file("res://escola/sala_de_aula.tscn")
