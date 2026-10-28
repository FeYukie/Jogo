extends Control

@onready var slider_master = $PanelContainer/VBoxContainer/HBoxVolume/HSliderVolume
@onready var slider_musica = $PanelContainer/VBoxContainer/HBoxMusica/HSliderMusica
@onready var check_box_tela_cheia = $PanelContainer/VBoxContainer/HBoxTela/CheckBox

# Obtém o índice dos canais de áudio da engine
@onready var master_bus = AudioServer.get_bus_index("Efeitos")
@onready var music_bus = AudioServer.get_bus_index("Music") if AudioServer.get_bus_index("Music") != -1 else 0

func _ready() -> void:
	# Atualiza os valores dos sliders com base no volume atual da engine
	slider_master.value = db_to_linear(AudioServer.get_bus_volume_db(master_bus))
	
	if AudioServer.get_bus_index("Music") != -1:
		slider_musica.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus))

	# Verifica se a janela atual está em Tela Cheia
	check_box_tela_cheia.button_pressed = (DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN)

# --- SINAL DO CHECKBOX DE TELA CHEIA ---
func _on_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

# --- BOTÃO VOLTAR ---
func _on_button_pressed() -> void:
	$AudioStreamPlayer.play()
	hide() # Esconde este menu de configurações

# --- SINAIS DOS SLIDERS DE ÁUDIO ---
func _on_h_slider_volume_value_changed(value: float) -> void:
	$AudioStreamPlayer.play()
	# Converte o valor do slider (0.0 a 1.0) para decibéis (dB)
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(value))
	AudioServer.set_bus_mute(master_bus, value == 0)

func _on_h_slider_musica_value_changed(value: float) -> void:
	$AudioStreamPlayer.play()
	if music_bus != -1:
		AudioServer.set_bus_volume_db(music_bus, linear_to_db(value))
		AudioServer.set_bus_mute(music_bus, value == 0)
