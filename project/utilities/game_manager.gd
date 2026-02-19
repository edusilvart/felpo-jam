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

func change_state(new_state : String) -> void:
	if state != null:
		exit_state()
	state = states.find(new_state)
	enter_state()

func enter_state() -> void:
	match states[state]:
		'INTRO':
			change_state('BATTLE')
		'BATTLE':
			wave_manager.wave_start()
		'SHOP':
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
