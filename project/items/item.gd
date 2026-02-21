class_name Item extends Node


var parent : Entity
var passive : bool = false
@export var cooldown : float = 0
var cooldown_timer := Timer.new()
var icon : Button
var icon_tex
var item_num : int = 0

func _ready() -> void:
	add_child(cooldown_timer)
	cooldown_timer.wait_time = cooldown
	cooldown_timer.one_shot = true
	cooldown_timer.timeout.connect(reset_cooldown)
	icon = Globals.HUD.items_container.get_child(item_num)
	icon.icon = icon_tex
	icon.disabled = false

func activate() -> void:
	if cooldown_timer.is_stopped():
		cooldown_timer.start()
		icon.disabled = true
		enter()

func reset_cooldown():
	icon.disabled = false
	icon.text = ''

func enter() -> void:
	pass

func update(delta) -> void:
	pass

func exit() -> void:
	pass

func destroy() -> void:
	exit()
	cooldown_timer.stop()
	parent.set('item0' + str(item_num + 1), null)
	icon.icon = null
	icon.text = ''
	icon.disabled = true
	queue_free()

func _physics_process(delta: float) -> void:
	update(delta)
	if not cooldown_timer.is_stopped():
		icon.text = str(int(cooldown_timer.time_left))
