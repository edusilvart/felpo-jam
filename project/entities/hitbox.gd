extends Area3D


@onready var instigator = get_parent()
var heavy_hit : bool
var damage : int
var knockback : Vector3


func _on_area_entered(area: Area3D) -> void:
	print(owner.name + ' hit ' + area.owner.name)
	area.get_parent().hit(get_parent(), heavy_hit, damage, knockback)
