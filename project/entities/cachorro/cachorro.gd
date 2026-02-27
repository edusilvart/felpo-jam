extends Entity

@onready var spawn_vfx : PackedScene = preload("res://vfx/spawn_explosion.tscn")

var target : CharacterBody3D
var player_range : bool = false # reutilizando states dos inimigos
@export var attack_cooldown : float = 2.0
var attack_cooldown_timer := Timer.new()

func _ready() -> void:
	add_child(attack_cooldown_timer)
	attack_cooldown_timer.wait_time = attack_cooldown
	attack_cooldown_timer.one_shot = true
	poof_vfx()

func poof_vfx() -> void:
	var vfx = spawn_vfx.instantiate()
	get_parent().add_child(vfx)
	vfx.start(global_position)

func assign_target() -> void:
	var enemies = get_tree().get_nodes_in_group('Enemies')
	if enemies.size() > 0:
		enemies.shuffle()
		target = enemies[0]
		player_range = false
		target.died.connect(target_died)
		state_machine.get_node('Chasing').target = target
	else:
		state_machine.set_state('Leave')

func _on_vision_body_entered(body: Node3D) -> void:
	if body == target:
		player_range = true

func _on_vision_body_exited(body: Node3D) -> void:
	if body == target:
		player_range = false

func target_died() -> void:
	target != null
	state_machine.set_state('Leave')
