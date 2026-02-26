extends Area3D


@onready var hit_sfx_01 = preload("res://entities/sfx/hit01.mp3")
@onready var hit_sfx_02 = preload("res://entities/sfx/hit02.mp3")
var soundclips = []
@onready var hit_vfx : PackedScene = preload("res://vfx/hit.tscn")
@onready var hit_heavy_vfx : PackedScene = preload("res://vfx/hit_heavy.tscn")
@onready var instigator = get_parent()
var heavy_hit : bool
var damage : int
var knockback : Vector3

func _ready() -> void:
	soundclips.append(hit_sfx_01)
	soundclips.append(hit_sfx_02)

func _on_area_entered(area: Area3D) -> void:
	area.get_parent().hit(get_parent(), heavy_hit, damage, knockback)
	
	var hit
	if heavy_hit:
		hit = hit_heavy_vfx.instantiate()
	else:
		hit = hit_vfx.instantiate()
	
	owner.get_parent().add_child(hit)
	hit.start(area.get_parent().global_position - Vector3(0, 0, 0.1))
	
	var sfx = soundclips.pick_random()
	SFX_MANAGER.play_sfx_at(sfx, global_position, 0, 0.9, 1.1)
