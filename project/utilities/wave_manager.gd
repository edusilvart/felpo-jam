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
	},
	"kingo": {
		"scene": preload('res://entities/inimigos/kingo/kingo.tscn'),
		"cost": 1000
	}
}

var enemies_on_waves = [
	['basico'],
	['basico', 'caderno'],
	['basico', 'caderno', 'avião'],
	['caderno', 'bolinha'],
	['caderno', 'avião', 'bolinha'],
	['basico', 'caderno', 'avião', 'bolinha'] # spawns do BOSS
]

var sorted_enemy_types = []
var living_enemies : int = 0
var wave_cost : int = 1
var max_enemies_per_wave : int = 2 # + number of wave
var num_enemies : int = 0 # num de inimigos q vai spawnar no inicio da wave
var min_enemies_ammount : int = 2 # quando chegar nesse numero de inimigo vai spawnar mais
var wave_duration : float = 30 # duração de cada wave em segundos
var wave_timer := Timer.new()

signal wave_ended

func _ready() -> void:
	Globals.wave_manager = self
	add_child(wave_timer)
	wave_timer.wait_time = wave_duration
	wave_timer.one_shot = true
	wave_timer.timeout.connect(wave_end)

func wave_start() -> void:
	living_enemies = 0
	wave_timer.start()
	
	num_enemies = max_enemies_per_wave + (get_parent().waves_completed + 1)
	for n in num_enemies:
		spawn_enemy(get_enemy(), random_point(3.2))

func get_enemy() -> String:
	var current_wave = get_parent().waves_completed
	var new_enemy : String = enemies_on_waves[current_wave].pick_random()
	return new_enemy

func wave_end() -> void:
	wave_cost *= 2
	wave_ended.emit()
	
	for enemy in get_tree().get_nodes_in_group('Enemies'):
		enemy.queue_free()

func spawn_enemy(enemy_type: String, spawn_point : Vector3) -> void:
	randomize()
	var delay_time = randf_range(0.1, 0.3)
	await get_tree().create_timer(delay_time).timeout
	
	if ['BATTLE', 'BOSS'].has(get_parent().states[get_parent().state]):
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

func _process(_delta: float) -> void:
	Globals.HUD.timer_label.text = str(int(wave_timer.time_left))

func on_enemy_died() -> void:
	living_enemies -= 1
	if living_enemies <= min_enemies_ammount:
		for n in 2:
			spawn_enemy(get_enemy(), random_point(3.2))
