extends CharacterBody2D

var SPEED = 300.0
var decelaration = 0.1
var acceleration = 0.1
const JUMP_VELOCITY = -350.0

@onready var animated_move_sprite = $MoveSprite
@onready var animated_attack_sprite = $AttackSprite
@onready var animated_dash_sprite = $DashSprite

var is_attacking = false
var is_dashing = false
var DASH_SPEED = 600.0
var DASH_DURATION = 0.1
var dash_time = 0.0
var dash_direction = 0.0  # Armazena a direção do dash
var can_dash = true

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# comeco dash
	if Input.is_action_just_pressed("dash") and can_dash and not is_attacking:
		var direction = Input.get_axis("ui_left", "ui_right")
		
		# usa a direção que ta vendo
		if direction == 0:
			direction = -1 if animated_move_sprite.flip_h else 1
		
		is_dashing = true
		can_dash = false
		dash_direction = direction 
		
		$dash_again_timer.start()
		animated_move_sprite.visible = false
		animated_dash_sprite.visible = true
		animated_dash_sprite.flip_h = direction < 0
		animated_dash_sprite.play("dash")
		
		# Aguarda a animação terminar para finalizar o dash
		await animated_dash_sprite.animation_finished
		
		is_dashing = false
		animated_dash_sprite.visible = false
		animated_move_sprite.visible = true
	
	# dashando
	if is_dashing:
		velocity.x = dash_direction * DASH_SPEED
	else:
	
		var direction := Input.get_axis("ui_left", "ui_right")
		
		if direction:
			velocity.x = move_toward(velocity.x, direction * SPEED, SPEED * acceleration)
			animated_move_sprite.flip_h = direction < 0
			animated_attack_sprite.flip_h = direction < 0
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED * decelaration)
	
	# nem batendo nem dashando
	if not is_attacking and not is_dashing:
		if is_on_floor():
			var direction = Input.get_axis("ui_left", "ui_right")
			if direction:
				animated_move_sprite.play("run")
			else:
				animated_move_sprite.play("idle")
		else:
			animated_move_sprite.play("jump")
	
	# Ataque
	if Input.is_action_just_pressed("attack") and not is_attacking and not is_dashing:
		is_attacking = true
		animated_move_sprite.visible = false
		animated_attack_sprite.visible = true
		animated_attack_sprite.play("attack")
		animated_move_sprite.play("idle")
		
		await animated_attack_sprite.animation_finished
		
		animated_attack_sprite.visible = false
		is_attacking = false
		animated_move_sprite.visible = true
	
	move_and_slide()

func _on_dash_again_timer_timeout() -> void:
	can_dash = true
