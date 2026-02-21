extends Enemy_Class

@onready var basico_scn : PackedScene = preload("res://entities/inimigos/basico/basico.tscn")
@onready var break_vfx : PackedScene = preload('res://vfx/caderno_break.tscn')

func on_hit() -> void:
	if HP <= 4:
		#var enemy = Globals.wave_manager.ENEMY_TYPES['basico']a
		Globals.wave_manager.spawn_enemy('basico', global_position)
		died.emit()
		
		var vfx = break_vfx.instantiate()
		get_parent().add_child(vfx)
		vfx.start(global_position)
		
		queue_free()
