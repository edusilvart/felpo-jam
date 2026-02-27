extends Entity




@onready var HUD_scn = preload("res://interfaces/HUD/kingo_hud.tscn")
var HUD
@onready var paper_trail : GPUParticles3D = get_node('PaperTrail')
@onready var drop_shadow : RayCast3D = get_node('DropShadow')

var player_range : bool = false
var attack_cooldown : float = 3
var jump_cooldown : float = 8
var shout_cooldown : float = 10
var shoot_cooldown : float = 8
var attack_timer := Timer.new()
var jump_timer := Timer.new()
var shout_timer := Timer.new()
var shoot_timer := Timer.new()

func _ready() -> void:
	state_machine.set_state('Intro')
	add_child(attack_timer)
	attack_timer.wait_time = attack_cooldown
	attack_timer.one_shot = true
	
	add_child(jump_timer)
	jump_timer.wait_time = jump_cooldown
	jump_timer.one_shot = true
	
	add_child(shout_timer)
	shout_timer.wait_time = shout_cooldown
	shout_timer.one_shot = true
	
	add_child(shoot_timer)
	shoot_timer.wait_time = shoot_cooldown
	shoot_timer.one_shot = true
	
	HUD = HUD_scn.instantiate()
	get_parent().add_child(HUD)
	HUD.HP_bar.max_value = max_HP
	HUD.start()

func hit(_instigator, heavy_hit : bool, damage : int, knockback : Vector3) -> void:
	HP -= damage
	HUD.update_hp(HP)
	if HP <= 0:
		state_machine.set_state('Death')
	
	if heavy_hit:
		Globals.camera.shake = 0.2
	else:
		Globals.camera.shake = 0.07
	
	if Globals.player.global_position.x < global_position.x:
		knockback.x *= -1
	velocity += knockback * 0.4

func _on_vision_body_entered(body: Node3D) -> void:
	if body == Globals.player:
		player_range = true

func _on_vision_body_exited(body: Node3D) -> void:
	if body == Globals.player:
		player_range = false
