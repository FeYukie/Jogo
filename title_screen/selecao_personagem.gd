extends Node2D
const CENAS_FASES = {
	1: "res://patio/terrain/assets/patio.tscn",
	2: "res://patio/parque.tscn",
	3: "res://escola/sala_de_aula.tscn"
}

func _on_botao_masculino_pressed() -> void:
	Global.personagem_selecionado = preload("res://bonecos/anim_menino.tres")
	Global.genero_jogador = "menino"
	Global.nome_jogador = "Manoel" 
	ir_para_o_jogo()
	
func _on_botao_feminino_pressed() -> void:
	Global.personagem_selecionado = preload("res://bonecos/anim_menina.tres")
	Global.genero_jogador = "menina"
	Global.nome_jogador = "Manu" 
	ir_para_o_jogo()

func ir_para_o_jogo():
	var fase_alvo = Global.fase
	
	# Pega o caminho correspondente no dicionário (com segurança para a fase 1 se não existir)
	var caminho_cena = CENAS_FASES.get(fase_alvo, CENAS_FASES[1])
		
	get_tree().change_scene_to_file(caminho_cena)
