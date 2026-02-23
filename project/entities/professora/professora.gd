extends Entity

@onready var steps_sfx = [
	preload("res://entities/professora/sfx/passos/Pedro_Carimbo_Run_v1-2.mp3"),
	preload("res://entities/professora/sfx/passos/Pedro_Carimbo_Run_v1-3.mp3"),
	preload("res://entities/professora/sfx/passos/Pedro_Carimbo_Run_v1-4.mp3"),
	preload("res://entities/professora/sfx/passos/Pedro_Carimbo_Run_v1-5.mp3")
]

var steps_distance : float = 0.2667
var steps_timer := Timer.new()

var uppercut_hold_time : float = 0.2
var uppercut_timer := Timer.new()

func _ready() -> void:
	Globals.player = self
	Globals.camera.target = self
	
	add_child(steps_timer)
	steps_timer.wait_time = steps_distance
	steps_timer.timeout.connect(play_step_sfx)
	steps_timer.one_shot = false
	
	add_child(uppercut_timer)
	uppercut_timer.timeout.connect(uppercut)
	uppercut_timer.wait_time = uppercut_hold_time
	uppercut_timer.one_shot = true

func get_dir_input() -> Vector2:
	var x : float = -Input.get_action_strength('move_left') + Input.get_action_strength('move_right')
	var z : float =  -Input.get_action_strength('move_forward') + Input.get_action_strength('move_backward')
	return Vector2(x, z).normalized()

func play_step_sfx() -> void:
	steps_sfx.shuffle()
	SFX_MANAGER.play_sfx_at(steps_sfx[0], global_position, 0, 1, 1)

func uppercut() -> void:
	if ['onGround', 'Attack01', 'Attack02', 'Attack03'].has(state_machine.state.name):
		state_machine.set_state('Uppercut')
