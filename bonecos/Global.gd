extends Node
var personagem_selecionado : SpriteFrames 
var genero_jogador: String = "menino"
var nome_jogador: String = "Manoel"
var vidas: int = 3
var vidas_atuais: int = vidas
var fase: int = 1
var total_bullying: int = 0
var total_omissao: int = 0
var total_bom: int = 0

func resetar_escolhas() -> void:
	total_bullying = 0
	total_omissao = 0
	total_bom = 0
func formatar_vezes(qtd: int) -> String:
	if qtd == 0:
		return "nenhuma vez"
	elif qtd == 1:
		return "1 vez"
	else:
		return "%d vezes" % qtd
func perder_vida(motivo: String = "") -> void:
	
	vidas -= 1
	print("Vida perdida por: ", motivo, ". Vidas restantes: ", vidas)
	
	# Se você tiver sinal para atualizar os corações da tela:
	# emit_signal("vida_alterada", vidas)
	
# Função para redefinir o estado global
func reiniciar_status() -> void:
	vidas_atuais = vidas
	print("vidas: ", vidas_atuais)
