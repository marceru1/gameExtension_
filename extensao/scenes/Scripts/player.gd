extends CharacterBody2D




## DEFININDO OS VALORES DE MOVIMENTACAO
const speed: float = 300.0
const jump_velocity = -500.0
const dash_speed = 900.0
const dash_duration = 0.2
const gravity = 1200.0

## VALORES PRA FLUIDEZ DE MOVIMENTACAO
@export var acceleration: float = 10.0
@export var desaceleration: float = 12.0

## REFERENCIANDO OS NOS DO LADO
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var dash_timer: Timer = $DashTimer
@onready var dash_cooldown_timer: Timer = $DashCooldownTimer


## CONDICOES
var is_attacking: bool = false
var is_dashing: bool = false
var can_dash: bool = true
var dash_vector: Vector2 = Vector2.ZERO

		
## FUNCAO DA GRAVIDADE, SE NAO TA DASHANDO E NAO TA NO CHAO, TA "CAINDO"
func _physics_process(delta: float) -> void:
	if not is_on_floor() and not is_dashing:
		velocity.y += gravity * delta

		
	handle_input(delta)
	move_and_slide()
	flip()
	animate()
	
## O NOME JA DIZ HANDLE INPUT, EH PRA LIDAR COM AS ENTRADAS DO JOGADOR
func handle_input(delta: float) -> void:
	if is_dashing:
		velocity = dash_vector * dash_speed
		return
		
	if Input.is_action_just_pressed("attack") and not is_attacking:
		start_attack()	
		
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
		
	var input_direction := Input.get_axis("ui_left", "ui_right")
	#velocity.x = input_direction * speed
	
	##logica de aceleracao e desaceleracao pra mais fluidez dosmovimentos
	var target_speed = input_direction * speed
	
	if input_direction != 0:
		velocity.x = lerp(velocity.x, target_speed, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x , 0.0, desaceleration * delta)
	######
	if Input.is_action_just_pressed("dash") and can_dash and not is_dashing:
		start_dash()

## FUNCOES DE ANIMACAO	
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
		
## FUNCAO DE DASH
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
	velocity.x = 0.0 ## AQUI DEFINE QUE DEPOIS DO DASH A VELOCIDADE VAI PRA 0
	## O QUE TIRA AQUELE BUG DE CONTINUAR ANDANDO (ANIMACAO)DEPOIS DO DASH
	
func _on_DashCooldownTimer_timeout() -> void:
	can_dash = true
	
func start_attack() -> void: ########
	is_attacking = true
	## COMECANDO A LOGICA DE DETECCAO DA HITBOX DE ATAQUE
	var overlapping_objects = $attack_area.get_overlapping_areas()
	
	for area in overlapping_objects:
		var parent = area.get_parent()
		print(parent.name)
	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		is_attacking= false
		

		
		
