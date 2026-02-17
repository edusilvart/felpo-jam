class_name Entity extends CharacterBody3D

@onready var flip_node = get_node('%Flip')
@onready var pivot = get_node('%Pivot')
@onready var state_machine = get_node('%StateMachine')

@export var speed_ratio : float = 1.0
@export var acceleration_ratio : float = 1.0
@export var slow_down_ratio : float = 1.0
@export var jump_force_ratio : float = 1.0
@export var jump_damp_ratio : float = 1.0
@export var weight_ratio : float = 1.0

var speed : float = 2.5 * speed_ratio
var acceleration : float = 20 * acceleration_ratio
var jump_force : float = 6 * jump_force_ratio
var weight : float = 20 * weight_ratio

var looking_right : bool = true
var prev_vel : Vector3

func apply_movement(move_dir : Vector2, new_accel : float, delta: float) -> void:
	velocity.x = move_toward(velocity.x, move_dir.x, new_accel * delta)
	velocity.z = move_toward(velocity.z, move_dir.y, new_accel * delta)
	
	prev_vel = velocity
	
	move_and_slide()

func apply_gravity(delta) -> void:
	velocity.y -= weight * delta

func flip(should_look_right : bool) -> void:
	if should_look_right:
		flip_node.scale.x = 1
		looking_right = true
	else:
		flip_node.scale.x = -1
		looking_right = false

func hit(instigator, heavy_hit : String, damage : int, knockback : Vector2) -> void:
	state_machine.get_node('Hit').instigator = instigator
	state_machine.get_node('Hit').heavy_hit = heavy_hit
	state_machine.get_node('Hit').damage = damage
	state_machine.get_node('Hit').knockback = knockback
