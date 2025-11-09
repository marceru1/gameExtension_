extends State

@export var minion_node : PackedScene
var can_transition:bool = false

func enter():
	super.enter()
	animation_player.play("summon")
	await animation_player.animation_finished
	can_transition = true

func spawn():
	var minion = minion_node.instantiate()
	minion.position = owner.position + Vector2(40,-40)
	get_tree().current_scene.add_child(minion)

func transition():
	if can_transition:
		get_parent().change_state("Follow")
		can_transition = false
