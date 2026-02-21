class_name Item extends Node


var parent : Entity
var passive : bool = false
@export var cooldown : float = 0 # -1 = no cooldown
var cooldown_timer := Timer.new()
var icon : Button
var icon_tex
var item_num : int = 0
var vfx_scene : PackedScene

func _ready() -> void:
	icon = Globals.HUD.items_container.get_child(item_num)
	icon.icon = icon_tex
	icon.disabled = false
	
	add_child(cooldown_timer)
	if cooldown > -1:
		cooldown_timer.wait_time = cooldown
		cooldown_timer.one_shot = true
		cooldown_timer.timeout.connect(reset_cooldown)
		vfx_scene = load("res://vfx/itens/" + name + ".tscn")
	else:
		enter()
		icon.disabled = true

func activate() -> void:
	if cooldown_timer.is_stopped():
		if cooldown > -1:
			cooldown_timer.start()
			var vfx = vfx_scene.instantiate()
			parent.add_child(vfx)
			vfx.start(parent.global_position - Vector3(0, 0, 0.02))
			enter()
		icon.disabled = true

func reset_cooldown():
	icon.disabled = false
	icon.text = ''

func enter() -> void:
	pass

func update(_delta) -> void:
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
