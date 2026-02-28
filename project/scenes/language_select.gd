extends Control

@onready var first_button : Button = get_node('%PT')

var next_scene : String = "res://scenes/intro.tscn"
var can_click : bool = true

func _ready() -> void:
	first_button.grab_focus()

func leave() -> void:
	SFX_MANAGER.select()
	ScenesManager.change_scene(next_scene, self)
	can_click = false

func _on_pt_pressed() -> void:
	TranslationServer.set_locale('pt')
	if can_click:
		leave()

func _on_en_pressed() -> void:
	TranslationServer.set_locale('en')
	if can_click:
		leave()
