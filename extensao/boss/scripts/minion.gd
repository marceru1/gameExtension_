extends CharacterBody2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var player = get_parent().find_child("player")

func _ready():
	set_physics_process(false)
	await animation.animation_finished
	set_physics_process(true)
	animation.play("idle")
	
func _physics_process(delta):
		var direction = player.position - position
		velocity = direction.normalized() * 60
		move_and_slide()
		
func take_damage():
	queue_free()
