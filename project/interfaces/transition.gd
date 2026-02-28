extends Control

@onready var solid : ColorRect = get_node('ColorRect')
@onready var anim_player : AnimationPlayer = get_node('AnimationPlayer')

func _ready() -> void:
	solid.color = Color(0, 0, 0, 0)

func enter() -> bool:
	solid.color = Color(0, 0, 0, 1)
	anim_player.play('enter')
	await anim_player.animation_finished
	return true

func leave() -> bool:
	solid.color = Color(0, 0, 0, 1)
	anim_player.play('leave')
	await anim_player.animation_finished
	return true
