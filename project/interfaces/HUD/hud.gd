extends Control


@onready var items_container : HBoxContainer = get_node('%ItemsIcon')
@onready var HP_bar : ProgressBar = get_node('%HP_Bar')
@onready var aula_label : Label = get_node('%Aula_Label')
@onready var timer_label : Label = get_node('%Timer_Label')

func _ready() -> void:
	Globals.HUD = self
