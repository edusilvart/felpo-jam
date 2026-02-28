extends PanelContainer


signal done

func leave() -> void:
	$AnimationPlayer.play('End')

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	done.emit()
