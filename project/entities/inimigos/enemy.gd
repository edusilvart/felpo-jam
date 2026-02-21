class_name Enemy_Class extends Entity


var player_range : bool = false
@export var attack_cooldown : float = 2.0
var attack_cooldown_timer := Timer.new()

func _ready() -> void:
	add_child(attack_cooldown_timer)
	attack_cooldown_timer.wait_time = attack_cooldown
	attack_cooldown_timer.one_shot = true
	state_machine.get_node('Chasing').target = Globals.player
	add_to_group('Enemies')

func _on_vision_body_entered(body: Node3D) -> void:
	if body == Globals.player:
		player_range = true

func _on_vision_body_exited(body: Node3D) -> void:
	if body == Globals.player:
		player_range = false
