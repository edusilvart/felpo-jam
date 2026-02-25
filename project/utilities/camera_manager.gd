extends Node3D


@onready var camera = get_node('SpringArm3D/Camera3D')

var target = null
var follow_speed : float = 2
var look_speed : float = 25

var noise = FastNoiseLite.new()
var noise_time : float = 0
var noise_speed : float = 7
var shake : float = 0
var shake_decay : float = 1.7
var max_offset : Vector2 = Vector2(0.4, 0.2)
var max_rotation : float = 0.1

func _ready() -> void:
	Globals.camera = self
	randomize()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.seed = randi()
	noise.frequency = 0.5

func _physics_process(delta: float) -> void:
	if target != null:
		var target_pos : Vector3 = target.global_position + Vector3(0, 0, 0)
		global_position.x = lerp(global_position.x, target_pos.x * 0.8, follow_speed * delta)
		global_position.y = lerp(global_position.y, target_pos.y * 0.4, follow_speed * delta)
		global_position.z = lerp(global_position.z, target_pos.z * 0.2, follow_speed * delta)
		
		camera.look_at(target_pos * 0.8, Vector3.UP)

func _process(delta: float) -> void:
	if shake:
		shake = move_toward(shake, 0, shake_decay * delta)
		camera_shake(delta)

func camera_shake(delta) -> void:
	noise_time += delta * noise_speed
	camera.h_offset = max_offset.x * shake * noise.get_noise_1d(noise_time)
	camera.v_offset = max_offset.y * shake * noise.get_noise_1d(noise_time + 100.0)
