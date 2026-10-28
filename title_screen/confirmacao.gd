extends Control

# Sinais para avisar quem chamou quando o usuário confirmar ou cancelar
signal confirmado(acao: String)
signal cancelado

@onready var label_mensagem = $PanelContainer/VBoxContainer/Label
@onready var botao_nao = $PanelContainer/VBoxContainer/HBoxContainer/não

var acao_atual: String = ""

func _ready() -> void:
	visible = false

# Função pública para abrir o pop-up
func pedir_confirmacao(mensagem: String, acao: String) -> void:
	acao_atual = acao
	label_mensagem.text = mensagem
	visible = true
	botao_nao.grab_focus() # Foca no "Não" por segurança

func _on_sim_pressed() -> void:
	visible = false
	emit_signal("confirmado", acao_atual)

func _on_não_pressed() -> void:
	visible = false
	emit_signal("cancelado")
