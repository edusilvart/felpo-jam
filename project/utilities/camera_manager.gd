extends Node3D


@onready var camera = get_node('SpringArm3D/Camera3D')

var target = null
var follow_speed : float = 2
var look_speed : float = 25

func _ready() -> void:
	Globals.camera = self

func _physics_process(delta: float) -> void:
	if target != null:
		var target_pos = target.global_position + Vector3(0, 1, 0)
		global_position.x = lerp(global_position.x, target_pos.x * 0.8, follow_speed * delta)
		global_position.z = lerp(global_position.z, target_pos.z * 0.2, follow_speed * delta)
		
		camera.look_at(target_pos * 0.8, Vector3.UP)
