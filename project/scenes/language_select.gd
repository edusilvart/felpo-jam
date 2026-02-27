extends Control


var next_scene : String = "res://scenes/particles_loader.tscn"

func leave() -> void:
	ScenesManager.change_scene(next_scene, self)

func _on_pt_pressed() -> void:
	TranslationServer.set_locale('pt')
	leave()

func _on_en_pressed() -> void:
	TranslationServer.set_locale('en')
	leave()
