extends Control

@onready var lose : VideoStreamPlayer = get_node('%lose_video')
@onready var win : VideoStreamPlayer = get_node('%win_video')
@onready var points := get_node('Points')

func _ready() -> void:
	if Globals.win:
		win.play()
		await win.finished
		points.enter(true)
	else:
		lose.play()
		await lose.finished
		points.enter(false)
