extends CharacterBody2D

var SPEED = 300.0
var decelaration = 0.1
var acceleration = 0.1

const JUMP_VELOCITY = -350.0
@onready var animated_move_sprite = $MoveSprite
@onready var animated_attack_sprite = $AttackSprite

var is_attacking = false

var is_dashing = false
var DASH_SPEED = 700.0
var DASH_DURATION = 0.2
var dash_time = 0.0

func _physics_process(delta: float) -> void:
	# gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta

	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction: 
		velocity.x = move_toward(velocity.x, direction * SPEED, SPEED * acceleration) #refinando a acao de acelerar
		animated_move_sprite.flip_h = direction < 0 #faz a animacao mudar de lado
		animated_attack_sprite.flip_h = direction < 0 #faz bater pro lado que o personagem esta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * decelaration) #refinando a acao de desacelerar

	
	#iniciando animacoes de movimento
	if not is_attacking:
		if is_on_floor(): #adiciona as animacoes
			if direction: 
				animated_move_sprite.play("run")
			else:
				animated_move_sprite.play("idle")
		else:
			animated_move_sprite.play("jump")
			
	#atacando
	if Input.is_action_just_pressed("attack") and not is_attacking:
		is_attacking = true
		animated_move_sprite.visible = false
		
		animated_attack_sprite.visible = true
		animated_attack_sprite.play("attack")
		
		# força o de movimento a "idle" (ou pode usar stop())
		animated_move_sprite.play("idle")
	
		await animated_attack_sprite.animation_finished
		animated_attack_sprite.visible = false
		is_attacking = false
		animated_move_sprite.visible = true
		

	
	move_and_slide()
