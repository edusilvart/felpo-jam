extends Control


@onready var logos = get_node('%Logos')
var particles_loader : String = "res://scenes/particles_loader.tscn"
var skipped = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('ui_accept') and not skipped:
		skip()

func _ready() -> void:
	logos.visible = false

func play_logos() -> void:
	logos.visible = true
	logos.play('default')

func skip() -> void:
	skipped = true
	ScenesManager.change_scene(particles_loader, self)

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	skip()
