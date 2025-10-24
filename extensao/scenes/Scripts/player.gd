extends CharacterBody2D

const speed: float = 300.0
const jump_velocity = -500.0
const dash_speed = 900.0
const dash_duration = 0.2
const gravity = 1200.0


@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var dash_timer: Timer = $DashTimer
@onready var dash_cooldown_timer: Timer = $DashCooldownTimer

var is_attacking: bool = false
var is_dashing: bool = false
var can_dash: bool = true
var dash_vector: Vector2 = Vector2.ZERO

#func _process(delta: float) -> void:
	#if is_on_floor():
		#can_dash = true
		
func _physics_process(delta: float) -> void:
	if not is_on_floor() and not is_dashing:
		velocity.y += gravity * delta
	#if not is_on_floor() and is_dashing:
		#velocity.y += gravity * delta
	#elif is_on_floor() and not is_dashing:
		#velocity.y = 0
		
	handle_input()
	move_and_slide()
	flip()
	animate()
	
func handle_input() -> void:
	if is_dashing:
		velocity = dash_vector * dash_speed
		return
		
	if Input.is_action_just_pressed("attack") and not is_attacking:
		start_attack()	
		
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
		
	var input_direction := Input.get_axis("ui_left", "ui_right")
	velocity.x = input_direction * speed
	
	if Input.is_action_just_pressed("dash") and can_dash and not is_dashing:
		start_dash()
		
func animate() -> void:
	if is_dashing:
		if animation.current_animation != "dash":
			animation.play("dash")
		return
		
	if is_attacking:
		if animation.current_animation != "attack":
			animation.play("attack")
		return	
		
	if not is_on_floor():
		if velocity.y < 0:
			if animation.current_animation != "jump":
				animation.play("jump")
		else:
			if animation.current_animation != "fall":
				animation.play("fall")
		return
		
	if abs(velocity.x) > 10:
		if animation.current_animation != "run":
			animation.play("run")
	else:
		if animation.current_animation != "idle":
			animation.play("idle")
			
func flip() -> void:
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true
		
func start_dash() -> void:
	is_dashing = true
	can_dash = false
	
	var x_dir := Input.get_axis("ui_left", "ui_right")
	
	dash_vector = Vector2(x_dir, 0.0).normalized()
	
	if dash_vector == Vector2.ZERO:
		if sprite.flip_h:
			dash_vector = Vector2.LEFT
		else:
			dash_vector = Vector2.RIGHT
			
	dash_timer.start(dash_duration)
	dash_cooldown_timer.start()
	
func _on_DashTimer_timeout() -> void:
	is_dashing = false
	
func _on_DashCooldownTimer_timeout() -> void:
	can_dash = true
	
func start_attack() -> void: ########
	is_attacking = true
	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		is_attacking= false
