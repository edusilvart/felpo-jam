extends Entity



func _ready() -> void:
	Globals.player = self
	Globals.camera.target = self

func get_dir_input() -> Vector2:
	var x : float = -Input.get_action_strength('move_left') + Input.get_action_strength('move_right')
	var z : float =  -Input.get_action_strength('move_forward') + Input.get_action_strength('move_backward')
	return Vector2(x, z).normalized()
