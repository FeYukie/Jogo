extends Node
var personagem_selecionado : SpriteFrames 
var genero_jogador: String = "menino"
var nome_jogador: String = "Manoel"
var vidas: int = 3
var vidas_atuais: int = vidas
var fase: int = 1
func perder_vida(motivo: String = "") -> void:
	vidas -= 1
	print("Vida perdida por: ", motivo, ". Vidas restantes: ", vidas)
	
	# Se você tiver sinal para atualizar os corações da tela:
	# emit_signal("vida_alterada", vidas)
	
# Função para redefinir o estado global
func reiniciar_status() -> void:
	vidas_atuais = vidas
	print("vidas: ", vidas_atuais)
