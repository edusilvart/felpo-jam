extends Control


@onready var items_container : HBoxContainer = get_node('%ItemsIcon')
@onready var HP_Bar : ProgressBar = get_node('%HP_Bar')

func _ready() -> void:
	Globals.HUD = self
