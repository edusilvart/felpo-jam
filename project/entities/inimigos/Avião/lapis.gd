extends Node3D


var speed : float = 0.9
var direction : Vector3 = Vector3(0, -1, 0)

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func _on_hitbox_area_entered(_area: Area3D) -> void:
	call_deferred('queue_free')

func _on_hurtbox_body_entered(_body: Node3D) -> void:
	call_deferred('queue_free')

func hit(_instigator, _heavy_hit, _damage, _knockback) -> void:
	call_deferred('queue_free')
