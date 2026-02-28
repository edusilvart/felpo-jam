extends Control


@onready var press_key = get_node('%PressAnyKey')
@onready var menu = get_node('%Menu')
@onready var options = get_node('%Options')
@onready var credits = get_node('%Credits')

@export var first_button : Button

var game_scn : String = "res://scenes/Game.tscn"

var menu_pos : Vector2
var waiting : bool = false

func _ready() -> void:
	menu_pos = menu.position
	options.exit.connect(show_menu)
	credits.exit.connect(show_menu)
	menu.visible = false
	waiting = true

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and waiting:
		key_pressed()
	elif event is InputEventJoypadButton and event.pressed and waiting:
		key_pressed()

func key_pressed() -> void:
	SFX_MANAGER.select()
	waiting = false
	press_key.leave()
	await press_key.done
	press_key.queue_free()
	show_menu()

func hide_menu() -> void:
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel(true)
	#tween.tween_property(menu, 'position', menu_pos + Vector2(0, 200), 0.4)
	tween.tween_property(menu, 'modulate', Color(1, 1, 1, 0), 0.4)
	await tween.finished
	menu.visible = false

func show_menu() -> void:
	first_button.grab_focus()
	menu.visible = true
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel(true)
	#tween.tween_property(menu, 'position', menu_pos, 0.4)
	tween.tween_property(menu, 'modulate', Color(1, 1, 1, 1), 0.4)
	await tween.finished

func _on_play_pressed() -> void:
	SFX_MANAGER.select()
	ScenesManager.change_scene(game_scn, self)
	menu.visible = false 

func _on_options_pressed() -> void:
	hide_menu()
	options.enter()
	SFX_MANAGER.select()

func _on_credits_pressed() -> void:
	SFX_MANAGER.select()
	hide_menu()
	credits.enter()

func _on_exit_pressed() -> void:
	SFX_MANAGER.cancel()
	get_tree().quit()
