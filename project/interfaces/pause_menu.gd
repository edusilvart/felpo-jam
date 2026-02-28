extends Control


@onready var resume_button : Button = get_node('%Resume')
@onready var options_button : Button = get_node('%Options')
@onready var options_menu : PanelContainer = get_node('%OptionMenu')

var main_menu : String = "res://scenes/main_menu.tscn"


func _ready() -> void:
	visible = false
	options_menu.exit.connect(options_closed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if visible:
			exit()
		else:
			enter()

func enter() -> void:
	get_tree().paused = true
	visible = true
	resume_button.grab_focus()
	SFX_MANAGER.select()

func exit() -> void:
	get_tree().paused = false
	visible = false

func _on_resume_pressed() -> void:
	SFX_MANAGER.select()
	exit()

func _on_settings_pressed() -> void:
	SFX_MANAGER.select()
	options_menu.visible = true
	options_menu.enter()

func options_closed() -> void:
	resume_button.grab_focus()

func _on_exit_pressed() -> void:
	SFX_MANAGER.cancel()
	exit()
	ScenesManager.change_scene(main_menu, get_parent())
