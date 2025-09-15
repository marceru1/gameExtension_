extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -300.0
@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# 1. Adicionar gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta

	# 2. Lidar com o pulo (apenas muda a velocidade Y)
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# 3. Lidar com o movimento horizontal (apenas muda a velocidade X)
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		animated_sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# 4. Decidir a ANIMAÇÃO (com base na velocidade e estado)
	# Esta é a lógica corrigida:
	if is_on_floor():
		# Se está no chão, pode ser "run" ou "idle"
		if direction: # Ou você pode usar: if velocity.x != 0:
			animated_sprite.play("run")
		else:
			animated_sprite.play("idle")
	else:
		# Se está no ar, é SEMPRE "jump"
		animated_sprite.play("jump")

	# 5. Aplicar o movimento
	move_and_slide()
