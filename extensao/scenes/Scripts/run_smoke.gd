extends AnimatedSprite2D
func _ready():
	# Conecta o sinal "animation_finished" (disparado quando a animacao termina)
	# a uma funcao que ira destruir o no.
	self.animation_finished.connect(_on_animation_finished)

	# Toca a animacao "puff" imediatamente.
	# Se sua animacao ainda se chama "default", use "default" aqui.
	self.play("puff") 

func _on_animation_finished():
	# Quando a animacao de 8 frames acabar, destroi este no de fumaca.
	queue_free()
