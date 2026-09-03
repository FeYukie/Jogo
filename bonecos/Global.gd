extends Node
var personagem_selecionado : SpriteFrames

var vidas: int = 3

func perder_vida(motivo: String = "") -> void:
	vidas -= 1
	print("Vida perdida por: ", motivo, ". Vidas restantes: ", vidas)
	
	# Se você tiver sinal para atualizar os corações da tela:
	# emit_signal("vida_alterada", vidas)
