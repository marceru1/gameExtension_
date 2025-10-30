extends CharacterBody2D


const SPEED = 700.0
const JUMP_VELOCITY = -400.0

@onready var ParedeD:= $ParedeD as RayCast2D
@onready var sprite = $texture as Sprite2D

var direction := -1

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if direction:
		velocity.x = direction * SPEED * delta;
		
	if ParedeD.is_colliding():
		direction *=-1
		ParedeD.scale.x *= -1
		
	if direction == 1:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
		

	move_and_slide();
