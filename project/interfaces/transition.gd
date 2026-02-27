extends Control

@onready var solid : ColorRect = get_node('ColorRect')

func _ready() -> void:
	solid.color = Color(0, 0, 0, 0)

func enter() -> bool:
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(solid, 'color', Color(0, 0, 0, 1), 0.5)
	await tween.finished
	return true

func leave() -> bool:
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(solid, 'color', Color(0, 0, 0, 0), 0.5)
	await tween.finished
	return true
