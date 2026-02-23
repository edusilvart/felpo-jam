extends Area3D


@onready var hit_fx : PackedScene = preload("res://vfx/hit.tscn")
@onready var hit_heavy_fx : PackedScene = preload("res://vfx/hit_heavy.tscn")
@onready var instigator = get_parent()
var heavy_hit : bool
var damage : int
var knockback : Vector3


func _on_area_entered(area: Area3D) -> void:
	area.get_parent().hit(get_parent(), heavy_hit, damage, knockback)
	
	var hit
	if heavy_hit:
		hit = hit_heavy_fx.instantiate()
	else:
		hit = hit_fx.instantiate()
	
	owner.get_parent().add_child(hit)
	hit.start(area.get_parent().global_position - Vector3(0, 0, 0.05))
