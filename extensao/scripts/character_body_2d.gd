extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -300.0
@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta

	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		animated_sprite.flip_h = direction < 0 #faz a animacao mudar de lado
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	
	
	if is_on_floor(): #adiciona as animacoes
		
		if direction: 
			animated_sprite.play("run")
		else:
			animated_sprite.play("idle")
	else:
		
		animated_sprite.play("jump")

	
	move_and_slide()
