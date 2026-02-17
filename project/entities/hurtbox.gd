extends Area3D


func _on_area_entered(area: Area3D) -> void:
	get_parent().hit(area.get_parent(), area.heavy_hit, area.damage, area.knockback)
