extends PanelContainer


@onready var points_label : Label = get_node('%Points_Label')
var animated_number : int = 0

signal done

func enter() -> void:
	modulate = Color(1, 1, 1, 0)
	visible = true
	animated_number = 0
	
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD).set_parallel(true)
	tween.tween_property(self, 'modulate', Color(1, 1, 1, 1), 0.2)
	
	points_label.text = '0'
	var target = Globals.kills
	tween.tween_property(self, 'animated_number', target, 1.3)
	await get_tree().create_timer(2.8).timeout
	exit()

func _process(_delta: float) -> void:
	points_label.text = str(animated_number)

func exit() -> void:
	Globals.total_kills += Globals.kills
	Globals.kills = 0
	done.emit()
	visible = false
