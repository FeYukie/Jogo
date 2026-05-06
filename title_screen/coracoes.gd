extends CanvasLayer

var coracoes : Array[ CoracaoGUI ] = []
# Called when the node enters the scene tree for the first time.
func _ready():
	coracoes.clear()
	for child in $Control/HFlowContainer.get_children():
		if child is CoracaoGUI:
			coracoes.append( child )
			child.visible = false
	pass # Replace with function body.

func update_hp(hp_atual, hp_maximo):
	var coracoes = get_children() # Pega a lista de corações na tela
	for i in range(coracoes.size()):
		# Se o índice do coração for menor que a vida atual, ele fica visível (cheio)
		coracoes[i].visible = i < hp_atual
		
func update_heart( _index : int, _hp : int ) -> void:
	var _value : int = clampi( _hp - + _index * 2, 0, 2 )
	if _index < coracoes.size():
		coracoes[ _index ].value = _value
	
func update_max_hp( _max_hp: int) -> void:
	var _heart_count : int = roundi( _max_hp * 0.5 )
	for i in coracoes.size():
		if i < _heart_count:
			coracoes[i].visible = true
		else:
			coracoes[i].visible = false
	pass
