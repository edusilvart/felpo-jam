extends Node3D


@onready var hitbox = get_node('Hitbox')
@onready var pivot = get_node('Pivot')
var direction : Vector3
var speed : float = 6.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hitbox.instigator = Globals.player
	hitbox.heavy_hit = false
	hitbox.damage = 2
	hitbox.knockback = direction * -10

func shoot(angle_deg) -> void:
	var angle_rad = deg_to_rad(angle_deg)
	direction = Vector3(sin(angle_rad), 0.0, cos(angle_rad)).normalized()
	
	pivot.look_at(global_position + direction, Vector3.UP)

func _process(delta):
	global_position += direction * speed * delta

func _on_hitbox_area_entered(area: Area3D) -> void:
	call_deferred('queue_free')
