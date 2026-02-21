extends Node3D


@onready var hitbox = get_node('Hitbox')
var speed : float = 1.0
var enemies = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hitbox.instigator = Globals.player
	hitbox.heavy_hit = false
	hitbox.damage = 1
	hitbox.knockback = Vector3.ZERO

func start(pos : Vector3):
	reparent(get_parent().get_parent())

func _physics_process(delta: float) -> void:
	if enemies.size() > 0:
		for hit_enemy in enemies:
			if hit_enemy != null:
				hit_enemy.global_position = lerp(hit_enemy.global_position, global_position, 20 * delta)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == 'Intro':
		$AnimationPlayer.play('Activate')
	if anim_name == 'Activate':
		queue_free()

func _on_hitbox_area_entered(area: Area3D) -> void:
	enemies.append(area.get_parent())
