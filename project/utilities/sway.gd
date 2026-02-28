extends Node


@onready var parent = get_parent()

@export var position : bool = true
@export var rotation : bool = true
@export var delay : float = 0
@export var speed : float = 10
@export var power : float = 1
@export var rot_speed : float = 10
@export var rot_power : float = 1

var start_pos : Vector2
var start_rot : float = 0
var runtime : float = 0

@warning_ignore("unused_signal")
signal done

func _ready() -> void:
	start_pos = parent.position
	start_rot = parent.rotation

func _process(delta: float) -> void:
	runtime += delta
	if parent != null:
		parent.position = get_pos()
		parent.rotation = get_rot()

func get_pos() -> Vector2:
	var final_pos := start_pos
	final_pos.y = start_pos.y + sin(runtime * power) * speed
	
	return final_pos

func get_rot() -> float:
	var final_rot := start_rot
	final_rot = final_rot + sin(runtime * rot_speed) * rot_power
	cos(final_rot)
	
	return final_rot
