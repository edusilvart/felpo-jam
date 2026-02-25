extends Node


@onready var wave_manager : Node = get_node('WaveManager')
@onready var shop_node : PackedScene = preload("res://interfaces/items/items_selection.tscn")
var shop : Control

var states = [
	'INTRO',
	'BATTLE',
	'SHOP',
	'BOSS',
	'END'
]
var state

func _ready() -> void:
	change_state('INTRO')
	shop = shop_node.instantiate()
	shop.ended.connect(shop_finished)
	add_child(shop)
	
	Globals.wave_manager.wave_ended.connect(wave_ended)

func change_state(new_state : String) -> void:
	if state != null:
		exit_state()
	state = states.find(new_state)
	enter_state()

func enter_state() -> void:
	match states[state]:
		'INTRO':
			pass
			change_state('BOSS')
		'BATTLE':
			wave_manager.wave_start()
			Globals.player.state_machine.set_state('onGround')
		'SHOP':
			Globals.player.state_machine.set_state('Waiting')
			shop.enter()
		'BOSS':
			pass
		'END':
			pass

func exit_state() -> void:
	match states[state]:
		'INTRO':
			pass
		'BATTLE':
			pass
		'SHOP':
			pass
		'BOSS':
			pass
		'END':
			pass

func shop_finished() -> void:
	if states[state] == 'SHOP':
		change_state('BATTLE')

func wave_ended() -> void:
	if states[state] == 'BATTLE':
		change_state('SHOP')
