extends Node


@onready var wave_manager : Node = get_node('WaveManager')
@onready var music_player : AudioStreamPlayer = get_node('%MusicPlayer')
@onready var shop_node : PackedScene = preload("res://interfaces/items/items_selection.tscn")
var shop : Control
var main_menu : String = "res://scenes/main_menu.tscn"
var end_screen : String = "res://scenes/game_over.tscn"

var num_waves : int = 5
var waves_completed : int = 0

var states = [
	'INTRO',
	'BATTLE',
	'SHOP',
	'BOSS',
	'END',
	'WIN',
	'LOSE'
]
var state

func _ready() -> void:
	change_state('INTRO')
	shop = shop_node.instantiate()
	shop.ended.connect(shop_finished)
	add_child(shop)
	
	Globals.wave_manager.wave_ended.connect(wave_ended)
	Globals.kills = 0
	Globals.total_kills = 0
	Globals.boss_duration = 0
	Globals.hits_taken = 0
	Globals.win = false

func change_state(new_state : String) -> void:
	if state != null:
		exit_state()
	state = states.find(new_state)
	enter_state()

func enter_state() -> void:
	match states[state]:
		'INTRO':
			Globals.player.state_machine.set_state('Waiting')
			await Globals.HUD.play_intro()
			change_state('BATTLE')
		'BATTLE':
			wave_manager.wave_start()
			Globals.player.state_machine.set_state('onGround')
			Globals.HUD.aula_label.text = 'Aula 0' + str(waves_completed + 1)
		'SHOP':
			Globals.player.state_machine.set_state('Waiting')
			shop.enter()
		'BOSS':
			Globals.wave_manager.spawn_enemy('kingo', Vector3(0, 0.7, -2.8))
		'END':
			Globals.player.state_machine.set_state('Waiting')
		'WIN':
			Globals.win = true
			ScenesManager.change_scene(end_screen, self)
		'LOSE':
			for enemy in get_tree().get_nodes_in_group('Enemies'):
				enemy.queue_free()
			Globals.win = false
			Globals.total_kills += Globals.kills
			ScenesManager.change_scene(end_screen, self)

func exit_state() -> void:
	match states[state]:
		'INTRO':
			music_player.play()
		'BATTLE':
			pass
		'SHOP':
			pass
		'BOSS':
			pass
		'END':
			pass
		'WIN':
			pass
		'LOSE':
			pass

func shop_finished() -> void:
	if states[state] == 'SHOP':
		change_state('BATTLE')

func wave_ended() -> void:
	waves_completed += 1
	if states[state] == 'BATTLE':
		if waves_completed == num_waves:
			change_state('BOSS')
		else:
			change_state('SHOP')
