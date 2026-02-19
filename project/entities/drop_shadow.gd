extends RayCast3D


@onready var shadow_sprite = get_node('ShadowSprite')
var distance : float = 0
var offset : float = 0.005

func _process(_delta: float) -> void:
	if is_colliding():
		shadow_sprite.visible = true
		shadow_sprite.global_position = get_collision_point() + Vector3(0, offset, 0)
		distance = remap(global_position.distance_to(get_collision_point()), 0, 0.6, 1, 0)
		shadow_sprite.scale = Vector3(distance, distance, 1)
	else:
		shadow_sprite.visible = false
