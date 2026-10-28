class_name CoracaoGUI extends Control

@onready var sprite: Sprite2D = $Sprite2D

var value: int = 2:
	set(novo_valor):
		#print("\n=== VALUE DO CORAÇÃO ALTERADO ===")
		#print("Nó: ", name)
		#print("Valor anterior: ", value)
		#print("Novo valor: ", novo_valor)
		#print_stack()

		value = novo_valor

		if is_node_ready():
			update_sprite()


func _ready() -> void:
	update_sprite()

func update_sprite() -> void:
	if sprite != null:
		sprite.frame = 2
		sprite.visible = value == 2
		
