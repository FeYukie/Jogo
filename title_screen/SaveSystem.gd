extends Node

const SAVE_PATH = "user://save_data.cfg"

# Guarda qual foi a maior fase desbloqueada (ex: 1, 2, 3...)
var fase_maxima_desbloqueada: int = 1
var ultima_fase_jogada: int = 1
func _ready() -> void:
	carregar_jogo()

# Chama esta função sempre que o jogador concluir uma fase
func desbloquear_fase(fase_numero: int) -> void:
	if fase_numero > fase_maxima_desbloqueada:
		fase_maxima_desbloqueada = fase_numero
		salvar_jogo()

func salvar_jogo() -> void:
	var config = ConfigFile.new()
	config.set_value("Progresso", "fase_maxima", fase_maxima_desbloqueada)
	
	var err = config.save(SAVE_PATH)
	if err == OK:
		print("Progresso salvo com sucesso! Fase máxima: ", fase_maxima_desbloqueada)
	else:
		print("Erro ao salvar progresso: ", err)

func carregar_jogo() -> void:
	var config = ConfigFile.new()
	var err = config.load(SAVE_PATH)
	
	if err == OK:
		fase_maxima_desbloqueada = config.get_value("Progresso", "fase_maxima", 1)
		print("Progresso carregado. Fase máxima desbloqueada: ", fase_maxima_desbloqueada)
	else:
		print("Nenhum save encontrado. Iniciando novo progresso.")
		fase_maxima_desbloqueada = 1
