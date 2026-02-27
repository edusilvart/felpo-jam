extends Control


@onready var HP_bar = get_node('%ProgressBar')
@onready var flash = get_node('%Flash')

func start() -> void:
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	HP_bar.value = 0
	tween.tween_property(HP_bar, 'value', HP_bar.max_value, 0.6)

func update_hp(new_HP) -> void:
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(HP_bar, 'value', new_HP, 0.2)

func quick_flash() -> void:
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	flash.color = Color(1, 1, 1, 1)
	tween.tween_property(flash, 'color', Color(1, 1, 1, 0), 0.3)
	HP_bar.get_parent().queue_free()

func end() -> void:
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	flash.color = Color(1, 1, 1, 0)
	tween.tween_property(flash, 'color', Color(1, 1, 1, 1), 3)
