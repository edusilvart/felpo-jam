extends Node



var ENEMY_TYPES := {
	"avião": {
		"scene": preload('res://entities/inimigos/Avião/avião.tscn'),
		"cost": 20
	},
	"bolinha": {
		"scene": preload('res://entities/inimigos/bolinha/bolinha.tscn'),
		"cost": 10
	},
	"caderno": {
		"scene": preload("res://entities/inimigos/caderno/caderno.tscn"),
		"cost": 3
	},
	"basico": {
		"scene": preload("res://entities/inimigos/basico/basico.tscn"),
		"cost": 1
	}
}

var sorted_enemy_types = []
var living_enemies : int = 0
var wave_cost : int = 5

signal wave_ended

func _ready() -> void:
	prepare_enemy_order()
	Globals.wave_manager = self

func wave_start() -> void:
	spawn_wave()

func wave_end() -> void:
	wave_cost *= 2
	wave_ended.emit()

func prepare_enemy_order() -> void:
	sorted_enemy_types = ENEMY_TYPES.keys()
	sorted_enemy_types.sort_custom(func(a: String, b: String) -> bool:
		return ENEMY_TYPES[a]["cost"] > ENEMY_TYPES[b]["cost"]
	)

func spawn_wave() -> void:
	var remaining: int = wave_cost
	
	for enemy_type in sorted_enemy_types:
		var cost: int = ENEMY_TYPES[enemy_type]["cost"]
		
		if cost > remaining:
			continue
		
		@warning_ignore("integer_division")
		var count: int = remaining / cost
		remaining -= count * cost
		
		for i in count:
			spawn_enemy(enemy_type, random_point(4))
		
		if remaining == 0:
			break

func spawn_enemy(enemy_type: String, spawn_point : Vector3) -> void:
	var scene: PackedScene = ENEMY_TYPES[enemy_type]["scene"]
	var enemy: Node3D = scene.instantiate()
	enemy.died.connect(on_enemy_died)
	get_parent().add_child(enemy)
	enemy.global_position = spawn_point
	living_enemies += 1

func random_point(radius: float) -> Vector3: # retorna ponto aleatorio no ciecleuo
	var angle : float = randf() * TAU
	var r : float = radius * sqrt(randf())
	var point2D : Vector2 = Vector2(cos(angle), sin(angle)) * r
	return Vector3(point2D.x, 1, point2D.y)

func on_enemy_died() -> void:
	living_enemies -= 1
	if living_enemies <= 0:
		wave_end()
