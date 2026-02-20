class_name Item extends Node


var parent : Entity
var passive : bool = false
@export var cooldown : float = 0
var cooldown_timer := Timer.new()
var icon : Button
var icon_tex
var icon_scene = preload("res://items/item_button.tscn")

func _ready() -> void:
	add_child(cooldown_timer)
	cooldown_timer.wait_time = cooldown
	cooldown_timer.one_shot = true
	cooldown_timer.timeout.connect(reset_cooldown)
	icon = icon_scene.instantiate()
	Globals.HUD.items_container.add_child(icon)
	icon.icon = icon_tex

func activate() -> void:
	if cooldown_timer.is_stopped():
		cooldown_timer.start()
		icon.disabled = true
		enter()

func reset_cooldown():
	icon.disabled = false

func enter() -> void:
	pass

func update(delta) -> void:
	pass

func exit() -> void:
	pass

func destroy() -> void:
	exit()
	icon.queue_free()
	queue_free()

func _physics_process(delta: float) -> void:
	update(delta)
	if not cooldown_timer.is_stopped():
		icon.text = str(int(cooldown_timer.time_left))
