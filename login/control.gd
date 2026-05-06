extends Control # Certifique-se que o nó na cena seja VERDE (Control)

var http # Não usamos @onready aqui para evitar o erro de null

func _ready():
	# Criamos o nó do zero
	http = HTTPRequest.new()
	
	# Colocamos ele dentro da cena
	add_child(http)
	
	# Agora conectamos o sinal. Como ele foi criado acima, 
	# é impossível ele ser 'null' nesta linha.
	http.request_completed.connect(_ao_completar_requisicao)
	
	print("Sistema de rede inicializado com sucesso!")

func _ao_completar_requisicao(result, response_code, headers, body):
	print("A resposta chegou! Código: ", response_code)
